extends Control

# D268: unreleased Court #39, deterministic BattleUnit matrix (NOT visual approval).
# 2 Court formations × 3 protagonists × 3 party sizes × 3 ordinary tactics.
# Follows D260 BattleUnit diagnostic and D262 encounter-scoped verdict contract.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/court_of_the_mute.tres")
const VERDICT_SCRIPT := preload("res://scripts/battle/court_verdict.gd")
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const CARD_ID := "court_of_the_mute"
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const EXPECTED_ENEMY_ROLES: Array[String] = [
	"mute_magistrate", "ash_scrivener", "bone_bailiff", "bone_bailiff"
]
const STEP: float = 1.0 / 30.0
const MAX_SECONDS: float = 90.0
const TOTAL_CASES: int = 54

var failures: Array[String] = []
var completed := 0
var victories := 0
var defeats := 0
var timeouts := 0
var wins_by_party_size: Array[int] = [0, 0, 0]
var wins_by_protagonist: Array[int] = [0, 0, 0]
var hp_by_size: Array[float] = [0.0, 0.0, 0.0]
var worst_hp_by_size: Array[float] = [1.0, 1.0, 1.0]
var duration_by_size: Array[float] = [0.0, 0.0, 0.0]
var fallen_by_size: Array[int] = [0, 0, 0]
var warnings := 0
var verdicts := 0
var redirects := 0
var scrivener_interruptions := 0


func _ready() -> void:
	call_deferred("_run_matrix")


func _check_contract() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		failures.append("Court #39 must stay unreleased; Act1 is 38/45")
	var card: RunCardData = RunState.get_card(CARD_ID)
	if card == null or not card.target_path.is_empty() or card.resolution_type != "combat":
		failures.append("Court QA card must have combat resolution and empty target_path")
	if ENCOUNTER.encounter_id != CARD_ID or ENCOUNTER.get_formation_count() != 2:
		failures.append("Court must have 2 original formations")
	if ENCOUNTER.enemy_unit_paths.size() != 4:
		failures.append("Court must have Judge, Scribe, Bailiff x2")
	else:
		for i in range(4):
			var data: UnitData = load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
			if data == null or data.visual_role != EXPECTED_ENEMY_ROLES[i]:
				failures.append("Court original enemy role #%d is not authored" % i)
	for role in ["mute_magistrate", "ash_scrivener", "bone_bailiff"]:
		var frames: SpriteFrames = ANIMATION_LIBRARY.get_frames(role)
		if frames == null:
			failures.append("D267 rich Court animation not registered: " + role)
			continue
		for state in ["idle", "walk", "attack", "hit", "death"]:
			if not frames.has_animation(state):
				failures.append("D267 original animation missing " + role + ":" + state)
	for formation in range(2):
		var points: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
		if points.size() != 4:
			failures.append("Court invalid formation: %d" % formation)
			continue
		for point in points:
			if not COURT_FLOOR.COMBAT_BOUNDS.has_point(_project_floor(point)):
				failures.append("Court enemy spawned off user-selected bottom floor")


# Exact Court branch of real battle.gd::_project_spawn_on_floor().
func _project_floor(source: Vector2) -> Vector2:
	var bounds: Rect2 = COURT_FLOOR.COMBAT_BOUNDS
	var depth: float = clampf((source.y - 130.0) / 275.0, 0.0, 1.0)
	return Vector2(source.x, lerpf(bounds.position.y + 25.0, bounds.position.y + 35.0, depth))


func _hero_positions(count: int) -> Array[Vector2]:
	match count:
		1:
			return [Vector2(300, 245)]
		2:
			return [Vector2(200, 205), Vector2(435, 340)]
		_:
			return [Vector2(185, 195), Vector2(335, 280), Vector2(490, 370)]


func _make_unit(arena: Node2D, data: UnitData, team: int, point: Vector2, order: String) -> BattleUnit:
	var unit: BattleUnit = UNIT_SCENE.instantiate() as BattleUnit
	if unit == null or data == null:
		failures.append("Court real BattleUnit or original UnitData missing")
		return null
	unit.configure(data, team, _project_floor(point))
	unit.set_arena_presentation(ENCOUNTER.arena_id)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval = maxf(0.2, unit.attack_interval * RunState.get_party_attack_interval_multiplier())
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(order)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
		unit.support_heal_amount *= RunState.get_enemy_hp_multiplier()
	unit.set_combat_bounds(COURT_FLOOR.COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	# BattleUnit receives its visual SpriteFrames in _ready(), which runs only
	# after add_child. Checking earlier falsely reported four missing atlases.
	if team == 1 and (unit.sprite_frames == null or unit.sprite_frames != ANIMATION_LIBRARY.get_frames(data.visual_role)):
		failures.append("Court unit did not use rich original D267 art: " + data.visual_role)
	return unit


func _fight(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	if not RunState.choose_protagonist(HERO_ROLES[protagonist]):
		failures.append("Court protagonist setup failed")
		return {}
	for member in range(1, party_size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + member) % HERO_ROLES.size()], "D268 Court matrix")

	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var all_units: Array[BattleUnit] = []
	var heroes: Array[BattleUnit] = []
	var guards: Array[BattleUnit] = []
	var scribe: BattleUnit = null
	var starts: Array[Vector2] = _hero_positions(party_size)
	for i in range(RunState.party_roles.size()):
		var data: UnitData = RunState.get_hero_unit_data(String(RunState.party_roles[i]))
		var actor: BattleUnit = _make_unit(arena, data, 0, starts[i], tactic)
		if actor == null:
			arena.free()
			return {}
		actor.enable_placement_regions([COURT_FLOOR.PLACEMENT_BOUNDS])
		heroes.append(actor)
		all_units.append(actor)
	for i in range(ENCOUNTER.enemy_unit_paths.size()):
		var enemy_data: UnitData = load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var enemy: BattleUnit = _make_unit(arena, enemy_data, 1, ENCOUNTER.get_enemy_positions_for_formation(formation)[i], tactic)
		if enemy == null:
			arena.free()
			return {}
		all_units.append(enemy)
		if enemy.visual_role == "ash_scrivener":
			scribe = enemy
		elif enemy.visual_role == "bone_bailiff":
			guards.append(enemy)

	if scribe == null or guards.size() != 2 or heroes.size() != party_size:
		failures.append("Court verdict roster configuration failed")
		arena.free()
		return {}
	var verdict: CourtVerdictController = VERDICT_SCRIPT.new() as CourtVerdictController
	arena.add_child(verdict)
	verdict.configure(scribe, guards, heroes)
	for unit in all_units:
		unit.start_combat()
	verdict.start_verdict()
	verdict.set_process(false)

	var elapsed := 0.0
	var outcome := ""
	var step_count := 0
	while elapsed < MAX_SECONDS:
		verdict.advance_battle(STEP)
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
			var rad: float = unit.body_radius
			var bounds: Rect2 = COURT_FLOOR.COMBAT_BOUNDS
			if unit.position.x < bounds.position.x + rad - 0.01 or unit.position.x > bounds.end.x - rad + 0.01 or unit.position.y < bounds.position.y + rad - 0.01 or unit.position.y > bounds.end.y - rad + 0.01:
				failures.append("Court actor left the user-selected lower floor: " + unit.display_name)
				break
		if not failures.is_empty():
			break
		elapsed += STEP
		step_count += 1
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
		if step_count % 90 == 0:
			await get_tree().process_frame

	warnings += verdict.warnings
	verdicts += verdict.verdicts
	redirects += verdict.bailiff_redirects
	scrivener_interruptions += verdict.interrupted
	if not scribe.alive and verdict.running:
		failures.append("Verdict continued after Scrivener died")
	verdict.stop_verdict()
	if verdict.marked_hero != null or not verdict.affected_bailiffs.is_empty():
		failures.append("Verdict left locked targets after cleanup")
	var hp_fraction := 0.0
	var lost := 0
	for unit in heroes:
		hp_fraction += clampf(unit.hp / maxf(1.0, unit.max_hp), 0.0, 1.0)
		if not unit.alive:
			lost += 1
	arena.free()
	await get_tree().process_frame
	return {
		"outcome": outcome,
		"duration": elapsed,
		"hp_fraction": hp_fraction / float(party_size),
		"hero_deaths": lost
	}


func _run_matrix() -> void:
	_check_contract()
	if failures.is_empty():
		await get_tree().process_frame
		for formation in range(2):
			for protagonist in range(3):
				for party_size in range(1, 4):
					for tactic in TACTICS:
						seed(268000 + formation * 1000 + protagonist * 100 + party_size * 10 + TACTICS.find(tactic))
						var result: Dictionary = await _fight(formation, protagonist, party_size, tactic)
						if result.is_empty():
							failures.append("Court case returned no BattleUnit result")
							break
						completed += 1
						var outcome: String = String(result["outcome"])
						if outcome == "win":
							victories += 1
							wins_by_party_size[party_size - 1] += 1
							wins_by_protagonist[protagonist] += 1
						elif outcome == "loss":
							defeats += 1
						else:
							timeouts += 1
						hp_by_size[party_size - 1] += float(result["hp_fraction"])
						worst_hp_by_size[party_size - 1] = minf(worst_hp_by_size[party_size - 1], float(result["hp_fraction"]))
						duration_by_size[party_size - 1] += float(result["duration"])
						fallen_by_size[party_size - 1] += int(result["hero_deaths"])
						if not failures.is_empty():
							break
					if not failures.is_empty():
						break
				if not failures.is_empty():
					break
			if not failures.is_empty():
				break

	RunState.reset_run()
	if completed != TOTAL_CASES:
		failures.append("Court matrix incomplete: %d/54" % completed)
	if victories + defeats + timeouts != completed:
		failures.append("Court matrix outcomes not accounted for")
	if timeouts != 0:
		failures.append("Court BattleUnit simulated timeouts: %d" % timeouts)
	if warnings == 0 or verdicts == 0 or redirects == 0:
		failures.append("Court warning/focus mechanic did not activate across 54 cases")
	var report := {
		"version": "D268_QA_ONLY",
		"completed": completed,
		"wins": victories,
		"losses": defeats,
		"timeouts": timeouts,
		"wins_by_party_size": wins_by_party_size,
		"wins_by_protagonist": wins_by_protagonist,
		"average_hero_hp_by_party_size": [
			snappedf(hp_by_size[0] / 18.0, 0.0001),
			snappedf(hp_by_size[1] / 18.0, 0.0001),
			snappedf(hp_by_size[2] / 18.0, 0.0001)
		],
		"worst_hero_hp_by_party_size": worst_hp_by_size,
		"average_seconds_by_party_size": [
			snappedf(duration_by_size[0] / 18.0, 0.0001),
			snappedf(duration_by_size[1] / 18.0, 0.0001),
			snappedf(duration_by_size[2] / 18.0, 0.0001)
		],
		"fallen_by_party_size": fallen_by_size,
		"verdict_warnings": warnings,
		"verdict_activations": verdicts,
		"bailiff_redirects": redirects,
		"scrivener_interruptions": scrivener_interruptions,
		"failures": failures,
		"card39_live": false
	}
	print("D268_COURT_BALANCE_DIAGNOSTICS ", JSON.stringify(report))
	if failures.is_empty():
		print("D268_COURT_54_CASE_FUNCTIONAL_PASS: all 54 original Court BattleUnit fights complete; release/art gate still open")
	else:
		push_error("D268_COURT_54_CASE_FUNCTIONAL_FAIL: " + "; ".join(failures))
	get_tree().quit(0 if failures.is_empty() else 1)
