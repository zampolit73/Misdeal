extends Control

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const ROUTER := preload("res://scripts/core/scene_router.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const RELIQUARY := preload("res://scripts/ui/wizard_reliquary.gd")
const BESTIARY := preload("res://scripts/ui/wizard_bestiary.gd")
const CARD_NUMBERS := ["—", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII"]

var _archive := ARCHIVE.instance()
var _tabs: Array[Button] = []
var _reader: RichTextLabel
var _summary: Label
var _reliquary: Control
var _bestiary: Control
var _plate_clip: Control
var _plate: TextureRect
var _reliquary_plate: Texture2D
var _list_view: Control
var _tab_states: Array[TextureRect] = []
var _tab_captions: Array[Label] = []
var _active_tab := 0


func _ready() -> void:
	var design: Dictionary = RELIQUARY.LAYOUT.data
	var canvas := Vector2(design.resolution[0], design.resolution[1])
	_build_list_view(canvas)

	_plate_clip = Control.new()
	_plate_clip.clip_contents = true
	_plate_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	RELIQUARY.put(self, _plate_clip, Rect2(Vector2.ZERO, canvas))
	_reliquary_plate = RELIQUARY.asset(design.plate)
	_plate = RELIQUARY.picture(_plate_clip, _reliquary_plate, Rect2(Vector2.ZERO, canvas))

	var title: Dictionary = design.title
	RELIQUARY.caption(self, RELIQUARY.rect(title.rect), "АРХИВ ВОЛШЕБНИКА", int(title.font_size), RELIQUARY.GOLD)
	var back_area := RELIQUARY.rect(design.back.rect)
	var back := RELIQUARY.hotspot(self, back_area, "В меню [Esc]")
	var back_text := RELIQUARY.caption(back, Rect2(Vector2.ZERO, back_area.size),
		"В меню [Esc]", int(design.back.font_size), RELIQUARY.GOLD)
	back.focus_entered.connect(func() -> void: back_text.modulate = Color(1.2, 1.2, 1.2))
	back.focus_exited.connect(func() -> void: back_text.modulate = Color.WHITE)
	back.pressed.connect(_close)

	for tab: Dictionary in design.tabs:
		var index := int(tab.index)
		var area := RELIQUARY.rect(tab.rect)
		var button := RELIQUARY.hotspot(self, area, tab.label)
		var active := RELIQUARY.picture(button, RELIQUARY.asset(tab.active_texture), Rect2(Vector2.ZERO, area.size))
		var text_area := RELIQUARY.rect(tab.text_rect)
		text_area.position -= area.position
		var caption := RELIQUARY.caption(button, text_area, tab.label, 22, RELIQUARY.GOLD)
		_tabs.append(button)
		_tab_states.append(active)
		_tab_captions.append(caption)
		button.pressed.connect(_show_tab.bind(index))
		button.focus_entered.connect(_update_tab.bind(index))
		button.focus_exited.connect(_update_tab.bind(index))
		button.mouse_entered.connect(_update_tab.bind(index))
		button.mouse_exited.connect(_update_tab.bind(index))

	_reliquary = RELIQUARY.new()
	add_child(_reliquary)
	_reliquary.set_collection(_archive.relics, _archive.error_message)
	_tabs[0].focus_neighbor_bottom = _tabs[0].get_path_to(_reliquary.first_niche())
	_show_tab(0)


func _build_list_view(canvas: Vector2) -> void:
	_list_view = Control.new()
	_list_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	RELIQUARY.put(self, _list_view, Rect2(Vector2.ZERO, canvas))
	var backdrop := RELIQUARY.picture(_list_view, preload("res://assets/pixel/ui/wizard_archive/library.webp"),
		Rect2(Vector2.ZERO, canvas))
	var candlelight := ShaderMaterial.new()
	candlelight.shader = preload("res://shaders/wizard_archive_candlelight.gdshader")
	backdrop.material = candlelight
	var frame := NinePatchRect.new()
	frame.texture = preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
	frame.patch_margin_left = 64
	frame.patch_margin_right = 64
	frame.patch_margin_top = 64
	frame.patch_margin_bottom = 64
	frame.modulate.a = 0.89
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	RELIQUARY.put(_list_view, frame, Rect2(112, 163, 1056, 527))
	_summary = Label.new()
	_summary.add_theme_font_size_override("font_size", 16)
	UI.apply_screen_copy(_summary, UI.GOLD)
	RELIQUARY.put(_list_view, _summary, Rect2(142, 183, 960, 24))
	_reader = RichTextLabel.new()
	_reader.bbcode_enabled = true
	_reader.focus_mode = Control.FOCUS_ALL
	_reader.add_theme_color_override("default_color", UI.TEXT)
	_reader.add_theme_font_size_override("normal_font_size", 16)
	_reader.add_theme_constant_override("line_separation", 5)
	RELIQUARY.put(_list_view, _reader, Rect2(141, 220, 960, 416))


func _update_tab(index: int) -> void:
	var button := _tabs[index]
	var active := index == _active_tab
	_tab_states[index].visible = active or button.has_focus() or button.is_hovered()
	_tab_states[index].modulate.a = 1.0 if active else 0.48
	_tab_captions[index].modulate = Color(1.18, 1.18, 1.18) if button.has_focus() else Color.WHITE



func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_close()


func _close() -> void:
	ROUTER.change_to(self, "res://scenes/main/main.tscn")


func _show_tab(index: int) -> void:
	_active_tab = index
	for slot in _tabs.size():
		_update_tab(slot)
	_tabs[index].grab_focus()
	var is_reliquary := index == 0
	var is_bestiary := index == 1
	_reliquary.visible = is_reliquary
	_list_view.visible = not (is_reliquary or is_bestiary)
	_plate.texture = BESTIARY.PLATE if is_bestiary else _reliquary_plate
	_plate_clip.size.y = _plate.size.y if not _list_view.visible else 164.0
	if is_bestiary and _bestiary == null:
		_bestiary = BESTIARY.new()
		add_child(_bestiary)
		_bestiary.set_collection(_archive.enemies, _archive.error_message)
		_tabs[1].focus_neighbor_bottom = _tabs[1].get_path_to(_bestiary.first_niche())
	if _bestiary != null:
		_bestiary.visible = is_bestiary
	if not _list_view.visible:
		return
	match index:
		2: _show_history()
		3: _show_challenges()
	if not _archive.error_message.is_empty():
		_summary.text += "   ·   " + _archive.error_message
	_reader.scroll_to_line(0)


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
