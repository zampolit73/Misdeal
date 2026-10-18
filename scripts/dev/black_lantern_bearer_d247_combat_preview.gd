extends Control

# D247: real BattleUnit 1v1 motion QA for already user-approved D224 Lantern Bearer
# movement, dynamic facing, contact, damage and death on the approved D209 arena.
# Source art D224 is approved; repacked 96px motion is NOT accepted. This
# scene does not alter RunState or the shared combat animation library.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const KNIGHT_DATA: UnitData = preload("res://resources/units/knight.tres")
const BEARER_DATA: UnitData = preload("res://resources/units/lantern_bearer.tres")
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ATLAS_PATH := "res://assets/pixel/units/black_lantern_road_qa/lantern_bearer_d224_approved_repacked_candidate.webp.b64"
const ANIMATIONS: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]
const FPS: Array[float] = [2.7, 7.0, 16.0, 12.0, 10.0]
const FLOOR_BOUNDS := Rect2(Vector2(90.0, 284.0), Vector2(1080.0, 158.0))
const LONGER_QA_FIGHT_HP_MULTIPLIER := 3.0

@onready var battle_backdrop: TextureRect = $BattleBackdrop
@onready var units_layer: Node2D = $UnitsLayer

var d224_frames: SpriteFrames
var bearer: BattleUnit
var knight: BattleUnit
var hero_on_left := true
var elapsed := 0.0
var fight_live := false
var bearer_attacks := 0
var knight_attacks := 0
var bearer_distance := 0.0
var last_bearer_position := Vector2.ZERO
var status_label: Label
var details_label: Label
var finish_label: Label


func _ready() -> void:
	_build_ui()
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		_fail("Карта №38 должна оставаться вне обычной колоды (37/45).")
		return
	battle_backdrop.call("set_arena_id", "black_lantern_road")
	if battle_backdrop.texture == null or battle_backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("Утверждённая D209 арена не загрузилась в размере 1280×720.")
		return
	if KNIGHT_DATA == null or BEARER_DATA == null or BEARER_DATA.visual_role != "lantern_bearer":
		_fail("UnitData рыцаря / Носильщика недоступны.")
		return
	d224_frames = _load_d224_frames()
	if d224_frames == null:
		return
	_reset_fight()


func _load_d224_frames() -> SpriteFrames:
	if not FileAccess.file_exists(ATLAS_PATH):
		_fail("Невозможно найти атлас D224.")
		return null
	var encoded := FileAccess.get_file_as_string(ATLAS_PATH).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	var atlas := Image.new()
	if bytes.is_empty() or atlas.load_webp_from_buffer(bytes) != OK:
		_fail("D224 WebP не декодируется.")
		return null
	if atlas.get_size() != Vector2i(576, 480):
		_fail("D224 имеет неверный размер: требуется 576×480.")
		return null
	atlas.convert(Image.FORMAT_RGBA8)
	if not ANIMATION_LIBRARY._all_authored_deck_frames_visible(atlas) or not ANIMATION_LIBRARY._all_authored_deck_frames_padded(atlas) or not ANIMATION_LIBRARY._all_authored_deck_frames_distinct(atlas) or not ANIMATION_LIBRARY._unused_deck_cells_clear(atlas):
		_fail("D224 не прошёл боевые проверки 25 оригинальных кадров.")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(atlas)
	if texture == null:
		_fail("Невозможно построить текстуру D224.")
		return null
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(ANIMATIONS.size()):
		var animation_name: String = ANIMATIONS[row]
		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, FPS[row])
		frames.set_animation_loop(animation_name, row < 2)
		for column in range(COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(float(column * 96), float(row * 96), 96.0, 96.0)
			frames.add_frame(animation_name, tile)
	return frames


func _reset_fight() -> void:
	if d224_frames == null:
		return
	for child in units_layer.get_children():
		# Includes transient battle hit labels, lines and particles.
		child.free()
	bearer = null
	knight = null
	fight_live = false
	elapsed = 0.0
	bearer_attacks = 0
	knight_attacks = 0
	bearer_distance = 0.0
	finish_label.text = ""
	var hero_start := Vector2(252.0, 355.0) if hero_on_left else Vector2(1010.0, 355.0)
	var bearer_start := Vector2(1040.0, 355.0) if hero_on_left else Vector2(230.0, 355.0)
	knight = _spawn_unit(KNIGHT_DATA, 0, hero_start)
	bearer = _spawn_unit(BEARER_DATA, 1, bearer_start)
	if knight == null or bearer == null:
		_fail("Не удалось создать реальных BattleUnit.")
		return
	# Override only this individual QA instance. DO NOT modify shared static
	# MisdealUnitAnimationLibrary frames cache or any production UnitData.
	bearer.sprite_frames = d224_frames
	bearer.frame_state = "idle"
	bearer.frame_time = 0.0
	bearer.frame_one_shot_time = 0.0
	bearer.art_sprite.texture = d224_frames.get_frame_texture("idle", 0)
	bearer.art_sprite.position = bearer._art_rest_position()
	bearer.rim_sprite.texture = bearer.art_sprite.texture
	bearer._set_facing_left(hero_on_left)
	bearer.diagnostic_attack.connect(_on_bearer_attack)
	knight.diagnostic_attack.connect(_on_knight_attack)
	bearer.died.connect(_on_unit_died)
	knight.died.connect(_on_unit_died)
	last_bearer_position = bearer.position
	knight.start_combat()
	bearer.start_combat()
	fight_live = true
	_update_status()
	print("D247 native 1v1 QA running: REAL BattleUnit AI, D224 Bearer frames injected into QA instance only.")


func _spawn_unit(data: UnitData, side: int, at: Vector2) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	if unit == null:
		return null
	unit.configure(data, side, at)
	unit.set_arena_presentation("black_lantern_road")
	# Longer visibility of walking and multiple real contact animations, QA only.
	# Movement, attack interval, range and damage retain the actual UnitData.
	unit.max_hp *= LONGER_QA_FIGHT_HP_MULTIPLIER
	unit.set_combat_bounds(FLOOR_BOUNDS)
	units_layer.add_child(unit)
	return unit


func _process(delta: float) -> void:
	if not fight_live or not is_instance_valid(bearer) or not is_instance_valid(knight):
		return
	elapsed += delta
	bearer_distance += bearer.position.distance_to(last_bearer_position)
	last_bearer_position = bearer.position
	_update_status()


func _on_bearer_attack(_attacker: BattleUnit, _target: BattleUnit) -> void:
	bearer_attacks += 1


func _on_knight_attack(_attacker: BattleUnit, _target: BattleUnit) -> void:
	knight_attacks += 1


func _on_unit_died(dead_unit: BattleUnit) -> void:
	if not fight_live:
		return
	fight_live = false
	if is_instance_valid(bearer) and bearer != dead_unit:
		bearer.combat_started = false
	if is_instance_valid(knight) and knight != dead_unit:
		knight.combat_started = false
	finish_label.text = ("НОСИЛЬЩИК ПАЛ — наблюдайте всю анимацию смерти." if dead_unit == bearer
		else "РЫЦАРЬ ПАЛ — перезапустите схватку.")
	_update_status()


func _force_bearer_death() -> void:
	if not is_instance_valid(bearer) or not bearer.alive:
		return
	var hit_from := knight.global_position if is_instance_valid(knight) else bearer.global_position + Vector2.LEFT * 80.0
	bearer.take_damage(bearer.hp + 1.0, "knight", hit_from)


func _swap_sides() -> void:
	hero_on_left = not hero_on_left
	_reset_fight()


func _update_status() -> void:
	if status_label == null or not is_instance_valid(bearer) or not is_instance_valid(knight):
		return
	var direction := "← ВЛЕВО" if hero_on_left else "ВПРАВО →"
	status_label.text = "НОСИЛЬЩИК D224 · %s · %.1f с · пройдено %.0f px" % [direction, elapsed, bearer_distance]
	details_label.text = "Носильщик: %.0f/%.0f HP • %s • атак %d    |    Рыцарь: %.0f/%.0f HP • атак %d" % [
		bearer.hp, bearer.max_hp, bearer.frame_state, bearer_attacks,
		knight.hp, knight.max_hp, knight_attacks]


func _build_ui() -> void:
	var top_panel := ColorRect.new()
	top_panel.color = Color(0.02, 0.025, 0.04, 0.85)
	top_panel.position = Vector2(0, 0)
	top_panel.size = Vector2(1280, 118)
	top_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_panel)
	var foot_panel := ColorRect.new()
	foot_panel.color = Color(0.02, 0.025, 0.04, 0.91)
	foot_panel.position = Vector2(0, 590)
	foot_panel.size = Vector2(1280, 130)
	foot_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(foot_panel)
	var title := _label("D247 · НОСИЛЬЩИК ФОНАРЯ / БОЙ 1×1 / АРТ D224 QA", Vector2(26, 10), Vector2(1220, 31), 21)
	title.add_theme_color_override("font_color", Color(0.98, 0.86, 0.71))
	status_label = _label("Запуск...", Vector2(26, 51), Vector2(940, 27), 17)
	details_label = _label("", Vector2(26, 80), Vector2(1200, 26), 14)
	finish_label = _label("", Vector2(26, 595), Vector2(1220, 31), 19)
	var note := _label("Движение, поворот, щит, фонарь и смерть — настоящий BattleUnit. Только HP ×3, скорость/урон не изменены.", Vector2(26, 632), Vector2(1200, 27), 14)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_make_button("СНОВА", Vector2(28, 668), Vector2(194, 40), _reset_fight)
	_make_button("СМЕНИТЬ СТОРОНУ", Vector2(234, 668), Vector2(250, 40), _swap_sides)
	_make_button("ПОКАЗАТЬ СМЕРТЬ", Vector2(496, 668), Vector2(248, 40), _force_bearer_death)
	_label("Колода 37/45 · карта №38 QA · D224 только для этой сцены", Vector2(770, 671), Vector2(490, 35), 12)


func _make_button(value: String, at: Vector2, dimensions: Vector2, callback: Callable) -> void:
	var b := Button.new()
	b.text = value
	b.position = at
	b.size = dimensions
	b.pressed.connect(callback)
	add_child(b)


func _label(value: String, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var node := Label.new()
	node.text = value
	node.position = at
	node.size = dimensions
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_theme_font_size_override("font_size", font_size)
	node.add_theme_color_override("font_color", Color(0.89, 0.81, 0.70))
	node.add_theme_color_override("font_shadow_color", Color.BLACK)
	node.add_theme_constant_override("shadow_offset_x", 2)
	node.add_theme_constant_override("shadow_offset_y", 2)
	add_child(node)
	return node


func _fail(reason: String) -> void:
	fight_live = false
	finish_label.text = "D247 / QA FAIL: " + reason
	finish_label.add_theme_color_override("font_color", Color(1, 0.35, 0.30))
	push_error("D247: " + reason)