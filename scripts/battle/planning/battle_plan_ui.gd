extends CanvasLayer
const DATA := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
var pilot: Node
var editor: Panel
var hud: Panel
var hero_choice: OptionButton
var count_choice: OptionButton
var slots: Array[Button]=[]
var tactic: OptionButton
var priority: OptionButton
var condition: OptionButton
var limit: SpinBox
var target_button: Button
var explanation: Label
var summary: Label
var live_text: Label
var notification: Label
var limit_label: Label
var report_panel: Panel
var slot := 0
var refreshing := false
var hero_roles: Array[String]=[]
var last_stage_text := ""
var notice_time := 0.0

func panel(at: Vector2, dimensions: Vector2) -> Panel:
	var item := Panel.new()
	item.position=at
	item.size=dimensions
	DS3.apply_surface(item,"dossier")
	add_child(item)
	return item

func label(parent: Node, text: String, at: Vector2, dimensions: Vector2, font_size: int=14) -> Label:
	var item := Label.new()
	item.text=text
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",DS3.PARCHMENT)
	item.mouse_filter=Control.MOUSE_FILTER_IGNORE
	parent.add_child(item)
	return item

func button(parent: Node, text: String, at: Vector2, dimensions: Vector2, action: Callable) -> Button:
	var item := Button.new()
	item.text=text
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",14)
	DS3.apply_action(item,false)
	parent.add_child(item)
	item.pressed.connect(action)
	return item

func option(parent: Node, names: Array, at: Vector2, dimensions: Vector2) -> OptionButton:
	var item := OptionButton.new()
	for title in names: item.add_item(str(title))
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",14)
	parent.add_child(item)
	return item

func build(owner_pilot: Node) -> void:
	pilot=owner_pilot
	layer=40
	editor=panel(Vector2(28,548),Vector2(1224,164))
	hero_choice=option(editor,[],Vector2(12,8),Vector2(174,32))
	hero_choice.item_selected.connect(func(_n: int):pilot.picking_target=false;slot=0;refresh())
	for n in range(3):
		var b:=button(editor,["I","II","III"][n],Vector2(198+n*54,8),Vector2(48,32),func():pass)
		b.pressed.connect(_select_slot.bind(n))
		slots.append(b)
	label(editor,"Приказов",Vector2(378,12),Vector2(80,26))
	count_choice=option(editor,["1","2","3"],Vector2(462,8),Vector2(58,32))
	count_choice.item_selected.connect(_resize)
	button(editor,"ОПЫТ / РЕЖИМ",Vector2(750,8),Vector2(194,32),pilot.show_setup)
	button(editor,"НАЧАТЬ БОЙ",Vector2(958,8),Vector2(252,32),pilot.start_planned_battle)
	tactic=option(editor,DATA.TACTIC_NAMES,Vector2(12,48),Vector2(145,34))
	priority=option(editor,DATA.PRIORITY_NAMES,Vector2(167,48),Vector2(212,34))
	target_button=button(editor,"Указать врага на арене",Vector2(389,48),Vector2(258,34),pilot.arm_target)
	button(editor,"×",Vector2(652,48),Vector2(34,34),_clear_target)
	condition=option(editor,DATA.CONDITION_NAMES,Vector2(702,48),Vector2(194,34))
	limit=SpinBox.new()
	limit.min_value=2
	limit.max_value=12
	limit.step=1
	limit.suffix="с."
	limit.position=Vector2(908,48)
	limit.size=Vector2(106,34)
	editor.add_child(limit)
	limit_label=label(editor,"Лимит этапа",Vector2(1028,52),Vector2(175,26))
	for choice in [tactic,priority,condition]: choice.item_selected.connect(func(_n: int):_edited())
	limit.value_changed.connect(func(_n: float):_edited())
	explanation=label(editor,"",Vector2(12,87),Vector2(1200,26),13)
	summary=label(editor,"",Vector2(12,119),Vector2(1200,34),12)
	summary.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	hud=panel(Vector2(804,178),Vector2(446,108))
	live_text=label(hud,"",Vector2(12,8),Vector2(420,82),15)
	notification=label(self,"",Vector2(804,290),Vector2(446,32),13)
	hud.visible=false

func current_role() -> String:
	return hero_roles[hero_choice.selected] if hero_choice.selected>=0 and not hero_roles.is_empty() else ""

func current_plan() -> Resource: return pilot.plans.get(current_role())

func set_heroes(roles: Array[String]) -> void:
	var old := current_role()
	hero_roles=roles.duplicate()
	hero_choice.clear()
	for role in roles: hero_choice.add_item(pilot.role_name(role))
	if roles.has(old): hero_choice.select(roles.find(old))
	slot=0
	refresh()

func _select_slot(n: int) -> void:
	pilot.picking_target=false
	slot=n
	refresh()

func refresh() -> void:
	var plan := current_plan()
	if plan==null: return
	refreshing=true
	slot=mini(slot,plan.orders.size()-1)
	count_choice.select(plan.orders.size()-1)
	for n in range(3):
		slots[n].disabled=n>=plan.orders.size()
		DS3.apply_action(slots[n],n==slot)
	var order: Dictionary=plan.orders[slot]
	tactic.select(DATA.TACTICS.find(order.tactic))
	priority.select(DATA.PRIORITIES.find(order.priority))
	condition.select(DATA.CONDITIONS.find(order.condition))
	limit.value=order.limit
	var last: bool=slot==plan.orders.size()-1
	condition.disabled=last
	limit.editable=not last
	condition.visible=not last
	limit.visible=not last
	limit_label.visible=not last
	var foe := DATA.target_of(order)
	target_button.text="Цель: "+foe.display_name if is_instance_valid(foe) and foe.alive else "Указать врага на арене"
	explanation.text="Последний приказ действует до конца боя." if last else "Смена по событию или лимиту. Если событие не случилось — переход без дополнительного штрафа."
	var rows: Array[String]=[]
	for role in hero_roles:
		var parts: Array[String]=[]
		for step in pilot.plans[role].orders: parts.append(DATA.TACTIC_NAMES[DATA.TACTICS.find(step.tactic)])
		rows.append(pilot.role_name(role)+": "+" → ".join(parts))
	summary.text="    |    ".join(rows)
	refreshing=false

func _resize(n: int) -> void:
	if refreshing or not pilot.editable(): return
	current_plan().resize_orders(n+1)
	refresh()

func _edited() -> void:
	if refreshing or not pilot.editable(): return
	var order: Dictionary=current_plan().orders[slot]
	order.tactic=DATA.TACTICS[tactic.selected]
	order.priority=DATA.PRIORITIES[priority.selected]
	order.condition=DATA.CONDITIONS[condition.selected]
	order.limit=int(limit.value)
	refresh()

func _clear_target() -> void:
	if not pilot.editable(): return
	current_plan().orders[slot].target=null
	pilot.picking_target=false
	refresh()

func update_live(delta: float) -> void:
	hud.visible=pilot.battle.combat_live and not pilot.battle.battle_finished
	var rows: Array[String]=[]
	var stages := ""
	for role in hero_roles:
		var executor: RefCounted=pilot.executors.get(role)
		if executor==null or executor.index<0: continue
		var state: String="ПАЛ" if not executor.unit().alive else DATA.TACTIC_NAMES[DATA.TACTICS.find(executor.orders[executor.index].tactic)]
		var remaining: String="до конца" if executor.index==executor.orders.size()-1 else "%.1f с" % maxf(0,float(executor.orders[executor.index].limit)-executor.elapsed)
		rows.append("%s · %s · %s · %s" % [pilot.role_name(role),["I","II","III"][executor.index],state,remaining])
		stages+=role+str(executor.index)
	live_text.text="\n".join(rows)
	if stages!=last_stage_text:
		if not last_stage_text.is_empty():
			notification.text="Боевой план: следующий приказ"
			notice_time=1.3
		last_stage_text=stages
	notice_time=maxf(0,notice_time-delta)
	notification.visible=notice_time>0 and hud.visible

func show_report(text: String) -> void:
	editor.visible=false
	hud.visible=false
	notification.visible=false
	report_panel=panel(Vector2(54,176),Vector2(1172,476))
	label(report_panel,"ЖУРНАЛ БОЕВОГО ОПЫТА",Vector2(18,10),Vector2(1100,32),21)
	var log_view := RichTextLabel.new()
	log_view.position=Vector2(18,52)
	log_view.size=Vector2(1136,350)
	log_view.text=text
	log_view.selection_enabled=true
	log_view.add_theme_font_size_override("normal_font_size",14)
	report_panel.add_child(log_view)
	button(report_panel,"ПОВТОРИТЬ",Vector2(18,422),Vector2(230,36),pilot.replay)
	button(report_panel,"ПРАВИТЬ ПЛАН",Vector2(264,422),Vector2(270,36),pilot.edit_again)
	button(report_panel,"СРАВНИТЬ РЕЖИМ",Vector2(550,422),Vector2(280,36),pilot.compare_mode)
	button(report_panel,"НАСТРОЙКИ",Vector2(846,422),Vector2(306,36),pilot.show_setup)
