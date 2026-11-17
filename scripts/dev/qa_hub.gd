extends Control
## Unified F6 navigator. The shipped game's main scene and menus stay unchanged.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const CATALOG := preload("res://scripts/dev/qa_hub_catalog.gd")
const SESSION := preload("res://scripts/dev/qa_hub_session.gd")
const CATEGORIES := CATALOG.GROUPS
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var _entries: Array[Dictionary] = []
var _active_group := "ВСЁ"
var _selected := -1
var _list: VBoxContainer
var _detail_title: Label
var _detail_description: Label
var _detail_path: Label
var _status: Label
var _launch: Button
var _search: LineEdit
var _count: Label
var _party: OptionButton
var _gold: SpinBox
var _recruitment: CheckBox
var _upgrades: CheckBox
var _visible_indices: Array[int] = []
var session: Node

func _ready() -> void:
	name="QAHub"
	process_mode=Node.PROCESS_MODE_ALWAYS
	session=SESSION.ensure(self)
	_entries=CATALOG.entries()
	_build()
	_active_group=session.hub_group
	_search.text=session.hub_query
	if not session.last_options.is_empty():
		var party_index: int=PARTIES.find(session.last_options.get("roles",[]))
		if party_index>=0: _party.select(party_index)
		_gold.value=session.last_options.get("gold",200)
		_recruitment.button_pressed=session.last_options.get("recruitment",true)
		_upgrades.button_pressed=session.last_options.get("upgrades",false)
	_show_group(_active_group)
	get_viewport().size_changed.connect(_fit)
	_fit()

func _fit() -> void:
	var screen:=get_viewport_rect().size
	var fit:=minf(screen.x/1280.0,screen.y/720.0)
	scale=Vector2.ONE*fit
	position=(screen-Vector2(1280,720)*fit)*0.5

func get_entries() -> Array:
	return _entries.duplicate(true)

func get_visible_entries() -> Array:
	var rows: Array=[]
	for index in _visible_indices: rows.append(_entries[index].duplicate(true))
	return rows

func _build() -> void:
	var background:=ColorRect.new()
	background.color=DS3.OBSIDIAN
	background.size=Vector2(1280,720)
	background.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(background)
	_add_text("MISDEAL / QA HUB",Vector2(38,20),Vector2(1000,48),32,DS3.PARCHMENT)
	_add_text("КАРТЫ · СОБЫТИЯ · БОИ · TRAVEL · ГЕРОИ · ИНТЕРФЕЙС",Vector2(40,73),Vector2(1180,26),15,DS3.MUTED)
	var categories:=HBoxContainer.new()
	categories.name="Categories"
	categories.position=Vector2(36,112)
	categories.add_theme_constant_override("separation",6)
	add_child(categories)
	for group in CATEGORIES:
		var button:=Button.new()
		button.text=group
		button.custom_minimum_size=Vector2(128,36)
		button.add_theme_font_size_override("font_size",13)
		DS3.apply_action(button,false)
		button.pressed.connect(_show_group.bind(group))
		categories.add_child(button)
	_search=LineEdit.new()
	_search.name="Search"
	_search.placeholder_text="Поиск: название, ID карты или путь сцены…"
	_search.position=Vector2(36,158)
	_search.size=Vector2(492,34)
	_search.text_changed.connect(func(_text: String):_show_group(_active_group))
	add_child(_search)
	_count=_text_node("",Vector2(550,163),Vector2(690,26),14,DS3.MUTED)
	add_child(_count)
	var left:=Panel.new()
	left.name="ScenePanel"
	left.position=Vector2(36,204)
	left.size=Vector2(492,450)
	DS3.apply_surface(left,"dossier")
	add_child(left)
	var scroll:=ScrollContainer.new()
	scroll.name="SceneScroll"
	scroll.position=Vector2(14,14)
	scroll.size=Vector2(464,422)
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	left.add_child(scroll)
	_list=VBoxContainer.new()
	_list.name="SceneList"
	_list.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation",6)
	scroll.add_child(_list)
	var right:=Panel.new()
	right.name="DetailPanel"
	right.position=Vector2(546,204)
	right.size=Vector2(696,450)
	DS3.apply_surface(right,"dossier")
	add_child(right)
	_detail_title=_text_node("Выберите сцену",Vector2(26,24),Vector2(644,62),24,DS3.PARCHMENT)
	_detail_title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_detail_title)
	_detail_description=_text_node("",Vector2(26,95),Vector2(642,82),16,DS3.TEXT)
	_detail_description.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_detail_description)
	_detail_path=_text_node("",Vector2(26,181),Vector2(642,36),11,DS3.MUTED)
	_detail_path.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_detail_path)
	_party=OptionButton.new()
	_party.name="Party"
	for label in ["Рыцарь — solo","Следопыт — solo","Маг — solo","Рыцарь + Следопыт","Рыцарь + Маг","Следопыт + Маг","Все герои — trio"]:_party.add_item(label)
	_party.select(6)
	_party.position=Vector2(26,228)
	_party.size=Vector2(355,34)
	right.add_child(_party)
	_gold=SpinBox.new()
	_gold.name="Gold"
	_gold.prefix="Золото: "
	_gold.max_value=999
	_gold.value=200
	_gold.position=Vector2(400,228)
	_gold.size=Vector2(266,34)
	right.add_child(_gold)
	_recruitment=CheckBox.new()
	_recruitment.text="Спутники доступны для найма"
	_recruitment.button_pressed=true
	_recruitment.position=Vector2(26,275)
	_recruitment.add_theme_font_size_override("font_size",13)
	right.add_child(_recruitment)
	_upgrades=CheckBox.new()
	_upgrades.text="Дать по 1 развитию"
	_upgrades.position=Vector2(390,275)
	_upgrades.add_theme_font_size_override("font_size",13)
	right.add_child(_upgrades)
	right.add_child(_text_node("Параметры — для реальных карт; авторские превью имеют свои настройки.",Vector2(28,314),Vector2(640,23),11,DS3.MUTED))
	_launch=Button.new()
	_launch.name="LaunchButton"
	_launch.text="ЗАПУСТИТЬ ПРОВЕРКУ"
	_launch.position=Vector2(26,348)
	_launch.size=Vector2(642,48)
	DS3.apply_action(_launch,true)
	_launch.pressed.connect(_launch_selected)
	right.add_child(_launch)
	_status=_text_node("",Vector2(28,405),Vector2(640,34),12,DS3.NEGATIVE)
	_status.name="Status"
	_status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	right.add_child(_status)
	_add_text("F10 — вернуться в хаб · F9 — повторить запуск · F11 — скрыть QA-панель",Vector2(38,667),Vector2(1200,24),14,DS3.PARCHMENT)
	_add_text("Отдельные QA-сохранение и витраж. Обычный прогресс не перезаписывается.",Vector2(38,693),Vector2(1200,22),12,DS3.MUTED)

func _show_group(group: String) -> void:
	_active_group=group
	session.hub_group=group
	session.hub_query=_search.text
	for child in _list.get_children():
		_list.remove_child(child)
		child.queue_free()
	_visible_indices.clear()
	var query:=_search.text.strip_edges().to_lower()
	for index in range(_entries.size()):
		var entry: Dictionary=_entries[index]
		if group=="ВСЁ" and entry.group=="АРХИВ": continue
		if group!="ВСЁ" and entry.group!=group: continue
		var haystack: String=(str(entry.title)+" "+str(entry.scene)+" "+str(entry.get("search",""))+" "+str(entry.desc)).to_lower()
		if not query.is_empty() and not haystack.contains(query): continue
		_visible_indices.append(index)
		var button:=Button.new()
		button.name="Scene"+str(index)
		button.text=str(entry.title)
		button.tooltip_text=str(entry.get("card_id",entry.scene))
		button.alignment=HORIZONTAL_ALIGNMENT_LEFT
		button.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS
		button.custom_minimum_size=Vector2(430,40)
		button.add_theme_font_size_override("font_size",15)
		DS3.apply_action(button,false)
		button.pressed.connect(_select.bind(index))
		_list.add_child(button)
	for button in $Categories.get_children():DS3.apply_action(button,button.text==group)
	_count.text="Найдено: %d · Актуальные сцены и карты; старые кандидаты — в «Архиве»." % _visible_indices.size()
	var chosen: int=_visible_indices[0] if not _visible_indices.is_empty() else -1
	for index in _visible_indices:
		if _entries[index].id==session.hub_selected: chosen=index
	_select(chosen)

func _select(index: int) -> void:
	_selected=index
	if index<0:
		_detail_title.text="Ничего не найдено"
		_detail_description.text="Измените запрос или раздел. Поиск работает также по ID карты и имени файла."
		_detail_path.text=""
		_status.text=""
		_launch.disabled=true
		return
	var entry: Dictionary=_entries[index]
	session.hub_selected=entry.id
	_detail_title.text=entry.title
	_detail_description.text=entry.desc
	_detail_path.text=str(entry.get("card_id",""))+"  "+str(entry.scene)
	_status.text=session.error_message
	_launch.disabled=not ResourceLoader.exists(entry.scene,"PackedScene") or not session.available
	for button in _list.get_children():DS3.apply_action(button,button.name=="Scene"+str(index))

func _launch_selected() -> void:
	if _selected<0:return
	var options: Dictionary={"roles":PARTIES[_party.selected].duplicate(),"gold":int(_gold.value),"recruitment":_recruitment.button_pressed,"upgrades":_upgrades.button_pressed}
	if not session.launch_entry(_entries[_selected],options):
		_status.text=session.error_message if not session.error_message.is_empty() else "Не удалось открыть сцену."

func _add_text(value: String,pos: Vector2,dimensions: Vector2,font: int,color: Color) -> void:
	add_child(_text_node(value,pos,dimensions,font,color))

func _text_node(value: String,pos: Vector2,dimensions: Vector2,font: int,color: Color) -> Label:
	var label:=Label.new()
	label.text=value
	label.position=pos
	label.size=dimensions
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size",font)
	label.add_theme_color_override("font_color",color)
	return label
