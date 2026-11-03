extends GutTest

# D382: data-driven waves only for Iron Wall, one card/reward/Last Deal.
# Exercise the actual Battle scene and live unit death signals, not fake results.
const IRON_WALL: EncounterData = preload("res://resources/encounters/iron_wall.tres")
const NORMAL: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")
const BATTLE := preload("res://scenes/battle/battle.tscn")


func after_each() -> void:
	RunState.reset_run()


func _boot(party_count: int = 1) -> Control:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("knight"))
	for index in range(1, party_count):
		var role: String = RunState.HERO_ROLES[index]
		assert_true(RunState.recruit_companion(role, "D382 GUT"))
	RunState.active_card_id = "iron_wall"
	RunState.select_encounter("res://resources/encounters/iron_wall.tres")
	RunState.combat_formation_by_card["iron_wall"] = 0
	var battle := BATTLE.instantiate() as Control
	add_child_autofree(battle)
	return battle


func _units_by_team(battle: Control, team_id: int, only_alive: bool = true) -> Array[BattleUnit]:
	var result: Array[BattleUnit] = []
	var actors: Array = battle.get("units")
	for candidate in actors:
		var actor := candidate as BattleUnit
		if actor != null and actor.team == team_id and (actor.alive or not only_alive):
			result.append(actor)
	return result


func _end_first_wave(battle: Control) -> void:
	battle.set("combat_started", true)
	battle.set("combat_live", true)
	var first_wave := _units_by_team(battle, 1)
	for enemy in first_wave:
		enemy.take_damage(enemy.max_hp + 10000.0)


func test_only_iron_wall_has_an_authored_second_wave() -> void:
	assert_true(IRON_WALL.has_second_wave())
	assert_false(NORMAL.has_second_wave())
	assert_eq(IRON_WALL.enemy_unit_paths.size(), 2)
	assert_eq(IRON_WALL.second_wave_unit_paths.size(), 2)
	assert_eq(IRON_WALL.get_formation_count(), 2)
	var expected := ["bone_archer", "skeleton"]
	for index in range(2):
		var data := load(IRON_WALL.second_wave_unit_paths[index]) as UnitData
		assert_not_null(data)
		if data != null:
			assert_eq(data.visual_role, expected[index])
		assert_true(IRON_WALL.second_wave_positions[index].x >= 700.0)
	assert_ne(IRON_WALL.second_wave_positions[0].y, IRON_WALL.second_wave_positions[1].y)


func test_first_wave_death_triggers_intermission_not_victory() -> void:
	var battle := _boot()
	var knight := _units_by_team(battle, 0)[0]
	var prior_hp: float = knight.hp
	_end_first_wave(battle)
	assert_true(battle.get("wave_intermission"))
	assert_eq(battle.get("battle_wave_index"), 1)
	assert_false(battle.get("combat_live"))
	assert_false(battle.get("battle_finished"))
	assert_false(RunState.last_battle_won)
	assert_eq(knight.hp, prior_hp, "No free HP recovery or reset between waves")
	assert_false(knight.combat_started)
	assert_true(knight.placement_enabled, "Drag survivors after clearing wave I")
	assert_eq(_units_by_team(battle, 1).size(), 0)
	assert_eq(battle.get_node("FightButton").text, "ВОЛНА II")
	assert_false(battle.get_node("ResultOverlay/ResultScrim").visible)
	assert_false(battle.get_node("SacrificeOrderButton").visible)
	assert_false(battle.get_node("DefianceOrderButton").visible)


func test_basic_tactic_can_change_between_waves() -> void:
	var battle := _boot(3)
	_end_first_wave(battle)
	battle.call("_select_tactical_order", "hunt")
	assert_eq(battle.get("tactical_order"), "hunt")
	assert_eq(_units_by_team(battle, 0).size(), 3)
	for hero in _units_by_team(battle, 0):
		assert_eq(hero.tactical_order, "hunt")
		assert_true(hero.placement_enabled)


func test_second_wave_spawns_and_waits_for_actual_final_victory() -> void:
	var battle := _boot(2)
	_end_first_wave(battle)
	var party := _units_by_team(battle, 0)
	var health_before: Array[float] = []
	for hero in party:
		health_before.append(hero.hp)
	await battle._start_second_wave()
	assert_eq(battle.get("battle_wave_index"), 2)
	assert_false(battle.get("wave_intermission"))
	assert_true(battle.get("combat_live"))
	assert_false(battle.get("battle_finished"))
	var foes := _units_by_team(battle, 1)
	assert_eq(foes.size(), 2)
	assert_eq(foes[0].visual_role, "bone_archer")
	assert_eq(foes[1].visual_role, "skeleton")
	for index in range(party.size()):
		assert_lte(party[index].hp, health_before[index], "Wave II cannot heal heroes")
	for enemy in foes:
		enemy.take_damage(enemy.max_hp + 10000.0)
	assert_true(battle.get("battle_finished"), "Only defeating wave II produces Victory")
	assert_true(RunState.last_battle_won)
	assert_eq(battle.get_node("ResultOverlay/Result").text, "ПОБЕДА")


func test_second_wave_cannot_be_started_outside_intermission() -> void:
	var battle := _boot()
	await battle._start_second_wave()
	assert_eq(battle.get("battle_wave_index"), 1)
	assert_false(battle.get("combat_started"))
	assert_eq(_units_by_team(battle, 1).size(), 2)
