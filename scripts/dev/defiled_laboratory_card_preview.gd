extends Control

# D152 original card-art preview and one-click real-battle QA.
# Released D152 remains in the normal Act1 pool, now 37 cards with D153 and D198.
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD_ID := "defiled_laboratory"
const EXPECTED_SIZE := Vector2i(448, 274)


func _ready() -> void:
	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.039, 0.027, 0.027, 1.0)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var heading: Label = _label("D152 / ОСКВЕРНЁННАЯ ЛАБОРАТОРИЯ", Vector2(96.0, 50.0), Vector2(1088.0, 54.0), 30)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var card: RunCardData = RunState.get_card(CARD_ID)
	var art: Texture2D = ART_CATALOG.get_run_card_texture(CARD_ID)
	if card == null or art == null or art.get_size() != Vector2(EXPECTED_SIZE):
		_show_error("Оригинальная иллюстрация D152 не загружена или имеет неверный размер 448x274.")
		return
	if not RunState.ACT1_CARD_IDS.has(CARD_ID):
		_show_error("D152 должна быть доступна в основной колоде Act 1.")
		return

	var plate := Panel.new()
	plate.position = Vector2(381.0, 143.0)
	plate.size = Vector2(518.0, 344.0)
	add_child(plate)

	var visual := TextureRect.new()
	visual.position = Vector2(416.0, 178.0)
	visual.size = Vector2(EXPECTED_SIZE)
	visual.texture = art
	visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual)

	var description := _label(card.card_text, Vector2(282.0, 506.0), Vector2(716.0, 69.0), 18)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var status := _label("448×274 • оригинальные враги • карта Act 1\nМожно проверить столкновение отдельно от обычной раздачи.", Vector2(315.0, 584.0), Vector2(650.0, 57.0), 16)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color(0.73, 0.80, 0.70, 1.0))

	var play_button := Button.new()
	play_button.text = "ПРОВЕРИТЬ В БОЮ"
	play_button.position = Vector2(502.0, 646.0)
	play_button.size = Vector2(276.0, 50.0)
	play_button.pressed.connect(_open_playtest)
	add_child(play_button)


func _label(value: String, at: Vector2, extent: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = at
	label.size = extent
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _show_error(message: String) -> void:
	var label := _label(message, Vector2(144.0, 300.0), Vector2(992.0, 175.0), 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.98, 0.43, 0.37, 1.0))
	push_error(message)


func _open_playtest() -> void:
	get_tree().change_scene_to_file("res://scenes/dev/defiled_laboratory_playtest.tscn")
