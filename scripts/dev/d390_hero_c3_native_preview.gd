extends Control

# D390: directly drawn pixel 96px still comparison ONLY. Never change production BattleUnit art.
# Every pair shares the same painted stone floor and contact line.
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const C3_KEYPOSE_PATH := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_native_d390_96.webp.b64"
const SOURCE_CELL := 96
const ROLES: Array[String] = ["knight", "ranger", "mage"]
const TITLES: Array[String] = ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const GROUP_CENTERS := [255.0, 640.0, 1025.0]
const PAIR_SPACING := 73.0
const SOLE_CONTACT_Y := 455.0
# D390: 96px stills: native pixels at 1.0; 1.3 is only an optional size study.
const COMPARE_SCALE := 1.0
const CELL_SCALE := 1.3
const GOLD := Color(0.85, 0.73, 0.57)
const PALE := Color(0.88, 0.85, 0.81)
const MUTED := Color(0.65, 0.67, 0.69)

var candidate_sprites: Array[Sprite2D] = []
var candidate_sole_offsets: Array[float] = []
var candidate_scale := COMPARE_SCALE
var scale_button: Button


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var arena = BACKDROP.new()
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")

	_add_scrim(Vector2(0, 0), Vector2(1280, 119), Color(0.015, 0.013, 0.020, 0.89))
	_add_scrim(Vector2(0, 545), Vector2(1280, 175), Color(0.015, 0.013, 0.020, 0.92))
	_add_text("MISDEAL / C3 — D390 ПИКСЕЛЬНЫЕ ФИГУРКИ", Vector2(36, 14), Vector2(1200, 44), 26, GOLD)
	_add_text("Каждая пара стоит на одном полу: действующий герой слева, пробный C3 справа.", Vector2(36, 69), Vector2(920, 28), 17, PALE)

	var image := _decode_keyposes()
	if image == null:
		_add_text("C3: тестовые позы не загружены.", Vector2(50, 405), Vector2(1120, 40), 22, Color(1, 0.45, 0.34))
		return
	var texture := ImageTexture.create_from_image(image)
	for index in range(ROLES.size()):
		var x_pos: float = GROUP_CENTERS[index]
		_add_text(TITLES[index], Vector2(x_pos - 130, 139), Vector2(260, 30), 20, GOLD, HORIZONTAL_ALIGNMENT_CENTER)

		var original := UNIT_SCENE.instantiate() as BattleUnit
		original.name = "Current_%s" % ROLES[index]
		original.team = 0
		original.visual_role = ROLES[index]
		original.display_name = TITLES[index]
		# BattleUnit already places its visible boots/shadow at local +36.
		# The old y=296 position left these figures hovering over the castle wall.
		original.position = Vector2(x_pos - PAIR_SPACING, SOLE_CONTACT_Y - BattleUnit.FLOOR_CONTACT_Y)
		add_child(original)
		(original.get_node("HealthBar") as ProgressBar).hide()
		(original.get_node("NameLabel") as Label).hide()

		var cell := AtlasTexture.new()
		cell.atlas = texture
		cell.region = Rect2(index * SOURCE_CELL, 0, SOURCE_CELL, SOURCE_CELL)
		var candidate := Sprite2D.new()
		candidate.name = "C3_%s" % ROLES[index]
		candidate.texture = cell
		candidate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(candidate)
		candidate_sprites.append(candidate)
		candidate_sole_offsets.append(_candidate_sole_offset(image, index))
		_position_candidate(index)

		_add_text("СЕЙЧАС", Vector2(x_pos - PAIR_SPACING - 66, 490), Vector2(132, 29), 15, PALE, HORIZONTAL_ALIGNMENT_CENTER)
		_add_text("C3 / D390", Vector2(x_pos + PAIR_SPACING - 66, 490), Vector2(132, 29), 15, MUTED, HORIZONTAL_ALIGNMENT_CENTER)

	_add_text("D390 / РИСУНОК В СЕТКЕ 96×96", Vector2(36, 558), Vector2(1040, 32), 20, GOLD)
	_add_text("Новые пиксельные фигурки нарисованы сразу в сетке 96×96, без уменьшения концепта.", Vector2(36, 603), Vector2(1200, 25), 17, PALE)
	_add_text("Проверяем силуэт при ×1. Это 3 статичные позы, не 75 кадров анимации.", Vector2(36, 646), Vector2(1200, 25), 15, MUTED)

	scale_button = Button.new()
	scale_button.name = "CandidateScaleButton"
	scale_button.position = Vector2(1000, 71)
	scale_button.size = Vector2(234, 30)
	scale_button.focus_mode = Control.FOCUS_NONE
	scale_button.pressed.connect(_toggle_candidate_scale)
	add_child(scale_button)
	_update_scale_button()


func _position_candidate(index: int) -> void:
	var candidate := candidate_sprites[index]
	var x_pos: float = GROUP_CENTERS[index] + PAIR_SPACING
	candidate.scale = Vector2.ONE * candidate_scale
	# Align the bottommost actually visible C3 pixel with the same physical
	# contact Y used by the real BattleUnit ring, regardless of crop margins.
	candidate.position = Vector2(x_pos, SOLE_CONTACT_Y - candidate_sole_offsets[index] * candidate_scale)


func _toggle_candidate_scale() -> void:
	candidate_scale = CELL_SCALE if is_equal_approx(candidate_scale, COMPARE_SCALE) else COMPARE_SCALE
	for index in range(candidate_sprites.size()):
		_position_candidate(index)
	_update_scale_button()


func _update_scale_button() -> void:
	scale_button.text = "C3: ×1 (реальные 96px)" if is_equal_approx(candidate_scale, COMPARE_SCALE) else "C3: ×1.3 (сравнить рост)"


func _candidate_sole_offset(image: Image, index: int) -> float:
	var last_visible_y := -1
	for y in range(SOURCE_CELL):
		for x in range(index * SOURCE_CELL, (index + 1) * SOURCE_CELL):
			if image.get_pixel(x, y).a > 0.5:
				last_visible_y = y
	if last_visible_y < 0:
		return 0.0
	return float(last_visible_y) + 0.5 - float(SOURCE_CELL) * 0.5


func _decode_keyposes() -> Image:
	if not FileAccess.file_exists(C3_KEYPOSE_PATH):
		return null
	var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(C3_KEYPOSE_PATH).strip_edges())
	if bytes.is_empty():
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK:
		return null
	if image.get_size() != Vector2i(SOURCE_CELL * ROLES.size(), SOURCE_CELL):
		return null
	return image


func _add_scrim(at: Vector2, dimensions: Vector2, tint: Color) -> void:
	var node := ColorRect.new()
	node.position = at
	node.size = dimensions
	node.color = tint
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(node)


func _add_text(value: String, at: Vector2, dimensions: Vector2, point_size: int, tint: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dimensions
	label.horizontal_alignment = alignment
	label.add_theme_font_size_override("font_size", point_size)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
