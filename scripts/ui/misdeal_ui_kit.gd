class_name MisdealUIKit
extends RefCounted

# Shared gothic/pixel UI chrome for the vertical slice.
# The kit deliberately modifies existing StyleBoxFlat resources at runtime so
# current layout/content margins and live gameplay text stay intact.

const GOLD := Color(0.93, 0.68, 0.36, 1.0)
const BRONZE := Color(0.67, 0.31, 0.19, 1.0)
const EMBER := Color(0.88, 0.25, 0.13, 1.0)
const STEEL := Color(0.42, 0.60, 0.72, 1.0)
const KNIGHT := Color(0.38, 0.61, 0.88, 1.0)
const RANGER := Color(0.42, 0.72, 0.39, 1.0)
const MAGE := Color(0.68, 0.43, 0.86, 1.0)

const TEXT := Color(0.94, 0.84, 0.70, 1.0)
const TEXT_HOVER := Color(1.0, 0.94, 0.80, 1.0)
const TEXT_MUTED := Color(0.48, 0.45, 0.45, 1.0)


static func apply_panel(panel: Panel, accent: Color = BRONZE, strong: bool = false) -> void:
	if panel == null:
		return
	var source := panel.get_theme_stylebox("panel") as StyleBoxFlat
	var style := source.duplicate() as StyleBoxFlat if source != null else StyleBoxFlat.new()
	style.bg_color = _panel_fill(accent, 0.94 if strong else 0.88)
	_set_border(style, 3 if strong else 2)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.90 if strong else 0.70)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.74 if strong else 0.58)
	style.shadow_size = 10 if strong else 6
	style.shadow_offset = Vector2(0.0, 3.0)
	_square_corners(style)
	panel.add_theme_stylebox_override("panel", style)
	add_corner_marks(panel, accent, 13.0 if strong else 10.0, 2.0)
	if strong:
		add_center_sigil(panel, accent)


static func apply_chip(panel: Panel, accent: Color = BRONZE) -> void:
	if panel == null:
		return
	var source := panel.get_theme_stylebox("panel") as StyleBoxFlat
	var style := source.duplicate() as StyleBoxFlat if source != null else StyleBoxFlat.new()
	style.bg_color = Color(0.010 + accent.r * 0.018, 0.008 + accent.g * 0.012, 0.012 + accent.b * 0.014, 0.90)
	_set_border(style, 1)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.62)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.36)
	style.shadow_size = 3
	style.shadow_offset = Vector2(0.0, 2.0)
	_square_corners(style)
	panel.add_theme_stylebox_override("panel", style)


static func apply_card_button(button: Button, accent: Color = BRONZE) -> void:
	if button == null:
		return
	_apply_button_styles(button, accent, true, false)
	add_corner_marks(button, accent, 10.0, 2.0)


static func apply_action_button(button: Button, accent: Color = BRONZE, strong: bool = false) -> void:
	if button == null:
		return
	_apply_button_styles(button, accent, false, strong)
	if strong:
		add_corner_marks(button, accent, 9.0, 2.0)


static func apply_title(label: Label, accent: Color = GOLD) -> void:
	if label == null:
		return
	label.add_theme_color_override("font_color", accent.lightened(0.12))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.96))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)


static func apply_subtitle(label: Label, accent: Color = BRONZE) -> void:
	if label == null:
		return
	label.add_theme_color_override("font_color", Color(
		0.64 + accent.r * 0.20,
		0.58 + accent.g * 0.16,
		0.56 + accent.b * 0.14,
		1.0
	))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.90))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)


static func add_corner_marks(host: Control, accent: Color, length: float = 10.0, thickness: float = 2.0) -> void:
	if host == null or host.get_node_or_null("_MisdealChrome") != null:
		return

	var overlay := Control.new()
	overlay.name = "_MisdealChrome"
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.z_index = 50
	host.add_child(overlay)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var c := Color(accent.r, accent.g, accent.b, 0.92)
	var inset := 5.0

	_add_bar(overlay, Vector2(0.0, 0.0), Vector2(inset, inset), Vector2(inset + length, inset + thickness), c)
	_add_bar(overlay, Vector2(0.0, 0.0), Vector2(inset, inset), Vector2(inset + thickness, inset + length), c)

	_add_bar(overlay, Vector2(1.0, 0.0), Vector2(-inset - length, inset), Vector2(-inset, inset + thickness), c)
	_add_bar(overlay, Vector2(1.0, 0.0), Vector2(-inset - thickness, inset), Vector2(-inset, inset + length), c)

	_add_bar(overlay, Vector2(0.0, 1.0), Vector2(inset, -inset - thickness), Vector2(inset + length, -inset), c)
	_add_bar(overlay, Vector2(0.0, 1.0), Vector2(inset, -inset - length), Vector2(inset + thickness, -inset), c)

	_add_bar(overlay, Vector2(1.0, 1.0), Vector2(-inset - length, -inset - thickness), Vector2(-inset, -inset), c)
	_add_bar(overlay, Vector2(1.0, 1.0), Vector2(-inset - thickness, -inset - length), Vector2(-inset, -inset), c)


static func add_center_sigil(host: Control, accent: Color) -> void:
	if host == null:
		return
	var overlay := host.get_node_or_null("_MisdealChrome") as Control
	if overlay == null or overlay.get_node_or_null("CenterSigil") != null:
		return

	var sigil := ColorRect.new()
	sigil.name = "CenterSigil"
	sigil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sigil.color = Color(accent.r, accent.g, accent.b, 0.88)
	sigil.anchor_left = 0.5
	sigil.anchor_right = 0.5
	sigil.anchor_top = 0.0
	sigil.anchor_bottom = 0.0
	sigil.offset_left = -4.0
	sigil.offset_right = 4.0
	sigil.offset_top = 3.0
	sigil.offset_bottom = 11.0
	sigil.pivot_offset = Vector2(4.0, 4.0)
	sigil.rotation = PI * 0.25
	overlay.add_child(sigil)


static func _apply_button_styles(button: Button, accent: Color, card: bool, strong: bool) -> void:
	var names: Array[String] = ["normal", "hover", "pressed", "disabled"]
	for style_name in names:
		var source := button.get_theme_stylebox(style_name) as StyleBoxFlat
		var style := source.duplicate() as StyleBoxFlat if source != null else StyleBoxFlat.new()
		var active := style_name == "hover" or style_name == "pressed"
		var disabled := style_name == "disabled"
		var pressed := style_name == "pressed"

		if disabled:
			style.bg_color = Color(0.016, 0.014, 0.018, 0.92)
			style.border_color = Color(0.22, 0.20, 0.21, 0.72)
			style.shadow_color = Color(0.0, 0.0, 0.0, 0.22)
		else:
			var energy := 0.070 if active else (0.050 if strong else 0.035)
			var alpha := 0.99 if card or strong else 0.94
			style.bg_color = Color(
				0.018 + accent.r * energy,
				0.012 + accent.g * energy * 0.74,
				0.016 + accent.b * energy * 0.72,
				alpha
			)
			style.border_color = Color(
				accent.r,
				accent.g,
				accent.b,
				1.0 if active else (0.92 if strong else 0.76)
			)
			style.shadow_color = Color(accent.r * 0.30, accent.g * 0.18, accent.b * 0.14, 0.34 if active else 0.18)

		_set_border(style, 3 if card or strong or active else 2)
		style.shadow_size = 10 if active else (7 if card or strong else 5)
		style.shadow_offset = Vector2(0.0, 3.0 if not pressed else 1.0)
		_square_corners(style)
		button.add_theme_stylebox_override(style_name, style)

	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_hover_color", TEXT_HOVER)
	button.add_theme_color_override("font_pressed_color", TEXT_HOVER)
	button.add_theme_color_override("font_disabled_color", TEXT_MUTED)


static func _panel_fill(accent: Color, alpha: float) -> Color:
	return Color(
		0.014 + accent.r * 0.018,
		0.009 + accent.g * 0.010,
		0.014 + accent.b * 0.012,
		alpha
	)


static func _set_border(style: StyleBoxFlat, width: int) -> void:
	style.border_width_left = width
	style.border_width_top = width
	style.border_width_right = width
	style.border_width_bottom = width


static func _square_corners(style: StyleBoxFlat) -> void:
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_right = 0
	style.corner_radius_bottom_left = 0
	style.anti_aliasing = false


static func _add_bar(
	parent: Control,
	anchor: Vector2,
	from_offset: Vector2,
	to_offset: Vector2,
	color: Color
) -> void:
	var bar := ColorRect.new()
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.color = color
	bar.anchor_left = anchor.x
	bar.anchor_right = anchor.x
	bar.anchor_top = anchor.y
	bar.anchor_bottom = anchor.y
	bar.offset_left = from_offset.x
	bar.offset_top = from_offset.y
	bar.offset_right = to_offset.x
	bar.offset_bottom = to_offset.y
	parent.add_child(bar)
