extends GutTest

# Real LastRiteController from Funeral Procession; encounter-scoped revival.
const UNIT := preload("res://scenes/battle/unit.tscn")
const RITE := preload("res://scripts/battle/last_rite.gd")
const DATA := preload("res://resources/encounters/last_rite.tres")
const PRIEST := preload("res://resources/units/funeral_priest.tres")
const BEARER := preload("res://resources/units/pallbearer.tres")
const KNIGHT := preload("res://resources/units/knight.tres")

var arena: Node2D

func before_each() -> void:
	arena = Node2D.new()
	add_child_autofree(arena)

func _spawn(resource: UnitData, team_id: int, location: Vector2) -> BattleUnit:
	var unit := UNIT.instantiate() as BattleUnit
	unit.configure(resource, team_id, location)
	arena.add_child(unit)
	unit.set_process(false)
	return unit

func _controller(priest: BattleUnit, bearers: Array[BattleUnit]) -> LastRiteController:
	var controller := RITE.new() as LastRiteController
	arena.add_child(controller)
	controller.configure(priest, bearers, DATA)
	controller.set_process(false)
	return controller

func _advance_to_resolution(controller: LastRiteController) -> void:
	controller.advance_battle(DATA.initial_delay + 0.01)
	controller.advance_battle(DATA.telegraph_seconds + 0.01)

func test_last_rite_rejects_living_bearer_or_wrong_identity() -> void:
	var bearer := _spawn(BEARER, 1, Vector2(400, 320))
	assert_false(bearer.revive_from_last_rite(0.5))
	var knight := _spawn(KNIGHT, 0, Vector2(210, 320))
	knight.take_attrition_damage(knight.max_hp + 1.0)
	assert_false(knight.revive_from_last_rite(0.5))

func test_dead_pallbearer_revives_with_authored_health_fraction() -> void:
	var bearer := _spawn(BEARER, 1, Vector2(400, 320))
	bearer.take_attrition_damage(bearer.max_hp + 1.0)
	assert_false(bearer.alive)
	assert_true(bearer.revive_from_last_rite(0.4))
	assert_true(bearer.alive)
	assert_true(bearer.combat_started)
	assert_almost_eq(bearer.hp, bearer.max_hp * 0.4, 0.01)
	assert_eq(bearer.frame_state, "idle")

func test_revival_fraction_is_clamped_to_supported_range() -> void:
	var low := _spawn(BEARER, 1, Vector2(380, 320))
	low.take_attrition_damage(low.max_hp + 1.0)
	assert_true(low.revive_from_last_rite(-1.0))
	assert_almost_eq(low.hp, low.max_hp * 0.10, 0.01)
	var high := _spawn(BEARER, 1, Vector2(450, 320))
	high.take_attrition_damage(high.max_hp + 1.0)
	assert_true(high.revive_from_last_rite(10.0))
	assert_eq(high.hp, high.max_hp)

func test_controller_spends_only_one_revival_per_encounter() -> void:
	var priest := _spawn(PRIEST, 1, Vector2(510, 310))
	var first := _spawn(BEARER, 1, Vector2(435, 300))
	var second := _spawn(BEARER, 1, Vector2(455, 340))
	var controller := _controller(priest, [first, second])
	first.take_attrition_damage(first.max_hp + 1.0)
	second.take_attrition_damage(second.max_hp + 1.0)
	controller.start_rite()
	_advance_to_resolution(controller)
	assert_true(first.alive)
	assert_false(second.alive)
	assert_true(controller.revival_spent)
	assert_eq(controller.revive_count, 1)
	_advance_to_resolution(controller)
	assert_eq(controller.revive_count, 1)
	assert_false(second.alive)

func test_priest_death_cancels_pending_last_rite() -> void:
	var priest := _spawn(PRIEST, 1, Vector2(510, 310))
	var bearer1 := _spawn(BEARER, 1, Vector2(435, 300))
	var bearer2 := _spawn(BEARER, 1, Vector2(455, 340))
	var controller := _controller(priest, [bearer1, bearer2])
	bearer1.take_attrition_damage(bearer1.max_hp + 1.0)
	controller.start_rite()
	controller.advance_battle(DATA.initial_delay + 0.01)
	assert_eq(controller.phase, controller.TELEGRAPH)
	priest.take_attrition_damage(priest.max_hp + 1.0)
	assert_eq(controller.phase, controller.IDLE)
	assert_eq(controller.cancelled_count, 1)
	controller.advance_battle(DATA.telegraph_seconds + 1.0)
	assert_false(bearer1.alive)
	assert_eq(controller.revive_count, 0)
