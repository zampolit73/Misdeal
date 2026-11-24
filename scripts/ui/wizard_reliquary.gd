extends Control
## Presentation of the persisted collection, shared by the menu and native QA.

const ART := preload("res://scripts/ui/artifact_art_catalog.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const CABINET_FRAME := preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
const NICHE := preload("res://assets/pixel/ui/wizard_archive/niche.webp")
const PARCHMENT := preload("res://assets/pixel/ui/wizard_archive/parchment.webp")
const SHROUD := preload("res://assets/pixel/ui/wizard_archive/shroud.svg")
const ROW_LENGTHS := [5, 4, 4]
const GOLD := Color("#e5bc80")
const INK := Color("#311a13")
const MUTED_INK := Color("#65402b")

var _buttons: Array[Button] = []
var _ids: Array[String] = []
var _collection: Dictionary
var _details: Control
var _portrait: TextureRect
var _title: Label
var _status: Label
var _description: Label
var _count: Label
var _selected := -1
var _detail_tween: Tween


func _ready() -> void:
	size = Vector2(1000, 500)
	var cabinet := Control.new()
	cabinet.size = Vector2(655, 500)
	add_child(cabinet)
	_picture(cabinet, CABINET_FRAME, Rect2(Vector2.ZERO, cabinet.size), TextureRect.STRETCH_SCALE)
	_label(cabinet, Rect2(20, 15, 615, 34), "РЕЛИКВАРИЙ", 24, GOLD, true)
	_build_niches(cabinet)
	cabinet.modulate.a = 0.0
	create_tween().tween_property(cabinet, "modulate:a", 1.0, 0.26)

	_picture(self, PARCHMENT, Rect2(668, 0, 332, 500), TextureRect.STRETCH_SCALE)
	_count = _label(self, Rect2(691, 446, 286, 35), "", 19, INK, true)
	_details = Control.new()
	_details.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_details)
	_status = _label(_details, Rect2(692, 24, 284, 26), "", 15, MUTED_INK, false)
	_portrait = _picture(_details, null, Rect2(708, 54, 252, 200), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	_title = _label(_details, Rect2(691, 262, 286, 56), "", 23, INK, true)
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_description = _label(_details, Rect2(704, 328, 260, 98), "", 18, INK, false)
	_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_description.vertical_alignment = VERTICAL_ALIGNMENT_TOP


func first_niche() -> Button:
	return _buttons[maxi(0, _selected)]


func set_collection(relics: Dictionary, error_message: String) -> void:
	_collection = relics
	var found := 0
	var first_found := -1
	for index in _ids.size():
		var id := _ids[index]
		var known := _collection.has(id)
		var button := _buttons[index]
		var artwork := button.get_node("Artwork") as TextureRect
		artwork.texture = ART.get_reliquary_texture(id) if known else SHROUD
		artwork.modulate = Color.WHITE if known else Color("#c39376")
		button.accessibility_name = RunState.get_artifact(id).title if known else "Скрытая реликвия"
		button.tooltip_text = button.accessibility_name
		if known:
			if first_found == -1:
				first_found = index
			found += 1
	_count.text = "Найдено %d / %d" % [found, _ids.size()]
	if not error_message.is_empty():
		var notice := _label(self, Rect2(24, 463, 607, 23), error_message, 14, GOLD, false)
		notice.tooltip_text = error_message
	_select(maxi(0, first_found), false)


func _build_niches(cabinet: Control) -> void:
	var group := ButtonGroup.new()
	_ids.assign(RunState.ARTIFACT_PATHS.keys())
	var index := 0
	for row in ROW_LENGTHS.size():
		var length: int = ROW_LENGTHS[row]
		var row_width := length * 121 - 7
		for column in length:
			var niche := Button.new()
			niche.position = Vector2((655 - row_width) * 0.5 + column * 121, 53 + row * 137)
			niche.size = Vector2(114, 129)
			niche.toggle_mode = true
			niche.button_group = group
			niche.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			# The decorative layers are transparent to both pointer and keyboard input.
			for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
				niche.add_theme_stylebox_override(state, StyleBoxEmpty.new())
			cabinet.add_child(niche)
			_picture(niche, NICHE, Rect2(Vector2.ZERO, niche.size), TextureRect.STRETCH_SCALE)
			var artwork := _picture(niche, null, Rect2(13, 16, 88, 86), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
			artwork.name = "Artwork"
			_add_highlight(niche, "Selection", GOLD, 2)
			_add_highlight(niche, "Focus", Color("#e0ae73"), 1)
			niche.pressed.connect(_select.bind(index))
			niche.focus_entered.connect(_update_outline.bind(niche))
			niche.focus_exited.connect(_update_outline.bind(niche))
			niche.mouse_entered.connect(_update_outline.bind(niche))
			niche.mouse_exited.connect(_update_outline.bind(niche))
			_buttons.append(niche)
			index += 1


func _select(index: int, animate: bool = true) -> void:
	if _selected == index:
		return
	_selected = index
	_buttons[index].set_pressed_no_signal(true)
	for button in _buttons:
		_update_outline(button)
	var id := _ids[index]
	var known := _collection.has(id)
	_status.text = "НАЙДЕНО" if known else "НИША ЗАКРЫТА"
	if known:
		var relic := RunState.get_artifact(id)
		_portrait.texture = ART.get_reliquary_texture(id)
		_portrait.modulate = Color.WHITE
		_title.text = relic.title
		_description.text = relic.description
	else:
		_portrait.texture = SHROUD
		_portrait.modulate = Color("#af8871")
		_title.text = "Неизвестная реликвия"
		_description.text = "Найдите реликвию во время забега, чтобы открыть эту запись."
	if animate:
		if _detail_tween != null:
			_detail_tween.kill()
		_details.modulate.a = 0.55
		_detail_tween = create_tween().set_parallel()
		_detail_tween.tween_property(_details, "modulate:a", 1.0, 0.16)
		var outline := _buttons[index].get_node("Selection") as Panel
		outline.modulate.a = 0.70
		_detail_tween.tween_property(outline, "modulate:a", 1.0, 0.16)


func _update_outline(niche: Button) -> void:
	var selection := niche.get_node("Selection") as Panel
	var focus := niche.get_node("Focus") as Panel
	selection.visible = niche.button_pressed
	selection.modulate.a = 1.0
	focus.visible = niche.has_focus() or niche.is_hovered()


func _add_highlight(niche: Button, layer_name: String, color: Color, width: int) -> void:
	var outline := Panel.new()
	outline.name = layer_name
	outline.position = Vector2(5, 5) if layer_name == "Focus" else Vector2(2, 2)
	outline.size = niche.size - outline.position * 2.0
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.draw_center = false
	style.border_color = color
	style.set_border_width_all(width)
	outline.add_theme_stylebox_override("panel", style)
	outline.hide()
	niche.add_child(outline)


func _picture(parent: Control, texture: Texture2D, area: Rect2, stretch: TextureRect.StretchMode) -> TextureRect:
	var image := TextureRect.new()
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = stretch
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	image.position = area.position
	image.size = area.size
	parent.add_child(image)
	return image


func _label(parent: Control, area: Rect2, value: String, font_size: int, color: Color, heading: bool) -> Label:
	var label := Label.new()
	label.text = value
	label.position = area.position
	label.size = area.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	if heading:
		label.add_theme_font_override("font", CARD_SKIN.heading_font())
	parent.add_child(label)
	return label
