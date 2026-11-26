extends Control
## System confirmations share Main Menu V2 materials, without changing save rules.
const PRIMARY := preload("res://assets/pixel/main/menu_v2/primary.webp")
const SECONDARY := preload("res://assets/pixel/main/menu_v2/secondary.webp")
const MENU_TYPE := preload("res://scripts/class_select/class_select_card_skin.gd")
const BONE := Color("ddc1a5")
const COPY := Color("e5dbc4")

# Authored corner contours of the existing 327px menu plates. Only dialog
# derivatives get alpha; the original Main Menu resources remain untouched.
const PRIMARY_CORNERS := [[14, 13, 14, 13, 12, 11, 11, 10, 9, 8, 6, 5, 1], [13, 13, 13, 13, 12, 11, 10, 9, 8, 7, 6, 4, 0], [0, 13, 13, 13, 13, 10, 9, 8, 7, 6, 5, 4, 5, 1], [0, 12, 13, 13, 13, 10, 9, 8, 7, 6, 5, 3, 1, 0]]
const SECONDARY_CORNERS := [[0, 14, 14, 14, 13, 12, 12, 11, 10, 9, 7, 6, 3], [0, 14, 14, 14, 14, 13, 12, 12, 11, 10, 8, 6, 5, 3], [0, 0, 14, 14, 14, 14, 13, 13, 12, 11, 10, 9, 7, 3], [0, 0, 14, 15, 15, 13, 13, 12, 11, 10, 9, 10, 9, 7, 3]]
static var _dialog_textures: Dictionary = {}

var _previous_focus: Control
var _finished := false


func present_new_game(begin_run: Callable) -> void:
	_build_panel("НОВАЯ ИГРА", Vector2(620, 454))
	var panel := get_node("Panel") as Control
	_label(panel, "Message", "Текущее прохождение будет сброшено.", Rect2(30, 76, 560, 32), 22, COPY)
	var next_run := _button(panel, "NextRunButton", "НОВЫЙ ЗАБЕГ", Rect2(36, 122, 548, 80), SECONDARY, begin_run.bind(false), "Сохранить Витраж Памяти")
	var reset := _button(panel, "ResetButton", "НАЧАТЬ С НУЛЯ", Rect2(36, 216, 548, 80), PRIMARY, begin_run.bind(true), "Витраж Памяти — 0/24")
	_label(panel, "Note", "Архив Волшебника будет сохранён.\nПрежний прогресс останется в резервной копии.", Rect2(30, 308, 560, 60), 19, COPY)
	var cancel_button := _button(panel, "CancelButton", "ОТМЕНА [ESC]", Rect2(164, 383, 292, 49), SECONDARY, Callable())
	_link_focus([next_run, reset, cancel_button])


func present_return_to_menu(leave_run: Callable) -> void:
	_build_panel("В ГЛАВНОЕ МЕНЮ", Vector2(620, 306))
	var panel := get_node("Panel") as Control
	_label(panel, "Message", "Изменения после последней контрольной\nточки будут потеряны.", Rect2(30, 80, 560, 64), 22, COPY)
	var confirm := _button(panel, "ReturnButton", "ВЕРНУТЬСЯ В МЕНЮ", Rect2(75, 157, 470, 62), PRIMARY, leave_run)
	var cancel_button := _button(panel, "CancelButton", "ОТМЕНА [ESC]", Rect2(164, 234, 292, 49), SECONDARY, Callable())
	_link_focus([confirm, cancel_button])


func _build_panel(title: String, dimensions: Vector2) -> void:
	_previous_focus = get_viewport().gui_get_focus_owner()
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var scrim := ColorRect.new()
	scrim.name = "Scrim"
	scrim.color = Color(0.0, 0.0, 0.0, 0.58)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := Panel.new()
	panel.name = "Panel"
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	# Nine-slice the actual secondary menu plate: preserve its aged bronze
	# corners and bevel; tile the dark stone instead of stretching it vertically.
	var frame := plate_style(SECONDARY)
	frame.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	frame.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	panel.add_theme_stylebox_override("panel", frame)
	add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.offset_left = -dimensions.x * 0.5
	panel.offset_right = dimensions.x * 0.5
	panel.offset_top = -dimensions.y * 0.5
	panel.offset_bottom = dimensions.y * 0.5
	_label(panel, "Title", title, Rect2(24, 19, dimensions.x - 48, 56), 36, BONE)


func _button(parent: Control, node_name: String, value: String, bounds: Rect2, texture: Texture2D, callback: Callable, subtitle: String = "") -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = value
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_override("font", MENU_TYPE.heading_font())
	button.add_theme_font_size_override("font_size", 24)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, BONE)
	for state in ["normal", "hover", "pressed", "hover_pressed"]:
		var style := plate_style(texture)
		style.content_margin_top = 0
		style.content_margin_bottom = 25 if not subtitle.is_empty() else 0
		if state == "hover":
			style.modulate_color = Color(1.10, 1.07, 1.04)
		elif state in ["pressed", "hover_pressed"]:
			style.modulate_color = Color("d4bfb3")
		button.add_theme_stylebox_override(state, style)
	var focus := plate_style(texture)
	# Highlight the actual bevel instead of drawing a second rectangular rim.
	focus.draw_center = false
	focus.modulate_color = Color(1.45, 1.30, 1.12)
	button.add_theme_color_override("font_focus_color", Color("f2d4a8"))
	button.add_theme_stylebox_override("focus", focus)
	parent.add_child(button)
	button.position = bounds.position
	button.size = bounds.size
	if not subtitle.is_empty():
		_label(button, "Subtitle", subtitle, Rect2(16, 43, bounds.size.x - 32, 28), 19, COPY)
		button.tooltip_text = subtitle
	button.pressed.connect(_finish.bind(callback))
	return button


static func plate_style(texture: Texture2D) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = _dialog_plate_texture(texture)
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, 18)
	return style


# Remove only the exterior matte of the original buttons. The 1px alpha
# fringe preserves the softer outer bronze/shadow pixels on the new panel.
static func _dialog_plate_texture(source: Texture2D) -> Texture2D:
	if _dialog_textures.has(source):
		return _dialog_textures[source] as Texture2D
	var pixels := source.get_image()
	if pixels == null or pixels.is_empty():
		return source
	# The dummy renderer can expose the source Image itself; always copy.
	pixels = pixels.duplicate() as Image
	if pixels.is_compressed() and pixels.decompress() != OK:
		return source
	pixels.convert(Image.FORMAT_RGBA8)
	var primary := source == PRIMARY
	var contours: Array = PRIMARY_CORNERS if primary else SECONDARY_CORNERS
	var w := pixels.get_width()
	var h := pixels.get_height()
	for y in range(h):
		var bottom := h - 1 - y
		if bottom < (1 if primary else 2) or (not primary and y == 0):
			pixels.fill_rect(Rect2i(0, y, w, 1), Color(0, 0, 0, 0))
			continue
		var left := 1 if primary else 3
		var right := 0 if primary else 3
		if y < contours[0].size():
			left = contours[0][y]
		elif bottom < contours[2].size():
			left = contours[2][bottom]
		if y < contours[1].size():
			right = contours[1][y]
		elif bottom < contours[3].size():
			right = contours[3][bottom]
		_trim_matte_row(pixels, y, left, false)
		_trim_matte_row(pixels, y, right, true)
	var isolated := ImageTexture.create_from_image(pixels)
	_dialog_textures[source] = isolated
	return isolated


static func _trim_matte_row(pixels: Image, y: int, count: int, from_right: bool) -> void:
	var w := pixels.get_width()
	for offset in range(count):
		var x := w - 1 - offset if from_right else offset
		var pixel := pixels.get_pixel(x, y)
		pixel.a *= 0.35 if offset == count - 1 else 0.0
		pixels.set_pixel(x, y, pixel)


func _label(parent: Control, node_name: String, value: String, bounds: Rect2, point: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# All copy here is authored with explicit line breaks. Wrapping a new
	# zero-width Label inflates its minimum height before its rect is set;
	# Godot then preserves that oversized rect after the width is assigned.
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.add_theme_font_override("font", MENU_TYPE.heading_font())
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	label.position = bounds.position
	label.size = bounds.size
	return label


func _link_focus(buttons: Array[Button]) -> void:
	for i in buttons.size():
		var button := buttons[i]
		var before := button.get_path_to(buttons[posmod(i - 1, buttons.size())])
		var after := button.get_path_to(buttons[(i + 1) % buttons.size()])
		button.focus_previous = before
		button.focus_neighbor_top = before
		button.focus_neighbor_left = before
		button.focus_next = after
		button.focus_neighbor_bottom = after
		button.focus_neighbor_right = after
	# Never let an accidental Enter reset progress.
	buttons.back().grab_focus()


func _input(event: InputEvent) -> void:
	if visible and not _finished and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		cancel()


func cancel() -> void:
	_finish(Callable())


func _finish(callback: Callable) -> void:
	if _finished:
		return
	_finished = true
	hide()
	queue_free()
	if is_instance_valid(_previous_focus) and _previous_focus.is_visible_in_tree():
		_previous_focus.grab_focus()
	if callback.is_valid():
		callback.call()
