extends Control

# D236: illustrated D234 handgrip and original torso on LEFT (4 idle cels),
# new six-phase ARTICULATED LEG pilot on RIGHT in real motion (6 walk cels).
# The 6 cels reuse the D234 upper art: NOT a six-frame repaint of the entire body,
# NOT a finished 25-cel production sprite. Card #38 is still QA-only.
const OLD_IDLE: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d234_handheld_idle4.webp.b64"
const NEW_WALK: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d236_walk6_pilot.webp.b64"
const CELL: int = 96
const IDLE_COUNT: int = 4
const WALK_COUNT: int = 6

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
	var old_frames: SpriteFrames = _load_checked_frames(OLD_IDLE, 0, IDLE_COUNT, "idle")
	var new_frames: SpriteFrames = _load_checked_frames(NEW_WALK, 1, WALK_COUNT, "walk")
	if old_frames == null or new_frames == null:
		return
	_panel(Vector2(55, 149), Vector2(565, 435))
	_panel(Vector2(663, 149), Vector2(565, 435))
	_label("D236 / СТРАЖ ДОРОГИ · ПРОВЕРКА ШЕСТИ ШАГОВ", Vector2(160, 18), Vector2(1040, 50), 26)
	_label("D234 · ПРИНЯТОЕ ОЖИДАНИЕ", Vector2(93, 164), Vector2(490, 38), 21)
	_label("D236 · ХОДЬБА / 6 ФАЗ", Vector2(680, 164), Vector2(525, 38), 21)
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
	for sprite in [old_big, old_actual]:
		sprite.play("idle")
	for sprite in [demo_big, demo_actual]:
		sprite.play("walk")
	_update_status()
	print("D236: left D234 4-idle, right six articulated walk-pilot cels with unchanged illustrated body; not production.")


func _load_checked_frames(path: String, active_row: int, count: int, anim_name: String) -> SpriteFrames:
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
			if row == active_row and col < count:
				if pixels < 100 or touches_border:
					_fail("Потеряна поза или обрезана прозрачная рамка: " + str(col))
					return null
				var fingerprint: int = hash(tile.get_data())
				if signatures.has(fingerprint):
					_fail("Повтор поз ожидания: " + str(col))
					return null
				signatures[fingerprint] = true
			elif pixels != 0:
				_fail("D236 обнаружил заполненные чужие ячейки: " + str(row) + ":" + str(col))
				return null
	if signatures.size() != count:
		_fail("Не хватает различающихся кадров: " + anim_name)
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	var sprite_frames := SpriteFrames.new()
	if sprite_frames.has_animation("default"):
		sprite_frames.remove_animation("default")
	sprite_frames.add_animation(anim_name)
	sprite_frames.set_animation_speed(anim_name, 2.8 if anim_name == "idle" else 6.0)
	sprite_frames.set_animation_loop(anim_name, true)
	for i in range(count):
		var tile := AtlasTexture.new()
		tile.atlas = texture
		tile.region = Rect2(i * CELL, active_row * CELL, CELL, CELL)
		sprite_frames.add_frame(anim_name, tile)
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
			sprite.play("walk" if sprite == demo_big or sprite == demo_actual else "idle")
	pause_button.text = "ПРОДОЛЖИТЬ" if paused else "ПАУЗА"
	_update_status()


func _update_status() -> void:
	if status == null:
		return
	var facing: String = "ВЛЕВО" if face_left else "ВПРАВО"
	var play_text: String = "ПАУЗА" if paused else "ВОСПРОИЗВОДИТСЯ"
	status.text = "D236: СЛЕВА IDLE 4 / СПРАВА WALK 6 · %s · %s. НОГИ МЕНЯЮТ ПОЗЫ, ФОНАРЬ ОСТАЁТСЯ В КИСТИ.\nВАЖНО: ВЕРХ ВЗЯТ ИЗ D234, НОГИ — АНИМАЦИОННЫЙ QA-ПРОТОТИП; НЕ ФИНАЛЬНЫЙ РИСОВАННЫЙ АТЛАС." % [facing, play_text]


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
	var label: Label = _label("D236 / QA FAIL: " + problem, Vector2(115, 270), Vector2(1070, 110), 23)
	label.add_theme_color_override("font_color", Color(1.0, 0.32, 0.30))
	push_error(problem)
