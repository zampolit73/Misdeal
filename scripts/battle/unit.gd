class_name BattleUnit
extends Node2D

signal died(unit: BattleUnit)
signal placement_rejected(unit: BattleUnit)

@export var team: int = 0
@export var display_name: String = "Unit"
@export var max_hp: float = 100.0
@export var damage: float = 12.0
@export var attack_interval: float = 0.8
@export var attack_range: float = 54.0
@export var move_speed: float = 90.0
@export var body_radius: float = 22.0

var hp: float
var combat_started := false
var alive := true
var target: BattleUnit
var attack_cooldown := 0.0

var placement_enabled := false
var placement_bounds := Rect2()
var dragging := false
var drag_offset := Vector2.ZERO
var drag_origin := Vector2.ZERO

@onready var name_label: Label = $NameLabel
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	hp = max_hp
	add_to_group("combat_units")
	name_label.text = display_name
	health_bar.max_value = max_hp
	health_bar.value = hp
	queue_redraw()

func enable_placement(bounds: Rect2) -> void:
	if team != 0:
		return

	placement_bounds = bounds
	placement_enabled = true
	queue_redraw()

func disable_placement() -> void:
	placement_enabled = false
	dragging = false
	z_index = int(position.y)
	queue_redraw()

func start_combat() -> void:
	disable_placement()
	combat_started = true
	attack_cooldown = randf_range(0.0, 0.25)

func _unhandled_input(event: InputEvent) -> void:
	if not placement_enabled or combat_started or not alive or team != 0:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if global_position.distance_to(get_global_mouse_position()) <= body_radius + 10.0:
				dragging = true
				drag_origin = position
				drag_offset = position - _mouse_position_in_parent()
				z_index = 1000
				queue_redraw()
				get_viewport().set_input_as_handled()
		elif dragging:
			dragging = false

			if _overlaps_friendly_unit():
				position = drag_origin
				placement_rejected.emit(self)

			z_index = int(position.y)
			queue_redraw()
			get_viewport().set_input_as_handled()

	if event is InputEventMouseMotion and dragging:
		var desired_position := _mouse_position_in_parent() + drag_offset
		var min_position := placement_bounds.position + Vector2(body_radius, body_radius)
		var max_position := placement_bounds.position + placement_bounds.size - Vector2(body_radius, body_radius)

		position = Vector2(
			clampf(desired_position.x, min_position.x, max_position.x),
			clampf(desired_position.y, min_position.y, max_position.y)
		)

		queue_redraw()
		get_viewport().set_input_as_handled()

func _mouse_position_in_parent() -> Vector2:
	return get_parent().to_local(get_global_mouse_position())

func _overlaps_friendly_unit() -> bool:
	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if unit == self or not unit.alive or unit.team != team:
			continue

		var minimum_distance := body_radius + unit.body_radius + 10.0
		if position.distance_to(unit.position) < minimum_distance:
			return true

	return false

func _process(delta: float) -> void:
	if not combat_started or not alive:
		return

	if not _is_valid_target(target):
		target = _find_nearest_enemy()

	if target == null:
		return

	var distance := global_position.distance_to(target.global_position)
	var desired_range := attack_range + target.body_radius

	if distance > desired_range:
		var direction := global_position.direction_to(target.global_position)
		position += direction * move_speed * delta
	else:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			_attack_target()

	z_index = int(position.y)

func _is_valid_target(candidate: BattleUnit) -> bool:
	return candidate != null and is_instance_valid(candidate) and candidate.alive and candidate.team != team

func _find_nearest_enemy() -> BattleUnit:
	var nearest: BattleUnit = null
	var nearest_distance := INF

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.team == team:
			continue

		var distance := global_position.distance_squared_to(unit.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = unit

	return nearest

func _attack_target() -> void:
	if not _is_valid_target(target):
		target = null
		return

	attack_cooldown = attack_interval
	target.take_damage(damage)

func take_damage(amount: float) -> void:
	if not alive:
		return

	hp = maxf(0.0, hp - amount)
	health_bar.value = hp
	queue_redraw()

	if hp <= 0.0:
		_die()

func _die() -> void:
	alive = false
	combat_started = false
	placement_enabled = false
	dragging = false
	target = null
	health_bar.value = 0.0
	name_label.text = "%s  ✝" % display_name
	modulate.a = 0.35
	queue_redraw()
	died.emit(self)

func _draw() -> void:
	var body_color := Color(0.20, 0.56, 0.95, 1.0) if team == 0 else Color(0.78, 0.72, 0.64, 1.0)
	var outline_color := Color(0.80, 0.90, 1.0, 1.0) if team == 0 else Color(0.95, 0.35, 0.30, 1.0)

	draw_circle(Vector2.ZERO, body_radius, body_color)
	draw_arc(Vector2.ZERO, body_radius, 0.0, TAU, 32, outline_color, 3.0)

	if placement_enabled and team == 0 and alive:
		var placement_color := Color(0.72, 0.92, 1.0, 1.0) if dragging else Color(0.42, 0.72, 0.90, 0.70)
		draw_arc(Vector2.ZERO, body_radius + 8.0, 0.0, TAU, 32, placement_color, 2.0)

	if alive and target != null and is_instance_valid(target) and target.alive:
		var local_target := to_local(target.global_position)
		var direction := local_target.normalized()
		draw_line(direction * body_radius, direction * (body_radius + 9.0), outline_color, 3.0)
