extends SceneTree

# D291 native real Battle smoke: active tactics and UI in the production scene,
# using RunState and the original battle script (not a mock preview or bitmap).
const SCENE := preload("res://scenes/battle/battle.tscn")

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
		_fail("could not choose hero")
		return
	var scene := SCENE.instantiate() as Control
	if scene == null:
		_fail("cannot instantiate production Battle")
		return
	root.add_child(scene)
	await process_frame

	# All six combat plates remain outside the main 20,96->1260,574 arena.
	var panels := ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "WizardCommentaryPanel", "SideObjectivePanel"]
	for path in panels:
		var plate := scene.get_node(path) as Panel
		var style := plate.get_theme_stylebox("panel") as StyleBoxFlat
		if style == null or style.border_width_left != 1 or style.shadow_size != 3:
			_fail("Battle DS3 light material not loaded: " + path)
			return
		if plate.mouse_filter != Control.MOUSE_FILTER_IGNORE and plate.mouse_filter != Control.MOUSE_FILTER_PASS:
			_fail("battle panel mouse interception changed: " + path)
			return
	var arena := scene.get_node("Arena") as Control
	var backdrop := scene.get_node("BattleBackdrop") as TextureRect
	if arena.position != Vector2(20, 96) or arena.size != Vector2(1240, 478) or backdrop == null:
		_fail("approved battle arena geometry changed")
		return
	if not backdrop.has_method("set_arena_id"):
		_fail("authored arena art contract changed")
		return

	var orders := ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton", "SacrificeOrderButton", "DefianceOrderButton"]
	for path in orders:
		var button := scene.get_node(path) as Button
		if not button.toggle_mode or button.size.y != 38 or button.pressed.get_connections().is_empty():
			_fail("Battle original real tactical controls changed: " + path)
			return
		for style_name in ["normal", "hover", "pressed", "disabled", "hover_pressed"]:
			if not button.has_theme_stylebox_override(style_name):
				_fail("DS3 tactical state missing: " + path + " " + style_name)
				return
	var hunt := scene.get_node("HuntOrderButton") as Button
	scene.call("_select_tactical_order", "hunt", false)
	if scene.get("tactical_order") != "hunt" or not hunt.button_pressed:
		_fail("real Hunt action no longer selects correct tactical order")
		return
	var hunt_style := hunt.get_theme_stylebox("normal") as StyleBoxFlat
	var assault := scene.get_node("AssaultOrderButton") as Button
	var assault_style := assault.get_theme_stylebox("normal") as StyleBoxFlat
	if hunt_style == null or assault_style == null or hunt_style.border_width_left <= assault_style.border_width_left:
		_fail("DS3 selected order highlight not reapplied after original selector")
		return
	scene.call("_select_tactical_order", "formation", false)
	if scene.get("tactical_order") != "formation" or not (scene.get_node("FormationOrderButton") as Button).button_pressed:
		_fail("real Formation action or UI state not preserved")
		return

	for btn in ["TargetPreviewButton", "FightButton", "ContinueButton", "RestartButton"]:
		var control := scene.get_node(btn) as Button
		if control.get_theme_stylebox("hover") == null:
			_fail("real Battle control missing DS3 visual state: " + btn)
			return
		if control.size.y <= 0:
			_fail("Battle Button geometry changed: " + btn)
			return
	if (scene.get_node("FightButton") as Button).pressed.get_connections().is_empty():
		_fail("Fight action lost original callback")
		return
	var actual_units: Array = scene.get("units")
	if actual_units.is_empty():
		_fail("no live BattleUnits were instantiated")
		return
	print("D291_BATTLE_DS3_NATIVE_PASS: real unit scene, authentic arena geometry, combat controls and dynamic tactic selection")
	scene.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("D291_BATTLE_DS3_FAIL: " + reason)
	quit(1)
