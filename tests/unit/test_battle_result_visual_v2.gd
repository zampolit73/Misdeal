extends GutTest

const BATTLE := preload("res://scenes/battle/battle.tscn")
const MENU := preload("res://scripts/ui/system_dialog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var _original_path := ""


func before_each() -> void:
	_original_path = SAVE.instance().path
	SAVE.instance().path = ""
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.active_card_id = "bone_patrol"
	RunState.select_encounter(RunState.get_card("bone_patrol").target_path)


func after_each() -> void:
	SAVE.instance().path = _original_path
	RunState.reset_run()


func _battle() -> Control:
	var battle: Control = BATTLE.instantiate()
	add_child_autofree(battle)
	return battle


func _inside_panel(battle: Control, node: Control) -> void:
	assert_true(battle.result_backdrop.get_global_rect().encloses(node.get_global_rect()), node.name)


func _live_copy(label: Label) -> void:
	assert_eq(label.get_visible_line_count(), label.get_line_count(), label.name + " all lines visible")
	var font: Font = label.get_theme_font("font")
	var point: int = label.get_theme_font_size("font_size")
	for line in label.text.split("\n"):
		assert_true(font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x <= label.size.x, label.name + " fits width")


func test_victory_groups_existing_reward_and_report_with_live_bonus_copy() -> void:
	var battle := _battle()
	assert_true(RunState.add_artifact("marked_coin"))
	battle.side_objective_id = "fast_crush"
	battle.side_objective_failed = false
	battle.combat_elapsed = 1.0
	var old_gold := RunState.gold
	battle._finish_battle(true)
	await get_tree().process_frame
	await get_tree().process_frame
	var controller: Node = battle.combat_plan_controller
	assert_true(RunState.last_battle_won)
	assert_gt(RunState.gold, old_gold)
	assert_eq(battle.result_label.text, "ПОБЕДА")
	assert_true(battle.result_subtitle.text.contains("УСЛОВИЕ ВОЛШЕБНИКА"))
	assert_true(battle.result_subtitle.text.contains("золота"))
	assert_eq(battle.result_backdrop.size, Vector2(640, 360))
	assert_eq(battle.get_node("ResultOverlay/ResultEncounter").text, battle.encounter.title.to_upper())
	for node in [battle.result_label, battle.result_subtitle, battle.get_node("ResultOverlay/ResultNote"), controller.review_button, battle.continue_button]:
		_inside_panel(battle, node)
	_live_copy(battle.result_subtitle)
	assert_true(battle.continue_button.visible)
	assert_true(controller.review_button.visible)
	assert_false(battle.last_deal_accept_button.visible)
	assert_false(battle.last_deal_refuse_button.visible)
	assert_true(controller.review_button.get_global_rect().end.x < battle.continue_button.get_global_rect().position.x)
	var style: StyleBoxTexture = battle.continue_button.get_theme_stylebox("normal")
	assert_eq(style.texture, MENU.plate_style(MENU.PRIMARY).texture)
	assert_eq(style.texture.get_image().get_pixel(0, 0).a, 0.0)
	assert_true(battle.continue_button.pressed.is_connected(battle._on_continue_pressed))
	var chrome := battle.result_backdrop.get_node_or_null("_MisdealChrome") as Control
	assert_true(chrome == null or not chrome.visible)
	var gold := RunState.gold
	controller.review_button.pressed.emit()
	assert_not_null(controller.review_dialog)
	controller.review_dialog.close_button.pressed.emit()
	assert_eq(RunState.gold, gold)
	assert_true(controller.review_button.has_focus())
	battle._finish_battle(true)
	assert_eq(RunState.gold, gold, "Repeated result cannot award gold again")


func test_last_deal_keeps_exact_live_hp_and_relic_prices_and_focus() -> void:
	for artifact in ["", "marked_coin"]:
		RunState.reset_run()
		RunState.choose_protagonist("knight")
		RunState.active_card_id = "bone_patrol"
		RunState.select_encounter(RunState.get_card("bone_patrol").target_path)
		if not artifact.is_empty():
			assert_true(RunState.add_artifact(artifact))
		var battle := _battle()
		battle._finish_battle(false)
		await get_tree().process_frame
		await get_tree().process_frame
		var overlay := battle.get_node("ResultOverlay")
		var detail: Label = overlay.get_node("ResultPriceDetail")
		var controller: Node = battle.combat_plan_controller
		assert_true(RunState.last_deal_pending)
		assert_eq(battle.result_backdrop.size, Vector2(744, 466))
		assert_eq(battle.result_label.text, "ПОСЛЕДНЯЯ СДЕЛКА")
		assert_true(detail.visible)
		assert_eq(battle.last_deal_price_label.text + "\n" + detail.text, RunState.get_last_deal_price_text())
		_live_copy(battle.last_deal_price_label)
		_live_copy(detail)
		for node in [battle.result_label, battle.result_subtitle, battle.last_deal_price_label, detail, battle.last_deal_accept_button, battle.last_deal_refuse_button, controller.review_button]:
			_inside_panel(battle, node)
		assert_true(battle.last_deal_accept_button.visible)
		assert_true(battle.last_deal_refuse_button.visible)
		assert_false(battle.continue_button.visible)
		assert_true(controller.review_button.has_focus(), "Read-only report owns safe initial focus")
		assert_true(battle.last_deal_accept_button.pressed.is_connected(battle._on_last_deal_accept_pressed))
		assert_true(battle.last_deal_refuse_button.pressed.is_connected(battle._on_last_deal_refuse_pressed))
		battle.queue_free()
		await get_tree().process_frame


func test_failed_deal_save_keeps_offer_and_displays_original_error() -> void:
	var battle := _battle()
	battle._finish_battle(false)
	assert_true(RunState.last_deal_pending)
	SAVE.instance().path = "res://.tmp/nonexistent_visual_v2_directory/slot.json"
	battle.last_deal_accept_button.pressed.emit()
	await get_tree().process_frame
	assert_true(RunState.last_deal_pending)
	assert_false(RunState.last_deal_used)
	assert_false(battle.last_deal_accept_button.disabled)
	assert_false(battle.last_deal_refuse_button.disabled)
	var note: Label = battle.get_node("ResultOverlay/ResultNote")
	assert_false(SAVE.instance().error_message.is_empty())
	assert_eq(note.text, SAVE.instance().error_message)
	assert_eq(note.get_theme_color("font_color"), Color("f0a299"))
	_inside_panel(battle, note)
	_live_copy(note)


func test_final_defeat_has_no_second_offer_and_classic_has_no_report() -> void:
	RunState.last_deal_used = true
	var battle := _battle()
	var controller: Node = battle.combat_plan_controller
	controller.return_to_hub()
	battle._finish_battle(false)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(battle.result_label.text, "ПОРАЖЕНИЕ")
	assert_eq(battle.result_backdrop.size, Vector2(680, 360))
	assert_false(battle.last_deal_accept_button.visible)
	assert_false(battle.continue_button.visible)
	assert_false(controller.review_button.visible)
	assert_true(battle.last_deal_refuse_button.visible)
	assert_eq(battle.last_deal_refuse_button.text, "ЗАВЕРШИТЬ ЗАБЕГ")
	_inside_panel(battle, battle.last_deal_refuse_button)
	assert_almost_eq(battle.last_deal_refuse_button.get_global_rect().get_center().x, battle.result_backdrop.get_global_rect().get_center().x, 0.1)
	assert_eq(battle.last_deal_price_label.text, "ПОСЛЕДНЯЯ СДЕЛКА УЖЕ ИСПОЛЬЗОВАНА")
	assert_false(RunState.last_deal_pending)


func test_restored_pending_offer_uses_same_result_and_no_charge() -> void:
	assert_true(RunState.begin_last_deal())
	var original_price := RunState.get_last_deal_price_text()
	var battle := _battle()
	await get_tree().process_frame
	await get_tree().process_frame
	assert_true(battle.battle_finished)
	assert_true(battle.last_deal_accept_button.visible)
	assert_eq(battle.result_backdrop.size, Vector2(744, 466))
	assert_true(RunState.last_deal_pending)
	assert_false(RunState.last_deal_used)
	assert_eq(battle.last_deal_price_label.text + "\n" + battle.get_node("ResultOverlay/ResultPriceDetail").text, original_price)
