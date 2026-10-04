class_name BattleUnit
extends Node2D

signal died(unit: BattleUnit)

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

@onready var name_label: Label = $NameLabel
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	hp = max_hp
	add_to_group("combat_units")
	name_label.text = display_name
	health_bar.max_value = max_hp
	health_bar.value = hp
	queue_redraw()

func start_combat() -> void:
	combat_started = true
	attack_cooldown = randf_range(0.0, 0.25)

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

	if alive and target != null and is_instance_valid(target) and target.alive:
		var local_target := to_local(target.global_position)
		var direction := local_target.normalized()
		draw_line(direction * body_radius, direction * (body_radius + 9.0), outline_color, 3.0)
