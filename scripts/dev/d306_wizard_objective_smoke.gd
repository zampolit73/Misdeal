extends SceneTree

# D306: native regression for the ACTUAL Grave Bell side challenge with
# user-approved D303 painted Battle panels, no mock screen or fake objective.
const SCENE_PATH := "res://scenes/battle/battle.tscn"
const ENCOUNTER_PATH := "res://resources/encounters/grave_bell.tres"
const DS3_PASS := preload("res://scripts/battle/battle_ds3_pass.gd")


func _initialize() -> void:
	call_deferred("_check")


func _check() -> void:
	var state := root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("cannot choose protagonist")
		return
	state.call("select_encounter", ENCOUNTER_PATH)
	var scene := (load(SCENE_PATH) as PackedScene).instantiate() as Control
	if scene == null:
		_fail("cannot instantiate real Battle")
		return
	root.add_child(scene)
	await process_frame
	if scene.get("side_objective_id") != "bell_first":
		_fail("Grave Bell did not use actual bell-first objective")
		return
	var panel := scene.get_node("SideObjectivePanel") as Panel
	var objective := scene.get_node("SideObjectivePanel/ObjectiveLabel") as Label
	if not panel.visible or not objective.text.contains("Звонарь должен пасть первым"):
		_fail("authentic Wizard challenge is not present")
		return
	if panel.position != Vector2(22, 575) or panel.size != Vector2(216, 133):
		_fail("preparation challenge displaced from left command margin")
		return
	var style := panel.get_theme_stylebox("panel") as StyleBoxFlat
	if style == null or style.bg_color.a < 0.9 or style.border_width_top < 2:
		_fail("D306 challenge lacks legible ink and aged bronze frame")
		return
	if objective.z_index <= (panel.get_node("DS3EngravedRelief") as CanvasItem).z_index:
		_fail("D306 objective text is still hidden under late-appended relief")
		return
	if objective.get_theme_font_size("font_size") < 13 or objective.get_theme_color("font_color").r < 0.8:
		_fail("D306 Wizard text contrast/font too weak")
		return
	var original_text := objective.text
	var fight := scene.get_node("FightButton") as Button
	if fight.pressed.get_connections().is_empty():
		_fail("real Fight action lost its handler")
		return
	fight.pressed.emit()
	await process_frame
	if not scene.get("combat_started"):
		_fail("actual Fight button did not start combat")
		return
	if not panel.visible or panel.position != Vector2(98, 165):
		_fail("D306 optional challenge did not move to safe combat corner")
		return
	if objective.text != original_text:
		_fail("D306 movement mutated the reward rule")
		return
	if (scene.get_node("BottomHudPanel") as Panel).visible or (scene.get_node("FightHudPanel") as Panel).visible:
		_fail("preparation-only panels remain over combat")
		return
	if (scene.get_node("FightButton") as Button).visible:
		_fail("Fight button remains visible after combat start")
		return
	print("D306_WIZARD_OBJECTIVE_NATIVE_PASS: live Grave Bell challenge, contrast and combat positioning")
	scene.queue_free()
	await process_frame
	quit(0)


func _fail(message: String) -> void:
	push_error("D306_WIZARD_OBJECTIVE_FAIL: " + message)
	quit(1)
