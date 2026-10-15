class_name BlackCrossingSurgeController
extends Node2D

# D189: ocean surf drawn from irregular moving crests, NEVER debug rectangles.
# Gameplay stays encounter-local and neutral: a warned leftward push and a
# temporary slowdown for both teams, with no damage or global AI changes.
const FLOOR := preload("res://scripts/battle/black_crossing_floor.gd")
const WAITING := 0
const WARNING := 1
const SURGE := 2

const INITIAL_DELAY := 3.2
const REST_SECONDS := 4.5
const WARNING_SECONDS := 1.4
const SLOW_SECONDS := 1.6
const PUSH_DISTANCE := 43.0
const SLOW_MULTIPLIER := 0.70
const WAVE_SAMPLES := 56

var combat_units: Array[BattleUnit] = []
var slowed_units: Array[BattleUnit] = []
var running := false
var phase := WAITING
var remaining := INITIAL_DELAY
var phase_elapsed := 0.0
var next_lane_index := 0
var current_center_y := 284.0

var warnings := 0
var surges := 0
var units_pushed := 0
var slow_resets := 0


func _ready() -> void:
	set_process(false)
	# Draw foam below the actual miniatures; keep sprites/healthbars readable.
	z_index = 90


func configure(participants: Array[BattleUnit]) -> void:
	stop_surge()
	combat_units = participants.duplicate()
	warnings = 0
	surges = 0
	units_pushed = 0
	slow_resets = 0
	next_lane_index = 0
	current_center_y = float(FLOOR.WAVE_LANE_CENTERS[0])


func start_surge() -> void:
	if combat_units.is_empty():
		return
	_clear_slow()
	running = true
	phase = WAITING
	remaining = INITIAL_DELAY
	phase_elapsed = 0.0
	set_process(true)


func stop_surge() -> void:
	_clear_slow()
	running = false
	phase = WAITING
	remaining = INITIAL_DELAY
	phase_elapsed = 0.0
	set_process(false)
	queue_redraw()


func _process(delta: float) -> void:
	advance_battle(delta)


# Deterministic stepping is shared by actual F6 combat and the 54-case matrix.
func advance_battle(delta: float) -> void:
	if not running:
		return
	var dt := maxf(delta, 0.0)
	phase_elapsed += dt
	remaining -= dt
	if remaining > 0.0:
		if phase != WAITING:
			queue_redraw()
		return
	match phase:
		WAITING:
			current_center_y = float(FLOOR.WAVE_LANE_CENTERS[next_lane_index])
			next_lane_index = (next_lane_index + 1) % FLOOR.WAVE_LANE_CENTERS.size()
			warnings += 1
			phase = WARNING
			remaining = WARNING_SECONDS
		WARNING:
			_apply_wave()
			surges += 1
			phase = SURGE
			remaining = SLOW_SECONDS
		SURGE:
			_clear_slow()
			phase = WAITING
			remaining = REST_SECONDS
	phase_elapsed = 0.0
	queue_redraw()


func _lane_rect() -> Rect2:
	return Rect2(
		Vector2(FLOOR.WAVE_MIN_X, current_center_y - FLOOR.WAVE_HALF_WIDTH),
		Vector2(FLOOR.WAVE_MAX_X - FLOOR.WAVE_MIN_X, FLOOR.WAVE_HALF_WIDTH * 2.0)
	)


func _apply_wave() -> void:
	_clear_slow()
	var lane := _lane_rect()
	for unit in combat_units:
		if not is_instance_valid(unit) or not unit.alive or not unit.combat_started:
			continue
		if not lane.has_point(unit.position):
			continue
		# Both teams. The exact same D189 floor bounds govern walking and
		# impulse movement, so waves cannot send a miniature into the water.
		unit.position = unit._clamped_combat_position(unit.position + Vector2(-PUSH_DISTANCE, 0.0))
		unit.wave_move_speed_multiplier = SLOW_MULTIPLIER
		unit.z_index = int(unit.position.y)
		slowed_units.append(unit)
		units_pushed += 1


func _clear_slow() -> void:
	for unit in slowed_units:
		if is_instance_valid(unit):
			unit.wave_move_speed_multiplier = 1.0
			slow_resets += 1
	slowed_units.clear()


# A changing coastline with two ripple frequencies, not a straight AoE edge.
func _ripple(y: float, amplitude: float, offset: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for sample in range(WAVE_SAMPLES + 1):
		var fraction := float(sample) / float(WAVE_SAMPLES)
		var x := lerpf(FLOOR.WAVE_MIN_X, FLOOR.WAVE_MAX_X, fraction)
		var displaced := sin(x * 0.025 + offset + phase_elapsed * 3.8) * amplitude
		displaced += sin(x * 0.061 - offset * 1.3 - phase_elapsed * 2.2) * amplitude * 0.32
		points.append(Vector2(x, y + displaced))
	return points


func _draw_warning() -> void:
	# The surf starts to ruffle the planks BEFORE its actual impact.
	# Narrow broken foamy curves replace the old full-width amber rectangle.
	var warning_fraction := clampf(phase_elapsed / WARNING_SECONDS, 0.0, 1.0)
	var warning_y := current_center_y + lerpf(-9.0, 4.0, warning_fraction)
	var edge := _ripple(warning_y, 2.8 + warning_fraction * 1.7, 0.25)
	var secondary := _ripple(warning_y + 12.0, 2.2, 1.8)
	draw_polyline(edge, Color(0.49, 0.70, 0.79, 0.43 + warning_fraction * 0.18), 2.0, false)
	for i in range(0, WAVE_SAMPLES - 3, 7):
		var segment := PackedVector2Array()
		for j in range(i, i + 4):
			segment.append(secondary[j])
		draw_polyline(segment, Color(0.84, 0.90, 0.84, 0.29 + warning_fraction * 0.18), 1.8, false)
	for i in range(2, WAVE_SAMPLES, 5):
		var point := edge[i]
		var shine := 0.5 + 0.5 * sin(float(i) * 1.7 + phase_elapsed * 8.0)
		draw_circle(point + Vector2(0.0, -3.0 - shine * 2.0), 1.0 + shine, Color(0.86, 0.93, 0.88, 0.25 + shine * 0.38))


func _draw_surge() -> void:
	var progress := clampf(phase_elapsed / SLOW_SECONDS, 0.0, 1.0)
	# The foam front rolls across the marked part of the real deck.
	var front_y := lerpf(current_center_y - FLOOR.WAVE_HALF_WIDTH - 3.0, current_center_y + FLOOR.WAVE_HALF_WIDTH + 7.0, progress)
	var crest := _ripple(front_y, 5.0, 0.4)
	var back := _ripple(front_y - 27.0, 3.1, 2.2)
	var water := PackedVector2Array()
	for point in back:
		water.append(point)
	for index in range(crest.size() - 1, -1, -1):
		water.append(crest[index])
	var wash_alpha := 0.35 * (1.0 - progress * 0.28)
	draw_colored_polygon(water, Color(0.10, 0.37, 0.47, wash_alpha))
	# Translucent blue undertow, broken white foam and moving spray droplets.
	draw_polyline(crest, Color(0.29, 0.66, 0.78, 0.52), 7.0, false)
	draw_polyline(crest, Color(0.79, 0.91, 0.94, 0.87), 2.4, false)
	var inner_foam := _ripple(front_y - 9.0, 3.1, 1.5)
	for i in range(0, WAVE_SAMPLES - 3, 7):
		var strand := PackedVector2Array()
		for j in range(i, i + 4):
			strand.append(inner_foam[j])
		draw_polyline(strand, Color(0.68, 0.84, 0.91, 0.56), 2.0, false)
	for i in range(2, WAVE_SAMPLES, 3):
		var point := crest[i]
		var pulse := 0.5 + 0.5 * sin(float(i) * 1.91 + phase_elapsed * 10.0)
		var spray_height := 4.0 + pulse * 9.0
		draw_circle(point + Vector2(0.0, -spray_height), 1.1 + pulse * 1.2, Color(0.81, 0.96, 1.0, (0.30 + pulse * 0.53) * (1.0 - progress * 0.28)))


func _draw() -> void:
	if not running:
		return
	match phase:
		WARNING:
			_draw_warning()
		SURGE:
			_draw_surge()
