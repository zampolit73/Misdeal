extends GutTest

const TABLE := preload("res://scenes/table/table.tscn")
const BATTLE := preload("res://scenes/battle/battle.tscn")
const HUD := preload("res://scripts/ui/hud_visual_v2.gd")
const MENU := preload("res://scripts/ui/system_dialog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var _old_save_path := ""


func before_each() -> void:
	_old_save_path = SAVE.instance().path
	SAVE.instance().path = ""
	RunState.reset_run()
	RunState.choose_protagonist("knight")


func after_each() -> void:
	SAVE.instance().path = _old_save_path
	RunState.reset_run()


func _table() -> Control:
	var table := TABLE.instantiate() as Control
	add_child_autofree(table)
	return table


func _battle(id: String) -> Control:
	RunState.active_card_id = id
	RunState.select_encounter("res://resources/encounters/%s.tres" % id)
	var battle := BATTLE.instantiate() as Control
	add_child_autofree(battle)
	return battle


func _plate(panel: Panel, bounds: Rect2) -> void:
	assert_eq(panel.get_rect(), bounds)
	var style := panel.get_theme_stylebox("panel") as StyleBoxTexture
	assert_not_null(style)
	assert_eq(style.texture, MENU.plate_style(MENU.SECONDARY).texture)
	assert_eq(style.texture.get_image().get_pixel(0, 0).a, 0.0)
	var chrome := panel.get_node_or_null("_MisdealChrome") as CanvasItem
	assert_true(chrome == null or not chrome.visible)


func _fits(outer: Control, child: Control) -> void:
	assert_true(outer.get_global_rect().encloses(child.get_global_rect()), child.name)


func test_table_grouped_actual_metrics_and_legacy_contour_coverage() -> void:
	var table := _table()
	await get_tree().process_frame
	await get_tree().process_frame
	var panel := table.get_node("HudPanel") as Panel
	var wizard := table.get_node("WizardLinePanel") as Panel
	_plate(panel, Rect2(312, 13, 656, 54))
	_plate(wizard, Rect2(336, 66, 608, 40))
	assert_true(panel.get_rect().encloses(Rect2(326, 26, 628, 35)), "Old baked stats and finials covered")
	assert_true(wizard.get_rect().encloses(Rect2(348, 68, 584, 33)), "Old baked dialogue and finials covered")
	assert_false(table.stats_label.visible)
	for index in range(5):
		var value := panel.get_node("MetricValue%d" % index) as Label
		assert_eq(value.text, ["1/12", "0", "1/3", "0", "0"][index])
		assert_true(value.visible)
		_fits(panel, value)
		assert_true(value.get_theme_font_size("font_size") >= 21)
		_fits(panel, panel.get_node("MetricName%d" % index))
	assert_eq(wizard.get_node("Speaker").text, "ВОЛШЕБНИК")
	_fits(wizard, table.wizard_line)
	assert_almost_eq(table.offer_a_button.size, Vector2(272, 338), Vector2(0.01, 0.01))
	assert_almost_eq(table.offer_b_button.size, Vector2(272, 338), Vector2(0.01, 0.01))


func test_table_live_conditions_reflow_without_moving_dialogue_and_full_copy() -> void:
	var table := _table()
	var panel := table.get_node("HudPanel") as Panel
	var wizard := table.get_node("WizardLinePanel") as Panel
	var wizard_bounds := wizard.get_rect()
	RunState.cards_resolved = 7
	RunState.gold = 135
	RunState.wizard_debt_active = true
	RunState.wizard_mark_danger_active = true
	RunState.sacrifice_order_ready = true
	RunState.defiance_order_ready = true
	RunState.held_card_id = "bone_patrol"
	RunState.oath_rank = 1
	HUD.refresh_table_stats(table)
	var conditions := panel.get_node("RunConditions") as Label
	var full: String = RunState.get_run_condition_text()
	assert_eq(conditions.text, full)
	assert_eq(conditions.tooltip_text, full)
	assert_true(conditions.visible)
	assert_eq(panel.get_node("MetricValue0").text, "8/12")
	assert_eq(panel.get_node("MetricValue1").text, "135")
	assert_eq(wizard.get_rect(), wizard_bounds)
	assert_true(panel.get_rect().end.y <= wizard.position.y + 1)
	var long_line := "Волшебник запомнит каждый из твоих поступков, каждую сделку и каждого оставленного спутника. ".repeat(4)
	table._set_wizard_line(long_line)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(table.wizard_line.text, long_line)
	assert_eq(table.wizard_line.tooltip_text, long_line)
	assert_lte(table.wizard_line.get_visible_line_count(), 2)
	_fits(wizard, table.wizard_line)
	_fits(panel, conditions)
	RunState.cards_resolved = 12
	HUD.refresh_table_stats(table)
	assert_eq(panel.get_node("MetricValue0").text, RunState.get_progress_text())


func test_battle_solo_header_exact_guidance_and_actual_modifiers() -> void:
	RunState.cards_resolved = 1
	var battle := _battle("grave_crossfire")
	await get_tree().process_frame
	await get_tree().process_frame
	_plate(battle.top_hud_panel, Rect2(23, 12, 837, 96))
	_plate(battle.run_hud_panel, Rect2(873, 12, 385, 96))
	assert_eq(battle.title_label.text, battle.encounter.title.to_upper())
	assert_false(battle.status_label.text.begins_with(battle.encounter.title.to_upper() + " — "))
	assert_true(battle.status_label.text.contains("два лучника") or battle.status_label.text.contains("Два лучника"))
	assert_eq(battle.deal_label.text, "КАРТА 2/12")
	var modifiers: Label = battle.run_condition_label
	assert_eq(modifiers.get_node("ModifierName0").text, "СОЛО")
	assert_eq(modifiers.get_node("ModifierValue0").text, "HP ×2.2 · УРОН ×1.9 · АТАКИ ×1.25")
	assert_eq(modifiers.get_node("ModifierName1").text, "ВРАГИ")
	assert_eq(modifiers.get_node("ModifierValue1").text, "HP −18% · УРОН −20%")
	assert_eq(modifiers.tooltip_text, battle._build_battle_condition_text())
	assert_false(modifiers.get_node("MoreModifiers").visible)
	_fits(battle.top_hud_panel, battle.title_label)
	_fits(battle.top_hud_panel, battle.status_label)
	_fits(battle.run_hud_panel, modifiers)
	for node in ["ModifierName0", "ModifierValue0", "ModifierName1", "ModifierValue1"]:
		_fits(modifiers, modifiers.get_node(node))
	assert_true(battle.top_hud_panel.get_node("DS3PaintedBanner").visible)
	assert_true(battle.run_hud_panel.get_node("DS3PaintedMedallion").visible)
	assert_eq(battle.arena_visual.get_rect(), Rect2(20, 96, 1240, 478))
	assert_eq(battle.bottom_hud_panel.position, Vector2(251, 575))
	battle._hide_preparation_hud()
	assert_false(modifiers.get_node("ModifierValue0").is_visible_in_tree())


func test_duo_and_trio_modifier_data_and_long_battle_status() -> void:
	RunState.recruit_companion("ranger", "HUD test")
	RunState.wizard_debt_active = true
	RunState.wizard_mark_danger_active = true
	var battle := _battle("iron_wall")
	var modifiers: Label = battle.run_condition_label
	assert_eq(modifiers.get_node("ModifierName0").text, "ДУО")
	assert_eq(modifiers.get_node("ModifierValue0").text, "HP +20% · УРОН +15%")
	assert_true(modifiers.get_node("MoreModifiers").visible)
	assert_true(modifiers.tooltip_text.contains("ДОЛГ • ВРАГИ +25%"))
	assert_true(modifiers.tooltip_text.contains("ПЕЧАТЬ • ВРАГИ +15%"))
	_fits(modifiers, modifiers.get_node("MoreModifiers"))
	var message := "ПОГРЕБАЛЬНАЯ ПРОЦЕССИЯ — жрец готовит «Последний обряд». Пока он жив, павший гробоносец может подняться ещё раз. Прервите ритуал!"
	battle._set_status(message)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(battle.status_label.text, message)
	assert_lte(battle.status_label.get_visible_line_count(), 2)
	_fits(battle.top_hud_panel, battle.status_label)
	# Presentation only: feed the genuine trio format using live RunState.
	RunState.recruit_companion("mage", "HUD test")
	var full: String = battle._build_battle_condition_text()
	HUD.present_modifiers(battle, full)
	assert_eq(modifiers.get_node("ModifierName0").text, "ОТРЯД 3/3")
	assert_eq(modifiers.get_node("ModifierValue0").text, "ПОЛНОЕ ДАВЛЕНИЕ")
	assert_false(modifiers.get_node("ModifierName1").visible)
	assert_eq(modifiers.tooltip_text, full)
