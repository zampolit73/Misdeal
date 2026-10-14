extends Control

# D151 art QA only. Reads explicit staged candidate assets, never joins Act1 deck.
const CARD_FILE := "res://assets/pixel/card_unification_v1/run/funeral_procession.webp"
const ATLAS_DIR := "res://assets/pixel/units/deck_expansion_v1/"
const ROLES := ["funeral_priest", "pallbearer"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const COUNTS := [4, 6, 6, 3, 6]
const CELL_SIZE := 96
const ATLAS_SIZE := Vector2i(576, 480)

var actors: Array[AnimatedSprite2D] = []
var mode_label: Label
var errors: Array[String] = []
var clipped_frames: Dictionary = {}


func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("#110c0e")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	_make_label("MISDEAL — ПОГРЕБАЛЬНАЯ ПРОЦЕССИЯ / АРТ D151", Vector2(45, 35), Vector2(1150, 46), 24, Color("#dfb77e"))
	_make_label("Визуальная проверка кандидатов • карта и новые кадры, без включения боя в колоду", Vector2(45, 89), Vector2(1140, 34), 15, Color("#bba690"))

	var card := TextureRect.new()
	card.position = Vector2(40, 141)
	card.size = Vector2(526, 325)
	card.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	card.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(card)

	var scene_art := _load_card()
	if scene_art != null:
		card.texture = scene_art
	_make_label("ОРИГИНАЛЬНЫЙ СЮЖЕТ КАРТЫ • 448×274", Vector2(44, 471), Vector2(526, 32), 16, Color("#dfb77e"))

	for index in range(ROLES.size()):
		var role: String = ROLES[index]
		var actor := AnimatedSprite2D.new()
		actor.position = Vector2(715 + index * 272, 346)
		actor.scale = Vector2(2.10, 2.10)
		actor.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		actor.flip_h = true
		actor.sprite_frames = _load_actor(role)
		add_child(actor)
		actors.append(actor)
		if actor.sprite_frames != null:
			actor.play("idle")

		var baseline := ColorRect.new()
		baseline.color = Color("#8b6c56")
		baseline.position = Vector2(actor.position.x - 87, 442)
		baseline.size = Vector2(174, 2)
		add_child(baseline)
		_make_label("ПОГРЕБАЛЬНЫЙ ЖРЕЦ" if index == 0 else "ГРОБОНОСЕЦ",
			Vector2(actor.position.x - 130, 474), Vector2(260, 32), 17, Color("#dfb77e"))

	var priest_cut: int = int(clipped_frames.get("funeral_priest", 0))
	var bearer_cut: int = int(clipped_frames.get("pallbearer", 0))
	if priest_cut > 0 or bearer_cut > 0:
		_make_label("АРТ НЕ ГОТОВ: выход за края ячеек — жрец %d/25, гробоносец %d/25. Ноги и края обрезаны." % [priest_cut, bearer_cut],
			Vector2(35, 511), Vector2(1170, 46), 16, Color("#e79b79"))
	else:
		_make_label("Проверка границ кадров пройдена — анимации требуют визуальной приёмки.",
			Vector2(35, 511), Vector2(1170, 44), 15, Color("#9dc7a8"))
	mode_label = _make_label("Пять состояний: отдельные прозрачные кадры", Vector2(46, 556), Vector2(1180, 35), 17, Color("#ddd3c4"))
	for i in range(STATES.size()):
		var button := Button.new()
		button.text = STATES[i].to_upper()
		button.position = Vector2(102 + 218 * i, 613)
		button.size = Vector2(188, 48)
		button.pressed.connect(_select_state.bind(STATES[i]))
		add_child(button)
	if not errors.is_empty():
		mode_label.text = "АРТ НЕ ГОТОВ: " + ", ".join(errors)
		mode_label.add_theme_color_override("font_color", Color("#e79b79"))


func _load_card() -> Texture2D:
	if not FileAccess.file_exists(CARD_FILE):
		errors.append("нет funeral_procession.webp")
		return null
	var image := Image.new()
	if image.load(CARD_FILE) != OK or image.get_size() != Vector2i(448, 274):
		errors.append("неверный формат карты")
		return null
	return ImageTexture.create_from_image(image)


func _load_actor(role: String) -> SpriteFrames:
	var path := ATLAS_DIR + role + "_frames.webp.b64"
	if not FileAccess.file_exists(path):
		errors.append("нет атласа " + role)
		return null
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var image := Image.new()
	if raw.is_empty() or image.load_webp_from_buffer(raw) != OK or image.get_size() != ATLAS_SIZE:
		errors.append("неверный атлас " + role)
		return null

	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(STATES.size()):
		var state: String = STATES[row]
		frames.add_animation(state)
		frames.set_animation_speed(state, [2.7, 7.0, 16.0, 12.0, 10.0][row])
		frames.set_animation_loop(state, row < 2)
		for column in range(COUNTS[row]):
			var region := Rect2i(column * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE)
			var cell := image.get_region(region)
			if not _has_visible_pixels(cell):
				errors.append("%s %s кадр %d пуст" % [role, state, column + 1])
			if _touches_cell_edge(cell):
				clipped_frames[role] = int(clipped_frames.get(role, 0)) + 1
			var tile := ImageTexture.create_from_image(cell)
			frames.add_frame(state, tile)
	return frames


func _has_visible_pixels(cell: Image) -> bool:
	var count := 0
	for y in range(0, CELL_SIZE, 4):
		for x in range(0, CELL_SIZE, 4):
			if cell.get_pixel(x, y).a > 0.24:
				count += 1
	return count > 16


# Detect actual clipping in the authored source atlas, not viewer positioning.
# Dense alpha on 2px cell borders means limbs/coffin/cloak are truncated.
func _touches_cell_edge(cell: Image) -> bool:
	var border_count := 0
	for pixel in range(CELL_SIZE):
		for margin in range(2):
			if cell.get_pixel(pixel, margin).a > 0.25:
				border_count += 1
			if cell.get_pixel(pixel, CELL_SIZE - 1 - margin).a > 0.25:
				border_count += 1
			if cell.get_pixel(margin, pixel).a > 0.25:
				border_count += 1
			if cell.get_pixel(CELL_SIZE - 1 - margin, pixel).a > 0.25:
				border_count += 1
	return border_count > 8


func _select_state(state: String) -> void:
	mode_label.text = "РЕЖИМ: " + state.to_upper()
	for actor in actors:
		if actor.sprite_frames == null:
			continue
		actor.stop()
		actor.play(state)


func _make_label(value: String, pos: Vector2, dimensions: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	add_child(label)
	return label
