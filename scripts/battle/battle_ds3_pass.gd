extends RefCounted

# D298: Visual fidelity pass to the selected second Gothic battle reference.
# Four separate hand-authored ornament illustrations carry zero baked UI data.
# Preserve real data-backed UI, tactics and the authored battle arena.
# Gameplay, tactical data, unit positions, scene geometry and arena images
# stay in the production Battle. The ornate fragments are already approved
# D287 dossier art, never a baked picture of fake buttons or stats.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const WEBP_TEXTURE := preload("res://scripts/ui/runtime_webp_texture.gd")
const ENGRAVED_FRAME := preload("res://scripts/ui/battle_engraved_frame.gd")
const ORNAMENT_DIR := "res://assets/pixel/ui/squad_dossier_d287/"
const GOTHIC_ART_DIR := "res://assets/pixel/ui/battle_ds3_d298/"

const BRONZE := Color("#a66636")
const MOONSTEEL := Color("#526477")
const CRIMSON := Color("#62201e")
const PARCHMENT := Color("#dfb77e")
const PARCHMENT_BRIGHT := Color("#f2d3a2")
const SECONDARY := Color(0.80, 0.72, 0.65, 1.0)

static func apply(scene: Control) -> void:
	# Recompose only presentation Controls. Arena, spawning and AI are unchanged.
	_layout_panels(scene)
	for name in ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "SideObjectivePanel", "WizardCommentaryPanel"]:
		var panel := scene.get_node(name) as Panel
		var material := "wood" if name == "BottomHudPanel" else ("wager" if name == "FightHudPanel" else "steel")
		panel.add_theme_stylebox_override("panel", _material(material))
		var legacy := panel.get_node_or_null("_MisdealChrome") as CanvasItem
		if legacy != null:
			legacy.visible = false
		_draw_hardware(panel, name, material)

	# Two full-sized EMPTY, illustrated holder plates from the approved
	# material vocabulary. Labels, all three-to-five live tactics, preview,
	# Fight and optional objectives render separately on top.
	_svg_decor(scene.get_node("BottomHudPanel") as Panel, "DS3CommandPlate", "battle_command_plate.svg", Vector2.ZERO, Vector2(691, 133), Color(1, 1, 1, 0.93))
	_svg_decor(scene.get_node("FightHudPanel") as Panel, "DS3FightPlate", "battle_fight_plate.svg", Vector2.ZERO, Vector2(293, 133), Color(1, 1, 1, 0.86))
	# Art panels are actual independent transparent assets, not a full
	# screenshot. Their alpha never interferes with live Title/Status/Buttons.
	_svg_decor(scene.get_node("TopHudPanel") as Panel, "DS3Banner", "battle_banner.svg", Vector2(-18, -14), Vector2(87, 147), Color(1, 1, 1, 0.91))
	_svg_decor(scene.get_node("RunHudPanel") as Panel, "DS3ProgressMedallion", "battle_progress_seal.svg", Vector2(-15, -10), Vector2(67, 85), Color(1, 1, 1, 0.90))
	_svg_decor(scene.get_node("BottomHudPanel") as Panel, "DS3LeftFinial", "battle_filigree.svg", Vector2(8, -11), Vector2(66, 37), Color(1, 1, 1, 0.80))
	_svg_decor(scene.get_node("BottomHudPanel") as Panel, "DS3RightFinial", "battle_filigree.svg", Vector2(615, -11), Vector2(66, 37), Color(1, 1, 1, 0.80))
	_svg_decor(scene.get_node("FightHudPanel") as Panel, "DS3FightRibbon", "battle_fight_ribbon.svg", Vector2(-20, 12), Vector2(68, 108), Color(1, 1, 1, 0.74))

	_style_label(scene, "Title", PARCHMENT_BRIGHT, 23)
	_style_label(scene, "Status", SECONDARY, 12)
	_style_label(scene, "OrderLabel", PARCHMENT_BRIGHT, 16)
	_style_label(scene, "OrderDescription", SECONDARY, 13)
	_style_label(scene, "DealLabel", PARCHMENT_BRIGHT, 19)
	_style_label(scene, "RunConditionLabel", SECONDARY, 12)
	_style_label(scene, "WizardCommentary", PARCHMENT, 13)
	_apply_typography(scene)
	_ornament(scene.get_node("RunHudPanel") as Panel, "DS3ProgressSeal", "ruby_crest.webp", Vector2(7, 9), Vector2(30, 30), Vector2i(103, 103), Color(0.90, 0.76, 0.62, 0.72))
	for name in ["PartyLabel", "EnemyLabel"]:
		var side := scene.get_node(name) as Label
		_strip(side, "DS3SideDivider", Vector2(19, 23), Vector2(side.size.x - 38.0, 1), Color(0.79, 0.57, 0.36, 0.56))
	# The hint remains on the *real* preparation floor, not on the panel.
	var hint := scene.get_node("PlacementHint") as Label
	hint.modulate = Color(1.0, 1.0, 1.0, 0.91)
	hint.add_theme_color_override("font_color", Color(0.72, 0.83, 0.91, 1))

	for name in ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton", "SacrificeOrderButton", "DefianceOrderButton"]:
		var tactic := scene.get_node(name) as Button
		style_tactic(tactic, tactic.button_pressed, _accent_for(name))
	style_secondary(scene.get_node("TargetPreviewButton") as Button, MOONSTEEL)
	style_secondary(scene.get_node("RestartButton") as Button, MOONSTEEL)
	style_primary(scene.get_node("FightButton") as Button, CRIMSON)
	(scene.get_node("FightButton") as Button).add_theme_font_size_override("font_size", 27)
	style_primary(scene.get_node("ContinueButton") as Button, BRONZE)
	# This seal belongs only to the existing real primary action, never to
	# the battle background or a second floating fake button.
	_ornament(scene.get_node("FightButton") as Button, "DS3FightRubySeal", "ruby_crest.webp", Vector2(10, 11), Vector2(45, 45), Vector2i(103, 103), Color(1, 1, 1, 0.91))
	# Continue may take the place of Fight after win; retain its legibility
	# without making it look like a second Fight button.
	# All original Button.pressed/toggled handlers remain owned by battle.gd.


# Native 1280x720 D295 composition from approved concept 2. All positions
# concern pre-existing actual Control nodes, never simulated painted controls.
static func _layout_panels(scene: Control) -> void:
	_place(scene.get_node("TopHudPanel") as Control, Vector2(22, 14), Vector2(902, 72))
	_place(scene.get_node("RunHudPanel") as Control, Vector2(959, 14), Vector2(299, 78))
	_place(scene.get_node("Title") as Control, Vector2(103, 19), Vector2(815, 32))
	_place(scene.get_node("Status") as Control, Vector2(104, 50), Vector2(806, 30))
	_place(scene.get_node("DealLabel") as Control, Vector2(1004, 19), Vector2(236, 29))
	_place(scene.get_node("RunConditionLabel") as Control, Vector2(967, 49), Vector2(280, 38))
	_place(scene.get_node("PartyLabel") as Control, Vector2(115, 106), Vector2(166, 25))
	_place(scene.get_node("EnemyLabel") as Control, Vector2(1096, 106), Vector2(152, 25))
	_place(scene.get_node("BottomHudPanel") as Control, Vector2(251, 575), Vector2(691, 133))
	_place(scene.get_node("FightHudPanel") as Control, Vector2(949, 575), Vector2(293, 133))
	# Secondary objectives previously occupied the same lower-right region.
	# Relocate this real conditional panel so it cannot cover the Fight control.
	_place(scene.get_node("SideObjectivePanel") as Control, Vector2(22, 575), Vector2(216, 133))
	_place(scene.get_node("SideObjectivePanel/ObjectiveLabel") as Control, Vector2(10, 8), Vector2(196, 115))
	_place(scene.get_node("OrderLabel") as Control, Vector2(267, 581), Vector2(659, 21))
	_place(scene.get_node("OrderDescription") as Control, Vector2(277, 656), Vector2(637, 42))
	# The former 660px single-line hint could cover the Ranger/other units.
	# Put the real hint in the unused left command margin, and wrap long
	# encounter-specific instructions instead of drawing over combatant feet.
	_place(scene.get_node("PlacementHint") as Control, Vector2(30, 580), Vector2(211, 114))
	var hint_copy := scene.get_node("PlacementHint") as Label
	hint_copy.add_theme_font_size_override("font_size", 12)
	hint_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_copy.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(scene.get_node("TargetPreviewButton") as Control, Vector2(965, 582), Vector2(259, 30))
	_place(scene.get_node("FightButton") as Control, Vector2(964, 619), Vector2(262, 77))
	_place(scene.get_node("ContinueButton") as Control, Vector2(964, 619), Vector2(262, 77))
	_place(scene.get_node("RestartButton") as Control, Vector2(964, 619), Vector2(262, 77))
	var caption := scene.get_node("OrderLabel") as Label
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	(scene.get_node("Status") as Label).clip_text = true
	var condition := scene.get_node("RunConditionLabel") as Label
	condition.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	condition.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	condition.clip_text = true
	# Readable two-row summary; full RunState modifiers remain in a native tooltip.
	condition.mouse_filter = Control.MOUSE_FILTER_STOP
	(scene.get_node("RunHudPanel") as Panel).mouse_filter = Control.MOUSE_FILTER_STOP
	(scene.get_node("OrderDescription") as Label).vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	(scene.get_node("SideObjectivePanel/ObjectiveLabel") as Label).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for name in ["PartyLabel", "EnemyLabel"]:
		var side := scene.get_node(name) as Label
		side.add_theme_color_override("font_color", PARCHMENT)
		side.add_theme_font_size_override("font_size", 13)


# The actual RunState status string can have 1-6 rows. The upper-right badge
# has room for two lines; compact only the visible summary and keep the
# complete original Russian text on hover. No game bonuses are recomputed.
static func present_run_conditions(scene: Control) -> void:
	var condition := scene.get_node("RunConditionLabel") as Label
	var full_text := condition.text
	if full_text.is_empty():
		return
	condition.text = compact_run_conditions(full_text)
	condition.tooltip_text = full_text
	(scene.get_node("RunHudPanel") as Control).tooltip_text = full_text
	(scene.get_node("DealLabel") as Control).tooltip_text = full_text


static func compact_run_conditions(full_text: String) -> String:
	var rows := full_text.split("\n", false)
	if rows.is_empty():
		return ""
	var first := rows[0].replace(" • ", " · ").replace("УРОН", "УР").replace("АТАКИ", "АТК").replace("HP ", "HP").replace("УР ", "УР").replace("АТК ", "АТК")
	var summary: Array[String] = [first]
	if rows.size() > 1:
		var second := rows[1].replace("ДАВЛЕНИЕ ВРАГОВ", "ВРАГИ").replace(" • ", " · ").replace("УРОН", "УР").replace("HP ", "HP").replace("УР ", "УР")
		if rows.size() > 2:
			second += " · +%d" % (rows.size() - 2)
		summary.append(second)
	return "\n".join(summary)


# A rare wizard side objective occupies the left lower margin.
# Place instructions in the open upper sky in that case, never on top of
# a meaningful live objective or a character's lower combat floor.
static func position_placement_hint(scene: Control) -> void:
	var hint := scene.get_node("PlacementHint") as Label
	var active_objective := scene.get_node("SideObjectivePanel") as Panel
	if active_objective.visible:
		_place(hint, Vector2(298, 138), Vector2(676, 39))
		hint.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	else:
		_place(hint, Vector2(30, 580), Vector2(211, 114))
		hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


static func _place(control: Control, at: Vector2, dimensions: Vector2) -> void:
	control.position = at
	control.size = dimensions


# Called after Battle's existing 3/4/5-tactic unlock/configure logic. This is
# exclusively geometry: never changes active/disabled, handlers or selection.
static func layout_tactics(scene: Control) -> void:
	var active: Array[Button] = []
	for name in ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton", "SacrificeOrderButton", "DefianceOrderButton"]:
		var choice := scene.get_node(name) as Button
		if choice.visible:
			active.append(choice)
	if active.is_empty():
		return
	var left := 268.0
	var width := 657.0
	var gap := 8.0
	var cell_width := (width - gap * float(active.size() - 1)) / float(active.size())
	for i in range(active.size()):
		active[i].position = Vector2(left + float(i) * (cell_width + gap), 608)
		active[i].size = Vector2(cell_width, 38)


static func _apply_typography(scene: Control) -> void:
	# System serif is available on Windows (Georgia/Cambria) with cross-platform
	# Cyrillic fallbacks. No external font bytes or baked language in the art.
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia", "Cambria", "Noto Serif", "DejaVu Serif", "Times New Roman"])
	for name in ["Title", "DealLabel", "OrderLabel", "PartyLabel", "EnemyLabel"]:
		(scene.get_node(name) as Label).add_theme_font_override("font", serif)
	for name in ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton", "SacrificeOrderButton", "DefianceOrderButton", "FightButton", "ContinueButton"]:
		(scene.get_node(name) as Button).add_theme_font_override("font", serif)


static func _material(material: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	match material:
		"wood":
			style.bg_color = Color(0.052, 0.040, 0.038, 0.90)
			style.border_color = Color(0.62, 0.40, 0.23, 0.84)
			style.border_width_top = 2
			style.border_width_bottom = 1
			style.border_width_left = 1
			style.border_width_right = 1
			style.shadow_size = 5
		"wager":
			style.bg_color = Color(0.11, 0.041, 0.044, 0.91)
			style.border_color = Color(0.67, 0.42, 0.25, 0.86)
			style.border_width_top = 2
			style.border_width_bottom = 1
			style.border_width_left = 1
			style.border_width_right = 1
			style.shadow_size = 5
		_:
			style.bg_color = Color(0.028, 0.026, 0.033, 0.16)
			style.border_color = Color(0.52, 0.38, 0.27, 0.53)
			style.set_border_width_all(1)
			style.shadow_size = 2
	style.set_corner_radius_all(2)
	style.shadow_color = Color(0, 0, 0, 0.65)
	style.shadow_offset = Vector2(0, 3)
	return style


static func _draw_hardware(panel: Panel, prefix: String, material: String) -> void:
	if panel.has_node("DS3MaterialUpper"):
		return
	# An authored geometric relief sits below the existing live labels.
	# This is a real independent Control, never a flattened HUD mockup.
	var relief := ENGRAVED_FRAME.new() as Control
	relief.name = "DS3EngravedRelief"
	relief.set("kind", material)
	relief.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(relief)
	relief.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# The panel is already laid out before the decoration is created.
	relief.position = Vector2.ZERO
	relief.size = panel.size
	var w := panel.size.x
	var h := panel.size.y
	var warm := material != "steel"
	var trim := Color(0.73, 0.49, 0.27, 0.69) if warm else Color(0.67, 0.48, 0.31, 0.44)
	_strip(panel, "DS3MaterialUpper", Vector2(9, 5), Vector2(w - 18, 1), trim)
	_strip(panel, "DS3MaterialLower", Vector2(10, h - 7), Vector2(w - 20, 1), trim.darkened(0.38))
	if warm:
		_strip(panel, "DS3CapInset", Vector2(12, 12), Vector2(w - 24, 1), Color(0.85, 0.58, 0.32, 0.24))
		if material == "wood":
			_inset(panel, "DS3CommandHolder", Vector2(13, 32), Vector2(w - 26, 48), false)
			_inset(panel, "DS3OrderScroll", Vector2(19, 80), Vector2(w - 38, 43), true)
		else:
			_inset(panel, "DS3StrikeHolder", Vector2(10, 43), Vector2(w - 20, h - 52), true)
			_strip(panel, "DS3ActionDivider", Vector2(12, 40), Vector2(w - 24, 1), Color(0.78, 0.50, 0.28, 0.63))
		# Small source-authored D287 fragments, not the entire ornate framing
		# of concept one. These remain purely visual and mouse-ignoring.
		_ornament(panel, "DS3GiltLeft", "gilt_corner.webp", Vector2(3, 4), Vector2(22, 22), Vector2i(53, 53), Color(1, 0.90, 0.72, 0.59))
		var corner := _ornament(panel, "DS3GiltRight", "gilt_corner.webp", Vector2(w - 25, h - 25), Vector2(22, 22), Vector2i(53, 53), Color(1, 0.90, 0.72, 0.59))
		corner.pivot_offset = Vector2(11, 11)
		corner.rotation = PI
	else:
		if prefix == "TopHudPanel":
			_inset(panel, "DS3EncounterTitleInset", Vector2(13, 6), Vector2(w - 26, 31), true)
			_strip(panel, "DS3EncounterDivider", Vector2(21, 40), Vector2(w - 42, 1), Color(0.65, 0.43, 0.27, 0.43))
		elif prefix == "RunHudPanel":
			_inset(panel, "DS3CardProgressPlaque", Vector2(8, 6), Vector2(w - 16, 30), true)
			_strip(panel, "DS3ProgressDivider", Vector2(18, 40), Vector2(w - 36, 1), Color(0.65, 0.43, 0.27, 0.43))
		_strip(panel, "DS3SteelRivet", Vector2(11, h - 12), Vector2(13, 1), Color(0.71, 0.48, 0.32, 0.36))


static func _inset(panel: Panel, name: String, at: Vector2, dimensions: Vector2, scroll: bool) -> void:
	var inset := Panel.new()
	inset.name = name
	inset.position = at
	inset.size = dimensions
	inset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := StyleBoxFlat.new()
	var ledger := name == "DS3EncounterTitleInset" or name == "DS3CardProgressPlaque"
	mat.bg_color = Color(0.026, 0.022, 0.030, 0.27) if ledger else (Color(0.055, 0.032, 0.031, 0.91) if scroll else Color(0.023, 0.021, 0.026, 0.82))
	mat.border_color = Color(0.51, 0.36, 0.23, 0.30) if ledger else Color(0.43, 0.28, 0.17, 0.69)
	mat.set_border_width_all(1)
	mat.set_corner_radius_all(2)
	inset.add_theme_stylebox_override("panel", mat)
	panel.add_child(inset)


static func _strip(parent: Control, name: String, at: Vector2, dimensions: Vector2, tint: Color) -> void:
	var strip := ColorRect.new()
	strip.name = name
	strip.position = at
	strip.size = dimensions
	strip.color = tint
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(strip)


# A separate high-quality vector painting is imported by Godot as a genuine
# Texture2D (SVG source remains editable in Git). No copy of the conceptual
# screenshot and no painted text, counter, unit, button or health indicator.
static func _svg_decor(parent: Control, name: String, asset_name: String, at: Vector2, dimensions: Vector2, tint: Color) -> TextureRect:
	var existing := parent.get_node_or_null(name) as TextureRect
	if existing != null:
		return existing
	var art := TextureRect.new()
	art.name = name
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.position = at
	art.size = dimensions
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.modulate = tint
	art.texture = load(GOTHIC_ART_DIR + asset_name) as Texture2D
	if art.texture == null:
		push_error("D298 missing battle Gothic source: " + asset_name)
	parent.add_child(art)
	return art


static func _ornament(parent: Control, name: String, asset: String, at: Vector2, dimensions: Vector2, native_size: Vector2i, tint: Color) -> TextureRect:
	var existing := parent.get_node_or_null(name) as TextureRect
	if existing != null:
		return existing
	var image := TextureRect.new()
	image.name = name
	image.set_script(WEBP_TEXTURE)
	image.position = at
	image.size = dimensions
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_SCALE
	image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	image.modulate = tint
	parent.add_child(image)
	image.call("load_webp_path", ORNAMENT_DIR + asset, native_size)
	return image


static func _style_label(scene: Control, path: String, tone: Color, font_size: int) -> void:
	var label := scene.get_node(path) as Label
	label.add_theme_color_override("font_color", tone)
	label.add_theme_font_size_override("font_size", font_size)


static func style_tactic(button: Button, selected: bool, accent: Color) -> void:
	# This is called after legacy DS2 selector redraws. A new selected
	# appearance can never switch real tactics or unlock gameplay.
	if button == null:
		return
	_style_button(button, accent, selected, false)
	var inlay := button.get_node_or_null("DS3SelectedInlay") as ColorRect
	if inlay == null:
		inlay = ColorRect.new()
		inlay.name = "DS3SelectedInlay"
		inlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		inlay.anchor_right = 1.0
		inlay.offset_left = 12.0
		inlay.offset_right = -12.0
		inlay.offset_top = 33.0
		inlay.offset_bottom = 35.0
		button.add_child(inlay)
	inlay.color = Color(accent.r, accent.g, accent.b, 0.98)
	inlay.visible = selected
	var wax := button.get_node_or_null("DS3OrderMark") as ColorRect
	if wax == null:
		wax = ColorRect.new()
		wax.name = "DS3OrderMark"
		wax.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wax.position = Vector2(15, 16)
		wax.size = Vector2(8, 8)
		wax.pivot_offset = Vector2(4, 4)
		wax.rotation = PI / 4.0
		button.add_child(wax)
	wax.color = PARCHMENT_BRIGHT
	wax.visible = selected
	var relief := button.get_node_or_null("DS3EtchedToken") as Control
	if relief == null:
		relief = ENGRAVED_FRAME.new() as Control
		relief.name = "DS3EtchedToken"
		relief.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(relief)
		relief.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		relief.position = Vector2.ZERO
		relief.size = button.size
	relief.set("kind", "order_selected" if selected else "order")
	relief.set("order_symbol", button.name)
	relief.queue_redraw()
	button.add_theme_color_override("font_color", PARCHMENT_BRIGHT if selected else Color(0.82, 0.73, 0.61))
	button.add_theme_color_override("font_pressed_color", PARCHMENT_BRIGHT)
	button.add_theme_color_override("font_hover_color", PARCHMENT_BRIGHT)


static func style_primary(button: Button, accent: Color) -> void:
	if button == null:
		return
	_style_button(button, accent, false, true)
	button.add_theme_color_override("font_color", PARCHMENT_BRIGHT)
	button.add_theme_color_override("font_hover_color", Color(1, 0.95, 0.81))
	button.add_theme_color_override("font_pressed_color", Color(1, 0.96, 0.86))


static func style_secondary(button: Button, accent: Color) -> void:
	if button == null:
		return
	_style_button(button, accent, button.button_pressed, false)
	button.add_theme_color_override("font_color", PARCHMENT)
	button.add_theme_color_override("font_hover_color", PARCHMENT_BRIGHT)


static func _accent_for(path: String) -> Color:
	if path == "SacrificeOrderButton":
		return Color("#bc5045")
	if path == "DefianceOrderButton":
		return Color("#779cba")
	return BRONZE


static func _style_button(button: Button, accent: Color, selected: bool, primary: bool) -> void:
	var center := Color(0.035, 0.026, 0.031, 0.97)
	if selected:
		center = Color(0.31, 0.139, 0.076, 0.99)
	if primary:
		center = Color(0.35, 0.057, 0.049, 0.99)
	var stroke := Color(accent.r, accent.g, accent.b, 0.99 if selected or primary else 0.57)
	_button_style(button, "normal", center, stroke, 2 if selected or primary else 1, 5 if primary else 2)
	_button_style(button, "hover", center.lightened(0.13), PARCHMENT, 2, 6)
	_button_style(button, "pressed", center.lightened(0.07), PARCHMENT_BRIGHT, 2, 3)
	_button_style(button, "hover_pressed", center.lightened(0.16), PARCHMENT_BRIGHT, 2, 5)
	_button_style(button, "disabled", Color(0.03, 0.024, 0.028, 0.83), Color(0.3, 0.24, 0.21, 0.45), 1, 1)


static func _button_style(button: Button, name: String, color: Color, line: Color, thickness: int, shadow: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = line
	style.set_border_width_all(thickness)
	style.set_corner_radius_all(3)
	style.shadow_color = Color(0, 0, 0, 0.65)
	style.shadow_size = shadow
	style.shadow_offset = Vector2(0, 2)
	style.content_margin_left = 5.0
	style.content_margin_right = 5.0
	button.add_theme_stylebox_override(name, style)
