extends GutTest

# A1P2 reproduction: a Tier-1 noncombat Fate-Hold must never turn a
# mandatory battle into an optional event. Normal return remains after 2 deals.
const STATE := preload("res://scripts/core/run_state.gd")

func test_noncombat_fate_hold_never_overrides_forced_tier_battle() -> void:
	seed(48123)
	var state := STATE.new() as Node
	add_child_autofree(state)
	state.call("reset_run")
	assert_true(state.call("choose_protagonist", "knight"))
	var forced: Array = state.get("forced_combat_slots")
	forced[1] = 2 # Forced at overall position 6, two picks after position 4.
	state.set("wizard_meddling_slots", [])
	state.set("wizard_wager_slots", [])
	state.set("wizard_mark_slots", [])
	state.set("cards_resolved", 4)

	var initial: Array = state.call("get_offer_cards")
	assert_eq(initial.size(), 2)
	if initial.size() != 2:
		return
	assert_eq((initial[0] as RunCardData).resolution_type, "event")
	assert_eq((initial[1] as RunCardData).resolution_type, "event")
	var held_id: String = (initial[0] as RunCardData).card_id
	assert_true(state.call("hold_offer_card", held_id))
	assert_true(state.call("choose_card", (initial[1] as RunCardData).card_id))
	state.call("complete_active_card")
	assert_eq(int(state.get("cards_resolved")), 5)

	var next: Array = state.call("get_offer_cards")
	assert_eq(next.size(), 2)
	if next.size() != 2:
		return
	assert_true(state.call("choose_card", (next[0] as RunCardData).card_id))
	state.call("complete_active_card")
	assert_eq(int(state.get("cards_resolved")), 6)

	var forced_offer: Array = state.call("get_offer_cards")
	assert_eq(forced_offer.size(), 2)
	if forced_offer.size() != 2:
		return
	assert_eq((forced_offer[0] as RunCardData).resolution_type, "combat",
		"Fate-Held event must not replace mandatory battle")
	assert_eq((forced_offer[1] as RunCardData).resolution_type, "combat",
		"Both real choices must be combat at locked battle slot")
	assert_true(state.call("has_held_card"),
		"Event must remain held until next allowed deal")
	assert_true(state.call("choose_card", (forced_offer[0] as RunCardData).card_id))
	state.call("complete_active_card")

	var returned: Array = state.call("get_offer_cards")
	assert_eq(returned.size(), 2)
	if returned.size() != 2:
		return
	var found := false
	for card in returned:
		if (card as RunCardData).card_id == held_id:
			found = true
	assert_true(found, "Held event returns just after forced combat")
	assert_false(state.call("has_held_card"))
