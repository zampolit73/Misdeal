extends Control
## Places the live collection over the supplied 1280×720 cabinet artwork.

const VISUAL := preload("res://scripts/ui/wizard_archive_visual_v3.gd")
const ART := preload("res://scripts/ui/artifact_art_catalog.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_archive_v21/layout_1280x720.json")
const ART_PATH := "res://assets/pixel/ui/wizard_archive_v21/"
const GOLD := VISUAL.GOLD
const COPY := VISUAL.COPY
const MUTED := VISUAL.MUTED

var _buttons: Array[Button] = []
var _ids: Array[String] = []
var _artworks: Array[Texture2D] = []
var _unknown: Array[Texture2D] = []
var _portrait: TextureRect
var _portrait_area: Rect2
var _title: Label
var _status: Label
var _description: RichTextLabel
var _count: Label
var _notice: Label
var _selected := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for path: String in LAYOUT.data.unknown_textures:
		_unknown.append(asset(path))
	_build_niches()

	var details: Dictionary = LAYOUT.data.details
	_status = caption(self, rect(details.status), "", 17, MUTED)
	_portrait_area = rect(details.image)
	_portrait = picture(self, null, _portrait_area)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_title = caption(self, rect(details.title), "", 23, GOLD)
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.clip_text = true
	_description = RichTextLabel.new()
	_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_description.add_theme_font_override("normal_font", CARD_SKIN.heading_font())
	_description.add_theme_font_size_override("normal_font_size", 19)
	_description.add_theme_color_override("default_color", COPY)
	put(self, _description, rect(details.description))
	VISUAL.plaque(self, Rect2(912, 615, 187, 44), true)
	_count = caption(self, rect(details.count), "", 17, GOLD)
	_notice = caption(self, Rect2(350, 685, 580, 28), "", 16, GOLD)
	_notice.hide()


func first_niche() -> Button:
	return _buttons[maxi(0, _selected)]


func set_collection(relics: Dictionary, error_message: String) -> void:
	var found := 0
	var first_found := -1
	_artworks.resize(_ids.size())
	for index in _ids.size():
		var id := _ids[index]
		var known := relics.has(id)
		var niche := _buttons[index]
		var artwork := niche.get_node("Artwork") as TextureRect
		var art_area := rect(LAYOUT.data.slots[index].art_rect)
		art_area.position -= niche.position
		var question := niche.get_node("UnknownMark") as Label
		question.visible = not known
		var texture := _item_art(id) if known else null
		_artworks[index] = texture
		artwork.texture = texture if known else _unknown[index % _unknown.size()]
		var fit := art_area.size
		if not known:
			fit *= 0.73
		var original := artwork.texture.get_size()
		var ratio := minf(fit.x / original.x, fit.y / original.y)
		artwork.size = original * ratio
		artwork.position = Vector2(art_area.get_center().x - artwork.size.x * 0.5, art_area.end.y - artwork.size.y)
		question.position = artwork.position + Vector2(0, artwork.size.y * 0.46)
		question.size = Vector2(artwork.size.x, 28)
		niche.accessibility_name = RunState.get_artifact(id).title if known else "Скрытая реликвия"
		if known:
			if first_found == -1:
				first_found = index
			found += 1
	_count.text = "Найдено %d / %d" % [found, _ids.size()]
	_notice.text = error_message
	_notice.visible = not error_message.is_empty()
	_selected = -1
	_select(maxi(0, first_found))


func _build_niches() -> void:
	var group := ButtonGroup.new()
	_ids.assign(RunState.ARTIFACT_PATHS.keys())
	for slot: Dictionary in LAYOUT.data.slots:
		var index := int(slot.index)
		var area := rect(slot.rect)
		var niche := hotspot(self, area, "")
		niche.toggle_mode = true
		niche.button_group = group
		var highlight := picture(niche, asset(slot.highlight), Rect2(Vector2.ZERO, area.size))
		highlight.name = "Highlight"
		VISUAL.mute_highlight(highlight)
		highlight.hide()
		var artwork := picture(niche, null, Rect2())
		artwork.name = "Artwork"
		var question := caption(niche, Rect2(), "?", 23, MUTED)
		question.name = "UnknownMark"
		niche.pressed.connect(_select.bind(index))
		niche.focus_entered.connect(_update_highlight.bind(niche))
		niche.focus_exited.connect(_update_highlight.bind(niche))
		niche.mouse_entered.connect(_update_highlight.bind(niche))
		niche.mouse_exited.connect(_update_highlight.bind(niche))
		_buttons.append(niche)


func _select(index: int) -> void:
	_selected = index
	_buttons[index].set_pressed_no_signal(true)
	for button in _buttons:
		_update_highlight(button)
	var texture := _artworks[index]
	if texture != null:
		var relic := RunState.get_artifact(_ids[index])
		_status.text = "НАЙДЕНО"
		_portrait.texture = texture
		_portrait.position = _portrait_area.position
		_portrait.size = _portrait_area.size
		_portrait.modulate.a = 1.0
		_title.text = relic.title
		_description.text = relic.description
	else:
		_status.text = "НИША ЗАКРЫТА"
		_portrait.texture = _unknown.back()
		_portrait.size = _portrait_area.size * 0.60
		_portrait.position = _portrait_area.get_center() - _portrait.size * 0.5
		_portrait.modulate.a = 0.72
		_title.text = "Неизвестная реликвия"
		_description.text = "Найдите реликвию во время забега, чтобы открыть эту запись."
	_description.scroll_to_line(0)


func _update_highlight(niche: Button) -> void:
	var highlight := niche.get_node("Highlight") as TextureRect
	highlight.visible = niche.button_pressed or niche.has_focus() or niche.is_hovered()
	highlight.modulate.a = 1.0 if niche.button_pressed else 0.46


func _item_art(id: String) -> Texture2D:
	# Trim the atlas cell's transparent margin so the visible object rests on the cushion.
	var image := ART.get_reliquary_texture(id).get_image()
	return ImageTexture.create_from_image(image.get_region(image.get_used_rect()))


static func rect(coordinates: Array) -> Rect2:
	return Rect2(coordinates[0], coordinates[1], coordinates[2], coordinates[3])


static func asset(path: String) -> Texture2D:
	return load(ART_PATH + path) as Texture2D


static func put(parent: Control, child: Control, area: Rect2) -> void:
	child.position = area.position
	child.size = area.size
	parent.add_child(child)


static func picture(parent: Control, texture: Texture2D, area: Rect2) -> TextureRect:
	var image := TextureRect.new()
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	put(parent, image, area)
	return image


static func caption(parent: Control, area: Rect2, value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_font_override("font", CARD_SKIN.heading_font())
	put(parent, label, area)
	return label


static func hotspot(parent: Control, area: Rect2, accessible_title: String) -> Button:
	var button := Button.new()
	button.accessibility_name = accessible_title
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "hover", "pressed", "focus", "hover_pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	put(parent, button, area)
	return button
