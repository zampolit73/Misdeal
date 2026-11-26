extends GutTest

const BATTLE := preload("res://scenes/battle/battle.tscn")
const HUD := preload("res://scripts/battle/planning/battle_live_hud.gd")

func after_each() -> void:
	RunState.reset_run()

func test_hud_geometry_emblems_and_empty_rows() -> void:
	var hud := HUD.new()
	add_child_autofree(hud)
	hud.build()
	assert_eq(hud.position, Vector2(838, 156))
	assert_false(hud.visible)
	assert_eq(hud.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_true(hud.get_theme_stylebox("panel") is StyleBoxTexture)
	assert_eq(hud.get_theme_stylebox("panel").texture.get_size(), Vector2(377, 249))
	var entries: Array[Dictionary] = [
		_row("knight", "Рыцарь", "II", "Оборона", "1.8 с"),
		_row("ranger", "Следопыт", "I", "Охота", "5.8 с"),
		_row("mage", "Маг", "III", "Натиск", "до конца"),
	]
	hud.show()
	hud.present_rows(entries)
	assert_eq(hud.size, Vector2(414, 96))
	for index in entries.size():
		var row: Control = hud.get_node("OrderRow%d" % (index + 1))
		assert_true(row.visible)
		assert_eq(row.get_node("RoleEmblem").get_meta("role"), entries[index].role)
		assert_eq(row.get_node("Hero").text, entries[index].hero)
		assert_eq(row.get_node("Stage").text, entries[index].stage)
		assert_eq(row.get_node("Tactic").text, entries[index].tactic)
		assert_eq(row.get_node("Remaining").text, entries[index].remaining)
		for label_name in ["Hero", "Stage", "Tactic", "Remaining"]:
			var label: Label = row.get_node(label_name)
			assert_eq(label.mouse_filter, Control.MOUSE_FILTER_IGNORE)
			assert_lte(label.get_theme_font("font").get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size")).x, label.size.x)
		assert_true(Rect2(Vector2.ZERO, hud.size).encloses(row.get_rect()))
	assert_false(hud.get_node("OrderRow3/RowRule").visible)
	entries.remove_at(1)
	hud.present_rows(entries)
	assert_eq(hud.size.y, 72.0)
	assert_eq(hud.get_node("OrderRow2/RoleEmblem").get_meta("role"), "mage")
	assert_false(hud.get_node("OrderRow3").visible)
	entries.remove_at(0)
	hud.present_rows(entries)
	assert_eq(hud.size.y, 48.0)
	assert_eq(hud.get_node("OrderRow1/Hero").text, "Маг")
	assert_false(hud.get_node("OrderRow2").visible)
	entries.clear()
	hud.present_rows(entries)
	assert_false(hud.visible)

func test_live_campaign_reads_executors_and_transition_notice() -> void:
	var battle: Control = _new_battle(true)
	var controller: Node = battle.combat_plan_controller
	var ui: CanvasLayer = controller.ui
	var hud: Panel = ui.hud
	assert_false(hud.visible)
	for role in controller.plans:
		controller.plans[role].orders.assign([_order("assault"), _order("defense")])
	controller.start_planned_battle()
	assert_false(hud.visible, "No HUD during the intro")
	await get_tree().create_timer(1.05).timeout
	assert_true(battle.combat_live)
	assert_true(hud.visible)
	assert_eq(controller.executors.size(), 3)
	# Freeze unit movement only in this test after real combat startup.
	for unit in battle.units:
		unit.set_process(false)
		unit.set_physics_process(false)
	var knight: RefCounted = controller.executors["knight"]
	var ranger: RefCounted = controller.executors["ranger"]
	var mage: RefCounted = controller.executors["mage"]
	knight.elapsed = 1.2
	ranger.elapsed = 2.5
	mage.elapsed = 3.0
	ui.update_live(0.0)
	assert_eq(hud.get_node("OrderRow1/Remaining").text, "3.8 с")
	assert_eq(hud.get_node("OrderRow2/Remaining").text, "2.5 с")
	assert_eq(hud.get_node("OrderRow3/Remaining").text, "2.0 с")
	assert_true(knight.advance("time"))
	assert_true(ranger.advance("timeout"))
	assert_true(mage.advance("damage_dealt"))
	ui.update_live(0.0)
	assert_eq(hud.get_node("OrderRow1/Stage").text, "II")
	assert_eq(hud.get_node("OrderRow1/Tactic").text, "Оборона")
	assert_eq(hud.get_node("OrderRow1/Remaining").text, "до конца")
	assert_true(hud.notice_panel.visible)
	assert_true(hud.notice_label.text.contains("Рыцарь → II Оборона · по времени"))
	assert_true(hud.notice_label.text.contains("Следопыт → II Оборона · лимит истёк"))
	assert_true(hud.notice_label.text.contains("Маг → II Оборона · после нанесения урона"))
	assert_eq(hud.notice_label.text.split("\n").size(), 3)
	assert_gte(hud.notice_panel.position.y, hud.size.y)
	assert_true(Rect2(0, 0, 1280, 720).encloses(hud.notice_panel.get_global_rect()))
	var notice_width: float = hud.notice_label.size.x
	for line in hud.notice_label.text.split("\n"):
		assert_lte(hud.notice_label.get_theme_font("font").get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, hud.notice_label.get_theme_font_size("font_size")).x, notice_width)
	var clock_before: float = knight.clock
	ui.update_live(3.0)
	assert_false(hud.notice_panel.visible)
	assert_eq(knight.clock, clock_before, "Renderer cannot advance the combat clock")
	ranger.unit().alive = false
	ui.update_live(0.0)
	assert_false(hud.get_node("OrderRow3").visible)
	assert_eq(hud.get_node("OrderRow2/Hero").text, "Маг")
	assert_eq(hud.size.y, 72.0)
	battle.combat_live = false
	ui.update_live(0.0)
	assert_false(hud.visible, "No HUD during a wave break")
	controller.on_battle_finished(true)
	assert_false(hud.visible, "No HUD over the result")

func test_solo_and_classic_do_not_show_phantom_rows() -> void:
	var battle: Control = _new_battle(false)
	var controller: Node = battle.combat_plan_controller
	var ui: CanvasLayer = controller.ui
	controller.return_to_hub()
	assert_true(controller.using_classic)
	assert_false(ui.hud.visible)
	controller.show_planning()
	controller.start_planned_battle()
	await get_tree().create_timer(1.05).timeout
	assert_true(battle.combat_live)
	assert_true(ui.hud.visible)
	assert_eq(ui.hud.size.y, 48.0)
	assert_eq(ui.hud.get_node("OrderRow1/Remaining").text, "до конца")
	assert_false(ui.hud.get_node("OrderRow2").visible)
	assert_false(ui.hud.get_node("OrderRow3").visible)

func _new_battle(trio: bool) -> Control:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	if trio:
		RunState.recruit_companion("ranger", "HUD test")
		RunState.recruit_companion("mage", "HUD test")
	RunState.active_card_id = "grave_bell"
	var battle := BATTLE.instantiate()
	add_child_autofree(battle)
	return battle

func _order(tactic: String) -> Dictionary:
	return {"tactic": tactic, "priority": "nearest", "condition": "time", "limit": 5, "target": null}

func _row(role: String, hero: String, stage: String, tactic: String, remaining: String) -> Dictionary:
	return {"role": role, "hero": hero, "stage": stage, "tactic": tactic, "remaining": remaining}
