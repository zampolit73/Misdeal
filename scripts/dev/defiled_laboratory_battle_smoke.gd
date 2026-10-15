extends Control

# D152 diagnostic battle matrix, deliberately separate from the normal run UI.
# Uses real BattleUnit AI + the original encounter-local hazard controller.
# PASS means technical completion, NOT fair difficulty or full reward flow.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/defiled_laboratory.tres")
const HAZARDS_SCRIPT := preload("res://scripts/battle/laboratory_hazards.gd")
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")

const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const STATE_NAMES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const STATE_COUNTS: Array[int] = [4, 6, 6, 3, 6]
const STEP := 1.0 / 30.0
const MAX_SECONDS := 80.0
const COMBAT_BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))
const TOTAL_CASES := 54

var headline: Label
var summary: Label
var errors: Array[String] = []
var completed := 0
var wins := 0
var losses := 0
var warnings := 0
var pulses := 0
var spills := 0
var max_duration := 0.0
var wins_by_party: Array[int] = [0, 0, 0]
var losses_by_party: Array[int] = [0, 0, 0]
# New D152-only challenge telemetry: party HP retained and fight duration.
# A functional PASS with 54 victories can still be poor balance.
var party_hp_fraction_sum: Array[float] = [0.0, 0.0, 0.0]
var party_duration_sum: Array[float] = [0.0, 0.0, 0.0]
var party_hero_deaths: Array[int] = [0, 0, 0]
var tactic_win_count: Array[int] = [0, 0, 0]
var tactic_hp_fraction_sum: Array[float] = [0.0, 0.0, 0.0]


func _ready() -> void:
	headline = Label.new()
	headline.position = Vector2(48.0, 88.0)
	headline.size = Vector2(1184.0, 90.0)
	headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	headline.add_theme_font_size_override("font_size", 28)
	headline.text = "D152 / DEFILED LABORATORY — TESTING"
	add_child(headline)

	summary = Label.new()
	summary.position = Vector2(75.0, 194.0)
	summary.size = Vector2(1130.0, 405.0)
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	summary.add_theme_font_size_override("font_size", 20)
	add_child(summary)
	await _run_matrix()


func _run_matrix() -> void:
	_validate_assets()
	if errors.is_empty():
		_validate_facing()
	if errors.is_empty():
		await get_tree().process_frame
		for formation in range(2):
			for protagonist in range(HERO_ROLES.size()):
				for party_size in range(1, 4):
					for tactic in TACTICS:
						seed(52000 + formation * 1000 + protagonist * 100 + party_size * 10 + TACTICS.find(tactic))
						var result: Dictionary = await _fight(formation, protagonist, party_size, tactic)
						if result.is_empty():
							break
						completed += 1
						if String(result["outcome"]) == "win":
							wins += 1
							wins_by_party[party_size - 1] += 1
						else:
							losses += 1
							losses_by_party[party_size - 1] += 1
						warnings += int(result["warnings"])
						pulses += int(result["pulses"])
						spills += int(result["spills"])
						var tactic_index: int = TACTICS.find(tactic)
						party_hp_fraction_sum[party_size - 1] += float(result["remaining_hp_fraction"])
						party_duration_sum[party_size - 1] += float(result["duration"])
						party_hero_deaths[party_size - 1] += int(result["hero_deaths"])
						tactic_hp_fraction_sum[tactic_index] += float(result["remaining_hp_fraction"])
						if String(result["outcome"]) == "win":
							tactic_win_count[tactic_index] += 1
						max_duration = maxf(max_duration, float(result["duration"]))
						summary.text = "%d/54 • %s • %d героя • %s\nПобед: %d • Поражений: %d" % [
							completed, HERO_ROLES[protagonist], party_size, tactic, wins, losses]
						if not errors.is_empty():
							break
					if not errors.is_empty():
						break
				if not errors.is_empty():
					break
			if not errors.is_empty():
				break

	RunState.reset_run()
	if errors.is_empty() and completed != TOTAL_CASES:
		errors.append("Completed only %d of %d cases" % [completed, TOTAL_CASES])
	if errors.is_empty() and warnings == 0:
		errors.append("None of the real battles triggered a laboratory telegraph")

	if errors.is_empty():
		headline.text = "D152 / DEFILED LABORATORY — FUNCTIONAL PASS"
		summary.text = ("54/54 боёв • %d побед / %d поражений\n"
			+ "Соло: %d/%d • Дуо: %d/%d • Трио: %d/%d\n"
			+ "Остаток HP (соло/дуо/трио): %.0f%% / %.0f%% / %.0f%%\n"
			+ "Средняя длительность: %.1f / %.1f / %.1f сек\n"
			+ "Погибшие герои в боях: %d / %d / %d\n"
			+ "Тактики ASSAULT/HUNT/FORMATION: %d / %d / %d побед\n"
			+ "Предупреждения: %d • попадания химией: %d • разливы: %d\n"
			+ "Максимальная длительность: %.1f сек\n"
			+ "Технический PASS не означает одобренный баланс.") % [
				wins, losses,
				wins_by_party[0], losses_by_party[0],
				wins_by_party[1], losses_by_party[1],
				wins_by_party[2], losses_by_party[2],
				party_hp_fraction_sum[0] * 100.0 / 18.0,
				party_hp_fraction_sum[1] * 100.0 / 18.0,
				party_hp_fraction_sum[2] * 100.0 / 18.0,
				party_duration_sum[0] / 18.0,
				party_duration_sum[1] / 18.0,
				party_duration_sum[2] / 18.0,
				party_hero_deaths[0], party_hero_deaths[1], party_hero_deaths[2],
				tactic_win_count[0], tactic_win_count[1], tactic_win_count[2],
				warnings, pulses, spills, max_duration]
		summary.add_theme_color_override("font_color", Color(0.60, 0.88, 0.70))
	else:
		headline.text = "D152 / DEFILED LABORATORY — FAIL"
		summary.text = "\n".join(errors.slice(0, 8))
		summary.add_theme_color_override("font_color", Color(0.98, 0.40, 0.36))
		push_error(summary.text)


func _validate_assets() -> void:
	var card: RunCardData = RunState.get_card("defiled_laboratory")
	if card == null or card.resolution_type != "combat" or card.tier != 1:
		errors.append("Missing D152 QA-only Tier1 card")
	if RunState.ACT1_CARD_IDS.size() != 34 or RunState.ACT1_CARD_IDS.has("defiled_laboratory"):
		errors.append("D152 must not enter live Act1 until card-art / full QA release")
	if ENCOUNTER.encounter_id != "defiled_laboratory" or ENCOUNTER.get_formation_count() != 2:
		errors.append("Expected two authored laboratory formations")
	var expected: PackedStringArray = PackedStringArray([
		"res://resources/units/plague_alchemist.tres",
		"res://resources/units/unstable_homunculus.tres",
		"res://resources/units/unstable_homunculus.tres"])
	if ENCOUNTER.enemy_unit_paths != expected:
		errors.append("Original laboratory roster no longer matches 1+2")
	for role in ["plague_alchemist", "unstable_homunculus"]:
		var role_name: String = String(role)
		var frames: SpriteFrames = ANIMATIONS.get_frames(role_name)
		if frames == null:
			errors.append("Original 25-frame atlas unavailable: " + role_name)
			continue
		for state_index in range(STATE_NAMES.size()):
			if frames.get_frame_count(STATE_NAMES[state_index]) != STATE_COUNTS[state_index]:
				errors.append("Wrong animation count for %s/%s" % [role_name, STATE_NAMES[state_index]])


func _validate_facing() -> void:
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var hero_data := load("res://resources/units/knight.tres") as UnitData
	if hero_data == null:
		errors.append("Facing fixture missing Knight")
		arena.free()
		return
	var hero: BattleUnit = _make_unit(arena, hero_data, 0, Vector2(260.0, 350.0), "assault")
	if hero == null:
		arena.free()
		return
	for resource_path in [
		"res://resources/units/plague_alchemist.tres",
		"res://resources/units/unstable_homunculus.tres",
	]:
		var data := load(resource_path) as UnitData
		if data == null:
			errors.append("Facing fixture missing original role: " + resource_path)
			continue
		var enemy: BattleUnit = _make_unit(arena, data, 1, Vector2(840.0, 350.0), "assault")
		if enemy == null:
			continue
		if not enemy.art_sprite.flip_h:
			errors.append("Source-right D152 enemy not facing left at deployment: " + data.visual_role)
		enemy.combat_started = true
		enemy.target = hero
		enemy._update_unit_facing()
		if not enemy.art_sprite.flip_h:
			errors.append("D152 enemy failed to face Knight on left: " + data.visual_role)
		hero.position.x = 1100.0
		enemy._update_unit_facing()
		if enemy.art_sprite.flip_h:
			errors.append("D152 enemy failed to turn right to a passed target: " + data.visual_role)
		hero.position.x = 260.0
		enemy.target = null
		enemy.combat_started = false
	arena.free()


func _make_unit(arena: Node2D, data: UnitData, team: int, pos: Vector2, tactic: String) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	if unit == null or data == null:
		errors.append("Could not instantiate real BattleUnit")
		return null
	unit.configure(data, team, pos)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval *= RunState.get_party_attack_interval_multiplier()
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(tactic)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _fixture(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	RunState.choose_protagonist(HERO_ROLES[protagonist])
	for teammate in range(1, party_size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + teammate) % 3], "D152 QA")
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var heroes: Array[BattleUnit] = []
	var enemies: Array[BattleUnit] = []
	var hero_spawns: Array[Vector2] = [Vector2(280, 340), Vector2(320, 411), Vector2(335, 305)]
	for i in range(RunState.party_roles.size()):
		var hero_data: UnitData = RunState.get_hero_unit_data(String(RunState.party_roles[i]))
		var hero: BattleUnit = _make_unit(arena, hero_data, 0, hero_spawns[i], tactic)
		if hero == null:
			arena.free()
			return {}
		heroes.append(hero)
	var enemy_spawns: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
	for i in range(ENCOUNTER.enemy_unit_paths.size()):
		var enemy_data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var depth: float = clampf((enemy_spawns[i].y - 130.0) / 275.0, 0.0, 1.0)
		var spawn: Vector2 = Vector2(enemy_spawns[i].x, lerpf(316.0, 410.0, depth))
		var enemy: BattleUnit = _make_unit(arena, enemy_data, 1, spawn, tactic)
		if enemy == null:
			arena.free()
			return {}
		enemies.append(enemy)
	var all_units: Array[BattleUnit] = []
	all_units.append_array(heroes)
	all_units.append_array(enemies)
	var controller := HAZARDS_SCRIPT.new() as LaboratoryHazardController
	arena.add_child(controller)
	var minions: Array[BattleUnit] = [enemies[1], enemies[2]]
	controller.configure(enemies[0], minions, all_units)
	controller.set_process(false)
	return {"arena": arena, "units": all_units, "controller": controller}


func _fight(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	var state: Dictionary = _fixture(formation, protagonist, party_size, tactic)
	if state.is_empty():
		return {}
	var all_units: Array[BattleUnit] = state["units"]
	var controller: LaboratoryHazardController = state["controller"]
	for unit in all_units:
		unit.start_combat()
	controller.start_hazards()
	controller.set_process(false)
	var elapsed := 0.0
	var frames := 0
	var outcome := ""
	while elapsed < MAX_SECONDS:
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
		controller.advance_battle(STEP)
		elapsed += STEP
		frames += 1
		var living_heroes := 0
		var living_enemies := 0
		for unit in all_units:
			if not unit.alive:
				continue
			if unit.team == 0:
				living_heroes += 1
			else:
				living_enemies += 1
		if living_enemies == 0:
			outcome = "win"
			break
		if living_heroes == 0:
			outcome = "loss"
			break
		if frames % 90 == 0:
			await get_tree().process_frame
	if outcome.is_empty():
		errors.append("Timeout %d / %s / size %d / %s" % [formation, HERO_ROLES[protagonist], party_size, tactic])
	var total_hero_hp_fraction: float = 0.0
	var starting_hero_count: int = 0
	var hero_deaths: int = 0
	for unit in all_units:
		if unit.team != 0:
			continue
		starting_hero_count += 1
		total_hero_hp_fraction += clampf(unit.hp / maxf(1.0, unit.max_hp), 0.0, 1.0)
		if not unit.alive:
			hero_deaths += 1
	var hp_fraction: float = total_hero_hp_fraction / float(maxi(1, starting_hero_count))
	var result := {
		"outcome": outcome,
		"duration": elapsed,
		"warnings": controller.warnings,
		"pulses": controller.pulses,
		"spills": controller.spills,
		"remaining_hp_fraction": hp_fraction,
		"hero_deaths": hero_deaths
	}
	controller.stop_hazards()
	# Explicit free after manually stepped units to prevent cross-case targets.
	(state["arena"] as Node2D).free()
	await get_tree().process_frame
	if outcome.is_empty():
		return {}
	return result
