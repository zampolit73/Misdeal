class_name BlackCrossingSurgeController
extends Node2D

# D193: grounded patchy pier wash instead of a floating wave wall.
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
const SURF_PATCH_COUNT := 7
const PATCH_SAMPLES := 12
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


# D193: shallow storm wash lives ON the pier at the miniature's foot line.
# The D192 1000px-long opaque crest floated above the deck because the local
# wave lane marks unit ORIGINS, while sprite soles sit another 36px down.
# Several ragged shoreward-moving tongues replace the horizontal water wall.
# This is VISUAL ONLY. _lane_rect(), push/slow, and safe combat floor do not move.
func _surface_between(back: PackedVector2Array, front: PackedVector2Array) -> PackedVector2Array:
	var shape := PackedVector2Array()
	for point in back:
		shape.append(point)
	for index in range(front.size() - 1, -1, -1):
		shape.append(front[index])
	return shape


func _draw_surf_patch(patch_index: int, progress: float, warning: bool) -> void:
	# Space the partial crests irregularly; gaps reveal actual wet planks.
	var lane_span := FLOOR.WAVE_MAX_X - FLOOR.WAVE_MIN_X
	var patch_step := lane_span / float(SURF_PATCH_COUNT)
	var center_x := FLOOR.WAVE_MIN_X + (float(patch_index) + 0.5) * patch_step
	center_x += sin(float(patch_index) * 2.17) * 9.0
	var half_width := patch_step * (0.52 + sin(float(patch_index) * 1.87) * 0.11)
	var start_x := maxf(FLOOR.WAVE_MIN_X, center_x - half_width)
	var end_x := minf(FLOOR.WAVE_MAX_X, center_x + half_width)
	# Neighboring tongues arrive at slightly different moments.
	var delay := float(patch_index % 3) * 0.075
	var t := clampf((progress - delay) / (1.0 - delay), 0.0, 1.0)
	var travel := t * t * (3.0 - 2.0 * t)
	var swell := sin(t * PI)
	var opacity := 0.55 + 0.45 * t
	if not warning:
		opacity = minf(clampf(t / 0.14, 0.0, 1.0), clampf((1.0 - t) / 0.27, 0.0, 1.0))
	if opacity <= 0.001:
		return

	# Unit origins are inside the hit lane, but their visible boots are 36px
	# below that origin. Draw the sea wash near the boots, not at head height.
	var foot_y := current_center_y + SURF_CONTACT_OFFSET_Y
	var front_y := foot_y - 17.0 + travel * 7.0 if warning else foot_y - 10.0 + travel * 26.0
	front_y += sin(float(patch_index) * 1.6) * 2.0
	var depth := 5.0 + 4.0 * t if warning else 10.0 + 10.0 * swell
	var back := PackedVector2Array()
	var middle := PackedVector2Array()
	var lip := PackedVector2Array()
	for sample in range(PATCH_SAMPLES + 1):
		var fraction := float(sample) / float(PATCH_SAMPLES)
		var x := lerpf(start_x, end_x, fraction)
		var taper := pow(maxf(sin(fraction * PI), 0.0), 0.76)
		var chop := sin(x * 0.046 + phase_elapsed * 2.7 + float(patch_index)) * 3.2
		chop += sin(x * 0.105 - phase_elapsed * 4.4) * 1.6
		var edge_y := front_y + chop * taper
		lip.append(Vector2(x, edge_y))
		back.append(Vector2(x, edge_y - depth * taper))
		middle.append(Vector2(x, edge_y - depth * 0.37 * taper))

	# No opaque rectangle or 50px-tall turquoise ribbon; deck grain shows
	# through the separate crescent-shaped pools of dark stormwater.
	var dark_alpha := (0.17 + 0.09 * swell) * opacity
	var lit_alpha := (0.17 + 0.10 * swell) * opacity
	draw_colored_polygon(_surface_between(back, lip), Color(0.06, 0.17, 0.24, dark_alpha))
	draw_colored_polygon(_surface_between(middle, lip), Color(0.28, 0.44, 0.50, lit_alpha))

	# Short attached whitecaps, with non-uniform height and missing sections.
	# They never join into one luminous ruler-straight line.
	for sample in range(2, PATCH_SAMPLES - 2, 3):
		var pulse := 0.5 + 0.5 * sin(float(sample + patch_index * 3) * 1.63 + phase_elapsed * 5.3)
		var curl := (2.5 + pulse * 4.0) * (0.65 if warning else 1.0 + swell * 0.45)
		var foam := PackedVector2Array([
			lip[sample - 1],
			lip[sample] + Vector2(-2.0, -curl),
			lip[sample + 1] + Vector2(0.0, -curl * 0.34),
			lip[sample + 2],
			middle[sample + 1],
			middle[sample]
		])
		draw_colored_polygon(foam, Color(0.67, 0.79, 0.81, (0.29 + 0.24 * pulse) * opacity))
		draw_line(lip[sample - 1], lip[sample] + Vector2(-2.0, -curl), Color(0.87, 0.93, 0.93, 0.44 * opacity), 1.9, false)
		if not warning and swell > 0.25:
			var bubble := lip[sample] + Vector2(4.0, -curl - 3.0 - pulse * 4.0)
			draw_circle(bubble, 1.0 + pulse * 0.6, Color(0.78, 0.87, 0.89, opacity * swell * 0.44))
	# A few broken eddies show motion without covering the scene in confetti.
	for sample in range(3, PATCH_SAMPLES - 2, 4):
		var wake := back[sample].lerp(middle[sample], 0.45)
		draw_line(wake + Vector2(-9.0, 0.0), wake + Vector2(7.0, -1.7), Color(0.50, 0.66, 0.71, opacity * 0.26), 1.4, false)


func _draw_warning() -> void:
	var progress := clampf(phase_elapsed / WARNING_SECONDS, 0.0, 1.0)
	for patch_index in range(SURF_PATCH_COUNT):
		_draw_surf_patch(patch_index, progress, true)


func _draw_surge() -> void:
	var progress := clampf(phase_elapsed / SLOW_SECONDS, 0.0, 1.0)
	for patch_index in range(SURF_PATCH_COUNT):
		_draw_surf_patch(patch_index, progress, false)


func _draw() -> void:
	if not running:
		return
	match phase:
		WARNING:
			_draw_warning()
		SURGE:
			_draw_surge()
