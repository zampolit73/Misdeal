extends RefCounted

# D293: FIRST actual tabletop-material DS3 combat rework.
# Gameplay, tactical data, unit positions, scene geometry and arena images
# stay in the production Battle. The ornate fragments are already approved
# D287 dossier art, never a baked picture of fake buttons or stats.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const WEBP_TEXTURE := preload("res://scripts/ui/runtime_webp_texture.gd")
const ORNAMENT_DIR := "res://assets/pixel/ui/squad_dossier_d287/"

const BRONZE := Color("#a66636")
const MOONSTEEL := Color("#526477")
const CRIMSON := Color("#62201e")
const PARCHMENT := Color("#dfb77e")
const PARCHMENT_BRIGHT := Color("#f2d3a2")
const SECONDARY := Color(0.80, 0.72, 0.65, 1.0)

static func apply(scene: Control) -> void:
	# The upper display stays subdued; only the lower interaction islands
	# receive physical wood/metal detailing. The battle floor is untouched.
	for name in ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "SideObjectivePanel", "WizardCommentaryPanel"]:
		var panel := scene.get_node(name) as Panel
		var material := "wood" if name == "BottomHudPanel" else ("wager" if name == "FightHudPanel" else "steel")
		panel.add_theme_stylebox_override("panel", _material(material))
		var legacy := panel.get_node_or_null("_MisdealChrome") as CanvasItem
		if legacy != null:
			legacy.visible = false
		_draw_hardware(panel, name, material)

	_style_label(scene, "Title", PARCHMENT_BRIGHT, 26)
	_style_label(scene, "Status", SECONDARY, 14)
	_style_label(scene, "OrderLabel", PARCHMENT_BRIGHT, 14)
	_style_label(scene, "OrderDescription", SECONDARY, 12)
	_style_label(scene, "DealLabel", PARCHMENT_BRIGHT, 18)
	_style_label(scene, "RunConditionLabel", SECONDARY, 11)
	_style_label(scene, "WizardCommentary", PARCHMENT, 13)
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
	style_primary(scene.get_node("ContinueButton") as Button, BRONZE)
	# This seal belongs only to the existing real primary action, never to
	# the battle background or a second floating fake button.
	_ornament(scene.get_node("FightButton") as Button, "DS3FightRubySeal", "ruby_crest.webp", Vector2(13, 14), Vector2(47, 47), Vector2i(103, 103), Color(1, 1, 1, 0.91))
	# Continue may take the place of Fight after win; retain its legibility
	# without making it look like a second Fight button.
	# All original Button.pressed/toggled handlers remain owned by battle.gd.


static func _material(material: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	match material:
		"wood":
			style.bg_color = Color(0.108, 0.058, 0.044, 0.92)
			style.border_color = Color(0.59, 0.37, 0.21, 0.92)
			style.border_width_top = 3
			style.border_width_bottom = 2
			style.border_width_left = 2
			style.border_width_right = 2
			style.shadow_size = 6
		"wager":
			style.bg_color = Color(0.129, 0.051, 0.049, 0.91)
			style.border_color = Color(0.66, 0.38, 0.21, 0.90)
			style.border_width_top = 3
			style.border_width_bottom = 2
			style.border_width_left = 2
			style.border_width_right = 2
			style.shadow_size = 6
		_:
			style.bg_color = Color(0.040, 0.033, 0.041, 0.85)
			style.border_color = Color(0.38, 0.39, 0.40, 0.55)
			style.set_border_width_all(1)
			style.shadow_size = 3
	style.set_corner_radius_all(4)
	style.shadow_color = Color(0, 0, 0, 0.68)
	style.shadow_offset = Vector2(0, 3)
	return style


static func _draw_hardware(panel: Panel, prefix: String, material: String) -> void:
	if panel.has_node("DS3MaterialUpper"):
		return
	var w := panel.size.x
	var h := panel.size.y
	var warm := material != "steel"
	var trim := Color(0.73, 0.49, 0.27, 0.64) if warm else Color(0.47, 0.52, 0.56, 0.45)
	_strip(panel, "DS3MaterialUpper", Vector2(11, 6), Vector2(w - 22, 1), trim)
	_strip(panel, "DS3MaterialLower", Vector2(11, h - 8), Vector2(w - 22, 1), trim.darkened(0.35))
	if warm:
		# Long-line chrome is no longer the entire design: genuine layered
		# command tray, double-metal cap and inset holders carry hierarchy.
		_strip(panel, "DS3CapInset", Vector2(15, 11), Vector2(w - 30, 1), Color(0.84, 0.56, 0.30, 0.28))
		if material == "wood":
			_inset(panel, "DS3CommandHolder", Vector2(11, 33), Vector2(w - 22, 51), false)
			_inset(panel, "DS3OrderScroll", Vector2(25, 89), Vector2(w - 50, 32), true)
		else:
			_inset(panel, "DS3StrikeHolder", Vector2(11, 45), Vector2(w - 22, h - 53), true)
			_strip(panel, "DS3ActionDivider", Vector2(12, 43), Vector2(w - 24, 1), Color(0.81, 0.51, 0.28, 0.7))
		# Reuse small native image elements approved for the Dossier: purposeful
		# metalwork, not a generated poster/infographic on top of gameplay.
		_ornament(panel, "DS3GiltLeft", "gilt_corner.webp", Vector2(3, 4), Vector2(26, 26), Vector2i(53, 53), Color(1, 0.90, 0.72, 0.75))
		var corner := _ornament(panel, "DS3GiltRight", "gilt_corner.webp", Vector2(w - 29, h - 29), Vector2(26, 26), Vector2i(53, 53), Color(1, 0.90, 0.72, 0.75))
		corner.pivot_offset = Vector2(13, 13)
		corner.rotation = PI
	else:
		# Small top panels stay readable, no fiddly symbols over long text.
		_strip(panel, "DS3SteelRivet", Vector2(11, h - 13), Vector2(17, 2), Color(0.71, 0.48, 0.32, 0.40))


static func _inset(panel: Panel, name: String, at: Vector2, dimensions: Vector2, scroll: bool) -> void:
	var inset := Panel.new()
	inset.name = name
	inset.position = at
	inset.size = dimensions
	inset.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mat := StyleBoxFlat.new()
	mat.bg_color = Color(0.055, 0.032, 0.031, 0.91) if scroll else Color(0.023, 0.021, 0.026, 0.82)
	mat.border_color = Color(0.43, 0.28, 0.17, 0.69)
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
		wax.position = Vector2(12, 15)
		wax.size = Vector2(6, 6)
		wax.pivot_offset = Vector2(3, 3)
		wax.rotation = PI / 4.0
		button.add_child(wax)
	wax.color = PARCHMENT_BRIGHT
	wax.visible = selected
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
