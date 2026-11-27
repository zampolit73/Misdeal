extends Control
## Challenges overview and a read-only, full achievement collection.
signal collection_mode_changed(active: bool)

const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_challenges_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/wizard_challenges_v2/challenges_plate.webp")
const ASSETS := "res://assets/pixel/ui/wizard_challenges_v2/"
const COLLECTION_LAYOUT := preload("res://assets/pixel/ui/wizard_bestiary_v2/layout_1280x720.json")
const COLLECTION_PLATE := preload("res://assets/pixel/ui/wizard_bestiary_v2/bestiary_plate.webp")
const COLLECTION_ASSETS := "res://assets/pixel/ui/wizard_bestiary_v2/"
const ACHIEVEMENTS := preload("res://scripts/core/achievement_catalog.gd")
const ACHIEVEMENT_FIRST_SLOT := 3
const PREVIEW_SIZE := 4
const ACHIEVEMENT_PAGE_SIZE := 12
# Only presentation aliases; the full catalog title always appears in the
# detail panel and tooltip. Never use localized display names as saved IDs.
const SHORT_TITLES := {
	"oath_v_victory": "Вопреки ставке",
	"four_cards": "Камни пути",
	"eight_cards": "Путь проклятия",
}

var _overview: Control
var _collection: Control
var _buttons: Array[Button] = []
var _entries: Array[Dictionary] = []
var _collection_buttons: Array[Button] = []
var _collection_entries: Array[Dictionary] = []
var _seal: TextureRect
var _title: Label
var _status_plaque: Panel
var _status: Label
var _condition_heading: Label
var _condition: RichTextLabel
var _effect_heading: Label
var _effect: RichTextLabel
var _count_plaque: Panel
var _count: Label
var _selected := 0
var _collection_selected := 0
var _archive: RefCounted
var _achievement_page := 0
var _achievement_heading: Label
var _open_collection: Button
var _back_to_overview: Button
var _achievement_page_label: Label
var _achievement_open_count := 0
var _total_open_count := 0
var _achievement_previous: Button
var _achievement_next: Button
var _wins_by_oath: Dictionary = {}


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	_overview = Control.new()
	_collection = Control.new()
	for layer in [_overview, _collection]:
		layer.mouse_filter = MOUSE_FILTER_IGNORE
		UI.put(self, layer, Rect2(0, 0, 1280, 720))
	_collection.hide()
	var design: Dictionary = LAYOUT.data
	for group: Dictionary in design.groups:
		if group.label == "Достижения":
			var area := Rect2(252, 343, 292, 41)
			_open_collection = UI.hotspot(_overview, area, "Все достижения")
			UI.VISUAL.style_button(_open_collection, true)
			_achievement_heading = UI.caption(_open_collection, Rect2(Vector2.ZERO, area.size), "", 17, UI.GOLD)
			_open_collection.pressed.connect(open_collection)
		else:
			UI.caption(_overview, UI.rect(group.rect), group.label, int(group.font_size), UI.GOLD)

	var detail: Dictionary = design.detail
	_seal = UI.picture(self, null, UI.rect(detail.art_rect))
	_seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_title = UI.caption(self, Rect2(698, 338, 456, 52), "", 24, UI.GOLD)
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.max_lines_visible = 2
	_title.clip_text = true
	_title.mouse_filter = MOUSE_FILTER_PASS
	_status_plaque = UI.VISUAL.plaque(self, Rect2(838, 390, 178, 41), true)
	_status = UI.caption(self, UI.rect(detail.status_rect), "", 16, UI.GOLD)
	_condition_heading = UI.caption(self, UI.rect(detail.condition_heading_rect), "Условие", 19, UI.COPY)
	_condition = _body(UI.rect(detail.condition_rect))
	_effect_heading = UI.caption(self, UI.rect(detail.effect_heading_rect), "Эффект", 19, UI.COPY)
	_effect = _body(UI.rect(detail.effect_rect))
	_count_plaque = UI.VISUAL.plaque(self, Rect2(775, 606, 307, 49), true)
	_count = UI.caption(self, UI.rect(detail.count_rect), "", 21, UI.GOLD)


func set_archive(archive: RefCounted) -> void:
	_archive = archive
	_wins_by_oath.clear()
	for entry: Dictionary in archive.history.values():
		if entry.won:
			_wins_by_oath[int(entry.oath)] = true
	var group := ButtonGroup.new()
	_total_open_count = 0
	for layout: Dictionary in LAYOUT.data.entries:
		var entry := _describe(layout)
		_entries.append(entry)
		if entry.unlocked and layout.kind != "achievement":
			_total_open_count += 1
		_add_seal_button(layout, entry, group)
	_achievement_open_count = 0
	for achievement in ACHIEVEMENTS.ENTRIES:
		if archive.has_achievement(achievement[0]):
			_achievement_open_count += 1
	_total_open_count += _achievement_open_count
	_achievement_heading.text = "Все достижения %d/%d  ›" % [_achievement_open_count, ACHIEVEMENTS.ENTRIES.size()]
	_open_collection.accessibility_name = _achievement_heading.text
	_open_collection.tooltip_text = "Открыть полную коллекцию достижений"
	_count.text = "Открыто %d / %d" % [_total_open_count, ACHIEVEMENTS.ENTRIES.size() + 8]
	if not archive.error_message.is_empty():
		UI.caption(self, Rect2(350, 685, 580, 28), archive.error_message, 16, UI.GOLD)
	_select(0)


func first_seal() -> Button:
	return _back_to_overview if is_collection_open() else _buttons[0]


func is_collection_open() -> bool:
	return _collection.visible


func collection_title() -> String:
	return "ДОСТИЖЕНИЯ · %d/%d" % [_achievement_open_count, ACHIEVEMENTS.ENTRIES.size()]


func open_collection() -> void:
	if is_collection_open():
		return
	if _collection_buttons.is_empty():
		_build_collection()
	_overview.hide()
	_collection.show()
	_layout_details(true)
	_count.text = "Получено %d / %d" % [_achievement_open_count, ACHIEVEMENTS.ENTRIES.size()]
	_show_achievement_page(0)
	collection_mode_changed.emit(true)
	_collection_buttons[_collection_selected].grab_focus()


func close_collection(restore_focus: bool = true) -> void:
	if not is_collection_open():
		return
	_collection.hide()
	_overview.show()
	_layout_details(false)
	_count.text = "Открыто %d / %d" % [_total_open_count, ACHIEVEMENTS.ENTRIES.size() + 8]
	_select(_selected)
	collection_mode_changed.emit(false)
	if restore_focus:
		_open_collection.grab_focus()


func _describe(layout: Dictionary) -> Dictionary:
	var result := {"title": "", "condition": "", "effect": "", "unlocked": false, "status": "ЗАКРЫТО"}
	match String(layout.kind):
		"style":
			var role: String = layout.role
			var style: Array = CHARTER.STYLES[role]
			result.title = style[1]
			result.condition = "%s должен победить XIII." % RunState.get_hero_unit_data(role).unit_name
			result.effect = style[2]
			result.unlocked = _archive.style_unlocked(role)
			if result.unlocked:
				result.status = "ОТКРЫТО"
		"achievement":
			return _achievement_entry(int(layout.index) - ACHIEVEMENT_FIRST_SLOT)
		"oath":
			var rank := int(layout.rank)
			result.title = CHARTER.OATHS[rank][0]
			result.effect = CHARTER.OATHS[rank][1]
			result.condition = "Одержать первую победу над XIII." if rank == 1 else (
				"Победить с клятвой «%s»." % CHARTER.OATHS[rank - 1][0])
			result.unlocked = rank <= _archive.highest_oath()
			if result.unlocked:
				result.status = "ПРОЙДЕНО" if _wins_by_oath.has(rank) else "ДОСТУПНО"
	result["detail_texture"] = layout.open_detail_texture if result.unlocked else layout.locked_detail_texture
	return result


func _achievement_entry(index: int) -> Dictionary:
	var achievement: Array = ACHIEVEMENTS.ENTRIES[index]
	var motif: Dictionary = LAYOUT.data.entries[ACHIEVEMENT_FIRST_SLOT + index % PREVIEW_SIZE]
	var unlocked: bool = _archive.has_achievement(achievement[0])
	return {
		"id": achievement[0], "title": achievement[1], "condition": achievement[2],
		"effect": "", "unlocked": unlocked, "status": "ВЫПОЛНЕНО" if unlocked else "ЗАКРЫТО",
		"seal_texture": motif.open_texture if unlocked else motif.locked_texture,
		"detail_texture": motif.open_detail_texture if unlocked else motif.locked_detail_texture,
	}


func _add_seal_button(layout: Dictionary, entry: Dictionary, group: ButtonGroup) -> void:
	var area := UI.rect(layout.rect)
	var button := UI.hotspot(_overview, area, "%s · %s" % [entry.title, entry.status.to_lower()])
	button.toggle_mode = true
	button.button_group = group
	button.tooltip_text = button.accessibility_name
	var art_area := UI.rect(layout.art_rect)
	art_area.position -= area.position
	var path: String = layout.open_texture if entry.unlocked else layout.locked_texture
	UI.picture(button, load(ASSETS + path) as Texture2D, art_area).name = "Seal"
	_add_highlight(button, ASSETS + String(layout.selected_texture))
	button.pressed.connect(_select.bind(int(layout.index)))
	_buttons.append(button)


func _build_collection() -> void:
	var back_area := Rect2(187, 174, 250, 35)
	_back_to_overview = UI.hotspot(_collection, back_area, "К испытаниям [Esc]")
	UI.VISUAL.style_button(_back_to_overview)
	UI.caption(_back_to_overview, Rect2(Vector2.ZERO, back_area.size), "‹  К испытаниям [Esc]", 17, UI.GOLD)
	_back_to_overview.pressed.connect(close_collection)
	var group := ButtonGroup.new()
	for slot: Dictionary in COLLECTION_LAYOUT.data.slots:
		var index := int(slot.index)
		var area := UI.rect(slot.rect)
		var button := UI.hotspot(_collection, area, "")
		button.toggle_mode = true
		button.button_group = group
		_add_highlight(button, COLLECTION_ASSETS + String(slot.highlight))
		var artwork := UI.picture(button, null, Rect2((area.size.x - 68) / 2.0, 7, 68, 68))
		artwork.name = "Seal"
		artwork.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var name_plate := UI.VISUAL.plaque(button, Rect2(9, 75, area.size.x - 18, 50))
		name_plate.name = "AchievementNamePlate"
		var frame := name_plate.get_theme_stylebox("panel") as StyleBoxTexture
		for side in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			frame.set_texture_margin(side, 8)
		var caption := UI.caption(name_plate, Rect2(4, 1, area.size.x - 26, 48), "", 16, UI.GOLD)
		caption.name = "AchievementName"
		caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caption.max_lines_visible = 2
		caption.clip_text = true
		button.pressed.connect(_select_collection.bind(index))
		_collection_buttons.append(button)
	_collection_entries.resize(_collection_buttons.size())
	var pages: Dictionary = COLLECTION_LAYOUT.data.pagination
	_achievement_previous = _page_button(UI.rect(pages.previous), "‹", "Предыдущая страница", -1)
	_achievement_page_label = UI.caption(_collection, UI.rect(pages.text), "", 20, UI.GOLD)
	_achievement_next = _page_button(UI.rect(pages.next), "›", "Следующая страница", 1)


func _add_highlight(button: Button, path: String) -> void:
	var glow := UI.picture(button, load(path) as Texture2D, Rect2(Vector2.ZERO, button.size))
	glow.name = "Highlight"
	UI.VISUAL.mute_highlight(glow)
	glow.hide()
	button.focus_entered.connect(_update_highlight.bind(button))
	button.focus_exited.connect(_update_highlight.bind(button))
	button.mouse_entered.connect(_update_highlight.bind(button))
	button.mouse_exited.connect(_update_highlight.bind(button))


func _select(index: int) -> void:
	_selected = index
	_buttons[index].set_pressed_no_signal(true)
	for button in _buttons:
		_update_highlight(button)
	_render_detail(_entries[index])


func _select_collection(index: int) -> void:
	if index < 0 or index >= _collection_entries.size() or _collection_entries[index].is_empty():
		return
	_collection_selected = index
	_collection_buttons[index].set_pressed_no_signal(true)
	for button in _collection_buttons:
		_update_highlight(button)
	_render_detail(_collection_entries[index])


func _render_detail(entry: Dictionary) -> void:
	_seal.texture = load(ASSETS + String(entry.detail_texture)) as Texture2D
	_title.text = entry.title.to_upper()
	_title.tooltip_text = entry.title
	_status.text = entry.status
	_condition.text = entry.condition
	_condition.scroll_to_line(0)
	_effect.text = entry.effect
	_effect.scroll_to_line(0)
	_effect_heading.visible = not _effect.text.is_empty()
	_effect.visible = _effect_heading.visible


func _layout_details(collection: bool) -> void:
	# Same native details and art; align to the appropriate existing cabinet.
	var detail: Dictionary = LAYOUT.data.detail
	_place(_seal, Rect2(929, 184, 160, 176) if collection else UI.rect(detail.art_rect))
	_place(_title, Rect2(848, 365, 320, 74) if collection else Rect2(698, 338, 456, 52))
	_place(_status_plaque, Rect2(919, 442, 178, 41) if collection else Rect2(838, 390, 178, 41))
	_place(_status, Rect2(930, 449, 156, 27) if collection else UI.rect(detail.status_rect))
	_place(_condition_heading, Rect2(854, 494, 308, 25) if collection else UI.rect(detail.condition_heading_rect))
	_place(_condition, Rect2(856, 522, 304, 78) if collection else UI.rect(detail.condition_rect))
	_place(_count_plaque, Rect2(864, 606, 288, 49) if collection else Rect2(775, 606, 307, 49))
	_place(_count, Rect2(874, 612, 268, 37) if collection else UI.rect(detail.count_rect))


func _place(control: Control, area: Rect2) -> void:
	control.position = area.position
	control.size = area.size


func _update_highlight(button: Button) -> void:
	var glow := button.get_node("Highlight") as TextureRect
	glow.visible = button.button_pressed or button.has_focus() or button.is_hovered()
	glow.modulate.a = 1.0 if button.button_pressed else 0.45


func _page_button(area: Rect2, glyph: String, accessible_title: String, direction: int) -> Button:
	var button := UI.hotspot(_collection, area, accessible_title)
	UI.VISUAL.style_button(button)
	UI.caption(button, Rect2(Vector2.ZERO, area.size), glyph, 30, UI.GOLD).name = "Arrow"
	button.tooltip_text = accessible_title
	button.pressed.connect(_step_achievement_page.bind(direction))
	return button


func _achievement_page_count() -> int:
	return ceili(float(ACHIEVEMENTS.ENTRIES.size()) / ACHIEVEMENT_PAGE_SIZE)


func _show_achievement_page(page: int) -> void:
	_achievement_page = page
	for slot in _collection_buttons.size():
		var index := page * ACHIEVEMENT_PAGE_SIZE + slot
		var button := _collection_buttons[slot]
		var has_entry := index < ACHIEVEMENTS.ENTRIES.size()
		button.visible = has_entry
		button.disabled = not has_entry
		if not has_entry:
			_collection_entries[slot] = {}
			continue
		var entry := _achievement_entry(index)
		_collection_entries[slot] = entry
		button.accessibility_name = "%s · %s" % [entry.title, entry.status.to_lower()]
		button.tooltip_text = button.accessibility_name
		var seal := button.get_node("Seal") as TextureRect
		seal.texture = load(ASSETS + String(entry.seal_texture)) as Texture2D
		var caption := button.get_node("AchievementNamePlate/AchievementName") as Label
		caption.text = SHORT_TITLES.get(entry.id, entry.title)
		caption.add_theme_color_override("font_color", UI.GOLD if entry.unlocked else UI.MUTED)
	_achievement_page_label.text = "%d / %d" % [_achievement_page + 1, _achievement_page_count()]
	_achievement_previous.disabled = _achievement_page == 0
	_achievement_next.disabled = _achievement_page == _achievement_page_count() - 1
	for button in [_achievement_previous, _achievement_next]:
		button.get_node("Arrow").modulate.a = 0.3 if button.disabled else 1.0
	_select_collection(0)


func _step_achievement_page(direction: int) -> void:
	if not is_collection_open():
		return
	var next_page := clampi(_achievement_page + direction, 0, _achievement_page_count() - 1)
	if next_page == _achievement_page:
		return
	_show_achievement_page(next_page)
	_collection_buttons[_collection_selected].grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if not is_visible_in_tree() or not is_collection_open() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_PAGEUP or event.keycode == KEY_PAGEDOWN:
		get_viewport().set_input_as_handled()
		_step_achievement_page(-1 if event.keycode == KEY_PAGEUP else 1)


func _body(area: Rect2) -> RichTextLabel:
	var label := RichTextLabel.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("normal_font", CARD_SKIN.heading_font())
	label.add_theme_font_size_override("normal_font_size", 19)
	label.add_theme_color_override("default_color", UI.COPY)
	UI.put(self, label, area)
	return label
