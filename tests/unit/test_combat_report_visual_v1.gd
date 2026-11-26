extends GutTest

const REPORT := preload("res://scripts/battle/planning/battle_report_visual.gd")
const BATTLE := preload("res://scenes/battle/battle.tscn")

func after_each() -> void:
	RunState.reset_run()

func test_real_campaign_report_is_read_only_and_modal() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "Report test")
	RunState.recruit_companion("mage", "Report test")
	RunState.active_card_id = "grave_bell"
	var battle: Control = BATTLE.instantiate()
	add_child_autofree(battle)
	var controller: Node = battle.combat_plan_controller
	assert_false(controller.review_button.visible)
	controller._show_review()
	assert_null(controller.review_dialog)
	controller.start_planned_battle()
	await get_tree().create_timer(1.05).timeout
	for unit in battle.units:
		unit.set_process(false)
		unit.set_physics_process(false)
	assert_eq(controller.executors.size(), 3)
	var knight: RefCounted = controller.executors["knight"]
	# A recorded earlier-wave event and actual live executor events keep their
	# order, timestamps and source labels, including unknown target names.
	controller.histories["knight"] = [
		{"kind":"start", "time":0.0, "wave":1, "order":"Оборона / Ближайший"},
		{"kind":"end", "time":5.0, "wave":1, "reason":"time", "elapsed":5.0}
	]
	knight.wave = 2
	knight.clock = 2.3
	knight.record("kill", {"target":"Скелет [#4]"})
	for i in range(24):
		knight.record("target", {"actual":"Могильный звонарь [#6]"})
	battle._finish_battle(true)
	assert_true(controller.review_button.visible)
	assert_false(knight.active)
	var initial: Array = knight.journal.duplicate(true)
	var result_count := 0
	for item in initial:
		if item.kind == "result":
			result_count += 1
	assert_eq(result_count, 1)
	controller.review_button.grab_focus()
	controller.review_button.pressed.emit()
	var report: CanvasLayer = controller.review_dialog
	assert_not_null(report)
	assert_eq(report.frame.size.round(), REPORT.PANEL_SIZE)
	assert_eq(report.frame.get_node("Encounter").text, battle.encounter.title.to_upper())
	assert_eq(report.journal.get_child_count(), 3)
	var section: VBoxContainer = report.journal.get_node("Hero_knight")
	assert_eq(section.get_node("Event1/Time").text, "Волна 1 · 0.0 с")
	assert_eq(section.get_node("Event2/Event").text, "Переход: Время · 5.0 с")
	var kill_found := false
	for row in section.get_children():
		var event := row.get_node_or_null("Event") as Label
		if event != null and event.text == "Личное убийство: Скелет [#4]":
			kill_found = true
			assert_eq(row.get_node("Time").text, "Волна 2 · 2.3 с")
	assert_true(kill_found)
	assert_eq(report.close_button.text, "ЗАКРЫТЬ [ESC]")
	assert_eq(report.root.mouse_filter, Control.MOUSE_FILTER_STOP)
	assert_eq(get_viewport().gui_get_focus_owner(), report.close_button)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_gt(report.scroll.get_v_scroll_bar().max_value, report.scroll.get_v_scroll_bar().page)
	var key := InputEventKey.new()
	key.keycode = KEY_END
	key.pressed = true
	report._input(key)
	assert_gt(report.scroll.scroll_vertical, 0)
	key.keycode = KEY_ESCAPE
	get_viewport().push_input(key)
	assert_null(controller.review_dialog)
	assert_eq(get_viewport().gui_get_focus_owner(), controller.review_button)
	assert_eq(knight.journal, initial)
	controller.review_button.pressed.emit()
	assert_eq(knight.journal, initial)
	controller.review_dialog.close_button.pressed.emit()
	assert_null(controller.review_dialog)
	assert_true(battle.continue_button.visible)
	assert_true(RunState.last_battle_won)

func test_empty_solo_and_event_translation() -> void:
	var report := REPORT.new()
	add_child_autofree(report)
	report.present("Длинное название боевого столкновения", {"mage":[]})
	assert_eq(report.journal.get_child_count(), 1)
	assert_not_null(report.journal.get_node("Hero_mage/Empty"))
	assert_eq(REPORT.describe_event({"kind":"death"}), "Герой погиб")
	assert_eq(REPORT.describe_event({"kind":"end", "reason":"timeout", "elapsed":6.0}), "Переход: Лимит истёк · 6.0 с")
	assert_eq(REPORT.describe_event({"kind":"end", "reason":"damage_dealt", "elapsed":2.0}), "Переход: Нанёс урон · 2.0 с")
	assert_eq(REPORT.describe_event({"kind":"result"}), "")
	report.present("Могильный звон", {})
	assert_not_null(report.journal.get_node("Empty"))

func test_classic_keeps_report_hidden() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.active_card_id = "grave_bell"
	var battle: Control = BATTLE.instantiate()
	add_child_autofree(battle)
	var controller: Node = battle.combat_plan_controller
	controller.return_to_hub()
	controller.on_battle_finished(false)
	assert_false(controller.review_button.visible)
	controller._show_review()
	assert_null(controller.review_dialog)

func test_defeat_preserves_last_deal_controls() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.active_card_id = "grave_bell"
	var battle: Control = BATTLE.instantiate()
	add_child_autofree(battle)
	var controller: Node = battle.combat_plan_controller
	controller.start_planned_battle()
	await get_tree().create_timer(1.05).timeout
	battle._finish_battle(false)
	assert_true(controller.review_button.visible)
	var offer_before: bool = RunState.last_deal_pending
	var accept_before: bool = battle.last_deal_accept_button.visible
	var refusal_before: bool = battle.last_deal_refuse_button.visible
	controller.review_button.pressed.emit()
	assert_not_null(controller.review_dialog)
	controller.review_dialog.close_button.pressed.emit()
	assert_false(RunState.last_battle_won)
	assert_eq(RunState.last_deal_pending, offer_before)
	assert_eq(battle.last_deal_accept_button.visible, accept_before)
	assert_eq(battle.last_deal_refuse_button.visible, refusal_before)
	assert_true(controller.review_button.has_focus())
