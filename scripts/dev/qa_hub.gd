extends Control

# OPT4: F6-only test navigator. Never added to the normal game's main scene.
# Existing authored previews keep responsibility for their own Battle setups.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const CATEGORIES := ["ВСЁ", "ИГРА", "КАРТЫ", "БОЙ", "АНИМАЦИИ", "ИНТЕРФЕЙС"]
const ENTRIES := [
	{"group": "ИГРА", "title": "Начало партии", "scene": "res://scenes/main/main.tscn",
	 "desc": "Полный игровой маршрут: начало → выбор героя → проклятый стол.",
	 "prep": ""},
	{"group": "ИГРА", "title": "Выбор героя", "scene": "res://scenes/class_select/class_select.tscn",
	 "desc": "Проверка трёх персонажей и начального интерфейса.", "prep": ""},
	{"group": "ИГРА", "title": "Стол с картами", "scene": "res://scenes/table/table.tscn",
	 "desc": "Настоящий стол с подготовленным Рыцарем и текущей раздачей.",
	 "prep": "knight"},
	{"group": "КАРТЫ", "title": "Галерея Card DS3", "scene": "res://scenes/dev/d315_card_ds3_gallery.tscn",
	 "desc": "Все карточные изображения, подписи, оптические центры и полный просмотр.", "prep": ""},
	{"group": "КАРТЫ", "title": "Карточные события", "scene": "res://scenes/dev/deck_expansion_d149_event_preview.tscn",
	 "desc": "Проверка событий без изменения утверждённых иллюстраций.", "prep": ""},
	{"group": "БОЙ", "title": "Засада на кладбище", "scene": "res://scenes/battle/battle.tscn",
	 "desc": "Настоящий бой: Рыцарь против скелетов; перед боем можно настроить расстановку.",
	 "prep": "graveyard"},
	{"group": "БОЙ", "title": "Суд Безмолвных", "scene": "res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn",
	 "desc": "Авторский QA-пускатель: 1–3 героя, реальные враги и две расстановки.", "prep": ""},
	{"group": "БОЙ", "title": "Дорога чёрных фонарей", "scene": "res://scenes/dev/black_lantern_d260_released_battle_preview.tscn",
	 "desc": "Пять оригинальных врагов, варианты отряда и настоящий маршрут Battle → Reward → Table.",
	 "prep": ""},
	{"group": "АНИМАЦИИ", "title": "Персонажи Суда — 25 кадров",
	 "scene": "res://scenes/dev/court_of_the_mute_d267_three_animation_preview.tscn",
	 "desc": "Три оригинальных атласа с Idle, Walk, Attack, Hit и Death.", "prep": ""},
	{"group": "АНИМАЦИИ", "title": "Нежить: Pack 2",
	 "scene": "res://scenes/dev/unit_animation_pack2_preview.tscn",
	 "desc": "Сравнение игровых спрайтов и неутверждённых кандидатов; оригиналы не заменяются.",
	 "prep": ""},
	{"group": "ИНТЕРФЕЙС", "title": "Панель волшебника",
	 "scene": "res://scenes/dev/d308_wizard_panel_preview.tscn",
	 "desc": "Условие звонаря, награда и рисованная табличка волшебника.", "prep": ""},
	{"group": "ИНТЕРФЕЙС", "title": "Досье отряда",
	 "scene": "res://scenes/dev/design_system_components_preview.tscn",
	 "desc": "Элементы интерфейса и существующая дизайн-система.", "prep": ""}
]

var _active_group := "ВСЁ"
var _selected := 0
var _list: VBoxContainer
var _detail_title: Label
var _detail_description: Label
var _detail_path: Label
var _status: Label
var _launch: Button

func _ready() -> void:
	name = "QAHub"
	_build()
	_show_group("ВСЁ")
	_select(0)

func get_entries() -> Array:
	return ENTRIES.duplicate(true)

func _build() -> void:
	var background := ColorRect.new()
	background.color = DS3.OBSIDIAN
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var glow := ColorRect.new()
	glow.color = Color(0.19, 0.038, 0.038, 0.18)
	glow.position = Vector2(0, 0)
	glow.size = Vector2(1280, 155)
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(glow)
	_add_text("MISDEAL / QA HUB", Vector2(39, 23), Vector2(850, 48), 32, DS3.PARCHMENT)
	_add_text("БЫСТРЫЙ ДОСТУП К РЕАЛЬНЫМ СЦЕНАМ  ·  ТОЛЬКО РЕЖИМ F6", Vector2(42, 79),
		Vector2(1120, 27), 15, DS3.MUTED)

	var category_row := HBoxContainer.new()
	category_row.name = "Categories"
	category_row.position = Vector2(35, 125)
	category_row.size = Vector2(1208, 46)
	category_row.add_theme_constant_override("separation", 7)
	add_child(category_row)
	for group in CATEGORIES:
		var button := Button.new()
		button.name = "Category" + str(CATEGORIES.find(group))
		button.text = group
		button.custom_minimum_size = Vector2(185, 43)
		DS3.apply_action(button, group == _active_group)
		button.pressed.connect(_show_group.bind(group))
		category_row.add_child(button)

	var left := Panel.new()
	left.name = "ScenePanel"
	left.position = Vector2(36, 195)
	left.size = Vector2(495, 460)
	DS3.apply_surface(left, "dossier")
	add_child(left)

	var scroll := ScrollContainer.new()
	scroll.name = "SceneScroll"
	scroll.position = Vector2(17, 16)
	scroll.size = Vector2(461, 430)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left.add_child(scroll)
	_list = VBoxContainer.new()
	_list.name = "SceneList"
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 8)
	scroll.add_child(_list)

	var right := Panel.new()
	right.name = "DetailPanel"
	right.position = Vector2(549, 195)
	right.size = Vector2(691, 460)
	DS3.apply_surface(right, "dossier")
	add_child(right)

	_detail_title = _text_node("Выберите сцену", Vector2(26, 30), Vector2(635, 74), 25, DS3.PARCHMENT)
	_detail_title.name = "DetailTitle"
	right.add_child(_detail_title)
	_detail_description = _text_node("", Vector2(28, 118), Vector2(628, 117), 17, DS3.TEXT)
	_detail_description.name = "DetailDescription"
	_detail_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_detail_description)
	_detail_path = _text_node("", Vector2(28, 255), Vector2(621, 58), 12, DS3.MUTED)
	_detail_path.name = "DetailPath"
	_detail_path.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_detail_path)

	_launch = Button.new()
	_launch.name = "LaunchButton"
	_launch.text = "ЗАПУСТИТЬ СЦЕНУ"
	_launch.position = Vector2(26, 340)
	_launch.size = Vector2(639, 54)
	DS3.apply_action(_launch, true)
	_launch.pressed.connect(_launch_selected)
	right.add_child(_launch)
	_status = _text_node("", Vector2(28, 409), Vector2(629, 37), 13, DS3.NEGATIVE)
	_status.name = "Status"
	right.add_child(_status)

	_add_text("Открытие: F6 на qa_hub.tscn  ·  Вернуться: снова F6  ·  Проверки не сохраняют прогресс.",
		Vector2(38, 670), Vector2(1190, 35), 14, DS3.MUTED)

func _show_group(group: String) -> void:
	_active_group = group
	if _list == null:
		return
	for child in _list.get_children():
		_list.remove_child(child)
		child.queue_free()
	var first := -1
	for index in range(ENTRIES.size()):
		var entry: Dictionary = ENTRIES[index]
		if group != "ВСЁ" and entry["group"] != group:
			continue
		if first < 0:
			first = index
		var button := Button.new()
		button.name = "Scene" + str(index)
		button.text = str(entry["title"])
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.custom_minimum_size = Vector2(433, 42)
		DS3.apply_action(button, index == _selected)
		button.pressed.connect(_select.bind(index))
		_list.add_child(button)
	for child in $Categories.get_children():
		var button := child as Button
		DS3.apply_action(button, button.text == group)
	if first >= 0:
		_select(first)

func _select(index: int) -> void:
	if index < 0 or index >= ENTRIES.size():
		return
	_selected = index
	var entry: Dictionary = ENTRIES[index]
	_detail_title.text = str(entry["title"])
	_detail_description.text = str(entry["desc"])
	_detail_path.text = str(entry["scene"])
	_status.text = ""
	_launch.disabled = not ResourceLoader.exists(str(entry["scene"]), "PackedScene")
	if _launch.disabled:
		_status.text = "Не найдена игровая сцена — запуск запрещён."
	for node in _list.get_children():
		var button := node as Button
		DS3.apply_action(button, button.name == "Scene" + str(index))

func _launch_selected() -> void:
	var entry: Dictionary = ENTRIES[_selected]
	var path: String = entry["scene"]
	if not ResourceLoader.exists(path, "PackedScene"):
		_status.text = "Сцена не найдена: " + path
		return
	var prep: String = entry["prep"]
	if prep != "":
		RunState.reset_run()
		if not RunState.choose_protagonist("knight"):
			_status.text = "Не удалось подготовить Рыцаря для QA."
			return
		if prep == "graveyard":
			RunState.select_encounter("res://resources/encounters/graveyard_ambush.tres")
	get_tree().change_scene_to_file(path)

func _add_text(value: String, pos: Vector2, dimensions: Vector2, font: int, color: Color) -> void:
	add_child(_text_node(value, pos, dimensions, font, color))

func _text_node(value: String, pos: Vector2, dimensions: Vector2, font: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.add_theme_font_size_override("font_size", font)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label
