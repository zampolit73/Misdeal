extends Control

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const ART := preload("res://scripts/battle/unit_animation_library.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_bestiary_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/wizard_bestiary_v2/bestiary_plate.webp")
const ART_PATH := "res://assets/pixel/ui/wizard_bestiary_v2/"

var _slots: Array[Button] = []
var _entries: Array[UnitData] = []
var _portraits: Dictionary = {}
var _encountered: Dictionary
var _unknown: Texture2D
var _page := 0
var _page_size: int = int(LAYOUT.data.page_size)
var _page_count: int = ceili(float(ARCHIVE.ENEMY_IDS.size()) / _page_size)
var _selected := 0
var _previous: Button
var _next: Button
var _page_label: Label
var _count: Label
var _status: Label
var _portrait: TextureRect
var _title: Label
var _description: RichTextLabel


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var design: Dictionary = LAYOUT.data
	_unknown = load(ART_PATH + String(design.unknown_texture)) as Texture2D
	var group := ButtonGroup.new()
	for slot: Dictionary in design.slots:
		var index := int(slot.index)
		var area := UI.rect(slot.rect)
		var button := UI.hotspot(self, area, "")
		button.toggle_mode = true
		button.button_group = group
		var highlight := load(ART_PATH + String(slot.highlight)) as Texture2D
		var glow := UI.picture(button, highlight, Rect2(Vector2.ZERO, area.size))
		glow.name = "Highlight"
		UI.VISUAL.mute_highlight(glow)
		var art_area := UI.rect(slot.art_rect)
		art_area.position -= area.position
		var artwork := UI.picture(button, null, art_area)
		artwork.name = "Portrait"
		artwork.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		UI.caption(button, art_area, "?", 27, UI.GOLD).name = "UnknownMark"
		_slots.append(button)
		button.pressed.connect(_select.bind(index))
		button.focus_entered.connect(_update_highlight.bind(button))
		button.focus_exited.connect(_update_highlight.bind(button))
		button.mouse_entered.connect(_update_highlight.bind(button))
		button.mouse_exited.connect(_update_highlight.bind(button))
	_entries.resize(_slots.size())

	var pages: Dictionary = design.pagination
	_previous = _page_button(UI.rect(pages.previous), "‹", "Предыдущая страница", -1)
	_page_label = UI.caption(self, UI.rect(pages.text), "", 20, UI.GOLD)
	_next = _page_button(UI.rect(pages.next), "›", "Следующая страница", 1)

	var details: Dictionary = design.details
	_status = UI.caption(self, UI.rect(details.status), "", 17, UI.MUTED)
	_portrait = UI.picture(self, null, UI.rect(details.image))
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_title = UI.caption(self, UI.rect(details.title), "", 22, UI.GOLD)
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.clip_text = true
	_description = RichTextLabel.new()
	_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_description.focus_mode = Control.FOCUS_ALL
	_description.add_theme_font_override("normal_font", CARD_SKIN.heading_font())
	_description.add_theme_font_size_override("normal_font_size", 19)
	_description.add_theme_color_override("default_color", UI.COPY)
	UI.put(self, _description, UI.rect(details.description))
	UI.VISUAL.plaque(self, Rect2(912, 615, 187, 44), true)
	_count = UI.caption(self, UI.rect(details.count), "", 17, UI.GOLD)


func set_collection(enemies: Dictionary, error_message: String) -> void:
	_encountered = enemies
	var found := 0
	for id in ARCHIVE.ENEMY_IDS:
		if enemies.has(id):
			found += 1
	_count.text = "Встречено %d / %d" % [found, ARCHIVE.ENEMY_IDS.size()]
	if not error_message.is_empty():
		UI.caption(self, Rect2(350, 685, 580, 28), error_message, 16, UI.GOLD)
	_show_page(0)


func first_niche() -> Button:
	return _slots[0]


func _show_page(page: int) -> void:
	_page = page
	var first_seen := -1
	for index in _slots.size():
		var button := _slots[index]
		var entry_index := _page * _page_size + index
		var has_entry := entry_index < ARCHIVE.ENEMY_IDS.size()
		button.visible = has_entry
		button.disabled = not has_entry
		_entries[index] = null
		if not has_entry:
			continue
		var id: String = ARCHIVE.ENEMY_IDS[entry_index]
		var seen := _encountered.has(id)
		var artwork := button.get_node("Portrait") as TextureRect
		var unknown_mark := button.get_node("UnknownMark") as Label
		unknown_mark.visible = not seen
		if seen:
			var data := load("res://resources/units/%s.tres" % id) as UnitData
			_entries[index] = data
			artwork.texture = _idle_portrait(data.visual_role)
			button.accessibility_name = data.unit_name
			if first_seen == -1:
				first_seen = index
		else:
			artwork.texture = _unknown
			button.accessibility_name = "Неизвестный противник"

	_previous.disabled = _page == 0
	_next.disabled = _page == _page_count - 1
	_update_page_caption(_previous)
	_update_page_caption(_next)
	_page_label.text = "%d / %d" % [_page + 1, _page_count]
	_select(maxi(0, first_seen))


func _select(index: int) -> void:
	_selected = index
	_slots[index].set_pressed_no_signal(true)
	for button in _slots:
		_update_highlight(button)
	var data := _entries[index]
	if data == null:
		_status.text = "НЕ ВСТРЕЧЕН"
		_portrait.texture = null
		_title.text = "Неизвестный противник"
		_description.text = "Встретьте противника в бою, чтобы открыть запись."
	else:
		_status.text = "ВСТРЕЧЕН"
		_portrait.texture = _idle_portrait(data.visual_role)
		_title.text = data.unit_name
		_description.text = _combat_features(data)
		if _portrait.texture == null:
			_status.text = "ПОРТРЕТ НЕДОСТУПЕН"
	_description.scroll_to_line(0)


func _idle_portrait(role: String) -> Texture2D:
	if _portraits.has(role):
		return _portraits[role] as Texture2D
	var frames := ART.get_frames(role, true, true)
	var still: Texture2D
	if frames != null and frames.get_frame_count("idle") > 0:
		still = frames.get_frame_texture("idle", 0)
	else:
		still = ART.get_static_texture(role)
	var portrait: ImageTexture
	if still != null:
		var image := still.get_image()
		if image != null and image.get_used_rect().has_area():
			portrait = ImageTexture.create_from_image(image.get_region(image.get_used_rect()))
	_portraits[role] = portrait
	return portrait


func _combat_features(data: UnitData) -> String:
	if data.is_boss:
		return "Противник XIII. Тяжёлые удары поражают область вокруг цели."
	var features := PackedStringArray()
	features.append("Атакует с расстояния." if data.attack_range >= 120.0 else "Вступает в ближний бой.")
	if data.support_heal_amount > 0.0:
		features.append("Лечит раненых союзников.")
	if data.splash_radius > 0.0:
		features.append("Способен задеть несколько целей.")
	return "\n".join(features)


func _update_highlight(button: Button) -> void:
	var highlight := button.get_node("Highlight") as TextureRect
	highlight.visible = button.button_pressed or button.has_focus() or button.is_hovered()
	highlight.modulate.a = 0.80 if button.button_pressed else 0.28


func _page_button(area: Rect2, glyph: String, title: String, direction: int) -> Button:
	var button := UI.hotspot(self, area, title)
	UI.VISUAL.style_button(button)
	UI.caption(button, Rect2(Vector2.ZERO, area.size), glyph, 30, UI.GOLD).name = "Arrow"
	button.pressed.connect(_step_page.bind(direction))
	button.focus_entered.connect(_update_page_caption.bind(button))
	button.focus_exited.connect(_update_page_caption.bind(button))
	button.mouse_entered.connect(_update_page_caption.bind(button))
	button.mouse_exited.connect(_update_page_caption.bind(button))
	return button


func _update_page_caption(button: Button) -> void:
	var caption := button.get_node("Arrow") as Label
	if button.disabled:
		caption.modulate.a = 0.31
	else:
		caption.modulate = Color.WHITE if button.has_focus() or button.is_hovered() else Color(0.85, 0.85, 0.85)


func _step_page(direction: int) -> void:
	var page := clampi(_page + direction, 0, _page_count - 1)
	if page != _page:
		_show_page(page)
		_slots[_selected].grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if not is_visible_in_tree() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_PAGEUP or event.keycode == KEY_PAGEDOWN:
		get_viewport().set_input_as_handled()
		_step_page(-1 if event.keycode == KEY_PAGEUP else 1)
