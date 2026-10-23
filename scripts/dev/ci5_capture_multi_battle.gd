extends SceneTree

# CI5 — original production Battle, with controlled temporary RunState.
# This separate Godot process never writes or replaces game saves.
const SIZE := Vector2i(1280, 720)
const BATTLE := "res://scenes/battle/battle.tscn"
const SCENARIOS := {
	"court-trio": {
		"encounter": "res://resources/encounters/court_of_the_mute.tres",
		"id": "court_of_the_mute",
		"card": "court_of_the_mute",
		"heroes": ["knight", "ranger", "mage"],
		"enemies": ["mute_magistrate", "ash_scrivener", "bone_bailiff", "bone_bailiff"]
	},
	"grave-bell-duo": {
		"encounter": "res://resources/encounters/grave_bell.tres",
		"id": "grave_bell",
		"card": "grave_bell",
		"heroes": ["knight", "ranger"],
		"enemies": ["skeleton", "skeleton", "grave_bellkeeper"]
	},
}

var _battle: Control
var _output := ""
var _first_positions: Dictionary = {}
var _movement := 0.0
var _log_lines: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 or not SCENARIOS.has(args[0]) or not args[1].begins_with("/"):
		_fail("expected: -- court-trio|grave-bell-duo /absolute/output/directory")
		return
	var name: String = args[0]
	var data: Dictionary = SCENARIOS[name]
	_output = args[1]
	DirAccess.make_dir_recursive_absolute(_output)
	root.size = SIZE

	var state := root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("cannot initialize real Knight")
		return
	# Mirrors existing D268 QA launcher; tests the actual party-size contract.
	var party: Array = state.get("party_roles")
	var fates: Dictionary = state.get("hero_fates")
	var fate_notes: Dictionary = state.get("hero_fate_notes")
	var hero_roles: Array = data["heroes"]
	for i in range(1, hero_roles.size()):
		var role: String = hero_roles[i]
		party.append(role)
		fates[role] = "joined"
		fate_notes[role] = "CI5 temporary multi-party scenario"
	state.set("party_roles", party)
	state.set("hero_fates", fates)
	state.set("hero_fate_notes", fate_notes)
	state.set("active_card_id", data["card"])
	state.call("select_encounter", data["encounter"])

	var packed := load(BATTLE) as PackedScene
	if packed == null:
		_fail("production Battle scene unavailable")
		return
	_battle = packed.instantiate() as Control
	if _battle == null:
		_fail("failed to instantiate actual Battle")
		return
	root.add_child(_battle)
	await process_frame
	var encounter := _battle.get("encounter") as EncounterData
	if encounter == null or encounter.encounter_id != data["id"]:
		_fail("unexpected active encounter")
		return
	var actual_heroes: Array[String] = []
	var actual_enemies: Array[String] = []
	var units: Array = _battle.get("units")
	for node in units:
		var unit := node as BattleUnit
		if unit == null:
			_fail("real Battle roster contains a missing actor")
			return
		_first_positions[unit.get_instance_id()] = unit.position
		if unit.team == 0:
			actual_heroes.append(unit.visual_role)
		elif unit.team == 1:
			actual_enemies.append(unit.visual_role)
	actual_heroes.sort()
	actual_enemies.sort()
	var want_heroes: Array = data["heroes"].duplicate()
	var want_enemies: Array = data["enemies"].duplicate()
	want_heroes.sort()
	want_enemies.sort()
	if actual_heroes != want_heroes or actual_enemies != want_enemies:
		_fail("unexpected original team composition heroes=" + str(actual_heroes) + " enemies=" + str(actual_enemies))
		return
	if name == "court-trio" and _battle.get("court_verdict_controller") == null:
		_fail("original Court marked-target mechanic was not initialized")
		return
	if name == "grave-bell-duo" and _battle.get("side_objective_id") != "bell_first":
		_fail("Grave Bell's authentic Wizard side condition missing")
		return

	_log_lines.append("frame,phase,combat_live,battle_finished,alive,max_displacement_px")
	await create_timer(0.5).timeout
	if not await _save("00-preparation", "preparation"):
		return
	var fight := _battle.get_node_or_null("FightButton") as Button
	if fight == null or fight.pressed.get_connections().is_empty():
		_fail("real Fight button is not connected")
		return
	fight.pressed.emit()
	var intro_wait := 0.0
	while not bool(_battle.get("combat_live")) and intro_wait < 4.0:
		await create_timer(0.05).timeout
		intro_wait += 0.05
	if not bool(_battle.get("combat_live")):
		_fail("production combat never entered live state")
		return

	if not await _save("01-combat-0000ms", "combat"):
		return
	await create_timer(0.6).timeout
	if not await _save("02-combat-0600ms", "combat"):
		return
	await create_timer(0.6).timeout
	if not await _save("03-combat-1200ms", "combat"):
		return
	if _movement < 2.0:
		_fail("frozen multi-party battle, movement=" + str(_movement))
		return
	var metadata := FileAccess.open(_output.path_join("motion.csv"), FileAccess.WRITE)
	if metadata == null:
		_fail("cannot write native motion data")
		return
	for line in _log_lines:
		metadata.store_line(line)
	metadata.close()
	print("CI5_BATTLE_PASS: ", name, " original actors=", units.size(),
		" frames=4 max_movement=", snappedf(_movement, 0.01))
	_battle.queue_free()
	await process_frame
	quit(0)

func _save(label: String, phase: String) -> bool:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.is_empty() or image.get_size() != SIZE:
		_fail("actual Godot framebuffer wrong size: " + label)
		return false
	var lit := 0
	for y in range(20, SIZE.y, 31):
		for x in range(20, SIZE.x, 31):
			var p := image.get_pixel(x, y)
			if p.r + p.g + p.b > 0.12:
				lit += 1
	if lit < 15 or image.save_png(_output.path_join(label + ".png")) != OK:
		_fail("blank/unsaved native frame: " + label)
		return false
	var alive := 0
	for node in _battle.get("units"):
		var actor := node as BattleUnit
		if actor == null:
			continue
		if actor.alive:
			alive += 1
		var key := actor.get_instance_id()
		if _first_positions.has(key):
			_movement = maxf(_movement, actor.position.distance_to(_first_positions[key]))
	_log_lines.append("%s,%s,%s,%s,%d,%.2f" % [
		label, phase, str(_battle.get("combat_live")),
		str(_battle.get("battle_finished")), alive, _movement])
	print("CI5_FRAME_PASS: ", label, " alive=", alive,
		" max_displacement_px=", snappedf(_movement, 0.01))
	return true

func _fail(message: String) -> void:
	push_error("CI5_BATTLE_FAIL: " + message)
	quit(1)
