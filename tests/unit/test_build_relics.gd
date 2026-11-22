extends GutTest

const BUILD := preload("res://scripts/ui/run_build_feedback.gd")
const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const UNIT := preload("res://scenes/battle/unit.tscn")

func before_each() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")


func _unit(role: String, team: int, point: Vector2) -> BattleUnit:
	var actor := UNIT.instantiate() as BattleUnit
	actor.configure(load("res://resources/units/%s.tres" % role), team, point)
	if team == 0:
		actor.relic_effects = RunState.get_relic_effects(role)
	add_child_autofree(actor)
	actor.start_combat()
	return actor


func test_catalog_loads_unique_relics_and_retains_effects_in_save() -> void:
	assert_eq(RunState.ARTIFACT_PATHS.size(), 13)
	for id in RunState.ARTIFACT_PATHS:
		var artifact := RunState.get_artifact(id)
		assert_not_null(artifact)
		assert_eq(artifact.artifact_id, id)
	assert_true(RunState.add_artifact("sanguine_whetstone"))
	assert_false(RunState.add_artifact("sanguine_whetstone"))
	var save := SAVE.new()
	var saved := save.snapshot(RunState)
	assert_true(RunState.remove_artifact("sanguine_whetstone"))
	assert_false(RunState.get_relic_effects("knight").has("wounded_damage"))
	assert_true(save.apply_slot(RunState, saved))
	assert_true(RunState.get_relic_effects("knight").has("wounded_damage"))


func test_wounded_strike_and_first_personal_kill_use_real_damage_pipeline() -> void:
	RunState.add_artifact("sanguine_whetstone")
	RunState.add_artifact("harvest_ring")
	var knight := _unit("knight", 0, Vector2(300, 325))
	var target := _unit("bone_archer", 1, Vector2(330, 325))
	knight.hp = 30.0
	knight.target = target
	var before := target.hp
	knight._attack_target()
	assert_almost_eq(before - target.hp, knight.damage * 1.16, 0.01)
	target.take_damage(target.hp, "knight", knight.position, knight)
	assert_almost_eq(knight.hp, 42.0, 0.01)
	var second := _unit("bone_archer", 1, Vector2(335, 325))
	second.take_damage(second.hp, "knight", knight.position, knight)
	assert_almost_eq(knight.hp, 42.0, 0.01)


func test_guard_can_combine_with_knight_cover_and_is_once_per_wave() -> void:
	RunState.recruit_companion("ranger", "QA")
	RunState.add_artifact("mourning_knot")
	RunState.add_artifact("shieldbond")
	var knight := _unit("knight", 0, Vector2(300, 325))
	knight.set_tactical_order("formation")
	var ranger := _unit("ranger", 0, Vector2(330, 325))
	ranger.hp = 25.0
	ranger.take_damage(10.0)
	assert_almost_eq(ranger.hp, 25.0 - 10.0 * 0.65 * 0.88, 0.01)
	var remaining := ranger.hp
	ranger.take_damage(10.0)
	assert_almost_eq(ranger.hp, remaining - 10.0 * 0.88, 0.01)
	knight.set_tactical_order("assault")
	ranger.start_combat()
	remaining = ranger.hp
	ranger.take_damage(10.0)
	assert_almost_eq(ranger.hp, remaining - 10.0 * 0.65, 0.01)


func test_grimoire_reaches_a_secondary_target_only_on_first_spell() -> void:
	RunState.recruit_companion("mage", "QA")
	RunState.add_artifact("ash_grimoire")
	var mage := _unit("mage", 0, Vector2(300, 325))
	var primary := _unit("bone_archer", 1, Vector2(355, 325))
	var distant := _unit("bone_archer", 1, Vector2(365 + mage.splash_radius, 325))
	mage.target = primary
	var before := distant.hp
	mage._attack_target()
	assert_lt(distant.hp, before)
	before = distant.hp
	mage._attack_target()
	assert_almost_eq(distant.hp, before, 0.01)


func test_scar_seal_offered_only_when_its_bonus_applies() -> void:
	var stock := STOPS.open(RunState, 8)
	assert_does_not_have(stock.stock, "relic/scar_seal")
	RunState.rescue_scar_roles.assign(["mage", "ranger"])
	assert_has(STOPS.open(RunState, 8).stock, "relic/scar_seal")
	assert_eq(STOPS.price(RunState, "relic/scar_seal"), 75)
	var before := BUILD.capture(RunState)
	RunState.add_artifact("scar_seal")
	var after := BUILD.capture(RunState)
	assert_almost_eq(after.knight.damage, before.knight.damage * 1.16, 0.01)
	assert_string_contains(BUILD.changes(before, after), "урон")
