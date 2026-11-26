extends RefCounted

const BONE := Color("e3c6a8")
const MUTED := Color("c4aa8f")
const RIBBON := preload("res://assets/pixel/main/menu_v2/primary.webp")
const CARD_SIZE := Vector2(282, 308)

static var _heading: SystemFont


static func heading_font() -> Font:
	if _heading == null:
		_heading = SystemFont.new()
		_heading.font_names = PackedStringArray(["Georgia", "Liberation Serif", "DejaVu Serif", "Times New Roman"])
	return _heading


static func prepare_screen(scene: Control) -> void:
	var frame := scene.get_node("Frame") as Control
	var row := frame.get_node("Cards") as HBoxContainer
	_place(row, Rect2(185, 271, 912, 308))
	row.add_theme_constant_override("separation", 33)
	_label(frame.get_node("Title"), Rect2(353, 188, 574, 40), 26, BONE)
	var wizard := frame.get_node("WizardLine") as Label
	wizard.autowrap_mode = TextServer.AUTOWRAP_OFF
	_label(wizard, Rect2(276, 231, 728, 27), 19, BONE)
	_label(frame.get_node("Rule"), Rect2(230, 648, 820, 29), 17, BONE)
	var help := Label.new()
	help.name = "ChoiceKeys"
	help.text = "← → — выбрать героя  ·  Enter — принять судьбу"
	help.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(help)
	_label(help, Rect2(300, 679, 680, 25), 16, MUTED)


static func prepare(button: Button) -> void:
	button.custom_minimum_size = CARD_SIZE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	for state in ["hover", "pressed", "focus"]:
		var rim := StyleBoxFlat.new()
		rim.draw_center = state == "pressed"
		rim.bg_color = Color("461f221f")
		rim.border_color = Color("ba967780")
		rim.set_border_width_all(1)
		rim.set_corner_radius_all(7)
		rim.set_expand_margin_all(-5)
		button.add_theme_stylebox_override(state, rim)

	var portrait := button.get_node("Portrait") as TextureRect
	_place(portrait, Rect2(8, 9, 266, 176))
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_label(button.get_node("ClassTitle"), Rect2(14, 190, 254, 32), 27, BONE)
	_label(button.get_node("Role"), Rect2(16, 223, 250, 22), 17, BONE)
	_label(button.get_node("Description"), Rect2(20, 255, 242, 43), 17, BONE)
	_label(button.get_node("Stats"), Rect2(20, 257, 242, 40), 19, BONE)

	var rim := Panel.new()
	rim.name = "SelectionRim"
	rim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rim.add_theme_stylebox_override("panel", button.get_theme_stylebox("hover"))
	button.add_child(rim)
	_place(rim, Rect2(Vector2.ZERO, CARD_SIZE))
	rim.hide()

	var chosen := Label.new()
	chosen.name = "ChosenSeal"
	chosen.text = "ВЫБРАН"
	chosen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(chosen)
	_label(chosen, Rect2(73, -12, 136, 28), 16, BONE)
	var badge := StyleBoxTexture.new()
	badge.texture = RIBBON
	chosen.add_theme_stylebox_override("normal", badge)
	chosen.hide()


static func set_state(button: Button, selected: bool, hovered: bool) -> void:
	button.get_node("ChosenSeal").visible = selected
	button.get_node("SelectionRim").visible = selected or hovered


static func prepare_confirm(button: Button) -> void:
	_place(button, Rect2(456, 597, 368, 49))
	prepare_action(button, 25)


static func prepare_action(button: Button, point: int) -> void:
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_override("font", heading_font())
	button.add_theme_font_size_override("font_size", point)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, BONE)
	button.add_theme_color_override("font_disabled_color", Color("968375"))
	var normal := StyleBoxEmpty.new()
	if button is OptionButton:
		normal.content_margin_left = 16.0
		normal.content_margin_right = 12.0
	button.add_theme_stylebox_override("normal", normal)
	for state in ["hover", "pressed", "hover_pressed", "disabled", "focus"]:
		var finish := StyleBoxFlat.new()
		finish.draw_center = state != "focus"
		finish.bg_color = Color("d6ae8621") if state == "hover" else Color("1a13144f")
		finish.set_corner_radius_all(5)
		finish.set_expand_margin_all(-6)
		finish.set_border_width_all(1)
		if button is OptionButton:
			finish.content_margin_left = 16.0
			finish.content_margin_right = 12.0
		finish.border_color = Color("a7816077") if state != "disabled" else Color("79706b30")
		button.add_theme_stylebox_override(state, finish)


static func _label(label: Label, bounds: Rect2, point: int, color: Color) -> void:
	label.add_theme_font_override("font", heading_font())
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("100c0b"))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(label, bounds)


static func _place(control: Control, bounds: Rect2) -> void:
	control.position = bounds.position
	control.size = bounds.size
