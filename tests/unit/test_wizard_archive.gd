extends GutTest

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const STOPS := preload("res://scripts/core/run_camp_stops.gd")

var profile: RefCounted

func _observe(target: RefCounted, key: String) -> void:
	var saved := SAVE.new().snapshot(RunState)
	target.observe_checkpoint(saved.state, key, saved.saved_at)

func before_each() -> void:
	profile = ARCHIVE.new()
	ARCHIVE.shared = profile
	DirAccess.make_dir_recursive_absolute("res://.tmp")
	profile.open_profile("res://.tmp/archive_" + Crypto.new().generate_random_bytes(8).hex_encode() + ".json")
	RunState.reset_run()
	RunState.choose_protagonist("knight")

func after_each() -> void:
	ARCHIVE.shared = null

func test_defeat_keeps_history_and_unlocks_nothing() -> void:
	RunState.run_failed = true
	RunState.cards_resolved = 6
	_observe(profile, "defeat")
	_observe(profile, "defeat")
	assert_eq(profile.history.size(), 1)
	assert_eq(profile.history.defeat.card, 7)
	assert_false(profile.style_unlocked("knight"))
	assert_eq(profile.highest_oath(), 0)
	assert_false(RunState.choose_protagonist("knight", "blood_oath"))
	assert_false(RunState.choose_protagonist("knight", "", 1))

func test_victory_unlocks_only_played_style_and_advances_one_rank() -> void:
	RunState.boss_defeated = true
	_observe(profile, "no-real-result")
	assert_eq(profile.history.size(), 0, "A state without a successful battle result unlocks nothing")
	RunState.last_battle_won = true
	RunState.add_artifact("harvest_ring")
	_observe(profile, "victory")
	assert_true(profile.style_unlocked("knight"))
	assert_false(profile.style_unlocked("ranger"))
	assert_eq(profile.highest_oath(), 1)
	RunState.reset_run()
	assert_false(RunState.choose_protagonist("knight", "blood_oath", 2))
	assert_true(RunState.choose_protagonist("knight", "blood_oath", 1))
	RunState.boss_defeated = true
	RunState.last_battle_won = true
	_observe(profile, "first-oath")
	var restored := ARCHIVE.new()
	restored.open_profile(profile.path)
	assert_eq(restored.highest_oath(), 2)
	assert_eq(restored.history.size(), 2)
	assert_has(restored.relics, "harvest_ring")
	assert_eq(restored.history["first-oath"].style, "blood_oath")

func test_archival_collections_and_backup_recovery_are_independent_of_run_slot() -> void:
	profile.record_enemies(["bone_warden"])
	profile.record_enemies(["bone_archer", "jack"])
	assert_eq(profile.enemies.size(), 2)
	var path: String = profile.path
	var bad := FileAccess.open(path, FileAccess.WRITE)
	bad.store_string("broken")
	bad.close()
	profile.open_profile(path)
	assert_has(profile.enemies, "bone_warden")
	assert_does_not_have(profile.enemies, "bone_archer", "Backup precedes the newest write")
	assert_true(profile.error_message.contains("резервной"))
	profile.record_enemies(["skeleton"])
	var restored := ARCHIVE.new()
	restored.open_profile(path)
	assert_has(restored.enemies, "skeleton")
	assert_true(restored.error_message.is_empty())
	var inactive := ARCHIVE.new()
	inactive.record_enemies(["bone_warden"])
	_observe(inactive, "dev")
	assert_true(inactive.enemies.is_empty())
	assert_true(inactive.history.is_empty())
	assert_true(SAVE.new().prepare_new_game(false))
	assert_has(profile.enemies, "bone_warden")

func test_oaths_change_real_shop_rest_danger_and_debt_values() -> void:
	RunState.oath_rank = 1
	assert_eq(STOPS.price(RunState, "heal"), 32)
	assert_eq(RunState.get_gravedigger_shop_price(), 44)
	assert_almost_eq(STOPS.rest_fraction(RunState), 0.40, 0.01)
	RunState.oath_rank = 2
	RunState.cards_resolved = 4
	RunState.camp_stop = STOPS.open(RunState, 4)
	RunState.record_battle_health("knight", 30.0)
	assert_true(STOPS.apply(RunState, "rest"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 30.0 + RunState.get_hero_max_hp("knight") * 0.30, 0.01)
	RunState.select_encounter("res://resources/encounters/iron_wall.tres")
	var base := RunState.get_enemy_damage_multiplier()
	RunState.oath_rank = 3
	assert_almost_eq(RunState.get_enemy_damage_multiplier(), base * 1.10, 0.01)
	RunState.select_encounter("res://resources/encounters/bone_patrol.tres")
	assert_almost_eq(RunState.get_enemy_damage_multiplier(), base, 0.01)
	RunState.oath_rank = 4
	assert_eq(RunState.get_wizard_tithe_gold_price(), 38)
	assert_true(RunState.begin_last_deal())
	assert_true(RunState.accept_last_deal())
	assert_almost_eq(RunState.last_deal_hp_penalty, 22.0, 0.01)
	RunState.oath_rank = 5
	assert_eq(STOPS.price(RunState, "heal"), 32)
	assert_almost_eq(STOPS.rest_fraction(RunState), 0.30, 0.01)
	assert_almost_eq(RunState.get_last_deal_hp_cost(), 22.0, 0.01)

func test_active_charter_persists_and_schema_two_has_classic_defaults() -> void:
	RunState.starting_style = "blood_oath"
	RunState.oath_rank = 2
	RunState.record_battle_health("knight", 37.25)
	var save := SAVE.new()
	var current := save.snapshot(RunState)
	RunState.reset_run()
	assert_true(save.apply_slot(RunState, current))
	assert_eq(RunState.oath_rank, 2)
	assert_eq(RunState.starting_style, "blood_oath")
	var old := current.duplicate(true)
	old.version = 2
	old.state.erase("starting_style")
	old.state.erase("oath_rank")
	assert_true(save.apply_slot(RunState, old))
	assert_eq(RunState.oath_rank, 0)
	assert_eq(RunState.starting_style, "")
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 37.25, 0.01)

func test_starting_styles_apply_the_authored_class_tradeoffs() -> void:
	for role in RunState.HERO_ROLES:
		RunState.reset_run()
		RunState.choose_protagonist(role)
		RunState.boss_defeated = true
		RunState.last_battle_won = true
		_observe(profile, role)
		var base := RunState.get_effective_hero_stats(role)
		RunState.reset_run()
		assert_true(RunState.choose_protagonist(role, RunState.CHARTER.STYLES[role][0]))
		var alt := RunState.get_effective_hero_stats(role)
		match role:
			"knight": assert_almost_eq(alt.move_speed, base.move_speed * 0.92, 0.01)
			"ranger": assert_almost_eq(alt.attack_range, base.attack_range - 10.0, 0.01)
			"mage":
				assert_almost_eq(alt.splash_radius, base.splash_radius + 18.0, 0.01)
				assert_almost_eq(alt.damage, base.damage * 0.92, 0.01)
