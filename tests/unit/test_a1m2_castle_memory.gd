extends GutTest

const STATE := preload("res://scripts/core/run_state.gd")
const EVENT := preload("res://scenes/event/act_choice.tscn")
const TEXT := preload("res://scripts/story/act1_castle_memory_text.gd")


func before_each() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("knight"))


func after_each() -> void:
	RunState.reset_run()


func _state() -> Node:
	var state := STATE.new() as Node
	add_child_autofree(state)
	state.reset_run()
	assert_true(state.choose_protagonist("knight"))
	return state


func _event(card_id: String) -> Control:
	RunState.active_card_id = card_id
	var event := EVENT.instantiate() as Control
	add_child_autofree(event)
	return event


func test_extended_facts_reject_unknown_and_reset_cleanly() -> void:
	var state := _state()
	assert_false(state.record_castle_fact("unapproved", "bone_patrol"))
	for fact_id in ["rations_hidden", "southern_march", "silenced_witness"]:
		assert_true(state.record_castle_fact(fact_id, "test_source"))
		assert_true(state.has_castle_fact(fact_id))
	assert_eq(state.get_bone_tax_gold_price(), 20)
	assert_eq(state.get_last_camp_healer_price(), 30)
	state.reset_run()
	assert_eq(state.get_bone_tax_gold_price(), 25)
	assert_eq(state.get_last_camp_healer_price(), 35)
	assert_eq(state.consume_castle_memory_line(), "")


func test_victorious_existing_battles_expose_independent_sources() -> void:
	var sources := {
		"bone_patrol": "promise_heard",
		"graveyard_ambush": "promise_heard",
		"grave_crossfire": "promise_heard",
		"black_crossing": "southern_march",
		"black_lantern_road": "southern_march",
		"crypt_guard": "silenced_witness",
		"gallows_volley": "silenced_witness",
	}
	for card_id in sources:
		var state := _state()
		state.active_card_id = card_id
		state.last_battle_won = true
		state.complete_active_card()
		var fact_id: String = sources[card_id]
		assert_true(state.has_castle_fact(fact_id), card_id)
		assert_eq(state.get_castle_fact_source(fact_id), card_id)


func test_failed_battle_never_grants_clues() -> void:
	for card_id in ["bone_patrol", "black_crossing", "crypt_guard", "court_of_the_mute"]:
		var state := _state()
		state.active_card_id = card_id
		state.last_battle_won = false
		state.complete_active_card()
		for fact_id in ["promise_heard", "orders_conflict", "southern_march", "silenced_witness"]:
			assert_false(state.has_castle_fact(fact_id), card_id)


func test_court_win_grants_both_truth_and_silenced_witness_once() -> void:
	var state := _state()
	state.active_card_id = "court_of_the_mute"
	state.last_battle_won = true
	state.complete_active_card()
	assert_true(state.has_castle_fact("orders_conflict"))
	assert_true(state.has_castle_fact("silenced_witness"))
	assert_eq(state.get_castle_fact_source("orders_conflict"), "court_of_the_mute")
	assert_eq(state.get_castle_fact_source("silenced_witness"), "court_of_the_mute")
	assert_true(state.record_castle_fact("rations_hidden", "debtor_bones"))
	assert_false(state.record_castle_fact("silenced_witness", "chained_prisoner"))


func test_sparing_debtor_bones_exposes_hidden_supply_record() -> void:
	var event := _event("debtor_bones")
	event.call("_resolve_debtor_bones", "safe")
	assert_eq(RunState.gold, 15)
	assert_eq(RunState.get_event_outcome("debtor_bones"), "safe")
	assert_true(RunState.has_castle_fact("rations_hidden"))
	assert_eq(RunState.get_bone_tax_gold_price(), 20)
	assert_eq(RunState.get_wizard_tithe_gold_price(), 25)


func test_debtor_bones_risk_does_not_promise_a_ledger_clue() -> void:
	var event := _event("debtor_bones")
	event.call("_resolve_debtor_bones", "break")
	assert_eq(RunState.gold, 25)
	assert_false(RunState.has_castle_fact("rations_hidden"))
	assert_eq(RunState.get_bone_tax_gold_price(), 25)
	assert_eq(RunState.get_wizard_tithe_gold_price(), 40)


func test_debtor_bones_leave_does_not_grant_evidence() -> void:
	var event := _event("debtor_bones")
	event.call("_resolve_leave")
	assert_false(RunState.has_castle_fact("rations_hidden"))


func test_candle_seller_purchase_exposes_alternative_supply_record() -> void:
	RunState.gold = 25
	var event := _event("candle_seller")
	event.call("_resolve_candle_seller", "knight")
	assert_eq(RunState.gold, 0)
	assert_eq(RunState.hero_upgrade_ids.size(), 1)
	assert_eq(RunState.get_castle_fact_source("rations_hidden"), "candle_seller")


func test_candle_seller_leave_and_unaffordable_purchase_do_not_grant_clue() -> void:
	RunState.gold = 24
	var event := _event("candle_seller")
	event.call("_resolve_candle_seller", "knight")
	assert_false(RunState.has_castle_fact("rations_hidden"))
	assert_eq(RunState.cards_resolved, 0)
	event.call("_resolve_leave")
	assert_false(RunState.has_castle_fact("rations_hidden"))


func test_gravedigger_paid_upgrade_is_another_supply_record_source() -> void:
	RunState.gold = 35
	var event := _event("gravedigger_shop")
	event.call("_resolve_shop", "knight")
	assert_eq(RunState.gold, 0)
	assert_eq(RunState.get_event_outcome("gravedigger_shop"), "bought")
	assert_eq(RunState.get_castle_fact_source("rations_hidden"), "gravedigger_shop")


func test_ash_rest_recruitment_grants_march_without_changing_scar() -> void:
	var event := _event("ash_rest")
	event.call("_resolve_ash_rest", "recruit")
	assert_true(RunState.is_role_in_party("ranger"))
	assert_true(RunState.has_rescue_scar("ranger"))
	assert_eq(RunState.get_castle_fact_source("southern_march"), "ash_rest")


func test_ash_rest_leave_grants_no_march_fact() -> void:
	# A knight with the Ranger already in the party gets an actual Leave option.
	assert_true(RunState.recruit_companion("ranger", "setup"))
	var event := _event("ash_rest")
	event.call("_resolve_leave")
	assert_false(RunState.has_castle_fact("southern_march"))


func test_rattling_bridge_abandon_is_still_a_road_witness() -> void:
	var event := _event("rattling_bridge")
	event.call("_resolve_rattling_bridge", "abandon")
	assert_eq(RunState.get_castle_fact_source("southern_march"), "rattling_bridge")
	assert_eq(RunState.get_companion_fate("ranger"), "lost")


func test_chained_prisoner_rescue_reveals_suppressed_testimony() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("mage"))
	var event := _event("chained_prisoner")
	event.call("_resolve_chained_prisoner", "recruit")
	assert_true(RunState.is_role_in_party("knight"))
	assert_true(RunState.has_castle_fact("silenced_witness"))
	assert_eq(RunState.get_castle_fact_source("silenced_witness"), "chained_prisoner")


func test_chained_prisoner_loot_does_not_grant_suppressed_testimony() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("mage"))
	var event := _event("chained_prisoner")
	event.call("_resolve_chained_prisoner", "loot_recruitment")
	assert_eq(RunState.gold, 25)
	assert_false(RunState.has_castle_fact("silenced_witness"))


func test_bone_tax_gold_price_matches_physical_card_and_payment() -> void:
	assert_true(RunState.record_castle_fact("rations_hidden", "debtor_bones"))
	RunState.gold = 20
	var event := _event("bone_tax")
	var btn := event.get_node("Panel/Choices/ChoiceA") as Button
	assert_true(btn.tooltip_text.contains("20 ЗОЛОТА"))
	assert_false(btn.disabled)
	event.call("_resolve_bone_tax", "gold")
	assert_eq(RunState.gold, 0)
	assert_eq(RunState.party_hp_bonus, 0.0)


func test_bone_tax_without_evidence_stays_25_and_blood_is_unchanged() -> void:
	RunState.gold = 24
	var event := _event("bone_tax")
	var btn := event.get_node("Panel/Choices/ChoiceA") as Button
	assert_true(btn.tooltip_text.contains("25 ЗОЛОТА"))
	assert_true(btn.disabled)
	event.call("_resolve_bone_tax", "gold")
	assert_eq(RunState.gold, 24)
	assert_eq(RunState.cards_resolved, 0)
	event.call("_resolve_bone_tax", "blood")
	assert_eq(RunState.party_hp_bonus, -15.0)
	assert_eq(RunState.gold, 24)


func test_last_camp_discount_recruits_knight_without_new_scar() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("mage"))
	assert_true(RunState.record_castle_fact("southern_march", "black_crossing"))
	RunState.gold = 30
	var event := _event("last_camp")
	var btn := event.get_node("Panel/Choices/ChoiceB") as Button
	assert_true(btn.tooltip_text.contains("30"))
	assert_false(btn.disabled)
	event.call("_resolve_last_camp", "recruit_gold")
	assert_eq(RunState.gold, 0)
	assert_true(RunState.is_role_in_party("knight"))
	assert_false(RunState.has_rescue_scar("knight"))


func test_last_camp_without_route_preserves_healer_35_and_threshold() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("ranger"))
	RunState.gold = 34
	var event := _event("last_camp")
	var btn := event.get_node("Panel/Choices/ChoiceB") as Button
	assert_true(btn.tooltip_text.contains("35"))
	assert_true(btn.disabled)
	event.call("_resolve_last_camp", "recruit_gold")
	assert_eq(RunState.gold, 34)
	assert_false(RunState.is_role_in_party("knight"))


func test_three_new_memory_lines_are_distinct_and_do_not_spoil_xiii() -> void:
	var state := _state()
	var lines: Array[String] = []
	for fact_id in ["rations_hidden", "southern_march", "silenced_witness"]:
		assert_true(state.record_castle_fact(fact_id, "real_card"))
		var phrase: String = TEXT.wizard_line_for_fact(fact_id)
		assert_false(phrase.is_empty())
		assert_false(phrase.contains("Канцлер"))
		assert_false(phrase.contains("Надзиратель"))
		lines.append(phrase)
	assert_ne(lines[0], lines[1])
	assert_ne(lines[1], lines[2])
	assert_ne(lines[0], lines[2])
	for phrase in lines:
		assert_eq(state.consume_castle_memory_line(), phrase)
	assert_eq(state.consume_castle_memory_line(), "")


func test_a1m1_ledger_price_remains_unchanged_by_other_clues() -> void:
	var state := _state()
	state.record_castle_fact("rations_hidden", "debtor_bones")
	state.record_castle_fact("southern_march", "black_crossing")
	state.record_castle_fact("silenced_witness", "crypt_guard")
	assert_eq(state.get_blood_ledger_gold_price(), 40)
	state.record_castle_fact("orders_conflict", "echo_crypt")
	assert_eq(state.get_blood_ledger_gold_price(), 35)
