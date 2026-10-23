extends GutTest

# RunState is instantiated independently to avoid mutating the player's run.
const STATE := preload("res://scripts/core/run_state.gd")

func _state() -> Node:
	var state := STATE.new() as Node
	add_child_autofree(state)
	state.call("reset_run")
	assert_true(state.call("choose_protagonist", "knight"))
	return state

func test_solo_party_scales_both_hero_and_enemy_pressure() -> void:
	var state := _state()
	assert_eq(state.call("get_party_size"), 1)
	assert_eq(state.call("get_party_hp_multiplier"), 2.2)
	assert_eq(state.call("get_party_damage_multiplier"), 1.9)
	assert_eq(state.call("get_enemy_hp_multiplier"), 0.82)
	assert_eq(state.call("get_enemy_base_damage_multiplier"), 0.80)

func test_duo_party_uses_intermediate_scaling() -> void:
	var state := _state()
	assert_true(state.call("recruit_companion", "ranger", "GUT test-only companion"))
	assert_eq(state.call("get_party_size"), 2)
	assert_eq(state.call("get_party_hp_multiplier"), 1.2)
	assert_eq(state.call("get_party_damage_multiplier"), 1.15)
	assert_eq(state.call("get_enemy_hp_multiplier"), 0.92)
	assert_eq(state.call("get_enemy_base_damage_multiplier"), 0.90)

func test_trio_uses_authored_encounter_baseline() -> void:
	var state := _state()
	assert_true(state.call("recruit_companion", "ranger", "test"))
	assert_true(state.call("recruit_companion", "mage", "test"))
	assert_eq(state.call("get_party_size"), 3)
	assert_eq(state.call("get_party_hp_multiplier"), 1.0)
	assert_eq(state.call("get_party_damage_multiplier"), 1.0)
	assert_eq(state.call("get_enemy_hp_multiplier"), 1.0)
	assert_eq(state.call("get_enemy_base_damage_multiplier"), 1.0)

func test_protagonist_cannot_be_recruited_twice() -> void:
	var state := _state()
	assert_false(state.call("can_recruit_companion", "knight"))
	assert_false(state.call("recruit_companion", "knight", "impossible"))
	assert_eq(state.call("get_party_size"), 1)

func test_joined_companion_cannot_be_recruited_twice() -> void:
	var state := _state()
	assert_true(state.call("recruit_companion", "mage", "accepted"))
	assert_false(state.call("recruit_companion", "mage", "duplicate"))
	assert_eq(state.call("get_party_size"), 2)
