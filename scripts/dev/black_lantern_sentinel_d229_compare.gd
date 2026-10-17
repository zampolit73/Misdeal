extends Control

# D229: isolated side-by-side VISUAL QA, not a production BattleUnit.
# Both candidates use exactly the same 4/6/6/3/6 states and native 96px cells.
const OLD_ATLAS: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d228_art_candidate.webp.b64"
const NEW_ATLAS: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64"
const ANIMATIONS: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]
const FPS: Array[float] = [2.7, 7.0, 16.0, 12.0, 10.0]
const CELL: int = 96

@onready var backdrop: TextureRect = $BattleBackdrop

var old_big: AnimatedSprite2D
var new_big: AnimatedSprite2D
var old_actual: AnimatedSprite2D
var new_actual: AnimatedSprite2D
var face_left: bool = true
var current_anim: String = "walk"
var status_label: Label
var face_left_button: Button
var face_right_button: Button
var animation_buttons: Array[Button] = []


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_show_failure("D209 утверждённый лес не загрузился")
		return
	var old_frames: SpriteFrames = _load_checked_frames(OLD_ATLAS)
	var new_frames: SpriteFrames = _load_checked_frames(NEW_ATLAS)
	if old_frames == null or new_frames == null:
		return
	_panel(Vector2(60, 160), Vector2(552, 404))
	_panel(Vector2(667, 160), Vector2(552, 404))
	_label("D229 / СТРАЖ ДОРОГИ — СРАВНЕНИЕ ДВУХ АРТОВ", Vector2(160, 15), Vector2(970, 42), 26)
	_label("D228 — ПРЕДЫДУЩИЙ", Vector2(124, 163), Vector2(420, 30), 21)
	_label("D229 — НОВЫЙ СИЛУЭТ", Vector2(729, 163), Vector2(425, 30), 21)
	_label("Увеличение ×3", Vector2(198, 194), Vector2(280, 28), 17)
	_label("Увеличение ×3", Vector2(804, 194), Vector2(280, 28), 17)
	_label("Боевой масштаб ×1", Vector2(354, 507), Vector2(212, 28), 15)
	_label("Боевой масштаб ×1", Vector2(960, 507), Vector2(212, 28), 15)
	old_big = _sprite(old_frames, Vector2(294, 360), 3.0)
	new_big = _sprite(new_frames, Vector2(901, 360), 3.0)
	old_actual = _sprite(old_frames, Vector2(460, 505), 1.0)
	new_actual = _sprite(new_frames, Vector2(1066, 505), 1.0)
	face_left_button = _face_button("← ВЛЕВО", Vector2(356, 90), true)
	face_right_button = _face_button("ВПРАВО →", Vector2(745, 90), false)
	status_label = _label("", Vector2(112, 568), Vector2(1058, 66), 18)
	var ru: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]
	for i in range(ANIMATIONS.size()):
		var btn := Button.new()
		btn.position = Vector2(190 + i * 183, 652)
		btn.size = Vector2(170, 45)
		btn.text = ru[i]
		add_child(btn)
		btn.pressed.connect(_play_anim.bind(ANIMATIONS[i]))
		animation_buttons.append(btn)
	_apply_facing(true)
	_play_anim("walk")
	print("D229: both versioned 25-frame Sentinel atlases loaded, synchronized left/right art review ready; QA ONLY.")


func _load_checked_frames(path: String) -> SpriteFrames:
	if not FileAccess.file_exists(path):
		_show_failure("Нет атласа: " + path)
		return null
	var bytes: PackedByteArray = Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var img := Image.new()
	if bytes.is_empty() or img.load_webp_from_buffer(bytes) != OK:
		_show_failure("Невозможно открыть WebP: " + path)
		return null
	if img.get_size() != Vector2i(CELL * 6, CELL * 5):
		_show_failure("Неверный размер 576×480: " + path)
		return null
	img.convert(Image.FORMAT_RGBA8)
	var errors: Array[String] = _check_atlas(img)
	if not errors.is_empty():
		_show_failure("Повреждён атлас: " + ", ".join(errors))
		return null
	var tex: Texture2D = ImageTexture.create_from_image(img)
	var anim := SpriteFrames.new()
	if anim.has_animation("default"):
		anim.remove_animation("default")
	for row in range(ANIMATIONS.size()):
		var name: String = ANIMATIONS[row]
		anim.add_animation(name)
		anim.set_animation_speed(name, FPS[row])
		anim.set_animation_loop(name, row < 2)
		for col in range(COUNTS[row]):
			var frame := AtlasTexture.new()
			frame.atlas = tex
			frame.region = Rect2(float(col * CELL), float(row * CELL), CELL, CELL)
			anim.add_frame(name, frame)
	return anim


func _check_atlas(image: Image) -> Array[String]:
	var errors: Array[String] = []
	var hashes: Dictionary = {}
	var total: int = 0
	for row in range(COUNTS.size()):
		for col in range(6):
			var cel: Image = image.get_region(Rect2i(col * CELL, row * CELL, CELL, CELL))
			var count: int = 0
			var edge: bool = false
			for y in range(CELL):
				for x in range(CELL):
					if cel.get_pixel(x, y).a <= 0.20:
						continue
					count += 1
					if x < 2 or y < 2 or x > 93 or y > 93:
						edge = true
			if col >= COUNTS[row]:
				if count != 0:
					errors.append("непустая служебная ячейка %s:%s" % [row, col])
				continue
			total += 1
			if count < 70:
				errors.append("нет кадра %s:%s" % [row, col])
			if edge:
				errors.append("обрезан кадр %s:%s" % [row, col])
			var signature: int = hash(cel.get_data())
			if hashes.has(signature):
				errors.append("повтор кадра %s:%s" % [row, col])
			hashes[signature] = true
	if total != 25:
		errors.append("не 25 кадров")
	return errors


func _sprite(frames: SpriteFrames, at: Vector2, magnification: float) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.position = at.round()
	sprite.scale = Vector2(magnification, magnification)
	sprite.centered = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.z_index = 20
	add_child(sprite)
	return sprite


func _face_button(caption: String, at: Vector2, left: bool) -> Button:
	var btn := Button.new()
	btn.position = at
	btn.size = Vector2(180, 42)
	btn.text = caption
	btn.toggle_mode = true
	add_child(btn)
	btn.pressed.connect(_apply_facing.bind(left))
	return btn


func _apply_facing(left: bool) -> void:
	face_left = left
	# These native-authored frames face LEFT; opposite direction uses flip_h.
	for sprite in [old_big, new_big, old_actual, new_actual]:
		if sprite != null:
			sprite.flip_h = not face_left
	if face_left_button != null:
		face_left_button.button_pressed = face_left
	if face_right_button != null:
		face_right_button.button_pressed = not face_left
	_update_label()


func _play_anim(name: String) -> void:
	current_anim = name
	for sprite in [old_big, new_big, old_actual, new_actual]:
		if sprite != null:
			sprite.stop()
			sprite.play(name)
	_update_label()


func _update_label() -> void:
	if status_label == null:
		return
	var ru: Dictionary = {"idle":"ОЖИДАНИЕ", "walk":"ХОДЬБА", "attack":"УКОЛ КОПЬЁМ", "hit":"УРОН", "death":"СМЕРТЬ"}
	var facing: String = "ВЛЕВО" if face_left else "ВПРАВО"
	status_label.text = "%s · %s | СОПОСТАВЬ БРОНЮ, КОПЬЁ, ФОНАРЬ И ПОСТАНОВКУ НОГ В МАСШТАБЕ ×1.\nНА D228 НЕТ ПОДТВЕРЖДЁННОГО F6 PASS; D229 — ВИЗУАЛЬНЫЙ КАНДИДАТ, НЕ БОЕВОЙ СПРАЙТ." % [String(ru.get(current_anim, current_anim)), facing]


func _panel(at: Vector2, bounds: Vector2) -> void:
	var bg := ColorRect.new()
	bg.position = at
	bg.size = bounds
	bg.color = Color(0.025, 0.029, 0.041, 0.88)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)


func _label(content: String, at: Vector2, bounds: Vector2, size: int) -> Label:
	var label := Label.new()
	label.position = at
	label.size = bounds
	label.text = content
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.70))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 40
	add_child(label)
	return label


func _show_failure(message: String) -> void:
	var label: Label = _label("D229 / QA FAIL: " + message, Vector2(102, 280), Vector2(1070, 150), 24)
	label.add_theme_color_override("font_color", Color(1.0, 0.29, 0.27))
	push_error(message)