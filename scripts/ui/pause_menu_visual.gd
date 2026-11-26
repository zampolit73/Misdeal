extends RefCounted
## Pause Menu Visual V1: presentation only. RunMenu owns every action and save gate.

const PLATE_PATH := "res://assets/pixel/ui/pause_menu_v1/pause_plate.webp"
const SKIN_PATH := "res://scripts/class_select/class_select_card_skin.gd"
const BONE := Color("e3c6a8")
const MUTED := Color("c4aa8f")
const PANEL_SIZE := Vector2(370, 568)
const ACTIONS := [
	["ResumeButton", "ПРОДОЛЖИТЬ ИГРУ"],
	["SaveButton", "СОХРАНИТЬ"],
	["LoadButton", "ЗАГРУЗИТЬ ИГРУ"],
	["SaveExitButton", "СОХРАНИТЬ И ВЫЙТИ"],
	["MainMenuButton", "В ГЛАВНОЕ МЕНЮ"]
]
const ROW_TOPS := [169.0, 223.0, 275.0, 326.0, 377.0]

static func build(root: Control, callbacks: Array[Callable], can_save: bool, message: String) -> Label:
	var scrim := ColorRect.new()
	scrim.name = "Scrim"
	scrim.color = Color(0.0, 0.0, 0.0, 0.52)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var panel := Control.new()
	panel.name = "PausePanel"
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.offset_left = -PANEL_SIZE.x * 0.5
	panel.offset_right = PANEL_SIZE.x * 0.5
	panel.offset_top = -PANEL_SIZE.y * 0.5
	panel.offset_bottom = PANEL_SIZE.y * 0.5

	var art := TextureRect.new()
	art.name = "PausePlate"
	art.texture = load(PLATE_PATH) as Texture2D
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(art)
	art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_label(panel, "Title", "ПАУЗА", Rect2(40, 82, 290, 43), 35, BONE)
	_label(panel, "Subtitle", "Партия приостановлена", Rect2(40, 133, 290, 28), 17, MUTED)

	var enabled: Array[Button] = []
	for i in ACTIONS.size():
		var button := Button.new()
		button.name = ACTIONS[i][0]
		button.text = ACTIONS[i][1]
		button.focus_mode = Control.FOCUS_ALL
		panel.add_child(button)
		load(SKIN_PATH).prepare_action(button, 20)
		# Retain the painted bevel; the real control supplies hover, press and focus.
		_style_button(button)
		button.position = Vector2(34, ROW_TOPS[i])
		button.size = Vector2(302, 42)
		if i == 1 or i == 3:
			button.disabled = not can_save
			if button.disabled:
				button.tooltip_text = "Сохранение доступно только на контрольной точке."
		button.pressed.connect(callbacks[i])
		if not button.disabled:
			enabled.append(button)
	for i in enabled.size():
		var button := enabled[i]
		var before := button.get_path_to(enabled[posmod(i - 1, enabled.size())])
		var after := button.get_path_to(enabled[(i + 1) % enabled.size()])
		button.focus_neighbor_top = before
		button.focus_neighbor_bottom = after
		button.focus_previous = before
		button.focus_next = after
		button.focus_neighbor_left = before
		button.focus_neighbor_right = after

	var status := _label(panel, "Status", message, Rect2(35, 445, 300, 66), 16, BONE)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.size = Vector2(300, 66)
	_label(panel, "EscapeHint", "ESC — продолжить", Rect2(54, 522, 262, 27), 16, MUTED)
	enabled[0].grab_focus()
	return status

static func _label(parent: Control, node_name: String, value: String, bounds: Rect2, point: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", load(SKIN_PATH).heading_font())
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color("100c0b"))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	parent.add_child(label)
	label.position = bounds.position
	label.size = bounds.size
	return label

static func _style_button(button: Button) -> void:
	for state in ["hover", "pressed", "hover_pressed", "disabled", "focus"]:
		var rim := StyleBoxFlat.new()
		rim.set_corner_radius_all(5)
		rim.set_expand_margin_all(-3)
		rim.set_border_width_all(2 if state == "focus" else 1)
		rim.draw_center = state != "focus"
		rim.bg_color = Color("d0a47822") if state == "hover" else Color("110d0d66")
		rim.border_color = Color("d1aa77") if state == "focus" else Color("b28d6366")
		if state == "disabled":
			rim.bg_color = Color("0b0909a6")
			rim.border_color = Color("6d605244")
		button.add_theme_stylebox_override(state, rim)
