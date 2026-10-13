extends Control

# F6-only Gameplay 2.4 benchmark: same protagonist, fixed companion order,
# authored layouts and seeds. Real BattleUnit combat and target-preview checks.
# Built late-tier heroes use actual authored upgrade/artifact Resources.
# Not a real Act 1 progression/win-rate test; no Wizard risks or reward flow.
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
const RESULTS_FILE := "user://misdeal_tactical_v24_party_focus.csv"

var errors: Array[String] = []
var results: Array[Dictionary] = []
var status_label: Label
var title_label: Label
var total_trials := 0


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

	# Last Bell: 2 layouts × 3 protagonists × 3 party sizes × 3 orders = 54.
	# Two advanced cards: 2 × 2 layouts × 3 protagonists × 3 party sizes
	# × 3 orders × 2 identical-seed replicates = 216.
	total_trials = 2 * HERO_ROLES.size() * 3 * ORDER_IDS.size() * (1 + 2 * REPEAT_LATE_SEEDS)
	title_label.text = "TACTICAL GAMEPLAY 2.4 — RUNNING"
	status_label.text = "Проверка общего фокуса и %d боёв с закреплёнными героями..." % total_trials
	var targeting_ok: bool = await _validate_hunt_focus()
	if targeting_ok:
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
		title_label.text = "TACTICAL GAMEPLAY 2.4 — PASS"
		status_label.text = ("%d/%d боёв завершились. Побед: %d, поражений: %d.\n"
			+ "ОХОТА: общий звонарь, ослабленная цель, перехват — OK.\n"
			+ "3 главных героя × соло/дуо/трио, фиксированные спутники.\n"
			+ "Поздние бои: экипированные герои, два начальных зерна.\n"
			+ "CSV: %s\n"
			+ "PASS = механика работает, а НЕ гарантия баланса.") % [
			results.size(), total_trials, victories, defeats, RESULTS_FILE
		]
		status_label.add_theme_color_override("font_color", Color(0.56, 0.84, 0.69))
	else:
		title_label.text = "TACTICAL GAMEPLAY 2.4 — FAIL"
		status_label.text = ("%d/%d боёв записано.\n" % [results.size(), total_trials]) + "\n".join(errors.slice(0, 7))
		status_label.add_theme_color_override("font_color", Color(0.94, 0.45, 0.38))
		push_error(status_label.text)


func _run_benchmarks() -> void:
	for encounter_index in range(ENCOUNTER_IDS.size()):
		var encounter_id: String = ENCOUNTER_IDS[encounter_index]
		var encounter := load("res://resources/encounters/%s.tres" % encounter_id) as EncounterData
		if encounter == null or not EXPECTED_ROLES.has(encounter_id):
			errors.append("%s: missing card/encounter" % encounter_id)
			return
		if not _validate_encounter(encounter):
			return
		var card: RunCardData = RunState.get_card(encounter_id)
		if card == null:
			errors.append("%s: RunCardData missing" % encounter_id)
			return
		var is_late: bool = card.tier == 2
		var repeat_count: int = REPEAT_LATE_SEEDS if is_late else 1
		var profile: String = PROFILE_BUILT if is_late else PROFILE_BARE

		for variant in range(2):
			for protagonist_index in range(HERO_ROLES.size()):
				var protagonist: String = HERO_ROLES[protagonist_index]
				for sample_index in range(repeat_count):
					# Same card/layout/protagonist/seed for 1, 2 and 3 heroes,
					# as well as all three orders; companion order is fixed.
					var case_seed: int = 24000 + encounter_index * 10000 + variant * 1000 + protagonist_index * 100 + sample_index * 47
					for party_size in range(1, 4):
						for order_id in ORDER_IDS:
							seed(case_seed)
							var result: Dictionary = await _run_single_battle(encounter, variant, party_size, protagonist, order_id, profile, sample_index)
							if result.is_empty():
								return
							results.append(result)
							status_label.text = ("%d/%d боёв\n%s • строй %d • %s • %d героя\n"
								+ "%s • зерно %d | %s за %.1f сек, живы: %d\n"
								+ "Одинаковый главный герой и фиксированные спутники.") % [
								results.size(), total_trials, encounter.title, variant + 1,
								protagonist, party_size, order_id, sample_index + 1,
								result["outcome"], result["seconds"], result["survivors"]
							]
							if result["outcome"] == "timeout":
								errors.append("%s / строй %d / %s / %d / %s: >%.0f сек" % [
									encounter_id, variant + 1, protagonist, party_size, order_id, MAX_BATTLE_SECONDS
								])
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

	for unit in units:
		unit.start_combat()

	var elapsed := 0.0
	var outcome := "timeout"
	var max_steps: int = int(ceil(MAX_BATTLE_SECONDS / STEP_SECONDS))
	for step in range(max_steps):
		for unit in units:
			if unit.alive:
				# Godot's real combat method, advanced with a deterministic delta.
				# Automatic _process is disabled to avoid counting time twice.
				unit._process(STEP_SECONDS)
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
	battlefield.queue_free()
	await get_tree().process_frame
	return {
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


func _validate_hunt_focus() -> bool:
	# Two healthy bellkeepers must receive a SHARED first HUNT target;
	# once one is wounded, every hunter switches to that same healer.
	# D139's per-unit immediate-threat interception must still override
	# the shared target for a melee Knight, without affecting ranged allies.
	var sandbox := Node2D.new()
	sandbox.visible = false
	add_child(sandbox)
	var heroes: Array[BattleUnit] = []
	for i in range(HERO_ROLES.size()):
		var role: String = HERO_ROLES[i]
		var hero := UNIT_SCENE.instantiate() as BattleUnit
		hero.configure(RunState.get_hero_unit_data(role), 0, Vector2(200 + i * 120, 320))
		sandbox.add_child(hero)
		hero.set_process(false)
		hero.set_tactical_order("hunt")
		heroes.append(hero)

	var bell_a := UNIT_SCENE.instantiate() as BattleUnit
	bell_a.configure(load("res://resources/units/grave_bellkeeper.tres") as UnitData, 1, Vector2(850, 320))
	sandbox.add_child(bell_a)
	bell_a.set_process(false)
	var bell_b := UNIT_SCENE.instantiate() as BattleUnit
	bell_b.configure(load("res://resources/units/grave_bellkeeper.tres") as UnitData, 1, Vector2(1040, 320))
	sandbox.add_child(bell_b)
	bell_b.set_process(false)

	var first_focus := true
	for hero in heroes:
		if hero.get_preview_target() != bell_a:
			first_focus = false

	# The farther bellkeeper becomes wounded: focus must transfer together.
	bell_b.hp = bell_b.max_hp * 0.5
	var wounded_focus := true
	for hero in heroes:
		if hero.get_preview_target() != bell_b:
			wounded_focus = false

	var frontline := UNIT_SCENE.instantiate() as BattleUnit
	frontline.configure(load("res://resources/units/bone_raider.tres") as UnitData, 1, Vector2(310, 320))
	sandbox.add_child(frontline)
	frontline.set_process(false)
	var intercepts_correctly: bool = heroes[0].get_preview_target() == frontline
	var ranged_focus_ok: bool = heroes[1].get_preview_target() == bell_b and heroes[2].get_preview_target() == bell_b

	# A nearby wounded priority target restores support focus for Knight.
	bell_b.position = Vector2(345, 320)
	var reachable_focus: bool = heroes[0].get_preview_target() == bell_b

	var correct: bool = first_focus and wounded_focus and intercepts_correctly and ranged_focus_ok and reachable_focus
	sandbox.queue_free()
	await get_tree().process_frame
	if not correct:
		errors.append("HUNT focus: shared/wounded bellkeeper, melee interception or reachable target mismatch")
	return correct


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


func _write_results() -> void:
	var csv := FileAccess.open(RESULTS_FILE, FileAccess.WRITE)
	if csv == null:
		errors.append("Unable to write benchmark CSV at %s" % RESULTS_FILE)
		return
	csv.store_line("encounter,variant,party_size,protagonist,party_roles,order,profile,sample,outcome,seconds,hero_survivors,enemy_survivors")
	for result in results:
		csv.store_line("%s,%d,%d,%s,%s,%s,%s,%d,%s,%.1f,%d,%d" % [
			result["encounter"], result["variant"], result["party_size"],
			result["protagonist"], result["party_roles"], result["order"], result["profile"],
			result["sample"], result["outcome"], result["seconds"], result["survivors"], result["enemy_survivors"]
		])
	csv.close()
