extends GutTest

const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")

var service: RefCounted

func before_each() -> void:
	service = SAVE.new()
	SAVE.shared = service
	MEMORY.shared = MEMORY.new()
	RunState.reset_run()
	RunState.choose_protagonist("knight")

func after_each() -> void:
	SAVE.shared = null
	MEMORY.shared = null

func test_wounds_survive_max_hp_changes_without_free_refill() -> void:
	var old_max: float = float(RunState.get_effective_hero_stats("knight").hp)
	RunState.store_hero_current_hp("knight", old_max * 0.35, old_max)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), old_max * 0.35, 0.01)
	RunState.party_hp_bonus += 10.0
	var new_max: float = float(RunState.get_effective_hero_stats("knight").hp)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), old_max * 0.35 + (new_max - old_max), 0.01)
	RunState.party_hp_bonus -= 1000.0
	assert_lte(RunState.get_hero_current_hp("knight"), float(RunState.get_effective_hero_stats("knight").hp))

func test_new_companion_starts_healthy_while_knight_remains_wounded() -> void:
	var max_hp: float = float(RunState.get_effective_hero_stats("knight").hp)
	RunState.store_hero_current_hp("knight", max_hp * 0.25, max_hp)
	assert_true(RunState.recruit_companion("ranger", "test"))
	assert_almost_eq(RunState.get_hero_current_hp("ranger"), float(RunState.get_effective_hero_stats("ranger").hp), 0.01)
	assert_lt(RunState.get_hero_current_hp("knight"), float(RunState.get_effective_hero_stats("knight").hp))

func test_camp_heals_once_and_does_not_advance_fate() -> void:
	var mx: float = float(RunState.get_effective_hero_stats("knight").hp)
	RunState.store_hero_current_hp("knight", mx * 0.2, mx)
	RunState.cards_resolved = 4
	assert_eq(RunState.get_gameplay_stop_kind(), "camp")
	assert_true(RunState.resolve_camp("rest"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), mx * 0.6, 0.01)
	assert_eq(RunState.cards_resolved, 4)
	assert_eq(RunState.get_gameplay_stop_kind(), "")
	assert_false(RunState.resolve_camp("rest"))

func test_training_uses_existing_extra_upgrade_cap() -> void:
	RunState.cards_resolved = 4
	var upgrade_id: String = RunState.get_camp_upgrade_id()
	assert_false(upgrade_id.is_empty())
	assert_true(RunState.resolve_camp("train"))
	assert_has(RunState.extra_hero_upgrade_ids, upgrade_id)
	assert_eq(RunState.cards_resolved, 4)
	assert_false(RunState.resolve_camp("train"))

func test_shop_multi_purchase_single_slots_and_no_extra_card() -> void:
	RunState.cards_resolved = 8
	RunState.camp_last_completed = 8
	RunState.gold = 100
	assert_eq(RunState.get_gameplay_stop_kind(), "shop")
	var relic: String = RunState.get_shop_artifact_id()
	assert_false(relic.is_empty())
	assert_true(RunState.buy_shop_item("artifact"))
	assert_true(RunState.has_artifact(relic))
	assert_eq(RunState.gold, 60)
	assert_false(RunState.buy_shop_item("artifact"))
	assert_true(RunState.buy_shop_item("upgrade"))
	assert_eq(RunState.gold, 25)
	var mx: float = float(RunState.get_effective_hero_stats("knight").hp)
	RunState.store_hero_current_hp("knight", mx * 0.25, mx)
	assert_true(RunState.buy_shop_item("heal"))
	assert_eq(RunState.gold, 5)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), mx * 0.55, 0.01)
	assert_true(RunState.leave_shop())
	assert_eq(RunState.get_gameplay_stop_kind(), "")
	assert_eq(RunState.cards_resolved, 8)
	assert_false(RunState.leave_shop())

func test_save_migrates_exact_legacy_shape_but_not_partial_damage() -> void:
	var data: Dictionary = service.snapshot(RunState)
	for key in SAVE.LEGACY_CORE_FIELDS:
		data.state.erase(key)
	assert_true(service.validate(data, RunState))
	RunState.camp_last_completed = 8
	RunState.shop_last_completed = 8
	RunState.shop_purchases["artifact"] = true
	RunState.hero_health_by_role["knight"] = {"current":1.0,"max":100.0}
	assert_true(service.apply_slot(RunState, data))
	assert_eq(RunState.camp_last_completed, 0)
	assert_eq(RunState.shop_last_completed, 0)
	assert_true(RunState.hero_health_by_role.is_empty())
	assert_true(RunState.shop_purchases.is_empty())
	var corrupted: Dictionary = service.snapshot(RunState)
	corrupted.state.erase("hero_health_by_role")
	assert_false(service.validate(corrupted, RunState))

func test_resume_of_purchased_item_preserves_once_only_flag() -> void:
	RunState.cards_resolved = 8
	RunState.camp_last_completed = 8
	RunState.gold = 100
	assert_true(RunState.buy_shop_item("artifact"))
	var saved: Dictionary = service.snapshot(RunState)
	assert_true(service.validate(saved, RunState))
	RunState.reset_run()
	assert_true(service.apply_slot(RunState, saved))
	assert_false(RunState.buy_shop_item("artifact"))
	assert_true(RunState.shop_purchases.has("artifact"))
	assert_eq(RunState.get_gameplay_stop_kind(), "shop")
