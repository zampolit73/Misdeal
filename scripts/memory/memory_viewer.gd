extends Control
const PROFILE := preload("res://scripts/memory/memory_profile.gd")
const KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
var profile: RefCounted
var reader: RichTextLabel
var art: Control
var group := "chronicle"
var list: VBoxContainer
var heading: Label

func _ready() -> void:
	if profile == null:
		profile = PROFILE.instance()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 4095
	var panel := Panel.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(panel)
	KIT.apply_panel(panel,KIT.BRONZE,true)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left","right","top","bottom"]:
		margin.add_theme_constant_override("margin_"+side,24)
	add_child(margin)
	var column := VBoxContainer.new()
	margin.add_child(column)
	var top := HBoxContainer.new()
	column.add_child(top)
	heading = Label.new()
	heading.text = "ВИТРАЖ ПАМЯТИ    %d/24" % profile.unlocked.size() + (" — ошибка сохранения" if not profile.error_message.is_empty() else "")
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	KIT.apply_subtitle(heading,KIT.BRONZE)
	top.add_child(heading)
	var close_button := Button.new()
	close_button.text = "ЗАКРЫТЬ [ESC]"
	close_button.pressed.connect(close)
	top.add_child(close_button)
	KIT.apply_action_button(close_button,KIT.BRONZE,false)
	close_button.grab_focus()
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation",24)
	column.add_child(body)
	art = Control.new()
	art.custom_minimum_size = Vector2(460,0)
	art.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(art)
	art.resized.connect(_render_art)
	art.gui_input.connect(_art_input)
	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 620
	body.add_child(right)
	var tabs := HBoxContainer.new()
	right.add_child(tabs)
	for pair in [["chronicle","Хроника"],["knight","Рыцарь"],["ranger","Следопыт"],["mage","Маг"]]:
		var button := Button.new()
		button.text = pair[1]
		button.pressed.connect(_group.bind(pair[0]))
		tabs.add_child(button)
		KIT.apply_action_button(button,KIT.BRONZE,false)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size.y = 240
	right.add_child(scroll)
	list = VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	reader = RichTextLabel.new()
	reader.size_flags_vertical = Control.SIZE_EXPAND_FILL
	reader.add_theme_font_size_override("normal_font_size",22)
	reader.add_theme_color_override("default_color",Color("e5d2ac"))
	right.add_child(reader)
	_group("chronicle")
	call_deferred("_render_art")
	modulate.a = 0
	create_tween().tween_property(self,"modulate:a",1.0,0.18)

func _render_art() -> void:
	for child in art.get_children():
		child.queue_free()
	var dimensions := Vector2(1122,1402)
	var factor := minf(art.size.x/dimensions.x,art.size.y/dimensions.y)
	var display := dimensions*factor
	var origin := (art.size-display)*0.5
	var ids: Array[String] = ["approved_vitrazh_memory"]
	if profile.unlocked.size() < 24:
		ids.append_array(profile.unlocked)
	for id in ids:
		var image := load("res://assets/story/a1v2/"+id+".png") as Texture2D
		var texture := TextureRect.new()
		texture.texture = image
		texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture.position = origin
		texture.size = display
		texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if id == "approved_vitrazh_memory" and profile.unlocked.size() < 24:
			texture.modulate = Color(0.045,0.045,0.045)
		art.add_child(texture)

func _group(value: String) -> void:
	group = value
	for child in list.get_children():
		child.queue_free()
	var count := 0
	for item in PROFILE.catalog():
		if item.group != group:
			continue
		var open: bool = profile.unlocked.has(item.id)
		if open:
			count += 1
		var button := Button.new()
		button.text = item.id + "  " + (item.title_ru if open else "Нераскрытая память")
		button.pressed.connect(_select.bind(item))
		list.add_child(button)
		KIT.apply_action_button(button,KIT.BRONZE,false)
	var total := 12 if group == "chronicle" else 4
	reader.text = "Выберите осколок. Закрытые воспоминания открываются за поступки в новых забегах."
	if count == total:
		var button := Button.new()
		button.text = "ПРОЧИТАТЬ ЦЕЛУЮ ИСТОРИЮ"
		button.pressed.connect(_closure)
		list.add_child(button)
		KIT.apply_action_button(button,KIT.BRONZE,false)
	if profile.unlocked.size() == 24:
		var button := Button.new()
		button.text = "КОГДА СТЕКЛО СТАЛО ЦЕЛЫМ"
		button.pressed.connect(func(): reader.text = "Ты видишь целую картину. Твой честный приказ обрёк замок; Канцлер подменил его обещанием помощи, а Комендант продолжил ложь, узнав правду. Ни один восстановленный осколок не возвращает погибших. Но теперь ты не можешь сказать, что видел лишь свою часть.\n\nВолшебник: «Вот и всё стекло. Прощения в нём нет — только лица»." )
		list.add_child(button)
		KIT.apply_action_button(button,KIT.BRONZE,false)

func _select(item: Dictionary) -> void:
	if not profile.unlocked.has(item.id):
		reader.text = "Эта память ещё закрыта. Продолжайте путь выбранным героем."
		return
	reader.text = item.title_ru + "\n\n" + item.memory_ru + "\n\nВолшебник: «" + item.wizard_comment_ru + "»"

func _closure() -> void:
	var texts := {"chronicle":"Замок был домом. Затем он стал временем, купленным для чужой победы. Обещания удерживали людей на стенах дольше, чем хлеб и страх; правда пришла, когда им уже не оставили выбора.","knight":"Я спас страну и потерял право считать свой приказ чистым. Я не обещал помощи. Но честность приказа не возвращает тех, кого я оставил.","ranger":"Я помню каждую дорогу. Одни вывели армию к победе, другие остались за запертыми воротами. Теперь я смотрю на путь и спрашиваю не только куда он ведёт, но кому позволят по нему пройти.","mage":"Я сумел отличить печать от подделки. Слишком поздно. Ни верная буква, ни раскрытый подлог не отменяют решения, которое я принял сам."}
	reader.text = texts[group]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			close()
		get_viewport().set_input_as_handled()

func close() -> void:
	queue_free()

func _art_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var factor := minf(art.size.x/1122.0,art.size.y/1402.0)
		var point: Vector2 = (event.position-(art.size-Vector2(1122,1402)*factor)*0.5)/factor
		if Rect2(0,0,1122,1402).has_point(point):
			var regions := (load("res://assets/story/a1v2/regions.png") as Texture2D).get_image()
			var id := roundi(regions.get_pixel(int(point.x),int(point.y)).r*255)
			if id >= 1 and id <= 24:
				_select(PROFILE.catalog()[id-1])
