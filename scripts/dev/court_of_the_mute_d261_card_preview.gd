extends Control

# D261: second user-approved Court of the Mute illustration. QA preview only.
# Full 448x274 image is derived from the exact selected portrait composition,
# without image regeneration or stretching faces. Card #39 is NOT released.
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD: RunCardData = preload("res://resources/cards/court_of_the_mute.tres")
const ART_FILE := "res://assets/pixel/card_unification_v1/run/court_of_the_mute_selected_v1.webp.b64"
const CARD_ID := "court_of_the_mute"
const SIZE := Vector2i(448, 274)

func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color(0.041, 0.043, 0.056, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var heading := _label("D261 · СУД БЕЗМОЛВНЫХ", Vector2(80, 45), Vector2(1120, 68), 28)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	if not FileAccess.file_exists(ART_FILE):
		_fail("Не найден выбранный второй арт: " + ART_FILE)
		return
	if CARD.card_id != CARD_ID or CARD.tier != 1 or CARD.resolution_type != "combat":
		_fail("QA-ресурс карты #39 неверен.")
		return
	if not CARD.target_path.is_empty():
		_fail("Бой #39 ещё не построен: запрещён маршрут к чужому бою.")
		return
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_fail("Карта #39 должна оставаться вне обычной колоды 38/45.")
		return
	if RunState.get_card(CARD_ID) == null:
		_fail("Ресурс карты #39 отсутствует в QA-каталоге.")
		return
	var art_texture: Texture2D = ART_CATALOG.get_run_card_texture(CARD_ID)
	if art_texture == null or art_texture.get_size() != Vector2(SIZE):
		_fail("Выбранный второй арт не загрузился в 448×274.")
		return

	var frame := Panel.new()
	frame.position = Vector2(376, 145)
	frame.size = Vector2(528, 351)
	add_child(frame)
	var art := TextureRect.new()
	art.position = Vector2(416, 181)
	art.size = Vector2(SIZE)
	art.texture = art_texture
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(art)
	var description := _label(CARD.card_text, Vector2(180, 506), Vector2(920, 68), 18)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status := _label(
		"УТВЕРЖДЁН ВАРИАНТ 2 · 448×274 · ТРИ НОВЫХ ТИПА ВРАГОВ В РАБОТЕ · 38/45",
		Vector2(135, 610), Vector2(1010, 65), 16
	)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color(0.68, 0.84, 0.71))
	print("D261_SELECTED_ART_PASS: option 2 source-derived 448x274 WebP in CardArtCatalog; QA card #39, LIVE 38/45")

func _label(message: String, pos: Vector2, rect: Vector2, size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = rect
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	add_child(label)
	return label

func _fail(message: String) -> void:
	var label := _label(message, Vector2(100, 280), Vector2(1080, 165), 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.96, 0.43, 0.36))
	push_error("D261: " + message)
