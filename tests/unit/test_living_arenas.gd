extends GutTest
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")

func after_each() -> void:
	get_tree().paused = false
	RunState.reset_run()

func test_all_arena_profiles_and_original_pixels_survive_toggle() -> void:
	var hashes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/living_arenas/source_hashes.json"))
	hashes.merge(JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/living_arenas_v2/source_hashes.json")))
	hashes.merge(JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/living_arenas_v3/source_hashes.json")))
	assert_eq(hashes.size(), 16)
	for path: String in hashes:
		var source_path := "res://"+path
		var digest := FileAccess.get_sha256(source_path)
		if path.ends_with(".b64"):
			# Git's Windows checkout converts text containers to CRLF.
			digest = FileAccess.get_file_as_string(source_path).replace("\r\n", "\n").sha256_text()
		assert_eq(digest,hashes[path],"Approved arena source is immutable: "+path)
	var node := BACKDROP.new()
	add_child_autofree(node)
	for id in BACKDROP.ARENA_PATHS:
		node.set_arena_id(id)
		assert_eq(node.material != null, PROFILE.supports(id), id)
		var bytes := node.texture.get_image().get_data()
		var original_texture := node.texture
		node.set_living_enabled(false)
		assert_null(node.material)
		node.set_living_enabled(true)
		assert_eq(node.texture, original_texture)
		assert_true(node.texture.get_image().get_data()==bytes,"Original source pixels retained")
	node.set_arena_id("ossuary", "ossuary_gate")
	assert_eq(node.living_profile_id, "ossuary_gate")
	assert_not_null(node.material)
	var ossuary: Texture2D = node.texture
	var gate_mask := PROFILE.mask_for("ossuary_gate")
	node.set_arena_id("ossuary", "death_wager")
	assert_eq(node.living_profile_id, "ossuary")
	assert_not_null(node.material)
	assert_ne(PROFILE.mask_for("ossuary"), gate_mask)
	assert_same(node.texture, ossuary, "Death Wager and Gate retain the same painting")
	assert_eq(PROFILE.masks.size(), PROFILE.ALL_PROFILES.size())

func test_released_court_plate_and_legacy_comparison_remain_distinct() -> void:
	var node := BACKDROP.new()
	add_child_autofree(node)
	node.set_arena_id("court_of_the_mute", "court_of_the_mute")
	var released := node.texture
	assert_not_null(node.material)
	node.set_court_qa_legacy_art(true)
	assert_ne(node.texture, released)
	assert_null(node.material, "The released painting's mask is not applied to the legacy image")
	node.set_court_qa_legacy_art(false)
	assert_same(node.texture, released)
	assert_not_null(node.material)

func test_masks_exclude_pier_floor_and_theatre_floor() -> void:
	for id in PROFILE.ALL_PROFILES:
		var mask := PROFILE.mask_for(id).get_image()
		var source := Image.new()
		source.load_png_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/battle/living_masks/"+id+".png"))
		assert_true(mask.get_data()==source.get_data(),"Image import preserves all four data channels")
		for y in range(89,135):
			for x in range(320):
				if id == "black_crossing": assert_eq(mask.get_pixel(x,y).r,0.0,"Water never reaches pier")
		if id == "threadbare_theatre":
			for y in range(110,145):
				for x in range(70,285): assert_eq(mask.get_pixel(x,y).r,0.0,"Stage remains fixed")
		if id in PROFILE.V2_ARENAS:
			var floor := mask.get_region(Rect2i(0, 94, 320, 86))
			assert_true(_is_zero(floor.get_data()), id+" full lower band is empty")
		if id in PROFILE.V3_ARENAS:
			var start_row := PROFILE.V3_FLOOR_Y / 4 - 1
			var floor := mask.get_region(Rect2i(0, start_row, 320, 180-start_row))
			assert_true(_is_zero(floor.get_data()), id+" includes a clear row before the protected band")
			assert_true(mask.get_data() == PROFILE.build_mask(id).get_data(), id+" shipped mask matches its profile")

func _is_zero(bytes: PackedByteArray) -> bool:
	var zero := PackedByteArray()
	zero.resize(bytes.size())
	return bytes == zero

func test_delta_pause_finish_and_disable_are_safe() -> void:
	var node := BACKDROP.new()
	add_child_autofree(node)
	node.set_arena_id("black_crossing")
	node.set_process(false)
	for i in range(120): node.advance_living(1.0/120.0)
	assert_almost_eq(node.living_elapsed,1.0,0.00001)
	var material: Material = node.material
	node.set_living_paused(true)
	node.advance_living(2.0)
	assert_almost_eq(node.living_elapsed,1.0,0.00001)
	node.set_living_paused(false)
	node.set_process(false)
	node.advance_living(0.5)
	assert_almost_eq(node.living_elapsed,1.5,0.00001)
	node.set_living_enabled(false)
	node.advance_living(2.0)
	assert_almost_eq(node.living_elapsed,1.5,0.00001)
	node.set_living_enabled(true)
	assert_eq(node.material,material)
	get_tree().paused = true
	var before := node.living_elapsed
	await get_tree().create_timer(0.05,true).timeout
	assert_eq(node.living_elapsed,before)
	get_tree().paused = false
	node.finish_living_arena()
	node.advance_living(1.0)
	assert_eq(node.living_elapsed,before)
	node.set_living_enabled(false)
	node.set_living_enabled(true)
	assert_false(node.is_processing(),"Finished battle cannot resume ambience")

func test_warden_phase_uses_the_local_clock_and_real_enrage_hook() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.select_encounter("res://resources/encounters/bone_warden.tres")
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	add_child_autofree(battle)
	var node: TextureRect = battle.battle_backdrop
	node.set_process(false)
	var before: int = battle.units.size()
	for unit: BattleUnit in battle.units.duplicate():
		if unit.is_boss:
			unit.take_damage(unit.max_hp * 0.51)
			assert_true(unit.enraged)
			break
	assert_true(battle.boss_reinforcements_spawned)
	assert_gt(battle.units.size(), before)
	var phase: ShaderMaterial = node.living_material
	node.advance_living(0.6)
	assert_almost_eq(float(phase.get_shader_parameter("phase_strength")), 0.5, 0.001)
	get_tree().paused = true
	node.advance_living(0.6)
	assert_almost_eq(float(phase.get_shader_parameter("phase_strength")), 0.5, 0.001)
	get_tree().paused = false
	node.advance_living(0.6)
	assert_eq(float(phase.get_shader_parameter("phase_strength")), 1.0)
	node.finish_living_arena()
	node.set_living_phase_two(false)
	node.advance_living(2.0)
	assert_eq(float(phase.get_shader_parameter("phase_strength")), 1.0)
	node.set_arena_id("warden", "bone_warden")
	assert_eq(node.living_phase_mix, 0.0)
	assert_false(node.living_finished)

func test_reopen_switch_and_visual_randomness_are_isolated() -> void:
	seed(147)
	var expected := randf()
	seed(147)
	for i in range(12):
		var node := BACKDROP.new()
		add_child(node)
		for id in PROFILE.ALL_PROFILES:
			node.set_arena_id(PROFILE.arena_for(id), PROFILE.encounter_for(id))
			node.advance_living(10.0)
			node.set_living_enabled(false)
			node.set_living_enabled(true)
		node.free()
	assert_eq(randf(),expected,"Atmosphere must never consume combat RNG")
	assert_eq(PROFILE.masks.size(),PROFILE.ALL_PROFILES.size(),"Bounded shared mask cache")

func test_identical_real_battle_results_with_fx_on_and_off() -> void:
	var encounters := DirAccess.get_files_at("res://resources/encounters")
	var tested_arenas := {}
	var tested_encounters := 0
	for file: String in encounters:
		if not file.ends_with(".tres"): continue
		var encounter := load("res://resources/encounters/"+file) as EncounterData
		# This directory also holds mechanics resources for Last Rite and Whistle.
		if encounter == null: continue
		var profile_id := PROFILE.for_encounter(encounter.arena_id, encounter.encounter_id)
		assert_false(profile_id.is_empty(), encounter.encounter_id)
		var baseline: Array = await _battle_result(encounter, profile_id, false)
		var animated: Array = await _battle_result(encounter, profile_id, true)
		assert_eq(animated,baseline,encounter.encounter_id+" same fixed-step real combat")
		tested_encounters += 1
		tested_arenas[encounter.arena_id] = true
	assert_eq(tested_arenas.size(), 16)
	assert_eq(tested_encounters, 22)

func _battle_result(encounter: EncounterData, profile_id: String, enabled: bool) -> Array:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger","QA")
	RunState.recruit_companion("mage","QA")
	RunState.active_card_id = encounter.encounter_id
	if encounter.arena_id == "warden":
		RunState.cards_resolved = 12
	RunState.select_encounter(encounter.resource_path)
	seed(775)
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	add_child(battle)
	assert_eq(battle.battle_backdrop.living_profile_id, profile_id, encounter.encounter_id)
	battle.process_mode = Node.PROCESS_MODE_DISABLED
	battle.battle_backdrop.set_living_enabled(enabled)
	battle.combat_started = true
	battle.combat_live = true
	for unit: BattleUnit in battle.units: unit.start_combat()
	if battle.black_crossing_surge_controller != null: battle.black_crossing_surge_controller.start_surge()
	if battle.thread_tether_controller != null: battle.thread_tether_controller.start_threads()
	for frame in range(3600):
		if battle.battle_finished: break
		if battle.wave_intermission:
			battle.process_mode = Node.PROCESS_MODE_INHERIT
			await battle._start_second_wave()
			battle.process_mode = Node.PROCESS_MODE_DISABLED
			if enabled and profile_id == "iron_wall":
				battle.battle_backdrop.advance_living(0.5)
				assert_gt(float(battle.battle_backdrop.living_material.get_shader_parameter("wave_strength")), 0.0)
		battle._process(1.0/60.0)
		battle.battle_backdrop.advance_living(1.0/60.0)
		if battle.black_crossing_surge_controller != null: battle.black_crossing_surge_controller.advance_battle(1.0/60.0)
		if battle.thread_tether_controller != null: battle.thread_tether_controller._process(1.0/60.0)
		for unit: BattleUnit in battle.units:
			if is_instance_valid(unit): unit._process(1.0/60.0)
	var result: Array = [battle.battle_finished,RunState.last_battle_won,battle.battle_wave_index,battle.boss_reinforcements_spawned]
	for unit: BattleUnit in battle.units:
		result.append([unit.visual_role,snappedf(unit.hp,0.001),unit.alive,unit.position.snapped(Vector2(0.01,0.01))])
	assert_true(battle.battle_finished,encounter.encounter_id+" fixed-step battle completed")
	assert_true(battle.battle_backdrop.living_finished)
	battle.free()
	await get_tree().process_frame
	return result
