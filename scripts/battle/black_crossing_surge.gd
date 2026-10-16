class_name BlackCrossingSurgeController
extends Node2D

# D195: flowing asymmetrical storm surf with soft foam crowns and decay.
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
const BREAKER_SAMPLES := 72
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


# D196 — ADVANCING STORM SURF (render-only)
# The D195 organic whitewater looked static because the wave advanced only
# 37px over 1.6s. Warning now approaches from farther seaward and hands off
# to a 94px forward-moving breaker. After impact, runoff continues toward
# the pier edge. ALL hit areas, push and slowdown remain unchanged.
# D194's repeated seven-point cap polygons were rendered as identical white
# triangles. A wave is one continuous turbulent mass: broad asymmetric swell,
# winding shade, rounded scattered whitewater, short streaks of retreating
# foam. All motion is phase-based, not per-frame random.
# The sole contact offset anchors the wave to the pier; the hit lane, AI and
# knockback still use _lane_rect(), not these drawing coordinates.
func _surface_between(rear: PackedVector2Array, front: PackedVector2Array) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	for point in rear:
		polygon.append(point)
	for index in range(front.size() - 1, -1, -1):
		polygon.append(front[index])
	return polygon


func _water_motion(x: float, seed: float) -> float:
	# Mixed long swell and short wind chop, gently animated out of phase.
	return (
		sin(x * 0.017 + seed + phase_elapsed * 1.8) * 0.59
		+ sin(x * 0.043 - seed * 1.4 - phase_elapsed * 3.3) * 0.29
		+ sin(x * 0.089 + seed * 2.1 + phase_elapsed * 4.6) * 0.12
	)


func _draw_whitewater(
	crest: PackedVector2Array,
	shoulder: PackedVector2Array,
	section_start: int,
	section_end: int,
	strength: float,
	seed: float
) -> void:
	if strength < 0.015:
		return
	# Smooth, irregular tongues of foam; NO sharp triangle fan / repeated teeth.
	var upper := PackedVector2Array()
	var lower := PackedVector2Array()
	for index in range(section_start, section_end + 1):
		var fraction := float(index - section_start) / float(section_end - section_start)
		var roundness := pow(maxf(sin(fraction * PI), 0.0), 0.65)
		var x := crest[index].x
		var drift := _water_motion(x * 1.2, seed)
		var curl := (7.0 + 4.0 * drift + 6.0 * sin(fraction * PI * 1.5 + seed)) * roundness
		upper.append(crest[index] + Vector2(-2.0 * roundness, -maxf(curl, 0.0) * strength))
		lower.append(crest[index].lerp(shoulder[index], 0.22 + 0.10 * roundness))
	draw_colored_polygon(_surface_between(upper, lower), Color(0.67, 0.81, 0.84, 0.52 * strength))
	draw_polyline(upper, Color(0.86, 0.93, 0.93, 0.68 * strength), 2.1, false)
	# Flecks within the curl break up a painted-solid foam blanket.
	for index in range(section_start + 3, section_end - 2, 5):
		var inner := crest[index].lerp(shoulder[index], 0.24)
		var wave_motion := _water_motion(inner.x, seed)
		draw_circle(inner + Vector2(wave_motion * 3.5, -2.0), 1.15, Color(0.88, 0.94, 0.92, 0.44 * strength))


func _draw_breaker(swell_index: int, progress: float, telegraph: bool) -> void:
	# Unequal phase offsets, spans, and side shapes keep the three crests from
	# looking stamped or synchronously looping.
	var delay := float(swell_index) * 0.075
	var t := clampf((progress - delay) / (1.0 - delay), 0.0, 1.0)
	var roll := t * t * (3.0 - 2.0 * t)
	var rise := sin(t * PI)
	var fade_in := clampf(t / 0.14, 0.0, 1.0)
	var fade_out := clampf((1.0 - t) / 0.28, 0.0, 1.0)
	var visibility := 0.25 + 0.40 * t if telegraph else minf(fade_in, fade_out)
	if visibility <= 0.001:
		return

	var width := FLOOR.WAVE_MAX_X - FLOOR.WAVE_MIN_X
	var center_x := FLOOR.WAVE_MIN_X + width * (0.21 + float(swell_index) * 0.29) - roll * 19.0
	var span := 226.0 + 23.0 * sin(float(swell_index) * 1.61 + 0.6)
	var left_x := maxf(FLOOR.WAVE_MIN_X, center_x - span)
	var right_x := minf(FLOOR.WAVE_MAX_X, center_x + span)
	var foot_y := current_center_y + SURF_CONTACT_OFFSET_Y
	var height := 13.0 + 9.0 * t if telegraph else 18.0 + 46.0 * rise
	# Warning approaches from the sea; impact starts EXACTLY where warning
	# ended, so the front cannot jump backwards at phase transition.
	# The impact face travels 94px along the pier (was only 37px in D195).
	var advance_start := -91.0 if telegraph else -62.0
	var advance_distance := 29.0 if telegraph else 94.0
	var push_forward := advance_start + advance_distance * roll

	var crest := PackedVector2Array()
	var shoulder := PackedVector2Array()
	var wash := PackedVector2Array()
	for sample in range(BREAKER_SAMPLES + 1):
		var fraction := float(sample) / float(BREAKER_SAMPLES)
		var x := lerpf(left_x, right_x, fraction)
		var envelope := pow(maxf(sin(fraction * PI), 0.0), 0.75)
		# Windward asymmetry breaks the uniform arc across all three swells.
		var skew := 0.87 + 0.16 * sin(fraction * PI * 1.65 + float(swell_index) * 1.3)
		var turbulence := _water_motion(x, float(swell_index) * 1.77)
		var floor_y := foot_y - 3.0 + push_forward * envelope + turbulence * 3.6 * envelope
		var high_y := floor_y - height * envelope * skew + turbulence * 5.0 * envelope
		crest.append(Vector2(x, high_y))
		shoulder.append(Vector2(x, lerpf(high_y, floor_y, 0.42 + 0.07 * turbulence)))
		wash.append(Vector2(x, floor_y))

	# The face is mostly storm-dark, with a quiet cold highlight near the crest.
	# Keeping coverage translucent preserves the original approved pier.
	var impact_alpha := visibility * (0.42 if telegraph else 0.68)
	draw_colored_polygon(_surface_between(crest, wash), Color(0.025, 0.10, 0.16, impact_alpha))
	draw_colored_polygon(_surface_between(crest, shoulder), Color(0.065, 0.22, 0.30, impact_alpha * 0.66))
	draw_colored_polygon(_surface_between(shoulder, wash), Color(0.12, 0.30, 0.37, impact_alpha * 0.36))

	# Three rounded, off-beat foam clusters per breaker. Their widths and
	# start points vary so no regular sawtooth silhouette is possible.
	var foam_rise := (0.26 + 0.30 * t) if telegraph else clampf((t - 0.10) / 0.22, 0.0, 1.0) * visibility
	for cluster in range(3):
		var first := 6 + cluster * 19 + (swell_index * 5 + cluster * 3) % 7
		var last := mini(first + 12 + (swell_index + cluster * 2) % 8, BREAKER_SAMPLES - 4)
		_draw_whitewater(crest, shoulder, first, last, foam_rise, float(swell_index * 3 + cluster) * 1.9)

	# Past the breaking point a SECOND, lower layer of runoff travels
	# beyond the collapsing front. It tapers at both ends and stays above the
	# broken foreground boards; it is strictly visual, not an extra hit zone.
	if not telegraph:
		var collapse := clampf((t - 0.33) / 0.40, 0.0, 1.0)
		var wash_strength := visibility * collapse
		if collapse > 0.0:
			var runoff_back := PackedVector2Array()
			var runoff_front := PackedVector2Array()
			var max_deck_y := FLOOR.COMBAT_BOUNDS.end.y + SURF_CONTACT_OFFSET_Y - 5.0
			for sample in range(BREAKER_SAMPLES + 1):
				var fraction := float(sample) / float(BREAKER_SAMPLES)
				var taper := pow(maxf(sin(fraction * PI), 0.0), 0.85)
				var slip := (9.0 + collapse * 17.0) * taper
				var back_y := wash[sample].y - (4.0 + 8.0 * collapse) * taper
				var front_y := minf(wash[sample].y + slip, max_deck_y)
				# A tiny skirt never reverses its polygon after clipping at the pier.
				back_y = minf(back_y, front_y)
				runoff_back.append(Vector2(wash[sample].x, back_y))
				runoff_front.append(Vector2(wash[sample].x, front_y))
			draw_colored_polygon(
				_surface_between(runoff_back, runoff_front),
				Color(0.07, 0.21, 0.27, wash_strength * 0.27)
			)
			for segment in range(5, BREAKER_SAMPLES - 7, 9):
				var streak := PackedVector2Array([
					runoff_front[segment] + Vector2(-8.0, -3.0),
					runoff_front[segment + 3] + Vector2(0.0, -4.0),
					runoff_front[segment + 6] + Vector2(7.0, -1.0)
				])
				draw_polyline(streak, Color(0.66, 0.83, 0.86, wash_strength * 0.67), 2.5, false)
		# Sparse spray blows toward the shore and settles back down.
		for spray_index in range(4):
			var index := 12 + spray_index * 14 + (swell_index * 3) % 5
			var point := crest[index]
			var gust := _water_motion(point.x, float(swell_index) * 2.3)
			var spray_y := -7.0 - 14.0 * rise + collapse * 14.0
			draw_circle(point + Vector2(gust * 11.0 - t * 7.0, spray_y), 1.0 + 0.8 * rise, Color(0.81, 0.90, 0.90, visibility * rise * 0.57))


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
