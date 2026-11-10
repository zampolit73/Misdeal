extends GutTest
const EVENTS := preload("res://scripts/event/final_five_events.gd")
const ART := preload("res://scripts/ui/card_art_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")

func test_all_original_forty_card_resources_are_preserved() -> void:
	var baseline: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/final_five/baseline_cards.json"))
	assert_eq(baseline.cards.size(),40)
	for card in baseline.cards:
		assert_true(RunState.ACT1_CARD_IDS.has(card.id))
		var content := FileAccess.get_file_as_string("res://"+card.path).replace("\r\n","\n")
		assert_eq(content.sha256_text(),card.sha256_lf,"Original resource changed: "+card.id)

func after_each() -> void:
	RunState.reset_run()

func fixture(id: String, count: int = 1) -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	if count >= 2: RunState.recruit_companion("ranger", "QA")
	if count >= 3: RunState.recruit_companion("mage", "QA")
	RunState.gold = 50
	RunState.active_card_id = id
	RunState.wizard_debt_active = true

func test_deck_resources_and_unique_art() -> void:
	assert_eq(RunState.ACT1_CARD_IDS.size(),45)
	var seen := {}
	var pictures := {}
	for id in RunState.ACT1_CARD_IDS:
		assert_false(seen.has(id))
		seen[id] = true
		assert_not_null(RunState.get_card(id))
	for id in EVENTS.IDS:
		var card := RunState.get_card(id)
		assert_eq(card.resolution_type,"event")
		assert_true(ResourceLoader.exists(card.target_path))
		var picture := ART.get_run_card_texture(id)
		assert_not_null(picture)
		assert_eq(picture.get_size(),Vector2(448,274))
		var digest := FileAccess.get_sha256(card.art_path)
		assert_false(pictures.has(digest))
		pictures[digest] = true

func test_all_fifteen_real_buttons_once_for_solo_duo_trio() -> void:
	for count in [1,2,3]:
		for id in EVENTS.IDS:
			for index in range(3):
				fixture(id,count)
				var event := load("res://scenes/event/act_choice.tscn").instantiate() as Control
				add_child(event)
				var button := event.get_node("Panel/Choices/Choice"+["A","B","C"][index]) as Button
				assert_false(button.disabled,id)
				button.pressed.emit()
				assert_eq(RunState.get_event_outcome(id),EVENTS.CHOICES[id][index][0])
				assert_eq(RunState.cards_resolved,1)
				assert_eq(RunState.fate_choice_history[0].chosen,id)
				var snapshot := SAVE.new().snapshot(RunState)
				for key in ["A","B","C"]: event.get_node("Panel/Choices/Choice"+key).pressed.emit()
				assert_eq(SAVE.new().snapshot(RunState).state,snapshot.state,"Repeat input must be inert")
				assert_false(RunState.is_card_eligible(id))
				assert_eq(RunState.get_party_size(),count)
				event.queue_free()
				await get_tree().process_frame

func test_prices_conditions_and_invalid_choices_are_atomic() -> void:
	for spec in [["unsent_letters","release",10],["borrowed_boots","repair",18],["false_weights","fair",12],["last_signal","truth",20]]:
		fixture(spec[0])
		RunState.gold = spec[2]-1
		var before: Dictionary = SAVE.new().snapshot(RunState).state
		assert_false(EVENTS.resolve(RunState,spec[0],spec[1]))
		assert_false(EVENTS.resolve(RunState,spec[0],"unknown"))
		assert_eq(SAVE.new().snapshot(RunState).state,before)
		RunState.gold += 1
		assert_true(EVENTS.resolve(RunState,spec[0],spec[1]))
		assert_eq(RunState.gold,0)
	fixture("unsent_letters")
	RunState.defiance_order_ready = true
	assert_false(EVENTS.resolve(RunState,"unsent_letters","release"))
	fixture("last_signal")
	RunState.wizard_debt_active = false
	assert_false(EVENTS.resolve(RunState,"last_signal","truth"))
	assert_true(EVENTS.resolve(RunState,"last_signal","passed"))

func test_normal_tier_deals_preserve_all_new_cards() -> void:
	for id in EVENTS.IDS:
		fixture("")
		RunState.cards_resolved = RunState.get_card(id).tier * 4
		RunState.forced_combat_slots.assign([3,3,3])
		RunState.wizard_meddling_slots.clear()
		RunState.wizard_mark_slots.clear()
		RunState.wizard_wager_slots.clear()
		var found := false
		for sample in range(500):
			seed(sample)
			RunState.current_offer_ids.clear()
			var offers := RunState.get_offer_cards()
			assert_eq(offers.size(),2)
			assert_ne(offers[0].card_id,offers[1].card_id)
			if RunState.current_offer_ids.has(id):
				found = true
				break
		assert_true(found,"Ordinary tier deal: "+id)
		assert_true(RunState.choose_card(id))
		assert_true(EVENTS.resolve(RunState,id,"passed"))
		RunState.complete_active_card()
		assert_eq(RunState.cards_resolved,RunState.get_card(id).tier*4+1)
		assert_false(RunState.is_boss_due())

func test_boots_match_live_hero_stats_and_reset() -> void:
	for count in [1,2,3]:
		for choice in ["repair","hobnails"]:
			fixture("borrowed_boots",count)
			var base := RunState.get_effective_hero_stats("knight")
			assert_true(EVENTS.resolve(RunState,"borrowed_boots",choice))
			var expected := RunState.get_effective_hero_stats("knight")
			assert_almost_eq(expected.move_speed,base.move_speed*(1.08 if choice=="repair" else 0.96),0.001)
			RunState.select_encounter("res://resources/encounters/graveyard_ambush.tres")
			var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
			add_child(battle)
			await get_tree().process_frame
			for unit in battle.units:
				if unit.visual_role=="knight": assert_almost_eq(unit.move_speed,expected.move_speed,0.001)
			battle.queue_free()
			await get_tree().process_frame
	RunState.reset_run()
	assert_eq(EVENTS.movement_multiplier(RunState),1.0)

func test_existing_save_contract_accepts_every_completed_outcome() -> void:
	var service := SAVE.new()
	DirAccess.make_dir_recursive_absolute("res://.tmp")
	service.path = "res://.tmp/final_five_save_test.json"
	for id in EVENTS.IDS:
		for entry in EVENTS.CHOICES[id]:
			fixture(id)
			assert_true(EVENTS.resolve(RunState,id,entry[0]))
			RunState.complete_active_card()
			var data := service.snapshot(RunState)
			assert_true(service.validate(data,RunState),id+":"+entry[0])
			assert_eq(data.state.event_outcomes[id],entry[0])
			assert_eq(data.state.fate_choice_history[0].chosen,id)
			assert_true(service.write_slot(RunState))
			var disk := service.read_slot(RunState)
			RunState.reset_run()
			assert_true(service.apply_slot(RunState,disk))
			assert_eq(RunState.event_outcomes,data.state.event_outcomes)
			assert_eq(RunState.party_hp_bonus,data.state.party_hp_bonus)
			assert_eq(RunState.party_damage_bonus,data.state.party_damage_bonus)
			assert_eq(RunState.gold,data.state.gold)
			assert_eq(RunState.defiance_order_ready,data.state.defiance_order_ready)
			assert_eq(RunState.wizard_debt_active,data.state.wizard_debt_active)

func test_effect_values_and_defiance_consumption() -> void:
	for entry in [["banner_seamstress","bandages",50,12.0,-0.5],["banner_seamstress","standard",50,-6.0,0.75],["borrowed_boots","repair",32,0.0,0.0],["borrowed_boots","hobnails",50,8.0,0.0],["false_weights","fair",38,16.0,0.0],["false_weights","silence",68,-6.0,0.0],["last_signal","salvage",72,0.0,0.0]]:
		fixture(entry[0])
		assert_true(EVENTS.resolve(RunState,entry[0],entry[1]))
		assert_eq(RunState.gold,entry[2])
		assert_eq(RunState.party_hp_bonus,entry[3])
		assert_eq(RunState.party_damage_bonus,entry[4])
	fixture("unsent_letters")
	assert_true(EVENTS.resolve(RunState,"unsent_letters","release"))
	assert_true(RunState.consume_defiance_order_for_battle())
	assert_false(RunState.consume_defiance_order_for_battle())
	fixture("last_signal")
	assert_true(EVENTS.resolve(RunState,"last_signal","truth"))
	assert_false(RunState.wizard_debt_active)
	assert_eq(RunState.get_reward_multiplier(),1)

func test_new_cards_can_be_held_then_resolved_at_the_original_delay() -> void:
	for id in EVENTS.IDS:
		fixture("")
		RunState.cards_resolved=RunState.get_card(id).tier*4
		RunState.current_offer_ids.assign([id,"moon_seal"])
		assert_true(RunState.hold_offer_card(id))
		assert_true(RunState.choose_card("moon_seal"))
		RunState.complete_active_card()
		assert_eq(RunState.held_card_id,id)
		RunState.cards_resolved=RunState.held_card_return_at
		RunState.forced_combat_slots.assign([3,3,3])
		RunState.current_offer_ids.clear()
		RunState.get_offer_cards()
		assert_true(RunState.current_offer_ids.has(id))
		assert_true(RunState.choose_card(id))
		assert_true(EVENTS.resolve(RunState,id,"passed"))
		RunState.complete_active_card()
		assert_eq(RunState.held_card_id,"")

func test_narrative_v2_art_lock_and_separate_story_levels() -> void:
	var hashes: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/echo_narrative_v2/art_hashes.json"))
	assert_eq(hashes.size(),10)
	for path in hashes:
		if path.ends_with("/card.webp"):
			assert_eq(FileAccess.get_sha256("res://"+path),hashes[path],"Approved card painting preserved")
	for id in EVENTS.IDS:
		fixture(id)
		var event := load("res://scenes/event/act_choice.tscn").instantiate() as Control
		add_child(event)
		assert_eq(event.description_label.text,EVENTS.SCENES[id])
		assert_ne(event.description_label.text,RunState.get_card(id).card_text)
		event.free()

func test_event_illustrations_use_distinct_scene_sources_and_correct_routes() -> void:
	var base := "res://assets/pixel/events/final_five/"
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(base+"manifest.json"))
	assert_eq(manifest.event_sources.size(),5)
	for id in EVENTS.IDS:
		assert_eq(FileAccess.get_sha256(base+"sources/event_choice_v1/"+id+"/source.png"),manifest.event_sources[id])
		for spec in [["event",Vector2i(448,274)],["backdrop",Vector2i(1280,720)]]:
			var path: String = id+"/"+spec[0]+".webp"
			assert_eq(FileAccess.get_sha256(base+path),manifest.files[path.replace("/","\\")])
			var image := Image.new()
			assert_eq(image.load_webp_from_buffer(FileAccess.get_file_as_bytes(base+path)),OK)
			assert_eq(image.get_size(),spec[1])
		fixture(id)
		var event := load("res://scenes/event/act_choice.tscn").instantiate() as Control
		add_child(event)
		var expected := Image.new()
		expected.load_webp_from_buffer(FileAccess.get_file_as_bytes(base+id+"/event.webp"))
		for button in [event.choice_a,event.choice_b,event.choice_c]:
			var texture: Texture2D = button.get_node("ChoiceArt").texture
			assert_eq(texture.get_image().get_data(),expected.get_data(),"Correct event illustration")
		assert_ne(FileAccess.get_sha256(base+id+"/event.webp"),FileAccess.get_sha256(base+id+"/card.webp"))
		event.free()
