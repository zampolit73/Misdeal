extends GutTest

# D383 — test the actual production Battle and Godot authored EncounterData,
# not a scripted preview. One card/reward; Firing Square uniquely uses crossfire.
const FIRING_SQUARE: EncounterData = preload("res://resources/encounters/firing_square.tres")
const IRON_WALL: EncounterData = preload("res://resources/encounters/iron_wall.tres")
const NORMAL: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")
const BATTLE := preload("res://scenes/battle/battle.tscn")


func after_each() -> void:
	RunState.reset_run()


func _boot(party_size: int = 1, formation: int = 0) -> Control:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("knight"))
	for index in range(1, party_size):
		var role: String = RunState.HERO_ROLES[index]
		assert_true(RunState.recruit_companion(role, "D383 crossfire test"))
	RunState.active_card_id = "firing_square"
	RunState.select_encounter("res://resources/encounters/firing_square.tres")
	RunState.combat_formation_by_card["firing_square"] = formation
	var battle := BATTLE.instantiate() as Control
	add_child_autofree(battle)
	return battle


func _units_by_team(battle: Control, team: int) -> Array[BattleUnit]:
	var result: Array[BattleUnit] = []
	var actors: Array = battle.get("units")
	for candidate in actors:
		var unit := candidate as BattleUnit
		if unit != null and unit.alive and unit.team == team:
			result.append(unit)
	return result


func _clear_wave_one(battle: Control) -> void:
	battle.set("combat_started", true)
	battle.set("combat_live", true)
	for foe in _units_by_team(battle, 1):
		foe.take_damage(foe.max_hp + 10000.0)


func test_only_two_opt_in_waves_and_five_total_original_enemies() -> void:
	assert_true(FIRING_SQUARE.has_second_wave())
	assert_true(IRON_WALL.has_second_wave(), "D382 Iron Wall stays approved")
	assert_false(NORMAL.has_second_wave(), "Normal fights stay fast single-wave")
	assert_eq(FIRING_SQUARE.enemy_unit_paths.size(), 3)
	assert_eq(FIRING_SQUARE.second_wave_unit_paths.size(), 2)
	assert_eq(FIRING_SQUARE.enemy_unit_paths.size() + FIRING_SQUARE.second_wave_unit_paths.size(), 5)
	assert_eq(FIRING_SQUARE.get_formation_count(), 2)
	assert_eq(FIRING_SQUARE.get_enemy_positions_for_formation(1).size(), 3)
	var roles: Array[String] = []
	for path in FIRING_SQUARE.enemy_unit_paths:
		var data := load(path) as UnitData
		assert_not_null(data)
		if data != null:
			roles.append(data.visual_role)
	for path in FIRING_SQUARE.second_wave_unit_paths:
		var data := load(path) as UnitData
		assert_not_null(data)
		if data != null:
			roles.append(data.visual_role)
	assert_eq(roles.count("crypt_guard"), 1)
	assert_eq(roles.count("bone_archer"), 4)


func test_firing_square_telegraph_is_honest_and_not_iron_wall_dialogue() -> void:
	assert_true(FIRING_SQUARE.second_wave_hint.contains("СЛЕВА"))
	assert_true(FIRING_SQUARE.second_wave_hint.contains("СПРАВА"))
	assert_true(FIRING_SQUARE.wave_intermission_status.contains("слева и справа"))
	assert_true(FIRING_SQUARE.wave_two_status.contains("перекрёстный"))
	assert_false(FIRING_SQUARE.wave_two_status.contains("пехота"))
	assert_true(IRON_WALL.wave_two_status.contains("пехота"))
	var battle := _boot(1)
	assert_eq(battle.get_node("EnemyLabel").text, "ВОЛНА I / II")
	assert_eq(battle.get_node("Status").text, FIRING_SQUARE.wave_one_status)


func test_solo_wave_clear_has_a_fair_announced_break_and_no_heal() -> void:
	var battle := _boot(1)
	var knight := _units_by_team(battle, 0)[0]
	knight.take_damage(12.0)
	var injured_hp: float = knight.hp
	_clear_wave_one(battle)
	assert_true(battle.get("wave_intermission"))
	assert_false(battle.get("combat_live"))
	assert_false(battle.get("battle_finished"))
	assert_eq(knight.hp, injured_hp, "No free heal in the crossfire break")
	assert_true(knight.placement_enabled)
	assert_eq(_units_by_team(battle, 1).size(), 0)
	assert_eq(battle.get_node("PlacementHint").text, FIRING_SQUARE.second_wave_hint,
		"Both attack directions must be announced before Wave II")
	assert_eq(battle.get_node("Status").text, FIRING_SQUARE.wave_intermission_status)
	assert_eq(battle.get_node("FightButton").text, "ВОЛНА II")
	assert_false(battle.get_node("ResultOverlay/ResultScrim").visible)
	assert_false(RunState.last_battle_won)


func test_trio_repositions_and_switches_order_for_two_sided_attack() -> void:
	var battle := _boot(3, 1)
	assert_eq(_units_by_team(battle, 0).size(), 3)
	assert_eq(_units_by_team(battle, 1).size(), 3)
	assert_eq(battle.get("enemy_formation_variant"), 1)
	_clear_wave_one(battle)
	battle.call("_select_tactical_order", "formation")
	assert_eq(battle.get("tactical_order"), "formation")
	for hero in _units_by_team(battle, 0):
		assert_true(hero.placement_enabled)
		assert_eq(hero.tactical_order, "formation")
		assert_eq(hero.placement_regions.size(), 1)
		assert_eq(hero.placement_regions[0], Rect2(Vector2(145.0, 305.0), Vector2(385.0, 122.0)))
	assert_false(battle.get_node("SacrificeOrderButton").visible)
	assert_false(battle.get_node("DefianceOrderButton").visible)


func test_duo_real_wave_two_has_left_and_right_archers_on_real_floor() -> void:
	var battle := _boot(2)
	_clear_wave_one(battle)
	var heroes := _units_by_team(battle, 0)
	var hp_first: float = heroes[0].hp
	await battle._start_second_wave()
	assert_true(battle.get("combat_live"))
	assert_false(battle.get("wave_intermission"))
	assert_eq(battle.get("battle_wave_index"), 2)
	assert_false(battle.get("battle_finished"))
	assert_eq(heroes[0].hp, hp_first)
	assert_eq(battle.get_node("Status").text, FIRING_SQUARE.wave_two_status)
	var archers := _units_by_team(battle, 1)
	assert_eq(archers.size(), 2)
	if archers.size() != 2:
		return
	var left := archers[0]
	var right := archers[1]
	assert_eq(left.visual_role, "bone_archer")
	assert_eq(right.visual_role, "bone_archer")
	assert_lt(left.position.x, 145.0, "Left Archer actually appears BEHIND deployment zone")
	assert_gt(right.position.x, 530.0, "Right Archer remains far across the floor")
	assert_gt(right.position.x - left.position.x, 850.0)
	var floor_rect: Rect2 = battle.call("_get_combat_bounds")
	for archer in archers:
		assert_true(floor_rect.has_point(archer.position),
			"Both archers stand on authored walkable stone, never on the backdrop")
		archer.target = heroes[0]
		archer.combat_started = true
		archer._update_unit_facing()
	assert_false(left.art_sprite.flip_h, "Left Archer looks RIGHT toward heroes")
	assert_true(right.art_sprite.flip_h, "Right Archer looks LEFT toward heroes")
	for archer in archers:
		archer.take_damage(archer.max_hp + 10000.0)
	assert_true(battle.get("battle_finished"), "Only Wave II can finish the battle")
	assert_true(RunState.last_battle_won)
	assert_eq(battle.get_node("ResultOverlay/Result").text, "ПОБЕДА")
	assert_eq(RunState.cards_resolved, 0,
		"One run card must not silently advance when multiple waves end")


func test_wave_two_cannot_be_skipped_before_first_wave_victory() -> void:
	var battle := _boot(1)
	await battle._start_second_wave()
	assert_eq(battle.get("battle_wave_index"), 1)
	assert_eq(_units_by_team(battle, 1).size(), 3)
	assert_false(battle.get("combat_started"))
