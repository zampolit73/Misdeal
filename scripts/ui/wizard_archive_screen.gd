extends Control

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const ROUTER := preload("res://scripts/core/scene_router.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ART := preload("res://scripts/ui/runtime_webp_texture.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const TABS := ["Реликварий", "Бестиарий", "Летопись забегов", "Испытания"]
const CARD_NUMBERS := ["—", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII"]

var _archive := ARCHIVE.instance()
var _tabs: Array[Button] = []
var _reader: RichTextLabel
var _summary: Label


func _ready() -> void:
	var backdrop := ART.new() as TextureRect
	backdrop.set("webp_path", "res://assets/pixel/class_select/d281_clean_table_hd.webp")
	backdrop.set("expected_size", Vector2i(1280,720))
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var plate := Panel.new()
	plate.position = Vector2(131, 42)
	plate.size = Vector2(1018, 636)
	add_child(plate)
	UI.apply_v2_material_plate(plate, true)
	var title := Label.new()
	title.text = "АРХИВ ВОЛШЕБНИКА"
	title.position = Vector2(28, 22)
	title.add_theme_font_size_override("font_size", 30)
	plate.add_child(title)
	UI.apply_screen_copy(title, UI.PARCHMENT_WARM, true)
	title.add_theme_font_override("font", CARD_SKIN.heading_font())
	var back := Button.new()
	back.text = "В меню  [Esc]"
	back.position = Vector2(807, 26)
	back.size = Vector2(182, 41)
	plate.add_child(back)
	UI.apply_action_button(back, UI.BRONZE)
	back.pressed.connect(_close)
	var row := HBoxContainer.new()
	row.position = Vector2(29, 88)
	row.size = Vector2(960, 46)
	row.add_theme_constant_override("separation", 10)
	plate.add_child(row)
	for index in TABS.size():
		var button := Button.new()
		button.text = TABS[index]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(button)
		UI.apply_action_button(button, UI.BRONZE)
		button.pressed.connect(_show_tab.bind(index))
		_tabs.append(button)
	_summary = Label.new()
	_summary.position = Vector2(30, 153)
	_summary.add_theme_font_size_override("font_size", 16)
	plate.add_child(_summary)
	UI.apply_screen_copy(_summary, UI.GOLD)
	_reader = RichTextLabel.new()
	_reader.bbcode_enabled = true
	_reader.focus_mode = Control.FOCUS_ALL
	_reader.position = Vector2(29, 190)
	_reader.size = Vector2(960, 416)
	_reader.add_theme_color_override("default_color", UI.TEXT)
	_reader.add_theme_font_size_override("normal_font_size", 16)
	_reader.add_theme_constant_override("line_separation", 5)
	plate.add_child(_reader)
	_show_tab(0)
	_tabs[0].grab_focus()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_close()


func _close() -> void:
	ROUTER.change_to(self, "res://scenes/main/main.tscn")


func _show_tab(index: int) -> void:
	for slot in _tabs.size():
		UI.apply_selected_button(_tabs[slot], slot == index)
	_tabs[index].grab_focus()
	match index:
		0: _show_relics()
		1: _show_enemies()
		2: _show_history()
		3: _show_challenges()
	if not _archive.error_message.is_empty():
		_summary.text += "   ·   " + _archive.error_message
	_reader.scroll_to_line(0)


func _show_relics() -> void:
	var found := 0
	var rows := PackedStringArray()
	for id in RunState.ARTIFACT_PATHS:
		if _archive.relics.has(id):
			var relic := RunState.get_artifact(id)
			rows.append(_entry(relic.title, relic.description))
			found += 1
		else:
			rows.append("[color=#9c8a7f]Неизвестная реликвия[/color]")
	_summary.text = "Найдено %d / %d" % [found, RunState.ARTIFACT_PATHS.size()]
	_reader.text = "\n\n".join(rows)


func _show_enemies() -> void:
	var rows := PackedStringArray()
	var found := 0
	for id in ARCHIVE.ENEMY_IDS:
		if not _archive.enemies.has(id):
			rows.append("[color=#9c8a7f]Противник ещё не встречен[/color]")
			continue
		var data := load("res://resources/units/%s.tres" % id) as UnitData
		var feature := "Атакует с расстояния." if data.attack_range >= 120.0 else "Вступает в ближний бой."
		if data.support_heal_amount > 0.0: feature += " Лечит раненых союзников."
		if data.splash_radius > 0.0: feature += " Способен задеть несколько целей."
		if data.is_boss: feature = "Противник XIII. Тяжёлые удары поражают область вокруг цели."
		rows.append(_entry(data.unit_name, feature))
		found += 1
	_summary.text = "Встречено %d / %d" % [found, ARCHIVE.ENEMY_IDS.size()]
	_reader.text = "\n\n".join(rows)


func _show_history() -> void:
	var rows := PackedStringArray()
	var entries: Array = _archive.history.values()
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.date > b.date)
	var victories := 0
	for record: Dictionary in entries:
		if record.won: victories += 1
		var team := PackedStringArray()
		for role in record.party: team.append(RunState.get_hero_unit_data(role).unit_name)
		var loot := PackedStringArray()
		for id in record.relics:
			if RunState.ARTIFACT_PATHS.has(id): loot.append(RunState.get_artifact(id).title)
		var result := "Победа" if record.won else "Поражение"
		var leader := RunState.get_hero_unit_data(record.role).unit_name
		var style := "Классический стиль" if record.style.is_empty() else String(CHARTER.STYLES[record.role][1])
		var title := "%s · %s · карта %s" % [result, leader, CARD_NUMBERS[int(record.card)]]
		var detail := "%s · %s\nОтряд: %s\nРеликвии: %s" % [CHARTER.OATHS[int(record.oath)][0], style, ", ".join(team), ", ".join(loot) if not loot.is_empty() else "—"]
		rows.append(_entry(title, detail))
	_summary.text = "Побед %d   ·   Поражений %d" % [victories, entries.size() - victories]
	_reader.text = "\n\n".join(rows) if not rows.is_empty() else "Здесь появятся завершённые забеги."


func _show_challenges() -> void:
	var rows := PackedStringArray()
	for role in ARCHIVE.ROLES:
		var hero := RunState.get_hero_unit_data(role).unit_name
		rows.append(_challenge(String(CHARTER.STYLES[role][1]), "%s должен победить XIII." % hero, _archive.style_unlocked(role)))
	var solo := false
	var trio := false
	var no_deal := false
	var final_oath := false
	for entry in _archive.history.values():
		if not entry.won: continue
		solo = solo or entry.party.size() == 1
		trio = trio or entry.party.size() == 3
		no_deal = no_deal or not entry.last_deal
		final_oath = final_oath or int(entry.oath) == CHARTER.OATHS.size() - 1
	rows.append(_challenge("Один против XIII", "Победить с одним героем в отряде.", solo))
	rows.append(_challenge("Три судьбы", "Победить полным отрядом.", trio))
	rows.append(_challenge("Без второй попытки", "Победить без Последней сделки.", no_deal))
	rows.append(_challenge("Вопреки последней ставке", "Победить с пятой клятвой.", final_oath))
	for rank in range(1, CHARTER.OATHS.size()):
		rows.append(_challenge(CHARTER.OATHS[rank][0], CHARTER.OATHS[rank][1], rank <= _archive.highest_oath()))
	_summary.text = "После первой победы открывается клятва I. Победа с клятвой открывает следующую."
	_reader.text = "\n\n".join(rows)


func _entry(title: String, detail: String) -> String:
	return "[color=#e4c693][b]%s[/b][/color]\n%s" % [title, detail]


func _challenge(title: String, detail: String, unlocked: bool) -> String:
	return _entry(title, "%s  ·  %s" % ["Открыто" if unlocked else "Закрыто", detail])
