extends Control

# D263 QA-only VIEW of a separately-authored EMPTY tribunal scene plate.
# Contains NO combat character silhouettes. This is not a card art replacement.
const ARENA_FILE := "res://assets/pixel/battle/arenas/court_of_the_mute_d263_qa.webp.b64"
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD_ID := "court_of_the_mute"

var bounds_overlay: ColorRect
var bounds_label: Label


func _ready() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_fail("Court #39 must stay OUT of released 38-card pool")
		return
	var card := RunState.get_card(CARD_ID)
	if card == null or not card.target_path.is_empty():
		_fail("D263 Court card QA resource is missing or accidentally released")
		return
	if not FileAccess.file_exists(ARENA_FILE):
		_fail("Original Court QA arena has not been authored yet: " + ARENA_FILE)
		return
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(ARENA_FILE).strip_edges())
	var plate := Image.new()
	if raw.is_empty() or plate.load_webp_from_buffer(raw) != OK or plate.get_size() != Vector2i(1280, 720):
		_fail("D263 Court arena must decode at true 1280×720")
		return
	var background := TextureRect.new()
	background.texture = ImageTexture.create_from_image(plate)
	background.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Show the user's *exact chosen* D261 card artwork as a small reference;
	# do not ever scale / bake actors from it into the editable scene plate.
	var card_art: Texture2D = ART_CATALOG.get_run_card_texture(CARD_ID)
	if card_art == null or card_art.get_size() != Vector2(448, 274):
		_fail("D261 user-selected second card illustration no longer loads")
		return
	var reference := TextureRect.new()
	reference.position = Vector2(1013, 17)
	reference.size = Vector2(251, 154)
	reference.texture = card_art
	reference.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reference.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	reference.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(reference)

	var heading := Label.new()
	heading.text = "D263 · СУД БЕЗМОЛВНЫХ · АРЕНА QA"
	heading.position = Vector2(28, 22)
	heading.size = Vector2(880, 55)
	heading.add_theme_font_size_override("font_size", 24)
	heading.add_theme_color_override("font_color", Color(0.94, 0.83, 0.70))
	add_child(heading)
	var warning := Label.new()
	warning.text = "Только пустая арена. Три набора анимаций ещё проходят художественную проверку."
	warning.position = Vector2(29, 55)
	warning.size = Vector2(920, 49)
	warning.add_theme_font_size_override("font_size", 14)
	warning.add_theme_color_override("font_color", Color(0.89, 0.71, 0.58))
	add_child(warning)

	bounds_overlay = ColorRect.new()
	bounds_overlay.color = Color(0.37, 0.83, 0.64, 0.13)
	bounds_overlay.position = Vector2(110, 380)
	bounds_overlay.size = Vector2(1080, 158)
	bounds_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bounds_overlay.visible = false
	add_child(bounds_overlay)
	bounds_label = Label.new()
	bounds_label.position = Vector2(28, 665)
	bounds_label.size = Vector2(1050, 28)
	bounds_label.text = "G — показать / скрыть реальную зону боя · 38/45 LIVE · #39 НЕ ВЫПУЩЕНА"
	bounds_label.add_theme_font_size_override("font_size", 15)
	bounds_label.add_theme_color_override("font_color", Color(0.78, 0.75, 0.69))
	add_child(bounds_label)

	print("D263_COURT_ARENA_PREVIEW_PASS: 1280x720 empty architectural tribunal QA plate, original D261 selected card image exact loader, 38 cards LIVE")


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_G:
		if bounds_overlay != null:
			bounds_overlay.visible = not bounds_overlay.visible


func _fail(message: String) -> void:
	push_error("D263_COURT_ARENA_PREVIEW_FAIL: " + message)
	var label := Label.new()
	label.text = message
	label.position = Vector2(50, 300)
	label.size = Vector2(1160, 210)
	label.add_theme_font_size_override("font_size", 21)
	add_child(label)
