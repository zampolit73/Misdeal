extends Control

const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const DOSSIER := preload("res://scripts/ui/squad_dossier_v3.gd")
const RELIC_ART := preload("res://scripts/ui/artifact_art_catalog.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_chronicle_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/wizard_chronicle_v2/chronicle_plate.webp")
const ASSETS := "res://assets/pixel/ui/wizard_chronicle_v2/"
const CARDS := ["—", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII"]
const DEFEAT_INK := UI.VISUAL.DEFEAT

var _records: Array[Dictionary] = []
var _rows: Array[Button] = []
var _party: Array[TextureRect] = []
var _relics: Array[TextureRect] = []
var _progress: Array[Label] = []
var _relic_textures: Dictionary = {}
var _page := 0
var _page_size := int(LAYOUT.data.page_size)
var _previous: Button
var _next: Button
var _page_label: Label
var _details: Control
var _outcome: Label
var _date: Label
var _loot_label: Label
var _style: Label
var _oath: Label
var _last_deal: Label
var _empty: Label


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var design: Dictionary = LAYOUT.data
	var heading: Dictionary = design.list_title
	UI.caption(self, UI.rect(heading.rect), "ЛЕТОПИСЬ ЗАБЕГОВ", int(heading.font_size), UI.GOLD)
	_build_rows(design.rows)
	var pages: Dictionary = design.pagination
	_previous = _page_button(UI.rect(pages.previous), "‹", "Предыдущая страница", -1)
	_page_label = UI.caption(self, UI.rect(pages.text), "", 20, UI.GOLD)
	_next = _page_button(UI.rect(pages.next), "›", "Следующая страница", 1)
	_build_details(design.detail)
	_empty = UI.caption(self, UI.rect(design.empty_message), "Здесь появятся завершённые забеги.", 23, UI.COPY)
	_empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func set_history(history: Dictionary, error_message: String) -> void:
	_records.assign(history.values())
	_records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.date > b.date)
	if not error_message.is_empty():
		UI.caption(self, Rect2(350, 685, 580, 28), error_message, 16, UI.GOLD)
	_show_page(0)


func first_record() -> Button:
	return _rows[0] if not _records.is_empty() else null


func _build_rows(rows: Array) -> void:
	var group := ButtonGroup.new()
	for row: Dictionary in rows:
		var index := int(row.index)
		var area := UI.rect(row.rect)
		var button := UI.hotspot(self, area, "")
		button.toggle_mode = true
		button.button_group = group
		var highlight := load(ASSETS + String(row.highlight)) as Texture2D
		var glow := UI.picture(button, highlight, Rect2(Vector2.ZERO, area.size))
		glow.name = "Highlight"
		UI.VISUAL.mute_highlight(glow)
		UI.caption(button, _local_rect(row.reached_rect, area.position), "", 23, UI.GOLD).name = "Card"
		var result := UI.caption(button, _local_rect(row.outcome_rect, area.position), "", 21, UI.GOLD)
		result.name = "Outcome"
		result.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		var date := UI.caption(button, _local_rect(row.date_rect, area.position), "", 15, UI.GOLD)
		date.name = "Date"
		date.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		date.clip_text = true
		var hero := UI.picture(button, null, _local_rect(row.portrait_rect, area.position))
		hero.name = "Hero"
		hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		button.pressed.connect(_select.bind(index))
		button.focus_entered.connect(_update_highlight.bind(button))
		button.focus_exited.connect(_update_highlight.bind(button))
		button.mouse_entered.connect(_update_highlight.bind(button))
		button.mouse_exited.connect(_update_highlight.bind(button))
		_rows.append(button)


func _build_details(design: Dictionary) -> void:
	_details = Control.new()
	_details.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_details)
	_outcome = UI.caption(_details, UI.rect(design.outcome), "", 32, UI.GOLD)
	_date = UI.caption(_details, UI.rect(design.date), "", 17, UI.COPY)
	_date.clip_text = true
	UI.caption(_details, UI.rect(design.party_label), "Отряд", 20, UI.COPY)
	_loot_label = UI.caption(_details, UI.rect(design.relic_label), "", 20, UI.COPY)
	for area: Array in design.party_slots:
		var portrait := UI.picture(_details, null, UI.rect(area))
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		portrait.mouse_filter = MOUSE_FILTER_PASS
		_party.append(portrait)
	for area: Array in design.relic_slots:
		var icon := UI.picture(_details, null, UI.rect(area))
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = MOUSE_FILTER_PASS
		_relics.append(icon)
	UI.caption(_details, UI.rect(design.progress_label), "Достигнутая карта", 19, UI.COPY)
	for index in design.progress_slots.size():
		_progress.append(UI.caption(_details, UI.rect(design.progress_slots[index]), CARDS[index + 1], 16, UI.COPY))
	_style = UI.caption(_details, UI.rect(design.style), "", 18, UI.COPY)
	_oath = UI.caption(_details, UI.rect(design.oath), "", 18, UI.COPY)
	_last_deal = UI.caption(_details, UI.rect(design.last_deal), "", 18, UI.COPY)


func _show_page(page: int) -> void:
	_page = page
	var total := ceili(float(_records.size()) / _page_size)
	for index in _rows.size():
		var button := _rows[index]
		var record_index := _page * _page_size + index
		var valid := record_index < _records.size()
		button.visible = valid
		button.disabled = not valid
		if not valid:
			continue
		var record := _records[record_index]
		var result := _result(record)
		var date := _display_date(record.date)
		var card: String = CARDS[int(record.card)]
		button.get_node("Card").text = card
		button.get_node("Outcome").text = result
		button.get_node("Date").text = date
		button.get_node("Hero").texture = _hero_portrait(record.role)
		button.accessibility_name = "%s, карта %s, %s, %s" % [result, card, date, _hero_name(record.role)]
		button.tooltip_text = button.accessibility_name
	_previous.disabled = _page == 0
	_next.disabled = _page + 1 >= total
	_update_arrow(_previous)
	_update_arrow(_next)
	_page_label.text = "%d / %d" % [_page + 1, total] if total > 0 else "—"
	_details.visible = total > 0
	_empty.visible = total == 0
	if total > 0:
		_select(0)


func _select(index: int) -> void:
	_rows[index].set_pressed_no_signal(true)
	for row in _rows:
		_update_highlight(row)
	var record := _records[_page * _page_size + index]
	var card := int(record.card)
	_outcome.text = _result(record).to_upper()
	_outcome.add_theme_color_override("font_color", UI.GOLD if record.won else DEFEAT_INK)
	_date.text = "Карта %s  ·  %s" % [CARDS[card], _display_date(record.date)]
	_date.tooltip_text = _date.text
	_date.mouse_filter = MOUSE_FILTER_PASS
	for slot in _party.size():
		var portrait := _party[slot]
		portrait.visible = slot < record.party.size()
		if portrait.visible:
			var role: String = record.party[slot]
			portrait.texture = _hero_portrait(role)
			portrait.tooltip_text = _hero_name(role)
	var relic_ids: Array[String] = []
	for id in record.relics:
		if RunState.ARTIFACT_PATHS.has(id) and not relic_ids.has(id):
			relic_ids.append(id)
	_loot_label.text = "Реликвии (%d)" % relic_ids.size()
	for slot in _relics.size():
		var icon := _relics[slot]
		icon.visible = slot < relic_ids.size()
		if icon.visible:
			var id := relic_ids[slot]
			icon.texture = _relic_icon(id)
			icon.tooltip_text = RunState.get_artifact(id).title
	for slot in _progress.size():
		var reached := slot + 1 == card
		_progress[slot].add_theme_color_override("font_color", UI.GOLD if reached else UI.MUTED)
		_progress[slot].add_theme_font_size_override("font_size", 22 if reached else 16)
		_progress[slot].add_theme_constant_override("outline_size", 2 if reached else 0)
		_progress[slot].add_theme_color_override("font_outline_color", Color("#38271e"))
	var style: String = "Классический стиль" if record.style.is_empty() else CHARTER.STYLES[record.role][1]
	_style.text = "Стиль: %s" % style
	_oath.text = "Клятва: %s" % CHARTER.OATHS[int(record.oath)][0]
	_last_deal.text = "Последняя сделка: %s" % ("использована" if record.last_deal else "не использована")


func _result(record: Dictionary) -> String:
	if not record.won:
		return "Поражение"
	return "Победа" if int(record.card) == 13 else "Итог не указан"


func _display_date(raw: String) -> String:
	var parts := raw.split("T", false, 1)
	if parts.size() == 2 and parts[0].length() == 10:
		var date := parts[0].split("-")
		if date.size() == 3:
			return "%s.%s.%s  %s" % [date[2], date[1], date[0], parts[1].left(5)]
	return raw if not raw.is_empty() else "Дата не записана"


func _hero_portrait(role: String) -> Texture2D:
	return load(String(DOSSIER.PORTRAITS[role]).replace(".webp", "_thumb.webp")) as Texture2D


func _hero_name(role: String) -> String:
	return RunState.get_hero_unit_data(role).unit_name


func _relic_icon(id: String) -> Texture2D:
	if not _relic_textures.has(id):
		var source := RELIC_ART.get_reliquary_texture(id)
		if source != null:
			var image := source.get_image()
			_relic_textures[id] = ImageTexture.create_from_image(image.get_region(image.get_used_rect()))
	return _relic_textures.get(id) as Texture2D


func _local_rect(values: Array, origin: Vector2) -> Rect2:
	var area := UI.rect(values)
	area.position -= origin
	return area


func _update_highlight(button: Button) -> void:
	var highlight := button.get_node("Highlight") as TextureRect
	highlight.visible = button.button_pressed or button.has_focus() or button.is_hovered()
	highlight.modulate.a = 1.0 if button.button_pressed else 0.45


func _page_button(area: Rect2, glyph: String, title: String, direction: int) -> Button:
	var button := UI.hotspot(self, area, title)
	UI.VISUAL.style_button(button)
	UI.caption(button, Rect2(Vector2.ZERO, area.size), glyph, 30, UI.GOLD).name = "Arrow"
	button.pressed.connect(_step_page.bind(direction))
	button.focus_entered.connect(_update_arrow.bind(button))
	button.focus_exited.connect(_update_arrow.bind(button))
	button.mouse_entered.connect(_update_arrow.bind(button))
	button.mouse_exited.connect(_update_arrow.bind(button))
	return button


func _update_arrow(button: Button) -> void:
	var label := button.get_node("Arrow") as Label
	label.modulate.a = 0.30 if button.disabled else (1.0 if button.has_focus() or button.is_hovered() else 0.75)


func _step_page(direction: int) -> void:
	var total := ceili(float(_records.size()) / _page_size)
	var next_page := _page + direction
	if next_page >= 0 and next_page < total:
		_show_page(next_page)
		_rows[0].grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if not is_visible_in_tree() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_PAGEUP or event.keycode == KEY_PAGEDOWN:
		get_viewport().set_input_as_handled()
		_step_page(-1 if event.keycode == KEY_PAGEUP else 1)
