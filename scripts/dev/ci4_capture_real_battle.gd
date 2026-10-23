extends SceneTree

# CI4: capture the REAL production Battle and its live BattleUnit animation.
# This is a read-only QA process, not a new gameplay scene or mock battle.
# Requires a rendering display (Xvfb/Mesa CI), never --headless.
const SIZE := Vector2i(1280, 720)
const BATTLE_SCENE := "res://scenes/battle/battle.tscn"
const ENCOUNTER := "res://resources/encounters/graveyard_ambush.tres"
const SAMPLE_TIMES := PackedFloat32Array([0.0, 0.30, 0.65, 1.05, 1.60])

var _battle: Control
var _output: String
var _lines: Array[String] = []
var _initial_positions: Dictionary = {}
var _max_movement := 0.0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].begins_with("/"):
		_fail("use -- <absolute output directory>")
		return
	_output = args[0]
	root.size = SIZE
	DirAccess.make_dir_recursive_absolute(_output)

	var state := root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("could not select authentic Knight protagonist")
		return
	# Use an existing shipped encounter with actual Knight vs two skeletons
	# and bone archer; no artificial enemies or fallback unit art.
	state.call("select_encounter", ENCOUNTER)

	var packed := load(BATTLE_SCENE) as PackedScene
	if packed == null:
		_fail("production Battle scene could not be loaded")
		return
	_battle = packed.instantiate() as Control
	if _battle == null:
		_fail("production Battle could not be instantiated")
		return
	root.add_child(_battle)
	await process_frame
	var encounter := _battle.get("encounter") as EncounterData
	var units: Array = _battle.get("units")
	if encounter == null or encounter.encounter_id != "graveyard_ambush":
		_fail("wrong live encounter selected")
		return
	var heroes := 0
	var enemies := 0
	for candidate in units:
		var unit := candidate as BattleUnit
		if unit == null or unit.sprite_frames == null:
			_fail("real Battle unit or sprite animation missing")
			return
		if unit.team == 0:
			heroes += 1
		elif unit.team == 1:
			enemies += 1
		_initial_positions[unit.get_instance_id()] = unit.position
	if heroes != 1 or enemies != 3:
		_fail("unexpected roster, wanted one original Knight and three authored skeleton enemies: " + str(heroes) + "/" + str(enemies))
		return

	_lines.append("frame,phase,live,finished,units_alive,max_movement_px")
	await create_timer(0.5).timeout
	if not await _save_frame("00-preparation", "preparation"):
		return

	var fight := _battle.get_node_or_null("FightButton") as Button
	if fight == null or fight.pressed.get_connections().is_empty():
		_fail("real Fight button signal missing")
		return
	fight.pressed.emit()
	await create_timer(0.33).timeout
	if not bool(_battle.get("combat_started")):
		_fail("Fight button failed to start authentic battle")
		return
	if not await _save_frame("01-intro", "intro"):
		return

	# The production intro is a real ~0.76s Tween, and only after it
	# finishes do BattleUnit actors actually start their AI.
	var intro_wait := 0.0
	while not bool(_battle.get("combat_live")) and intro_wait < 4.0:
		await create_timer(0.05).timeout
		intro_wait += 0.05
	if not bool(_battle.get("combat_live")):
		_fail("real combat never became live after intro")
		return

	var previous := 0.0
	var index := 2
	for elapsed in SAMPLE_TIMES:
		if elapsed > previous:
			await create_timer(elapsed - previous).timeout
		if not await _save_frame("%02d-live-%04dms" % [index, int(elapsed * 1000.0)], "combat"):
			return
		previous = elapsed
		index += 1

	# Real movement must be observable. This prevents a frozen QA still
	# from masquerading as a sequence of functioning autobattler frames.
	if _max_movement < 2.0:
		_fail("no native unit movement observed, max displacement=" + str(_max_movement))
		return
	var log_file := FileAccess.open(_output.path_join("battle-frame-metadata.csv"), FileAccess.WRITE)
	if log_file == null:
		_fail("cannot write frame motion metadata")
		return
	for line in _lines:
		log_file.store_line(line)
	log_file.close()
	print("CI4_BATTLE_CAPTURE_PASS: 7 original 1280x720 frames, units=1 hero+3 enemies, movement_px=", snappedf(_max_movement, 0.1))
	_battle.queue_free()
	await process_frame
	quit(0)

func _save_frame(label: String, phase: String) -> bool:
	await RenderingServer.frame_post_draw
	var frame := root.get_texture().get_image()
	if frame == null or frame.is_empty() or frame.get_size() != SIZE:
		_fail("missing 1280x720 renderer output: " + label)
		return false
	var lit := 0
	for y in range(20, SIZE.y, 31):
		for x in range(20, SIZE.x, 31):
			var c := frame.get_pixel(x, y)
			if c.r + c.g + c.b > 0.12:
				lit += 1
	if lit < 15:
		_fail("likely blank GPU framebuffer: " + label + " lit=" + str(lit))
		return false
	var path := _output.path_join(label + ".png")
	if frame.save_png(path) != OK:
		_fail("could not save actual Godot frame: " + path)
		return false
	var active := 0
	for candidate in _battle.get("units"):
		var unit := candidate as BattleUnit
		if unit != null:
			if unit.alive:
				active += 1
			var id := unit.get_instance_id()
			if _initial_positions.has(id):
				_max_movement = maxf(_max_movement, unit.position.distance_to(_initial_positions[id]))
	_lines.append("%s,%s,%s,%s,%d,%.2f" % [
		label, phase, str(_battle.get("combat_live")), str(_battle.get("battle_finished")), active, _max_movement
	])
	print("CI4_FRAME_PASS: ", label, " live=", _battle.get("combat_live"),
		" alive=", active, " max_movement_px=", snappedf(_max_movement, 0.1), " path=", path)
	return true

func _fail(message: String) -> void:
	push_error("CI4_BATTLE_CAPTURE_FAIL: " + message)
	quit(1)
