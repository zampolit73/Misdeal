extends Control

# D153 diagnostic matrix: actual BattleUnit combat AI and original encounter-only
# ThreadTetherController. Not a random run and never a production card unlock.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/threadbare_theatre.tres")
const TETHER_SCRIPT := preload("res://scripts/battle/thread_tether.gd")
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")
const ARENA_PATH := "res://assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64"

const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const ANIMATIONS_NAMES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const ANIMATIONS_COUNTS: Array[int] = [4, 6, 6, 3, 6]
const STEP := 1.0 / 30.0
const MAX_SECONDS := 85.0
const COMBAT_BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))
const TOTAL_CASES := 54

var title_label: Label
var status_label: Label
var failures: Array[String] = []
var completed := 0
var wins := 0
var defeats := 0
var timeouts := 0
var all_links := 0
var all_breaks := 0
var all_master_breaks := 0
var wins_per_size: Array[int] = [0, 0, 0]
var duration_per_size: Array[float] = [0.0, 0.0, 0.0]
var hp_per_size: Array[float] = [0.0, 0.0, 0.0]
var deaths_per_size: Array[int] = [0, 0, 0]


func _ready() -> void:
	title_label = Label.new()
	title_label.position = Vector2(50, 92)
	title_label.size = Vector2(1180, 76)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 27)
	title_label.text = "D153 / THREADBARE THEATRE — TESTING"
	add_child(title_label)
	status_label = Label.new()
	status_label.position = Vector2(74, 194)
	status_label.size = Vector2(1132, 414)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 19)
	add_child(status_label)
	await _run()


func _check_resources() -> void:
	if ENCOUNTER.encounter_id != "threadbare_theatre" or ENCOUNTER.arena_id != "threadbare_theatre":
		failures.append("D153 encounter or theatre arena id missing")
	if ENCOUNTER.get_formation_count() != 2:
		failures.append("D153 requires two different formations")
	if ENCOUNTER.enemy_unit_paths != PackedStringArray([
		"res://resources/units/threadbare_puppeteer.tres",
		"res://resources/units/bone_marionette.tres",
		"res://resources/units/bone_marionette.tres"
	]):
		failures.append("D153 must have one original puppeteer and two original skeletal marionettes")
	if RunState.ACT1_CARD_IDS.size() != 35 or RunState.ACT1_CARD_IDS.has("threadbare_theatre"):
		failures.append("D153 must not enter the 35-card deal pool yet")
	var card: RunCardData = RunState.get_card("threadbare_theatre")
	if card == null or card.resolution_type != "combat" or card.target_path != "res://resources/encounters/threadbare_theatre.tres":
		failures.append("QA-only D153 combat card missing")
	var data := FileAccess.get_file_as_string(ARENA_PATH)
	if data.is_empty():
		failures.append("Missing original approved theatre battle plate")
	else:
		var decoded := Marshalls.base64_to_raw(data.strip_edges())
		var image := Image.new()
		if image.load_webp_from_buffer(decoded) != OK or image.get_size() != Vector2i(1280, 720):
			failures.append("D153 arena image is not valid 1280x720 WebP")
	for role in ["threadbare_puppeteer", "bone_marionette"]:
		var frames: SpriteFrames = ANIMATIONS.get_frames(String(role))
		if frames == null:
			failures.append("Approved D153 animation unavailable: " + role)
			continue
		for i in range(ANIMATIONS_NAMES.size()):
			if frames.get_frame_count(ANIMATIONS_NAMES[i]) != ANIMATIONS_COUNTS[i]:
				failures.append("D153 invalid animation count: %s/%s" % [role, ANIMATIONS_NAMES[i]])


func _make_unit(arena: Node2D, data: UnitData, team: int, pos: Vector2, tactic: String) -> BattleUnit:
	if data == null:
		failures.append("Missing BattleUnit data in D153 matrix")
		return null
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	if unit == null:
		failures.append("Could not instantiate real BattleUnit")
		return null
	unit.configure(data, team, pos)
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
	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _fixture(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	if not RunState.choose_protagonist(HERO_ROLES[protagonist]):
		failures.append("Cannot select D153 protagonist")
		return {}
	for member in range(1, party_size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + member) % HERO_ROLES.size()], "D153 matrix")
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var all_units: Array[BattleUnit] = []
	var start_positions: Array[Vector2] = [Vector2(280, 340), Vector2(335, 410), Vector2(245, 305)]
	for i in range(RunState.party_roles.size()):
		var hero_data: UnitData = RunState.get_hero_unit_data(String(RunState.party_roles[i]))
		var hero: BattleUnit = _make_unit(arena, hero_data, 0, start_positions[i], tactic)
		if hero == null:
			arena.free()
			return {}
		all_units.append(hero)
	var enemy_start: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
	var enemies: Array[BattleUnit] = []
	for i in range(ENCOUNTER.enemy_unit_paths.size()):
		var enemy_data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var depth: float = clampf((enemy_start[i].y - 130.0) / 275.0, 0.0, 1.0)
		var pos := Vector2(enemy_start[i].x, lerpf(316.0, 410.0, depth))
		var enemy: BattleUnit = _make_unit(arena, enemy_data, 1, pos, tactic)
		if enemy == null:
			arena.free()
			return {}
		all_units.append(enemy)
		enemies.append(enemy)
	var controller := TETHER_SCRIPT.new() as ThreadTetherController
	arena.add_child(controller)
	var puppets: Array[BattleUnit] = [enemies[1], enemies[2]]
	controller.configure(enemies[0], puppets)
	controller.start_threads()
	controller.set_process(false)
	if not controller.running or controller.connections_made < 1:
		failures.append("D153 controller did not link an original marionette on deployment")
		controller.stop_threads()
		arena.free()
		return {}
	return {"arena": arena, "units": all_units, "controller": controller, "puppets": puppets}


func _fight(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	var state := _fixture(formation, protagonist, party_size, tactic)
	if state.is_empty():
		return {}
	var all_units: Array[BattleUnit] = state["units"]
	var controller: ThreadTetherController = state["controller"]
	var puppets: Array[BattleUnit] = state["puppets"]
	for unit in all_units:
		unit.start_combat()
	var elapsed := 0.0
	var frame := 0
	var outcome := ""
	while elapsed < MAX_SECONDS:
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
		controller.refresh_links()
		elapsed += STEP
		frame += 1
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
		if frame % 90 == 0:
			await get_tree().process_frame
	var hp_sum := 0.0
	var hero_count := 0
	var hero_deaths := 0
	for unit in all_units:
		if unit.team != 0:
			continue
		hero_count += 1
		hp_sum += clampf(unit.hp / maxf(1.0, unit.max_hp), 0.0, 1.0)
		if not unit.alive:
			hero_deaths += 1
	var result := {
		"outcome": outcome,
		"duration": elapsed,
		"hp_fraction": hp_sum / float(maxi(1, hero_count)),
		"hero_deaths": hero_deaths,
		"links": controller.connections_made,
		"breaks": controller.connections_broken,
		"master_breaks": controller.master_death_breaks
	}
	controller.stop_threads()
	for puppet in puppets:
		if absf(puppet.damage_taken_multiplier - 1.0) > 0.001:
			failures.append("Tether leaked puppet protection after cleanup")
	(state["arena"] as Node2D).free()
	await get_tree().process_frame
	return result


func _run() -> void:
	_check_resources()
	if failures.is_empty():
		await get_tree().process_frame
		for formation in range(2):
			for protagonist in range(HERO_ROLES.size()):
				for party_size in range(1, 4):
					for tactic in TACTICS:
						seed(153000 + formation * 1000 + protagonist * 100 + party_size * 10 + TACTICS.find(tactic))
						var result: Dictionary = await _fight(formation, protagonist, party_size, tactic)
						if result.is_empty():
							break
						completed += 1
						if String(result["outcome"]) == "win":
							wins += 1
							wins_per_size[party_size - 1] += 1
						else:
							defeats += 1
						if String(result["outcome"]).is_empty():
							timeouts += 1
							failures.append("Timed out: formation %d, %s, size %d, %s" % [
								formation, HERO_ROLES[protagonist], party_size, tactic])
						all_links += int(result["links"])
						all_breaks += int(result["breaks"])
						all_master_breaks += int(result["master_breaks"])
						hp_per_size[party_size - 1] += float(result["hp_fraction"])
						duration_per_size[party_size - 1] += float(result["duration"])
						deaths_per_size[party_size - 1] += int(result["hero_deaths"])
						status_label.text = "%d / 54 • %s • %d героя • %s\nПобеды: %d • Поражения: %d" % [
							completed, HERO_ROLES[protagonist], party_size, tactic, wins, defeats]
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
		failures.append("Only %d of 54 battles completed" % completed)
	if failures.is_empty() and all_links <= 0:
		failures.append("No active thread links were observed in the real battles")
	if failures.is_empty():
		title_label.text = "D153 / THEATRE BATTLE — FUNCTIONAL PASS"
		status_label.text = ("54 / 54 боёв • %d побед / %d поражений\n"
			+ "Соло / дуо / трио: %d / %d / %d побед\n"
			+ "HP отряда: %.0f%% / %.0f%% / %.0f%%\n"
			+ "Средняя длительность: %.1f / %.1f / %.1f с\n"
			+ "Погибшие герои: %d / %d / %d\n"
			+ "Нити: %d соединений, %d разрывов, %d разрывов при смерти Кукловода.\n"
			+ "Технический PASS не подтверждает баланс или маршрут награды.") % [
			wins, defeats, wins_per_size[0], wins_per_size[1], wins_per_size[2],
			hp_per_size[0] * 100.0 / 18.0,
			hp_per_size[1] * 100.0 / 18.0,
			hp_per_size[2] * 100.0 / 18.0,
			duration_per_size[0] / 18.0,
			duration_per_size[1] / 18.0,
			duration_per_size[2] / 18.0,
			deaths_per_size[0], deaths_per_size[1], deaths_per_size[2],
			all_links, all_breaks, all_master_breaks]
		status_label.add_theme_color_override("font_color", Color(0.63, 0.90, 0.70))
	else:
		title_label.text = "D153 / THEATRE BATTLE — FAIL"
		status_label.text = "\n".join(failures.slice(0, 8))
		status_label.add_theme_color_override("font_color", Color(0.96, 0.39, 0.32))
		push_error(status_label.text)
