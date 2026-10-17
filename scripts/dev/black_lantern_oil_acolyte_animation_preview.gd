extends Control

# D217 / QA ONLY: original Oil Acolyte vector-cel trial (curved SICKLE,
# separate oil FLASK and small LANTERN). Source SVG is game-independent.
# FIVE unused empty atlas cells. No live unit animation registration.
const CANDIDATE := "res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg"
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
var source_frames: SpriteFrames


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("D209 лесная арена не загрузилась")
		return
	var source_svg: String = FileAccess.get_file_as_string(CANDIDATE)
	if source_svg.is_empty():
		_fail("D217 кандидат отсутствует в GitHub")
		return
	var atlas := Image.new()
	if atlas.load_svg_from_buffer(source_svg.to_utf8_buffer()) != OK:
		_fail("D217 SVG не декодируется")
		return
	if atlas.get_size() != Vector2i(ATLAS_WIDTH, ATLAS_HEIGHT):
		_fail("D217 неверный размер атласа, требуется 576×480")
		return
	atlas.convert(Image.FORMAT_RGBA8)
	var errors: Array[String] = _inspect(atlas)
	if not errors.is_empty():
		_fail("D217 проверка атласа: " + " / ".join(errors))
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
	_label("D217 / МАСЛЯНЫЙ СЛУЖКА — СЕРП И МАСЛО", Vector2(190, 19), Vector2(900, 38), 25, true)
	_label("Большой просмотр x3", Vector2(123, 154), Vector2(345, 33), 19, true)
	_label("В боевом масштабе x1", Vector2(690, 155), Vector2(420, 32), 19, true)
	state_name = _label("", Vector2(138, 506), Vector2(340, 32), 20, true)
	status = _label(
		"ТЕХНИЧЕСКИЙ QA: 25 SVG-поз с прозрачностью и 5 пустых ячеек.\n"
		+ "ПОЛЬЗОВАТЕЛЬСКИЙ АРТ-QA / БОЕВОЕ ПОДКЛЮЧЕНИЕ ЕЩЁ НЕ ПРИНЯТЫ.",
		Vector2(130, 558), Vector2(1020, 65), 16, true
	)
	large = _sprite(Vector2(280, 384), 3.0)
	actual = _sprite(Vector2(912, 451), 1.0)
	var names: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]
	for i in range(5):
		var button := Button.new()
		button.position = Vector2(176 + i * 187, 633)
		button.size = Vector2(170, 47)
		button.text = names[i]
		add_child(button)
		button.pressed.connect(_play_state.bind(STATE_NAMES[i]))
	_play_state("walk")
	print("D217 shield Oil Acolyte: 25 distinct sprites, 5 clear unused cells, no border contact; QA-only.")


func _sprite(at: Vector2, magnification: float) -> AnimatedSprite2D:
	var view := AnimatedSprite2D.new()
	view.position = at
	view.sprite_frames = source_frames
	view.centered = true
	view.scale = Vector2(magnification, magnification)
	view.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	view.z_index = 20
	add_child(view)
	return view


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
	var error := _label("D217 / QA FAIL: " + reason, Vector2(80, 290), Vector2(1120, 170), 24, true)
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
	var ru := {"idle":"ОЖИДАНИЕ","walk":"ХОДЬБА","attack":"АТАКА СЕРПОМ","hit":"РЕАКЦИЯ НА УДАР","death":"ПАДЕНИЕ"}
	state_name.text = String(ru.get(name, name)).to_upper()
	large.stop()
	actual.stop()
	large.play(name)
	actual.play(name)
