extends GutTest

# A1P2: exercise the real Fate Spread resource/offer lifecycle in all party sizes.
# Battle/event outcomes are deliberately fast-forwarded: this is NOT a played
# autobattle or subjective full Act-I balance playtest.
const STATE := preload("res://scripts/core/run_state.gd")
const ROLES := ["knight", "ranger", "mage"]
const RUNS_PER_PARTY := 12

func test_36_real_deal_routes_reach_boss_and_run_end() -> void:
	var total_combat := 0
	var total_events := 0
	var total_mixed_offers := 0
	var total_same_kind_neighbors := 0
	var total_forced_slots := 0
	var totals_by_party := [0, 0, 0]
	var sample_by_party := ["", "", ""]
	for party_index in range(3):
		for trial in range(RUNS_PER_PARTY):
			seed(48100 + party_index * 100 + trial)
			var state := STATE.new() as Node
			add_child_autofree(state)
			state.call("reset_run")
			var protagonist: String = ROLES[trial % ROLES.size()]
			assert_true(state.call("choose_protagonist", protagonist))
			for role in ROLES:
				if int(state.call("get_party_size")) >= party_index + 1:
					break
				if role != protagonist:
					assert_true(state.call("recruit_companion", role, "A1P2 setup only"))
			assert_eq(int(state.call("get_party_size")), party_index + 1)

			var last_kind := ""
			var chosen_ids := {}
			var combat := 0
			var events := 0
			for step in range(12):
				var offers: Array = state.call("get_offer_cards")
				if state.call("has_pending_wizard_meddling"):
					state.call("apply_pending_wizard_meddling")
				if state.call("has_pending_wizard_wager"):
					state.call("decline_pending_wizard_wager")
				offers = state.call("get_offer_cards")
				assert_eq(offers.size(), 2)
				if offers.size() != 2:
					return
				var first := offers[0] as RunCardData
				var second := offers[1] as RunCardData
				assert_ne(first.card_id, second.card_id)
				assert_eq(first.tier, int(step / 4))
				assert_eq(second.tier, int(step / 4))
				if first.resolution_type != second.resolution_type:
					total_mixed_offers += 1
				var forced: Array = state.get("forced_combat_slots")
				if step % 4 == int(forced[int(step / 4)]):
					total_forced_slots += 1
					assert_eq(first.resolution_type, "combat")
					assert_eq(second.resolution_type, "combat")
				var chosen := offers[(trial + step) % 2] as RunCardData
				assert_false(chosen_ids.has(chosen.card_id))
				chosen_ids[chosen.card_id] = true
				assert_true(ResourceLoader.exists(chosen.target_path))
				if chosen.resolution_type == "combat":
					assert_true(load(chosen.target_path) is EncounterData)
					combat += 1
					total_combat += 1
				else:
					assert_true(load(chosen.target_path) is PackedScene)
					events += 1
					total_events += 1
				if last_kind == chosen.resolution_type:
					total_same_kind_neighbors += 1
				last_kind = chosen.resolution_type
				assert_true(state.call("choose_card", chosen.card_id))
				assert_eq(str(state.get("active_card_id")), chosen.card_id)
				if chosen.resolution_type == "combat":
					assert_eq(str(state.get("selected_encounter_path")), chosen.target_path)
				# Simulate winning/finishing this selected encounter only; its
				# actual AI, rewards and scene transitions remain separately tested.
				state.call("complete_active_card")
				assert_eq(int(state.get("cards_resolved")), step + 1)
				assert_false(state.call("is_run_complete"))

			assert_true(state.call("is_boss_due"))
			var boss_offers: Array = state.call("get_offer_cards")
			assert_eq(boss_offers.size(), 1)
			if boss_offers.size() != 1:
				return
			var boss := boss_offers[0] as RunCardData
			assert_eq(boss.card_id, "bone_warden")
			assert_true(state.call("choose_card", boss.card_id))
			assert_true(load(boss.target_path) is EncounterData)
			state.call("complete_active_card")
			assert_true(state.call("is_run_complete"))
			assert_true(bool(state.get("boss_defeated")))
			assert_eq(int(state.get("cards_resolved")), 12)
			assert_eq((state.get("fate_choice_history") as Array).size(), 12)
			totals_by_party[party_index] += combat
			if trial == 0:
				sample_by_party[party_index] = "%s: %d combat, %d events" % [
					protagonist, combat, events]
			state.queue_free()

	print("A1P2_AUDIT_PASS: 36/36 real Fate Spread routes, 12+XIII every run")
	print("A1P2_AUDIT_METRICS: combat=%d events=%d mixed_offers=%d adjacent_same_kind=%d forced_windows=%d (out of 432 nonboss choices)" % [
		total_combat, total_events, total_mixed_offers,
		total_same_kind_neighbors, total_forced_slots])
	for party_index in range(3):
		print("A1P2_PARTY_%d: average chosen combats/run %.2f; sample %s" % [
			party_index+1, float(totals_by_party[party_index]) / RUNS_PER_PARTY,
			sample_by_party[party_index]])
	assert_eq(total_forced_slots, 108)
	assert_gt(total_mixed_offers, 0)
	assert_gt(total_combat, 108)
	assert_gt(total_events, 0)
