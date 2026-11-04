extends Control

# D389: preview-only 96px C3 concept-derived keyposes. Never changes BattleUnit art.
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ASSET_DIR := "res://assets/pixel/units/hero_c3_keyposes_qa/"
const ROLES: Array[String] = ["knight", "ranger", "mage"]
const TITLES: Array[String] = ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const GROUP_CENTERS := [255.0, 640.0, 1025.0]
const PAIR_SPACING := 73.0
const SOLE_CONTACT_Y := 455.0
const CANDIDATE_SCALES := {"knight": 1.10, "ranger": 1.10, "mage": 1.30}
const GOLD := Color(0.85, 0.73, 0.57)
const PALE := Color(0.88, 0.85, 0.81)
const MUTED := Color(0.68, 0.68, 0.68)

var candidate_sprites: Array[Sprite2D] = []
var candidate_sole_offsets: Array[float] = []


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var arena = BACKDROP.new()
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")

	_add_scrim(Vector2(0, 0), Vector2(1280, 119), Color(0.015, 0.013, 0.020, 0.89))
	_add_scrim(Vector2(0, 545), Vector2(1280, 175), Color(0.015, 0.013, 0.020, 0.92))
	_add_text("MISDEAL / C3 — НОВЫЕ КЛЮЧЕВЫЕ ПОЗЫ 96×96", Vector2(36, 14), Vector2(1200, 44), 26, GOLD)
	_add_text("Слева — текущий игровой герой. Справа — отдельный C3-кандидат в настоящем размере.", Vector2(36, 69), Vector2(920, 28), 17, PALE)

	for index in range(ROLES.size()):
		var role: String = ROLES[index]
		var x_pos: float = GROUP_CENTERS[index]
		_add_text(TITLES[index], Vector2(x_pos - 130, 139), Vector2(260, 30), 20, GOLD, HORIZONTAL_ALIGNMENT_CENTER)

		var original := UNIT_SCENE.instantiate() as BattleUnit
		original.name = "Current_%s" % role
		original.team = 0
		original.visual_role = role
		original.display_name = TITLES[index]
		original.position = Vector2(x_pos - PAIR_SPACING, SOLE_CONTACT_Y - BattleUnit.FLOOR_CONTACT_Y)
		add_child(original)
		(original.get_node("HealthBar") as ProgressBar).hide()
		(original.get_node("NameLabel") as Label).hide()

		var image := _load_candidate_image(role)
		if image == null:
			_add_text("НЕТ АРТА", Vector2(x_pos + 15, 420), Vector2(120, 24), 15, Color(1, 0.4, 0.3))
			continue
		var bounds := _alpha_bounds(image)
		var texture := ImageTexture.create_from_image(image)
		var candidate := Sprite2D.new()
		candidate.name = "C3_%s" % role
		candidate.texture = texture
		candidate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var candidate_scale: float = float(CANDIDATE_SCALES[role])
		candidate.scale = Vector2.ONE * candidate_scale
		add_child(candidate)
		candidate_sprites.append(candidate)
		var sole_offset := float(bounds.position.y + bounds.size.y) - 0.5 - 48.0
		candidate_sole_offsets.append(sole_offset)
		candidate.position = Vector2(
			x_pos + PAIR_SPACING,
			SOLE_CONTACT_Y - sole_offset * candidate_scale
		)

		_add_text("СЕЙЧАС", Vector2(x_pos - PAIR_SPACING - 66, 490), Vector2(132, 29), 15, PALE, HORIZONTAL_ALIGNMENT_CENTER)
		_add_text("C3 / 96px", Vector2(x_pos + PAIR_SPACING - 66, 490), Vector2(132, 29), 15, GOLD, HORIZONTAL_ALIGNMENT_CENTER)

	_add_text("D389 / СТАТИЧЕСКИЕ КЛЮЧЕВЫЕ ПОЗЫ", Vector2(36, 558), Vector2(1040, 32), 20, GOLD)
	_add_text("Это отдельные 96×96 концепт-производные пиксельные кандидаты, не финальные спрайты и не анимации.", Vector2(36, 603), Vector2(1200, 25), 17, PALE)
	_add_text("Проверяем силуэт, ноги и оружие на фоне арены. До 25 кадров на героя и замены в бою ещё не дошли.", Vector2(36, 646), Vector2(1200, 25), 15, MUTED)


func _load_candidate_image(role: String) -> Image:
	var path := "%s%s_96.webp.b64" % [ASSET_DIR, role]
	if not FileAccess.file_exists(path):
		push_warning("D389 C3 candidate image missing: " + path)
		return null
	var encoded := FileAccess.get_file_as_string(path).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_warning("D389 C3 candidate Base64 is empty: " + path)
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK:
		push_warning("D389 C3 candidate WebP decode failed: " + path)
		return null
	if image.get_size() != Vector2i(96, 96):
		push_warning("D389 C3 candidate must be 96x96: " + path)
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image


func _alpha_bounds(image: Image) -> Rect2i:
	var min_x := image.get_width()
	var min_y := image.get_height()
	var max_x := -1
	var max_y := -1
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.5:
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
	if max_x < min_x or max_y < min_y:
		return Rect2i()
	return Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)


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
