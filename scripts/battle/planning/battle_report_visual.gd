extends CanvasLayer
## Read-only campaign report. Only the campaign adapter owns combat history.
const SKIN := preload("res://scripts/battle/planning/battle_plan_skin.gd")
const PLAN := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const PLATE := "res://assets/pixel/ui/combat_report_v1/report_plate.webp"
const PANEL_SIZE := Vector2(1000, 588)
const INK := Color("382317")
const PALE := Color("efd1a2")
const RULE := Color("8a5d39")
const ROLE_NAMES := {"knight": "Рыцарь", "ranger": "Следопыт", "mage": "Маг"}

var root: Control
var frame: Control
var scroll: ScrollContainer
var journal: VBoxContainer
var close_button: Button
var previous_focus: WeakRef
var _closing := false
var _font: Font
var _bold: Font

signal closed

func _ready() -> void:
	layer = 60
	_font = SKIN.serif()
	_bold = SKIN.serif(true)
	var previous := get_viewport().gui_get_focus_owner()
	if previous != null:
		previous_focus = weakref(previous)
	root = Control.new()
	root.name = "ReportRoot"
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var scrim := ColorRect.new()
	scrim.name = "Scrim"
	scrim.color = Color(0.008, 0.004, 0.006, 0.53)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame = Control.new()
	frame.name = "ReportFrame"
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(frame)
	frame.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	frame.offset_left = -PANEL_SIZE.x * 0.5
	frame.offset_top = -PANEL_SIZE.y * 0.5
	frame.offset_right = PANEL_SIZE.x * 0.5
	frame.offset_bottom = PANEL_SIZE.y * 0.5
	SKIN.mount(frame, load(PLATE) as Texture2D, Vector2.ZERO, PANEL_SIZE).name = "ReportPlate"
	var title := _label("Heading", "РАЗБОР ПРИКАЗОВ", 31, PALE, _font)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_place(frame, title, Rect2(130, 24, 740, 38))
	var subtitle := _label("Encounter", "", 18, PALE, _font)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.clip_text = true
	_place(frame, subtitle, Rect2(370, 63, 260, 27))

	scroll = ScrollContainer.new()
	scroll.name = "JournalScroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
	scroll.focus_mode = Control.FOCUS_NONE
	scroll.mouse_filter = Control.MOUSE_FILTER_STOP
	_place(frame, scroll, Rect2(77, 116, 854, 366))
	scroll.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	scroll.add_theme_constant_override("scrollbar_h_separation", 7)
	var bar := scroll.get_v_scroll_bar()
	bar.add_theme_stylebox_override("scroll", _scroll_style(Color("41291b"), Color("84572d"), 5))
	bar.add_theme_stylebox_override("grabber", _scroll_style(Color("ba8a54"), Color("79522e"), 5))
	bar.add_theme_stylebox_override("grabber_highlight", _scroll_style(Color("d8ae72"), Color("79522e"), 5))
	bar.add_theme_stylebox_override("grabber_pressed", _scroll_style(Color("ac7942"), Color("79522e"), 5))
	bar.focus_mode = Control.FOCUS_NONE
	journal = VBoxContainer.new()
	journal.name = "Journal"
	journal.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	journal.add_theme_constant_override("separation", 12)
	journal.mouse_filter = Control.MOUSE_FILTER_PASS
	scroll.add_child(journal)

	close_button = Button.new()
	close_button.name = "CloseButton"
	close_button.text = "ЗАКРЫТЬ [ESC]"
	close_button.add_theme_font_override("font", _font)
	close_button.add_theme_font_size_override("font_size", 20)
	for state in ["normal", "hover", "pressed", "hover_pressed", "focus"]:
		var style := StyleBoxFlat.new()
		style.set_corner_radius_all(4)
		style.bg_color = Color("d8ab6222") if state == "hover" else Color("120a0766") if state in ["pressed", "hover_pressed"] else Color.TRANSPARENT
		style.border_color = PALE if state == "focus" else Color.TRANSPARENT
		style.set_border_width_all(1)
		close_button.add_theme_stylebox_override(state, style)
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		close_button.add_theme_color_override(color_name, PALE)
	_place(frame, close_button, Rect2(704, 505, 234, 40))
	close_button.focus_mode = Control.FOCUS_ALL
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		close_button.set_focus_neighbor(side, NodePath("."))
	close_button.focus_next = NodePath(".")
	close_button.focus_previous = NodePath(".")
	close_button.pressed.connect(close)
	close_button.grab_focus()

func present(encounter: String, logs: Dictionary) -> void:
	var subtitle := frame.get_node("Encounter") as Label
	subtitle.text = encounter.to_upper()
	var point := 18
	while point > 12 and _font.get_string_size(subtitle.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > subtitle.size.x:
		point -= 1
	subtitle.add_theme_font_size_override("font_size", point)
	for child in journal.get_children():
		journal.remove_child(child)
		child.free()
	for role in logs:
		_add_section(str(role), logs[role])
	if logs.is_empty():
		journal.add_child(_label("Empty", "Боевых событий нет.", 20, INK, _font))
	scroll.scroll_vertical = 0

func _add_section(role: String, log: Array) -> void:
	var section := VBoxContainer.new()
	section.name = "Hero_" + role
	section.add_theme_constant_override("separation", 3)
	section.mouse_filter = Control.MOUSE_FILTER_PASS
	journal.add_child(section)
	var header := HBoxContainer.new()
	header.custom_minimum_size.y = 39
	header.mouse_filter = Control.MOUSE_FILTER_PASS
	header.add_theme_constant_override("separation", 4)
	section.add_child(header)
	var badge := Control.new()
	badge.custom_minimum_size = Vector2(219, 39)
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(badge)
	var plate := Panel.new()
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_theme_stylebox_override("panel", SKIN.textured(SKIN.slice(SKIN.METAL_SOURCE, SKIN.METAL), 10, Color("cfc0ac")))
	_place(badge, plate, Rect2(15, 4, 204, 30))
	var name_label := _label("HeroName", str(ROLE_NAMES.get(role, role)).to_upper(), 19, PALE, _font)
	_place(badge, name_label, Rect2(39, 4, 176, 30))
	if ROLE_NAMES.has(role):
		var emblem := Control.new()
		emblem.name = "RoleEmblem"
		emblem.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_place(badge, emblem, Rect2(1, 4, 30, 30))
		emblem.draw.connect(SKIN.emblem.bind(emblem, role))
	var line := ColorRect.new()
	line.color = RULE
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.custom_minimum_size.y = 1
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	line.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	header.add_child(line)
	var count := 0
	for raw in log:
		var event_text := describe_event(raw)
		if event_text.is_empty():
			continue
		count += 1
		var row := HBoxContainer.new()
		row.name = "Event%d" % count
		row.custom_minimum_size.y = 25
		row.mouse_filter = Control.MOUSE_FILTER_PASS
		row.add_theme_constant_override("separation", 12)
		section.add_child(row)
		var timestamp := _label("Time", "Волна %d · %.1f с" % [int(raw.wave), float(raw.time)], 19, INK, _bold)
		timestamp.custom_minimum_size.x = 210
		row.add_child(timestamp)
		var divider := ColorRect.new()
		divider.color = Color("936a45")
		divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		divider.custom_minimum_size.x = 1
		row.add_child(divider)
		var event_label := _label("Event", event_text, 19, INK, _font)
		event_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		event_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(event_label)
		var rule := ColorRect.new()
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rule.color = Color("8a5d3975")
		rule.custom_minimum_size.y = 1
		section.add_child(rule)
	if count == 0:
		section.add_child(_label("Empty", "Боевых событий нет.", 19, INK, _font))

static func describe_event(item: Dictionary) -> String:
	match str(item.get("kind", "")):
		"start": return "Начало: " + str(item.order)
		"end":
			var reason := str(item.reason)
			var localized := "Лимит истёк" if reason == "timeout" else reason
			if reason in PLAN.CONDITIONS:
				localized = PLAN.CONDITION_NAMES[PLAN.CONDITIONS.find(reason)]
			return "Переход: %s · %.1f с" % [localized, float(item.elapsed)]
		"kill": return "Личное убийство: " + str(item.target)
		"death": return "Герой погиб"
		"target": return "Выбрана цель: " + str(item.actual)
	return ""

func close() -> void:
	if _closing:
		return
	_closing = true
	root.hide()
	if previous_focus != null:
		var previous: Variant = previous_focus.get_ref()
		if is_instance_valid(previous) and previous.is_inside_tree():
			previous.grab_focus()
	closed.emit()
	queue_free()

func _input(event: InputEvent) -> void:
	if _closing or not event is InputEventKey or not event.pressed:
		return
	match event.keycode:
		KEY_ESCAPE:
			if not event.echo:
				close()
		KEY_UP: scroll.scroll_vertical -= 28
		KEY_DOWN: scroll.scroll_vertical += 28
		KEY_PAGEUP: scroll.scroll_vertical -= int(scroll.size.y)
		KEY_PAGEDOWN: scroll.scroll_vertical += int(scroll.size.y)
		KEY_HOME: scroll.scroll_vertical = 0
		KEY_END: scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
		_: return
	get_viewport().set_input_as_handled()

func _label(node_name: String, value: String, points: int, pigment: Color, font: Font) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", points)
	label.add_theme_color_override("font_color", pigment)
	return label

func _place(parent: Control, control: Control, bounds: Rect2) -> void:
	parent.add_child(control)
	control.position = bounds.position
	control.size = bounds.size

func _scroll_style(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 5
	style.content_margin_right = 5
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	return style
