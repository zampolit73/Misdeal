extends GutTest
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")

func after_each() -> void:
	RunState.reset_run()

func _event(gold: int = 50) -> Control:
	RunState.reset_run()
	RunState.choose_protagonist("ranger")
	RunState.gold = gold
	RunState.active_card_id = "jack"
	var event := preload("res://scenes/event/act_choice.tscn").instantiate() as Control
	add_child_autofree(event)
	return event

func _battle() -> Control:
	RunState.selected_encounter_path = "res://resources/encounters/graveyard_ambush.tres"
	var battle := preload("res://scenes/battle/battle.tscn").instantiate() as Control
	add_child_autofree(battle)
	return battle

func test_normal_deals_and_wizard_replacements_never_offer_jack_without_ranger() -> void:
	for role in ["knight","mage","ranger"]:
		var appeared := false
		for sample in range(80):
			seed(sample)
			RunState.reset_run()
			RunState.choose_protagonist(role)
			RunState.cards_resolved = 4
			RunState.forced_combat_slots[1] = 2
			RunState.wizard_meddling_slots.assign([4])
			RunState.get_offer_cards()
			RunState._prepare_wizard_meddling_if_due()
			var ids := RunState.current_offer_ids.duplicate()
			ids.append(RunState.wizard_meddling_replacement_id)
			if ids.has("jack"):
				appeared = true
				assert_eq(role,"ranger","Restricted card escaped its role gate")
		assert_eq(appeared,role == "ranger")
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.remaining_card_ids.assign(["jack"])
	assert_true(RunState.get_offer_cards().is_empty(),"Fallback candidate pool respects the gate")
	RunState.current_offer_ids.assign(["jack"])
	assert_false(RunState.choose_card("jack"),"Cached/injected offer cannot bypass the gate")
	assert_true(RunState.recruit_companion("ranger","QA"))
	assert_true(RunState.is_card_eligible("jack"),"A recruited Ranger unlocks the same event")

func test_all_three_real_choices_resolve_once_and_reset_between_runs() -> void:
	for choice in ["recruited","passed","token"]:
		var event := _event()
		var before := RunState.get_effective_hero_stats("ranger")
		var index := ["recruited","passed","token"].find(choice)
		var button := event.get_node("Panel/Choices/Choice"+["A","B","C"][index]) as Button
		assert_false(event.get_node("Panel/LeaveButton").visible,"Exactly three outcomes")
		button.pressed.emit()
		assert_eq(RunState.get_event_outcome("jack"),choice)
		assert_eq(RunState.cards_resolved,1)
		assert_eq(RunState.gold,25 if choice == "recruited" else 50)
		assert_eq(RunState.has_jack_companion(),choice == "recruited")
		assert_eq(RunState.get_party_size(),1)
		var after := RunState.get_effective_hero_stats("ranger")
		assert_almost_eq(float(after.damage),float(before.damage)*(1.1 if choice == "token" else 1.0),0.001)
		for other in ["A","B","C"]:
			event.get_node("Panel/Choices/Choice"+other).pressed.emit()
		assert_eq(RunState.cards_resolved,1,"Repeated input cannot grant or charge again")
		assert_eq(RunState.get_event_outcome("jack"),choice)
		assert_false(RunState.is_card_eligible("jack"))
		event.queue_free()
		await get_tree().process_frame
	RunState.reset_run()
	assert_false(RunState.has_jack_companion())
	assert_eq(RunState.get_jack_damage_multiplier("ranger"),1.0)

func test_insufficient_gold_cannot_charge_or_resolve_and_other_choices_stay_available() -> void:
	var event := _event(24)
	assert_true(event.get_node("Panel/Choices/ChoiceA").disabled)
	assert_false(event.get_node("Panel/Choices/ChoiceB").disabled)
	assert_false(event.get_node("Panel/Choices/ChoiceC").disabled)
	event.call("_resolve_jack","recruited")
	assert_eq(RunState.gold,24)
	assert_eq(RunState.cards_resolved,0)
	assert_false(RunState.has_event_outcome("jack"))

func test_fixed_pet_stats_preserve_solo_and_trio_hero_compensation() -> void:
	for trio in [false,true]:
		RunState.reset_run()
		RunState.choose_protagonist("ranger")
		if trio:
			RunState.recruit_companion("knight","QA")
			RunState.recruit_companion("mage","QA")
		RunState.set_event_outcome("jack","recruited")
		var expected := RunState.get_effective_hero_stats("ranger")
		var battle := _battle()
		await get_tree().process_frame
		var pet: BattleUnit
		var ranger: BattleUnit
		for unit in battle.units:
			if unit.visual_role == "jack": pet = unit
			if unit.visual_role == "ranger": ranger = unit
		assert_not_null(pet)
		assert_eq(pet.max_hp,45.0)
		assert_eq(pet.damage,6.0)
		assert_eq(RunState.get_party_size(),3 if trio else 1)
		assert_almost_eq(ranger.damage,float(expected.damage),0.001)
		assert_almost_eq(ranger.max_hp,float(expected.hp),0.001)
		assert_not_null(pet.sprite_frames)
		for hero in battle.units:
			if hero.team == 0 and hero.visual_role != "jack":
				var gap: Vector2 = pet.position-hero.position
				assert_true(absf(gap.x) >= 95.0 or absf(gap.y) >= 60.0,"Pet deployment silhouette stays clear")
		battle.queue_free()
		await get_tree().process_frame

func test_token_is_ranger_only_and_matches_real_battle_and_dossier_stats() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("ranger")
	RunState.recruit_companion("knight","QA")
	RunState.recruit_companion("mage","QA")
	RunState.add_hero_upgrade("ranger_longshot")
	RunState.add_artifact("blind_quiver")
	var knight := RunState.get_effective_hero_stats("knight")
	RunState.set_event_outcome("jack","token")
	assert_eq(RunState.get_effective_hero_stats("knight"),knight)
	var battle := _battle()
	for unit in battle.units:
		assert_ne(unit.visual_role,"jack")
		if unit.visual_role == "ranger":
			assert_almost_eq(unit.damage,float(RunState.get_effective_hero_stats("ranger").damage),0.001)

func test_pet_death_does_not_fail_hero_objective_but_pet_cannot_replace_dead_party() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("ranger")
	RunState.set_event_outcome("jack","recruited")
	var battle := _battle()
	battle.side_objective_id = "no_critical"
	var pet: BattleUnit
	var ranger: BattleUnit
	for unit in battle.units:
		if unit.visual_role == "jack": pet = unit
		if unit.visual_role == "ranger": ranger = unit
	battle.call("_on_unit_health_critical",pet)
	assert_false(battle.side_objective_failed)
	pet.take_damage(10000.0)
	assert_false(battle.side_objective_failed)
	assert_false(battle.battle_finished)
	pet.alive = true # Explicit defeat fixture: only animal remains alive.
	ranger.take_damage(10000.0)
	assert_true(battle.battle_finished)
	assert_false(RunState.last_battle_won)

func test_complete_original_dog_animation_pack_has_all_states_and_clear_spares() -> void:
	assert_eq(FileAccess.get_sha256("res://assets/pixel/events/jack/approved_source.png"),"ae73dccfb5764cbe11ca6368f4fad1d65ceff568b26922e5a2808090b730b352","Exact user-selected first painting")
	assert_eq(FileAccess.get_sha256("res://assets/pixel/units/jack/source.png"),"7588a5a3fa24448c992ae16aa4157d23da7b64debd1cfbaf44674ca66b135791","Original complete drawing batch retained")
	var frames := ANIMATIONS.get_frames("jack")
	assert_not_null(frames)
	if frames == null: return
	var hashes := {}
	for state in {"idle":4,"walk":6,"attack":6,"hit":3,"death":6}:
		assert_eq(frames.get_frame_count(state),{"idle":4,"walk":6,"attack":6,"hit":3,"death":6}[state])
		for i in range(frames.get_frame_count(state)):
			var image := frames.get_frame_texture(state,i).get_image()
			assert_eq(image.get_size(),Vector2i(96,96))
			var digest := image.get_data().hex_encode().sha256_text()
			assert_false(hashes.has(digest),"Every authored pose must be distinct")
			hashes[digest] = true
	assert_eq(hashes.size(),25)
	var packed := Image.new()
	packed.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string("res://assets/pixel/units/jack/atlas.webp.b64").strip_edges()))
	packed.convert(Image.FORMAT_RGBA8)
	var original := Image.new()
	original.load_png_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/units/jack/atlas.png"))
	original.convert(Image.FORMAT_RGBA8)
	var identical := true
	for y in range(480):
		for x in range(576):
			var a := original.get_pixel(x,y)
			var b := packed.get_pixel(x,y)
			if a.a != b.a or (a.a > 0.0 and a != b): identical = false
	assert_true(identical,"Runtime WebP preserves all visible RGBA pixels of the packed original poses")
