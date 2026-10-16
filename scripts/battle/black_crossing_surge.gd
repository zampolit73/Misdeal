class_name BlackCrossingSurgeController
extends Node2D

# D194: rolling breakers with three overlapping crests, not flat strips.
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
const BREAKER_COUNT := 3
const BREAKER_SAMPLES := 36
const SURF_CONTACT_OFFSET_Y := 36.0

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


# D194 — CINEMATIC STORM BREAKERS
# D192 was a straight turquoise wall; D193 was seven tiny scratches.
# Three broad overlapping wave heads now rise, curl and collapse onto the
# intact planks. Wave height is an envelope, not a constant-height strip.
# Water travels forward (toward +Y) and slightly left as it breaks.
# Drawing is in UnitsLayer coordinates: boot contact = origin + (0, 36).
# Only the visuals change; _lane_rect() is the gameplay hit area.
func _water_face(back_edge: PackedVector2Array, forward_edge: PackedVector2Array) -> PackedVector2Array:
	var shape := PackedVector2Array()
	for p in back_edge:
		shape.append(p)
	for index in range(forward_edge.size() - 1, -1, -1):
		shape.append(forward_edge[index])
	return shape


func _draw_breaker(swell_index: int, progress: float, telegraph: bool) -> void:
	# Unaligned large swells overlap instead of forming a single flat band.
	var delay := float(swell_index) * 0.085
	var t := clampf((progress - delay) / (1.0 - delay), 0.0, 1.0)
	var roll := t * t * (3.0 - 2.0 * t)
	var lift := sin(t * PI)
	var visibility := 0.34 + 0.38 * t if telegraph else minf(clampf(t / 0.14, 0.0, 1.0), clampf((1.0 - t) / 0.27, 0.0, 1.0))
	if visibility <= 0.001:
		return

	var lane_width := FLOOR.WAVE_MAX_X - FLOOR.WAVE_MIN_X
	var center_x := FLOOR.WAVE_MIN_X + lane_width * (0.20 + float(swell_index) * 0.30)
	center_x -= roll * (8.0 if telegraph else 24.0)
	var span := 238.0 + sin(float(swell_index) * 1.8) * 12.0
	var start_x := maxf(FLOOR.WAVE_MIN_X, center_x - span)
	var end_x := minf(FLOOR.WAVE_MAX_X, center_x + span)
	var foot_y := current_center_y + SURF_CONTACT_OFFSET_Y
	# A broad high face grows behind the rolling foamy lip, then collapses.
	var height := 11.0 + t * 10.0 if telegraph else 20.0 + lift * 51.0
	var advance := t * 10.0 if telegraph else roll * 38.0

	var crest := PackedVector2Array()
	var shoulder := PackedVector2Array()
	var front := PackedVector2Array()
	for sample in range(BREAKER_SAMPLES + 1):
		var f := float(sample) / float(BREAKER_SAMPLES)
		var x := lerpf(start_x, end_x, f)
		# The swell rises in its center, dies off naturally at both tips.
		var envelope := pow(maxf(sin(f * PI), 0.0), 0.66)
		var gust := sin(x * 0.028 - phase_elapsed * 3.2 + float(swell_index)) * 5.5
		gust += sin(x * 0.073 + phase_elapsed * 4.7) * 2.4
		var floor_y := foot_y + advance * envelope + gust * envelope * 0.45
		var top_y := floor_y - height * envelope + gust * envelope
		crest.append(Vector2(x, top_y))
		shoulder.append(Vector2(x, lerpf(top_y, floor_y, 0.49)))
		front.append(Vector2(x, floor_y))

	# A shaped volume: dark sea underbelly, storm-blue face and pearl foam.
	# The 36px boot offset prevents the water from hovering near the horizon.
	var alpha := visibility * (0.36 if telegraph else 0.78)
	draw_colored_polygon(_water_face(crest, front), Color(0.035, 0.125, 0.18, alpha))
	draw_colored_polygon(_water_face(crest, shoulder), Color(0.075, 0.24, 0.32, alpha * 0.8))
	draw_colored_polygon(_water_face(shoulder, front), Color(0.13, 0.33, 0.42, alpha * 0.55))

	# Whitewater breaks in irregular disconnected curls rather than a line.
	for sample in range(3, BREAKER_SAMPLES - 3, 4):
		var f := float(sample) / float(BREAKER_SAMPLES)
		var taper := pow(maxf(sin(f * PI), 0.0), 0.66)
		if taper < 0.30:
			continue
		var boil := 0.5 + 0.5 * sin(float(sample + swell_index * 4) * 1.27 + phase_elapsed * 5.0)
		var froth := (5.0 + boil * 13.0) * taper * (0.5 if telegraph else 1.0)
		var foam := PackedVector2Array([
			crest[sample - 2] + Vector2(0.0, 3.0),
			crest[sample - 1] + Vector2(-2.0, -froth * 0.48),
			crest[sample] + Vector2(0.0, -froth),
			crest[sample + 1] + Vector2(3.0, -froth * 0.58),
			crest[sample + 2] + Vector2(0.0, 2.0),
			shoulder[sample + 1] + Vector2(0.0, -3.0),
			shoulder[sample - 1] + Vector2(0.0, -3.0)
		])
		draw_colored_polygon(foam, Color(0.69, 0.82, 0.85, visibility * (0.28 if telegraph else 0.75)))
		# A bright upper lip and a few physically placed foam droplets.
		var break_line := PackedVector2Array([
			crest[sample - 2],
			crest[sample - 1] + Vector2(-2.0, -froth * 0.48),
			crest[sample] + Vector2(0.0, -froth)
		])
		draw_polyline(break_line, Color(0.88, 0.95, 0.94, visibility * (0.24 if telegraph else 0.82)), 2.8, false)
		if not telegraph and lift > 0.2:
			var spray := crest[sample] + Vector2(3.0 - t * 10.0, -froth - 8.0 - boil * 10.0)
			draw_circle(spray, 1.5 + boil * 1.3, Color(0.83, 0.94, 0.95, visibility * lift * 0.7))
			draw_circle(spray + Vector2(8.0, 6.0), 1.0 + boil * 0.5, Color(0.64, 0.84, 0.90, visibility * lift * 0.6))

	# Broken foam wash follows the moving water toward the planks.
	if not telegraph:
		for sample in range(3, BREAKER_SAMPLES - 5, 7):
			var wash := front[sample]
			var foam_tail := PackedVector2Array([
				wash + Vector2(-12.0, -2.0),
				wash + Vector2(4.0, -4.0),
				front[sample + 3] + Vector2(8.0, -1.0)
			])
			draw_polyline(foam_tail, Color(0.62, 0.79, 0.81, visibility * 0.40), 2.4, false)


func _draw_warning() -> void:
	var t := clampf(phase_elapsed / WARNING_SECONDS, 0.0, 1.0)
	for swell_index in range(BREAKER_COUNT):
		_draw_breaker(swell_index, t, true)


func _draw_surge() -> void:
	var t := clampf(phase_elapsed / SLOW_SECONDS, 0.0, 1.0)
	for swell_index in range(BREAKER_COUNT):
		_draw_breaker(swell_index, t, false)


func _draw() -> void:
	if not running:
		return
	match phase:
		WARNING:
			_draw_warning()
		SURGE:
			_draw_surge()
