extends Control

const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_challenges_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/wizard_challenges_v2/challenges_plate.webp")
const ASSETS := "res://assets/pixel/ui/wizard_challenges_v2/"
const ACHIEVEMENTS := preload("res://scripts/core/achievement_catalog.gd")
const ACHIEVEMENT_FIRST_SLOT := 3
const ACHIEVEMENT_PAGE_SIZE := 4


var _buttons: Array[Button] = []
var _entries: Array[Dictionary] = []
var _seal: TextureRect
var _title: Label
var _status: Label
var _condition: RichTextLabel
var _effect_heading: Label
var _effect: RichTextLabel
var _count: Label
var _selected := 0
var _archive: RefCounted
var _achievement_page := 0
var _achievement_heading: Label
var _achievement_page_label: Label
var _achievement_open_count := 0
var _achievement_previous: Button
var _achievement_next: Button
var _wins_by_oath: Dictionary = {}



func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var design: Dictionary = LAYOUT.data
	for group: Dictionary in design.groups:
		var heading := UI.caption(self, UI.rect(group.rect), group.label, int(group.font_size), UI.GOLD)
		if group.label == "Достижения":
			_achievement_heading = heading
			heading.position.y += 1
			heading.add_theme_font_size_override("font_size", 15)
			heading.size.y = 18
			_achievement_page_label = UI.caption(self, Rect2(301, 367, 194, 15), "", 13, UI.MUTED)
	_achievement_previous = _page_button(Rect2(255, 349, 41, 32), "‹", "Предыдущие достижения", -1)
	_achievement_next = _page_button(Rect2(502, 349, 41, 32), "›", "Следующие достижения", 1)

	var detail: Dictionary = design.detail
	_seal = UI.picture(self, null, UI.rect(detail.art_rect))
	_seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_title = UI.caption(self, UI.rect(detail.title_rect), "", 26, UI.GOLD)
	_title.clip_text = true
	UI.VISUAL.plaque(self, Rect2(838, 390, 178, 41), true)
	_status = UI.caption(self, UI.rect(detail.status_rect), "", 16, UI.GOLD)
	UI.caption(self, UI.rect(detail.condition_heading_rect), "Условие", 19, UI.COPY)
	_condition = _body(UI.rect(detail.condition_rect))
	_effect_heading = UI.caption(self, UI.rect(detail.effect_heading_rect), "Эффект", 19, UI.COPY)
	_effect = _body(UI.rect(detail.effect_rect))
	UI.VISUAL.plaque(self, Rect2(775, 606, 307, 49), true)
	_count = UI.caption(self, UI.rect(detail.count_rect), "", 21, UI.GOLD)


func set_archive(archive: RefCounted) -> void:
	_archive = archive
	_wins_by_oath.clear()
	for entry: Dictionary in archive.history.values():
		if entry.won:
			_wins_by_oath[int(entry.oath)] = true
	var group := ButtonGroup.new()
	var open_count := 0
	for layout: Dictionary in LAYOUT.data.entries:
		var entry := _describe(layout)
		_entries.append(entry)
		if entry.unlocked and layout.kind != "achievement":
			open_count += 1
		_add_seal_button(layout, entry, group)
	_achievement_open_count = 0
	for entry in ACHIEVEMENTS.ENTRIES:
		if archive.has_achievement(entry[0]):
			_achievement_open_count += 1
	open_count += _achievement_open_count
	_count.text = "Открыто %d / %d" % [open_count, ACHIEVEMENTS.ENTRIES.size() + 8]
	if not archive.error_message.is_empty():
		UI.caption(self, Rect2(350, 685, 580, 28), archive.error_message, 16, UI.GOLD)
	_update_page_heading()
	_select(0)


func first_seal() -> Button:
	return _buttons[0]


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
			var offset := _achievement_page * ACHIEVEMENT_PAGE_SIZE + int(layout.index) - ACHIEVEMENT_FIRST_SLOT
			var achievement: Array = ACHIEVEMENTS.ENTRIES[offset]
			result.title = achievement[1]
			result.condition = achievement[2]
			result.unlocked = _archive.has_achievement(achievement[0])
			result["id"] = achievement[0]
			if result.unlocked:
				result.status = "ВЫПОЛНЕНО"
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


func _add_seal_button(layout: Dictionary, entry: Dictionary, group: ButtonGroup) -> void:
	var area := UI.rect(layout.rect)
	var button := UI.hotspot(self, area, "%s · %s" % [entry.title, entry.status.to_lower()])
	button.toggle_mode = true
	button.button_group = group
	button.tooltip_text = button.accessibility_name
	var art_area := UI.rect(layout.art_rect)
	art_area.position -= area.position
	var path: String = layout.open_texture if entry.unlocked else layout.locked_texture
	UI.picture(button, load(ASSETS + path) as Texture2D, art_area).name = "Seal"
	if layout.kind == "achievement":
		var name_plate := UI.VISUAL.plaque(button, Rect2(0, 65, area.size.x, 29))
		name_plate.name = "AchievementNamePlate"
		var frame := name_plate.get_theme_stylebox("panel") as StyleBoxTexture
		for side in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			frame.set_texture_margin(side, 10)
		var caption := UI.caption(name_plate, Rect2(3, 1, area.size.x - 6, 27), "", 12, UI.GOLD)
		caption.name = "AchievementName"
		caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caption.max_lines_visible = 2
		caption.clip_text = true
		name_plate.hide()
	var glow := UI.picture(button, load(ASSETS + String(layout.selected_texture)) as Texture2D,
		Rect2(Vector2.ZERO, area.size))
	glow.name = "Highlight"
	UI.VISUAL.mute_highlight(glow)
	glow.hide()
	button.pressed.connect(_select.bind(int(layout.index)))
	button.focus_entered.connect(_update_highlight.bind(button))
	button.focus_exited.connect(_update_highlight.bind(button))
	button.mouse_entered.connect(_update_highlight.bind(button))
	button.mouse_exited.connect(_update_highlight.bind(button))
	_buttons.append(button)


func _select(index: int) -> void:
	_selected = index
	_buttons[index].set_pressed_no_signal(true)
	for button in _buttons:
		_update_highlight(button)
	var entry := _entries[index]
	_seal.texture = load(ASSETS + String(entry.detail_texture)) as Texture2D
	_title.text = entry.title.to_upper()
	var point_size := 26
	var font := CARD_SKIN.heading_font()
	while point_size > 18 and font.get_string_size(_title.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point_size).x > _title.size.x - 8:
		point_size -= 1
	_title.add_theme_font_size_override("font_size", point_size)
	_title.tooltip_text = entry.title
	_title.mouse_filter = MOUSE_FILTER_PASS
	_status.text = entry.status
	_condition.text = entry.condition
	_condition.scroll_to_line(0)
	_effect.text = entry.effect
	_effect.scroll_to_line(0)
	_effect_heading.visible = not _effect.text.is_empty()
	_effect.visible = _effect_heading.visible


func _update_highlight(button: Button) -> void:
	var glow := button.get_node("Highlight") as TextureRect
	glow.visible = button.button_pressed or button.has_focus() or button.is_hovered()
	glow.modulate.a = 1.0 if button.button_pressed else 0.45


func _page_button(area: Rect2, glyph: String, accessible_title: String, direction: int) -> Button:
	var button := UI.hotspot(self, area, accessible_title)
	UI.VISUAL.style_button(button)
	UI.caption(button, Rect2(Vector2.ZERO, area.size), glyph, 25, UI.GOLD).name = "Arrow"
	button.tooltip_text = accessible_title
	button.pressed.connect(_step_achievement_page.bind(direction))
	return button


func _achievement_page_count() -> int:
	return ceili(float(ACHIEVEMENTS.ENTRIES.size()) / ACHIEVEMENT_PAGE_SIZE)


func _update_page_heading() -> void:
	_achievement_heading.text = "Достижения %d/%d" % [_achievement_open_count, ACHIEVEMENTS.ENTRIES.size()]
	_achievement_heading.add_theme_font_size_override("font_size", 15)
	_achievement_page_label.text = "%d / %d" % [_achievement_page + 1, _achievement_page_count()]
	_achievement_previous.disabled = _achievement_page == 0
	_achievement_next.disabled = _achievement_page == _achievement_page_count() - 1
	for button in [_achievement_previous, _achievement_next]:
		button.get_node("Arrow").modulate.a = 0.3 if button.disabled else 1.0


func _step_achievement_page(direction: int) -> void:
	var next_page := clampi(_achievement_page + direction, 0, _achievement_page_count() - 1)
	if next_page == _achievement_page: return
	_achievement_page = next_page
	_update_page_heading()
	for index in range(ACHIEVEMENT_FIRST_SLOT, ACHIEVEMENT_FIRST_SLOT + ACHIEVEMENT_PAGE_SIZE):
		var layout: Dictionary = LAYOUT.data.entries[index]
		var entry := _describe(layout)
		_entries[index] = entry
		var button := _buttons[index]
		button.accessibility_name = "%s · %s" % [entry.title, entry.status.to_lower()]
		button.tooltip_text = button.accessibility_name
		var seal := button.get_node("Seal") as TextureRect
		var path: String = layout.open_texture if entry.unlocked else layout.locked_texture
		seal.texture = load(ASSETS + path) as Texture2D
		var art_area := UI.rect(layout.art_rect)
		art_area.position -= button.position
		if _achievement_page > 0:
			art_area = Rect2(14, 3, 66, 62)
		seal.position = art_area.position
		seal.size = art_area.size
		var plate := button.get_node("AchievementNamePlate") as Panel
		plate.visible = _achievement_page > 0
		plate.get_node("AchievementName").text = entry.title
	_select(ACHIEVEMENT_FIRST_SLOT)
	_buttons[ACHIEVEMENT_FIRST_SLOT].grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if not is_visible_in_tree() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_PAGEUP or event.keycode == KEY_PAGEDOWN:
		get_viewport().set_input_as_handled()
		_step_achievement_page(-1 if event.keycode == KEY_PAGEUP else 1)


func _body(area: Rect2) -> RichTextLabel:
	var label := RichTextLabel.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("normal_font", CARD_SKIN.heading_font())
	label.add_theme_font_size_override("normal_font_size", 18)
	label.add_theme_color_override("default_color", UI.COPY)
	UI.put(self, label, area)
	return label
