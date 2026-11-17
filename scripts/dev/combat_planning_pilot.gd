extends Control
## F6-only composition around the existing production Battle scene.
const DATA := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const EXECUTOR := preload("res://scripts/battle/planning/battle_plan_executor.gd")
const PRESETS := preload("res://scripts/battle/planning/battle_plan_presets.gd")
const VIEW := preload("res://scripts/battle/planning/battle_plan_ui.gd")
const SESSION := preload("res://scripts/dev/qa_hub_session.gd")
const BATTLE := "res://scenes/battle/battle.tscn"
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var battle: Control
var ui: CanvasLayer
var setup: CanvasLayer
var party_choice: OptionButton
var mode_choice: OptionButton
var seed_choice: SpinBox
var preset_choice: OptionButton
var plans: Dictionary={}
var executors: Dictionary={}
var histories: Dictionary={}
var initial_positions: Dictionary={}
var picking_target := false
var pick_role := ""
var pick_slot := 0
var planned := true
var reported := false
var intermission_seen := false
var legacy_kills: Dictionary={}
var encounter_path := "res://resources/encounters/grave_bell.tres"
var run_seed := 31017
var report_text := ""

func _ready() -> void: _initialize.call_deferred()

func _initialize() -> void:
	var session := SESSION.ensure(self)
	setup=VIEW.new()
	setup.layer=60
	add_child(setup)
	var panel: Panel=setup.panel(Vector2(320,132),Vector2(640,424))
	setup.label(panel,"БОЕВОЙ ПЛАН 1.0 · ПИЛОТ",Vector2(24,18),Vector2(600,42),25)
	setup.label(panel,"Могильный звон · настоящий Battle · отдельный QA-профиль",Vector2(24,68),Vector2(590,32))
	party_choice=setup.option(panel,["Рыцарь","Следопыт","Маг","Рыцарь + Следопыт","Рыцарь + Маг","Следопыт + Маг","Все трое"],Vector2(24,116),Vector2(590,36))
	party_choice.select(6)
	var requested: Array=session.last_options.get("roles",PARTIES[6])
	if PARTIES.has(requested): party_choice.select(PARTIES.find(requested))
	mode_choice=setup.option(panel,["ПРЕЖНИЙ АВТОБОЙ","COMBAT PLANNING — индивидуальные приказы"],Vector2(24,166),Vector2(590,36))
	mode_choice.select(1)
	seed_choice=SpinBox.new()
	seed_choice.min_value=1
	seed_choice.max_value=999999
	seed_choice.value=run_seed
	seed_choice.prefix="Seed: "
	seed_choice.position=Vector2(24,218)
	seed_choice.size=Vector2(250,36)
	panel.add_child(seed_choice)
	preset_choice=setup.option(panel,PRESETS.NAMES,Vector2(290,218),Vector2(324,36))
	setup.label(panel,"Одинаковый seed и расстановка для сравнения.\nПриказы меняются только до боя / в передышке.",Vector2(24,270),Vector2(590,50))
	setup.button(panel,"ОТКРЫТЬ АРЕНУ",Vector2(24,348),Vector2(590,46),open_battle)
	set_process(true)

func role_name(role: String) -> String:
	return {"knight":"Рыцарь","ranger":"Следопыт","mage":"Маг"}.get(role,role)

func _clear_battle() -> void:
	for executor in executors.values(): executor.disconnect_unit()
	executors.clear()
	if is_instance_valid(ui): ui.queue_free()
	if is_instance_valid(battle):
		battle.visible=false
		battle.queue_free()
		battle=null

func show_setup() -> void:
	get_tree().paused=false
	_clear_battle()
	setup.visible=true
	picking_target=false

func editable() -> bool:
	return planned and is_instance_valid(battle) and not battle.battle_finished and (not battle.combat_started or battle.wave_intermission)

func open_battle(keep_placement: bool=false) -> void:
	_clear_battle()
	get_tree().paused=false
	planned=mode_choice.selected==1
	run_seed=int(seed_choice.value)
	var roles: Array=PARTIES[party_choice.selected]
	RunState.reset_run()
	RunState.choose_protagonist(roles[0])
	for role in roles.slice(1): RunState.recruit_companion(role,"Combat Planning QA")
	RunState.select_encounter(encounter_path)
	RunState.battle_target_preview_enabled=false
	RunState.wizard_wager_slots.clear()
	RunState.wizard_mark_slots.clear()
	RunState.wizard_meddling_slots.clear()
	seed(run_seed)
	battle=load(BATTLE).instantiate()
	add_child(battle)
	# Reseed only this QA instance immediately before the existing random
	# opening cooldowns; ambient render cadence cannot change the comparison.
	battle.combat_beginning.connect(_combat_beginning)
	setup.visible=false
	reported=false
	intermission_seen=false
	picking_target=false
	histories.clear()
	legacy_kills.clear()
	var heroes: Array[String]=[]
	for unit in battle.units:
		if unit.team!=0 or unit.visual_role=="jack": continue
		heroes.append(unit.visual_role)
		if not plans.has(unit.visual_role): plans[unit.visual_role]=DATA.new()
		# Instance references never survive a different battle.
		for order in plans[unit.visual_role].orders: order.target=null
		if keep_placement and initial_positions.has(unit.visual_role): unit.position=initial_positions[unit.visual_role]
		unit.diagnostic_damage.connect(_legacy_damage)
	if not keep_placement: PRESETS.apply(plans,PRESETS.IDS[preset_choice.selected])
	ui=VIEW.new()
	add_child(ui)
	ui.build(self)
	ui.set_heroes(heroes)
	ui.editor.visible=planned
	if planned: _hide_legacy_preparation()
	else:
		ui.button(ui,"ОПЫТ / РЕЖИМ",Vector2(1000,172),Vector2(246,32),show_setup)
	if not keep_placement: initial_positions.clear()

func _hide_legacy_preparation() -> void:
	for name in ["BottomHudPanel","FightHudPanel","OrderLabel","OrderDescription","AssaultOrderButton","HuntOrderButton","FormationOrderButton","SacrificeOrderButton","DefianceOrderButton","TargetPreviewButton","FightButton","PlacementHint"]:
		var node := battle.get_node_or_null(name) as CanvasItem
		if node!=null: node.visible=false
	if battle.target_preview!=null: battle.target_preview.set_active(false)

func _remember_positions() -> void:
	initial_positions.clear()
	for unit in battle.units:
		if unit.team==0 and unit.alive and unit.visual_role!="jack": initial_positions[unit.visual_role]=unit.position

func _combat_beginning() -> void:
	seed(run_seed+battle.battle_wave_index-1)
	if battle.battle_wave_index==1: _remember_positions()

func start_legacy_battle() -> void:
	if not is_instance_valid(battle) or battle.combat_started or battle.battle_finished: return
	_remember_positions()
	battle._on_fight_pressed()

func start_planned_battle() -> void:
	if not editable(): return
	if not battle.wave_intermission: _remember_positions()
	picking_target=false
	for unit in battle.units:
		if unit.team==0 and unit.alive and unit.visual_role!="jack":
			var executor := EXECUTOR.new(unit,plans[unit.visual_role],2 if battle.wave_intermission else 1)
			executors[unit.visual_role]=executor
			unit.plan_executor=executor
	ui.editor.visible=false
	ui.hud.visible=false
	battle._on_fight_pressed()

func arm_target() -> void:
	if not editable(): return
	picking_target=true
	pick_role=ui.current_role()
	pick_slot=ui.slot
	ui.explanation.text="Нажмите на противника на арене. ПКМ — отмена. Расстановка героев сохраняется."

func assign_target(enemy: BattleUnit) -> void:
	if not picking_target or not editable() or enemy.team!=1 or not enemy.alive: return
	plans[pick_role].orders[pick_slot].target=weakref(enemy)
	picking_target=false
	var old: Color=enemy.modulate
	enemy.modulate=Color(1.3,1.18,0.82)
	enemy.create_tween().tween_property(enemy,"modulate",old,0.35)
	ui.refresh()

func _input(event: InputEvent) -> void:
	if not picking_target or not event is InputEventMouseButton or not event.pressed: return
	if event.button_index==MOUSE_BUTTON_RIGHT:
		picking_target=false
		ui.refresh()
		return
	if event.button_index!=MOUSE_BUTTON_LEFT: return
	var point: Vector2=get_viewport().get_canvas_transform().affine_inverse()*event.position
	var nearest: BattleUnit
	var distance := 60.0
	for enemy in battle.units:
		if enemy.team!=1 or not enemy.alive: continue
		var gap: float=point.distance_to(enemy.global_position+Vector2(0,-24))
		if gap<distance:
			nearest=enemy
			distance=gap
	if nearest!=null:
		assign_target(nearest)
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	if not is_instance_valid(battle): return
	if planned:
		ui.update_live(delta)
		if battle.wave_intermission and not intermission_seen:
			intermission_seen=true
			var survivors: Array[String]=[]
			for executor in executors.values():
				var role: String=executor.unit().visual_role
				histories[role]=executor.journal.duplicate(true)
				executor.disconnect_unit()
			executors.clear()
			for unit in battle.units:
				if unit.team==0 and unit.alive and unit.visual_role!="jack": survivors.append(unit.visual_role)
			ui.set_heroes(survivors)
			ui.editor.visible=true
			ui.hud.visible=false
			_hide_legacy_preparation()
	if battle.battle_finished and not reported:
		reported=true
		_show_report.call_deferred()

func _legacy_damage(attacker: BattleUnit, victim: BattleUnit, amount: float) -> void:
	if amount>0 and not victim.alive: legacy_kills[attacker.visual_role]=int(legacy_kills.get(attacker.visual_role,0))+1

func _show_report() -> void:
	var lines: Array[String]=[]
	lines.append(("ПОБЕДА" if RunState.last_battle_won else "ПОРАЖЕНИЕ")+" · "+("Боевой план" if planned else "Прежний автобой")+" · seed "+str(run_seed)+" · %.2f c" % battle.combat_elapsed)
	for unit in battle.units:
		if unit.team!=0 or unit.visual_role=="jack": continue
		var role: String=unit.visual_role
		lines.append("\n%s — HP %.1f / %.1f · личных убийств %d" % [role_name(role),unit.hp,unit.max_hp,int(legacy_kills.get(role,0))])
		var rows: Array=histories.get(role,[]).duplicate(true)
		if executors.has(role):
			executors[role].finish(RunState.last_battle_won)
			rows.append_array(executors[role].journal)
		for row in rows:
			var detail: String={"start":"Начало","end":"Переход","target":"Цель","kill":"Личное убийство","death":"Гибель","result":"Итог"}.get(row.kind,row.kind)
			match str(row.kind):
				"start": detail+=" · "+str(row.order)+" · назначена: "+str(row.assigned)
				"end":
					var reason: String="Лимит истёк; событие не выполнено" if row.reason=="timeout" else DATA.CONDITION_NAMES[DATA.CONDITIONS.find(row.reason)]
					detail+=" · "+reason+" · %.2f c этапа" % row.elapsed
				"target": detail+=" · назначена: "+str(row.assigned)+" · фактически: "+str(row.actual)
				"kill": detail+=" · "+str(row.target)
			lines.append("Волна %d · %.2f c · %s · %s" % [row.wave,row.time,["—","I","II","III"][clampi(int(row.stage),0,3)],detail])
	report_text="\n".join(lines)
	ui.show_report(report_text)

func replay() -> void: open_battle(true)
func edit_again() -> void:
	mode_choice.select(1)
	open_battle(true)
func compare_mode() -> void:
	mode_choice.select(0 if planned else 1)
	open_battle(true)

func _exit_tree() -> void:
	for executor in executors.values(): executor.disconnect_unit()
