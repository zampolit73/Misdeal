extends GutTest

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")

func before_each() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")


func _resolve_at(slot: int) -> void:
	RunState.cards_resolved = slot - 1
	RunState.active_card_id = "moon_seal"
	RunState.complete_active_card()


func test_new_companion_enters_healthy_and_party_changes_preserve_wounds() -> void:
	RunState.record_battle_health("knight", 46.5)
	assert_true(RunState.lose_companion("mage", "Test"))
	assert_false(RunState.recruit_companion("mage", "Test"))
	assert_true(RunState.recruit_companion("ranger", "Test"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 46.5, 0.01)
	assert_almost_eq(RunState.get_hero_current_hp("ranger"), RunState.get_hero_max_hp("ranger"), 0.01)


func test_downed_hero_recovers_one_fifth_and_max_hp_increase_cannot_heal() -> void:
	RunState.recruit_companion("ranger", "Test")
	RunState.recruit_companion("mage", "Test")
	RunState.record_battle_health("knight", 0.0)
	var recovered := RunState.get_hero_max_hp("knight") * 0.20
	assert_almost_eq(RunState.get_hero_current_hp("knight"), recovered, 0.01)
	RunState.party_hp_bonus += 50.0
	assert_almost_eq(RunState.get_hero_current_hp("knight"), recovered, 0.01)
	RunState.party_hp_bonus -= 100.0
	RunState.clamp_party_health()
	assert_lte(RunState.get_hero_current_hp("knight"), RunState.get_hero_max_hp("knight"))


func test_rest_applies_once_and_does_not_resolve_a_fate_card() -> void:
	RunState.record_battle_health("knight", 64.0)
	_resolve_at(4)
	assert_eq(RunState.camp_stop.slot, 4)
	assert_true(STOPS.apply(RunState, "rest"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 64.0 + RunState.get_hero_max_hp("knight") * 0.40, 0.01)
	assert_false(STOPS.apply(RunState, "rest"))
	assert_eq(RunState.cards_resolved, 4)


func test_last_rest_unlocks_xiii_without_spending_another_card() -> void:
	_resolve_at(12)
	assert_eq(RunState.camp_stop.slot, 12)
	assert_true(STOPS.apply(RunState, "upgrade/knight"))
	assert_eq(RunState.hero_upgrade_ids.size(), 1)
	assert_eq(RunState.cards_resolved, 12)
	assert_eq(RunState.get_offer_cards()[0].card_id, RunState.BOSS_CARD_ID)


func test_dark_rite_uses_displayed_blood_price_and_revokes_action() -> void:
	_resolve_at(4)
	var entry := RunState.get_hero_current_hp("knight")
	var cost := STOPS.rite_cost(RunState)
	assert_true(STOPS.apply(RunState, "rite"))
	assert_eq(RunState.artifact_ids.size(), 1)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), entry - cost, 0.01)
	assert_false(STOPS.apply(RunState, "rite"))


func test_shop_retains_inventory_and_purchases_across_load() -> void:
	RunState.recruit_companion("ranger", "Test")
	RunState.gold = 90
	RunState.record_battle_health("knight", 55.0)
	_resolve_at(8)
	var stock: Array = RunState.camp_stop.stock.duplicate()
	assert_true(STOPS.apply(RunState, "heal"))
	var service := SAVE.new()
	var saved := service.snapshot(RunState)
	RunState.reset_run()
	assert_true(service.apply_slot(RunState, saved))
	assert_eq(RunState.camp_stop.stock, stock)
	assert_eq(RunState.gold, 65)
	assert_false(STOPS.apply(RunState, "heal"))
	assert_true(STOPS.apply(RunState, stock[0]))
	assert_eq(RunState.gold, 15)
	assert_false(STOPS.apply(RunState, stock[1]))
	assert_true(STOPS.apply(RunState, "leave"))
	assert_true(RunState.camp_stop.is_empty())
