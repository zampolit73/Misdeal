extends SceneTree
## Native visual fixture and real marked Grave Bell battle for Build & Rewards.

var state: Node
var output: String

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		quit(1)
		return
	output = args[0]
	DirAccess.make_dir_recursive_absolute(output)
	state = root.get_node("RunState")
	seed(31017)
	state.reset_run()
	state.choose_protagonist("knight")
	state.add_artifact("sanguine_whetstone")
	state.add_artifact("harvest_ring")
	state.add_artifact("marked_coin")
	state.change_hero_hp("knight", -40.0)
	await _open("res://scenes/table/table.tscn")
	await create_timer(1.0).timeout
	var table := current_scene
	table.get_node("SquadButton").pressed.emit()
	await create_timer(0.35).timeout
	var roster: Control = table.squad_status
	if not _verify(roster.relics_label.text.contains("Кровавый билд") and roster.stats_label.tooltip_text.contains("−40 HP"), "Dossier shows wounds and the equipped synergy"): return
	await _capture("blood_build.png")

	state.cards_resolved = 7
	state.gold = 100
	state.active_card_id = "moon_seal"
	state.complete_active_card()
	await _open("res://scenes/table/table.tscn")
	var panel := current_scene.get_node("CampStop")
	panel._choose("heal")
	if not _verify(state.gold == 75 and panel._message.text.contains("→"), "Purchase displays actual HP change"): return
	await _capture("merchant_change.png")
	panel._choose("leave")
	state.active_card_id = "grave_bell"
	state.select_encounter(state.get_card("grave_bell").target_path)
	state.wizard_mark_danger_active = true
	var before: int = state.gold
	await _open("res://scenes/battle/battle.tscn")
	var battle := current_scene
	battle.combat_plan_controller.start_planned_battle()
	for frame in range(5400):
		await process_frame
		if battle.battle_finished:
			break
	if not _verify(battle.battle_finished and state.last_battle_won, "Grave Bell AI victory"): return
	if not _verify(state.gold - before in [12, 27] and battle.result_subtitle.text.contains("МЕЧЕНАЯ МОНЕТА"), "Marked Coin paid one real bonus"): return
	await _capture("marked_coin.png")
	print("GAMEPLAY_BUILDS_NATIVE_PASS: actual combat victory, treasury bonus, wounds, synergy and purchase feedback")
	await create_timer(0.8).timeout
	quit()


func _open(path: String) -> void:
	change_scene_to_file(path)
	await scene_changed
	await process_frame


func _capture(file: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(file))


func _verify(condition: bool, message: String) -> bool:
	if not condition:
		push_error("GAMEPLAY_BUILDS_FAIL: " + message)
		quit(1)
	return condition
