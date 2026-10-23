extends SceneTree

# D291 native real Battle smoke: active tactics and UI in the production scene,
# using RunState and the original battle script (not a mock preview or bitmap).
const SCENE_PATH := "res://scenes/battle/battle.tscn"
const APPROVED_BATTLE_FRAGMENTS := preload("res://scripts/ui/battle_reference_fragments.gd")
const D303_APPROVED := preload("res://scripts/ui/battle_approved_modules.gd")

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

	# D304: allow both a code-only checkout with D301 fallback and a
	# checkout with all five approved D303 binary art skins installed.
	var approved_art: bool = D303_APPROVED.available()
	# D295 selected concept 2: slim top ledgers, centered live command tray,
	# separated right action; conditional objective moved left, no collisions.
	var panels := ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "WizardCommentaryPanel", "SideObjectivePanel"]
	for path in panels:
		var plate := scene.get_node(path) as Panel
		var full_paint: bool = approved_art and (path == "BottomHudPanel" or path == "FightHudPanel")
		# D311 replaced the SideObjectivePanel's background with a real Wizard
		# plaque. Its transparent panel is intentional: a D295 border would
		# duplicate the approved painted frame. Verify the artwork nodes too.
		var wizard_plaque := plate.get_node_or_null("D307WizardArt") as Control if path == "SideObjectivePanel" else null
		var plate_style := plate.get_theme_stylebox("panel")
		if wizard_plaque != null:
			if not (plate_style is StyleBoxEmpty):
				_fail("D311 Wizard plaque must not have a second panel border")
				return
			if plate.get_node_or_null("D307WizardHeading") == null or plate.get_node_or_null("D307WizardBody") == null or plate.get_node_or_null("D312WizardReward") == null:
				_fail("D311 Wizard plaque is missing live objective text nodes")
				return
		elif full_paint:
			if not (plate_style is StyleBoxEmpty):
				_fail("D304 original frame still visible behind painted material: " + path)
				return
		else:
			var style := plate_style as StyleBoxFlat
			var expected_shadow: int = 5 if path == "BottomHudPanel" or path == "FightHudPanel" else 2
			if style == null or style.border_width_left != 1 or style.shadow_size != expected_shadow:
				_fail("D295 selected material not loaded: " + path)
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
	# D299 accepts the exact rendered material decorations isolated from the
	# second approved image. Vector-only D298 pieces remain in Git for rollback
	# but MUST NOT appear over the painted counterparts in production.
	for old_path in ["TopHudPanel/DS3Banner", "RunHudPanel/DS3ProgressMedallion", "RunHudPanel/DS3ProgressSeal", "FightHudPanel/DS3FightRibbon"]:
		if scene.get_node_or_null(old_path) != null:
			_fail("D299 stale vector artwork overlaps approved painted fragment: " + old_path)
			return
	var painted := {
		"TopHudPanel/DS3PaintedBanner": Vector2(96, 165),
		"RunHudPanel/DS3PaintedMedallion": Vector2(74, 98),
		"BottomHudPanel/DS3PaintedCandles": Vector2(51, 150),
		"FightHudPanel/DS3PaintedWaxRibbon": Vector2(73, 157),
		"BottomHudPanel/DS3CommandPlate": Vector2(691, 133),
		"BottomHudPanel/DS3LeftFinial": Vector2(66, 37),
		"BottomHudPanel/DS3RightFinial": Vector2(66, 37),
		"FightHudPanel/DS3FightPlate": Vector2(293, 133),
	}
	for art_path in painted:
		var ornament := scene.get_node_or_null(art_path) as TextureRect
		if ornament == null or ornament.texture == null:
			_fail("D299 approved or supporting Battle art failed to decode: " + str(art_path))
			return
		if ornament.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D299 art intercepts a real Battle button or tooltip: " + str(art_path))
			return
		if ornament.size != painted[art_path]:
			_fail("D299 artwork outside authored screen dimensions: " + str(art_path))
			return
	# D300 upgrades the actual artwork, not the canvas coordinates.
	# Keep D299 packed source as rollback but never load its smaller pixels.
	var high_quality_sizes := {
		"banner": Vector2(111, 189),
		"medallion": Vector2(88, 113),
		"candles": Vector2(57, 172),
		"wax_ribbon": Vector2(84, 178),
	}
	for id in high_quality_sizes:
		var tex := APPROVED_BATTLE_FRAGMENTS.get_fragment(id) as Texture2D
		if tex == null or tex.get_image() == null or tex.get_image().is_empty():
			_fail("D300 source alpha WebP did not decode: " + str(id))
			return
		if tex.get_size() != high_quality_sizes[id]:
			_fail("D300 source material is still the downsampled D299 art: " + str(id))
			return
		var raw_image := tex.get_image()
		if raw_image.get_pixel(0, 0).a > 0.02:
			_fail("D300 fragment transparent corner became a black rectangle: " + str(id))
			return
	if approved_art:
		var source_sizes := {
			"command_game.webp": Vector2(1100, 278),
			"fight_panel_game.webp": Vector2(650, 388),
			"idle_game.webp": Vector2(540, 111),
			"selected_game.webp": Vector2(540, 111),
			"fight_button_game.webp": Vector2(524, 154)
		}
		for asset_name in source_sizes:
			var native_asset := load("res://assets/pixel/ui/battle_ds3_d303/" + asset_name) as Texture2D
			if native_asset == null or native_asset.get_size() != source_sizes[asset_name]:
				_fail("D304 source-derived painted module missing/imported at wrong resolution: " + asset_name)
				return
		var command_art := scene.get_node_or_null("BottomHudPanel/D304CommandArt") as TextureRect
		var fight_art := scene.get_node_or_null("FightHudPanel/D304FightArt") as TextureRect
		if command_art == null or fight_art == null or command_art.texture == null or fight_art.texture == null:
			_fail("D304 approved full-size UI modules were not imported")
			return
		if command_art.mouse_filter != Control.MOUSE_FILTER_IGNORE or fight_art.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D304 painted material may not intercept a live UI control")
			return
		if command_art.size != Vector2(691, 175) or fight_art.size != Vector2(293, 175):
			_fail("D304 approved module scaling does not match native UI footprint")
			return
		for art_path in ["BottomHudPanel/DS3CommandPlate", "FightHudPanel/DS3FightPlate", "BottomHudPanel/DS3PaintedCandles", "FightHudPanel/DS3PaintedWaxRibbon"]:
			var old_fragment := scene.get_node(art_path) as CanvasItem
			if old_fragment.visible:
				_fail("D304 duplicate old SVG/painted fragment overlaps approved module: " + art_path)
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
		# D301: every one of the 3-5 unlocked original Buttons previews the
		# description in-place, never floating a duplicate Godot tooltip.
		if not button.tooltip_text.is_empty():
			_fail("D301 tactic still creates a duplicate floating tooltip: " + path)
			return
		if button.mouse_entered.get_connections().is_empty() or button.mouse_exited.get_connections().is_empty():
			_fail("D301 order preview signals missing: " + path)
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
	var formation_preview := scene.get_node("FormationOrderButton") as Button
	var live_description := scene.get_node("OrderDescription") as Label
	var selected_hunt_description: String = live_description.text
	formation_preview.mouse_entered.emit()
	if not live_description.text.begins_with("ПРОСМОТР: СТРОЙ") or scene.get("tactical_order") != "hunt":
		_fail("D301 hover preview should show Formation without selecting it")
		return
	formation_preview.mouse_exited.emit()
	if live_description.text != selected_hunt_description:
		_fail("D301 leaving a tactic must restore the actually selected Hunt description")
		return
	# Hovering the selected order should never hide its live description.
	hunt.mouse_entered.emit()
	if live_description.text != selected_hunt_description:
		_fail("D301 selected tactic hover should not replace its own description")
		return
	hunt.mouse_exited.emit()
	var assault := scene.get_node("AssaultOrderButton") as Button
	var hunt_inlay := hunt.get_node_or_null("DS3SelectedInlay") as ColorRect
	var assault_inlay := assault.get_node_or_null("DS3SelectedInlay") as ColorRect
	var token := hunt.get_node_or_null("DS3OrderMark") as ColorRect
	if approved_art:
		var selected_skin := hunt.get_theme_stylebox("normal") as StyleBoxTexture
		var idle_skin := assault.get_theme_stylebox("normal") as StyleBoxTexture
		if selected_skin == null or idle_skin == null or selected_skin.texture == idle_skin.texture:
			_fail("D304 live Hunt selection does not change to an approved skin")
			return
		if hunt_inlay.visible or assault_inlay.visible or token.visible:
			_fail("D304 old vector token overlay obscures approved painted skin")
			return
		if str((hunt.get_node("DS3EtchedToken") as Control).get("kind")) != "order_symbol_only":
			_fail("D304 selected real order icon is missing or adds double borders")
			return
	else:
		var hunt_style := hunt.get_theme_stylebox("normal") as StyleBoxFlat
		var assault_style := assault.get_theme_stylebox("normal") as StyleBoxFlat
		if hunt_style == null or assault_style == null or hunt_style.border_width_left <= assault_style.border_width_left:
			_fail("DS3 fallback selected order highlight not reapplied after original selector")
			return
		if hunt_inlay == null or assault_inlay == null or not hunt_inlay.visible or assault_inlay.visible:
			_fail("D293 fallback Hunt token / idle Assault visibility wrong")
			return
		if token == null or not token.visible:
			_fail("D293 fallback selected heraldic mark missing")
			return
		if hunt_style.bg_color.r <= assault_style.bg_color.r + 0.10:
			_fail("D292 fallback selected tactical fill lacks contrast")
			return
	scene.call("_select_tactical_order", "formation", false)
	if scene.get("tactical_order") != "formation" or not (scene.get_node("FormationOrderButton") as Button).button_pressed:
		_fail("real Formation action or UI state not preserved")
		return
	if approved_art:
		var formation_skin := (scene.get_node("FormationOrderButton") as Button).get_theme_stylebox("normal") as StyleBoxTexture
		var idle_hunt_skin := hunt.get_theme_stylebox("normal") as StyleBoxTexture
		if formation_skin == null or idle_hunt_skin == null or formation_skin.texture == idle_hunt_skin.texture:
			_fail("D304 formation selection did not swap genuine painted tactics")
			return
	else:
		if hunt_inlay.visible or not (scene.get_node("FormationOrderButton/DS3SelectedInlay") as ColorRect).visible:
			_fail("D293 fallback selected token did not follow Formation")
			return
		if token.visible:
			_fail("D293 fallback selected Hunt icon stayed visible after switching to Formation")
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
	print("D291_BATTLE_DS3_NATIVE_PASS: D304 painted modules / fallback, D301 live tactics, arena and targeting")
	scene.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("D291_BATTLE_DS3_FAIL: " + reason)
	quit(1)
