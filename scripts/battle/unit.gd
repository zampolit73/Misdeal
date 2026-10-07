class_name BattleUnit
extends Node2D

const UNIT_TILE_SIZE: float = 96.0
const TACTICAL_ORDER_ASSAULT := "assault"
const TACTICAL_ORDER_HUNT := "hunt"
const TACTICAL_ORDER_FORMATION := "formation"
const TACTICAL_ORDER_SACRIFICE := "sacrifice"
const TACTICAL_ORDER_DEFIANCE := "defiance"
const ASSAULT_MOVE_MULTIPLIER := 1.15
const ART_BASE_POSITION := Vector2(0.0, -12.0)

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
signal health_critical(unit: BattleUnit)
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
var tactical_order := TACTICAL_ORDER_ASSAULT
var target_refresh_cooldown := 0.0
var damage_taken_multiplier := 1.0

var placement_enabled := false
var placement_bounds := Rect2()
var placement_regions: Array[Rect2] = []
var combat_bounds := Rect2()
var dragging := false
var drag_offset := Vector2.ZERO
var drag_origin := Vector2.ZERO

var hit_flash_time := 0.0
var hit_pulse_tween: Tween
var attack_tween: Tween
var death_tween: Tween
var unit_sheet_texture: Texture2D
var base_sprite_scale := Vector2.ONE
var idle_phase := 0.0
var attack_animating := false
var hit_kick_offset := Vector2.ZERO
var hit_stop_time := 0.0
var critical_announced := false
var arena_id := "crypt"
var arena_tint := Color.WHITE

@onready var rim_sprite: Sprite2D = $RimSprite
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

func set_arena_presentation(value: String) -> void:
	arena_id = value
	match arena_id:
		"graveyard":
			arena_tint = Color(0.82, 0.90, 1.0, 1.0)
		"ossuary":
			arena_tint = Color(1.0, 0.91, 0.76, 1.0)
		"warden":
			arena_tint = Color(1.0, 0.80, 0.72, 1.0)
		_:
			arena_tint = Color(1.0, 0.94, 0.86, 1.0)

	if is_node_ready():
		_apply_arena_presentation()

func set_tactical_order(order_id: String) -> void:
	match order_id:
		TACTICAL_ORDER_ASSAULT, TACTICAL_ORDER_HUNT, TACTICAL_ORDER_FORMATION, TACTICAL_ORDER_SACRIFICE, TACTICAL_ORDER_DEFIANCE:
			tactical_order = order_id
		_:
			tactical_order = TACTICAL_ORDER_ASSAULT

	target = null
	target_refresh_cooldown = 0.0

func _ready() -> void:
	hp = max_hp
	add_to_group("combat_units")
	name_label.text = display_name
	name_label.visible = team == 0 or is_boss or show_enemy_name
	art_sprite.texture = _get_art_texture()
	rim_sprite.texture = art_sprite.texture
	var sprite_scale: float = 1.10 if is_boss else 1.08
	art_sprite.scale = Vector2.ONE * (sprite_scale * visual_scale)
	base_sprite_scale = art_sprite.scale
	idle_phase = fmod(float(get_instance_id()) * 0.731, TAU)
	_apply_role_presentation()
	_apply_arena_presentation()
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

func _apply_arena_presentation() -> void:
	base_art_modulate = Color(
		base_art_modulate.r * arena_tint.r,
		base_art_modulate.g * arena_tint.g,
		base_art_modulate.b * arena_tint.b,
		1.0
	)
	art_sprite.modulate = base_art_modulate

	var rim_color := Color(0.34, 0.66, 1.0, 0.24) if team == 0 else Color(1.0, 0.34, 0.20, 0.22)
	if is_boss:
		rim_color = Color(1.0, 0.42, 0.16, 0.34)
	rim_sprite.modulate = Color(
		rim_color.r * arena_tint.r,
		rim_color.g * arena_tint.g,
		rim_color.b * arena_tint.b,
		rim_color.a
	)
	_sync_rim_visual()

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
	var regions: Array[Rect2] = [bounds]
	enable_placement_regions(regions)

func enable_placement_regions(regions: Array[Rect2]) -> void:
	if team != 0:
		return

	placement_regions = regions.duplicate()
	if placement_regions.is_empty():
		placement_regions.append(Rect2(Vector2.ZERO, Vector2(1.0, 1.0)))
	placement_bounds = placement_regions[0]
	placement_enabled = true
	queue_redraw()

func _clamp_to_placement_regions(desired_position: Vector2) -> Vector2:
	if placement_regions.is_empty():
		return desired_position

	var best_position: Vector2 = desired_position
	var best_distance: float = INF
	for region in placement_regions:
		var min_position: Vector2 = region.position + Vector2(body_radius, body_radius)
		var max_position: Vector2 = region.position + region.size - Vector2(body_radius, body_radius)
		var candidate := Vector2(
			clampf(desired_position.x, min_position.x, max_position.x),
			clampf(desired_position.y, min_position.y, max_position.y)
		)
		var distance: float = desired_position.distance_squared_to(candidate)
		if distance < best_distance:
			best_distance = distance
			best_position = candidate
	return best_position

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
	target_refresh_cooldown = 0.0
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
		position = _clamp_to_placement_regions(desired_position)

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
	_update_idle_visual(delta)
	_sync_rim_visual()

	if hit_flash_time > 0.0:
		hit_flash_time = maxf(0.0, hit_flash_time - delta)
		queue_redraw()

	if hit_stop_time > 0.0:
		hit_stop_time = maxf(0.0, hit_stop_time - delta)
		return

	if not combat_started or not alive:
		return

	_process_support(delta)

	target_refresh_cooldown = maxf(0.0, target_refresh_cooldown - delta)
	var should_refresh_target := not _is_valid_target(target)
	if team == 0 and tactical_order != TACTICAL_ORDER_ASSAULT and target_refresh_cooldown <= 0.0:
		should_refresh_target = true

	if should_refresh_target:
		target = _find_preferred_enemy()
		target_refresh_cooldown = 0.35

	var movement_speed := _get_current_move_speed()
	var velocity := _get_separation_velocity()

	if target != null:
		var distance := global_position.distance_to(target.global_position)
		var desired_max_range := attack_range + target.body_radius
		var desired_min_range := minimum_range + target.body_radius

		if minimum_range > 0.0 and distance < desired_min_range:
			var retreat_direction := target.global_position.direction_to(global_position)

			if _can_move_in_direction(retreat_direction, delta):
				velocity += retreat_direction * movement_speed
			else:
				attack_cooldown -= delta
				if attack_cooldown <= 0.0:
					_attack_target()
		elif distance > desired_max_range:
			var direction := global_position.direction_to(target.global_position)
			velocity += direction * movement_speed
		else:
			attack_cooldown -= delta
			if attack_cooldown <= 0.0:
				_attack_target()

	position += velocity.limit_length(movement_speed * 1.35) * delta
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
		_play_combat_audio("heal")

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

	var step := direction.normalized() * _get_current_move_speed() * delta
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

func _find_preferred_enemy() -> BattleUnit:
	if team != 0:
		return _find_nearest_enemy()

	match tactical_order:
		TACTICAL_ORDER_HUNT:
			return _find_hunt_enemy()
		TACTICAL_ORDER_FORMATION:
			return _find_formation_enemy()
		_:
			return _find_nearest_enemy()

func _find_nearest_enemy() -> BattleUnit:
	var nearest: BattleUnit = null
	var nearest_distance := INF

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.team == team:
			continue

		var distance: float = global_position.distance_squared_to(unit.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = unit

	return nearest

func _find_hunt_enemy() -> BattleUnit:
	var best_target: BattleUnit = null
	var best_rank: int = 999
	var best_distance := INF

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.team == team:
			continue

		var rank: int = 2
		if unit.support_heal_interval > 0.0:
			rank = 0
		elif unit.minimum_range > 0.0:
			rank = 1

		var distance: float = global_position.distance_squared_to(unit.global_position)
		if rank < best_rank or (rank == best_rank and distance < best_distance):
			best_rank = rank
			best_distance = distance
			best_target = unit

	return best_target

func _find_formation_enemy() -> BattleUnit:
	var protected_ally := _find_most_vulnerable_friendly()
	if protected_ally == null:
		return _find_nearest_enemy()

	var nearest_threat: BattleUnit = null
	var nearest_distance := INF

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.team == team:
			continue

		var distance: float = protected_ally.global_position.distance_squared_to(unit.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_threat = unit

	return nearest_threat

func _find_most_vulnerable_friendly() -> BattleUnit:
	var weakest: BattleUnit = null
	var weakest_ratio := INF
	var weakest_max_hp := INF

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.team != team:
			continue

		var hp_ratio: float = unit.hp / maxf(1.0, unit.max_hp)
		if hp_ratio < weakest_ratio - 0.001:
			weakest = unit
			weakest_ratio = hp_ratio
			weakest_max_hp = unit.max_hp
		elif absf(hp_ratio - weakest_ratio) <= 0.001 and unit.max_hp < weakest_max_hp:
			weakest = unit
			weakest_max_hp = unit.max_hp

	return weakest

func apply_hit_stop(duration: float) -> void:
	if not combat_started or not alive:
		return
	hit_stop_time = maxf(hit_stop_time, duration)

func _get_current_move_speed() -> float:
	if team == 0 and tactical_order == TACTICAL_ORDER_ASSAULT:
		return move_speed * ASSAULT_MOVE_MULTIPLIER
	return move_speed

func _update_idle_visual(delta: float) -> void:
	if not alive or attack_animating:
		return

	var idle_speed := 2.7 if combat_started else 1.65
	var bob_amount := 1.35 if combat_started else 0.8
	idle_phase = fmod(idle_phase + delta * idle_speed, TAU)

	var bob := sin(idle_phase) * bob_amount
	var breathe := 1.0 + sin(idle_phase * 0.72) * 0.012
	art_sprite.position = ART_BASE_POSITION + Vector2(0.0, bob) + hit_kick_offset
	art_sprite.scale = Vector2(
		base_sprite_scale.x * (2.0 - breathe),
		base_sprite_scale.y * breathe
	)

func _sync_rim_visual() -> void:
	if rim_sprite == null or art_sprite == null:
		return

	rim_sprite.position = art_sprite.position + Vector2(0.0, 1.0)
	rim_sprite.rotation = art_sprite.rotation
	rim_sprite.scale = art_sprite.scale * 1.045
	rim_sprite.visible = art_sprite.visible

func _attack_target() -> void:
	if not _is_valid_target(target):
		target = null
		return

	attack_cooldown = attack_interval
	var primary_target := target
	var impact_position := primary_target.global_position
	_play_attack_feedback(primary_target)
	_play_combat_audio("attack")
	_apply_combat_hit_stop()
	primary_target.take_damage(damage, visual_role, global_position)

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
			unit.take_damage(splash_damage, visual_role, global_position)

func _apply_combat_hit_stop() -> void:
	var duration := 0.045
	match _get_attack_style():
		"ranged":
			duration = 0.026
		"magic":
			duration = 0.034
	get_tree().call_group("combat_units", "apply_hit_stop", duration)

func _play_attack_feedback(primary_target: BattleUnit) -> void:
	if attack_tween != null and attack_tween.is_valid():
		attack_tween.kill()

	attack_animating = true
	var direction := global_position.direction_to(primary_target.global_position)
	var style := _get_attack_style()

	match style:
		"ranged":
			art_sprite.position = ART_BASE_POSITION - direction * 5.0
			art_sprite.rotation = -direction.x * 0.055
			art_sprite.scale = Vector2(base_sprite_scale.x * 0.96, base_sprite_scale.y * 1.04)
			_spawn_attack_trace(primary_target, Color(1.0, 0.76, 0.38, 0.92), 1.6)
		"magic":
			art_sprite.position = ART_BASE_POSITION - direction * 2.0
			art_sprite.rotation = direction.x * 0.035
			art_sprite.scale = base_sprite_scale * 1.12
			art_sprite.modulate = Color(0.90, 0.72, 1.0, 1.0) if visual_role == "mage" else Color(0.60, 1.0, 0.72, 1.0)
			var trace_color := Color(0.72, 0.44, 1.0, 0.95) if visual_role == "mage" else Color(0.50, 1.0, 0.70, 0.92)
			_spawn_attack_trace(primary_target, trace_color, 3.0)
		_:
			art_sprite.position = ART_BASE_POSITION + direction * 9.0
			art_sprite.rotation = direction.x * 0.08
			art_sprite.scale = Vector2(base_sprite_scale.x * 1.06, base_sprite_scale.y * 0.96)

	attack_tween = create_tween()
	attack_tween.set_parallel(true)
	attack_tween.tween_property(art_sprite, "position", ART_BASE_POSITION, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(art_sprite, "rotation", 0.0, 0.14)
	attack_tween.tween_property(art_sprite, "scale", base_sprite_scale, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(art_sprite, "modulate", base_art_modulate, 0.14)
	attack_tween.chain().tween_callback(_finish_attack_feedback)

func _finish_attack_feedback() -> void:
	attack_animating = false

func _get_attack_style() -> String:
	match visual_role:
		"ranger", "bone_archer":
			return "ranged"
		"mage", "grave_bellkeeper":
			return "magic"
		_:
			return "melee"

func _spawn_attack_trace(primary_target: BattleUnit, color: Color, width: float) -> void:
	if get_parent() == null or not is_instance_valid(primary_target):
		return

	var trace := Line2D.new()
	trace.width = width
	trace.default_color = color
	trace.points = PackedVector2Array([
		position + Vector2(0.0, -18.0),
		primary_target.position + Vector2(0.0, -18.0),
	])
	trace.z_index = 1900
	get_parent().add_child(trace)

	var trace_tween := trace.create_tween()
	trace_tween.tween_property(trace, "modulate:a", 0.0, 0.14)
	trace_tween.tween_callback(trace.queue_free)

func take_attrition_damage(amount: float) -> void:
	if not alive or amount <= 0.0:
		return

	hp = maxf(0.0, hp - amount)
	health_bar.value = hp

	if team == 0 and not critical_announced and hp > 0.0 and hp / maxf(1.0, max_hp) <= 0.25:
		critical_announced = true
		health_critical.emit(self)

	queue_redraw()

	if hp <= 0.0:
		_die()


func take_damage(amount: float, source_role: String = "", source_position: Vector2 = Vector2.ZERO) -> void:
	if not alive:
		return

	var applied_amount := maxf(0.0, amount * damage_taken_multiplier)
	_show_damage_number(applied_amount)
	_play_hit_feedback(source_position)
	_spawn_impact_sparks(source_role, source_position)
	_play_combat_audio("hit")

	hp = maxf(0.0, hp - applied_amount)
	health_bar.value = hp

	if team == 0 and not critical_announced and hp > 0.0 and hp / maxf(1.0, max_hp) <= 0.25:
		critical_announced = true
		health_critical.emit(self)

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
	_play_combat_audio("boss")
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

func _play_hit_feedback(source_position: Vector2 = Vector2.ZERO) -> void:
	hit_flash_time = 0.12

	if hit_pulse_tween != null and hit_pulse_tween.is_valid():
		hit_pulse_tween.kill()

	var kick_direction := Vector2(-1.0 if int(get_instance_id()) % 2 == 0 else 1.0, -0.18)
	if source_position != Vector2.ZERO:
		kick_direction = source_position.direction_to(global_position)
	scale = Vector2(1.12, 1.12)
	hit_kick_offset = kick_direction.normalized() * 5.0 + Vector2(0.0, -1.0)
	art_sprite.modulate = Color(1.0, 0.62, 0.52, 1.0)
	hit_pulse_tween = create_tween()
	hit_pulse_tween.set_parallel(true)
	hit_pulse_tween.tween_property(self, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	hit_pulse_tween.tween_property(art_sprite, "modulate", base_art_modulate, 0.14)
	hit_pulse_tween.tween_property(self, "hit_kick_offset", Vector2.ZERO, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _spawn_impact_sparks(source_role: String, source_position: Vector2) -> void:
	if get_parent() == null:
		return

	var impact_position := position + Vector2(0.0, -18.0)
	var direction := Vector2.RIGHT
	if source_position != Vector2.ZERO:
		direction = source_position.direction_to(global_position)
	if direction.length_squared() < 0.01:
		direction = Vector2.RIGHT

	var spark_color := Color(1.0, 0.70, 0.34, 0.92)
	if source_role == "mage" or source_role == "grave_bellkeeper":
		spark_color = Color(0.74, 0.48, 1.0, 0.96)
	elif source_role == "ranger" or source_role == "bone_archer":
		spark_color = Color(1.0, 0.86, 0.52, 0.94)

	for index in range(3):
		var spark := Line2D.new()
		spark.width = 1.8
		spark.default_color = spark_color
		var angle := -0.48 + float(index) * 0.48
		var ray := direction.rotated(angle) * (10.0 + float(index) * 3.0)
		spark.points = PackedVector2Array([impact_position, impact_position + ray])
		spark.z_index = 2050
		get_parent().add_child(spark)

		var tween := spark.create_tween()
		tween.set_parallel(true)
		tween.tween_property(spark, "position", direction * (4.0 + float(index) * 2.0), 0.16)
		tween.tween_property(spark, "modulate:a", 0.0, 0.16)
		tween.chain().tween_callback(spark.queue_free)

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
	health_bar.visible = false
	name_label.visible = false
	_play_combat_audio("death")
	if team == 1:
		_spawn_death_fragments()

	if hit_pulse_tween != null and hit_pulse_tween.is_valid():
		hit_pulse_tween.kill()
	if attack_tween != null and attack_tween.is_valid():
		attack_tween.kill()
	attack_animating = false
	hit_kick_offset = Vector2.ZERO

	var death_tilt := -0.22 if int(get_instance_id()) % 2 == 0 else 0.22
	var death_duration := 0.26 if team == 1 else 0.42
	var death_scale := Vector2(0.58, 0.58) if team == 1 else Vector2(0.76, 0.76)
	death_tween = create_tween()
	death_tween.set_parallel(true)
	death_tween.tween_property(self, "scale", death_scale, death_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	death_tween.tween_property(self, "modulate:a", 0.10 if team == 1 else 0.16, death_duration)
	death_tween.tween_property(art_sprite, "rotation", death_tilt, death_duration)
	death_tween.tween_property(art_sprite, "position", ART_BASE_POSITION + Vector2(0.0, 12.0), death_duration)

	queue_redraw()
	died.emit(self)

func _spawn_death_fragments() -> void:
	if get_parent() == null:
		return

	var fragment_count := 8 if is_boss else 5
	for index in range(fragment_count):
		var fragment := Line2D.new()
		fragment.width = 2.6 if is_boss else 2.0
		fragment.default_color = Color(0.82, 0.72, 0.56, 0.90)
		fragment.points = PackedVector2Array([Vector2(-4.0, 0.0), Vector2(4.0, 0.0)])
		fragment.position = position + Vector2(0.0, -10.0)
		fragment.rotation = float(index) * 0.73
		fragment.z_index = 2040
		get_parent().add_child(fragment)

		var direction := Vector2.from_angle(-2.55 + float(index) * 0.72)
		var distance := 24.0 + float(index % 3) * 8.0
		var tween := fragment.create_tween()
		tween.set_parallel(true)
		tween.tween_property(fragment, "position", fragment.position + direction * distance + Vector2(0.0, 12.0), 0.34)
		tween.tween_property(fragment, "rotation", fragment.rotation + 1.6, 0.34)
		tween.tween_property(fragment, "modulate:a", 0.0, 0.34)
		tween.chain().tween_callback(fragment.queue_free)

func _play_combat_audio(event_name: String) -> void:
	if get_tree() == null:
		return
	get_tree().call_group("combat_audio", "play_event", event_name, visual_role)

func _draw() -> void:
	var team_color := Color(0.20, 0.58, 1.0, 0.95) if team == 0 else Color(0.95, 0.20, 0.16, 0.95)
	var target_color := Color(0.78, 0.90, 1.0, 0.7) if team == 0 else Color(1.0, 0.58, 0.44, 0.7)
	var ring_radius := maxf(22.0, body_radius * 1.05)

	draw_set_transform(Vector2(0.0, 22.0), 0.0, Vector2(1.0, 0.30))
	draw_circle(Vector2.ZERO, ring_radius + 7.0, Color(0.0, 0.0, 0.0, 0.16))
	draw_circle(Vector2.ZERO, ring_radius + 1.0, Color(0.0, 0.0, 0.0, 0.38))
	draw_arc(Vector2.ZERO, ring_radius, 0.0, TAU, 36, Color(team_color.r, team_color.g, team_color.b, 0.78), 2.2)
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
