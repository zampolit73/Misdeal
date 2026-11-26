extends Control
## Card Inspection Visual V1. The Table and Reward remain the owners of data,
## choices and modal return. This reader never resolves a card.

const UI_MOTION := preload("res://scripts/ui/ui_motion.gd")
const CARD_DS3_SKIN := preload("res://scripts/ui/card_ds3_skin.gd")
const FONT_SKIN := "res://scripts/class_select/class_select_card_skin.gd"
const PLATE_PATH := "res://assets/pixel/ui/card_inspection_v1/reader_plate.webp"
const PANEL_SIZE := Vector2(900, 452)
const INK := Color("332015")
const MUTED_INK := Color("593d29")
const BODY_BOUNDS := Rect2(402, 170, 437, 186)

signal closed

var _previous_focus: WeakRef
var _closing := false
var frame: Panel
var lore_title: Label
var lore_kind: Label
var lore_body: RichTextLabel
var lore_art: TextureRect
var annotation: RichTextLabel
var _annotation_rule: ColorRect


func _ready() -> void:
	var previous := get_viewport().gui_get_focus_owner()
	if previous != null:
		_previous_focus = weakref(previous)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 300

	var scrim := ColorRect.new()
	scrim.name = "Scrim"
	scrim.color = Color(0.012, 0.006, 0.008, 0.60)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.gui_input.connect(_on_scrim_input)
	add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	frame = Panel.new()
	frame.name = "Frame"
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	frame.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	add_child(frame)
	frame.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	frame.offset_left = -PANEL_SIZE.x / 2
	frame.offset_top = -PANEL_SIZE.y / 2
	frame.offset_right = PANEL_SIZE.x / 2
	frame.offset_bottom = PANEL_SIZE.y / 2

	var plate := TextureRect.new()
	plate.name = "ReaderPlate"
	plate.texture = load(PLATE_PATH) as Texture2D
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plate.stretch_mode = TextureRect.STRETCH_SCALE
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(plate)
	plate.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	lore_art = TextureRect.new()
	lore_art.name = "LoreArt"
	lore_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	lore_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	lore_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(lore_art)
	_place(lore_art, Rect2(80, 47, 243, 325))
	CARD_DS3_SKIN.apply_inspection(frame, lore_art)

	lore_title = _label("CardTitle", Rect2(397, 52, 448, 69), 29, INK)
	lore_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_title.max_lines_visible = 2
	lore_kind = _label("CardType", Rect2(402, 121, 437, 32), 18, MUTED_INK)
	lore_kind.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_kind.max_lines_visible = 2
	_rule("HeadingRule", Rect2(423, 158, 395, 1), Color("8c603d"))
	var seal := _label("RuleSeal", Rect2(607, 146, 27, 25), 19, MUTED_INK)
	seal.text = "✦"

	lore_body = _reading_area("FullDescription", BODY_BOUNDS, 23, INK)
	_annotation_rule = _rule("AnnotationRule", Rect2(402, 275, 437, 1), Color("8c603d"))
	_annotation_rule.hide()
	annotation = _reading_area("ExtraRule", Rect2(402, 282, 437, 74), 17, Color("6a3022"))
	annotation.hide()

	var close_button := Button.new()
	close_button.name = "CloseButton"
	close_button.text = "ЗАКРЫТЬ [ESC]"
	frame.add_child(close_button)
	load(FONT_SKIN).prepare_action(close_button, 20)
	_place(close_button, Rect2(631, 388, 210, 31))
	# The blank painted plate stays under the live control.
	close_button.focus_neighbor_left = NodePath(".")
	close_button.focus_neighbor_right = NodePath(".")
	close_button.focus_neighbor_top = NodePath(".")
	close_button.focus_neighbor_bottom = NodePath(".")
	close_button.focus_next = NodePath(".")
	close_button.focus_previous = NodePath(".")
	close_button.pressed.connect(close)
	UI_MOTION.reveal(frame, scrim)
	close_button.grab_focus()


func present(card_title: String, card_type: String, full_text: String, card_art: Texture2D, extra: String = "") -> void:
	lore_title.text = card_title
	var physical_title := frame.get_node_or_null("DS3InspectCardTitle") as Label
	if physical_title != null:
		physical_title.text = card_title
	var physical_type := frame.get_node_or_null("DS3InspectCardType") as Label
	if physical_type != null:
		# The full type/role is always on the right; the small tab uses its
		# existing leading category, not a newly invented classification.
		physical_type.text = card_type.get_slice(" • ", 0)
		_fit_line(physical_type, 10, 7)
	lore_kind.text = card_type
	_fit_line(lore_kind, 18, 14)
	lore_body.text = full_text
	lore_body.scroll_to_line(0)
	lore_art.texture = card_art
	annotation.text = extra.strip_edges()
	annotation.visible = not annotation.text.is_empty()
	annotation.scroll_to_line(0)
	_annotation_rule.visible = annotation.visible
	lore_body.size = Vector2(BODY_BOUNDS.size.x, 97 if annotation.visible else BODY_BOUNDS.size.y)


func close() -> void:
	if _closing:
		return
	_closing = true
	UI_MOTION.stop(frame)
	if _previous_focus != null:
		var previous = _previous_focus.get_ref()
		if is_instance_valid(previous) and previous.is_inside_tree():
			previous.grab_focus()
	closed.emit()
	queue_free()


func _input(event: InputEvent) -> void:
	if _closing:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()
	elif event is InputEventKey and event.pressed and event.keycode in [KEY_UP, KEY_DOWN, KEY_PAGEUP, KEY_PAGEDOWN, KEY_HOME, KEY_END]:
		var scroll := lore_body.get_v_scroll_bar()
		# If a long note is the only overflowing region, use the same keys.
		if not scroll.visible and annotation.visible:
			scroll = annotation.get_v_scroll_bar()
		match event.keycode:
			KEY_UP: scroll.value -= 28.0
			KEY_DOWN: scroll.value += 28.0
			KEY_PAGEUP: scroll.value -= scroll.page
			KEY_PAGEDOWN: scroll.value += scroll.page
			KEY_HOME: scroll.value = scroll.min_value
			KEY_END: scroll.value = scroll.max_value - scroll.page
		get_viewport().set_input_as_handled()


func _on_scrim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		close()


func _place(control: Control, bounds: Rect2) -> void:
	control.position = bounds.position
	control.size = bounds.size


func _rule(node_name: String, bounds: Rect2, pigment: Color) -> ColorRect:
	var rule := ColorRect.new()
	rule.name = node_name
	rule.color = pigment
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(rule)
	_place(rule, bounds)
	return rule


func _label(node_name: String, bounds: Rect2, point: int, pigment: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", load(FONT_SKIN).heading_font())
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", pigment)
	label.clip_text = true
	frame.add_child(label)
	_place(label, bounds)
	return label


func _reading_area(node_name: String, bounds: Rect2, point: int, pigment: Color) -> RichTextLabel:
	var copy := RichTextLabel.new()
	copy.name = node_name
	copy.bbcode_enabled = false
	copy.scroll_active = true
	copy.scroll_following = false
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	copy.mouse_filter = Control.MOUSE_FILTER_STOP
	copy.add_theme_font_override("normal_font", load(FONT_SKIN).heading_font())
	copy.add_theme_font_size_override("normal_font_size", point)
	copy.add_theme_color_override("default_color", pigment)
	copy.add_theme_constant_override("line_separation", 4)
	frame.add_child(copy)
	_place(copy, bounds)
	return copy


func _fit_line(label: Label, preferred: int, smallest: int) -> void:
	var font := label.get_theme_font("font")
	var point := preferred
	while point > smallest and font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > label.size.x:
		point -= 1
	label.add_theme_font_size_override("font_size", point)
