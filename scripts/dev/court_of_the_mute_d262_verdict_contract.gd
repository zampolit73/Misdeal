extends Control

# D262: headless contract for genuine BattleUnit instances, not placeholder art.
const UNIT_SCENE: PackedScene = preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/court_of_the_mute.tres")
const VERDICT_SCRIPT := preload("res://scripts/battle/court_verdict.gd")
const ART_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")

func _ready() -> void:
	call_deferred("_run_contract")

func _run_contract() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has("court_of_the_mute"):
		_fail("unreleased card #39 changed normal 38-card pool")
		return
	var card: RunCardData = RunState.get_card("court_of_the_mute")
	if card == null or not card.target_path.is_empty():
		_fail("new card resource missing or prematurely pointed to incomplete battle")
		return
	if ENCOUNTER.encounter_id != "court_of_the_mute" or ENCOUNTER.get_formation_count() != 2:
		_fail("Court encounter ID or two formations missing")
		return
	if ENCOUNTER.enemy_unit_paths.size() != 4 or ENCOUNTER.enemy_names.size() != 4:
		_fail("Court must contain exactly four original combat units")
		return

	var roles: Array[String] = []
	for i in range(ENCOUNTER.enemy_unit_paths.size()):
		var data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		if data == null or data.max_hp <= 0.0:
			_fail("Court unit resource invalid")
			return
		roles.append(data.visual_role)
	if roles != ["mute_magistrate", "ash_scrivener", "bone_bailiff", "bone_bailiff"]:
		_fail("reused actor role or wrong Court roster")
		return
	for role in ["mute_magistrate", "ash_scrivener", "bone_bailiff"]:
		if ART_LIBRARY.get_frames(role) != null:
			_fail("unfinished Court enemy art should NOT be registered globally")
			return

	var stage := Node2D.new()
	add_child(stage)
	var heroes: Array[BattleUnit] = []
	for i in range(3):
		var data := UnitData.new()
		data.unit_name = "Hero %d" % i
		data.visual_role = "knight"
		data.max_hp = 125.0
		var actor := UNIT_SCENE.instantiate() as BattleUnit
		actor.configure(data, 0, Vector2(240.0 + i * 90.0, 285.0 + i * 25.0))
		stage.add_child(actor)
		heroes.append(actor)
	var guards: Array[BattleUnit] = []
	var scrivener: BattleUnit = null
	for i in range(4):
		var data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var enemy := UNIT_SCENE.instantiate() as BattleUnit
		var loc: Vector2 = ENCOUNTER.enemy_positions[i]
		enemy.configure(data, 1, loc)
		stage.add_child(enemy)
		if enemy.visual_role == "ash_scrivener":
			scrivener = enemy
		if enemy.visual_role == "bone_bailiff":
			guards.append(enemy)
	if not is_instance_valid(scrivener) or guards.size() != 2:
		_fail("original Court units failed to instantiate")
		return

	var verdict := VERDICT_SCRIPT.new() as CourtVerdictController
	stage.add_child(verdict)
	verdict.configure(scrivener, guards, heroes)
	verdict.set_process(false) # deterministic headless time, NOT double stepping
	verdict.start_verdict()
	verdict.set_process(false)
	if not verdict.running or verdict.phase != "rest":
		_fail("controller did not start in rest warning lead-in")
		return
	verdict.advance_battle(1.05)
	if verdict.phase != "warning" or not is_instance_valid(verdict.marked_hero):
		_fail("visible warned seal/marked hero missing")
		return
	var marked := verdict.marked_hero
	if guards[0].target == marked or guards[1].target == marked:
		_fail("bailiffs focused hero BEFORE warning finished")
		return
	verdict.advance_battle(1.45)
	if verdict.phase != "active" or guards[0].target != marked or guards[1].target != marked:
		_fail("two bailiffs failed to target exactly the warned hero")
		return
	verdict.advance_battle(2.55)
	if verdict.phase != "rest" or guards[0].target != null or guards[1].target != null:
		_fail("bailiffs did not release target after 2.5s verdict")
		return
	verdict.advance_battle(3.65)
	if verdict.phase != "warning" or verdict.warnings != 2:
		_fail("second Court warning not scheduled")
		return
	verdict.advance_battle(1.45)
	if verdict.phase != "active":
		_fail("second verdict failed")
		return
	scrivener.alive = false
	verdict.advance_battle(0.05)
	if verdict.running or verdict.phase != "idle" or verdict.interrupted != 1 or guards[0].target != null or guards[1].target != null:
		_fail("killing scribe did not immediately clear and stop verdict targeting")
		return
	if verdict.warnings != 2 or verdict.verdicts != 2 or verdict.bailiff_redirects < 4:
		_fail("actual Court mechanics counters missing")
		return
	print("D262_COURT_VERDICT_PASS: QA-only card, all 3 novel original UnitData roles, 2 formations, warning then 2-bailiff focus, expiry clears, dead-scribe cancels")
	get_tree().quit(0)

func _fail(message: String) -> void:
	push_error("D262_COURT_VERDICT_FAIL: " + message)
	get_tree().quit(1)
