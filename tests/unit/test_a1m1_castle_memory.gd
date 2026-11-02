extends GutTest

# A1M1 covers the shipped RunState and real ActChoice scene. The test-owned
# autoload state is reset before and after every event scenario.
const STATE := preload("res://scripts/core/run_state.gd")
const CHOICE_SCENE := preload("res://scenes/event/act_choice.tscn")
const MEMORY_TEXT := preload("res://scripts/story/act1_castle_memory_text.gd")


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
	var event := CHOICE_SCENE.instantiate() as Control
	add_child_autofree(event)
	assert_eq(RunState.active_card_id, card_id)
	return event


func test_empty_run_has_normal_ledger_price_and_no_evidence() -> void:
	var state := _state()
	assert_eq(state.get_blood_ledger_gold_price(), 40)
	assert_false(state.has_castle_fact("orders_conflict"))
	assert_eq(state.get_castle_fact_source("orders_conflict"), "")
	assert_eq(state.consume_castle_memory_line(), "")


func test_facts_are_unique_and_remember_first_real_source() -> void:
	var state := _state()
	assert_false(state.record_castle_fact("unknown_fact", "echo_crypt"))
	assert_false(state.record_castle_fact("orders_conflict", ""))
	assert_true(state.record_castle_fact("orders_conflict", "echo_crypt"))
	assert_false(state.record_castle_fact("orders_conflict", "court_of_the_mute"))
	assert_eq(state.get_castle_fact_source("orders_conflict"), "echo_crypt")
	assert_eq(state.get_blood_ledger_gold_price(), 35)
	assert_eq(state.consume_castle_memory_line(), MEMORY_TEXT.wizard_line_for_fact("orders_conflict"))
	assert_eq(state.consume_castle_memory_line(), "")


func test_reset_run_clears_evidence_and_unread_wizard_line() -> void:
	var state := _state()
	assert_true(state.record_castle_fact("orders_conflict", "echo_crypt"))
	state.reset_run()
	assert_false(state.has_castle_fact("orders_conflict"))
	assert_eq(state.get_blood_ledger_gold_price(), 40)
	assert_eq(state.consume_castle_memory_line(), "")


func test_court_of_the_mute_win_is_independent_conflict_source() -> void:
	var state := _state()
	state.active_card_id = "court_of_the_mute"
	state.last_battle_won = true
	state.complete_active_card()
	assert_true(state.has_castle_fact("orders_conflict"))
	assert_eq(state.get_castle_fact_source("orders_conflict"), "court_of_the_mute")
	assert_eq(state.get_blood_ledger_gold_price(), 35)
	assert_eq(state.cards_resolved, 1)


func test_court_of_the_mute_defeat_does_not_create_evidence() -> void:
	var state := _state()
	state.active_card_id = "court_of_the_mute"
	state.last_battle_won = false
	state.complete_active_card()
	assert_false(state.has_castle_fact("orders_conflict"))
	assert_eq(state.get_blood_ledger_gold_price(), 40)


func test_role_observations_are_different_and_do_not_spoil_culprit() -> void:
	var knight: String = MEMORY_TEXT.moon_seal_observation("knight")
	var ranger: String = MEMORY_TEXT.moon_seal_observation("ranger")
	var mage: String = MEMORY_TEXT.moon_seal_observation("mage")
	assert_ne(knight, ranger)
	assert_ne(knight, mage)
	assert_ne(ranger, mage)
	for phrase in [knight, ranger, mage]:
		assert_false(phrase.is_empty())
		assert_false(phrase.contains("Канцлер"))
		assert_false(phrase.contains("Надзиратель"))


func test_moon_seal_keep_records_promise_and_original_gold() -> void:
	var event := _event("moon_seal")
	event.call("_resolve_moon_seal", "keep")
	assert_eq(RunState.gold, 10)
	assert_eq(RunState.get_event_outcome("moon_seal"), "kept")
	assert_true(RunState.has_castle_fact("promise_heard"))
	assert_eq(RunState.get_castle_fact_source("promise_heard"), "moon_seal")
	assert_false(RunState.has_castle_fact("orders_conflict"))
	assert_eq(RunState.cards_resolved, 1)


func test_moon_seal_sale_preserves_immediate_gain_without_false_proof() -> void:
	var event := _event("moon_seal")
	event.call("_resolve_moon_seal", "sell")
	assert_eq(RunState.gold, 30)
	assert_eq(RunState.get_event_outcome("moon_seal"), "sold")
	assert_true(RunState.has_castle_fact("promise_heard"))
	assert_false(RunState.has_castle_fact("orders_conflict"))


func test_moon_seal_abandoned_grants_no_fact() -> void:
	var event := _event("moon_seal")
	event.call("_resolve_leave")
	assert_eq(RunState.get_event_outcome("moon_seal"), "left")
	assert_false(RunState.has_castle_fact("promise_heard"))
	assert_false(RunState.has_castle_fact("orders_conflict"))


func test_echo_crypt_listen_without_seal_grants_proof_at_original_cost() -> void:
	var event := _event("echo_crypt")
	event.call("_resolve_echo_crypt", "listen")
	assert_eq(RunState.party_hp_bonus, -15.0)
	assert_eq(RunState.party_damage_bonus, 1.5)
	assert_true(RunState.has_castle_fact("orders_conflict"))
	assert_eq(RunState.get_castle_fact_source("orders_conflict"), "echo_crypt")
	assert_eq(RunState.get_blood_ledger_gold_price(), 35)


func test_echo_crypt_gold_without_seal_has_no_proof() -> void:
	var event := _event("echo_crypt")
	event.call("_resolve_echo_crypt", "gold")
	assert_eq(RunState.gold, 25)
	assert_false(RunState.has_castle_fact("orders_conflict"))


func test_echo_crypt_opened_with_kept_seal_grants_proof() -> void:
	RunState.set_event_outcome("moon_seal", "kept")
	var event := _event("echo_crypt")
	event.call("_resolve_echo_crypt", "relic")
	assert_eq(RunState.party_hp_bonus, 0.0)
	assert_true(RunState.has_castle_fact("orders_conflict"))


func test_echo_crypt_opened_without_seal_does_not_grant_proof() -> void:
	var event := _event("echo_crypt")
	event.call("_resolve_echo_crypt", "relic")
	assert_eq(RunState.party_hp_bonus, -15.0)
	assert_false(RunState.has_castle_fact("orders_conflict"))


func test_ledger_gold_path_applies_conditional_price_with_real_upgrade() -> void:
	RunState.record_castle_fact("orders_conflict", "court_of_the_mute")
	RunState.gold = 35
	var event := _event("blood_ledger")
	var button := event.get_node("Panel/Choices/ChoiceA") as Button
	assert_true(button.text.contains("35"))
	assert_false(button.disabled)
	event.call("_resolve_blood_ledger", "gold")
	assert_eq(RunState.gold, 0)
	assert_eq(RunState.hero_upgrade_ids.size(), 1)
	assert_eq(RunState.get_event_outcome("blood_ledger"), "gold")


func test_ledger_price_and_affordability_match_without_evidence() -> void:
	RunState.gold = 39
	var event := _event("blood_ledger")
	var button := event.get_node("Panel/Choices/ChoiceA") as Button
	assert_true(button.text.contains("40"))
	assert_true(button.disabled)
	event.call("_resolve_blood_ledger", "gold")
	assert_eq(RunState.gold, 39)
	assert_eq(RunState.hero_upgrade_ids.size(), 0)
	assert_false(RunState.has_event_outcome("blood_ledger"))


func test_ledger_rejects_insufficient_gold_even_with_evidence() -> void:
	RunState.record_castle_fact("orders_conflict", "echo_crypt")
	RunState.gold = 34
	var event := _event("blood_ledger")
	var button := event.get_node("Panel/Choices/ChoiceA") as Button
	assert_true(button.disabled)
	event.call("_resolve_blood_ledger", "gold")
	assert_eq(RunState.gold, 34)
	assert_false(RunState.has_event_outcome("blood_ledger"))
