extends GutTest

# Act I flavor coverage: keep original Fate Spread card/offered/discard rules.
const STATE := preload("res://scripts/core/run_state.gd")
const BEATS := [3, 7, 11]

func _state_at_beat(beat: int, rejected: String) -> Node:
	var state := STATE.new() as Node
	add_child_autofree(state)
	state.call("reset_run")
	assert_true(state.call("choose_protagonist", "knight"))
	state.set("cards_resolved", beat)
	var history: Array = state.get("fate_choice_history")
	history.append({"chosen": "bone_patrol", "rejected": rejected})
	return state

func test_first_tier_references_actual_discarded_card() -> void:
	var state := _state_at_beat(3, "candle_seller")
	var line: String = state.call("get_wizard_deal_line")
	var rejected := state.call("get_card", "candle_seller") as RunCardData
	assert_true(line.contains(rejected.title))
	assert_true(line.contains("замке"))
	assert_false(line.contains("bone_patrol"))

func test_second_tier_has_its_own_rejection_line() -> void:
	var state := _state_at_beat(7, "grave_bell")
	var line: String = state.call("get_wizard_deal_line")
	var rejected := state.call("get_card", "grave_bell") as RunCardData
	assert_true(line.contains(rejected.title))
	assert_true(line.contains("отказы"))

func test_third_tier_has_its_own_rejection_line() -> void:
	var state := _state_at_beat(11, "black_altar")
	var line: String = state.call("get_wizard_deal_line")
	var rejected := state.call("get_card", "black_altar") as RunCardData
	assert_true(line.contains(rejected.title))
	assert_true(line.contains("концу"))

func test_other_turns_do_not_force_discard_dialogue() -> void:
	var state := _state_at_beat(5, "candle_seller")
	assert_eq(state.call("get_wizard_deal_line"), "")

func test_held_or_missing_discard_gets_no_invented_card() -> void:
	var state := _state_at_beat(3, "")
	assert_eq(state.call("get_wizard_deal_line"), "")

func test_wizard_mark_danger_keeps_higher_priority() -> void:
	var state := _state_at_beat(7, "grave_bell")
	state.set("wizard_mark_danger_active", true)
	var line: String = state.call("get_wizard_deal_line")
	assert_true(line.contains("печать"))
	assert_false(line.contains("grave_bell"))

func test_boss_seal_is_not_replaced_by_discard_commentary() -> void:
	var state := _state_at_beat(12, "grave_bell")
	assert_eq(state.call("get_wizard_deal_line"), "")

func test_real_three_card_route_records_rejected_id_used_by_wizard() -> void:
	var state := STATE.new() as Node
	add_child_autofree(state)
	state.call("reset_run")
	assert_true(state.call("choose_protagonist", "knight"))
	for slot in range(3):
		var offers: Array = state.call("get_offer_cards")
		if bool(state.call("has_pending_wizard_meddling")):
			state.call("apply_pending_wizard_meddling")
		if bool(state.call("has_pending_wizard_wager")):
			state.call("decline_pending_wizard_wager")
		offers = state.call("get_offer_cards")
		assert_eq(offers.size(), 2)
		if offers.size() != 2:
			return
		assert_true(state.call("choose_card", offers[0].card_id))
		state.call("complete_active_card")
	assert_eq(state.get("cards_resolved"), 3)
	var history: Array = state.get("fate_choice_history")
	assert_eq(history.size(), 3)
	var discarded_id: String = str(history.back().get("rejected", ""))
	assert_false(discarded_id.is_empty())
	state.set("wizard_mark_danger_active", false)
	var rejected := state.call("get_card", discarded_id) as RunCardData
	assert_not_null(rejected)
	if rejected != null:
		assert_true(String(state.call("get_wizard_deal_line")).contains(rejected.title))
