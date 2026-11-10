extends Control
const PROFILE := preload("res://scripts/memory/memory_profile.gd")
const FRAME := preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
const GROUPS := [["chronicle","Хроника"],["knight","Рыцарь"],["ranger","Следопыт"],["mage","Маг"]]
const GOLD := Color("c79958")
const BONE := Color("ead9b9")
const MUTED := Color("a69a87")
var profile: RefCounted
var reader: RichTextLabel
var art: Control
var group := "chronicle"
var list: HBoxContainer
var heading: Label
var title_label: Label
var section_label: Label
var page_label: Label
var canvas: Control
var page := 0
var selected_id := ""
var tabs: Dictionary = {}
var fragments: Dictionary = {}
var previous: Button
var next: Button
var closure_button: Button
var full_button: Button
var serif: SystemFont
var body: SystemFont

func _ready() -> void:
	if profile == null: profile = PROFILE.instance()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 4095
	serif=SystemFont.new()
	serif.font_names=PackedStringArray(["Georgia","Times New Roman","DejaVu Serif"])
	body=SystemFont.new()
	body.font_names=PackedStringArray(["Segoe UI","Arial","DejaVu Sans"])
	var shade:=ColorRect.new()
	shade.color=Color(0.008,0.006,0.006,0.97)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	canvas=Control.new()
	canvas.size=Vector2(1280,720)
	canvas.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(canvas)
	_frame(Rect2(20,16,1240,688))
	_label("ВИТРАЖ ПАМЯТИ",Rect2(58,38,850,44),32,BONE,true)
	_label("Память не меняет прошлого. Она возвращает ему лица.",Rect2(60,84,850,24),14,MUTED)
	var close_button:=_button("ЗАКРЫТЬ · ESC",Rect2(1064,44,154,36),close)
	close_button.grab_focus()
	_frame(Rect2(60,113,409,505))
	art=Control.new()
	art.position=Vector2(72,125)
	art.size=Vector2(385,481)
	canvas.add_child(art)
	art.gui_input.connect(_art_input)
	for index in range(4):
		var pair: Array=GROUPS[index]
		var count:=_count(pair[0])
		var total:=12 if index==0 else 4
		tabs[pair[0]]=_button("%s · %d/%d"%[pair[1].to_upper(),count,total],Rect2(526+index*173,124,165,36),_group.bind(pair[0]))
	_frame(Rect2(526,179,688,350))
	section_label=_label("",Rect2(569,211,600,24),12,GOLD)
	title_label=_label("",Rect2(556,246,620,62),30,BONE,true)
	_rule(556,319,620)
	reader=RichTextLabel.new()
	reader.position=Vector2(556,340)
	reader.size=Vector2(620,164)
	reader.bbcode_enabled=true
	reader.focus_mode=Control.FOCUS_ALL
	reader.add_theme_font_override("normal_font",serif)
	reader.add_theme_font_size_override("normal_font_size",22)
	reader.add_theme_color_override("default_color",BONE)
	reader.add_theme_constant_override("normal_line_separation",7)
	canvas.add_child(reader)
	list=HBoxContainer.new()
	list.position=Vector2(526,551)
	list.size=Vector2(688,54)
	list.add_theme_constant_override("separation",8)
	canvas.add_child(list)
	previous=_button("‹ Назад",Rect2(526,614,96,28),_turn_page.bind(-1))
	next=_button("Далее ›",Rect2(1118,614,96,28),_turn_page.bind(1))
	page_label=_label("",Rect2(626,617,56,24),12,MUTED)
	closure_button=_button("Целая история",Rect2(692,614,186,28),_closure)
	full_button=_button("Весь витраж",Rect2(886,614,222,28),_full_closure)
	_rule(60,644,1160)
	heading=_label("ВОССТАНОВЛЕНО %d ИЗ 24"%profile.unlocked.size(),Rect2(65,653,310,24),14,GOLD,true)
	var summary: Array[String]=[]
	for pair in GROUPS:
		summary.append("%s %d/%d"%[pair[1],_count(pair[0]),12 if pair[0]=="chronicle" else 4])
	var footer:=_label("    ·    ".join(summary),Rect2(390,653,820,24),14,MUTED)
	footer.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
	if not profile.error_message.is_empty():
		heading.text="ОШИБКА СОХРАНЕНИЯ"
		heading.tooltip_text=profile.error_message
	_group("chronicle")
	_render_art()
	resized.connect(_layout_canvas)
	_layout_canvas()
	modulate.a=0
	create_tween().tween_property(self,"modulate:a",1.0,0.18)

func _layout_canvas() -> void:
	var factor:=minf(size.x/1280.0,size.y/720.0)
	canvas.scale=Vector2.ONE*factor
	canvas.position=(size-Vector2(1280,720)*factor)*0.5

func _frame(rect: Rect2) -> void:
	var node:=NinePatchRect.new()
	node.texture=FRAME
	node.position=rect.position
	node.size=rect.size
	node.patch_margin_left=38
	node.patch_margin_right=38
	node.patch_margin_top=36
	node.patch_margin_bottom=36
	node.mouse_filter=Control.MOUSE_FILTER_IGNORE
	canvas.add_child(node)

func _label(text: String, rect: Rect2, point: int, color: Color, title: bool=false) -> Label:
	var node:=Label.new()
	node.position=rect.position
	node.size=rect.size
	node.text=text
	node.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter=Control.MOUSE_FILTER_IGNORE
	node.add_theme_font_override("font",serif if title else body)
	node.add_theme_font_size_override("font_size",point)
	node.add_theme_color_override("font_color",color)
	canvas.add_child(node)
	return node

func _rule(x: float,y: float,width: float) -> void:
	var rule:=ColorRect.new()
	rule.position=Vector2(x,y)
	rule.size=Vector2(width,1)
	rule.color=Color("6a4d2e")
	rule.mouse_filter=Control.MOUSE_FILTER_IGNORE
	canvas.add_child(rule)
	_label("◆",Rect2(x+width/2-6,y-10,16,20),13,GOLD)

func _button(text: String, rect: Rect2, action: Callable) -> Button:
	var button:=Button.new()
	button.position=rect.position
	button.size=rect.size
	button.custom_minimum_size=rect.size
	button.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND
	button.pressed.connect(action)
	var caption:=Label.new()
	caption.name="Caption"
	caption.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	caption.offset_left=8
	caption.offset_right=-8
	caption.text=text
	caption.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	caption.mouse_filter=Control.MOUSE_FILTER_IGNORE
	caption.add_theme_font_override("font",body)
	caption.add_theme_font_size_override("font_size",14 if rect.size.y>40 else 13)
	caption.add_theme_color_override("font_color",BONE)
	button.add_child(caption)
	_skin_button(button,false)
	canvas.add_child(button)
	return button

func _skin_button(button: Button, selected: bool) -> void:
	for state in ["normal","hover","pressed","focus","disabled"]:
		var box:=StyleBoxFlat.new()
		box.bg_color=Color("34191a") if selected or state=="pressed" else Color("121011")
		box.border_color=GOLD if selected or state in ["hover","focus"] else Color("58412a")
		box.set_border_width_all(1)
		button.add_theme_stylebox_override(state,box)

func _count(value: String) -> int:
	var count:=0
	for item in PROFILE.catalog():
		if item.group==value and profile.unlocked.has(item.id): count+=1
	return count

func _entries() -> Array:
	return PROFILE.catalog().filter(func(item): return item.group==group)

func _group(value: String) -> void:
	group=value
	page=0
	selected_id=""
	_refresh_choices()
	title_label.text="Выберите осколок"
	section_label.text="ХРОНИКА ЗАМКА" if group=="chronicle" else "ПАМЯТЬ · "+str(tabs[group].get_node("Caption").text).split(" · ")[0]
	reader.text="Закрытые воспоминания открываются за поступки в новых забегах. Выберите осколок на витраже или внизу."
	reader.scroll_to_line(0)

func _refresh_choices() -> void:
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	fragments.clear()
	var entries:=_entries()
	for i in range(page*4,mini(page*4+4,entries.size())):
		var item: Dictionary=entries[i]
		var opened: bool=profile.unlocked.has(item.id)
		var button:=_button(item.title_ru if opened else "Нераскрытая память",Rect2(0,0,166,54),_select.bind(item))
		button.reparent(list)
		button.set_meta("fragment_id",item.id)
		button.tooltip_text=item.title_ru if opened else "Память ещё закрыта"
		fragments[item.id]=button
		_skin_button(button,item.id==selected_id)
	for key in tabs: _skin_button(tabs[key],key==group)
	previous.disabled=page==0
	next.disabled=(page+1)*4>=entries.size()
	previous.modulate.a=0.35 if previous.disabled else 1.0
	next.modulate.a=0.35 if next.disabled else 1.0
	page_label.text="%d / %d"%[page+1,ceili(entries.size()/4.0)]
	closure_button.visible=_count(group)==entries.size()
	full_button.visible=profile.unlocked.size()==24

func _turn_page(direction: int) -> void:
	page=clampi(page+direction,0,ceili(_entries().size()/4.0)-1)
	_refresh_choices()

func _select(item: Dictionary) -> void:
	if item.group!=group: group=item.group
	var entries:=_entries()
	page=entries.find(item)/4
	selected_id=item.id
	_refresh_choices()
	if fragments.has(selected_id): fragments[selected_id].grab_focus()
	section_label.text="%s   /   ОСКОЛОК %d ИЗ %d"%["ХРОНИКА" if group=="chronicle" else "ПАМЯТЬ "+{"knight":"РЫЦАРЯ","ranger":"СЛЕДОПЫТА","mage":"МАГА"}[group],entries.find(item)+1,entries.size()]
	if not profile.unlocked.has(item.id):
		title_label.text="Нераскрытая память"
		reader.text="Эта память ещё закрыта. Продолжайте путь выбранным героем."
	else:
		title_label.text=item.title_ru
		reader.text=item.memory_ru+"\n\n[color=#a69a87][font_size=17]Волшебник: «"+item.wizard_comment_ru+"»[/font_size][/color]"
	reader.scroll_to_line(0)

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

func _closure() -> void:
	if _count(group)!=_entries().size(): return
	section_label.text="ЦЕЛАЯ ПАМЯТЬ · "+str(tabs[group].get_node("Caption").text)
	title_label.text="Целая история"
	reader.scroll_to_line(0)
	var texts := {"chronicle":"Замок был домом. Затем он стал временем, купленным для чужой победы. Обещания удерживали людей на стенах дольше, чем хлеб и страх; правда пришла, когда им уже не оставили выбора.","knight":"Я спас страну и потерял право считать свой приказ чистым. Я не обещал помощи. Но честность приказа не возвращает тех, кого я оставил.","ranger":"Я помню каждую дорогу. Одни вывели армию к победе, другие остались за запертыми воротами. Теперь я смотрю на путь и спрашиваю не только куда он ведёт, но кому позволят по нему пройти.","mage":"Я сумел отличить печать от подделки. Слишком поздно. Ни верная буква, ни раскрытый подлог не отменяют решения, которое я принял сам."}
	reader.text = texts[group]


func _full_closure() -> void:
	if profile.unlocked.size()!=24: return
	section_label.text="ВИТРАЖ ВОССТАНОВЛЕН · 24 ИЗ 24"
	title_label.text="Когда стекло стало целым"
	reader.text="Ты видишь целую картину. Твой честный приказ обрёк замок; Канцлер подменил его обещанием помощи, а Комендант продолжил ложь, узнав правду. Ни один восстановленный осколок не возвращает погибших. Но теперь ты не можешь сказать, что видел лишь свою часть.\n\nВолшебник: «Вот и всё стекло. Прощения в нём нет — только лица»."
	reader.scroll_to_line(0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode==KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()

func _unhandled_key_input(_event: InputEvent) -> void:
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
