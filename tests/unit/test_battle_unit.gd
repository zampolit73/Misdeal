extends GutTest

# Real BattleUnit scene + shipped Knight Resource. No mock damage formulas.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const KNIGHT: UnitData = preload("res://resources/units/knight.tres")

func _knight() -> BattleUnit:
	# Unit effects (damage text/sparks) are created as siblings of the actor.
	# Own the complete battle-test subtree, not just the original Unit node.
	var arena := Node2D.new()
	add_child_autofree(arena)
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(KNIGHT, 0, Vector2(260, 350))
	arena.add_child(unit)
	unit.set_process(false)
	unit.set_process_input(false)
	return unit

func test_shipped_knight_stats_are_loaded_from_resource() -> void:
	var unit := _knight()
	assert_eq(unit.max_hp, 150.0)
	assert_eq(unit.hp, 150.0)
	assert_eq(unit.damage, 18.0)
	assert_eq(unit.attack_interval, 0.9)

func test_tactical_orders_accept_valid_and_reject_unknown() -> void:
	var unit := _knight()
	for order_id in ["assault", "hunt", "formation", "sacrifice", "defiance"]:
		unit.set_tactical_order(order_id)
		assert_eq(unit.tactical_order, order_id)
	unit.set_tactical_order("unknown_future_order")
	assert_eq(unit.tactical_order, "assault")

func test_damage_respects_incoming_damage_multiplier() -> void:
	var unit := _knight()
	unit.damage_taken_multiplier = 0.8
	unit.take_damage(25.0)
	assert_eq(unit.hp, 130.0)
	assert_true(unit.alive)

func test_heal_caps_at_maximum_health() -> void:
	var unit := _knight()
	unit.take_damage(40.0)
	unit.heal(100.0)
	assert_eq(unit.hp, unit.max_hp)

func test_negative_or_zero_heal_does_not_restore_health() -> void:
	var unit := _knight()
	unit.take_damage(35.0)
	unit.heal(-25.0)
	unit.heal(0.0)
	assert_eq(unit.hp, 115.0)

func test_lethal_damage_clamps_hp_and_ends_unit_life() -> void:
	var unit := _knight()
	unit.take_damage(1000.0)
	assert_eq(unit.hp, 0.0)
	assert_false(unit.alive)
	assert_false(unit.combat_started)

func test_dead_unit_cannot_receive_healing() -> void:
	var unit := _knight()
	unit.take_damage(1000.0)
	unit.heal(1000.0)
	assert_eq(unit.hp, 0.0)
	assert_false(unit.alive)

func test_start_combat_transitions_from_preparation() -> void:
	var unit := _knight()
	assert_false(unit.combat_started)
	unit.start_combat()
	assert_true(unit.combat_started)
	assert_false(unit.placement_enabled)
