class_name LastRiteController
extends Node2D

# Encounter-scoped ritual. Does not affect the old Grave Bellkeeper, Whistle,
# global targeting rules, party-size scalers, or any other card.
const IDLE := 0
const WAITING := 1
const TELEGRAPH := 2
const FURY := 3

var data: LastRiteData
var priest: BattleUnit
var bearers: Array[BattleUnit] = []
var phase: int = IDLE
var seconds_remaining := 0.0
var revival_spent := false
var warning_count := 0
var revive_count := 0
var fury_count := 0
var cancelled_count := 0
var _base_attack_intervals: Dictionary = {}


func _ready() -> void:
	set_process(false)
	z_index = 1600


func configure(leader: BattleUnit, attendants: Array[BattleUnit], tuning: LastRiteData) -> void:
	stop_rite()
	priest = leader
	bearers = attendants.duplicate()
	data = tuning
	revival_spent = false
	warning_count = 0
	revive_count = 0
	fury_count = 0
	cancelled_count = 0
	if is_instance_valid(priest) and not priest.died.is_connected(_on_priest_died):
		priest.died.connect(_on_priest_died)


func start_rite() -> void:
	if data == null or not is_instance_valid(priest) or not priest.alive:
		return
	if bearers.size() != 2:
		push_warning("Last Rite expects exactly two authored pallbearers.")
		return
	phase = WAITING
	seconds_remaining = data.initial_delay
	set_process(true)


func _process(delta: float) -> void:
	advance_battle(delta)


func advance_battle(delta: float) -> void:
	if phase == IDLE or data == null:
		return
	if not is_instance_valid(priest) or not priest.alive:
		stop_rite()
		return
	seconds_remaining -= maxf(0.0, delta)
	if phase == TELEGRAPH:
		queue_redraw()
	if seconds_remaining > 0.0:
		return
	match phase:
		WAITING:
			phase = TELEGRAPH
			warning_count += 1
			seconds_remaining = data.telegraph_seconds
			queue_redraw()
		TELEGRAPH:
			_resolve_rite()
		FURY:
			_finish_fury()


func _resolve_rite() -> void:
	if not priest.alive:
		stop_rite()
		return
	if not revival_spent:
		for bearer in bearers:
			if is_instance_valid(bearer) and not bearer.alive:
				if bearer.revive_from_last_rite(data.revive_hp_fraction):
					revival_spent = true
					revive_count += 1
					phase = WAITING
					seconds_remaining = data.cooldown_seconds
					queue_redraw()
					return
	# Revive is unavailable or not needed: speed up only living pallbearers
	# for one short window; restore their original cadence afterwards.
	_base_attack_intervals.clear()
	for bearer in bearers:
		if not is_instance_valid(bearer) or not bearer.alive:
			continue
		_base_attack_intervals[bearer.get_instance_id()] = bearer.attack_interval
		bearer.attack_interval = maxf(0.25, bearer.attack_interval * data.fury_attack_interval_multiplier)
	if _base_attack_intervals.is_empty():
		phase = WAITING
		seconds_remaining = data.cooldown_seconds
		queue_redraw()
		return
	fury_count += 1
	phase = FURY
	seconds_remaining = data.fury_seconds
	queue_redraw()


func _finish_fury() -> void:
	_restore_fury()
	phase = WAITING
	seconds_remaining = maxf(0.1, data.cooldown_seconds - data.fury_seconds)
	queue_redraw()


func _restore_fury() -> void:
	for bearer in bearers:
		if is_instance_valid(bearer) and _base_attack_intervals.has(bearer.get_instance_id()):
			bearer.attack_interval = float(_base_attack_intervals[bearer.get_instance_id()])
	_base_attack_intervals.clear()


func stop_rite() -> void:
	if phase == TELEGRAPH:
		cancelled_count += 1
	_restore_fury()
	phase = IDLE
	seconds_remaining = 0.0
	set_process(false)
	queue_redraw()


func _on_priest_died(dead: BattleUnit) -> void:
	if dead == priest:
		stop_rite()


func _draw() -> void:
	if phase != TELEGRAPH or not is_instance_valid(priest) or not priest.alive:
		return
	# A small red sigil and funerary flame, not the existing bell wave.
	var center := to_local(priest.global_position) + Vector2(0.0, -68.0)
	var ember := Color(0.90, 0.42, 0.24, 0.92)
	var sigil := Color(0.60, 0.16, 0.19, 0.86)
	draw_arc(center, 20.0, 0.0, TAU, 24, sigil, 2.2, false)
	for i in range(5):
		var start := center + Vector2.from_angle(-PI * 0.5 + float(i) * TAU / 5.0) * 19.0
		var end := center + Vector2.from_angle(-PI * 0.5 + float((i + 2) % 5) * TAU / 5.0) * 19.0
		draw_line(start, end, Color(0.72, 0.24, 0.22, 0.80), 1.6, false)
	draw_line(center + Vector2(0.0, -20.0), center + Vector2(-5.0, -34.0), ember, 2.0, false)
	draw_line(center + Vector2(-5.0, -34.0), center + Vector2(0.0, -46.0), ember, 2.0, false)
	for bearer in bearers:
		if not is_instance_valid(bearer):
			continue
		var marker := to_local(bearer.global_position) + Vector2(0.0, -54.0)
		draw_arc(marker, 8.0, PI * 0.2, PI * 0.8, 12, sigil, 2.0, false)
