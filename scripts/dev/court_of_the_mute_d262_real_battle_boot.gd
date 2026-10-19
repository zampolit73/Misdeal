extends Control

# D262 HEADLESS ONLY: builds real Battle (not a false preview with old art)
# with the new original Court roster for solo/duo/trio and both deployments.
# This is NOT a visual arena/art PASS and does not release card #39.
const BATTLE: PackedScene = preload("res://scenes/battle/battle.tscn")
const CARD_ID := "court_of_the_mute"
const ENCOUNTER := "res://resources/encounters/court_of_the_mute.tres"
const EXPECTED := ["mute_magistrate", "ash_scrivener", "bone_bailiff", "bone_bailiff"]

func _ready() -> void:
	call_deferred("_run_boot")

func _run_boot() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_abort("do not release Court before the actual original 25-frame art")
		return
	var result_cases := 0
	for party_size in [1, 2, 3]:
		for formation in [0, 1]:
			RunState.reset_run()
			if not RunState.choose_protagonist("knight"):
				_abort("could not set hero")
				return
			for index in range(1, party_size):
				var role: String = RunState.HERO_ROLES[index]
				RunState.party_roles.append(role)
				RunState.hero_fates[role] = RunState.FATE_JOINED
			RunState.active_card_id = CARD_ID
			RunState.select_encounter(ENCOUNTER)
			RunState.combat_formation_by_card[CARD_ID] = formation
			var battle := BATTLE.instantiate() as Control
			if battle == null:
				_abort("real Battle PackedScene missing")
				return
			add_child(battle)
			await get_tree().process_frame
			var selected: EncounterData = battle.get("encounter") as EncounterData
			var court: CourtVerdictController = battle.get("court_verdict_controller") as CourtVerdictController
			if selected == null or selected.encounter_id != CARD_ID or court == null:
				_abort("real Battle did not attach encounter-local verdict for %d-%d" % [party_size, formation])
				return
			if int(battle.get("enemy_formation_variant")) != formation:
				_abort("real Battle ignores authored formation")
				return
			if battle.get("black_lantern_light_controller") != null:
				_abort("foreign #38 lantern controller leaked into Court")
				return
			var enemy_roles: Array[String] = []
			var hero_count := 0
			var all: Array = battle.get("units")
			for entry in all:
				var actor := entry as BattleUnit
				if actor == null:
					_abort("not genuine BattleUnit")
					return
				if actor.team == 0:
					hero_count += 1
				else:
					enemy_roles.append(actor.visual_role)
			enemy_roles.sort()
			var expected := EXPECTED.duplicate()
			expected.sort()
			if enemy_roles != expected or hero_count != party_size or court.bailiffs.size() != 2:
				_abort("invalid roster size %d-%d, roles %s" % [party_size, formation, enemy_roles])
				return
			if court.running or court.phase != "idle":
				_abort("verdict started during placement, before Fight")
				return
			if not court.scrivener.alive:
				_abort("expected original scrivener alive before Fight")
				return
			court.start_verdict()
			court.set_process(false)
			court.advance_battle(1.01)
			if court.phase != "warning":
				_abort("verdict warning absent in native Battle")
				return
			court.advance_battle(1.41)
			if court.phase != "active" or court.bailiffs[0].target != court.marked_hero or court.bailiffs[1].target != court.marked_hero:
				_abort("bailiffs ignored real Battle hero mark")
				return
			court.stop_verdict()
			if court.bailiffs[0].target != null or court.bailiffs[1].target != null:
				_abort("mark did not clear in real Battle")
				return
			battle.queue_free()
			await get_tree().process_frame
			result_cases += 1
	print("D262_COURT_REAL_BATTLE_PASS: 6 genuine Battle startup cases (solo/duo/trio x 2 formations); 4 new actors, warned + focused verdict only in Court, 38-card live pool unchanged")
	get_tree().quit(0)

func _abort(message: String) -> void:
	push_error("D262_COURT_REAL_BATTLE_FAIL: " + message)
	get_tree().quit(1)
