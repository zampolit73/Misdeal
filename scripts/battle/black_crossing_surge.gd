class_name BlackCrossingSurgeController
extends Node2D

# D188: encounter-only wave hazard, NOT damage, stun or permanent stat scaling.
# Fixed horizontal warning bands give deployment/order choices meaningful space.
const WAITING := 0
const WARNING := 1
const SURGE := 2

const INITIAL_DELAY := 3.2
const REST_SECONDS := 4.5
const WARNING_SECONDS := 1.4
const SLOW_SECONDS := 1.6
const LANE_CENTERS := [337.0, 403.0]
const HALF_WIDTH := 34.0
const MIN_X := 130.0
const MAX_X := 1130.0
const PUSH_DISTANCE := 43.0
const SLOW_MULTIPLIER := 0.70

var combat_units: Array[BattleUnit] = []
var slowed_units: Array[BattleUnit] = []
var running := false
var phase := WAITING
var remaining := INITIAL_DELAY
var next_lane_index := 0
var current_center_y: float = 337.0

var warnings := 0
var surges := 0
var units_pushed := 0
var slow_resets := 0


func _ready() -> void:
	set_process(false)
	# Wave highlight stays under live units (their z_index tracks floor Y).
	z_index = 90


func configure(participants: Array[BattleUnit]) -> void:
	stop_surge()
	combat_units = participants.duplicate()
	warnings = 0
	surges = 0
	units_pushed = 0
	slow_resets = 0
	next_lane_index = 0


func start_surge() -> void:
	if combat_units.is_empty():
		return
	_clear_slow()
	running = true
	phase = WAITING
	remaining = INITIAL_DELAY
	set_process(true)


func stop_surge() -> void:
	_clear_slow()
	running = false
	phase = WAITING
	remaining = INITIAL_DELAY
	set_process(false)
	queue_redraw()


func _process(delta: float) -> void:
	advance_battle(delta)


# Public deterministic update for the 54-case Godot smoke matrix.
func advance_battle(delta: float) -> void:
	if not running:
		return
	remaining -= maxf(delta, 0.0)
	if remaining > 0.0:
		return
	match phase:
		WAITING:
			current_center_y = float(LANE_CENTERS[next_lane_index])
			next_lane_index = (next_lane_index + 1) % LANE_CENTERS.size()
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
	queue_redraw()


func _lane_rect() -> Rect2:
	return Rect2(Vector2(MIN_X, current_center_y - HALF_WIDTH), Vector2(MAX_X - MIN_X, HALF_WIDTH * 2.0))


func _apply_wave() -> void:
	_clear_slow()
	var lane := _lane_rect()
	for unit in combat_units:
		if not is_instance_valid(unit) or not unit.alive or not unit.combat_started:
			continue
		if not lane.has_point(unit.position):
			continue
		# Both teams are affected. Movement respects the same battle-floor
		# bounds as their AI; no unit can be pushed off the pier.
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


func _draw() -> void:
	if not running or phase == WAITING:
		return
	var lane := _lane_rect()
	if phase == WARNING:
		draw_rect(lane, Color(0.92, 0.52, 0.25, 0.11), true)
		draw_rect(lane, Color(0.98, 0.67, 0.32, 0.83), false, 2.0)
	else:
		draw_rect(lane, Color(0.28, 0.65, 0.84, 0.21), true)
		draw_line(lane.position, lane.position + Vector2(lane.size.x, 0.0), Color(0.63, 0.89, 1.0, 0.8), 3.0)
		draw_line(lane.position + Vector2(0.0, lane.size.y), lane.end, Color(0.63, 0.89, 1.0, 0.8), 3.0)
