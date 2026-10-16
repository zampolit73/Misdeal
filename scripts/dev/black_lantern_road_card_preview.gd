extends Control

# D200: isolated final-size CARD ART review. No fight fixture, runtime card
# registration, pool edits or Godot combat changes. The source is the user's
# explicitly selected THIRD scene illustration, not the labelled concept sheet.
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD: RunCardData = preload("res://resources/cards/black_lantern_road.tres")
const EXPECTED_SIZE := Vector2i(448, 274)
const ASSET_PATH := "res://assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64"


func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color(0.041, 0.043, 0.056, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var heading := _label("D200 / ДОРОГА ЧЁРНЫХ ФОНАРЕЙ", Vector2(80, 47), Vector2(1120, 64), 27)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	if not FileAccess.file_exists(ASSET_PATH):
		_fail("Выбранный арт #38 отсутствует: " + ASSET_PATH)
		return
	var texture: Texture2D = ART_CATALOG.get_run_card_texture("black_lantern_road")
	if texture == null or texture.get_size() != Vector2(EXPECTED_SIZE):
		_fail("D200: неправильный размер/загрузка WebP. Ожидается 448×274.")
		return
	if CARD.card_id != "black_lantern_road" or CARD.resolution_type != "combat" or CARD.tier != 1:
		_fail("D200: неверный QA-only ресурс карты.")
		return
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		_fail("Карта №38 пока не должна входить в обычную колоду 37/45.")
		return

	var frame := Panel.new()
	frame.position = Vector2(376, 145)
	frame.size = Vector2(528, 351)
	add_child(frame)

	var art := TextureRect.new()
	art.position = Vector2(416, 181)
	art.size = Vector2(EXPECTED_SIZE)
	art.texture = texture
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(art)

	var description := _label(CARD.card_text, Vector2(200, 516), Vector2(880, 66), 18)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status := _label(
		"Композиция 3 • 448×274 • 5 оригинальных скелетов • №38 ещё не в колоде",
		Vector2(162, 610), Vector2(956, 70), 17
	)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color(0.66, 0.85, 0.72))


func _label(message: String, position_value: Vector2, rect_size: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = position_value
	label.size = rect_size
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _fail(message: String) -> void:
	var label := _label(message, Vector2(100, 284), Vector2(1080, 170), 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.97, 0.41, 0.37))
	push_error(message)
