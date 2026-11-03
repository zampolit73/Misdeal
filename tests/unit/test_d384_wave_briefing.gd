extends GutTest

# D384: the existing DS3 OrderDescription reveals who the actual nearest-
# enemy AI would approach FIRST when the authored second wave spawns.
# Predictions move with the living heroes; no targeting lines/new mechanics.
const BATTLE := preload("res://scenes/battle/battle.tscn")


func after_each() -> void:
	RunState.reset_run()


func _boot(card_id: String, party_size: int = 2) -> Control:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("knight"))
	for index in range(1, party_size):
		assert_true(RunState.recruit_companion(RunState.HERO_ROLES[index], "D384 test"))
	RunState.active_card_id = card_id
	RunState.select_encounter("res://resources/encounters/%s.tres" % card_id)
	var battle := BATTLE.instantiate() as Control
	add_child_autofree(battle)
	return battle


func _get_team(battle: Control, team: int) -> Array[BattleUnit]:
	var result: Array[BattleUnit] = []
	for actor in battle.get("units"):
		var unit := actor as BattleUnit
		if unit != null and unit.alive and unit.team == team:
			result.append(unit)
	return result


func _reach_break(battle: Control) -> void:
	battle.set("combat_started", true)
	battle.set("combat_live", true)
	for enemy in _get_team(battle, 1):
		enemy.take_damage(enemy.max_hp + 10000.0)
	assert_true(battle.get("wave_intermission"))


func test_crossfire_readout_shows_nearest_initial_targets_and_changes_with_placement() -> void:
	var battle := _boot("firing_square")
	var heroes := _get_team(battle, 0)
	var first := heroes[0]
	var second := heroes[1]
	_reach_break(battle)
	# Both positions remain inside the authored Firing Square deployment zone.
	first.position = Vector2(170.0, 355.0)
	second.position = Vector2(495.0, 355.0)
	battle.call("_process", 0.15)
	var text_before: String = battle.get_node("OrderDescription").text
	assert_true(text_before.contains("ПЕРВЫЕ ЦЕЛИ: слева"))
	assert_true(text_before.contains("слева — %s" % first.display_name))
	assert_true(text_before.contains("справа — %s" % second.display_name))
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 0), first)
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 1), second)
	# Rearranging the very same heroes flips actual initial enemy target pressure.
	first.position = Vector2(495.0, 355.0)
	second.position = Vector2(170.0, 355.0)
	battle.call("_process", 0.15)
	var text_after: String = battle.get_node("OrderDescription").text
	assert_ne(text_before, text_after)
	assert_true(text_after.contains("слева — %s" % second.display_name))
	assert_true(text_after.contains("справа — %s" % first.display_name))
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 0), second)
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 1), first)
	assert_eq(battle.get("battle_wave_index"), 1)
	assert_false(battle.get("battle_finished"))


func test_wave_break_unstacks_surviving_heroes_in_legal_strip() -> void:
	var battle := _boot("firing_square", 3)
	var heroes := _get_team(battle, 0)
	var hp_before: Array[float] = []
	for hero in heroes:
		hp_before.append(hero.hp)
		# Simulate three wounded survivors converging on the same floor tile.
		hero.position = Vector2(475.0, 355.0)
	_reach_break(battle)
	for index in range(heroes.size()):
		var hero := heroes[index]
		assert_true(hero.placement_enabled)
		assert_eq(hero.hp, hp_before[index], "Regrouping cannot grant healing")
		assert_true(hero.placement_regions[0].has_point(hero.position))
		for earlier in range(index):
			assert_gte(hero.position.distance_to(heroes[earlier].position), 71.9,
				"Auto-clamping survivors must not stack their clickable silhouettes")
	assert_false(battle.get("battle_finished"))


func test_iron_wall_readout_uses_actual_archer_and_skeleton_not_left_right() -> void:
	var battle := _boot("iron_wall", 3)
	_reach_break(battle)
	var description: String = battle.get_node("OrderDescription").text
	assert_true(description.contains("ПЕРВЫЕ ЦЕЛИ: стрелок"))
	assert_true(description.contains("пехотинец"))
	assert_false(description.contains("слева"))
	assert_true(battle.get_node("FightButton").visible)
	assert_eq(battle.get_node("FightButton").text, "ВОЛНА II")


func test_hover_and_committed_order_change_keep_the_position_pressure_visible() -> void:
	var battle := _boot("firing_square", 3)
	_reach_break(battle)
	var description := battle.get_node("OrderDescription") as Label
	var before: String = battle.get("tactical_order")
	battle.call("_on_tactic_preview_entered", "hunt")
	assert_true(description.text.contains("ПРОСМОТР: ОХОТА"))
	assert_true(description.text.contains("ПЕРВЫЕ ЦЕЛИ: слева"))
	assert_eq(battle.get("tactical_order"), before, "Hover previews never change the actual AI")
	battle.call("_on_tactic_preview_exited")
	assert_false(description.text.contains("ПРОСМОТР"))
	assert_true(description.text.contains("ПЕРВЫЕ ЦЕЛИ:"))
	battle.call("_select_tactical_order", "formation")
	assert_eq(battle.get("tactical_order"), "formation")
	assert_true(description.text.contains("СТРОЙ"))
	assert_true(description.text.contains("ПЕРВЫЕ ЦЕЛИ:"))
	for hero in _get_team(battle, 0):
		assert_eq(hero.tactical_order, "formation")


func test_no_future_wave_targets_leak_into_single_wave_or_before_break() -> void:
	var regular := _boot("graveyard_ambush")
	assert_eq(regular.call("_get_wave_target_readout"), "")
	assert_false(regular.get_node("OrderDescription").text.contains("ПЕРВЫЕ ЦЕЛИ"))
	var wave := _boot("firing_square")
	assert_eq(wave.call("_get_wave_target_readout"), "")
	assert_false(wave.get_node("OrderDescription").text.contains("ПЕРВЫЕ ЦЕЛИ"))
	assert_false(wave.get("wave_intermission"))
