extends Control

# D233: limited animation-production method QA only.
# Four variants of ONE D232 illustrated pose, with cloak tip/lantern movement.
# NOT a full 25-cel production animation; other 26 atlas cells are empty.
const OLD_IDLE: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d233_idle4_cutout_proof.webp.b64"
const NEW_IDLE: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d234_handheld_idle4.webp.b64"
const CELL: int = 96
const EXPECTED_FRAMES: int = 4

@onready var backdrop: TextureRect = $BattleBackdrop

var demo_big: AnimatedSprite2D
var demo_actual: AnimatedSprite2D
var old_big: AnimatedSprite2D
var old_actual: AnimatedSprite2D
var pause_button: Button
var face_left_button: Button
var face_right_button: Button
var face_left: bool = true
var paused: bool = false
var status: Label


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("D209 утверждённый лес не загрузился")
		return
	var old_frames: SpriteFrames = _load_idle_four(OLD_IDLE)
	var new_frames: SpriteFrames = _load_idle_four(NEW_IDLE)
	if old_frames == null or new_frames == null:
		return
	_panel(Vector2(55, 149), Vector2(565, 435))
	_panel(Vector2(663, 149), Vector2(565, 435))
	_label("D234 / СТРАЖ ДОРОГИ · ПРАВИЛЬНЫЙ ХВАТ ФОНАРЯ / QA", Vector2(160, 18), Vector2(1040, 50), 26)
	_label("D233 · ФОНАРЬ ВОЗЛЕ КОЛЕНА", Vector2(93, 164), Vector2(490, 38), 21)
	_label("D234 · ФОНАРЬ В СВОБОДНОЙ РУКЕ", Vector2(680, 164), Vector2(525, 38), 21)
	_label("Увеличение ×3", Vector2(211, 207), Vector2(290, 26), 17)
	_label("Увеличение ×3", Vector2(825, 207), Vector2(290, 26), 17)
	old_big = _animated(old_frames, Vector2(294, 368), 3.0)
	demo_big = _animated(new_frames, Vector2(918, 368), 3.0)
	old_actual = _animated(old_frames, Vector2(511, 514), 1.0)
	demo_actual = _animated(new_frames, Vector2(1132, 514), 1.0)
	_label("Игровой масштаб ×1", Vector2(395, 536), Vector2(204, 28), 15)
	_label("Игровой масштаб ×1", Vector2(1004, 536), Vector2(204, 28), 15)
	pause_button = _button("ПАУЗА", Vector2(140, 102), Vector2(198, 38))
	pause_button.pressed.connect(_toggle_pause)
	face_left_button = _button("← ВЛЕВО", Vector2(431, 102), Vector2(198, 38))
	face_left_button.pressed.connect(_set_facing.bind(true))
	face_right_button = _button("ВПРАВО →", Vector2(694, 102), Vector2(198, 38))
	face_right_button.pressed.connect(_set_facing.bind(false))
	status = _label("", Vector2(108, 604), Vector2(1070, 89), 17)
	_set_facing(true)
	for sprite in [old_big, old_actual, demo_big, demo_actual]:
		sprite.play("idle")
	_update_status()
	print("D234: 4x left OLD knee lamp vs right NEW wrist-held lantern; each 26 empty; no battle changes.")


func _load_idle_four(path: String) -> SpriteFrames:
	var image: Image = _read_rgba(path, Vector2i(CELL * 6, CELL * 5))
	if image == null:
		return null
	var signatures: Dictionary = {}
	for row in range(5):
		for col in range(6):
			var tile: Image = image.get_region(Rect2i(col * CELL, row * CELL, CELL, CELL))
			var pixels: int = 0
			var touches_border: bool = false
			for y in range(CELL):
				for x in range(CELL):
					if tile.get_pixel(x, y).a <= 0.20:
						continue
					pixels += 1
					if x < 2 or x > 93 or y < 2 or y > 93:
						touches_border = true
			if row == 0 and col < EXPECTED_FRAMES:
				if pixels < 100 or touches_border:
					_fail("Потеряна поза или обрезана прозрачная рамка: " + str(col))
					return null
				var fingerprint: int = hash(tile.get_data())
				if signatures.has(fingerprint):
					_fail("Повтор поз ожидания: " + str(col))
					return null
				signatures[fingerprint] = true
			elif pixels != 0:
				_fail("D234 ожидает ТОЛЬКО 4 кадра на каждый вариант: " + str(row) + ":" + str(col))
				return null
	if signatures.size() != EXPECTED_FRAMES:
		_fail("Не хватает четырёх поз ожидания")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	var sprite_frames := SpriteFrames.new()
	if sprite_frames.has_animation("default"):
		sprite_frames.remove_animation("default")
	sprite_frames.add_animation("idle")
	sprite_frames.set_animation_speed("idle", 2.8)
	sprite_frames.set_animation_loop("idle", true)
	for i in range(EXPECTED_FRAMES):
		var tile := AtlasTexture.new()
		tile.atlas = texture
		tile.region = Rect2(i * CELL, 0, CELL, CELL)
		sprite_frames.add_frame("idle", tile)
	return sprite_frames


func _read_rgba(path: String, expected: Vector2i) -> Image:
	if not FileAccess.file_exists(path):
		_fail("Атлас отсутствует: " + path)
		return null
	var bytes: PackedByteArray = Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var image := Image.new()
	if bytes.is_empty() or image.load_webp_from_buffer(bytes) != OK:
		_fail("Ошибка декодирования WebP: " + path)
		return null
	if image.get_size() != expected:
		_fail("Неверный размер: " + path)
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image


func _animated(frames: SpriteFrames, where: Vector2, mag: float) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.position = where.round()
	sprite.scale = Vector2.ONE * mag
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.z_index = 20
	add_child(sprite)
	return sprite


func _set_facing(to_left: bool) -> void:
	face_left = to_left
	# Both source drawings face left; reverse both together for right-facing.
	for sprite in [old_big, old_actual, demo_big, demo_actual]:
		if sprite != null:
			sprite.flip_h = not face_left
	_update_status()


func _toggle_pause() -> void:
	paused = not paused
	for sprite in [old_big, old_actual, demo_big, demo_actual]:
		if paused:
			sprite.pause()
		else:
			sprite.play("idle")
	pause_button.text = "ПРОДОЛЖИТЬ" if paused else "ПАУЗА"
	_update_status()


func _update_status() -> void:
	if status == null:
		return
	var facing: String = "ВЛЕВО" if face_left else "ВПРАВО"
	var play_text: String = "ПАУЗА" if paused else "ВОСПРОИЗВОДИТСЯ"
	status.text = "D234: ОБА 4/4 · %s · %s. СПРАВА ФОНАРЬ ПРИВЯЗАН К КИСТИ И ВИДНА РУЧКА.\nСРАВНИ ХВАТ И КОНТУР ПЛАЩА ПРИ ×1. ТОЛЬКО IDLE, НЕ 25 КАДРОВ И НЕ РЕАЛЬНЫЙ БОЙ." % [facing, play_text]


func _button(value: String, pos: Vector2, dim: Vector2) -> Button:
	var btn := Button.new()
	btn.text = value
	btn.position = pos
	btn.size = dim
	add_child(btn)
	return btn


func _panel(pos: Vector2, dim: Vector2) -> void:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = dim
	rect.color = Color(0.024, 0.026, 0.037, 0.86)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(rect)


func _label(value: String, pos: Vector2, dim: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = dim
	label.text = value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.95, 0.87, 0.75))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 40
	add_child(label)
	return label


func _fail(problem: String) -> void:
	var label: Label = _label("D234 / QA FAIL: " + problem, Vector2(115, 270), Vector2(1070, 110), 23)
	label.add_theme_color_override("font_color", Color(1.0, 0.32, 0.30))
	push_error(problem)
