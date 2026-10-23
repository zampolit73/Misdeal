extends GutTest

# A1P3: production scene/state handoffs, not a simulated combat victory rate.
# Actual combat timing, movement and difficulty still need F5 player evidence.
const TABLE := "res://scenes/table/table.tscn"
const ACT_CHOICE := "res://scenes/event/act_choice.tscn"
const BATTLE := "res://scenes/battle/battle.tscn"
const REWARD := "res://scenes/reward/reward.tscn"
const RUN_END := "res://scenes/run_end/run_end.tscn"


func before_each() -> void:
	seed(51320)
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("ranger"))


func after_each() -> void:
	RunState.reset_run()


func _scene(path: String) -> Control:
	var packed := load(path) as PackedScene
	assert_not_null(packed, "Missing production scene: " + path)
	if packed == null:
		return null
	var instance := packed.instantiate() as Control
	assert_not_null(instance, "Cannot instantiate production scene: " + path)
	if instance == null:
		return null
	add_child_autofree(instance)
	return instance


func _settle_wizard_offer() -> Array[RunCardData]:
	var offers: Array[RunCardData] = RunState.get_offer_cards()
	if RunState.has_pending_wizard_meddling():
		RunState.apply_pending_wizard_meddling()
	if RunState.has_pending_wizard_wager():
		RunState.decline_pending_wizard_wager()
	offers = RunState.get_offer_cards()
	return offers


func _advance_to_first_combat() -> RunCardData:
	# Use real deal/choice resources, but explicitly fast-forward any
	# pre-combat event: no fake claim of a clicked story branch.
	for unused in range(3):
		var offers := _settle_wizard_offer()
		assert_eq(offers.size(), 2)
		if offers.size() != 2:
			return null
		if offers[0].resolution_type == "combat":
			assert_true(RunState.choose_card(offers[0].card_id))
			return offers[0]
		assert_true(RunState.choose_card(offers[0].card_id))
		RunState.complete_active_card()
	return null


func test_real_event_scene_resolves_and_next_table_deals() -> void:
	var offers := _settle_wizard_offer()
	assert_eq(offers.size(), 2)
	if offers.size() != 2:
		return
	var event: RunCardData = null
	for card in offers:
		if card.target_path == ACT_CHOICE:
			event = card
			break
	# Opening always starts with an event; choose a deterministic supported
	# ActChoice event for its actual leave-button resolution path.
	if event == null:
		for attempt in range(12):
			seed(51321 + attempt)
			RunState.reset_run()
			assert_true(RunState.choose_protagonist("ranger"))
			for card in _settle_wizard_offer():
				if card.target_path == ACT_CHOICE:
					event = card
					break
			if event != null:
				break
	assert_not_null(event, "No ActChoice event in 13 deterministic opening deals")
	if event == null:
		return
	assert_true(RunState.choose_card(event.card_id))
	var scene := _scene(event.target_path)
	if scene == null:
		return
	assert_eq((scene.get_node("Panel/Title") as Label).text, event.title)
	scene.call("_resolve_leave")
	assert_eq(RunState.cards_resolved, 1)
	assert_false(RunState.has_active_card())
	assert_false((scene.get_node("Panel/ContinueButton") as Button).disabled)
	var table := _scene(TABLE)
	if table != null:
		assert_eq(RunState.get_offer_cards().size(), 2)
		assert_true((table.get_node("Cards/BonePatrolCard") as Button).visible)


func test_real_battle_victory_opens_major_upgrade_then_loot() -> void:
	var combat := _advance_to_first_combat()
	assert_not_null(combat)
	if combat == null:
		return
	assert_eq(RunState.selected_encounter_path, combat.target_path)
	var battle := _scene(BATTLE)
	if battle == null:
		return
	assert_eq(battle.get("encounter").encounter_id, (load(combat.target_path) as EncounterData).encounter_id)
	assert_false(RunState.last_battle_won)
	# Inject a *result* into the real Battle result handler. This checks
	# reward navigation contract, not whether the autobattler wins.
	battle.call("_finish_battle", true)
	assert_true(RunState.last_battle_won)
	assert_true((battle.get_node("ContinueButton") as Button).visible)
	var reward := _scene(REWARD)
	if reward == null:
		return
	assert_eq(str(reward.get("reward_mode")), "major_upgrade")
	var upgrades: Array[String] = RunState.get_major_upgrade_offer_ids()
	assert_false(upgrades.is_empty())
	if upgrades.is_empty():
		return
	assert_true(RunState.claim_major_upgrade(upgrades[0]))
	reward.call("_setup_card_reward")
	assert_eq(str(reward.get("reward_mode")), "normal_loot")
	var old_gold: int = RunState.gold
	var expected_loot: int = 25 * RunState.get_reward_multiplier()
	RunState.apply_reward("blood_coin")
	assert_eq(RunState.gold, old_gold + expected_loot)
	RunState.complete_active_card()
	assert_eq(RunState.deals_survived, 1)
	assert_false(RunState.has_active_card())
	var table := _scene(TABLE)
	if table != null:
		assert_eq(RunState.get_offer_cards().size(), 2)


func test_boss_xiii_reward_reaches_real_run_end_screen() -> void:
	for slot in range(12):
		var offers := _settle_wizard_offer()
		assert_eq(offers.size(), 2, "Card position %d" % (slot + 1))
		if offers.size() != 2:
			return
		assert_true(RunState.choose_card(offers[slot % 2].card_id))
		# State-level route setup only: A1P2 covers this path exhaustively.
		RunState.complete_active_card()
	assert_eq(RunState.cards_resolved, 12)
	assert_true(RunState.is_boss_due())
	var boss_offer := _settle_wizard_offer()
	assert_eq(boss_offer.size(), 1)
	if boss_offer.size() != 1:
		return
	assert_eq(boss_offer[0].card_id, RunState.BOSS_CARD_ID)
	var table := _scene(TABLE)
	if table == null:
		return
	assert_true(RunState.choose_card(RunState.BOSS_CARD_ID))
	var battle := _scene(BATTLE)
	if battle == null:
		return
	assert_true(bool(battle.call("_is_boss_encounter")))
	battle.call("_finish_battle", true)
	var reward := _scene(REWARD)
	if reward == null:
		return
	assert_eq(str(reward.get("reward_mode")), "normal_loot")
	RunState.apply_reward("blood_coin")
	RunState.complete_active_card()
	assert_true(RunState.boss_defeated)
	assert_true(RunState.is_run_complete())
	assert_eq(RunState.cards_resolved, 12, "Boss is XIII, not a thirteenth pre-boss card")
	var ending := _scene(RUN_END)
	if ending != null:
		assert_eq((ending.get_node("Title") as Label).text, "ЗАБЕГ ЗАВЕРШЁН")


func test_first_battle_defeat_offers_last_deal_then_refusal_ends_run() -> void:
	var combat := _advance_to_first_combat()
	if combat == null:
		return
	var battle := _scene(BATTLE)
	if battle == null:
		return
	battle.call("_finish_battle", false)
	assert_false(RunState.last_battle_won)
	assert_true(RunState.last_deal_pending)
	assert_false(RunState.run_failed)
	RunState.refuse_last_deal("A1P3 отказ от последней сделки")
	assert_true(RunState.run_failed)
	assert_false(RunState.last_deal_pending)
	var ending := _scene(RUN_END)
	if ending != null:
		assert_eq((ending.get_node("Title") as Label).text, "ПАРТИЯ ПРОИГРАНА")
		assert_true((ending.get_node("WizardLine") as Label).text.contains("A1P3"))


func test_chained_prisoner_recruitment_resolves_into_party_and_scar() -> void:
	# Scripted fixture for the real ActChoice UI; this card is not guaranteed
	# to appear in the player's randomized twelve-card run.
	RunState.active_card_id = "chained_prisoner"
	var prisoner := _scene(ACT_CHOICE)
	if prisoner == null:
		return
	assert_true(RunState.can_recruit_companion("knight"))
	prisoner.call("_resolve_chained_prisoner", "recruit")
	assert_eq(RunState.get_party_size(), 2)
	assert_true(RunState.is_role_in_party("knight"))
	assert_true(RunState.has_rescue_scar("knight"))
	assert_false(RunState.has_active_card())
	assert_eq(RunState.cards_resolved, 1)
