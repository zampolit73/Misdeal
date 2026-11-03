extends GutTest

# D384/D385: first-target predictions during the authored wave break move
# into the existing DS3 OrderLabel HEADER (not below the tactic scroll).
# Predictions follow the living heroes; no target lines/new mechanics.
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
	var text_before: String = battle.get_node("OrderLabel").text
	assert_true(text_before.contains("ПЕРВЫЕ ЦЕЛИ: слева"))
	assert_true(text_before.contains("слева — %s" % first.display_name))
	assert_true(text_before.contains("справа — %s" % second.display_name))
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 0), first)
	assert_eq(battle.call("_nearest_hero_to_second_wave_spawn", 1), second)
	# Rearranging the very same heroes flips actual initial enemy target pressure.
	first.position = Vector2(495.0, 355.0)
	second.position = Vector2(170.0, 355.0)
	battle.call("_process", 0.15)
	var text_after: String = battle.get_node("OrderLabel").text
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
			assert_gte(absf(hero.position.x - heroes[earlier].position.x), 139.9,
				"Visible miniatures must not overlap horizontally after the wave clamp")
	assert_false(battle.get("battle_finished"))


func test_wave_break_drag_rejects_visible_silhouette_overlap_only_during_redeployment() -> void:
	var battle := _boot("firing_square", 3)
	var heroes := _get_team(battle, 0)
	var first := heroes[0]
	var second := heroes[1]
	var third := heroes[2]
	first.position = Vector2(245.0, 355.0)
	second.position = Vector2(345.0, 355.0)
	third.position = Vector2(505.0, 355.0)
	assert_false(first._overlaps_friendly_unit(),
		"Normal original placement only checks the approved small collision radii")
	_reach_break(battle)
	first.position = Vector2(245.0, 355.0)
	second.position = Vector2(345.0, 355.0)
	third.position = Vector2(505.0, 355.0)
	assert_eq(first.intermission_min_horizontal_gap, 140.0)
	assert_true(first._overlaps_friendly_unit(),
		"Wave redeployment cannot drop 100px-apart large portraits on each other")
	# Explicit combat end clears the temporary extra click/drag spacing.
	first.disable_placement()
	assert_eq(first.intermission_min_horizontal_gap, 0.0)


func test_wave_break_warning_stays_inside_lower_left_margin() -> void:
	var battle := _boot("firing_square")
	_reach_break(battle)
	var hint := battle.get_node("PlacementHint") as Label
	assert_true(hint.visible)
	assert_true(hint.text.contains("СЛЕВА"))
	assert_true(hint.text.contains("СПРАВА"))
	assert_true(hint.text.contains("\n"))
	assert_gte(hint.position.x, 40.0)
	assert_lte(hint.position.x + hint.size.x, 238.0)
	assert_lte(hint.position.y + hint.size.y, 710.0)
	assert_eq(hint.get_theme_font_size("font_size"), 11)
	assert_true(hint.clip_text, "The wave hint must not extend beyond the left panel")
	var order := battle.get_node("OrderLabel") as Label
	var description := battle.get_node("OrderDescription") as Label
	assert_true(order.text.contains("ПЕРВЫЕ ЦЕЛИ"))
	assert_false(description.text.contains("\n"))
	assert_eq(order.get_theme_font_size("font_size"), 13)


func test_iron_wall_readout_uses_actual_archer_and_skeleton_not_left_right() -> void:
	var battle := _boot("iron_wall", 3)
	_reach_break(battle)
	var description: String = battle.get_node("OrderLabel").text
	assert_true(description.contains("ПЕРВЫЕ ЦЕЛИ: стрелок"))
	assert_true(description.contains("пехотинец"))
	assert_false(description.contains("слева"))
	assert_true(battle.get_node("FightButton").visible)
	assert_eq(battle.get_node("FightButton").text, "ВОЛНА II")


func test_hover_and_committed_order_change_keep_the_position_pressure_visible() -> void:
	var battle := _boot("firing_square", 3)
	_reach_break(battle)
	var description := battle.get_node("OrderDescription") as Label
	var forecast := battle.get_node("OrderLabel") as Label
	var forecast_before := forecast.text
	assert_true(forecast_before.contains("ПЕРВЫЕ ЦЕЛИ: слева"))
	var before: String = battle.get("tactical_order")
	battle.call("_on_tactic_preview_entered", "hunt")
	assert_true(description.text.contains("ПРОСМОТР: ОХОТА"))
	assert_false(description.text.contains("\n"), "Description stays in one line inside the existing scroll")
	assert_eq(forecast.text, forecast_before, "The header forecast survives order hover")
	assert_eq(battle.get("tactical_order"), before, "Hover previews never change the actual AI")
	battle.call("_on_tactic_preview_exited")
	assert_false(description.text.contains("ПРОСМОТР"))
	assert_eq(forecast.text, forecast_before)
	battle.call("_select_tactical_order", "formation")
	assert_eq(battle.get("tactical_order"), "formation")
	assert_true(description.text.contains("СТРОЙ"))
	assert_false(description.text.contains("\n"))
	assert_eq(forecast.text, forecast_before)
	for hero in _get_team(battle, 0):
		assert_eq(hero.tactical_order, "formation")


func test_no_future_wave_targets_leak_into_single_wave_or_before_break() -> void:
	var regular := _boot("graveyard_ambush")
	assert_eq(regular.call("_get_wave_target_readout"), "")
	assert_false(regular.get_node("OrderLabel").text.contains("ПЕРВЫЕ ЦЕЛИ"))
	var wave := _boot("firing_square")
	assert_eq(wave.call("_get_wave_target_readout"), "")
	assert_false(wave.get_node("OrderLabel").text.contains("ПЕРВЫЕ ЦЕЛИ"))
	assert_false(wave.get("wave_intermission"))
