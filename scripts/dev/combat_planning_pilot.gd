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
var encounter_scope: Array = []
var first_wave_enemies: Array[BattleUnit] = []
var first_wave_draft: Dictionary = {}

func _ready() -> void: _initialize.call_deferred()

func _initialize() -> void:
	var session := SESSION.ensure(self)
	setup=VIEW.new()
	setup.layer=60
	add_child(setup)
	var panel: Panel=setup.panel(Vector2(320,132),Vector2(640,424))
	setup.label(panel,"БОЕВОЙ ПЛАН",Vector2(24,18),Vector2(600,42),25)
	setup.label(panel,"Могильный звон · сравнение режимов",Vector2(24,68),Vector2(590,32))
	party_choice=setup.option(panel,["Рыцарь","Следопыт","Маг","Рыцарь + Следопыт","Рыцарь + Маг","Следопыт + Маг","Все трое"],Vector2(24,116),Vector2(590,36))
	party_choice.select(6)
	var requested: Array=session.last_options.get("roles",PARTIES[6])
	if PARTIES.has(requested): party_choice.select(PARTIES.find(requested))
	mode_choice=setup.option(panel,["Прежний автобой","Индивидуальные приказы"],Vector2(24,166),Vector2(590,36))
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
	preset_choice.select(4)
	var preset_hint: Label = setup.label(panel,PRESETS.DESCRIPTIONS[4],Vector2(24,266),Vector2(590,48))
	preset_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	preset_choice.item_selected.connect(func(index: int): preset_hint.text = PRESETS.DESCRIPTIONS[index])
	setup.label(panel,"Исход зависит от состава и расстановки.",Vector2(24,316),Vector2(590,23),13)
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
	preset_choice.select(0)
	preset_choice.item_selected.emit(0)

func editable() -> bool:
	return planned and is_instance_valid(battle) and not battle.battle_finished and (not battle.combat_started or battle.wave_intermission)

func open_battle(keep_placement: bool=false) -> void:
	var previous_scope := encounter_scope
	var previous_role: String = ui.current_role() if keep_placement and is_instance_valid(ui) else ""
	var previous_slot: int = ui.slot if keep_placement and is_instance_valid(ui) else 0
	if keep_placement and intermission_seen:
		for role in first_wave_draft:
			plans[role].orders.assign(first_wave_draft[role])
	first_wave_draft.clear()
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
	# This QA fixture supplies its own planning driver.
	battle.combat_planning_disabled = true
	add_child(battle)
	first_wave_enemies.clear()
	var roster: Array = []
	for unit in battle.units:
		if unit.team == 1:
			first_wave_enemies.append(unit)
			roster.append([unit.visual_role, unit.display_name, unit.position])
	encounter_scope = [encounter_path, battle.enemy_formation_variant, battle.encounter.enemy_unit_paths, roster]
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
		if keep_placement and initial_positions.has(unit.visual_role): unit.position=initial_positions[unit.visual_role]
		unit.diagnostic_damage.connect(_legacy_damage)
	if not keep_placement: PRESETS.apply(plans,PRESETS.IDS[preset_choice.selected])
	var same_encounter := keep_placement and previous_scope == encounter_scope
	var dropped := _rebind_assignments(same_encounter)
	ui=VIEW.new()
	add_child(ui)
	ui.build(self)
	if dropped:
		ui.fallback_message = "Назначение сброшено: будет использован приоритет цели."
	if same_encounter:
		ui.selected_role = previous_role
		ui.slot = previous_slot
	ui.set_heroes(heroes)
	if planned: _hide_legacy_preparation()
	else:
		ui.button(ui,"ОПЫТ / РЕЖИМ",Vector2(1000,172),Vector2(246,32),show_setup)
	if not keep_placement: initial_positions.clear()

func clear_assignment(order: Dictionary) -> void:
	order.target = null
	order.erase("spawn_slot")

func resize_plan(role: String, count: int) -> void:
	var plan: Resource = plans[role]
	var previous: Array = plan.orders.duplicate()
	plan.resize_orders(count)
	for index in range(mini(count, previous.size())):
		if previous[index].has("spawn_slot"):
			plan.orders[index].spawn_slot = previous[index].spawn_slot

func _rebind_assignments(same_encounter: bool) -> bool:
	var dropped := false
	for plan in plans.values():
		for order in plan.orders:
			var had_target: bool = order.target != null or order.has("spawn_slot")
			var index: int = order.get("spawn_slot", -1)
			if same_encounter and index >= 0 and index < first_wave_enemies.size():
				order.target = weakref(first_wave_enemies[index])
			else:
				clear_assignment(order)
				dropped = dropped or had_target
	return dropped

func enemy_label(enemy: BattleUnit) -> String:
	var number := first_wave_enemies.find(enemy) + 1
	return "%s · %d" % [enemy.display_name, number] if number > 0 else enemy.display_name

func _hide_legacy_preparation() -> void:
	for name in ["BottomHudPanel","FightHudPanel","OrderLabel","OrderDescription","AssaultOrderButton","HuntOrderButton","FormationOrderButton","SacrificeOrderButton","DefianceOrderButton","TargetPreviewButton","FightButton","PlacementHint"]:
		var node := battle.get_node_or_null(name) as CanvasItem
		if node!=null: node.visible=false
	if battle.target_preview!=null: battle.target_preview.set_active(false)
	battle.side_objective_panel.position = Vector2(44, 145)

func qa_toolbar_visible() -> bool:
	return not editable()

func return_to_hub() -> void:
	get_node("/root/QAHubSession").return_to_hub()

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
	if not battle.wave_intermission:
		_remember_positions()
		for role in plans:
			first_wave_draft[role] = plans[role].orders.duplicate(true)
	cancel_target()
	for unit in battle.units:
		if unit.team==0 and unit.alive and unit.visual_role!="jack":
			var executor := EXECUTOR.new(unit,plans[unit.visual_role],2 if battle.wave_intermission else 1)
			executors[unit.visual_role]=executor
			unit.plan_executor=executor
	ui.hide_preparation()
	ui.hud.visible=false
	battle._on_fight_pressed()

func arm_target() -> void:
	if not editable() or not ui.detail.visible or ui.current_role().is_empty() or battle.wave_intermission: return
	ui.limit.apply()
	picking_target=true
	pick_role=ui.current_role()
	pick_slot=ui.slot
	ui.set_picking(true)

func cancel_target() -> void:
	if not picking_target:
		return
	picking_target = false
	ui.set_picking(false)

func assign_target(enemy: BattleUnit) -> void:
	var index := first_wave_enemies.find(enemy)
	if not picking_target or not editable() or index < 0 or not enemy.alive: return
	var order: Dictionary = plans[pick_role].orders[pick_slot]
	order.target = weakref(enemy)
	order.spawn_slot = index
	ui.fallback_message = ""
	cancel_target()

func _input(event: InputEvent) -> void:
	if not picking_target:
		return
	if event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		cancel_target()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseMotion:
		ui.update_hover(_enemy_at(event.position))
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var enemy := _enemy_at(event.position)
		if enemy != null:
			assign_target(enemy)
			get_viewport().set_input_as_handled()

func _enemy_at(viewport_point: Vector2) -> BattleUnit:
	for enemy in ui.pick_markers:
		if ui.pick_markers[enemy].get_global_rect().has_point(viewport_point) and enemy.alive:
			return enemy
	var point := get_viewport().get_canvas_transform().affine_inverse() * viewport_point
	var nearest: BattleUnit
	var distance := 60.0
	for enemy in battle.units:
		if enemy.team!=1 or not enemy.alive: continue
		var offset: Vector2 = point - enemy.global_position
		var gap := offset.distance_to(Vector2(0, -35))
		if Rect2(-42, -93, 84, 111).has_point(offset) and (nearest == null or gap < distance):
			nearest=enemy
			distance=gap
	return nearest

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
			if _rebind_assignments(false):
				ui.fallback_message = "Цели первой волны сброшены. Новые враги появятся после запуска."
			for unit in battle.units:
				if unit.team==0 and unit.alive and unit.visual_role!="jack": survivors.append(unit.visual_role)
			ui.set_heroes(survivors)
			ui.hud.visible=false
			_hide_legacy_preparation()
	if battle.battle_finished and not reported:
		reported=true
		_show_report.call_deferred()

func _legacy_damage(attacker: BattleUnit, victim: BattleUnit, amount: float) -> void:
	if amount>0 and not victim.alive: legacy_kills[attacker.visual_role]=int(legacy_kills.get(attacker.visual_role,0))+1

func _show_report() -> void:
	var lines: Array[String]=[]
	var summary: Array[String] = []
	var outcome := "Победа" if RunState.last_battle_won else "Поражение"
	var metadata := "%s · %.2f с · seed %d" % ["Боевой план" if planned else "Прежний автобой", battle.combat_elapsed, run_seed]
	for unit in battle.units:
		if unit.team!=0 or unit.visual_role=="jack": continue
		var role: String=unit.visual_role
		var hero_result := "%s · %s · личных убийств %d" % [role_name(role), "%.0f / %.0f HP" % [unit.hp, unit.max_hp], int(legacy_kills.get(role,0))]
		lines.append("\n" + hero_result)
		summary.append(hero_result)
		var milestones: Array[String] = []
		var rows: Array=histories.get(role,[]).duplicate(true)
		if executors.has(role):
			executors[role].finish(RunState.last_battle_won)
			rows.append_array(executors[role].journal)
		for row in rows:
			var stage: String = VIEW.STAGES[clampi(int(row.stage) - 1, 0, 2)]
			var prefix := "Волна %d, " % row.wave if intermission_seen else ""
			var detail: String={"start":"Начало","end":"Переход","target":"Цель","kill":"Личное убийство","death":"Гибель","result":"Итог"}.get(row.kind,row.kind)
			match str(row.kind):
				"start": detail+=" · "+str(row.order)+" · назначена: "+str(row.assigned)
				"end":
					var reason: String="Лимит истёк, условие не выполнено" if row.reason=="timeout" else VIEW.CONDITIONS[DATA.CONDITIONS.find(row.reason)]
					detail+=" · "+reason+" · %.2f c этапа" % row.elapsed
					milestones.append("%s%s: %s (%.1f с)" % [prefix, stage, reason.to_lower(), row.elapsed])
				"target": detail+=" · назначена: "+str(row.assigned)+" · фактически: "+str(row.actual)
				"kill": detail+=" · "+str(row.target)
				"death": milestones.append("%sпогиб на приказе %s" % [prefix, stage])
			lines.append("Волна %d · %.2f c · %s · %s" % [row.wave,row.time,["—","I","II","III"][clampi(int(row.stage),0,3)],detail])
		if not milestones.is_empty():
			summary.append("   " + "  ·  ".join(milestones))
		summary.append("")
	report_text="\n".join(lines)
	battle.get_node("ResultOverlay").hide()
	ui.show_report(outcome + " — " + battle.encounter.title, metadata, "\n".join(summary), report_text)

func replay() -> void: open_battle(true)
func replay_qa_battle() -> bool:
	if not is_instance_valid(battle):
		return false
	if editable() and not battle.wave_intermission:
		_remember_positions()
	replay()
	return true
func edit_again() -> void:
	mode_choice.select(1)
	open_battle(true)
func compare_mode() -> void:
	mode_choice.select(0 if planned else 1)
	open_battle(true)

func _exit_tree() -> void:
	for executor in executors.values(): executor.disconnect_unit()
