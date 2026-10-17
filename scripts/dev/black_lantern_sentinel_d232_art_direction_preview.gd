extends Control

# D232 ONE-POSE art direction comparison ONLY.
# A single high-fidelity character was isolated from a generated concept image,
# downsampled at native 96x96 with NEAREST and validated for alpha margins.
# It is NOT a 25-frame animation sheet, not approved art, and is not used in BattleUnit.
const OLD_ATLAS: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64"
const NEW_POSE: String = "res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_single_96px.webp.b64"
const SIZE: int = 96

@onready var backdrop: TextureRect = $BattleBackdrop


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_error("Не загружена утверждённая арена D209")
		return
	var original: Texture2D = _get_checked_image(OLD_ATLAS, true)
	var candidate: Texture2D = _get_checked_image(NEW_POSE, false)
	if original == null or candidate == null:
		return
	_panel(Vector2(42, 143), Vector2(559, 435))
	_panel(Vector2(677, 143), Vector2(559, 435))
	_label("D232 / СТРАЖ ДОРОГИ — СРАВНЕНИЕ РИСУНКА ПРИ ×1", Vector2(163, 24), Vector2(1015, 46), 26)
	_label("D229 · ТЕХНИЧЕСКИЙ", Vector2(79, 163), Vector2(485, 35), 20)
	_label("D232 · БОЛЕЕ ДЕТАЛЬНЫЙ ОБРАЗЕЦ", Vector2(713, 163), Vector2(484, 35), 19)
	_label("Увеличение ×3", Vector2(167, 206), Vector2(308, 28), 17)
	_label("Увеличение ×3", Vector2(795, 206), Vector2(320, 28), 17)
	_sprite(original, Vector2(303, 380), 3.0)
	_sprite(candidate, Vector2(931, 380), 3.0)
	_sprite(original, Vector2(526, 520), 1.0)
	_sprite(candidate, Vector2(1154, 520), 1.0)
	_label("Боевой масштаб ×1", Vector2(405, 536), Vector2(190, 28), 15)
	_label("Боевой масштаб ×1", Vector2(1035, 536), Vector2(190, 28), 15)
	_label("D232: ТОЛЬКО ОДНА ПОЗА НА ПРОЗРАЧНОМ ФОНЕ — НЕ 25 КАДРОВ АНИМАЦИИ.\nПРОВЕРЬ КОПЬЁ, БРОНЮ, ФОНАРЬ, ЧИТАЕМОСТЬ И КАЧЕСТВО ПРИ ×1.", Vector2(130, 617), Vector2(1040, 78), 18)
	print("D232: one approved-forest still-frame QA loaded; D229 production atlas unchanged. User art approval pending.")


func _get_checked_image(path: String, from_atlas: bool) -> Texture2D:
	if not FileAccess.file_exists(path):
		_error("Не найден арт: " + path)
		return null
	var encoded: String = FileAccess.get_file_as_string(path).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	var source := Image.new()
	if bytes.is_empty() or source.load_webp_from_buffer(bytes) != OK:
		_error("Не удалось декодировать WebP: " + path)
		return null
	var expected: Vector2i = Vector2i(576, 480) if from_atlas else Vector2i(SIZE, SIZE)
	if source.get_size() != expected:
		_error("Неверный размер: " + path)
		return null
	source.convert(Image.FORMAT_RGBA8)
	var still: Image = source.get_region(Rect2i(0, 0, SIZE, SIZE)) if from_atlas else source
	var visible: int = 0
	var cropped: bool = false
	for y in range(SIZE):
		for x in range(SIZE):
			if still.get_pixel(x, y).a <= 0.2:
				continue
			visible += 1
			if x < 2 or x > 93 or y < 2 or y > 93:
				cropped = true
	if visible < 150 or cropped:
		_error("Пустой или обрезанный кадр: " + path)
		return null
	return ImageTexture.create_from_image(still)


func _sprite(tex: Texture2D, at: Vector2, zoom: float) -> void:
	var spr := Sprite2D.new()
	spr.texture = tex
	spr.position = at.round()
	spr.scale = Vector2.ONE * zoom
	spr.centered = true
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spr.z_index = 20
	add_child(spr)


func _panel(at: Vector2, dims: Vector2) -> void:
	var panel := ColorRect.new()
	panel.position = at
	panel.size = dims
	panel.color = Color(0.023, 0.025, 0.035, 0.83)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)


func _label(value: String, at: Vector2, dims: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dims
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.94, 0.85, 0.72))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 40
	add_child(label)
	return label


func _error(message: String) -> void:
	var label := _label("D232 / QA FAIL: " + message, Vector2(100, 290), Vector2(1075, 130), 24)
	label.add_theme_color_override("font_color", Color(1.0, 0.32, 0.30))
	push_error(message)
