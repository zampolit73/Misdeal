extends Node
## Presentation for the existing event buttons. Costs and restrictions come from their scene adapters.

const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const MOTION := preload("res://scripts/ui/ui_motion.gd")
const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const SKIN := preload("res://scripts/ui/event_choice_skin.gd")
const SELECTED_INK := Color("f0dfc1")
const BONE := Color("e1d0b8")
const INK := UNIFIED.GOLD
const MUTED := Color("c5b3a4")
const ROMAN := ["I", "II", "III", "IV"]
const ROW_BOUNDS := Rect2(96, 169, 1088, SKIN.HEIGHT)

var _cards: Array[Button] = []
var _actions: Array[Button] = []
var _pending: Button
var _hint: Label
var _footer: Panel
var _result: Label
var _reader_button: Button
var _reader_text := ""
var _finished := false
var _hovered: Button


func track(buttons: Array[Button]) -> void:
	for button in buttons:
		button.pressed.connect(_remember.bind(button))


func build(surface: Control, row: HBoxContainer, title: Label, quote: Label, description: Label,
		result: Label, stats: Array[Label], cards: Array[Button]) -> void:
	_result = result
	_plate(surface, "EventStats", Rect2(96, 17, 1088, 33), true)
	_plate(surface, "EventHeader", Rect2(96, 46, 1088, 119))
	for index in stats.size():
		var bounds := Rect2(123, 21, 1034, 24)
		if stats.size() == 2:
			bounds = Rect2(123, 21, 150, 24) if index == 0 else Rect2(281, 21, 876, 24)
		_style_label(stats[index], bounds, 13, BONE, false)
		stats[index].text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		stats[index].tooltip_text = stats[index].text
		stats[index].mouse_filter = Control.MOUSE_FILTER_PASS
	_style_label(title, Rect2(123, 54, 1034, 38), 30, BONE, false)
	title.add_theme_font_override("font", SKIN.serif())
	_style_label(quote, Rect2(123, 90, 1034, 23), 15, BONE, false)
	_style_label(description, Rect2(123, 110, 1034, 45), 15, BONE, true)
	quote.max_lines_visible = 1
	quote.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	description.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_reader_text = "%s\n\n%s" % [quote.text, description.text]
	_reader_button = _small_button(surface, "Читать полностью", Rect2(997, 122, 160, 28))
	_reader_button.pressed.connect(_open_reader.bind(title.text))
	_reader_button.hide()
	if description.get_line_count() > 2 or quote.get_theme_font("font").get_string_size(
			quote.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x > quote.size.x:
		description.size.x = 867
		_reader_button.show()
	description.max_lines_visible = 2

	for button in cards:
		if button.visible:
			_cards.append(button)
	var width := 260 if _cards.size() == 4 else 312
	var needs_extra_copy := false
	for index in _cards.size():
		if _build_card(_cards[index], index, width):
			needs_extra_copy = true
	if needs_extra_copy:
		for button in _cards:
			_enlarge_copy(button, width)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	row.z_index = 3
	_place(row, ROW_BOUNDS)

	_footer = _plate(surface, "EventContext", Rect2(96, 641, 1088, 58), true)
	_hint = _label(_footer, "Hint", "", Rect2(27, 6, 1034, 46), 14, BONE, true)
	_style_label(result, Rect2(123, 647, 1034, 46), 15, BONE, true)
	result.hide()
	_update_hint()
	_wire_focus()


func show_result(continue_button: Button = null) -> void:
	_finished = true
	_hint.hide()
	for button in _cards:
		MOTION.stop(button, &"event_lift")
		button.position.y = 0.0
		var restriction := button.get_node("Copy/Availability") as Label
		restriction.text = "ВЫБРАНО" if button == _pending else ""
		_place(restriction, Rect2(28, 370, button.size.x - 56, 30))
		restriction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		restriction.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		restriction.add_theme_color_override("font_color", SELECTED_INK)
		restriction.hide()
		var action := button.get_node("Copy/UnifiedAction") as TextureRect
		action.texture = UNIFIED.button_texture("pressed" if button == _pending else "disabled")
		action.get_node("Caption").text = "ВЫБРАНО" if button == _pending else "ЗАВЕРШЕНО"
		action.get_node("Caption").add_theme_color_override("font_color", UNIFIED.GOLD if button == _pending else UNIFIED.DISABLED)
		SKIN.shade(button, 1.16 if button == _pending else 0.8)
		button.focus_mode = Control.FOCUS_NONE
	_result.show()
	if continue_button != null:
		continue_button.show()
		UI.apply_action_button(continue_button, UI.GOLD, true)
		continue_button.z_index = 3
		_place(continue_button, Rect2(923, 649, 234, 42))
		_result.size.x = 789
		continue_button.grab_focus()
	_fit(_result, 13)


func _remember(button: Button) -> void:
	if not _finished and not button.disabled and button.visible:
		_pending = button


func _build_card(button: Button, index: int, width: int) -> bool:
	var raw := button.text
	var parts := raw.split("\n\n", true, 1)
	var action := String(button.get_meta("event_action", parts[0])).strip_edges()
	var detail := String(button.get_meta("event_outcome", parts[1] if parts.size() > 1 else "")).strip_edges()
	var cost := String(button.get_meta("event_cost", "Без платы"))
	var restriction := String(button.get_meta("event_restriction", ""))
	var kind := String(button.get_meta("event_kind", "ВЫБОР"))
	var accent: Color = {
		"КРОВЬ": Color("efa89d"), "МОНЕТА": UNIFIED.GOLD, "РИТУАЛ": Color("d8bedc"),
		"ОТКАЗ": Color("c7cfc8"), "РИСК": Color("efbc89"),
	}.get(kind, UNIFIED.INK)
	if button.disabled:
		accent = accent.lerp(UNIFIED.MUTED, 0.65)
	button.tooltip_text = "%s\n%s\n%s" % [action, cost, detail]
	if not restriction.is_empty():
		button.tooltip_text += "\n" + restriction
	button.text = ""
	button.custom_minimum_size = Vector2(width, SKIN.HEIGHT)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	for child in button.get_children():
		if child is CanvasItem and child.name != "ChoiceArt":
			child.hide()
	var art := button.get_node("ChoiceArt") as TextureRect
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.modulate = Color("d6cec8") if button.disabled else Color.WHITE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(art, UNIFIED.art_rect(button.custom_minimum_size, SKIN.SPLIT))
	SKIN.mount(button, button.custom_minimum_size)
	SKIN.shade(button, 0.95 if button.disabled else 1.0)
	var category := _label(button, "ActionType", "%s  /  %s" % [ROMAN[index], kind],
		Rect2(20, 8, width - 40, 34), 16, accent, false)
	category.z_index = 2
	category.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	category.add_theme_font_override("font", SKIN.serif())
	var copy := Control.new()
	copy.name = "Copy"
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.z_index = 2
	button.add_child(copy)
	_place(copy, Rect2(Vector2.ZERO, button.custom_minimum_size))
	var title := _label(copy, "Action", action, Rect2(16, 185, width - 32, 40), 19, INK, true)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", SKIN.serif(true))
	_fit(title, 13)
	var text_width := width - 36
	var cost_ink := UNIFIED.GOLD
	var cost_label := _label(copy, "Cost", cost, Rect2(18, 228, text_width, 38), 15, cost_ink, true)
	cost_label.add_theme_font_override("font", UNIFIED.serif())
	cost_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_fit(cost_label, 13)
	var outcome_y := 228 + maxi(28, cost_label.get_line_count() * (cost_label.get_line_height() + 1) + 6)
	var availability := _label(copy, "Availability", restriction, Rect2(18, 365, text_width, 36),
		14, UNIFIED.NEGATIVE, true)
	availability.add_theme_font_override("font", UNIFIED.serif())
	availability.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_fit(availability, 12)
	var body_bottom := 402
	if not restriction.is_empty():
		body_bottom -= availability.get_line_count() * (availability.get_line_height() + 1) + 4
	var body := _label(copy, "Outcome", detail, Rect2(18, outcome_y, text_width, body_bottom - outcome_y),
		15 if width == 260 else 16, UNIFIED.COPY, true)
	body.add_theme_font_override("font", UNIFIED.serif())
	body.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_fit(body, 13)
	var plate := UNIFIED.action(copy, Rect2(22, 407, width - 44, 36), "НЕДОСТУПНО" if button.disabled else "ВЫБРАТЬ", 15)
	plate.texture = UNIFIED.button_texture("disabled" if button.disabled else "idle")
	if button.disabled:
		plate.get_node("Caption").add_theme_color_override("font_color", UNIFIED.DISABLED)
	button.set_meta("event_action", action)
	button.set_meta("event_restriction", restriction)
	_bind(button)
	return _text_height(body) > body.size.y


func _enlarge_copy(button: Button, width: int) -> void:
	SKIN.enlarge_copy(button)
	var art := button.get_node("ChoiceArt") as TextureRect
	art.size.y -= SKIN.COPY_EXPANSION
	for field in ["Action", "Cost", "Outcome"]:
		var label := button.get_node("Copy/" + field) as Label
		label.position.y -= SKIN.COPY_EXPANSION
	var body := button.get_node("Copy/Outcome") as Label
	body.size.y += SKIN.COPY_EXPANSION
	body.add_theme_font_size_override("font_size", 15 if width == 260 else 16)
	_fit(body, 12)


func _bind(button: Button) -> void:
	_actions.append(button)
	button.mouse_entered.connect(_enter.bind(button))
	button.mouse_exited.connect(_exit.bind(button))
	button.focus_entered.connect(_focus_changed.bind(button))
	button.focus_exited.connect(_focus_changed.bind(button))
	if button in _cards:
		button.button_down.connect(_lift.bind(button, true))
		button.button_up.connect(_lift.bind(button, false))


func _enter(button: Button) -> void:
	_hovered = button
	_update_hint()
	_lift(button, false)


func _exit(button: Button) -> void:
	if _hovered == button:
		_hovered = null
	_update_hint()
	_lift(button, false)


func _lift(button: Button, held: bool) -> void:
	if _finished or button.disabled or button not in _cards:
		return
	_refresh_frame(button, held)
	var height := -4.0 if _hovered == button and not held else 0.0
	var tween := MOTION.replace_tween(button, &"event_lift")
	tween.tween_property(button, "position:y", height, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _focus_changed(button: Button) -> void:
	_update_hint()
	_refresh_frame(button)


func _refresh_frame(button: Button, held: bool = false) -> void:
	if _finished or button.disabled or button not in _cards:
		return
	var highlighted := _hovered == button or button.has_focus()
	SKIN.shade(button, 0.94 if held else (1.13 if highlighted else 1.0))
	var plate := button.get_node("Copy/UnifiedAction") as TextureRect
	plate.texture = UNIFIED.button_texture("pressed" if held else ("hover" if highlighted else "idle"))


func _update_hint() -> void:
	if _finished or not is_inside_tree():
		return
	var viewport := _footer.get_viewport()
	if viewport == null:
		return
	var focus := _hovered
	if focus == null:
		focus = viewport.gui_get_focus_owner() as Button
	_hint.text = "← →  между решениями   •   Enter  выбрать"
	if focus not in _actions:
		return
	if focus.disabled:
		_hint.text = String(focus.get_meta("event_restriction", ""))
	else:
		_hint.text = "%s  ·  Enter — выбрать" % focus.get_meta("event_action")


func _wire_focus() -> void:
	var enabled: Array[Button] = []
	for action in _actions:
		action.focus_mode = Control.FOCUS_NONE if action.disabled else Control.FOCUS_ALL
		if not action.disabled:
			enabled.append(action)
	if _reader_button.visible:
		enabled.append(_reader_button)
	for index in enabled.size():
		var current := enabled[index]
		var previous := current.get_path_to(enabled[posmod(index - 1, enabled.size())])
		var next := current.get_path_to(enabled[(index + 1) % enabled.size()])
		current.focus_neighbor_left = previous
		current.focus_neighbor_right = next
		current.focus_previous = previous
		current.focus_next = next
	if not enabled.is_empty():
		_focus_first.call_deferred(enabled.front())


func _focus_first(button: Button) -> void:
	if not _finished and is_instance_valid(button) and button.is_visible_in_tree() and not button.disabled:
		button.grab_focus()


func _open_reader(title: String) -> void:
	var popup := PopupPanel.new()
	popup.add_theme_stylebox_override("panel", SKIN.plate_style())
	var column := VBoxContainer.new()
	popup.add_child(column)
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_left = 18
	column.offset_top = 12
	column.offset_right = -18
	column.offset_bottom = -12
	var heading := Label.new()
	heading.text = title
	UI.apply_screen_copy(heading, SELECTED_INK)
	column.add_child(heading)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	var body := Label.new()
	body.text = _reader_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UI.apply_screen_copy(body, SELECTED_INK)
	scroll.add_child(body)
	var close := Button.new()
	close.text = "Закрыть"
	column.add_child(close)
	UI.apply_action_button(close, UI.BRONZE, false)
	close.pressed.connect(popup.hide)
	popup.popup_hide.connect(popup.queue_free)
	add_child(popup)
	popup.popup_centered(Vector2i(690, 276))
	close.grab_focus()


func _plate(parent: Control, node_name: String, bounds: Rect2, compact: bool = false) -> Panel:
	var panel := Panel.new()
	panel.name = node_name
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = 2
	panel.add_theme_stylebox_override("panel", SKIN.plate_style(compact))
	parent.add_child(panel)
	_place(panel, bounds)
	return panel


static func _label(parent: Control, node_name: String, value: String, bounds: Rect2,
		point: int, color: Color, wrap: bool) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = value
	parent.add_child(label)
	_style_label(label, bounds, point, color, wrap)
	label.z_index = 0
	return label


static func _style_label(label: Label, bounds: Rect2, point: int, color: Color, wrap: bool) -> void:
	label.show()
	label.modulate = Color.WHITE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = 3
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	label.add_theme_constant_override("line_spacing", 1)
	_place(label, bounds)


static func _fit(label: Label, minimum: int) -> void:
	var point := label.get_theme_font_size("font_size")
	while point > minimum and _text_height(label) > label.size.y:
		point -= 1
		label.add_theme_font_size_override("font_size", point)


static func _text_height(label: Label) -> int:
	return label.get_line_count() * (label.get_line_height() + 1)


static func _small_button(parent: Control, copy: String, bounds: Rect2) -> Button:
	var button := Button.new()
	button.text = copy
	button.z_index = 3
	parent.add_child(button)
	UI.apply_action_button(button, UI.BRONZE, false)
	button.add_theme_font_size_override("font_size", 13)
	_place(button, bounds)
	return button


static func _place(control: Control, bounds: Rect2) -> void:
	control.set_anchors_preset(Control.PRESET_TOP_LEFT)
	control.position = bounds.position
	control.size = bounds.size
