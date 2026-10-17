class_name BlackLanternLightController
extends Node2D

# D206: encounter-scoped implementation candidate. Not wired into battle.gd.
# All coordinates are relative to Battle/UnitsLayer. Pool Y values describe
# boot contact (+36px from BattleUnit origin), not the horizon or HUD.
const WARNING_SECONDS: float = 1.4
const ACTIVE_SECONDS: float = 3.1
const REST_SECONDS: float = 1.8
const CYCLE_SECONDS: float = WARNING_SECONDS + ACTIVE_SECONDS + REST_SECONDS
const ATTACK_SPEED_MULTIPLIER: float = 1.16
const POOL_RADIUS: float = 93.0
const FOOT_OFFSET: Vector2 = Vector2(0.0, 36.0)
const ZONES_A: Array[Vector2] = [Vector2(852.0, 377.0), Vector2(1048.0, 407.0)]
const ZONES_B: Array[Vector2] = [Vector2(958.0, 404.0), Vector2(1076.0, 342.0)]

var participants: Array[BattleUnit] = []
var enemy_base_intervals: Dictionary = {}
var running: bool = false
var elapsed: float = 0.0
var buffed_enemy_count: int = 0

func _ready() -> void:
	# Root battle units have dynamic z from their feet. This element must
	# stay UNDER characters and above arena art, never over health bars.
	z_index = 90
	set_process(false)

func configure(units: Array[BattleUnit]) -> void:
	stop_light()
	participants = units.duplicate()
	enemy_base_intervals.clear()
	for unit in participants:
		if not is_instance_valid(unit) or unit.team != 1:
			continue
		enemy_base_intervals[unit.get_instance_id()] = unit.attack_interval

func start_light() -> void:
	if enemy_base_intervals.is_empty():
		return
	elapsed = 0.0
	running = true
	buffed_enemy_count = 0
	set_process(true)
	_update_enemy_intervals()
	queue_redraw()

func stop_light() -> void:
	# Restore every surviving enemy to its original combat interval. This
	# must also happen on victory/defeat before the battle scene is removed.
	for unit in participants:
		if not is_instance_valid(unit) or unit.team != 1:
			continue
		var key: int = unit.get_instance_id()
		if enemy_base_intervals.has(key):
			unit.attack_interval = float(enemy_base_intervals[key])
	running = false
	elapsed = 0.0
	buffed_enemy_count = 0
	set_process(false)
	queue_redraw()

func _exit_tree() -> void:
	stop_light()

func _process(delta: float) -> void:
	advance_battle(delta)

# Deterministic stepping so future solo/duo/trio QA can drive exact phases.
func advance_battle(delta: float) -> void:
	if not running:
		return
	elapsed += maxf(0.0, delta)
	_update_enemy_intervals()
	queue_redraw()

func get_phase() -> String:
	if not running:
		return "idle"
	var time_in_cycle: float = fposmod(elapsed, CYCLE_SECONDS)
	if time_in_cycle < WARNING_SECONDS:
		return "warning"
	if time_in_cycle < WARNING_SECONDS + ACTIVE_SECONDS:
		return "active"
	return "rest"

func get_pool_centers() -> Array[Vector2]:
	var cycle_index: int = int(floorf(elapsed / CYCLE_SECONDS))
	var set_a: bool = cycle_index % 2 == 0
	var targets: Array[Vector2] = ZONES_A
	var previous: Array[Vector2] = ZONES_B
	if not set_a:
		targets = ZONES_B
		previous = ZONES_A
	var time_in_cycle: float = fposmod(elapsed, CYCLE_SECONDS)
	var factor: float = 0.0
	if time_in_cycle >= WARNING_SECONDS:
		var active_fraction: float = clampf((time_in_cycle - WARNING_SECONDS) / ACTIVE_SECONDS, 0.0, 1.0)
		factor = smoothstep(0.0, 0.70, active_fraction)
	var centers: Array[Vector2] = []
	for i in range(targets.size()):
		centers.append(previous[i].lerp(targets[i], factor))
	return centers

func get_warning_centers() -> Array[Vector2]:
	var cycle_index: int = int(floorf(elapsed / CYCLE_SECONDS))
	if cycle_index % 2 == 0:
		return ZONES_A
	return ZONES_B

func _update_enemy_intervals() -> void:
	buffed_enemy_count = 0
	var active: bool = get_phase() == "active"
	var centers: Array[Vector2] = []
	if active:
		centers = get_pool_centers()
	for unit in participants:
		if not is_instance_valid(unit) or unit.team != 1:
			continue
		var key: int = unit.get_instance_id()
		if not enemy_base_intervals.has(key):
			continue
		var original_interval: float = float(enemy_base_intervals[key])
		var illuminated: bool = false
		if active and unit.alive:
			for center in centers:
				if (unit.position + FOOT_OFFSET).distance_squared_to(center) <= POOL_RADIUS * POOL_RADIUS:
					illuminated = true
					break
		unit.attack_interval = maxf(0.2, original_interval / ATTACK_SPEED_MULTIPLIER) if illuminated else original_interval
		if illuminated:
			buffed_enemy_count += 1

func _draw() -> void:
	if not running:
		return
	var phase: String = get_phase()
	if phase == "warning":
		var flicker: float = 0.45 + 0.20 * absf(sin(elapsed * 6.0))
		for center in get_warning_centers():
			draw_arc(center, POOL_RADIUS, 0.0, TAU, 60, Color(1.0, 0.72, 0.35, flicker), 2.0, true)
	elif phase == "active":
		for center in get_pool_centers():
			draw_circle(center, POOL_RADIUS, Color(0.92, 0.52, 0.18, 0.14))
			draw_circle(center, POOL_RADIUS * 0.66, Color(1.0, 0.72, 0.31, 0.08))
			draw_arc(center, POOL_RADIUS, 0.0, TAU, 60, Color(1.0, 0.74, 0.39, 0.60), 2.0, true)
