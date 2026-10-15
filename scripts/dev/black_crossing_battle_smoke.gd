extends Control

# D188: 54 deterministic *real BattleUnit* combats with the encounter-only
# warned wave controller. Technical PASS is not a balance or reward signoff.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/black_crossing.tres")
const SURGE_SCRIPT := preload("res://scripts/battle/black_crossing_surge.gd")
const FLOOR := preload("res://scripts/battle/black_crossing_floor.gd")
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")
const ARENA_PATH := "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64"
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const STATES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]
const STEP := 1.0 / 30.0
const MAX_SECONDS := 85.0
const TOTAL_CASES := 54

var failures: Array[String] = []
var title_label: Label
var status_label: Label
var completed := 0
var wins := 0
var defeats := 0
var timeouts := 0
var warnings := 0
var surges := 0
var pushed := 0
var cleared := 0
var wins_per_size: Array[int] = [0, 0, 0]
var wins_per_class: Array[int] = [0, 0, 0]
var hp_per_size: Array[float] = [0.0, 0.0, 0.0]
var worst_hp: Array[float] = [1.0, 1.0, 1.0]
var duration_per_size: Array[float] = [0.0, 0.0, 0.0]
var fallen: Array[int] = [0, 0, 0]


func _ready() -> void:
	title_label = Label.new()
	title_label.position = Vector2(45, 80)
	title_label.size = Vector2(1190, 68)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 27)
	title_label.text = "D188 / BLACK CROSSING — RUNNING"
	add_child(title_label)
	status_label = Label.new()
	status_label.position = Vector2(80, 172)
	status_label.size = Vector2(1120, 485)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 19)
	add_child(status_label)
	await _run_matrix()


func _check_resources() -> void:
	if ENCOUNTER.encounter_id != "black_crossing" or ENCOUNTER.arena_id != "black_crossing":
		failures.append("D188 wrong encounter / arena id")
	if ENCOUNTER.get_formation_count() != 2 or ENCOUNTER.enemy_unit_paths != PackedStringArray([
		"res://resources/units/drowned_ferryman.tres",
		"res://resources/units/drowned_hand.tres",
		"res://resources/units/drowned_hand.tres"
	]):
		failures.append("D188 must have two formations, 1 original Ferryman + 2 original Drowned")
	if RunState.ACT1_CARD_IDS.size() != 36 or RunState.ACT1_CARD_IDS.has("black_crossing"):
		failures.append("D188 card must remain QA-only, live pool 36/45")
	var card: RunCardData = RunState.get_card("black_crossing")
	if card == null or card.target_path != "res://resources/encounters/black_crossing.tres" or card.resolution_type != "combat":
		failures.append("D188 QA-only card lookup missing")
	for role in HERO_ROLES:
		if RunState.get_hero_unit_data(role) == null:
			failures.append("D188 missing hero UnitData: " + role)
	for enemy_path in [
		"res://resources/units/drowned_ferryman.tres",
		"res://resources/units/drowned_hand.tres"
	]:
		var enemy: UnitData = load(enemy_path) as UnitData
		if enemy == null:
			failures.append("D188 missing enemy UnitData: " + enemy_path)
	var encoded := FileAccess.get_file_as_string(ARENA_PATH)
	if encoded.is_empty():
		failures.append("D188 approved storm arena is missing")
	else:
		var image := Image.new()
		if image.load_webp_from_buffer(Marshalls.base64_to_raw(encoded.strip_edges())) != OK or image.get_size() != Vector2i(1280, 720):
			failures.append("D188 storm arena is not valid 1280x720 WebP")
	for role in ["drowned_ferryman", "drowned_hand"]:
		var frames: SpriteFrames = ANIMATIONS.get_frames(role)
		if frames == null:
			failures.append("D188 original animation missing: " + role)
			continue
		for index in range(STATES.size()):
			if frames.get_frame_count(STATES[index]) != COUNTS[index]:
				failures.append("D188 incorrect 25-pose atlas: %s/%s" % [role, STATES[index]])


func _make_unit(arena: Node2D, data: UnitData, team: int, position_value: Vector2, tactic: String) -> BattleUnit:
	if data == null:
		failures.append("D188 null UnitData for team %d" % team)
		return null
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	if unit == null:
		failures.append("D188 BattleUnit scene failed")
		return null
	unit.configure(data, team, position_value)
	unit.set_arena_presentation(ENCOUNTER.arena_id)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval *= RunState.get_party_attack_interval_multiplier()
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(tactic)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
	unit.set_combat_bounds(FLOOR.COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _fight(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	if not RunState.choose_protagonist(HERO_ROLES[protagonist]):
		failures.append("D188 unable to select protagonist")
		return {}
	for member in range(1, party_size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + member) % HERO_ROLES.size()], "D188 matrix")
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var combat_units: Array[BattleUnit] = []
	var hero_starts: Array[Vector2] = [Vector2(270, 284), Vector2(340, 330), Vector2(240, 302)]
	for index in range(RunState.party_roles.size()):
		var hero_data: UnitData = RunState.get_hero_unit_data(String(RunState.party_roles[index]))
		var hero: BattleUnit = _make_unit(arena, hero_data, 0, hero_starts[index], tactic)
		if hero == null:
			arena.free()
			return {}
		combat_units.append(hero)
	var enemy_positions: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
	for index in range(ENCOUNTER.enemy_unit_paths.size()):
		var enemy_path: String = ENCOUNTER.enemy_unit_paths[index]
		var enemy_data: UnitData = load(enemy_path) as UnitData
		var depth: float = clampf((enemy_positions[index].y - 130.0) / 275.0, 0.0, 1.0)
		var enemy_position := Vector2(
			enemy_positions[index].x,
			lerpf(FLOOR.COMBAT_BOUNDS.position.y + 32.0, FLOOR.COMBAT_BOUNDS.end.y - 32.0, depth)
		)
		var enemy: BattleUnit = _make_unit(arena, enemy_data, 1, enemy_position, tactic)
		if enemy == null:
			failures.append("D188 enemy load failed: " + enemy_path)
			arena.free()
			return {}
		combat_units.append(enemy)
	var controller := SURGE_SCRIPT.new() as BlackCrossingSurgeController
	arena.add_child(controller)
	controller.configure(combat_units)
	for unit in combat_units:
		unit.start_combat()
	controller.start_surge()
	controller.set_process(false)
	var elapsed := 0.0
	var frame := 0
	var outcome := ""
	while elapsed < MAX_SECONDS:
		for unit in combat_units:
			if unit.alive:
				unit._process(STEP)
		controller.advance_battle(STEP)
		for fighter in combat_units:
			if not FLOOR.contains_unit_origin(fighter.position, fighter.body_radius):
				failures.append("D189 fighter left the walkable planks: %s (%s)" % [
					fighter.display_name, str(fighter.position)
				])
				break
		if not failures.is_empty():
			break
		elapsed += STEP
		frame += 1
		var heroes_alive := 0
		var enemies_alive := 0
		for unit in combat_units:
			if not unit.alive:
				continue
			if unit.team == 0:
				heroes_alive += 1
			else:
				enemies_alive += 1
		if enemies_alive == 0:
			outcome = "win"
			break
		if heroes_alive == 0:
			outcome = "loss"
			break
		if frame % 90 == 0:
			await get_tree().process_frame
	var hp_sum := 0.0
	var hero_count := 0
	var hero_deaths := 0
	for unit in combat_units:
		if unit.team != 0:
			continue
		hero_count += 1
		hp_sum += clampf(unit.hp / maxf(unit.max_hp, 1.0), 0.0, 1.0)
		if not unit.alive:
			hero_deaths += 1
	var result := {
		"outcome": outcome,
		"duration": elapsed,
		"hp_fraction": hp_sum / float(maxi(hero_count, 1)),
		"hero_deaths": hero_deaths,
		"warnings": controller.warnings,
		"surges": controller.surges,
		"pushed": controller.units_pushed
	}
	controller.stop_surge()
	result["cleared"] = controller.slow_resets
	for unit in combat_units:
		if absf(unit.wave_move_speed_multiplier - 1.0) > 0.001:
			failures.append("D188 slow modifier leaked after battle")
	arena.free()
	await get_tree().process_frame
	return result


func _run_matrix() -> void:
	_check_resources()
	if failures.is_empty():
		await get_tree().process_frame
		for formation in range(2):
			for protagonist in range(HERO_ROLES.size()):
				for party_size in range(1, 4):
					for tactic in TACTICS:
						seed(188000 + formation * 1000 + protagonist * 100 + party_size * 10 + TACTICS.find(tactic))
						var result: Dictionary = await _fight(formation, protagonist, party_size, tactic)
						if result.is_empty():
							break
						completed += 1
						var outcome := String(result["outcome"])
						if outcome == "win":
							wins += 1
							wins_per_size[party_size - 1] += 1
							wins_per_class[protagonist] += 1
						elif outcome == "loss":
							defeats += 1
						else:
							timeouts += 1
							failures.append("D188 timeout: formation %d, role %s, size %d, %s" % [
								formation, HERO_ROLES[protagonist], party_size, tactic
							])
						hp_per_size[party_size - 1] += float(result["hp_fraction"])
						worst_hp[party_size - 1] = minf(worst_hp[party_size - 1], float(result["hp_fraction"]))
						duration_per_size[party_size - 1] += float(result["duration"])
						fallen[party_size - 1] += int(result["hero_deaths"])
						warnings += int(result["warnings"])
						surges += int(result["surges"])
						pushed += int(result["pushed"])
						cleared += int(result["cleared"])
						status_label.text = "D188: %d/54 • %s • %d героя • %s" % [
							completed, HERO_ROLES[protagonist], party_size, tactic
						]
						if not failures.is_empty():
							break
					if not failures.is_empty():
						break
				if not failures.is_empty():
					break
			if not failures.is_empty():
				break
	RunState.reset_run()
	if failures.is_empty() and completed != TOTAL_CASES:
		failures.append("Only %d of 54 D188 cases completed" % completed)
	if failures.is_empty() and (wins + defeats != TOTAL_CASES or timeouts > 0):
		failures.append("Not all D188 cases ended in win/loss")
	if failures.is_empty() and (warnings == 0 or surges == 0 or pushed == 0):
		failures.append("D188 waves never telegraphed, struck or affected any fighters")
	if failures.is_empty() and cleared < pushed:
		failures.append("D188 wave slow modifiers were not fully cleared")
	if failures.is_empty() and (wins_per_size[0] == 0 or wins_per_size[1] == 0 or wins_per_size[2] == 0):
		failures.append("D188 unwinnable for solo, duo or trio")

	if failures.is_empty():
		title_label.text = "D188 / BLACK CROSSING — FUNCTIONAL PASS"
		status_label.text = ("54/54 боёв • %d побед / %d поражений\n"
			+ "Соло / дуо / трио: %d / %d / %d побед\n"
			+ "Рыцарь / Следопыт / Маг: %d / %d / %d побед\n"
			+ "Средний HP: %.0f%% / %.0f%% / %.0f%%\n"
			+ "Худший HP: %.0f%% / %.0f%% / %.0f%%\n"
			+ "Длительность: %.1f / %.1f / %.1f сек\n"
			+ "Погибшие герои: %d / %d / %d\n"
			+ "Волны: %d предупреждений, %d ударов, %d смещений, %d сбросов замедления\n"
			+ "Функциональный PASS не подтверждает баланс и маршрут награды.") % [
			wins, defeats,
			wins_per_size[0], wins_per_size[1], wins_per_size[2],
			wins_per_class[0], wins_per_class[1], wins_per_class[2],
			hp_per_size[0] * 100.0 / 18.0, hp_per_size[1] * 100.0 / 18.0, hp_per_size[2] * 100.0 / 18.0,
			worst_hp[0] * 100.0, worst_hp[1] * 100.0, worst_hp[2] * 100.0,
			duration_per_size[0] / 18.0, duration_per_size[1] / 18.0, duration_per_size[2] / 18.0,
			fallen[0], fallen[1], fallen[2], warnings, surges, pushed, cleared
		]
		status_label.add_theme_color_override("font_color", Color(0.62, 0.90, 0.73))
	else:
		title_label.text = "D188 / BLACK CROSSING — FAIL"
		status_label.text = "\n".join(failures.slice(0, 8))
		status_label.add_theme_color_override("font_color", Color(0.96, 0.38, 0.32))
		push_error(status_label.text)
