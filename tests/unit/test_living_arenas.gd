extends GutTest
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")

func after_each() -> void:
	get_tree().paused = false
	RunState.reset_run()

func test_only_three_pilots_and_original_pixels_survive_toggle() -> void:
	var hashes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/living_arenas/source_hashes.json"))
	for path in hashes: assert_eq(FileAccess.get_sha256("res://"+path),hashes[path],"Approved arena bytes are immutable")
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
	assert_eq(PROFILE.masks.size(),3)

func test_masks_exclude_pier_floor_and_theatre_floor() -> void:
	for id in PROFILE.PILOTS:
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

func test_reopen_switch_and_visual_randomness_are_isolated() -> void:
	seed(147)
	var expected := randf()
	seed(147)
	for i in range(12):
		var node := BACKDROP.new()
		add_child(node)
		for id in PROFILE.PILOTS:
			node.set_arena_id(id)
			node.advance_living(10.0)
			node.set_living_enabled(false)
			node.set_living_enabled(true)
		node.set_arena_id("crypt")
		assert_null(node.material)
		assert_false(node.is_processing())
		node.free()
	assert_eq(randf(),expected,"Atmosphere must never consume combat RNG")
	assert_eq(PROFILE.masks.size(),3,"Bounded shared mask cache")

func test_identical_real_battle_results_with_fx_on_and_off() -> void:
	for id in PROFILE.PILOTS:
		var baseline: Array = await _battle_result(id,false)
		var animated: Array = await _battle_result(id,true)
		assert_eq(animated,baseline,id+" same fixed-step real combat")

func _battle_result(id: String, enabled: bool) -> Array:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger","QA")
	RunState.recruit_companion("mage","QA")
	RunState.select_encounter("res://resources/encounters/"+id+".tres")
	seed(775)
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	add_child(battle)
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
		battle._process(1.0/60.0)
		battle.battle_backdrop.advance_living(1.0/60.0)
		if battle.black_crossing_surge_controller != null: battle.black_crossing_surge_controller.advance_battle(1.0/60.0)
		if battle.thread_tether_controller != null: battle.thread_tether_controller._process(1.0/60.0)
		for unit: BattleUnit in battle.units:
			if is_instance_valid(unit): unit._process(1.0/60.0)
	var result: Array = [battle.battle_finished,RunState.last_battle_won,battle.battle_wave_index]
	for unit: BattleUnit in battle.units:
		result.append([unit.visual_role,snappedf(unit.hp,0.001),unit.alive,unit.position.snapped(Vector2(0.01,0.01))])
	assert_true(battle.battle_finished,id+" fixed-step battle completed")
	assert_true(battle.battle_backdrop.living_finished)
	battle.free()
	await get_tree().process_frame
	return result
