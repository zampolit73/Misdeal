extends GutTest

# Original Bone Warden Resource drives enrage thresholds and multipliers.
const UNIT := preload("res://scenes/battle/unit.tscn")
const WARDEN := preload("res://resources/units/bone_warden.tres")
const KNIGHT := preload("res://resources/units/knight.tres")

var arena: Node2D

func before_each() -> void:
	arena = Node2D.new()
	add_child_autofree(arena)

func _spawn_warden() -> BattleUnit:
	var boss := UNIT.instantiate() as BattleUnit
	boss.configure(WARDEN, 1, Vector2(450, 320))
	arena.add_child(boss)
	boss.set_process(false)
	return boss

func test_bone_warden_stays_calm_above_half_hp() -> void:
	var boss := _spawn_warden()
	assert_true(boss.is_boss)
	assert_eq(boss.max_hp, 700.0)
	boss.take_damage(349.0)
	assert_false(boss.enraged)
	assert_eq(boss.hp, 351.0)
	assert_eq(boss.damage, 24.0)

func test_bone_warden_enrages_exactly_at_half_health() -> void:
	var boss := _spawn_warden()
	boss.take_damage(350.0)
	assert_true(boss.enraged)
	assert_almost_eq(boss.damage, 24.0 * 1.45, 0.001)
	assert_almost_eq(boss.attack_interval, 1.0 * 0.68, 0.001)
	assert_almost_eq(boss.move_speed, 60.0 * 1.3, 0.001)

func test_enrage_multipliers_apply_only_once_across_extra_hits() -> void:
	var boss := _spawn_warden()
	boss.take_damage(350.0)
	var damage_after_first := boss.damage
	var cadence_after_first := boss.attack_interval
	boss.take_damage(50.0)
	assert_true(boss.enraged)
	assert_eq(boss.damage, damage_after_first)
	assert_eq(boss.attack_interval, cadence_after_first)

func test_lethal_blow_does_not_activate_boss_enrage() -> void:
	var boss := _spawn_warden()
	boss.take_damage(1000.0)
	assert_false(boss.alive)
	assert_false(boss.enraged)
	assert_eq(boss.hp, 0.0)

func test_non_boss_with_configured_threshold_never_enrages() -> void:
	var hero := UNIT.instantiate() as BattleUnit
	hero.configure(KNIGHT, 0, Vector2(150, 320))
	arena.add_child(hero)
	hero.set_process(false)
	hero.enrage_threshold = 0.5
	hero.enrage_damage_multiplier = 3.0
	var base_damage := hero.damage
	hero.take_damage(hero.max_hp * 0.7)
	assert_false(hero.enraged)
	assert_eq(hero.damage, base_damage)
