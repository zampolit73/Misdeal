extends Node
## Production adapter: uses the real Battle and the approved V4 planning UI.
## The QA fixture remains independent and disables this adapter explicitly.
const PLAN := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const EXECUTOR := preload("res://scripts/battle/planning/battle_plan_executor.gd")
const VIEW := preload("res://scripts/battle/planning/battle_plan_ui.gd")
const PRESETS := preload("res://scripts/battle/planning/battle_plan_presets.gd")
const DS3_BATTLE := preload("res://scripts/battle/battle_ds3_pass.gd")

var battle: Control
var ui: CanvasLayer
var plans: Dictionary = {}
var executors: Dictionary = {}
var histories: Dictionary = {}
var first_wave_enemies: Array[BattleUnit] = []
var selected_target_role := ""
var selected_target_slot := 0
var picking_target := false
var planned := true
var using_classic := false
var return_button: Button
var review_button: Button
var review_dialog: AcceptDialog
var completed := false

func is_production_mode() -> bool:
	return true

func configure(owner_battle: Control) -> void:
	battle = owner_battle
	for hero in battle.units:
		if hero.team == 0 and hero.visual_role != "jack" and hero.alive:
			var plan := PLAN.new()
			var drafts: Dictionary = RunState.get_meta("battle_plan_drafts", {})
			if drafts.has(hero.visual_role):
				plan.orders.assign(drafts[hero.visual_role].duplicate(true))
				plan.orders = plan.copy_orders()
			plans[hero.visual_role] = plan
		elif hero.team == 1:
			first_wave_enemies.append(hero)
	ui = VIEW.new()
	battle.add_child(ui)
	ui.build(self)
	_refresh_heroes()
	_hide_classic()
	battle.combat_beginning.connect(_on_combat_beginning)
	return_button = ui.button(ui, "Боевой план", Vector2(990, 542), Vector2(260, 31), show_planning)
	return_button.visible = false
	return_button.tooltip_text = "Вернуться к индивидуальным приказам, не меняя расстановку."
	review_dialog = AcceptDialog.new()
	review_dialog.title = "Разбор боевого плана"
	review_dialog.size = Vector2i(840, 540)
	battle.add_child(review_dialog)
	review_button = Button.new()
	review_button.text = "РАЗБОР ПРИКАЗОВ"
	review_button.position = Vector2(390, 634)
	review_button.size = Vector2(250, 48)
	DS3_BATTLE.style_secondary(review_button, Color("#a66636"))
	battle.get_node("ResultOverlay").add_child(review_button)
	review_button.pressed.connect(_show_review)
	review_button.visible = false
	set_process(true)

func role_name(role: String) -> String:
	return {"knight":"Рыцарь","ranger":"Следопыт","mage":"Маг"}.get(role,role)

func enemy_label(enemy: BattleUnit) -> String:
	if not is_instance_valid(enemy):
		return "—"
	var index := first_wave_enemies.find(enemy)
	return "%s · %d" % [enemy.display_name, index + 1] if index >= 0 else enemy.display_name

func _refresh_heroes() -> void:
	var living: Array[String] = []
	for hero in battle.units:
		if hero.team == 0 and hero.alive and hero.visual_role != "jack":
			living.append(hero.visual_role)
	ui.set_heroes(living)

func editable() -> bool:
	return planned and not using_classic and not battle.battle_finished and (not battle.combat_started or battle.wave_intermission)

func resize_plan(role: String, count: int) -> void:
	if not editable() or not plans.has(role):
		return
	var source: Array = plans[role].orders.duplicate(true)
	plans[role].resize_orders(count)
	for index in range(mini(count, source.size())):
		if source[index].has("spawn_slot"):
			plans[role].orders[index].spawn_slot = source[index].spawn_slot

func clear_assignment(order: Dictionary) -> void:
	order.target = null
	order.erase("spawn_slot")

func _persist_drafts() -> void:
	var drafts: Dictionary = RunState.get_meta("battle_plan_drafts", {})
	for role in plans:
		var clean: Array[Dictionary] = plans[role].copy_orders()
		for order in clean:
			order.target = null
		drafts[role] = clean
	RunState.set_meta("battle_plan_drafts", drafts)

func _hide_classic() -> void:
	for name in ["BottomHudPanel", "FightHudPanel", "OrderLabel", "OrderDescription",
			"AssaultOrderButton", "HuntOrderButton", "FormationOrderButton",
			"SacrificeOrderButton", "DefianceOrderButton", "TargetPreviewButton",
			"FightButton", "PlacementHint"]:
		var node := battle.get_node_or_null(name) as CanvasItem
		if node != null:
			node.visible = false
	if battle.target_preview != null:
		battle.target_preview.set_active(false)
	battle.side_objective_panel.position = Vector2(44, 145)

func _restore_classic() -> void:
	battle.bottom_hud_panel.visible = true
	battle.fight_hud_panel.visible = true
	battle.order_label.visible = true
	battle.order_description_label.visible = true
	battle.fight_button.visible = true
	battle.fight_button.disabled = false
	battle.placement_hint.visible = true
	battle.assault_order_button.visible = true
	battle.hunt_order_button.visible = true
	battle.formation_order_button.visible = true
	battle._configure_tactical_order_buttons()
	for button in [battle.assault_order_button, battle.hunt_order_button, battle.formation_order_button]:
		button.disabled = false
	battle._select_tactical_order(battle.tactical_order, false)
	battle.target_preview_button.visible = not battle.wave_intermission
	battle._sync_target_preview_button()
	DS3_BATTLE.layout_tactics(battle)
	DS3_BATTLE.position_side_objective(battle, false)
	battle.fight_button.text = "ВОЛНА II" if battle.wave_intermission else "БОЙ"

func return_to_hub() -> void:
	# The pilot's QA-Hub action becomes an explicit safe classic-mode choice.
	if not editable():
		return
	cancel_target()
	_persist_drafts()
	using_classic = true
	ui.hide_preparation()
	ui.hud.hide()
	_restore_classic()
	return_button.visible = true

func show_planning() -> void:
	if battle.battle_finished or (battle.combat_started and not battle.wave_intermission):
		return
	using_classic = false
	planned = true
	return_button.visible = false
	_hide_classic()
	ui.show_overview()

func show_setup() -> void:
	# In campaign, the QA "Settings" action becomes a visible safe reset.
	if not editable():
		return
	PRESETS.apply(plans, "assault")
	for plan in plans.values():
		for order in plan.orders:
			clear_assignment(order)
	ui.fallback_message = "План сброшен: один Натиск каждому герою."
	ui.show_overview()
	_persist_drafts()

func start_planned_battle() -> void:
	if not editable():
		return
	if ui.limit != null:
		ui.limit.apply()
	cancel_target()
	# Previous wave may have used an exclusive classic order; clear its global
	# effects before the per-hero executors start (especially Sacrifice HP drain).
	battle._select_tactical_order("assault", false)
	_persist_drafts()
	for hero in battle.units:
		if hero.team != 0 or hero.visual_role == "jack" or not hero.alive:
			continue
		if executors.has(hero.visual_role):
			executors[hero.visual_role].disconnect_unit()
		var runner := EXECUTOR.new(hero, plans[hero.visual_role], battle.battle_wave_index + (1 if battle.wave_intermission else 0))
		executors[hero.visual_role] = runner
		hero.plan_executor = runner
	ui.hide_preparation()
	ui.hud.hide()
	battle._on_fight_pressed()

func _on_combat_beginning() -> void:
	# BattleUnit starts its own executor after the intro; do not advance clocks here.
	return_button.visible = false
	if using_classic:
		ui.hud.hide()

func arm_target() -> void:
	if not editable() or not ui.detail.visible or battle.wave_intermission:
		return
	ui.limit.apply()
	picking_target = true
	selected_target_role = ui.current_role()
	selected_target_slot = ui.slot
	ui.set_picking(true)

func cancel_target() -> void:
	if not picking_target:
		return
	picking_target = false
	ui.set_picking(false)

func _pick_enemy(point: Vector2) -> BattleUnit:
	for enemy in ui.pick_markers:
		if is_instance_valid(enemy) and enemy.alive and ui.pick_markers[enemy].get_global_rect().has_point(point):
			return enemy
	var local := battle.get_viewport().get_canvas_transform().affine_inverse() * point
	var nearest: BattleUnit
	var distance := 60.0
	for enemy in battle.units:
		if enemy.team != 1 or not enemy.alive:
			continue
		var offset: Vector2 = local - enemy.global_position
		var gap: float = offset.distance_to(Vector2(0, -35))
		if Rect2(-42, -93, 84, 111).has_point(offset) and (nearest == null or gap < distance):
			nearest = enemy
			distance = gap
	return nearest

func _input(event: InputEvent) -> void:
	if not picking_target:
		return
	if event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		cancel_target()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion:
		ui.update_hover(_pick_enemy(event.position))
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var enemy := _pick_enemy(event.position)
		if enemy != null:
			var order: Dictionary = plans[selected_target_role].orders[selected_target_slot]
			order.target = weakref(enemy)
			order.spawn_slot = first_wave_enemies.find(enemy)
			cancel_target()
			get_viewport().set_input_as_handled()

func on_wave_intermission() -> void:
	if completed:
		return
	for role in executors:
		var executor: RefCounted = executors[role]
		histories[role] = executor.journal.duplicate(true)
		# Wave II may use classic orders instead. Never leave the old
		# per-hero planner policy attached after detaching its signals.
		var hero: BattleUnit = executor.unit()
		if is_instance_valid(hero) and hero.plan_executor == executor:
			hero.plan_executor = null
		executor.disconnect_unit()
	executors.clear()
	for plan in plans.values():
		for order in plan.orders:
			clear_assignment(order)
	first_wave_enemies.clear()
	_persist_drafts()
	if not using_classic:
		_refresh_heroes()
		_hide_classic()
	else:
		return_button.visible = true

func on_battle_finished(_won: bool) -> void:
	if completed:
		return
	completed = true
	cancel_target()
	ui.hide_preparation()
	ui.hud.hide()
	return_button.visible = false
	if not using_classic:
		review_button.visible = true

func _show_review() -> void:
	var rows: Array[String] = []
	for role in plans:
		rows.append(role_name(role))
		var log: Array = histories.get(role, []).duplicate(true)
		if executors.has(role):
			executors[role].finish(RunState.last_battle_won)
			log.append_array(executors[role].journal)
		for item in log:
			var label := ""
			match str(item.kind):
				"start": label = "Начало: " + str(item.order)
				"end": label = "Переход (%s), %.1f с" % ["лимит" if item.reason == "timeout" else str(item.reason), float(item.elapsed)]
				"kill": label = "Личное убийство: " + str(item.target)
				"death": label = "Герой погиб"
				"target": label = "Выбрана цель: " + str(item.actual)
			if not label.is_empty():
				rows.append("  Волна %d · %.1f с · %s" % [int(item.wave), float(item.time), label])
		rows.append("")
	review_dialog.dialog_text = "\n".join(rows) if not rows.is_empty() else "Боевых событий нет."
	review_dialog.popup_centered_ratio(0.78)

func _process(delta: float) -> void:
	if completed or not is_instance_valid(battle):
		return
	if using_classic and battle.combat_started and not battle.wave_intermission:
		return_button.visible = false
	if not using_classic:
		ui.update_live(delta)

func _exit_tree() -> void:
	for runner in executors.values():
		runner.disconnect_unit()
