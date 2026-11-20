extends Node
## Presentation for the existing event buttons. Costs and restrictions come from their scene adapters.

const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const MOTION := preload("res://scripts/ui/ui_motion.gd")
const BRONZE := Color("a6794d")
const BONE := Color("f0dfc1")
const PAPER := Color("dbc39e")
const INK := Color("2a1b16")
const MUTED := Color("c5b3a4")
const ROMAN := ["I", "II", "III", "IV"]

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
	var header := _panel(surface, "EventHeader", Rect2(96, 24, 1088, 148), Color("211918"))
	var rule := ColorRect.new()
	rule.color = BRONZE.darkened(0.38)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(rule)
	_place(rule, Rect2(20, 31, 1048, 1))
	for index in stats.size():
		var bounds := Rect2(118, 28, 1044, 23)
		if stats.size() == 2:
			bounds = Rect2(118, 28, 150, 23) if index == 0 else Rect2(276, 28, 886, 23)
		_style_label(stats[index], bounds, 13, UI.PARCHMENT_WARM, false)
		stats[index].text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		stats[index].tooltip_text = stats[index].text
		stats[index].mouse_filter = Control.MOUSE_FILTER_PASS
	_style_label(title, Rect2(118, 60, 1044, 38), 30, BONE, false)
	_style_label(quote, Rect2(118, 101, 1044, 23), 15, UI.PARCHMENT_WARM, false)
	_style_label(description, Rect2(118, 123, 1044, 46), 15, BONE, true)
	quote.max_lines_visible = 1
	quote.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	description.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_reader_text = "%s\n\n%s" % [quote.text, description.text]
	_reader_button = _small_button(surface, "Читать полностью", Rect2(1002, 130, 160, 29))
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
	var width := 255 if _cards.size() == 4 else 331
	for index in _cards.size():
		_build_card(_cards[index], index, width)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	row.z_index = 3
	_place(row, Rect2(96, 190, 1088, 422))

	_footer = _panel(surface, "EventContext", Rect2(96, 630, 1088, 64), Color("211918"))
	_hint = _label(_footer, "Hint", "", Rect2(21, 7, 1046, 50), 14, MUTED, true)
	_style_label(result, Rect2(117, 637, 1046, 50), 15, BONE, true)
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
		var copy := restriction.get_parent() as Panel
		_place(restriction, Rect2(12, 4 - copy.position.y, copy.size.x - 24, 24))
		restriction.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		restriction.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		restriction.add_theme_color_override("font_color", BONE)
		var frame := _card_style(BRONZE.lightened(0.35) if button == _pending else BRONZE.darkened(0.45))
		button.add_theme_stylebox_override("disabled", frame)
		button.focus_mode = Control.FOCUS_NONE
	_result.show()
	if continue_button != null:
		continue_button.show()
		UI.apply_action_button(continue_button, UI.GOLD, true)
		continue_button.z_index = 3
		_place(continue_button, Rect2(929, 641, 234, 42))
		_result.size.x = 789
		continue_button.grab_focus()
	_fit(_result, 13)


func _remember(button: Button) -> void:
	if not _finished and not button.disabled and button.visible:
		_pending = button


func _build_card(button: Button, index: int, width: int) -> void:
	var raw := button.text
	var parts := raw.split("\n\n", true, 1)
	var action := String(button.get_meta("event_action", parts[0])).strip_edges()
	var detail := String(button.get_meta("event_outcome", parts[1] if parts.size() > 1 else "")).strip_edges()
	var cost := String(button.get_meta("event_cost", "Без платы"))
	var restriction := String(button.get_meta("event_restriction", ""))
	var kind := String(button.get_meta("event_kind", "ВЫБОР"))
	var accent: Color = {
		"КРОВЬ": Color("e9a19a"), "МОНЕТА": Color("ebc187"), "РИТУАЛ": Color("c9add9"),
		"ОТКАЗ": Color("b6c8d2"), "РИСК": Color("efb091"),
	}.get(kind, Color("e4cbb0"))
	if button.disabled:
		accent = accent.lerp(MUTED, 0.65)
	button.tooltip_text = "%s\n%s\n%s" % [action, cost, detail]
	if not restriction.is_empty():
		button.tooltip_text += "\n" + restriction
	button.text = ""
	button.custom_minimum_size = Vector2(width, 422)
	button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	for state: String in ["normal", "hover", "pressed", "disabled", "focus"]:
		var color := BRONZE
		if state in ["hover", "focus", "pressed"]:
			color = BRONZE.lightened(0.38)
		elif state == "disabled":
			color = BRONZE.darkened(0.37)
		var style := _card_style(color)
		if state == "focus":
			style.draw_center = false
		if state == "pressed":
			style.bg_color = Color("3a2121")
		button.add_theme_stylebox_override(state, style)
	for child in button.get_children():
		if child is CanvasItem and child.name != "ChoiceArt":
			child.hide()
	var art := button.get_node("ChoiceArt") as TextureRect
	var art_bottom := 183 if width == 255 else 215
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.modulate = Color("d6cec8") if button.disabled else Color.WHITE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(art, Rect2(2, 31, width - 4, art_bottom - 31))
	_label(button, "ActionType", "%s  /  %s" % [ROMAN[index], kind], Rect2(13, 4, width - 26, 24), 13, accent, false)
	var copy_height := 420 - art_bottom
	var copy := _panel(button, "Copy", Rect2(2, art_bottom, width - 4, copy_height), PAPER, false, 0)
	var title := _label(copy, "Action", action, Rect2(12, 10, width - 28, 52), 17, INK, true)
	title.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	var cost_y := 10 + maxi(26, title.get_line_count() * title.get_line_height() + 4)
	_label(copy, "Cost", cost, Rect2(12, cost_y, width - 28, 24), 15, Color("603427"), true)
	var outcome_y := cost_y + 32
	var status_height := 43 if not restriction.is_empty() else 0
	var body := _label(copy, "Outcome", detail, Rect2(12, outcome_y, width - 28,
		copy_height - outcome_y - status_height - 6), 15, INK, true)
	body.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_fit(body, 13)
	var availability := _label(copy, "Availability", restriction, Rect2(12, copy_height - 42,
		width - 28, 38), 14, Color("702d27"), true)
	availability.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_fit(availability, 13)
	button.set_meta("event_action", action)
	button.set_meta("event_restriction", restriction)
	_bind(button)


func _bind(button: Button) -> void:
	_actions.append(button)
	button.mouse_entered.connect(_enter.bind(button))
	button.mouse_exited.connect(_exit.bind(button))
	button.focus_entered.connect(_update_hint)
	button.focus_exited.connect(_update_hint)
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
	var height := -4.0 if _hovered == button and not held else 0.0
	var tween := MOTION.replace_tween(button, &"event_lift")
	tween.tween_property(button, "position:y", height, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


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
	popup.add_theme_stylebox_override("panel", _card_style(BRONZE))
	var column := VBoxContainer.new()
	popup.add_child(column)
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.offset_left = 18
	column.offset_top = 12
	column.offset_right = -18
	column.offset_bottom = -12
	var heading := Label.new()
	heading.text = title
	UI.apply_screen_copy(heading, BONE)
	column.add_child(heading)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	var body := Label.new()
	body.text = _reader_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UI.apply_screen_copy(body, BONE)
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


static func _panel(parent: Control, node_name: String, bounds: Rect2, color: Color,
		framed: bool = true, depth: int = 2) -> Panel:
	var panel := Panel.new()
	panel.name = node_name
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = depth
	var style := _card_style(BRONZE.darkened(0.2)) if framed else StyleBoxFlat.new()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	_place(panel, bounds)
	return panel


static func _card_style(border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("231a1a")
	style.border_color = border
	style.set_border_width_all(2)
	return style


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
	while point > minimum and label.get_line_count() * (label.get_line_height() + 1) > label.size.y:
		point -= 1
		label.add_theme_font_size_override("font_size", point)


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
