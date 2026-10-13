class_name BoneShepherdWhistleController
extends Node2D

# Isolated, encounter-specific special. Never modifies legacy enemies or hero AI.
const WAITING := 0
const TELEGRAPH := 1
const RUSH := 2
const IDLE := 3

var data: BoneShepherdWhistleData
var shepherd: BattleUnit
var lambs: Array[BattleUnit] = []
var shared_target: BattleUnit
var phase: int = IDLE
var seconds_remaining := 0.0
var warning_count := 0
var rush_count := 0
var expiry_count := 0

func _ready() -> void:
	set_process(false)
	z_index = 1600

func configure(leader: BattleUnit, followers: Array[BattleUnit], tuning: BoneShepherdWhistleData) -> void:
	shepherd = leader
	lambs = followers.duplicate()
	data = tuning
	if shepherd != null and not shepherd.died.is_connected(_on_shepherd_died):
		shepherd.died.connect(_on_shepherd_died)

func start_whistle() -> void:
	if data == null or not is_instance_valid(shepherd) or not shepherd.alive:
		return
	if not _living_lambs().is_empty():
		phase = WAITING
		seconds_remaining = data.initial_delay
		set_process(true)

func _process(delta: float) -> void:
	advance_battle(delta)

func advance_battle(delta: float) -> void:
	if phase == IDLE or data == null:
		return
	if _living_lambs().is_empty():
		stop_whistle()
		return
	if phase != RUSH and (not is_instance_valid(shepherd) or not shepherd.alive):
		stop_whistle()
		return
	seconds_remaining -= delta
	if phase == TELEGRAPH or phase == RUSH:
		queue_redraw()
	if phase == RUSH and (not is_instance_valid(shared_target) or not shared_target.alive):
		shared_target = _choose_target()
		if shared_target == null:
			_finish_rush()
			return
		for lamb in _living_lambs():
			lamb.begin_shepherd_rush(shared_target, data.lamb_speed_multiplier)
	if seconds_remaining > 0.0:
		return
	match phase:
		WAITING:
			_begin_warning()
		TELEGRAPH:
			_begin_rush()
		RUSH:
			_finish_rush()

func _begin_warning() -> void:
	shared_target = _choose_target()
	if shared_target == null:
		stop_whistle()
		return
	phase = TELEGRAPH
	seconds_remaining = data.warning_seconds
	warning_count += 1
	queue_redraw()

func _begin_rush() -> void:
	if not is_instance_valid(shepherd) or not shepherd.alive:
		stop_whistle()
		return
	if not is_instance_valid(shared_target) or not shared_target.alive:
		shared_target = _choose_target()
	if shared_target == null:
		stop_whistle()
		return
	phase = RUSH
	seconds_remaining = data.rush_seconds
	rush_count += 1
	for lamb in _living_lambs():
		lamb.begin_shepherd_rush(shared_target, data.lamb_speed_multiplier)
	queue_redraw()

func _finish_rush() -> void:
	for lamb in lambs:
		if is_instance_valid(lamb):
			lamb.clear_shepherd_rush()
	expiry_count += 1
	shared_target = null
	if not is_instance_valid(shepherd) or not shepherd.alive or _living_lambs().is_empty():
		stop_whistle()
		return
	phase = WAITING
	# The period is measured from the START of the preceding rush.
	seconds_remaining = maxf(0.1, data.period_seconds - data.rush_seconds)
	queue_redraw()

func stop_whistle() -> void:
	for lamb in lambs:
		if is_instance_valid(lamb):
			lamb.clear_shepherd_rush()
	phase = IDLE
	seconds_remaining = 0.0
	shared_target = null
	set_process(false)
	queue_redraw()

func _on_shepherd_died(dead: BattleUnit) -> void:
	if dead != shepherd:
		return
	# An issued rush still finishes; a whistle that is only warning is cancelled.
	if phase != RUSH:
		stop_whistle()

func _living_lambs() -> Array[BattleUnit]:
	var live: Array[BattleUnit] = []
	for lamb in lambs:
		if is_instance_valid(lamb) and lamb.alive:
			live.append(lamb)
	return live

func _choose_target() -> BattleUnit:
	var live_lambs := _living_lambs()
	if live_lambs.is_empty():
		return null
	var center := Vector2.ZERO
	for lamb in live_lambs:
		center += lamb.global_position
	center /= float(live_lambs.size())
	var nearest: BattleUnit
	var best := INF
	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue
		var unit := node as BattleUnit
		if not unit.alive or unit.team != 0:
			continue
		var distance := center.distance_squared_to(unit.global_position)
		if distance > data.max_target_distance * data.max_target_distance:
			continue
		if distance < best:
			best = distance
			nearest = unit
	return nearest

func _draw() -> void:
	if phase != TELEGRAPH or not is_instance_valid(shepherd) or not shepherd.alive:
		return
	# Small localized red horn-shaped mark, not an arena-wide debuff.
	var center := to_local(shepherd.global_position) + Vector2(0, -65)
	draw_arc(center, 15.0, PI * 0.12, PI * 0.88, 12, Color(0.65, 0.17, 0.19, 0.85), 2.6, false)
	draw_arc(center, 15.0, PI * 1.12, PI * 1.88, 12, Color(0.65, 0.17, 0.19, 0.85), 2.6, false)
	draw_line(center + Vector2(0, -16), center + Vector2(0, -29), Color(0.96, 0.66, 0.36), 2.0, false)
	for lamb in _living_lambs():
		var tip := to_local(lamb.global_position) + Vector2(0, -49)
		draw_line(tip + Vector2(-9, 0), tip + Vector2(0, -9), Color(0.76, 0.22, 0.24, 0.90), 3.0, false)
		draw_line(tip + Vector2(0, -9), tip + Vector2(9, 0), Color(0.76, 0.22, 0.24, 0.90), 3.0, false)
