extends SceneTree
## A real XIII victory is the only source of the unlocks in this fixture.

var state: Node
var archive: RefCounted
var save: RefCounted
var output: String

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var arguments := OS.get_cmdline_user_args()
	if arguments.is_empty():
		quit(1)
		return
	output = arguments[0]
	DirAccess.make_dir_recursive_absolute(output)
	var token := Crypto.new().generate_random_bytes(6).hex_encode()
	state = root.get_node("RunState")
	archive = load("res://scripts/core/wizard_archive.gd").instance()
	archive.open_profile(output.path_join("qa_archive_" + token + ".json"))
	save = load("res://scripts/core/run_save_service.gd").instance()
	save.path = output.path_join("qa_run_" + token + ".json")
	seed(31017)
	state.reset_run()
	state.choose_protagonist("knight")
	for id in ["knight_iron_oath", "knight_executioner", "knight_cleaver"]:
		state.add_hero_upgrade(id)
	state.add_artifact("dead_mans_shield")
	state.add_artifact("harvest_ring")
	state.change_hero_hp("knight", state.get_hero_max_hp("knight"))
	if not await _fight_warden(): return
	var battle := current_scene
	if not _check(state.last_battle_won, "Qualified Knight fixture must win XIII"): return
	var phase_two := false
	for unit in battle.units:
		if unit.is_boss: phase_two = unit.enraged
	if not _check(phase_two, "Real second phase occurred"): return
	if not _check(archive.highest_oath() == 0, "Do not unlock before the victory reward is settled"): return
	battle.continue_button.pressed.emit()
	if not await _at_scene("/reward/reward.tscn"): return
	for frame in range(1300):
		await process_frame
		if not current_scene.scene_file_path.ends_with("/reward/reward.tscn"): break
		if root.get_node("SceneTransition").get("_busy"): continue
		for button in current_scene.reward_buttons:
			if button.visible and not button.disabled:
				button.pressed.emit()
				break
	if not await _at_scene("/run_end/run_end.tscn"): return
	if not _check(state.boss_defeated and archive.style_unlocked("knight") and archive.highest_oath() == 1, "Real victory unlocks the protagonist style and oath I"): return
	if not _check(archive.enemies.has("bone_warden") and archive.enemies.has("skeleton") and archive.relics.has("harvest_ring"), "Real enemy and relic entries"): return

	state.reset_run()
	state.choose_protagonist("ranger")
	state.change_hero_hp("ranger", -state.get_hero_max_hp("ranger") + 6.0)
	if not await _fight_warden(): return
	if not _check(not state.last_battle_won and state.last_deal_pending, "Ranger suffered a real defeat"): return
	current_scene.last_deal_refuse_button.pressed.emit()
	if not await _at_scene("/run_end/run_end.tscn"): return
	archive.open_profile(archive.path)
	if not _check(archive.history.size() == 2 and not archive.style_unlocked("ranger") and archive.highest_oath() == 1, "Persist both results without unlocking on defeat"): return

	await _open("res://scenes/main/main.tscn")
	current_scene.get_node("WizardArchiveButton").pressed.emit()
	if not await _at_scene("/archive/wizard_archive.tscn"): return
	await _capture("reliquary.png")
	current_scene._tabs[1].pressed.emit()
	if not _check(current_scene._reader.text.contains("Костяной надзиратель"), "Bestiary reveals encountered XIII"): return
	await _capture("bestiary.png")
	current_scene._tabs[2].pressed.emit()
	await _capture("chronicle.png")
	current_scene._tabs[3].pressed.emit()
	await _capture("challenges.png")

	state.reset_run()
	await _open("res://scenes/class_select/class_select.tscn")
	var select := current_scene
	select.get_node("Frame/Cards/Knight").pressed.emit()
	var style := select.get_node("Frame/StartingStyle") as OptionButton
	var oath := select.get_node("Frame/WizardOath") as OptionButton
	if not _check(not style.is_item_disabled(1) and not oath.is_item_disabled(1) and oath.is_item_disabled(2), "Correct options are unlocked in real character selection"): return
	style.select(1)
	oath.select(1)
	style.item_selected.emit(1)
	oath.item_selected.emit(1)
	await create_timer(0.4).timeout
	await _capture("starting_charter.png")
	select.get_node("Frame/ConfirmButton").pressed.emit()
	if not await _at_scene("/table/table.tscn"): return
	var checkpoint: Dictionary = save.read_slot(state)
	if not _check(state.starting_style == "blood_oath" and state.oath_rank == 1 and checkpoint.state.oath_rank == 1, "Starting style and oath persist with an actual new run"): return
	if not _check(state.get_merchant_price(25) == 32, "Oath changes the actual merchant price"): return
	print("GAMEPLAY_META_NATIVE_PASS: real XIII victory and defeat; phase II; archive restored; style and oath selected and saved")
	await create_timer(0.8).timeout
	quit()

func _fight_warden() -> bool:
	state.cards_resolved = 12
	state.get_offer_cards()
	if not _check(state.choose_card("bone_warden"), "Production XIII offer must resolve to its battle"): return false
	await _open("res://scenes/battle/battle.tscn")
	var battle := current_scene
	battle.combat_plan_controller.start_planned_battle()
	for frame in range(5400):
		await process_frame
		if battle.battle_finished:
			return true
	return _check(false, "XIII battle timed out")

func _open(path: String) -> void:
	change_scene_to_file(path)
	await scene_changed
	await process_frame

func _at_scene(suffix: String) -> bool:
	for frame in range(1200):
		await process_frame
		if current_scene != null and current_scene.scene_file_path.ends_with(suffix) and not root.get_node("SceneTransition").get("_busy"):
			return true
	return _check(false, "Did not reach " + suffix)

func _capture(filename: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(filename))

func _check(condition: bool, message: String) -> bool:
	if not condition:
		push_error("GAMEPLAY_META_FAIL: " + message)
		quit(1)
	return condition
