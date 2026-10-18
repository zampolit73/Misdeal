extends Control

# D239 / QA ONLY: B-style SPEAR Sentinel full 25-frame illustrated-source animation pack; 25
# cels, FIVE unused empty atlas cells. One full-pack review only; no live unit animation registration.
const CANDIDATE := "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d239_full25_qa.webp.b64"
const STATE_NAMES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const STATE_COUNTS: Array[int] = [4, 6, 6, 3, 6]
const STATE_FPS: Array[float] = [2.7, 7.0, 16.0, 12.0, 10.0]
const CELL: int = 96
const ATLAS_WIDTH: int = 576
const ATLAS_HEIGHT: int = 480

@onready var backdrop: TextureRect = $BattleBackdrop

var large: AnimatedSprite2D
var actual: AnimatedSprite2D
var status: Label
var state_name: Label
var current_state: String = "walk"
var facing_left: bool = true
var source_frames: SpriteFrames
var left_button: Button
var right_button: Button


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("D209 лесная арена не загрузилась")
		return
	var asset_data: PackedByteArray = Marshalls.base64_to_raw(FileAccess.get_file_as_string(CANDIDATE).strip_edges())
	if asset_data.is_empty():
		_fail("D239 кандидат отсутствует в GitHub")
		return
	var atlas := Image.new()
	if atlas.load_webp_from_buffer(asset_data) != OK:
		_fail("D239 WebP не декодируется")
		return
	if atlas.get_size() != Vector2i(ATLAS_WIDTH, ATLAS_HEIGHT):
		_fail("D239 неверный размер атласа, требуется 576×480")
		return
	atlas.convert(Image.FORMAT_RGBA8)
	var errors: Array[String] = _inspect(atlas)
	if not errors.is_empty():
		_fail("D239 проверка атласа: " + " / ".join(errors))
		return
	var texture: Texture2D = ImageTexture.create_from_image(atlas)
	source_frames = _build_frames(texture)
	# A semi-opaque panel is only a preview background, not a game asset.
	var panel := ColorRect.new()
	panel.position = Vector2(62, 155)
	panel.size = Vector2(470, 398)
	panel.color = Color(0.035, 0.047, 0.059, 0.89)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)
	_label("D239 / АРТ ЗАБРАКОВАН · ОТКРОЙ D241", Vector2(190, 19), Vector2(900, 38), 25, true)
	_label("Большой просмотр x3", Vector2(123, 154), Vector2(345, 33), 19, true)
	_label("В боевом масштабе x1", Vector2(690, 155), Vector2(420, 32), 19, true)
	state_name = _label("", Vector2(84, 506), Vector2(448, 32), 18, true)
	status = _label(
		"D239: ВИЗУАЛЬНЫЙ FAIL; НОВАЯ QA-СЦЕНА D241. ПРОВЕРЬ ОБА НАПРАВЛЕНИЯ И ВСЕ 5 АНИМАЦИЙ.\n"
		+ "25 ПОЗ В ОДНОМ ПАКЕТЕ · ВАЖНО ОЦЕНИТЬ ПЛАВНОСТЬ УКОЛА И ПАДЕНИЯ НА ×1.",
		Vector2(130, 558), Vector2(1020, 65), 16, true
	)
	large = _sprite(Vector2(280, 384), 3.0)
	actual = _sprite(Vector2(912, 451), 1.0)
	# The new 96px spear artwork faces LEFT already; mirror only when facing RIGHT.
	# Flip both galleries, rather than inventing another 25 drawings.
	left_button = _direction_button("← ВЛЕВО", Vector2(82, 102), true)
	right_button = _direction_button("ВПРАВО →", Vector2(285, 102), false)
	_set_facing(true)
	var names: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]
	for i in range(5):
		var button := Button.new()
		button.position = Vector2(176 + i * 187, 633)
		button.size = Vector2(170, 47)
		button.text = names[i]
		add_child(button)
		button.pressed.connect(_play_state.bind(STATE_NAMES[i]))
	_play_state("walk")
	print("D239 armored Spear Sentinel B-style QA: 25 distinct source-composited poses, 5 clear cells; native F6 pending.")


func _sprite(at: Vector2, magnification: float) -> AnimatedSprite2D:
	var view := AnimatedSprite2D.new()
	view.position = at.round()
	view.sprite_frames = source_frames
	view.centered = true
	view.scale = Vector2(magnification, magnification)
	# Nearest-filter only: this is the illustrated-source 96px motion candidate.
	view.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	view.z_index = 20
	add_child(view)
	return view


func _direction_button(caption: String, at: Vector2, face_left: bool) -> Button:
	var button := Button.new()
	button.position = at
	button.size = Vector2(190, 42)
	button.text = caption
	button.toggle_mode = true
	button.add_theme_font_size_override("font_size", 18)
	add_child(button)
	button.pressed.connect(_set_facing.bind(face_left))
	return button


func _set_facing(face_left: bool) -> void:
	facing_left = face_left
	if large != null:
		large.flip_h = not facing_left
	if actual != null:
		actual.flip_h = not facing_left
	if left_button != null:
		left_button.button_pressed = facing_left
	if right_button != null:
		right_button.button_pressed = not facing_left
	_update_state_label()


func _update_state_label() -> void:
	if state_name == null:
		return
	var ru := {"idle":"ОЖИДАНИЕ","walk":"ХОДЬБА","attack":"УКОЛ КОПЬЁМ","hit":"РЕАКЦИЯ НА УДАР","death":"ПАДЕНИЕ"}
	var side := "← ВЛЕВО" if facing_left else "ВПРАВО →"
	state_name.text = "%s · %s" % [String(ru.get(current_state, current_state)), side]


func _label(value: String, at: Vector2, dims: Vector2, font_size: int, centered: bool) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dims
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if centered else HORIZONTAL_ALIGNMENT_LEFT
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.93, 0.85, 0.72))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 40
	add_child(label)
	return label


func _fail(reason: String) -> void:
	var error := _label("D239 / QA FAIL: " + reason, Vector2(80, 290), Vector2(1120, 170), 24, true)
	error.add_theme_color_override("font_color", Color(1, 0.36, 0.32))
	push_error(reason)


func _inspect(atlas: Image) -> Array[String]:
	var errors: Array[String] = []
	var hashes: Dictionary = {}
	var filled := 0
	for row in range(STATE_COUNTS.size()):
		for col in range(6):
			var region := atlas.get_region(Rect2i(col * CELL, row * CELL, CELL, CELL))
			var alpha_count := 0
			var touches_border := false
			for y in range(CELL):
				for x in range(CELL):
					if region.get_pixel(x, y).a <= 0.20:
						continue
					alpha_count += 1
					if x < 2 or x > 93 or y < 2 or y > 93:
						touches_border = true
			if col >= STATE_COUNTS[row]:
				if alpha_count > 0:
					errors.append("непрозрачная пустая ячейка %d:%d" % [row, col])
				continue
			if alpha_count < 70:
				errors.append("пустая поза %d:%d" % [row, col])
			if touches_border:
				errors.append("край ячейки %d:%d" % [row, col])
			var fingerprint: int = hash(region.get_data())
			if hashes.has(fingerprint):
				errors.append("повтор кадра %d:%d" % [row, col])
			hashes[fingerprint] = true
			filled += 1
	if filled != 25:
		errors.append("не 25 кадров")
	return errors


func _build_frames(texture: Texture2D) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(STATE_NAMES.size()):
		var name: String = STATE_NAMES[row]
		frames.add_animation(name)
		frames.set_animation_speed(name, STATE_FPS[row])
		frames.set_animation_loop(name, row < 2)
		for col in range(STATE_COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(float(col * CELL), float(row * CELL), CELL, CELL)
			frames.add_frame(name, tile)
	return frames


func _play_state(name: String) -> void:
	current_state = name
	_update_state_label()
	large.stop()
	actual.stop()
	large.play(name)
	actual.play(name)
