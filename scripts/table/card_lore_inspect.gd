extends Control

# Deliberate non-destructive reading surface. RMB opens the complete original
# card text, while the two offer cards and their action buttons remain clean.
signal closed

var frame: Panel
var lore_title: Label
var lore_kind: Label
var lore_body: RichTextLabel
var lore_art: TextureRect
var annotation: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 300

	var scrim := ColorRect.new()
	scrim.name = "Scrim"
	scrim.color = Color(0.012, 0.006, 0.008, 0.78)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.gui_input.connect(_on_scrim_input)
	add_child(scrim)

	frame = Panel.new()
	frame.name = "Frame"
	frame.position = Vector2(260.0, 144.0)
	frame.size = Vector2(760.0, 440.0)
	frame.mouse_filter = Control.MOUSE_FILTER_STOP
	var border := StyleBoxFlat.new()
	border.bg_color = Color("#211512")
	border.border_color = Color("#ad7649")
	border.border_width_left = 3
	border.border_width_top = 3
	border.border_width_right = 3
	border.border_width_bottom = 3
	border.shadow_color = Color(0.0, 0.0, 0.0, 0.82)
	border.shadow_size = 19
	frame.add_theme_stylebox_override("panel", border)
	add_child(frame)

	var caption := _label(frame, "Caption", Vector2(30.0, 18.0), Vector2(430.0, 28.0), 14, Color("#c79c68"))
	caption.text = "СТРАНИЦА ИЗ ПРОКЛЯТОЙ КОЛОДЫ"
	var divider := ColorRect.new()
	divider.name = "Divider"
	divider.color = Color("#705036")
	divider.position = Vector2(31.0, 52.0)
	divider.size = Vector2(698.0, 1.0)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(divider)

	var art_border := Panel.new()
	art_border.name = "ArtBorder"
	art_border.position = Vector2(32.0, 73.0)
	art_border.size = Vector2(282.0, 200.0)
	art_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var art_style := StyleBoxFlat.new()
	art_style.bg_color = Color("#402820")
	art_style.border_color = Color("#ad7649")
	art_style.border_width_left = 2
	art_style.border_width_top = 2
	art_style.border_width_right = 2
	art_style.border_width_bottom = 2
	art_border.add_theme_stylebox_override("panel", art_style)
	frame.add_child(art_border)

	lore_art = TextureRect.new()
	lore_art.name = "LoreArt"
	lore_art.position = Vector2(36.0, 77.0)
	lore_art.size = Vector2(274.0, 192.0)
	lore_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lore_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	lore_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	frame.add_child(lore_art)

	var artwork_hint := _label(frame, "ArtHint", Vector2(32.0, 292.0), Vector2(282.0, 54.0), 13, Color("#c8ab83"))
	artwork_hint.text = "Нажми «Закрыть» или ESC,\nчтобы вернуться к выбору."
	artwork_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	lore_title = _label(frame, "CardTitle", Vector2(338.0, 70.0), Vector2(392.0, 72.0), 23, Color("#f0d0a0"))
	lore_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	lore_kind = _label(frame, "CardType", Vector2(341.0, 142.0), Vector2(380.0, 23.0), 13, Color("#ba8457"))

	lore_body = RichTextLabel.new()
	lore_body.name = "FullDescription"
	lore_body.position = Vector2(338.0, 176.0)
	lore_body.size = Vector2(392.0, 165.0)
	lore_body.bbcode_enabled = false
	lore_body.scroll_active = true
	lore_body.scroll_following = false
	lore_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lore_body.add_theme_font_size_override("normal_font_size", 17)
	lore_body.add_theme_color_override("default_color", Color("#f0d7b5"))
	lore_body.mouse_filter = Control.MOUSE_FILTER_STOP
	frame.add_child(lore_body)

	annotation = _label(frame, "ExtraRule", Vector2(338.0, 347.0), Vector2(392.0, 32.0), 13, Color("#e0a971"))
	annotation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var close_button := Button.new()
	close_button.name = "CloseButton"
	close_button.position = Vector2(536.0, 392.0)
	close_button.size = Vector2(194.0, 35.0)
	close_button.text = "ЗАКРЫТЬ  [ESC]"
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color("#ffddb0"))
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color("#5a211b")
	close_style.border_color = Color("#b98951")
	close_style.border_width_left = 2
	close_style.border_width_top = 2
	close_style.border_width_right = 2
	close_style.border_width_bottom = 2
	close_button.add_theme_stylebox_override("normal", close_style)
	var close_hover := close_style.duplicate() as StyleBoxFlat
	close_hover.bg_color = Color("#883025")
	close_button.add_theme_stylebox_override("hover", close_hover)
	close_button.add_theme_stylebox_override("pressed", close_hover)
	close_button.pressed.connect(close)
	frame.add_child(close_button)


func present(card_title: String, card_type: String, full_text: String, card_art: Texture2D, extra: String = "") -> void:
	lore_title.text = card_title
	lore_kind.text = card_type
	lore_body.text = full_text
	lore_art.texture = card_art
	annotation.text = extra


func close() -> void:
	closed.emit()
	queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()


func _on_scrim_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		close()


func _label(parent: Control, node_name: String, at: Vector2, dimensions: Vector2, font_size: int, pigment: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.position = at
	label.size = dimensions
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", pigment)
	label.clip_text = true
	parent.add_child(label)
	return label
