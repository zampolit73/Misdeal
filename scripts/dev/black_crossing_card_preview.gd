extends Control

# D182 card-art acceptance gallery only; no combat or Act1 pool changes.
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD: RunCardData = preload("res://resources/cards/black_crossing.tres")
const EXPECTED_SIZE := Vector2i(448, 274)


func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.038, 0.047, 0.057, 1.0)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	var heading := _label("D182 / ЧЁРНАЯ ПЕРЕПРАВА", Vector2(90, 55), Vector2(1100, 60), 28)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var art: Texture2D = ART_CATALOG.get_run_card_texture("black_crossing")
	if art == null or art.get_size() != Vector2(EXPECTED_SIZE):
		_error("D182: approved card image is missing or has incorrect 448x274 size.")
		return
	if CARD.card_id != "black_crossing" or CARD.resolution_type != "combat":
		_error("D182 candidate RunCardData is invalid.")
		return
	if RunState.ACT1_CARD_IDS.size() != 36 or RunState.ACT1_CARD_IDS.has("black_crossing"):
		_error("D182 must remain outside the 36-card live pool.")
		return
	if RunState.CARD_PATHS.get("black_crossing", "") != "res://resources/cards/black_crossing.tres":
		_error("D188 QA-only card resource mapping is missing.")
		return
	var frame := Panel.new()
	frame.position = Vector2(376, 145)
	frame.size = Vector2(528, 351)
	add_child(frame)
	var illustration := TextureRect.new()
	illustration.position = Vector2(416, 180)
	illustration.size = Vector2(EXPECTED_SIZE)
	illustration.texture = art
	illustration.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	illustration.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	illustration.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(illustration)
	var description := _label(CARD.card_text, Vector2(235, 510), Vector2(810, 70), 18)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status := _label("Композиция 3 • 448×274 • будущая карта №37", Vector2(155, 608), Vector2(970, 54), 18)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color(0.72, 0.83, 0.75))


func _label(value: String, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = at
	label.size = dimensions
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _error(message: String) -> void:
	var label := _label(message, Vector2(120, 300), Vector2(1040, 140), 23)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.98, 0.37, 0.33))
	push_error(message)
