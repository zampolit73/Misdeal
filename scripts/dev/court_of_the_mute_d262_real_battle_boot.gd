extends Control

# D262 HEADLESS ONLY: builds real Battle (not a false preview with old art)
# with the new original Court roster for solo/duo/trio and both deployments.
# This is NOT a visual arena/art PASS and does not release card #39.
const BATTLE: PackedScene = preload("res://scenes/battle/battle.tscn")
const CARD_ID := "court_of_the_mute"
const ENCOUNTER := "res://resources/encounters/court_of_the_mute.tres"
const EXPECTED := ["mute_magistrate", "ash_scrivener", "bone_bailiff", "bone_bailiff"]
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const OTHER_ARENA_EXPECTED := Rect2(Vector2(90, 284), Vector2(1080, 158))

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
			# D264 screenshot fix: feet, actor AI bounds and draggable region
			# must all be on the lower floor in EVERY party and formation.
			var world_bounds: Rect2 = court.scrivener.combat_bounds
			if world_bounds != COURT_FLOOR.COMBAT_BOUNDS:
				_abort("Court did not receive lower stone floor combat bounds")
				return
			if world_bounds.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y < COURT_FLOOR.FLOOR_TOP_SCREEN_Y:
				_abort("Court combat begins on decorative stairs")
				return
			if world_bounds.end.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y > COURT_FLOOR.FLOOR_BOTTOM_SCREEN_Y:
				_abort("Court combat overflows lower floor")
				return
			for check_unit in all:
				var actor := check_unit as BattleUnit
				if actor.combat_bounds != COURT_FLOOR.COMBAT_BOUNDS:
					_abort("Court unit lacks shared lower-floor movement bounds")
					return
				if not COURT_FLOOR.COMBAT_BOUNDS.has_point(actor.position):
					_abort("Court actor spawned off the walkable floor")
					return
				if actor.team == 0:
					if actor.placement_bounds != COURT_FLOOR.PLACEMENT_BOUNDS:
						_abort("Court hero drag region not moved onto floor")
						return
					if not COURT_FLOOR.PLACEMENT_BOUNDS.has_point(actor.position):
						_abort("Court hero started outside authored drag lane")
						return
			if actor.team == 1 and actor.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y < COURT_FLOOR.FLOOR_TOP_SCREEN_Y:
					_abort("Court enemy placed on the throne stairs")
					return
			if actor.team == 1 and actor.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y > COURT_FLOOR.FLOOR_BOTTOM_SCREEN_Y:
					_abort("Court enemy placed below lower stone floor")
					return
			if actor.team == 0 and actor.combat_bounds == OTHER_ARENA_EXPECTED:
					_abort("Court inherited the default arena bounds")
					return
			if actor.team == 1 and actor.combat_bounds == OTHER_ARENA_EXPECTED:
					_abort("Court reused generic arena geometry")
					return
			if actor.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y < COURT_FLOOR.FLOOR_TOP_SCREEN_Y:
					_abort("Court actor feet overlap decorative steps")
					return
			if actor.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y > COURT_FLOOR.FLOOR_BOTTOM_SCREEN_Y:
					_abort("Court actor feet overflow screen")
					return
			if not world_bounds.has_point(actor.position):
					_abort("Court placement leaked beyond real combat bounds")
					return
			if actor.team == 0 and actor.position.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y >= 574.0:
					_abort("Court hero starts behind preparation HUD")
					return
			if actor.team == 1 and actor.position.x < 700.0:
					_abort("Court enemy spawn crossed hero-side formation")
					return
			if actor.team == 0 and actor.position.x > 590.0:
					_abort("Court hero spawn crossed enemy-side formation")
					return
			if actor.team == 1 and actor.position.x > COURT_FLOOR.COMBAT_BOUNDS.end.x:
					_abort("Court enemy spawn outside far floor bound")
					return
			if actor.team == 0 and actor.position.x < COURT_FLOOR.COMBAT_BOUNDS.position.x:
					_abort("Court hero spawn outside near floor bound")
					return
			if actor.combat_bounds != world_bounds:
					_abort("Court actors do not share common floor")
					return
			if actor.team == 0 and not COURT_FLOOR.COMBAT_BOUNDS.encloses(actor.placement_bounds):
					_abort("Court hero drag area is outside the lower floor")
					return
			if actor.team == 0 and actor.placement_bounds.end.y + COURT_FLOOR.UNITS_LAYER_OFFSET.y >= 610.0:
					_abort("Court pre-fight placement overlaps too much HUD")
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
