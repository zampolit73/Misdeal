extends GutTest
const HUB := preload("res://scenes/dev/qa_hub.tscn")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const LIVING_PROFILE := preload("res://scripts/battle/living_arena_profile.gd")

func after_each() -> void:
	get_tree().paused=false
	var session:=get_tree().root.get_node_or_null("QAHubSession")
	if session!=null: session.free()

func test_complete_catalog_search_archive_and_current_travel() -> void:
	var hub:=HUB.instantiate()
	add_child_autofree(hub)
	await hub.initialized
	await get_tree().process_frame
	var entries: Array=hub.get_entries()
	var live_cards := {}
	var ids := {}
	var batch02 := false
	var batch03 := false
	var batch03_locations := 0
	var batch03_outcomes := 0
	for entry in entries:
		assert_false(ids.has(entry.id),entry.id)
		ids[entry.id]=true
		assert_true(ResourceLoader.exists(entry.scene,"PackedScene"),entry.scene)
		if entry.has("card_id"): live_cards[entry.card_id]=true
		if entry.scene.ends_with("travel_batch02_playtest.tscn"): batch02=true
		if entry.scene.ends_with("travel_batch03_playtest.tscn"): batch03=true
		if entry.get("batch") == 3:
			batch03_locations += 1
			batch03_outcomes += int(entry.case_count)
	assert_eq(live_cards.size(),RunState.CARD_PATHS.size())
	assert_true(batch02)
	assert_true(batch03)
	assert_eq(batch03_locations, 10)
	assert_eq(batch03_outcomes, 72)
	for entry in hub.get_visible_entries(): assert_ne(entry.group,"АРХИВ")
	hub._show_group("TRAVEL")
	assert_eq(hub.get_visible_entries().size(),28)
	hub.get_node("Search").text="candle_seller"
	hub._show_group("ВСЁ")
	assert_eq(hub.get_visible_entries().size(),2)
	var matching_card := false
	for entry in hub.get_visible_entries():
		if entry.get("card_id","")=="candle_seller": matching_card=true
	assert_true(matching_card)
	hub.get_node("Search").text="no_matching_scene_123"
	hub._show_group("ВСЁ")
	assert_true(hub.get_node("DetailPanel/LaunchButton").disabled)
	hub.get_node("Categories/LivingArenas").pressed.emit()
	assert_eq(hub.get_node("Search").text, "")
	var living_previews: Array[String] = []
	for entry in hub.get_visible_entries():
		living_previews.append(entry.living_profile)
	assert_eq(living_previews, LIVING_PROFILE.ALL_PROFILES)
	assert_false(hub.get_node("DetailPanel/LaunchButton").disabled)
	hub.get_node("Search").text=""
	hub._show_group("АРХИВ")
	assert_gt(hub.get_visible_entries().size(),50)
	await get_tree().process_frame

func test_session_isolates_save_memory_and_restores_original_state_and_services() -> void:
	var previous_save: RefCounted=SAVE.shared
	var previous_memory: RefCounted=MEMORY.shared
	var before: Dictionary=SAVE.new().snapshot(RunState).state
	var hub:=HUB.instantiate()
	add_child_autofree(hub)
	await hub.initialized
	await get_tree().process_frame
	var session: Node=get_tree().root.get_node("QAHubSession")
	assert_true(session.available)
	assert_ne(SAVE.shared,previous_save)
	assert_ne(MEMORY.shared,previous_memory)
	assert_true(SAVE.shared.path.begins_with("user://qa_hub/"))
	assert_true(MEMORY.shared.path.begins_with("user://qa_hub/"))
	var card: Dictionary={}
	for entry in hub.get_entries():
		if entry.get("card_id")=="candle_seller": card=entry
	assert_true(session.prepare(card,{"roles":["mage"],"gold":17,"upgrades":true,"recruitment":false}))
	assert_eq(RunState.party_roles,["mage"])
	assert_eq(RunState.gold,17)
	assert_eq(RunState.active_card_id,"candle_seller")
	assert_eq(RunState.get_role_upgrade_count("mage"),1)
	assert_false(RunState.can_recruit_companion("ranger"))
	session.free()
	assert_same(SAVE.shared,previous_save)
	assert_same(MEMORY.shared,previous_memory)
	assert_eq(SAVE.new().snapshot(RunState).state,before)
