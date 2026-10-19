class_name MisdealUIKit
extends RefCounted

# Shared gothic/pixel UI chrome for the vertical slice.
# The kit deliberately modifies existing StyleBoxFlat resources at runtime so
# current layout/content margins and live gameplay text stay intact.

# Design System 2.0: opt-in Fate Spread material palette (art-direction targets).
# Do not replace existing live token values without a reviewed screen migration.
const TABLE_OBSIDIAN := Color("#100c0d")
const RITUAL_CRIMSON := Color("#62201e")
const AGED_BRONZE := Color("#a66636")
const PARCHMENT_WARM := Color("#dfb77e")
const MOONLIT_STEEL := Color("#334758")

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

# Design System 1.0 foundations. Keep existing colors above as the canonical
# runtime palette: battle, cards, and tabletop already import this kit.
const VOID := Color(0.006, 0.004, 0.009, 1.0)
const TEXT_SECONDARY := Color(0.80, 0.73, 0.65, 1.0)
const TEXT_ON_DARK := Color(0.97, 0.93, 0.87, 1.0)
const STATUS_SUCCESS := Color(0.42, 0.75, 0.46, 1.0)
const STATUS_DANGER := Color(0.90, 0.32, 0.25, 1.0)

const BASE_VIEWPORT := Vector2i(1280, 720)
const SPACE_1 := 4
const SPACE_2 := 8
const SPACE_3 := 12
const SPACE_4 := 16
const SPACE_6 := 24
const SPACE_8 := 32

const TYPE_MICRO := 10
const TYPE_CAPTION := 12
const TYPE_META := 14
const TYPE_BODY := 16
const TYPE_SECTION := 20
const TYPE_TITLE := 28
const TYPE_DISPLAY := 36

const BORDER_HAIRLINE := 1
const BORDER_NORMAL := 2
const BORDER_STRONG := 3
const CORNER_RADIUS := 0
const BUTTON_HEIGHT := 40
const BUTTON_HEIGHT_PRIMARY := 48

# Advisory layer bands, not replacement values for existing battle Node2D
# depth-sorting. Use for newly built Control/CanvasLayer UI only.
const LAYER_WORLD := 0
const LAYER_GAMEPLAY_FEEDBACK := 10
const LAYER_HUD := 20
const LAYER_MODAL := 40
const LAYER_TRANSITION := 60


static func apply_text_role(target: Label, role: String = "body", accent: Color = TEXT) -> void:
	# Opt-in typography. Do not silently resize approved current layouts.
	if target == null:
		return
	var font_size := TYPE_BODY
	match role:
		"micro":
			font_size = TYPE_MICRO
		"caption":
			font_size = TYPE_CAPTION
		"meta":
			font_size = TYPE_META
		"section":
			font_size = TYPE_SECTION
		"title":
			font_size = TYPE_TITLE
		"display":
			font_size = TYPE_DISPLAY
	target.add_theme_font_size_override("font_size", font_size)
	target.add_theme_color_override("font_color", accent)
	target.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.90))
	target.add_theme_constant_override("shadow_offset_x", 1)
	target.add_theme_constant_override("shadow_offset_y", 1)


static func apply_button_minimum(target: Button, primary: bool = false) -> void:
	# Designed for new controls; the existing screens keep their authored geometry.
	if target == null:
		return
	var minimum := BUTTON_HEIGHT_PRIMARY if primary else BUTTON_HEIGHT
	var required_size := target.custom_minimum_size
	required_size.y = maxf(required_size.y, float(minimum))
	target.custom_minimum_size = required_size


static func apply_panel(target, accent: Color = BRONZE, strong: bool = false) -> void:
	var panel: Control = target as Control
	if panel == null:
		return
	var source: StyleBoxFlat = panel.get_theme_stylebox("panel") as StyleBoxFlat
	var style: StyleBoxFlat = StyleBoxFlat.new()
	if source != null:
		style = source.duplicate() as StyleBoxFlat
	style.bg_color = _panel_fill(accent, 0.94 if strong else 0.88)
	_set_border(style, BORDER_STRONG if strong else BORDER_NORMAL)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.90 if strong else 0.70)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.74 if strong else 0.58)
	style.shadow_size = 10 if strong else 6
	style.shadow_offset = Vector2(0.0, 3.0)
	_square_corners(style)
	panel.add_theme_stylebox_override("panel", style)
	add_corner_marks(panel, accent, 13.0 if strong else 10.0, 2.0)
	if strong:
		add_center_sigil(panel, accent)


static func apply_chip(target, accent: Color = BRONZE) -> void:
	var panel := target as Control
	if panel == null:
		return
	var source: StyleBoxFlat = panel.get_theme_stylebox("panel") as StyleBoxFlat
	var style: StyleBoxFlat = StyleBoxFlat.new()
	if source != null:
		style = source.duplicate() as StyleBoxFlat
	style.bg_color = Color(0.010 + accent.r * 0.018, 0.008 + accent.g * 0.012, 0.012 + accent.b * 0.014, 0.90)
	_set_border(style, BORDER_HAIRLINE)
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


# Compact modular battle chrome, migrated from battle.gd without any pixel
# change. Keep this distinct from the ornate table/card chrome above.
static func apply_battle_panel(panel: Panel, accent: Color = BRONZE, alpha: float = 0.68) -> void:
	if panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(
		0.010 + accent.r * 0.010,
		0.008 + accent.g * 0.006,
		0.012 + accent.b * 0.008,
		clampf(alpha, 0.0, 1.0)
	)
	_set_border(style, BORDER_HAIRLINE)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.42)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
	style.shadow_size = 4
	style.shadow_offset = Vector2(0.0, 2.0)
	# Compatibility: preserve the existing battle panel's 2px corner radius.
	_set_corner_radius(style, 2)
	panel.add_theme_stylebox_override("panel", style)


static func apply_battle_button(button: Button, accent: Color = BRONZE, primary: bool = false) -> void:
	if button == null:
		return
	for style_name in ["normal", "hover", "pressed", "disabled"]:
		var style := StyleBoxFlat.new()
		var active: bool = style_name == "hover" or style_name == "pressed"
		var disabled: bool = style_name == "disabled"
		var pressed: bool = style_name == "pressed"
		if disabled:
			style.bg_color = Color(0.012, 0.010, 0.014, 0.46)
			style.border_color = Color(0.20, 0.18, 0.20, 0.42)
		else:
			var energy := 0.070 if active else (0.055 if primary else 0.030)
			var panel_alpha := 0.90 if primary else (0.82 if active else 0.68)
			style.bg_color = Color(
				0.012 + accent.r * energy,
				0.009 + accent.g * energy * 0.65,
				0.014 + accent.b * energy * 0.60,
				panel_alpha
			)
			style.border_color = Color(
				accent.r,
				accent.g,
				accent.b,
				0.94 if pressed else (0.74 if active else 0.48)
			)
		_set_border(style, BORDER_NORMAL if primary or pressed else BORDER_HAIRLINE)
		style.shadow_color = Color(0.0, 0.0, 0.0, 0.34 if active else 0.20)
		style.shadow_size = 4 if active else 2
		style.shadow_offset = Vector2(0.0, 2.0 if not pressed else 1.0)
		_set_corner_radius(style, 2)
		button.add_theme_stylebox_override(style_name, style)
	_apply_button_font_colors(button)


# Opt-in selected state for a choice/tactic; does not change button_pressed,
# toggle_mode, or control behavior. Reapply when the selection changes.
static func apply_selected_button(button: Button, selected: bool, accent: Color = GOLD) -> void:
	if button == null:
		return
	# Recreate a stable base rather than layering a permanent tinted override.
	_apply_button_styles(button, accent, false, false)
	if not selected:
		return
	for name in ["normal", "hover", "pressed", "hover_pressed"]:
		var base: StyleBoxFlat = button.get_theme_stylebox(name) as StyleBoxFlat
		if base == null:
			continue
		var style := base.duplicate() as StyleBoxFlat
		style.bg_color = Color(0.075 + accent.r * 0.080, 0.050 + accent.g * 0.052, 0.038 + accent.b * 0.038, 0.98)
		style.border_color = Color(accent.r, accent.g, accent.b, 0.97)
		_set_border(style, BORDER_STRONG)
		_square_corners(style)
		button.add_theme_stylebox_override(name, style)
	button.add_theme_color_override("font_color", TEXT_HOVER)


# A panel-style variant for readable help text. It is not a global
# tooltip override and cannot interfere with existing native tooltips.
static func apply_tooltip_panel(panel: PanelContainer, accent: Color = STEEL) -> void:
	if panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.023, 0.019, 0.025, 0.97)
	_set_border(style, BORDER_HAIRLINE)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.73)
	style.content_margin_left = SPACE_4
	style.content_margin_top = SPACE_3
	style.content_margin_right = SPACE_4
	style.content_margin_bottom = SPACE_3
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.52)
	style.shadow_size = 5
	_square_corners(style)
	panel.add_theme_stylebox_override("panel", style)


# Native hover tooltip factory, intended for new controls implementing
# Control._make_custom_tooltip(). The returned node belongs to Godot's
# tooltip popup: do not parent it to the requesting control.
static func make_tooltip(message: String, accent: Color = STEEL) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = Vector2(180.0, 0.0)
	apply_tooltip_panel(panel, accent)
	var label := Label.new()
	label.text = message
	label.custom_minimum_size.x = 180.0
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	apply_text_role(label, "caption", TEXT)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(label)
	return panel


# In-world card art and labels remain separate; this draws an optional
# simple card surface for reuse in Inspect/Reward panels, not gameplay art.
static func apply_card_surface(panel: PanelContainer, accent: Color = BRONZE, selected: bool = false) -> void:
	if panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = _panel_fill(accent, 0.97 if selected else 0.89)
	_set_border(style, BORDER_STRONG if selected else BORDER_NORMAL)
	style.border_color = Color(accent.r, accent.g, accent.b, 0.92 if selected else 0.55)
	style.content_margin_left = SPACE_4
	style.content_margin_top = SPACE_4
	style.content_margin_right = SPACE_4
	style.content_margin_bottom = SPACE_4
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.58)
	style.shadow_size = 7 if selected else 4
	_square_corners(style)
	panel.add_theme_stylebox_override("panel", style)


# Screen-pass typography changes contrast only. Existing .tscn size, line
# wrapping, color-coded card role, and geometry stay authored per screen.
static func apply_screen_copy(target: Label, accent: Color = TEXT_SECONDARY, emphatic: bool = false) -> void:
	if target == null:
		return
	target.add_theme_color_override("font_color", accent)
	target.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.95 if emphatic else 0.88))
	target.add_theme_constant_override("shadow_offset_x", 1)
	target.add_theme_constant_override("shadow_offset_y", 1)


# Main menu is a transparent hotspot over approved splash art. Never replace
# its authored transparent Normal/Hover/Focus StyleBoxes with filled buttons.
static func apply_splash_hotspot(button: Button) -> void:
	if button == null:
		return
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_hover_color", TEXT_HOVER)
	button.add_theme_color_override("font_pressed_color", TEXT_HOVER)
	button.add_theme_color_override("font_focus_color", TEXT_HOVER)
	button.add_theme_color_override("font_disabled_color", TEXT_MUTED)


# Restores the exact existing tactile offer-card frame used on the table.
# RunState never enters UIKit: gameplay supplies only the semantic flags.
static func apply_offer_card_frame(button: Button, boss: bool = false, marked: bool = false, held: bool = false) -> void:
	if button == null:
		return
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.032, 0.020, 0.021, 0.992)
	_set_border(normal, BORDER_STRONG)
	normal.border_color = Color(0.66, 0.42, 0.20, 1.0)
	normal.shadow_color = Color(0, 0, 0, 0.68)
	normal.shadow_size = 8

	var hover := normal.duplicate() as StyleBoxFlat
	_set_border(hover, 4)
	hover.border_color = Color(0.98, 0.62, 0.26, 1.0)
	hover.shadow_color = Color(0.48, 0.12, 0.03, 0.58)
	hover.shadow_size = 12

	if boss:
		normal.border_color = Color(0.72, 0.20, 0.12, 1.0)
		hover.border_color = Color(1.0, 0.42, 0.18, 1.0)
	elif marked:
		normal.border_color = Color(0.92, 0.48, 0.12, 1.0)
		normal.shadow_color = Color(0.62, 0.13, 0.03, 0.62)
		normal.shadow_size = 12
		hover.border_color = Color(1.0, 0.72, 0.22, 1.0)
		hover.shadow_color = Color(0.82, 0.22, 0.04, 0.72)
		hover.shadow_size = 16
	elif held:
		normal.border_color = Color(0.42, 0.68, 0.84, 1.0)
		hover.border_color = Color(0.62, 0.84, 1.0, 1.0)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)



# D274: scoped parchment card border, never applied to the Fate Spread overlay.
static func apply_parchment_offer_card_frame(button: Button, boss: bool = false, marked: bool = false, held: bool = false) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#160e0b")
	_set_border(normal, 4)
	normal.border_color = Color("#8d542d")
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.85)
	normal.shadow_size = 12
	var hover := normal.duplicate() as StyleBoxFlat
	hover.border_color = Color("#e8ae64")
	hover.shadow_color = Color(0.75, 0.30, 0.08, 0.68)
	hover.shadow_size = 17
	if boss:
		normal.border_color = Color("#9a382d")
		hover.border_color = Color("#e5714a")
	elif marked:
		normal.border_color = Color("#d58b3b")
		normal.shadow_color = Color(0.62, 0.16, 0.03, 0.68)
	elif held:
		normal.border_color = Color("#72868c")
		hover.border_color = Color("#a5c7cf")
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	button.add_theme_stylebox_override("disabled", normal.duplicate() as StyleBoxFlat)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

# Unlike apply_selected_button (regular action style), keep the compact
# battle button base and accent only the ACTUAL selected toggle. Visible
# distinction cannot rely solely on button_pressed or a subtle text tint.
static func apply_battle_order_choice(button: Button, selected: bool, accent: Color = GOLD) -> void:
	if button == null:
		return
	apply_battle_button(button, accent, false)
	if not selected:
		if button.has_theme_stylebox_override("hover_pressed"):
			button.remove_theme_stylebox_override("hover_pressed")
		return

	var base := button.get_theme_stylebox("pressed") as StyleBoxFlat
	if base == null:
		return
	var style := base.duplicate() as StyleBoxFlat
	# Bronze remains the default inactive button, gold marks active orders.
	# Special sacrifice/defiance orders retain their ember/steel identity.
	var selected_accent: Color = GOLD if accent == BRONZE else accent
	style.bg_color = Color(0.055 + selected_accent.r * 0.070, 0.038 + selected_accent.g * 0.038, 0.028 + selected_accent.b * 0.022, 0.91)
	style.border_color = Color(selected_accent.r, selected_accent.g, selected_accent.b, 0.96)
	_set_border(style, BORDER_NORMAL)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.36)
	style.shadow_size = 4
	for name in ["pressed", "hover_pressed"]:
		button.add_theme_stylebox_override(name, style)
	button.add_theme_color_override("font_pressed_color", TEXT_HOVER)


static func apply_title(target, accent: Color = GOLD) -> void:
	var label: Control = target as Control
	if label == null:
		return
	label.add_theme_color_override("font_color", accent.lightened(0.12))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.96))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)


static func apply_subtitle(target, accent: Color = BRONZE) -> void:
	var label := target as Control
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
		var source: StyleBoxFlat = button.get_theme_stylebox(style_name) as StyleBoxFlat
		var style: StyleBoxFlat = StyleBoxFlat.new()
		if source != null:
			style = source.duplicate() as StyleBoxFlat
		var active: bool = style_name == "hover" or style_name == "pressed"
		var disabled: bool = style_name == "disabled"
		var pressed: bool = style_name == "pressed"

		if disabled:
			style.bg_color = Color(0.016, 0.014, 0.018, 0.92)
			style.border_color = Color(0.22, 0.20, 0.21, 0.72)
			style.shadow_color = Color(0.0, 0.0, 0.0, 0.22)
		else:
			var energy: float = 0.070 if active else (0.050 if strong else 0.035)
			var alpha: float = 0.99 if card or strong else 0.94
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

		_set_border(style, BORDER_STRONG if card or strong or active else BORDER_NORMAL)
		style.shadow_size = 10 if active else (7 if card or strong else 5)
		style.shadow_offset = Vector2(0.0, 3.0 if not pressed else 1.0)
		_square_corners(style)
		button.add_theme_stylebox_override(style_name, style)

	_apply_button_font_colors(button)


static func _apply_button_font_colors(button: Button) -> void:
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
	_set_corner_radius(style, CORNER_RADIUS)


static func _set_corner_radius(style: StyleBoxFlat, radius: int) -> void:
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
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


# DS2 material helpers are opt-in: live 1.0 screens remain untouched.
# Use in isolated previews until explicitly approved in a running Godot build.
static func apply_v2_material_plate(target: Control, prominent: bool = false) -> void:
	if target == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.060, 0.042, 0.043, 0.94 if prominent else 0.89)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = AGED_BRONZE if prominent else AGED_BRONZE.darkened(0.28)
	style.content_margin_left = SPACE_6
	style.content_margin_right = SPACE_6
	style.content_margin_top = SPACE_4
	style.content_margin_bottom = SPACE_4
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.82)
	style.shadow_size = 12 if prominent else 7
	style.shadow_offset = Vector2(0.0, 4.0)
	_square_corners(style)
	target.add_theme_stylebox_override("panel", style)


static func apply_v2_parchment_plate(target: Control) -> void:
	if target == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.76, 0.65, 0.48, 0.99)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.36, 0.21, 0.13, 1.0)
	_square_corners(style)
	target.add_theme_stylebox_override("panel", style)


static func apply_v2_reward_card(button: Button, selected: bool = false) -> void:
	if button == null:
		return
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var style := StyleBoxFlat.new()
		var focused: bool = state == "focus"
		var active: bool = state == "hover" or state == "pressed"
		style.bg_color = Color(0.075, 0.046, 0.044, 0.97) if selected or active else Color(0.043, 0.030, 0.032, 0.96)
		style.border_width_left = 3 if selected else 2
		style.border_width_right = 3 if selected else 2
		style.border_width_top = 3 if selected else 2
		style.border_width_bottom = 3 if selected else 2
		style.border_color = PARCHMENT_WARM if selected or focused else (AGED_BRONZE if active else AGED_BRONZE.darkened(0.24))
		style.shadow_color = Color(0.0, 0.0, 0.0, 0.78)
		style.shadow_size = 11 if selected or active else 6
		style.shadow_offset = Vector2(0.0, 4.0)
		_square_corners(style)
		button.add_theme_stylebox_override(state, style)
	button.add_theme_color_override("font_color", PARCHMENT_WARM)
	button.add_theme_color_override("font_hover_color", TEXT_ON_DARK)
