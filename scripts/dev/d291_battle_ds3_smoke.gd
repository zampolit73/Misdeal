extends SceneTree

# D291 native real Battle smoke: active tactics and UI in the production scene,
# using RunState and the original battle script (not a mock preview or bitmap).
const SCENE_PATH := "res://scenes/battle/battle.tscn"

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
	# Script-mode headless runs must register RunState before loading battle.gd.
	var packed := load(SCENE_PATH) as PackedScene
	if packed == null:
		_fail("production Battle resource missing after RunState registration")
		return
	var scene := packed.instantiate() as Control
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
		var physical: bool = path == "BottomHudPanel" or path == "FightHudPanel"
		if style == null or style.border_width_left != (2 if physical else 1) or style.shadow_size != (6 if physical else 3):
			_fail("D293 Battle physical DS3 material not loaded: " + path)
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
	if scene.get_node_or_null("TopHudPanel/DS3EncounterTitleInset") == null or scene.get_node_or_null("RunHudPanel/DS3CardProgressPlaque") == null:
		_fail("D293 top ledger title/stage physical inlays are missing")
		return
	var hint := scene.get_node("PlacementHint") as Label
	if hint.modulate.a < 0.90:
		_fail("D293 placement hint contrast regressed")
		return
	# These are genuine authored webp pieces, not a drawn image of the HUD.
	for path in ["BottomHudPanel", "FightHudPanel"]:
		var tray := scene.get_node(path) as Panel
		if tray.get_node_or_null("DS3MaterialUpper") == null or tray.get_node_or_null("DS3CapInset") == null:
			_fail("D293 physical battle command tray missing")
			return
		for name in ["DS3GiltLeft", "DS3GiltRight"]:
			var fragment := tray.get_node_or_null(name) as TextureRect
			if fragment == null or fragment.texture == null or fragment.texture.get_size() != Vector2(53, 53):
				_fail("D293 genuine bronze ornament missing from " + path)
				return
	if scene.get_node_or_null("BottomHudPanel/DS3CommandHolder") == null or scene.get_node_or_null("BottomHudPanel/DS3OrderScroll") == null:
		_fail("D293 tactical order holder/scroll hierarchy missing")
		return
	if scene.get_node_or_null("FightHudPanel/DS3StrikeHolder") == null:
		_fail("D293 primary action lacquer holder missing")
		return
	var ruby := scene.get_node_or_null("FightButton/DS3FightRubySeal") as TextureRect
	if ruby == null or ruby.texture == null or ruby.texture.get_size() != Vector2(103, 103):
		_fail("D293 physical painted ruby crest missing from real Fight Button")
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
	var hunt_inlay := hunt.get_node_or_null("DS3SelectedInlay") as ColorRect
	var assault_inlay := assault.get_node_or_null("DS3SelectedInlay") as ColorRect
	if hunt_inlay == null or assault_inlay == null or not hunt_inlay.visible or assault_inlay.visible:
		_fail("D293 selected Hunt token / idle Assault visibility wrong")
		return
	var token := hunt.get_node_or_null("DS3OrderMark") as ColorRect
	if token == null or not token.visible:
		_fail("D293 selected Tactic heraldic mark missing")
		return
	if hunt_style.bg_color.r <= assault_style.bg_color.r + 0.10:
		_fail("D292 selected tactical fill lacks contrast")
		return
	scene.call("_select_tactical_order", "formation", false)
	if scene.get("tactical_order") != "formation" or not (scene.get_node("FormationOrderButton") as Button).button_pressed:
		_fail("real Formation action or UI state not preserved")
		return
	if hunt_inlay.visible or not (scene.get_node("FormationOrderButton/DS3SelectedInlay") as ColorRect).visible:
		_fail("D293 selected token did not follow Formation")
		return
	if token.visible:
		_fail("D293 selected Hunt icon stayed visible after switching to Formation")
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
