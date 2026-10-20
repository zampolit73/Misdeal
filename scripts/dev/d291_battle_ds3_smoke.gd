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

	# D295 selected concept 2: slim top ledgers, centered live command tray,
	# separated right action; conditional objective moved left, no collisions.
	var panels := ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "WizardCommentaryPanel", "SideObjectivePanel"]
	for path in panels:
		var plate := scene.get_node(path) as Panel
		var style := plate.get_theme_stylebox("panel") as StyleBoxFlat
		var expected_shadow: int = 5 if path == "BottomHudPanel" or path == "FightHudPanel" else 2
		if style == null or style.border_width_left != 1 or style.shadow_size != expected_shadow:
			_fail("D295 selected minimal Gothic material not loaded: " + path)
			return
		var expected_mouse: int = Control.MOUSE_FILTER_STOP if path == "RunHudPanel" else Control.MOUSE_FILTER_IGNORE
		if plate.mouse_filter != expected_mouse and (path == "RunHudPanel" or plate.mouse_filter != Control.MOUSE_FILTER_PASS):
			_fail("battle panel mouse interception changed: " + path)
			return
		var relief := plate.get_node_or_null("DS3EngravedRelief") as Control
		if relief == null or relief.get_script() == null or relief.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D296 real engraved Control missing or intercepts input: " + path)
			return
		if relief.size != plate.size:
			_fail("D296 relief is not aligned with the real battle panel: " + path)
			return
	if not (scene.get_node("Title") as Label).has_theme_font_override("font"):
		_fail("D296 gothic title typography missing")
		return
	if not (scene.get_node("FightButton") as Button).has_theme_font_override("font"):
		_fail("D296 primary serif typography missing")
		return
	if scene.get_node_or_null("RunHudPanel/DS3ProgressSeal") == null:
		_fail("D296 progress heraldic fragment missing")
		return
	# D298 decorative assets are transparent empty holder surfaces, loaded
	# as independent Godot textures. They must never capture native input.
	var painted := {
		"TopHudPanel/DS3Banner": Vector2(87, 147),
		"RunHudPanel/DS3ProgressMedallion": Vector2(67, 85),
		"BottomHudPanel/DS3CommandPlate": Vector2(691, 133),
		"BottomHudPanel/DS3LeftFinial": Vector2(66, 37),
		"BottomHudPanel/DS3RightFinial": Vector2(66, 37),
		"FightHudPanel/DS3FightPlate": Vector2(293, 133),
		"FightHudPanel/DS3FightRibbon": Vector2(68, 108),
	}
	for art_path in painted:
		var ornament := scene.get_node_or_null(art_path) as TextureRect
		if ornament == null or ornament.texture == null:
			_fail("D298 Gothic real-art import/decode missing: " + str(art_path))
			return
		if ornament.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D298 painted-only asset intercepts Battle input: " + str(art_path))
			return
		if ornament.size != painted[art_path]:
			_fail("D298 painted asset violates authored HUD geometry: " + str(art_path))
			return
	var header := scene.get_node("Title") as Label
	if header.position.x < 100.0 or header.size.x < 800.0:
		_fail("D298 header title no longer clears physical red hanging banner")
		return
	var hint_label := scene.get_node("PlacementHint") as Label
	if hint_label.position != Vector2(30, 580) or hint_label.size.x > 215.0:
		_fail("D298 deployment hint can obscure live unit feet instead of wrapping at the left margin")
		return
	var run_plate := scene.get_node("RunHudPanel") as Panel
	var run_modifiers := scene.get_node("RunConditionLabel") as Label
	if run_plate.position != Vector2(959, 14) or run_plate.size != Vector2(299, 78):
		_fail("D297 right progress panel does not leave room for modifiers")
		return
	if run_modifiers.get_theme_font_size("font_size") < 12 or run_modifiers.get_line_count() != 2:
		_fail("D297 compact 2-row status is too small or wrapped")
		return
	if not run_modifiers.text.contains("СОЛО") or not run_modifiers.text.contains("АТК×1.25"):
		_fail("D297 visible solo modifiers are not the authentic RunState values")
		return
	if not run_modifiers.tooltip_text.contains("ДАВЛЕНИЕ ВРАГОВ") or not run_modifiers.tooltip_text.contains("АТАКИ ×1.25"):
		_fail("D297 full run modifiers were lost instead of remaining inspectable")
		return
	if run_modifiers.mouse_filter != Control.MOUSE_FILTER_STOP:
		_fail("D297 status tooltip cannot receive hover input")
		return
	var top := scene.get_node("TopHudPanel") as Panel
	var commands := scene.get_node("BottomHudPanel") as Panel
	var fight_plate := scene.get_node("FightHudPanel") as Panel
	var objective := scene.get_node("SideObjectivePanel") as Panel
	var fight_action := scene.get_node("FightButton") as Button
	if top.size.y != 72.0 or top.position.y != 14.0 or commands.position != Vector2(251, 575):
		_fail("D295 slim title / centered command geometry wrong")
		return
	if commands.size != Vector2(691, 133) or fight_plate.position != Vector2(949, 575) or fight_action.position != Vector2(964, 619):
		_fail("D295 real command or action geometry wrong")
		return
	if objective.position.x + objective.size.x >= commands.position.x or fight_plate.position.x <= commands.position.x + commands.size.x:
		_fail("D295 conditional objective/action overlaps the tactics")
		return
	var desc := scene.get_node("OrderDescription") as Label
	if desc.position.y < 655.0 or desc.position.y + desc.size.y > commands.position.y + commands.size.y:
		_fail("D295 description outside central inset")
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
		if button.visible and (button.position.x < 268.0 or button.position.x + button.size.x > 925.1 or button.position.y != 608.0):
			_fail("D295 unlocked tactic outside centered command holder: " + path)
			return
		if not button.toggle_mode or button.size.y != 38 or button.pressed.get_connections().is_empty():
			_fail("Battle original real tactical controls changed: " + path)
			return
		var engraving := button.get_node_or_null("DS3EtchedToken") as Control
		if engraving == null or engraving.get_script() == null or engraving.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D296 tactic plaque decoration is absent or intercepts press: " + path)
			return
		if str(engraving.get("order_symbol")) != path:
			_fail("D297 tactic heraldry not tied to its real order: " + path)
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
	print("D291_BATTLE_DS3_NATIVE_PASS: D295 approved minimal Gothic layout, original arena, native tactics and target selection")
	scene.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("D291_BATTLE_DS3_FAIL: " + reason)
	quit(1)
