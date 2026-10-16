extends Control

# D153 art-only preview. New skeletal enemies and tether mechanic are staged.
# No combat scene entry until original 25-frame atlases and native QA exist.
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD: RunCardData = preload("res://resources/cards/threadbare_theatre.tres")
const EXPECTED_SIZE := Vector2i(448, 274)


func _ready() -> void:
	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.041, 0.031, 0.035, 1.0)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var heading := _label("D153 / ТЕАТР ОБОРВАННЫХ НИТЕЙ", Vector2(80, 38), Vector2(1120, 64), 28)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var texture: Texture2D = ART_CATALOG.get_run_card_texture("threadbare_theatre")
	if texture == null or texture.get_size() != Vector2(EXPECTED_SIZE):
		_show_error("Оригинальная иллюстрация D153 отсутствует или имеет неверный размер.")
		return
	if CARD.card_id != "threadbare_theatre" or CARD.resolution_type != "combat":
		_show_error("D153 card resource is incomplete.")
		return
	if RunState.ACT1_CARD_IDS.size() != 37 or not RunState.ACT1_CARD_IDS.has("threadbare_theatre"):
		_show_error("D153 должна входить в актуальную колоду 37/45.")
		return
	var frame := Panel.new()
	frame.position = Vector2(376, 135)
	frame.size = Vector2(528, 351)
	add_child(frame)
	var illustration := TextureRect.new()
	illustration.position = Vector2(416, 170)
	illustration.size = Vector2(EXPECTED_SIZE)
	illustration.texture = texture
	illustration.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	illustration.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	illustration.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(illustration)
	var description := _label(CARD.card_text, Vector2(212, 504), Vector2(856, 65), 19)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status := _label("Утверждённый вариант C · 448×274 · костяные марионетки\nАрт-предпросмотр выпущенной карты №36 (37/45).", Vector2(190, 596), Vector2(900, 75), 17)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color(0.72, 0.83, 0.73))


func _label(value: String, pos: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = dimensions
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _show_error(message: String) -> void:
	var label := _label(message, Vector2(120, 298), Vector2(1040, 120), 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.97, 0.4, 0.36))
	push_error(message)
