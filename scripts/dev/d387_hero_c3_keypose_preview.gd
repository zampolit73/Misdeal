extends Control

# D387 hero C3 lookdev only. This scene never replaces production combat art.
# The candidate image contains three concept-derived SINGLE key poses.
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const C3_KEYPOSE_PATH := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_keyposes_48.webp.b64"
const SOURCE_CELL := 48
const ROLES: Array[String] = ["knight", "ranger", "mage"]
const TITLES: Array[String] = ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const X_POSITIONS := [300.0, 640.0, 980.0]
const GOLD := Color(0.85, 0.73, 0.57)
const PALE := Color(0.88, 0.85, 0.81)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var arena: TextureRect = BACKDROP.new()
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(arena)
	arena.set_arena_id("firing_square")

	_add_scrim(Vector2(0, 0), Vector2(1280, 124), Color(0.015, 0.013, 0.020, 0.89))
	_add_scrim(Vector2(0, 560), Vector2(1280, 160), Color(0.015, 0.013, 0.020, 0.92))
	_add_text("MISDEAL / C3 — ТЁМНЫЙ ОРДЕН", Vector2(36, 17), Vector2(1190, 43), 27, GOLD)
	_add_text("СВЕРХУ: действующие бойцы. СНИЗУ: три тестовые C3-позы без анимации.", Vector2(38, 66), Vector2(1190, 30), 17, PALE)

	var image := _decode_keyposes()
	if image == null:
		_add_text("C3: исходные тестовые позы не загружены.", Vector2(50, 450), Vector2(1120, 40), 21, Color(1, 0.4, 0.3))
		return
	var texture := ImageTexture.create_from_image(image)
	for index in range(ROLES.size()):
		var x_pos: float = X_POSITIONS[index]
		var original := UNIT_SCENE.instantiate() as BattleUnit
		original.team = 0
		original.visual_role = ROLES[index]
		original.display_name = TITLES[index]
		original.position = Vector2(x_pos, 296)
		add_child(original)
		(original.get_node("HealthBar") as ProgressBar).hide()
		(original.get_node("NameLabel") as Label).hide()

		var cell := AtlasTexture.new()
		cell.atlas = texture
		cell.region = Rect2(index * SOURCE_CELL, 0, SOURCE_CELL, SOURCE_CELL)
		var candidate := Sprite2D.new()
		candidate.texture = cell
		candidate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		# 48px preliminary art is displayed as a 96px study, not a production atlas.
		candidate.scale = Vector2(2.0, 2.0)
		candidate.position = Vector2(x_pos, 454)
		add_child(candidate)
		_add_text(TITLES[index], Vector2(x_pos - 108, 555), Vector2(216, 30), 17, GOLD, HORIZONTAL_ALIGNMENT_CENTER)

	_add_text("C3 KEY-POSE QA / НЕ ИГРОВЫЕ АНИМАЦИИ", Vector2(38, 617), Vector2(1190, 29), 18, GOLD)
	_add_text("Только проверка силуэта, ног и оружия на настоящем фоне. Для внедрения нужны 25 разных кадров на героя.", Vector2(38, 656), Vector2(1190, 30), 15, PALE)

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
