extends Control

# D249, QA ONLY. Real 3v5 BattleUnit AI and scoped D206 lanternlight on D209.
# Staged originals: D244 Road Sentinel + D224 Lantern Bearer, via shared loader.
# Temporary original QA art: D218 Guide, D217 Acolyte, D219 Archer, INSTANCE ONLY.
# Do NOT release black_lantern_road into RunState or change production Battle.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/black_lantern_road.tres")
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const LANTERN_LIGHT := preload("res://scripts/battle/black_lantern_light.gd")
const HERO_PATHS: Array[String] = [
	"res://resources/units/knight.tres",
	"res://resources/units/ranger.tres",
	"res://resources/units/mage.tres"
]
const HERO_SOURCES: Array[Vector2] = [
	Vector2(185, 195), Vector2(335, 280), Vector2(490, 370)
]
const ENEMY_ROLES: Array[String] = [
	"extinguished_guide", "lantern_bearer", "road_sentinel",
	"oil_acolyte", "lantern_archer"
]
const ORIGINAL_QA_PATHS := {
	"extinguished_guide": "res://assets/pixel/units/black_lantern_road_qa/extinguished_guide_d218_candidate.webp.b64",
	"oil_acolyte": "res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg",
	"lantern_archer": "res://assets/pixel/units/black_lantern_road_qa/lantern_archer_d219_candidate.webp.b64"
}
const ANIMATIONS: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]
const FPS: Array[float] = [2.7, 7.0, 16.0, 12.0, 10.0]
const BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))

@onready var backdrop: TextureRect = $BattleBackdrop
@onready var units_layer: Node2D = $UnitsLayer

var actors: Array[BattleUnit] = []
var scoped_light: BlackLanternLightController
var original_qa_frames: Dictionary = {}
var formation: int = 0
var light_enabled: bool = true
var battle_active: bool = false
var elapsed: float = 0.0
var update_counter: float = 0.0
var hero_attacks: int = 0
var enemy_attacks: int = 0
var title_label: Label
var status_label: Label
var details_label: Label
var result_label: Label
var light_button: Button


func _ready() -> void:
	_make_ui()
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		_fail("Нарушена изоляция: карта №38 должна оставаться вне обычной колоды 37/45.")
		return
	if ENCOUNTER.encounter_id != "black_lantern_road" or ENCOUNTER.get_formation_count() != 2:
		_fail("Ресурс Дороги чёрных фонарей или две расстановки недоступны.")
		return
	if ENCOUNTER.enemy_unit_paths.size() != ENEMY_ROLES.size():
		_fail("Карта №38 обязана содержать ровно пять оригинальных врагов.")
		return
	for index in range(ENEMY_ROLES.size()):
		var candidate := load(ENCOUNTER.enemy_unit_paths[index]) as UnitData
		if candidate == null or candidate.visual_role != ENEMY_ROLES[index]:
			_fail("Неверная оригинальная роль врага #%d" % (index + 1))
			return
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("Не удалось загрузить утверждённую лесную арену D209 1280×720.")
		return
	for role in ["road_sentinel", "lantern_bearer"]:
		if ANIMATION_LIBRARY.get_frames(role) == null:
			_fail("Отсутствует принятый анимационный атлас: " + role)
			return
	for role in ORIGINAL_QA_PATHS.keys():
		var frames := _read_temporary_original(str(ORIGINAL_QA_PATHS[role]))
		if frames == null:
			_fail("Техническая анимация недоступна, роль: " + str(role))
			return
		original_qa_frames[role] = frames
	_reset_battle()


func _read_temporary_original(path: String) -> SpriteFrames:
	if not FileAccess.file_exists(path):
		return null
	var text_source := FileAccess.get_file_as_string(path)
	if text_source.is_empty():
		return null
	var image := Image.new()
	var status: Error = ERR_FILE_CORRUPT
	if path.ends_with(".svg"):
		status = image.load_svg_from_buffer(text_source.to_utf8_buffer())
	else:
		var raw := Marshalls.base64_to_raw(text_source.strip_edges())
		if raw.is_empty():
			return null
		status = image.load_webp_from_buffer(raw)
	if status != OK or image.get_size() != Vector2i(576, 480):
		return null
	image.convert(Image.FORMAT_RGBA8)
	if not ANIMATION_LIBRARY._all_authored_deck_frames_visible(image):
		return null
	if not ANIMATION_LIBRARY._all_authored_deck_frames_padded(image):
		return null
	if not ANIMATION_LIBRARY._all_authored_deck_frames_distinct(image):
		return null
	if not ANIMATION_LIBRARY._unused_deck_cells_clear(image):
		return null
	var texture := ImageTexture.create_from_image(image)
	if texture == null:
		return null
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(ANIMATIONS.size()):
		var name: String = ANIMATIONS[row]
		frames.add_animation(name)
		frames.set_animation_speed(name, FPS[row])
		frames.set_animation_loop(name, row < 2)
		for col in range(COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(float(col * 96), float(row * 96), 96.0, 96.0)
			frames.add_frame(name, tile)
	return frames


func _project_on_road(source: Vector2) -> Vector2:
	# Same geometry as battle.gd: original authored Y projected onto walkable floor.
	var depth := clampf((source.y - 130.0) / 275.0, 0.0, 1.0)
	return Vector2(source.x, lerpf(BOUNDS.position.y + 32.0, BOUNDS.end.y - 32.0, depth))


func _reset_battle() -> void:
	_stop_battle()
	for child in units_layer.get_children():
		child.free()
	actors.clear()
	scoped_light = null
	elapsed = 0.0
	update_counter = 0.0
	hero_attacks = 0
	enemy_attacks = 0
	result_label.text = ""
	for i in range(HERO_PATHS.size()):
		var hero := load(HERO_PATHS[i]) as UnitData
		if hero == null or _spawn_actor(hero, 0, HERO_SOURCES[i], "") == null:
			_fail("Не удалось создать героя " + str(i))
			return
	var points: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
	if points.size() != ENEMY_ROLES.size():
		_fail("Расстановка не содержит всех пяти врагов.")
		return
	for i in range(ENEMY_ROLES.size()):
		var data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		if data == null or _spawn_actor(data, 1, points[i], ENCOUNTER.enemy_names[i]) == null:
			_fail("Не удалось создать врага " + str(i))
			return
	scoped_light = LANTERN_LIGHT.new() as BlackLanternLightController
	units_layer.add_child(scoped_light)
	scoped_light.configure(actors)
	if light_enabled:
		scoped_light.start_light()
	for unit in actors:
		unit.start_combat()
	battle_active = true
	_update_status()
	print("D249: 3v5 actual BattleUnit AI and scoped light, isolated QA; #38 still not released.")


func _spawn_actor(data: UnitData, team_id: int, source: Vector2, enemy_name: String) -> BattleUnit:
	var actor := UNIT_SCENE.instantiate() as BattleUnit
	if actor == null:
		return null
	actor.configure(data, team_id, _project_on_road(source), enemy_name)
	actor.set_arena_presentation("black_lantern_road")
	actor.set_combat_bounds(BOUNDS)
	if team_id == 0:
		actor.set_tactical_order("assault")
	units_layer.add_child(actor)
	if team_id == 1:
		var frames: SpriteFrames = null
		if data.visual_role == "road_sentinel" or data.visual_role == "lantern_bearer":
			frames = ANIMATION_LIBRARY.get_frames(data.visual_role)
		else:
			frames = original_qa_frames.get(data.visual_role) as SpriteFrames
		if frames == null:
			actor.free()
			return null
		# Inject temporary sprites into individual QA units only; never into global cache.
		actor.sprite_frames = frames
		actor.frame_state = "idle"
		actor.frame_time = 0.0
		actor.frame_one_shot_time = 0.0
		actor.art_sprite.texture = frames.get_frame_texture("idle", 0)
		actor.art_sprite.position = actor._art_rest_position()
		actor.rim_sprite.texture = actor.art_sprite.texture
	actor.died.connect(_on_actor_died)
	actor.diagnostic_attack.connect(_on_actor_attack)
	actors.append(actor)
	return actor


func _on_actor_attack(attacker: BattleUnit, _target: BattleUnit) -> void:
	if not battle_active:
		return
	if attacker.team == 0:
		hero_attacks += 1
	else:
		enemy_attacks += 1


func _on_actor_died(_unit: BattleUnit) -> void:
	if not battle_active:
		return
	var heroes_alive := 0
	var enemies_alive := 0
	for actor in actors:
		if actor.alive:
			if actor.team == 0:
				heroes_alive += 1
			else:
				enemies_alive += 1
	if enemies_alive == 0 or heroes_alive == 0:
		result_label.text = "ПОБЕДА ГЕРОЕВ — ТОЛЬКО QA" if enemies_alive == 0 else "ГЕРОИ ПАЛИ — ТОЛЬКО QA"
		_stop_battle()
	_update_status()


func _stop_battle() -> void:
	battle_active = false
	if scoped_light != null and is_instance_valid(scoped_light):
		scoped_light.stop_light()
	for unit in actors:
		if is_instance_valid(unit):
			unit.combat_started = false


func _process(delta: float) -> void:
	if not battle_active:
		return
	elapsed += delta
	update_counter += delta
	if update_counter >= 0.15:
		update_counter = 0.0
		_update_status()


func _toggle_formation() -> void:
	formation = 1 - formation
	_reset_battle()


func _toggle_lantern_light() -> void:
	light_enabled = not light_enabled
	light_button.text = "СВЕТ ВКЛ" if light_enabled else "СВЕТ ВЫКЛ"
	if scoped_light != null and is_instance_valid(scoped_light):
		if light_enabled:
			scoped_light.start_light()
		else:
			scoped_light.stop_light()
	_update_status()


func _update_status() -> void:
	var heroes_alive := 0
	var enemies_alive := 0
	for unit in actors:
		if is_instance_valid(unit) and unit.alive:
			if unit.team == 0:
				heroes_alive += 1
			else:
				enemies_alive += 1
	var variant := "МАРШ" if formation == 0 else "ПЕРЕКРЁСТОК"
	status_label.text = "D249 · %s · %.1f сек · герои %d/3, враги %d/5" % [variant, elapsed, heroes_alive, enemies_alive]
	var phase := "отключён"
	var illuminated := 0
	if scoped_light != null and is_instance_valid(scoped_light) and light_enabled:
		phase = scoped_light.get_phase()
		illuminated = scoped_light.buffed_enemy_count
	details_label.text = "Атак героев %d / врагов %d · свет: %s · усилено скелетов %d · временный арт Guide/Acolyte/Archer" % [
		hero_attacks, enemy_attacks, phase, illuminated]


func _make_ui() -> void:
	var top := ColorRect.new()
	top.position = Vector2.ZERO
	top.size = Vector2(1280, 119)
	top.color = Color(0.018, 0.018, 0.028, 0.86)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top)
	var bottom := ColorRect.new()
	bottom.position = Vector2(0, 588)
	bottom.size = Vector2(1280, 132)
	bottom.color = Color(0.018, 0.018, 0.028, 0.92)
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bottom)
	title_label = _label("D249 · ДОРОГА ЧЁРНЫХ ФОНАРЕЙ / БОЙ 3×5 / QA", Vector2(24, 7), Vector2(1234, 36), 23)
	status_label = _label("Загрузка оригинальных врагов...", Vector2(25, 50), Vector2(1234, 30), 18)
	details_label = _label("", Vector2(25, 81), Vector2(1234, 28), 13)
	result_label = _label("", Vector2(24, 591), Vector2(1235, 27), 18)
	var note := _label("Настоящий AI и две расстановки. Страж/Носильщик: принятый арт B; Проводник/Служка/Стрелок: ТОЛЬКО технический QA, не релиз.", Vector2(24, 623), Vector2(1236, 29), 13)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_button("СНОВА", Vector2(24, 668), Vector2(150, 39), _reset_battle)
	_button("СМЕНИТЬ РАССТАНОВКУ", Vector2(187, 668), Vector2(287, 39), _toggle_formation)
	light_button = _button("СВЕТ ВКЛ", Vector2(489, 668), Vector2(190, 39), _toggle_lantern_light)
	_label("#38 QA · обычная колода 37/45 · баланс и награды не проверены", Vector2(691, 671), Vector2(568, 27), 12)


func _button(title: String, at: Vector2, dimensions: Vector2, callback: Callable) -> Button:
	var b := Button.new()
	b.text = title
	b.position = at
	b.size = dimensions
	b.pressed.connect(callback)
	add_child(b)
	return b


func _label(title: String, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var b := Label.new()
	b.text = title
	b.position = at
	b.size = dimensions
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_theme_font_size_override("font_size", font_size)
	b.add_theme_color_override("font_color", Color(0.94, 0.84, 0.73))
	b.add_theme_color_override("font_shadow_color", Color.BLACK)
	b.add_theme_constant_override("shadow_offset_x", 2)
	b.add_theme_constant_override("shadow_offset_y", 2)
	add_child(b)
	return b


func _fail(message: String) -> void:
	_stop_battle()
	result_label.text = "D249 / QA FAIL: " + message
	result_label.add_theme_color_override("font_color", Color(1, 0.38, 0.34))
	push_error("D249: " + message)
