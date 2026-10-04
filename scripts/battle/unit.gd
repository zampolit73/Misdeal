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
@export var minimum_range: float = 0.0
@export var splash_radius: float = 0.0
@export var splash_damage_multiplier: float = 0.0
@export var move_speed: float = 90.0
@export var body_radius: float = 22.0
@export var separation_padding: float = 10.0
@export var separation_strength: float = 120.0

var unit_data: UnitData
var hp: float
var combat_started := false
var alive := true
var target: BattleUnit
var attack_cooldown := 0.0

var placement_enabled := false
var placement_bounds := Rect2()
var combat_bounds := Rect2()
var dragging := false
var drag_offset := Vector2.ZERO
var drag_origin := Vector2.ZERO

var hit_flash_time := 0.0
var hit_pulse_tween: Tween
var death_tween: Tween

@onready var name_label: Label = $NameLabel
@onready var health_bar: ProgressBar = $HealthBar

func configure(data: UnitData, unit_team: int, spawn_position: Vector2, name_override: String = "") -> void:
	unit_data = data
	team = unit_team
	position = spawn_position
	display_name = data.unit_name if name_override.is_empty() else name_override
	max_hp = data.max_hp
	damage = data.damage
	attack_interval = data.attack_interval
	attack_range = data.attack_range
	minimum_range = data.minimum_range
	splash_radius = data.splash_radius
	splash_damage_multiplier = data.splash_damage_multiplier
	move_speed = data.move_speed
	body_radius = data.body_radius
	separation_padding = data.separation_padding
	separation_strength = data.separation_strength

func _ready() -> void:
	hp = max_hp
	add_to_group("combat_units")
	name_label.text = display_name
	health_bar.max_value = max_hp
	health_bar.value = hp
	queue_redraw()

func set_combat_bounds(bounds: Rect2) -> void:
	combat_bounds = bounds

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

func _input(event: InputEvent) -> void:
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
	if hit_flash_time > 0.0:
		hit_flash_time = maxf(0.0, hit_flash_time - delta)
		queue_redraw()

	if not combat_started or not alive:
		return

	if not _is_valid_target(target):
		target = _find_nearest_enemy()

	var velocity := _get_separation_velocity()

	if target != null:
		var distance := global_position.distance_to(target.global_position)
		var desired_max_range := attack_range + target.body_radius
		var desired_min_range := minimum_range + target.body_radius

		if minimum_range > 0.0 and distance < desired_min_range:
			var retreat_direction := target.global_position.direction_to(global_position)

			if _can_move_in_direction(retreat_direction, delta):
				velocity += retreat_direction * move_speed
			else:
				attack_cooldown -= delta
				if attack_cooldown <= 0.0:
					_attack_target()
		elif distance > desired_max_range:
			var direction := global_position.direction_to(target.global_position)
			velocity += direction * move_speed
		else:
			attack_cooldown -= delta
			if attack_cooldown <= 0.0:
				_attack_target()

	position += velocity.limit_length(move_speed * 1.35) * delta
	_clamp_to_combat_bounds()
	z_index = int(position.y)
	queue_redraw()

func _can_move_in_direction(direction: Vector2, delta: float) -> bool:
	if combat_bounds.size == Vector2.ZERO:
		return true

	var step := direction.normalized() * move_speed * delta
	var candidate := position + step
	var clamped_candidate := _clamped_combat_position(candidate)

	return candidate.distance_to(clamped_candidate) < 0.5

func _clamp_to_combat_bounds() -> void:
	if combat_bounds.size == Vector2.ZERO:
		return

	position = _clamped_combat_position(position)

func _clamped_combat_position(candidate: Vector2) -> Vector2:
	var min_position := combat_bounds.position + Vector2(body_radius, body_radius)
	var max_position := combat_bounds.position + combat_bounds.size - Vector2(body_radius, body_radius)

	return Vector2(
		clampf(candidate.x, min_position.x, max_position.x),
		clampf(candidate.y, min_position.y, max_position.y)
	)

func _get_separation_velocity() -> Vector2:
	var separation := Vector2.ZERO

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if unit == self or not unit.alive:
			continue

		var offset := position - unit.position
		var distance := offset.length()
		var minimum_distance := body_radius + unit.body_radius + separation_padding

		if distance >= minimum_distance:
			continue

		if distance < 0.001:
			offset = Vector2.LEFT if get_instance_id() < unit.get_instance_id() else Vector2.RIGHT
			distance = 0.001

		var overlap_ratio := (minimum_distance - distance) / minimum_distance
		separation += offset.normalized() * separation_strength * overlap_ratio

	return separation

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
	var primary_target := target
	var impact_position := primary_target.global_position
	primary_target.take_damage(damage)

	if splash_radius <= 0.0 or splash_damage_multiplier <= 0.0:
		return

	var splash_damage := damage * splash_damage_multiplier

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if unit == primary_target or not unit.alive or unit.team == team:
			continue

		if unit.global_position.distance_to(impact_position) <= splash_radius:
			unit.take_damage(splash_damage)

func take_damage(amount: float) -> void:
	if not alive:
		return

	_show_damage_number(amount)
	_play_hit_feedback()

	hp = maxf(0.0, hp - amount)
	health_bar.value = hp
	queue_redraw()

	if hp <= 0.0:
		_die()

func _play_hit_feedback() -> void:
	hit_flash_time = 0.12

	if hit_pulse_tween != null and hit_pulse_tween.is_valid():
		hit_pulse_tween.kill()

	scale = Vector2(1.12, 1.12)
	hit_pulse_tween = create_tween()
	hit_pulse_tween.tween_property(self, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _show_damage_number(amount: float) -> void:
	if get_parent() == null:
		return

	var damage_label := Label.new()
	damage_label.text = "-%d" % int(round(amount))
	damage_label.position = position + Vector2(-28.0, -70.0)
	damage_label.size = Vector2(56.0, 28.0)
	damage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_label.z_index = 2000
	damage_label.add_theme_font_size_override("font_size", 18)
	damage_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.58, 1.0))
	get_parent().add_child(damage_label)

	var float_tween := damage_label.create_tween()
	float_tween.set_parallel(true)
	float_tween.tween_property(damage_label, "position", damage_label.position + Vector2(0.0, -30.0), 0.42)
	float_tween.tween_property(damage_label, "modulate:a", 0.0, 0.42)
	float_tween.chain().tween_callback(damage_label.queue_free)

func _die() -> void:
	alive = false
	combat_started = false
	placement_enabled = false
	dragging = false
	target = null
	health_bar.value = 0.0
	name_label.text = "%s  ✝" % display_name

	if hit_pulse_tween != null and hit_pulse_tween.is_valid():
		hit_pulse_tween.kill()

	death_tween = create_tween()
	death_tween.set_parallel(true)
	death_tween.tween_property(self, "scale", Vector2(0.72, 0.72), 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	death_tween.tween_property(self, "modulate:a", 0.22, 0.22)

	queue_redraw()
	died.emit(self)

func _draw() -> void:
	var body_color := Color(0.20, 0.56, 0.95, 1.0) if team == 0 else Color(0.78, 0.72, 0.64, 1.0)
	var outline_color := Color(0.80, 0.90, 1.0, 1.0) if team == 0 else Color(0.95, 0.35, 0.30, 1.0)

	if hit_flash_time > 0.0:
		body_color = body_color.lerp(Color.WHITE, 0.82)
		outline_color = Color.WHITE

	draw_circle(Vector2.ZERO, body_radius, body_color)
	draw_arc(Vector2.ZERO, body_radius, 0.0, TAU, 32, outline_color, 3.0)

	if placement_enabled and team == 0 and alive:
		var placement_color := Color(0.72, 0.92, 1.0, 1.0) if dragging else Color(0.42, 0.72, 0.90, 0.70)
		draw_arc(Vector2.ZERO, body_radius + 8.0, 0.0, TAU, 32, placement_color, 2.0)

	if alive and target != null and is_instance_valid(target) and target.alive:
		var local_target := to_local(target.global_position)
		var direction := local_target.normalized()
		draw_line(direction * body_radius, direction * (body_radius + 9.0), outline_color, 3.0)
