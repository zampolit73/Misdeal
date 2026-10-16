class_name BlackCrossingSurgeController
extends Node2D

# D192: storm breaker with volume, curling foam and forward rolling motion.
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


# D192: actual breaking surf instead of a glowing horizontal line.
# Shapes are deterministic, time-driven Godot polygons: no new art assets,
# no UI, and no gameplay impact. Foam/body occupy visual space beyond the
# 50px hit lane; _lane_rect() alone decides which units are affected.
func _ripple(y: float, amplitude: float, offset: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for sample in range(WAVE_SAMPLES + 1):
		var fraction := float(sample) / float(WAVE_SAMPLES)
		var x := lerpf(FLOOR.WAVE_MIN_X, FLOOR.WAVE_MAX_X, fraction)
		# Long asymmetric swell with smaller broken wind-driven chop.
		var displaced := sin(x * 0.017 + offset + phase_elapsed * 2.4) * amplitude
		displaced += sin(x * 0.047 - offset * 1.3 - phase_elapsed * 4.1) * amplitude * 0.46
		displaced += sin(x * 0.091 + offset * 2.2 + phase_elapsed * 5.8) * amplitude * 0.16
		points.append(Vector2(x, y + displaced))
	return points


func _water_between(rear_edge: PackedVector2Array, front_edge: PackedVector2Array) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	for point in rear_edge:
		polygon.append(point)
	for index in range(front_edge.size() - 1, -1, -1):
		polygon.append(front_edge[index])
	return polygon


func _draw_foam_caps(edge: PackedVector2Array, intensity: float, spraying: bool) -> void:
	# Uneven curling tongues give the foam a recognizable broken-wave outline.
	# Stable sample locations avoid flickering random confetti every frame.
	for index in range(3, WAVE_SAMPLES - 3, 7):
		var pulse := 0.5 + 0.5 * sin(float(index) * 1.37 + phase_elapsed * 5.5)
		var curl_height := (6.0 + pulse * 7.0) * intensity
		var left := edge[index - 2]
		var shoulder_left := edge[index - 1]
		var center := edge[index]
		var shoulder_right := edge[index + 1]
		var right := edge[index + 2]
		var cap := PackedVector2Array([
			left + Vector2(0.0, -2.0),
			shoulder_left + Vector2(0.0, -curl_height * 0.66),
			center + Vector2(0.0, -curl_height),
			shoulder_right + Vector2(0.0, -curl_height * 0.45),
			right + Vector2(0.0, -1.0),
			shoulder_right + Vector2(0.0, 2.0 + 4.0 * intensity),
			center + Vector2(0.0, 4.0 + 6.0 * intensity),
			shoulder_left + Vector2(0.0, 2.0 + 3.0 * intensity)
		])
		draw_colored_polygon(cap, Color(0.76, 0.91, 0.94, 0.23 + 0.44 * intensity))
		var scallop := PackedVector2Array([
			left,
			shoulder_left + Vector2(0.0, -curl_height * 0.28),
			center + Vector2(0.0, -curl_height * 0.57),
			shoulder_right + Vector2(0.0, -curl_height * 0.23),
			right
		])
		draw_polyline(scallop, Color(0.89, 0.97, 0.97, 0.30 + 0.55 * intensity), 2.5, false)
		if spraying:
			var spray_height := 8.0 + pulse * 13.0
			var spray_alpha := (0.32 + pulse * 0.42) * intensity
			draw_circle(center + Vector2(-4.0, -curl_height - spray_height), 1.5 + pulse, Color(0.86, 0.97, 1.0, spray_alpha))
			draw_circle(center + Vector2(8.0, -curl_height - spray_height * 0.55), 1.2 + pulse * 0.7, Color(0.77, 0.92, 0.96, spray_alpha * 0.7))


func _draw_warning() -> void:
	# A growing dark swell approaches BEFORE impact, not an outlined AoE.
	var t := clampf(phase_elapsed / WARNING_SECONDS, 0.0, 1.0)
	var lift := sin(t * PI)
	var shoreline := current_center_y - 15.0 + t * 10.0
	var rear := _ripple(shoreline - 29.0 - lift * 3.0, 3.4, 1.6)
	var shoulder := _ripple(shoreline - 11.0, 4.0 + lift * 1.5, 0.95)
	var lip := _ripple(shoreline + 10.0, 5.0 + lift * 3.0, 0.3)
	# Layered volume stays under the miniatures and gives the surge a silhouette.
	draw_colored_polygon(_water_between(rear, lip), Color(0.035, 0.18, 0.27, 0.30 + t * 0.18))
	draw_colored_polygon(_water_between(shoulder, lip), Color(0.10, 0.38, 0.46, 0.18 + t * 0.18))
	draw_polyline(shoulder, Color(0.24, 0.53, 0.64, 0.24 + t * 0.20), 5.0, false)
	draw_polyline(lip, Color(0.40, 0.71, 0.78, 0.36 + t * 0.22), 4.0, false)
	_draw_foam_caps(lip, 0.32 + t * 0.27, false)
	# Scattered moving wake patches inside the water instead of ruler lines.
	var wake := _ripple(shoreline - 4.0, 4.0, 2.7)
	for index in range(1, WAVE_SAMPLES - 4, 9):
		var patch := PackedVector2Array()
		for j in range(index, index + 4):
			patch.append(wake[j])
		draw_polyline(patch, Color(0.61, 0.84, 0.87, 0.16 + t * 0.22), 2.5, false)


func _draw_surge() -> void:
	var t := clampf(phase_elapsed / SLOW_SECONDS, 0.0, 1.0)
	# The breaking lip actually travels shoreward (~65px) while the water
	# behind it swells, catches the light, and dissipates into the planks.
	var travel := t * t * (3.0 - 2.0 * t)
	var crest_lift := sin(t * PI)
	var front_y := lerpf(
		current_center_y - FLOOR.WAVE_HALF_WIDTH - 12.0,
		current_center_y + FLOOR.WAVE_HALF_WIDTH + 4.0,
		travel
	)
	var rear := _ripple(front_y - 52.0 - crest_lift * 7.0, 4.5, 1.8)
	var shoulder := _ripple(front_y - 29.0 - crest_lift * 6.0, 6.2, 1.25)
	var face := _ripple(front_y - 9.0 - crest_lift * 3.0, 7.0 + crest_lift * 2.5, 0.8)
	var lip := _ripple(front_y + crest_lift * 4.0, 8.5 + crest_lift * 3.0, 0.25)
	# Fade in/out rather than abruptly drawing a ribbon at full opacity.
	var fade_in := clampf(t / 0.12, 0.0, 1.0)
	var fade_out := clampf((1.0 - t) / 0.22, 0.0, 1.0)
	var opacity := minf(fade_in, fade_out)
	# Three shaded surfaces read as an advancing breaker, not a debug stripe.
	draw_colored_polygon(_water_between(rear, lip), Color(0.03, 0.16, 0.26, 0.58 * opacity))
	draw_colored_polygon(_water_between(rear, shoulder), Color(0.05, 0.26, 0.35, 0.53 * opacity))
	draw_colored_polygon(_water_between(shoulder, lip), Color(0.10, 0.44, 0.54, 0.51 * opacity))
	draw_colored_polygon(_water_between(face, lip), Color(0.27, 0.65, 0.71, 0.26 * opacity))
	draw_polyline(shoulder, Color(0.22, 0.54, 0.66, 0.48 * opacity), 6.0, false)
	draw_polyline(face, Color(0.34, 0.71, 0.78, 0.74 * opacity), 8.0, false)
	draw_polyline(lip, Color(0.68, 0.88, 0.91, 0.88 * opacity), 6.5, false)
	_draw_foam_caps(lip, opacity * (0.75 + crest_lift * 0.25), true)
	# Uneven foam strings trail the rolling crest as it loses momentum.
	var wake := _ripple(front_y - 19.0, 4.6, 2.4)
	for index in range(2, WAVE_SAMPLES - 4, 8):
		var strand := PackedVector2Array()
		for j in range(index, index + 5):
			strand.append(wake[j])
		draw_polyline(strand, Color(0.70, 0.88, 0.90, 0.53 * opacity), 3.3, false)


func _draw() -> void:
	if not running:
		return
	match phase:
		WARNING:
			_draw_warning()
		SURGE:
			_draw_surge()
