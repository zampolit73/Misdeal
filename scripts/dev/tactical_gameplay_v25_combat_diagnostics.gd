extends Control

# F6-only D141 diagnostics. Exact v2.4 matchup seeds for 54 Last Bell cases
# and 72 Knight-led advanced fights; tracks real attack/heal/damage via optional
# BattleUnit signals, and target-distance/movement after every combat frame.
# Data collection only: no encounter or balance changes and no full Act 1 flow.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const ORDER_IDS: Array[String] = ["assault", "hunt", "formation"]
const ENCOUNTER_IDS: Array[String] = [
	"last_bell", "ossuary_gate", "firing_square"
]
const EXPECTED_ROLES := {
	"ossuary_gate": ["crypt_guard", "grave_bellkeeper", "bone_archer", "bone_thrall"],
	"last_bell": ["bone_thrall", "bone_thrall", "grave_bellkeeper", "grave_bellkeeper"],
	"firing_square": ["crypt_guard", "bone_archer", "bone_archer", "bone_archer", "bone_archer"]
}
const EXPECTED_ENEMY_HP := [0.82, 0.92, 1.0]
const EXPECTED_ENEMY_DAMAGE := [0.80, 0.90, 1.0]
const STANDARD_COMBAT_BOUNDS := Rect2(Vector2(90.0, 284.0), Vector2(1080.0, 158.0))
const VOLLEY_COMBAT_BOUNDS := Rect2(Vector2(90.0, 279.0), Vector2(1080.0, 163.0))
const STEP_SECONDS := 1.0 / 30.0
const MAX_BATTLE_SECONDS := 75.0
const FRAMES_PER_YIELD := 90
const REPEAT_LATE_SEEDS := 2
const PROFILE_BARE := "bare"
const PROFILE_BUILT := "tier2_built"
# Actual authored Resources, one hero upgrade per present role and one
# protagonist-specific artifact. Representative upper build, not guaranteed.
const LATE_UPGRADES := {
	"knight": "knight_iron_oath",
	"ranger": "ranger_longshot",
	"mage": "mage_wildfire"
}
const LATE_ARTIFACTS := {
	"knight": "dead_mans_shield",
	"ranger": "blind_quiver",
	"mage": "cracked_focus"
}
const RESULTS_FILE := "user://misdeal_tactical_v25_trace_cases.csv"
const UNIT_RESULTS_FILE := "user://misdeal_tactical_v25_trace_units.csv"

var errors: Array[String] = []
var results: Array[Dictionary] = []
var status_label: Label
var title_label: Label
var total_trials := 0
var trace_units: Array[BattleUnit] = []
var trace_stats: Dictionary = {}
var per_unit_rows: Array[Dictionary] = []


func _ready() -> void:
	title_label = Label.new()
	title_label.position = Vector2(48, 80)
	title_label.size = Vector2(1184, 124)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 29)
	title_label.add_theme_color_override("font_color", Color(0.91, 0.77, 0.56))
	add_child(title_label)

	status_label = Label.new()
	status_label.position = Vector2(90, 220)
	status_label.size = Vector2(1100, 402)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 19)
	add_child(status_label)

	# 54 Last Bell matchups (all protagonists) + 72 Knight-led late matchups.
	total_trials = 2 * HERO_ROLES.size() * 3 * ORDER_IDS.size() + 2 * 2 * 3 * ORDER_IDS.size() * REPEAT_LATE_SEEDS
	title_label.text = "TACTICAL GAMEPLAY 2.5 — DIAGNOSING"
	status_label.text = "Диагностика %d сопоставимых боёв без изменения баланса..." % total_trials
	await _run_benchmarks()
	if errors.is_empty() and results.size() != total_trials:
		errors.append("Incomplete benchmark: %d/%d results" % [results.size(), total_trials])
	_write_results()
	RunState.reset_run()

	if errors.is_empty():
		var victories := 0
		var defeats := 0
		for result in results:
			if result["outcome"] == "win":
				victories += 1
			elif result["outcome"] == "loss":
				defeats += 1
		title_label.text = "TACTICAL GAMEPLAY 2.5 — PASS"
		status_label.text = ("%d/%d боёв завершились. Побед: %d, поражений: %d.\n"
			+ "Диагностика: атаки, урон, лечение, преследование, смена целей.\n"
			+ "Последний звон: 54; поздний Рыцарь соло/дуо/трио: 72.\n"
			+ "Итоги: %s\n"
			+ "Герои и враги: %s\n"
			+ "PASS = измерения записаны, НЕ решение проблемы.") % [
			results.size(), total_trials, victories, defeats, RESULTS_FILE, UNIT_RESULTS_FILE
		]
		status_label.add_theme_color_override("font_color", Color(0.56, 0.84, 0.69))
	else:
		title_label.text = "TACTICAL GAMEPLAY 2.5 — FAIL"
		status_label.text = ("%d/%d боёв записано.\n" % [results.size(), total_trials]) + "\n".join(errors.slice(0, 7))
		status_label.add_theme_color_override("font_color", Color(0.94, 0.45, 0.38))
		push_error(status_label.text)


func _run_benchmarks() -> void:
	for encounter_index in range(ENCOUNTER_IDS.size()):
		var encounter_id: String = ENCOUNTER_IDS[encounter_index]
		var encounter := load("res://resources/encounters/%s.tres" % encounter_id) as EncounterData
		if encounter == null or not EXPECTED_ROLES.has(encounter_id):
			errors.append("%s: missing encounter" % encounter_id)
			return
		if not _validate_encounter(encounter):
			return
		var card: RunCardData = RunState.get_card(encounter_id)
		if card == null:
			errors.append("%s: missing RunCardData" % encounter_id)
			return
		var is_late: bool = card.tier == 2
		var repeat_count: int = REPEAT_LATE_SEEDS if is_late else 1
		var profile: String = PROFILE_BUILT if is_late else PROFILE_BARE

		for variant in range(2):
			for protagonist_index in range(HERO_ROLES.size()):
				# The exact v2.4 seed and pairing; filter advanced cases to Knight.
				if is_late and protagonist_index != 0:
					continue
				var protagonist: String = HERO_ROLES[protagonist_index]
				for sample_index in range(repeat_count):
					var case_seed: int = 24000 + encounter_index * 10000 + variant * 1000 + protagonist_index * 100 + sample_index * 47
					for party_size in range(1, 4):
						for order_id in ORDER_IDS:
							seed(case_seed)
							var result: Dictionary = await _run_single_battle(encounter, variant, party_size, protagonist, order_id, profile, sample_index)
							if result.is_empty():
								return
							results.append(result)
							status_label.text = ("%d/%d боёв\n%s • строй %d • %s • %d героя\n"
								+ "%s • зерно %d | %s за %.1f сек\n"
								+ "Записываем урон, лечение и время преследования.") % [
								results.size(), total_trials, encounter.title, variant + 1,
								protagonist, party_size, order_id, sample_index + 1,
								result["outcome"], result["seconds"]
							]
							if result["outcome"] == "timeout":
								errors.append("%s %s %d heroes / formation %d: timeout" % [encounter_id, order_id, party_size, variant + 1])
							if not errors.is_empty():
								return


func _validate_encounter(encounter: EncounterData) -> bool:
	if encounter.get_formation_count() != 2:
		errors.append("%s: both authored formations required" % encounter.encounter_id)
		return false
	var expected: Array = EXPECTED_ROLES[encounter.encounter_id]
	if encounter.enemy_unit_paths.size() != expected.size():
		errors.append("%s: original enemy roster size changed" % encounter.encounter_id)
		return false

	for i in range(expected.size()):
		var enemy_data := load(encounter.enemy_unit_paths[i]) as UnitData
		if enemy_data == null or enemy_data.visual_role != String(expected[i]):
			errors.append("%s: role mismatch at enemy %d" % [encounter.encounter_id, i])
			return false

	for variant in range(2):
		var positions: PackedVector2Array = encounter.get_enemy_positions_for_formation(variant)
		if positions.size() != expected.size() or encounter.get_formation_hint(variant).is_empty():
			errors.append("%s: invalid layout or hint %d" % [encounter.encounter_id, variant])
			return false
		for i in range(positions.size()):
			if positions[i].x < 760.0 or positions[i].x > 1150.0 or positions[i].y < 125.0 or positions[i].y > 405.0:
				errors.append("%s: enemy outside authored arena" % encounter.encounter_id)
				return false
			for j in range(i + 1, positions.size()):
				if positions[i].distance_to(positions[j]) < 48.0:
					errors.append("%s: overlapping enemy spawn positions" % encounter.encounter_id)
					return false
	return true


func _run_single_battle(
	encounter: EncounterData,
	variant: int,
	party_size: int,
	protagonist: String,
	order_id: String,
	profile: String,
	sample_index: int
) -> Dictionary:
	RunState.reset_run()
	if not RunState.choose_protagonist(protagonist):
		errors.append("Cannot choose protagonist: %s" % protagonist)
		return {}
	# A Knight always adds Ranger then Mage, Ranger adds Mage then Knight,
	# and Mage adds Knight then Ranger. No protagonist rotation by party size.
	var protagonist_index: int = HERO_ROLES.find(protagonist)
	for offset in range(1, party_size):
		var companion: String = HERO_ROLES[(protagonist_index + offset) % HERO_ROLES.size()]
		RunState.recruit_companion(companion, "F6 controlled party")
	if RunState.get_party_size() != party_size:
		errors.append("Cannot assemble party of %d" % party_size)
		return {}

	if not is_equal_approx(RunState.get_enemy_hp_multiplier(), EXPECTED_ENEMY_HP[party_size - 1]) or not is_equal_approx(RunState.get_enemy_base_damage_multiplier(), EXPECTED_ENEMY_DAMAGE[party_size - 1]):
		errors.append("Party-size enemy scaling changed unexpectedly: %d" % party_size)
		return {}

	if profile == PROFILE_BUILT:
		for role in RunState.party_roles:
			var upgrade_id: String = String(LATE_UPGRADES.get(role, ""))
			if upgrade_id.is_empty() or not RunState.add_hero_upgrade(upgrade_id):
				errors.append("Could not apply tier-2 upgrade for %s" % role)
				return {}
		var artifact_id: String = String(LATE_ARTIFACTS.get(protagonist, ""))
		if artifact_id.is_empty() or not RunState.add_artifact(artifact_id):
			errors.append("Could not apply tier-2 artifact for %s" % protagonist)
			return {}

	var battlefield := Node2D.new()
	battlefield.visible = false
	add_child(battlefield)

	var units: Array[BattleUnit] = []
	var heroes: Array[BattleUnit] = []
	var enemies: Array[BattleUnit] = []
	var bounds := STANDARD_COMBAT_BOUNDS
	if encounter.encounter_id == "gallows_volley" or encounter.encounter_id == "firing_square":
		bounds = VOLLEY_COMBAT_BOUNDS

	var placement_regions: Array[Rect2] = []
	if bounds == VOLLEY_COMBAT_BOUNDS:
		placement_regions.append(Rect2(Vector2(145, 305), Vector2(385, 122)))
	else:
		placement_regions.append(Rect2(Vector2(150, 306), Vector2(163, 123)))
		placement_regions.append(Rect2(Vector2(355, 306), Vector2(163, 123)))

	for i in range(party_size):
		var role: String = RunState.party_roles[i]
		var hero_data: UnitData = RunState.get_hero_unit_data(role)
		if hero_data == null:
			errors.append("Missing hero UnitData: %s" % role)
			break
		var hero := UNIT_SCENE.instantiate() as BattleUnit
		var source_position: Vector2 = _hero_spawn_source(encounter.encounter_id, party_size, i)
		hero.configure(hero_data, 0, _project_spawn(source_position, bounds))
		_apply_authored_build(hero)
		hero.max_hp *= RunState.get_party_hp_multiplier()
		hero.damage *= RunState.get_party_damage_multiplier()
		hero.attack_interval = maxf(0.2, hero.attack_interval * RunState.get_party_attack_interval_multiplier())
		hero.move_speed *= RunState.get_party_move_speed_multiplier()
		if party_size == 1 and order_id == "formation":
			hero.damage_taken_multiplier = 0.90
		hero.set_tactical_order(order_id)
		hero.set_combat_bounds(bounds)
		battlefield.add_child(hero)
		hero.enable_placement_regions(placement_regions)
		hero.set_process(false)
		heroes.append(hero)
		units.append(hero)

	var enemy_positions: PackedVector2Array = encounter.get_enemy_positions_for_formation(variant)
	for i in range(encounter.enemy_unit_paths.size()):
		var enemy_data := load(encounter.enemy_unit_paths[i]) as UnitData
		if enemy_data == null:
			errors.append("%s: enemy data missing" % encounter.encounter_id)
			break
		var enemy := UNIT_SCENE.instantiate() as BattleUnit
		enemy.configure(enemy_data, 1, _project_spawn(enemy_positions[i], bounds))
		enemy.max_hp *= RunState.get_enemy_hp_multiplier()
		enemy.damage *= RunState.get_enemy_damage_multiplier()
		enemy.support_heal_amount *= RunState.get_enemy_hp_multiplier()
		enemy.set_combat_bounds(bounds)
		battlefield.add_child(enemy)
		enemy.set_process(false)
		enemies.append(enemy)
		units.append(enemy)

	if not errors.is_empty():
		battlefield.queue_free()
		await get_tree().process_frame
		return {}

	_start_trace(units)
	for unit in units:
		unit.start_combat()

	var elapsed := 0.0
	var outcome := "timeout"
	var max_steps: int = int(ceil(MAX_BATTLE_SECONDS / STEP_SECONDS))
	for step in range(max_steps):
		for unit in units:
			if unit.alive:
				unit._process(STEP_SECONDS)
		_observe_trace(STEP_SECONDS)
		elapsed += STEP_SECONDS
		var heroes_alive := 0
		var enemies_alive := 0
		for hero in heroes:
			if hero.alive:
				heroes_alive += 1
		for enemy in enemies:
			if enemy.alive:
				enemies_alive += 1
		if enemies_alive == 0:
			outcome = "win"
			break
		if heroes_alive == 0:
			outcome = "loss"
			break
		if (step + 1) % FRAMES_PER_YIELD == 0:
			await get_tree().process_frame

	var survivors := 0
	var enemy_survivors := 0
	for hero in heroes:
		if hero.alive:
			survivors += 1
	for enemy in enemies:
		if enemy.alive:
			enemy_survivors += 1
	var measurements: Dictionary = _finish_trace(encounter.encounter_id, variant, party_size, protagonist, order_id, profile, sample_index)
	battlefield.queue_free()
	await get_tree().process_frame
	return {
		"hero_attacks": measurements["hero_attacks"],
		"hero_damage": measurements["hero_damage"],
		"enemy_damage": measurements["enemy_damage"],
		"enemy_healing": measurements["enemy_healing"],
		"hero_chase_seconds": measurements["hero_chase_seconds"],
		"hero_support_focus_seconds": measurements["hero_support_focus_seconds"],
		"hero_target_switches": measurements["hero_target_switches"],
		"hero_travel": measurements["hero_travel"],
		"hero_support_attacks": measurements["hero_support_attacks"],
		"encounter": encounter.encounter_id,
		"variant": variant + 1,
		"party_size": party_size,
		"protagonist": protagonist,
		"party_roles": "+".join(RunState.party_roles),
		"order": order_id,
		"profile": profile,
		"sample": sample_index,
		"outcome": outcome,
		"seconds": snappedf(elapsed, 0.1),
		"survivors": survivors,
		"enemy_survivors": enemy_survivors
	}


func _apply_authored_build(unit: BattleUnit) -> void:
	# The exact modifier order from production Battle._spawn_unit().
	for upgrade in RunState.get_hero_upgrades_for_role(unit.visual_role):
		unit.max_hp += upgrade.hp_bonus
		unit.damage *= upgrade.damage_multiplier
		unit.attack_interval = maxf(0.2, unit.attack_interval * upgrade.attack_interval_multiplier)
		unit.attack_range += upgrade.attack_range_bonus
		unit.minimum_range += upgrade.minimum_range_bonus
		unit.splash_radius += upgrade.splash_radius_bonus
		unit.splash_damage_multiplier += upgrade.splash_damage_bonus
		unit.move_speed *= upgrade.move_speed_multiplier
	for artifact in RunState.get_artifacts_for_role(unit.visual_role):
		unit.max_hp += artifact.hp_bonus
		unit.damage *= artifact.damage_multiplier
		unit.attack_interval = maxf(0.2, unit.attack_interval * artifact.attack_interval_multiplier)
		unit.attack_range += artifact.attack_range_bonus
		unit.minimum_range += artifact.minimum_range_bonus
		unit.splash_radius += artifact.splash_radius_bonus
		unit.splash_damage_multiplier += artifact.splash_damage_bonus
		unit.move_speed *= artifact.move_speed_multiplier


func _hero_spawn_source(encounter_id: String, party_size: int, index: int) -> Vector2:
	# Mirrors the four relevant positioning profiles in battle.gd.
	var positions: Array[Vector2] = []
	if encounter_id == "gallows_volley" or encounter_id == "firing_square":
		match party_size:
			1:
				positions = [Vector2(290, 305)]
			2:
				positions = [Vector2(205, 245), Vector2(425, 365)]
			_:
				positions = [Vector2(185, 225), Vector2(330, 305), Vector2(480, 385)]
	else:
		match party_size:
			1:
				positions = [Vector2(220, 245)]
			2:
				positions = [Vector2(205, 190), Vector2(445, 325)]
			_:
				positions = [Vector2(190, 175), Vector2(285, 365), Vector2(445, 260)]
	return positions[index]


func _project_spawn(source: Vector2, bounds: Rect2) -> Vector2:
	var depth: float = clampf((source.y - 130.0) / 275.0, 0.0, 1.0)
	return Vector2(source.x, lerpf(bounds.position.y + 32.0, bounds.end.y - 32.0, depth))



func _start_trace(units: Array[BattleUnit]) -> void:
	trace_units = units
	trace_stats.clear()
	for unit in units:
		trace_stats[unit.get_instance_id()] = {
			"unit": unit,
			"role": unit.visual_role,
			"team": unit.team,
			"attacks": 0,
			"support_attacks": 0,
			"damage_out": 0.0,
			"damage_in": 0.0,
			"healing_out": 0.0,
			"healing_in": 0.0,
			"chase": 0.0,
			"support_focus": 0.0,
			"in_range": 0.0,
			"travel": 0.0,
			"switches": 0,
			"last_target": 0,
			"last_position": unit.position
		}
		unit.diagnostic_attack.connect(_on_trace_attack)
		unit.diagnostic_damage.connect(_on_trace_damage)
		unit.diagnostic_heal.connect(_on_trace_heal)


func _on_trace_attack(attacker: BattleUnit, victim: BattleUnit) -> void:
	var key: int = attacker.get_instance_id()
	if not trace_stats.has(key):
		return
	var item: Dictionary = trace_stats[key]
	item["attacks"] = int(item["attacks"]) + 1
	if victim.support_heal_interval > 0.0:
		item["support_attacks"] = int(item["support_attacks"]) + 1


func _on_trace_damage(attacker: BattleUnit, victim: BattleUnit, amount: float) -> void:
	if trace_stats.has(attacker.get_instance_id()):
		var dealt: Dictionary = trace_stats[attacker.get_instance_id()]
		dealt["damage_out"] = float(dealt["damage_out"]) + amount
	if trace_stats.has(victim.get_instance_id()):
		var received: Dictionary = trace_stats[victim.get_instance_id()]
		received["damage_in"] = float(received["damage_in"]) + amount


func _on_trace_heal(healer: BattleUnit, recipient: BattleUnit, amount: float) -> void:
	if trace_stats.has(healer.get_instance_id()):
		var entry: Dictionary = trace_stats[healer.get_instance_id()]
		entry["healing_out"] = float(entry["healing_out"]) + amount
	if trace_stats.has(recipient.get_instance_id()):
		var target_entry: Dictionary = trace_stats[recipient.get_instance_id()]
		target_entry["healing_in"] = float(target_entry["healing_in"]) + amount


func _observe_trace(delta: float) -> void:
	for unit in trace_units:
		var item: Dictionary = trace_stats[unit.get_instance_id()]
		item["travel"] = float(item["travel"]) + unit.position.distance_to(item["last_position"])
		item["last_position"] = unit.position
		if not unit.alive or unit.team != 0:
			continue
		var target_unit: BattleUnit = unit.target
		var target_id: int = target_unit.get_instance_id() if is_instance_valid(target_unit) else 0
		if target_id != int(item["last_target"]):
			if int(item["last_target"]) != 0:
				item["switches"] = int(item["switches"]) + 1
			item["last_target"] = target_id
		if target_unit == null or not is_instance_valid(target_unit) or not target_unit.alive:
			continue
		if target_unit.support_heal_interval > 0.0:
			item["support_focus"] = float(item["support_focus"]) + delta
		var distance: float = unit.global_position.distance_to(target_unit.global_position)
		if distance > unit.attack_range + target_unit.body_radius:
			item["chase"] = float(item["chase"]) + delta
		elif distance >= unit.minimum_range + target_unit.body_radius:
			item["in_range"] = float(item["in_range"]) + delta


func _finish_trace(encounter_id: String, variant: int, party_size: int,
		protagonist: String, order_id: String, profile: String, sample_index: int) -> Dictionary:
	var totals := {
		"hero_attacks": 0,
		"hero_support_attacks": 0,
		"hero_damage": 0.0,
		"enemy_damage": 0.0,
		"enemy_healing": 0.0,
		"hero_chase_seconds": 0.0,
		"hero_support_focus_seconds": 0.0,
		"hero_target_switches": 0,
		"hero_travel": 0.0
	}
	for unit in trace_units:
		var item: Dictionary = trace_stats[unit.get_instance_id()]
		if unit.team == 0:
			totals["hero_attacks"] += int(item["attacks"])
			totals["hero_support_attacks"] += int(item["support_attacks"])
			totals["hero_damage"] += float(item["damage_out"])
			totals["hero_chase_seconds"] += float(item["chase"])
			totals["hero_support_focus_seconds"] += float(item["support_focus"])
			totals["hero_target_switches"] += int(item["switches"])
			totals["hero_travel"] += float(item["travel"])
		else:
			totals["enemy_damage"] += float(item["damage_out"])
			totals["enemy_healing"] += float(item["healing_out"])
		per_unit_rows.append({
			"encounter": encounter_id,
			"variant": variant + 1,
			"party_size": party_size,
			"protagonist": protagonist,
			"order": order_id,
			"profile": profile,
			"sample": sample_index,
			"role": String(item["role"]),
			"team": int(item["team"]),
			"attacks": int(item["attacks"]),
			"support_attacks": int(item["support_attacks"]),
			"damage_out": float(item["damage_out"]),
			"damage_in": float(item["damage_in"]),
			"healing_out": float(item["healing_out"]),
			"healing_in": float(item["healing_in"]),
			"chase_seconds": float(item["chase"]),
			"support_focus_seconds": float(item["support_focus"]),
			"in_range_seconds": float(item["in_range"]),
			"travel": float(item["travel"]),
			"target_switches": int(item["switches"]),
			"alive": int(unit.alive)
		})
	trace_units.clear()
	trace_stats.clear()
	return totals


func _write_results() -> void:
	var csv := FileAccess.open(RESULTS_FILE, FileAccess.WRITE)
	if csv == null:
		errors.append("Cannot write case CSV: %s" % RESULTS_FILE)
		return
	csv.store_line("encounter,variant,party_size,protagonist,party_roles,order,profile,sample,outcome,seconds,hero_survivors,enemy_survivors,hero_attacks,hero_support_attacks,hero_damage,enemy_damage,enemy_healing,hero_chase_seconds,hero_support_focus_seconds,hero_target_switches,hero_travel")
	for result in results:
		csv.store_csv_line(PackedStringArray([
			String(result["encounter"]), str(result["variant"]), str(result["party_size"]),
			String(result["protagonist"]), String(result["party_roles"]), String(result["order"]),
			String(result["profile"]), str(result["sample"]), String(result["outcome"]),
			str(result["seconds"]), str(result["survivors"]), str(result["enemy_survivors"]),
			str(result["hero_attacks"]), str(result["hero_support_attacks"]),
			str(result["hero_damage"]), str(result["enemy_damage"]), str(result["enemy_healing"]),
			str(result["hero_chase_seconds"]), str(result["hero_support_focus_seconds"]),
			str(result["hero_target_switches"]), str(result["hero_travel"])
		]))
	csv.close()

	var unit_csv := FileAccess.open(UNIT_RESULTS_FILE, FileAccess.WRITE)
	if unit_csv == null:
		errors.append("Cannot write unit CSV: %s" % UNIT_RESULTS_FILE)
		return
	unit_csv.store_line("encounter,variant,party_size,protagonist,order,profile,sample,role,team,attacks,support_attacks,damage_out,damage_in,healing_out,healing_in,chase_seconds,support_focus_seconds,in_range_seconds,travel,target_switches,alive")
	for item in per_unit_rows:
		unit_csv.store_csv_line(PackedStringArray([
			String(item["encounter"]), str(item["variant"]), str(item["party_size"]),
			String(item["protagonist"]), String(item["order"]), String(item["profile"]),
			str(item["sample"]), String(item["role"]), str(item["team"]),
			str(item["attacks"]), str(item["support_attacks"]), str(item["damage_out"]),
			str(item["damage_in"]), str(item["healing_out"]), str(item["healing_in"]),
			str(item["chase_seconds"]), str(item["support_focus_seconds"]),
			str(item["in_range_seconds"]), str(item["travel"]),
			str(item["target_switches"]), str(item["alive"])
		]))
	unit_csv.close()
