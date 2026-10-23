extends GutTest

# Real BattleUnit targeting in an isolated arena: no substitute AI or mocks.
const UNIT := preload("res://scenes/battle/unit.tscn")
const KNIGHT := preload("res://resources/units/knight.tres")

var arena: Node2D

func before_each() -> void:
	arena = Node2D.new()
	add_child_autofree(arena)

func _spawn(team_id: int, location: Vector2) -> BattleUnit:
	var unit := UNIT.instantiate() as BattleUnit
	unit.configure(KNIGHT, team_id, location)
	arena.add_child(unit)
	unit.set_process(false)
	return unit

func test_assault_targets_nearest_living_enemy_not_distant_support() -> void:
	var hero := _spawn(0, Vector2.ZERO)
	var front := _spawn(1, Vector2(65, 0))
	var healer := _spawn(1, Vector2(290, 0))
	healer.support_heal_interval = 2.0
	hero.set_tactical_order("assault")
	assert_same(hero.get_preview_target(), front)

func test_hunt_ranged_unit_prioritizes_support_over_nearest_melee() -> void:
	var ranger := _spawn(0, Vector2.ZERO)
	ranger.attack_range = 190.0
	var frontline := _spawn(1, Vector2(55, 0))
	var support := _spawn(1, Vector2(240, 0))
	support.support_heal_interval = 2.0
	ranger.set_tactical_order("hunt")
	assert_same(ranger.get_preview_target(), support)
	assert_not_same(ranger.get_preview_target(), frontline)

func test_hunt_melee_intercepts_near_frontline_threat() -> void:
	var knight := _spawn(0, Vector2.ZERO)
	var frontline := _spawn(1, Vector2(75, 0))
	var distant_support := _spawn(1, Vector2(320, 0))
	distant_support.support_heal_interval = 1.4
	knight.set_tactical_order("hunt")
	assert_same(knight.get_preview_target(), frontline)

func test_hunt_prefers_wounded_healer_over_healthy_healer() -> void:
	var ranger := _spawn(0, Vector2.ZERO)
	ranger.attack_range = 170.0
	var healthy := _spawn(1, Vector2(100, 0))
	var wounded := _spawn(1, Vector2(260, 0))
	healthy.support_heal_interval = 2.0
	wounded.support_heal_interval = 2.0
	wounded.hp = wounded.max_hp * 0.25
	ranger.set_tactical_order("hunt")
	assert_same(ranger.get_preview_target(), wounded)

func test_formation_targets_threat_nearest_weakest_ally() -> void:
	var defender := _spawn(0, Vector2.ZERO)
	var ally := _spawn(0, Vector2(340, 0))
	ally.hp = 20.0
	var close_to_defender := _spawn(1, Vector2(80, 0))
	var threat_to_ally := _spawn(1, Vector2(355, 0))
	defender.set_tactical_order("formation")
	assert_same(defender.get_preview_target(), threat_to_ally)
	assert_not_same(defender.get_preview_target(), close_to_defender)

func test_dead_targets_are_excluded_and_no_target_if_none_alive() -> void:
	var hero := _spawn(0, Vector2.ZERO)
	var enemy := _spawn(1, Vector2(90, 0))
	assert_same(hero.get_preview_target(), enemy)
	enemy.take_attrition_damage(enemy.max_hp + 1.0)
	assert_false(enemy.alive)
	assert_null(hero.get_preview_target())
