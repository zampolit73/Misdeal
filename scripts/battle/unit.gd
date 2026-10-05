class_name BattleUnit
extends Node2D

const UNIT_TILE_SIZE: float = 96.0
const UNIT_SHEET_PARTS: Array[String] = [
	"res://assets/pixel/units/combat_units_v3/part_00.txt",
	"res://assets/pixel/units/combat_units_v3/part_01.txt",
	"res://assets/pixel/units/combat_units_v3/part_02.txt",
	"res://assets/pixel/units/combat_units_v3/part_03.txt",
	"res://assets/pixel/units/combat_units_v3/part_04.txt",
	"res://assets/pixel/units/combat_units_v3/part_05.txt",
	"res://assets/pixel/units/combat_units_v3/part_06.txt",
	"res://assets/pixel/units/combat_units_v3/part_07.txt",
	"res://assets/pixel/units/combat_units_v3/part_08.txt",
	"res://assets/pixel/units/combat_units_v3/part_09.txt",
]

signal died(unit: BattleUnit)
signal boss_enraged(unit: BattleUnit)
signal placement_rejected(unit: BattleUnit)

@export var team: int = 0
@export var display_name: String = "Unit"
@export var visual_role: String = "unit"
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
@export var visual_scale: float = 1.0
@export var show_enemy_name: bool = false
@export var support_heal_interval: float = 0.0
@export var support_heal_radius: float = 0.0
@export var support_heal_amount: float = 0.0
@export var is_boss: bool = false
@export var enrage_threshold: float = 0.0
@export var enrage_damage_multiplier: float = 1.0
@export var enrage_attack_interval_multiplier: float = 1.0
@export var enrage_move_speed_multiplier: float = 1.0

var unit_data: UnitData
var hp: float
var combat_started := false
var alive := true
var target: BattleUnit
var attack_cooldown := 0.0
var support_cooldown := 0.0
var enraged := false
var base_art_modulate := Color.WHITE

var placement_enabled := false
var placement_bounds := Rect2()
var combat_bounds := Rect2()
var dragging := false
var drag_offset := Vector2.ZERO
var drag_origin := Vector2.ZERO

var hit_flash_time := 0.0
var hit_pulse_tween: Tween
var attack_tween: Tween
var death_tween: Tween
var unit_sheet_texture: Texture2D

@onready var art_sprite: Sprite2D = $ArtSprite
@onready var name_label: Label = $NameLabel
@onready var health_bar: ProgressBar = $HealthBar

func configure(data: UnitData, unit_team: int, spawn_position: Vector2, name_override: String = "") -> void:
	unit_data = data
	team = unit_team
	position = spawn_position
	display_name = data.unit_name if name_override.is_empty() else name_override
	visual_role = data.visual_role
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
	visual_scale = data.visual_scale
	show_enemy_name = data.show_enemy_name
	support_heal_interval = data.support_heal_interval
	support_heal_radius = data.support_heal_radius
	support_heal_amount = data.support_heal_amount
	is_boss = data.is_boss
	enrage_threshold = data.enrage_threshold
	enrage_damage_multiplier = data.enrage_damage_multiplier
	enrage_attack_interval_multiplier = data.enrage_attack_interval_multiplier
	enrage_move_speed_multiplier = data.enrage_move_speed_multiplier

func _ready() -> void:
	hp = max_hp
	add_to_group("combat_units")
	name_label.text = display_name
	name_label.visible = team == 0 or is_boss or show_enemy_name
	art_sprite.texture = _get_art_texture()
	var sprite_scale: float = 1.10 if is_boss else 1.08
	art_sprite.scale = Vector2.ONE * (sprite_scale * visual_scale)
	_apply_role_presentation()
	_apply_health_bar_style()
	_apply_boss_layout()
	health_bar.max_value = max_hp
	health_bar.value = hp
	queue_redraw()

func _get_art_texture() -> Texture2D:
	var tile := Vector2i(-1, -1)
	match visual_role:
		"knight":
			tile = Vector2i(0, 0)
		"ranger":
			tile = Vector2i(1, 0)
		"mage":
			tile = Vector2i(2, 0)
		"skeleton":
			tile = Vector2i(0, 1)
		"bone_archer":
			tile = Vector2i(1, 1)
		"grave_bellkeeper":
			tile = Vector2i(2, 1)
		"bone_thrall":
			tile = Vector2i(0, 2)
		"crypt_guard":
			tile = Vector2i(1, 2)
		"bone_warden":
			tile = Vector2i(2, 2)
		_:
			return null

	var sheet: Texture2D = _get_unit_sheet_texture()
	if sheet == null:
		return null

	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(tile.x) * UNIT_TILE_SIZE, float(tile.y) * UNIT_TILE_SIZE),
		Vector2(UNIT_TILE_SIZE, UNIT_TILE_SIZE)
	)
	return atlas

func _get_unit_sheet_texture() -> Texture2D:
	if unit_sheet_texture != null:
		return unit_sheet_texture

	var encoded: String = ""
	for part_path in UNIT_SHEET_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing production combat unit atlas part: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Production combat unit atlas base64 decode failed.")
		return null

	var image := Image.new()
	var error := image.load_png_from_buffer(bytes)
	if error != OK:
		push_error("Production combat unit atlas PNG decode failed: %s" % error_string(error))
		return null

	if image.get_width() != 288 or image.get_height() != 288:
		push_error(
			"Production combat unit atlas decoded at %dx%d, expected 288x288."
			% [image.get_width(), image.get_height()]
		)
		return null

	unit_sheet_texture = ImageTexture.create_from_image(image)
	return unit_sheet_texture

func _apply_role_presentation() -> void:
	match visual_role:
		"grave_bellkeeper":
			base_art_modulate = Color.WHITE
			health_bar.offset_left = -30.0
			health_bar.offset_right = 30.0
			name_label.add_theme_color_override("font_color", Color(0.62, 0.90, 0.74, 1.0))
		"bone_thrall":
			base_art_modulate = Color.WHITE
		"crypt_guard":
			base_art_modulate = Color.WHITE
			health_bar.offset_left = -36.0
			health_bar.offset_right = 36.0
			name_label.offset_left = -72.0
			name_label.offset_right = 72.0
			name_label.add_theme_color_override("font_color", Color(0.94, 0.72, 0.46, 1.0))
		"bone_warden":
			base_art_modulate = Color.WHITE
			name_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.38, 1.0))
		_:
			base_art_modulate = Color.WHITE

	art_sprite.modulate = base_art_modulate

func _apply_boss_layout() -> void:
	if not is_boss:
		return

	health_bar.offset_left = -72.0
	health_bar.offset_top = -88.0
	health_bar.offset_right = 72.0
	health_bar.offset_bottom = -77.0
	name_label.offset_left = -112.0
	name_label.offset_top = 58.0
	name_label.offset_right = 112.0
	name_label.offset_bottom = 84.0
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.add_theme_color_override("font_color", Color(0.96, 0.72, 0.42, 1.0))

func _apply_health_bar_style() -> void:
	var background := StyleBoxFlat.new()
	background.bg_color = Color(0.025, 0.022, 0.03, 0.95)
	background.border_width_left = 1
	background.border_width_top = 1
	background.border_width_right = 1
	background.border_width_bottom = 1
	background.border_color = Color(0.13, 0.12, 0.15, 1.0)

	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.25, 0.72, 0.36, 1.0) if team == 0 else Color(0.82, 0.19, 0.17, 1.0)

	health_bar.add_theme_stylebox_override("background", background)
	health_bar.add_theme_stylebox_override("fill", fill)

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
	if team != 0 and not is_boss and not show_enemy_name:
		name_label.visible = false
	attack_cooldown = randf_range(0.0, 0.25)
	if support_heal_interval > 0.0:
		support_cooldown = support_heal_interval * 0.65

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

	_process_support(delta)

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

func _process_support(delta: float) -> void:
	if support_heal_interval <= 0.0 or support_heal_amount <= 0.0:
		return

	support_cooldown -= delta
	if support_cooldown > 0.0:
		return

	support_cooldown = support_heal_interval
	var healed_any := false

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if unit == self or not unit.alive or unit.team != team:
			continue
		if unit.hp >= unit.max_hp:
			continue
		if global_position.distance_to(unit.global_position) > support_heal_radius:
			continue

		unit.heal(support_heal_amount)
		healed_any = true

	if healed_any:
		_show_status_text("ЗВОН!", Color(0.52, 1.0, 0.68, 1.0))

func heal(amount: float) -> void:
	if not alive or amount <= 0.0:
		return

	var previous_hp := hp
	hp = minf(max_hp, hp + amount)
	var healed := hp - previous_hp
	if healed <= 0.0:
		return

	health_bar.value = hp
	_show_heal_number(healed)
	queue_redraw()

func _show_heal_number(amount: float) -> void:
	if get_parent() == null:
		return

	var heal_label := Label.new()
	heal_label.text = "+%d" % int(round(amount))
	heal_label.position = position + Vector2(-24.0, -60.0)
	heal_label.size = Vector2(48.0, 22.0)
	heal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heal_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	heal_label.z_index = 2000
	heal_label.add_theme_font_size_override("font_size", 14)
	heal_label.add_theme_color_override("font_color", Color(0.52, 1.0, 0.68, 1.0))
	get_parent().add_child(heal_label)

	var float_tween := heal_label.create_tween()
	float_tween.set_parallel(true)
	float_tween.tween_property(heal_label, "position", heal_label.position + Vector2(0.0, -28.0), 0.42)
	float_tween.tween_property(heal_label, "modulate:a", 0.0, 0.42)
	float_tween.chain().tween_callback(heal_label.queue_free)

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
	_play_attack_feedback(primary_target)
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

func _play_attack_feedback(primary_target: BattleUnit) -> void:
	if attack_tween != null and attack_tween.is_valid():
		attack_tween.kill()

	var base_position := Vector2(0.0, -12.0)
	var direction := global_position.direction_to(primary_target.global_position)
	art_sprite.position = base_position + direction * 5.0

	attack_tween = create_tween()
	attack_tween.tween_property(art_sprite, "position", base_position, 0.11).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func take_damage(amount: float) -> void:
	if not alive:
		return

	_show_damage_number(amount)
	_play_hit_feedback()

	hp = maxf(0.0, hp - amount)
	health_bar.value = hp

	if is_boss and not enraged and enrage_threshold > 0.0 and hp > 0.0:
		if hp / max_hp <= enrage_threshold:
			_trigger_enrage()

	queue_redraw()

	if hp <= 0.0:
		_die()

func _trigger_enrage() -> void:
	enraged = true
	damage *= enrage_damage_multiplier
	attack_interval = maxf(0.2, attack_interval * enrage_attack_interval_multiplier)
	move_speed *= enrage_move_speed_multiplier
	_show_status_text("ЯРОСТЬ!", Color(1.0, 0.42, 0.20, 1.0))
	boss_enraged.emit(self)
	queue_redraw()

func _show_status_text(message: String, color: Color) -> void:
	if get_parent() == null:
		return

	var label := Label.new()
	label.text = message
	label.position = position + Vector2(-54.0, -92.0)
	label.size = Vector2(108.0, 28.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = 2100
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	get_parent().add_child(label)

	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position", label.position + Vector2(0.0, -26.0), 0.55)
	tween.tween_property(label, "modulate:a", 0.0, 0.55)
	tween.chain().tween_callback(label.queue_free)

func _play_hit_feedback() -> void:
	hit_flash_time = 0.12

	if hit_pulse_tween != null and hit_pulse_tween.is_valid():
		hit_pulse_tween.kill()

	scale = Vector2(1.12, 1.12)
	art_sprite.modulate = Color(1.0, 0.62, 0.52, 1.0)
	hit_pulse_tween = create_tween()
	hit_pulse_tween.set_parallel(true)
	hit_pulse_tween.tween_property(self, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	hit_pulse_tween.tween_property(art_sprite, "modulate", base_art_modulate, 0.14)

func _show_damage_number(amount: float) -> void:
	if get_parent() == null:
		return

	var damage_label := Label.new()
	damage_label.text = "-%d" % int(round(amount))
	damage_label.position = position + Vector2(-24.0, -60.0)
	damage_label.size = Vector2(48.0, 22.0)
	damage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_label.z_index = 2000
	damage_label.add_theme_font_size_override("font_size", 14)
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
	var team_color := Color(0.20, 0.58, 1.0, 0.95) if team == 0 else Color(0.95, 0.20, 0.16, 0.95)
	var target_color := Color(0.78, 0.90, 1.0, 0.7) if team == 0 else Color(1.0, 0.58, 0.44, 0.7)
	var ring_radius := maxf(22.0, body_radius * 1.05)

	draw_set_transform(Vector2(0.0, 21.0), 0.0, Vector2(1.0, 0.34))
	draw_circle(Vector2.ZERO, ring_radius + 1.0, Color(0.0, 0.0, 0.0, 0.45))
	draw_arc(Vector2.ZERO, ring_radius, 0.0, TAU, 36, team_color, 2.5)
	if is_boss:
		var pulse := 0.5 + 0.5 * sin(float(Time.get_ticks_msec()) / 120.0)
		var boss_color := Color(1.0, 0.20 + pulse * 0.08, 0.10, 0.98) if enraged else Color(0.95, 0.58 + pulse * 0.08, 0.16, 0.92)
		draw_circle(Vector2.ZERO, ring_radius + 11.0, Color(boss_color.r, boss_color.g, boss_color.b, 0.06 + pulse * 0.05))
		draw_arc(Vector2.ZERO, ring_radius + 6.0, 0.0, TAU, 40, boss_color, 3.0)
		draw_arc(Vector2.ZERO, ring_radius + 12.0, 0.0, TAU, 40, Color(boss_color.r, boss_color.g, boss_color.b, 0.34), 1.5)
	elif support_heal_interval > 0.0:
		draw_arc(Vector2.ZERO, ring_radius + 5.0, 0.0, TAU, 36, Color(0.34, 0.90, 0.62, 0.82), 2.0)
	elif visual_role == "crypt_guard":
		draw_arc(Vector2.ZERO, ring_radius + 5.0, 0.0, TAU, 36, Color(0.92, 0.58, 0.20, 0.82), 2.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	if placement_enabled and team == 0 and alive:
		var placement_color := Color(0.58, 0.85, 1.0, 1.0) if dragging else Color(0.42, 0.72, 0.95, 0.72)
		draw_arc(Vector2(0.0, 21.0), 30.0, 0.0, TAU, 36, placement_color, 2.0)

	if alive and target != null and is_instance_valid(target) and target.alive:
		var local_target := to_local(target.global_position)
		var direction := local_target.normalized()
		draw_line(direction * 22.0, direction * 29.0, target_color, 2.0)

func _draw_miniature(figure_color: Color, outline_color: Color) -> void:
	match visual_role:
		"knight":
			_draw_knight(figure_color, outline_color)
		"ranger":
			_draw_ranger(figure_color, outline_color)
		"mage":
			_draw_mage(figure_color, outline_color)
		"skeleton":
			_draw_skeleton(figure_color, outline_color, false)
		"bone_archer":
			_draw_skeleton(figure_color, outline_color, true)
		_:
			draw_circle(Vector2.ZERO, body_radius * 0.62, figure_color)
			draw_arc(Vector2.ZERO, body_radius * 0.62, 0.0, TAU, 24, outline_color, 2.0)

func _draw_knight(figure_color: Color, outline_color: Color) -> void:
	draw_circle(Vector2(0.0, -9.0), 7.0, figure_color)
	draw_rect(Rect2(-8.0, -3.0, 16.0, 19.0), figure_color)
	draw_arc(Vector2(0.0, -9.0), 7.0, 0.0, TAU, 18, outline_color, 2.0)

	var shield := PackedVector2Array([
		Vector2(-16.0, -3.0),
		Vector2(-7.0, -6.0),
		Vector2(-7.0, 10.0),
		Vector2(-12.0, 16.0),
		Vector2(-17.0, 9.0)
	])
	draw_colored_polygon(shield, Color(0.26, 0.42, 0.62, 1.0))
	draw_polyline(PackedVector2Array([shield[0], shield[1], shield[2], shield[3], shield[4], shield[0]]), outline_color, 1.5)

	draw_line(Vector2(10.0, -8.0), Vector2(17.0, 13.0), outline_color, 2.0)
	draw_line(Vector2(7.0, -2.0), Vector2(14.0, -4.0), outline_color, 2.0)

func _draw_ranger(figure_color: Color, outline_color: Color) -> void:
	var hood := PackedVector2Array([
		Vector2(0.0, -17.0),
		Vector2(-11.0, -3.0),
		Vector2(11.0, -3.0)
	])
	draw_colored_polygon(hood, figure_color)
	draw_polyline(PackedVector2Array([hood[0], hood[1], hood[2], hood[0]]), outline_color, 1.5)
	draw_circle(Vector2(0.0, -5.0), 5.0, Color(0.09, 0.10, 0.09, 1.0))
	draw_rect(Rect2(-6.0, 1.0, 12.0, 15.0), figure_color)

	draw_arc(Vector2(10.0, 2.0), 12.0, -PI * 0.45, PI * 0.45, 18, outline_color, 2.0)
	draw_line(Vector2(10.0, -9.0), Vector2(10.0, 13.0), outline_color, 1.2)
	draw_line(Vector2(5.0, 2.0), Vector2(19.0, 2.0), outline_color, 1.4)

func _draw_mage(figure_color: Color, outline_color: Color) -> void:
	var robe := PackedVector2Array([
		Vector2(0.0, -13.0),
		Vector2(-12.0, 15.0),
		Vector2(12.0, 15.0)
	])
	draw_colored_polygon(robe, figure_color)
	draw_polyline(PackedVector2Array([robe[0], robe[1], robe[2], robe[0]]), outline_color, 1.5)
	draw_circle(Vector2(0.0, -12.0), 6.0, Color(0.16, 0.08, 0.22, 1.0))

	draw_line(Vector2(13.0, -15.0), Vector2(13.0, 16.0), outline_color, 2.0)
	draw_circle(Vector2(13.0, -18.0), 4.0, Color(0.75, 0.42, 1.0, 1.0))
	draw_arc(Vector2(13.0, -18.0), 7.0, 0.0, TAU, 18, Color(0.55, 0.28, 0.9, 0.45), 2.0)

func _draw_skeleton(figure_color: Color, outline_color: Color, with_bow: bool) -> void:
	var bone := figure_color
	draw_circle(Vector2(0.0, -10.0), 7.0, bone)
	draw_circle(Vector2(-2.5, -11.0), 1.5, Color(0.08, 0.06, 0.05, 1.0))
	draw_circle(Vector2(2.5, -11.0), 1.5, Color(0.08, 0.06, 0.05, 1.0))
	draw_line(Vector2(0.0, -3.0), Vector2(0.0, 13.0), bone, 3.0)
	draw_line(Vector2(-8.0, 1.0), Vector2(8.0, 1.0), bone, 2.0)
	draw_line(Vector2(-7.0, 5.0), Vector2(7.0, 5.0), bone, 2.0)
	draw_line(Vector2(-6.0, 9.0), Vector2(6.0, 9.0), bone, 2.0)
	draw_line(Vector2(0.0, 13.0), Vector2(-7.0, 18.0), bone, 2.0)
	draw_line(Vector2(0.0, 13.0), Vector2(7.0, 18.0), bone, 2.0)
	draw_arc(Vector2(0.0, -10.0), 7.0, 0.0, TAU, 18, outline_color, 1.4)

	if with_bow:
		draw_arc(Vector2(11.0, 3.0), 12.0, -PI * 0.55, PI * 0.55, 18, outline_color, 2.0)
		draw_line(Vector2(11.0, -7.0), Vector2(11.0, 13.0), outline_color, 1.2)
		draw_line(Vector2(5.0, 3.0), Vector2(20.0, 3.0), outline_color, 1.4)
