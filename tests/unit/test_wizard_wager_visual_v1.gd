extends GutTest

const TABLE := preload("res://scenes/table/table.tscn")
const WAGER_PATH := "WagerOverlay/Root/WagerPanel"

func after_each() -> void:
	RunState.reset_run()

func test_offer_layout_press_accept_and_return() -> void:
	var table: Control = await _open_pending()
	var panel := table.get_node(WAGER_PATH) as Panel
	assert_eq(panel.get_global_rect(), Rect2(268, 232, 744, 475))
	assert_true(panel.get_node("WagerPlate") is TextureRect)
	assert_true(panel.get_node("SacrificeBonus").text.contains("Жертва"))
	assert_eq(panel.get_node("RiskPanel/Value").text, "ВРАГИ +25% УРОНА")
	assert_eq(panel.get_node("RewardPanel/Value").text, "ОБЫЧНАЯ ДОБЫЧА ×2")
	assert_false(panel.get_node("RiskPanel/RiskArt").visible)
	assert_false(panel.get_node("RewardPanel/RewardArt").visible)
	assert_eq(panel.get_node("WagerPlate").mouse_filter, Control.MOUSE_FILTER_IGNORE)
	for path in ["Title", "Quote", "RiskPanel/Kicker", "RiskPanel/Value", "RiskPanel/Title", "RewardPanel/Kicker", "RewardPanel/Value", "RewardPanel/Title", "SacrificeBonus", "AcceptButton", "RefuseButton"]:
		var control: Control = panel.get_node(path)
		assert_true(panel.get_global_rect().encloses(control.get_global_rect()), path)
		var font := control.get_theme_font("font")
		var point := control.get_theme_font_size("font_size")
		assert_lte(font.get_string_size(control.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x, control.size.x, path)
	assert_false(table.can_open_table_modal())
	assert_false(table.fate_spread_button.visible)
	assert_eq(panel.get_node("RiskPanel/Title").text, "Пока действует долг")
	var offer_ids := RunState.current_offer_ids.duplicate()
	var gold: int = RunState.gold
	var damage_before: float = RunState.get_enemy_damage_multiplier()
	var accept: Button = panel.get_node("AcceptButton")
	accept.pressed.emit()
	accept.pressed.emit()
	await get_tree().process_frame
	assert_false(table.wager_root.visible)
	assert_true(table.fate_spread_button.visible)
	assert_false(RunState.has_pending_wizard_wager())
	assert_true(RunState.wizard_debt_active)
	assert_true(RunState.sacrifice_order_ready)
	assert_eq(RunState.get_reward_multiplier(), 2)
	assert_almost_eq(RunState.get_enemy_damage_multiplier(), damage_before * 1.25, 0.0001)
	assert_eq(RunState.wizard_wagers_accepted, 1)
	assert_eq(RunState.current_offer_ids, offer_ids)
	assert_eq(RunState.gold, gold)
	assert_eq(table.focus_behavior_recursive, Control.FOCUS_BEHAVIOR_INHERITED)

func test_offer_decline_preserves_cards_and_no_debt() -> void:
	var table: Control = await _open_pending()
	var panel := table.get_node(WAGER_PATH) as Panel
	var refuse: Button = panel.get_node("RefuseButton")
	var accept: Button = panel.get_node("AcceptButton")
	assert_eq(refuse.get_node(refuse.focus_neighbor_left), accept)
	assert_eq(accept.get_node(accept.focus_neighbor_right), refuse)
	assert_eq(get_viewport().gui_get_focus_owner(), refuse)
	var offer_ids := RunState.current_offer_ids.duplicate()
	refuse.pressed.emit()
	refuse.pressed.emit()
	await get_tree().process_frame
	assert_false(table.wager_root.visible)
	assert_true(table.fate_spread_button.visible)
	assert_false(RunState.has_pending_wizard_wager())
	assert_false(RunState.wizard_debt_active)
	assert_false(RunState.sacrifice_order_ready)
	assert_eq(RunState.get_reward_multiplier(), 1)
	assert_eq(RunState.wizard_wagers_declined, 1)
	assert_eq(RunState.current_offer_ids, offer_ids)
	assert_eq(table.focus_behavior_recursive, Control.FOCUS_BEHAVIOR_INHERITED)

func _open_pending() -> Control:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.wizard_wager_pending = true
	var table: Control = TABLE.instantiate()
	add_child_autofree(table)
	await get_tree().create_timer(1.5).timeout
	assert_true(table.wager_root.visible)
	assert_true(RunState.has_pending_wizard_wager())
	return table
