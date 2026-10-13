extends Control

# F6 gallery for the five final approved Wave 1 art assets (D135).
# This is visual-only; no RunState or gameplay interaction.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ART := preload("res://scripts/ui/card_unification_v1.gd")

const CARDS := [
	{"id": "gravedigger_shop", "label": "МАГАЗИН МОГИЛЬЩИКА", "group": "run"},
	{"id": "bone_swarm", "label": "КОСТЯНОЙ РОЙ", "group": "run"},
	{"id": "grave_crossfire", "label": "ПЕРЕКРЁСТНЫЙ ОГОНЬ", "group": "run"},
	{"id": "candle_seller", "label": "ПРОДАВЕЦ СВЕЧЕЙ", "group": "event"},
	{"id": "last_camp", "label": "ПОСЛЕДНИЙ ЛАГЕРЬ", "group": "event"},
]

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.035, 0.025, 0.029, 1.0)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_add_label(self, "MISDEAL  /  АРТЫ ПЕРВОЙ ВОЛНЫ — 5 НОВЫХ", Vector2(25, 12), Vector2(1230, 41), 27)
	var missing := 0
	for i in range(CARDS.size()):
		var data: Dictionary = CARDS[i]
		var top_row := i < 3
		var width := 378.0 if top_row else 570.0
		var height := 253.0 if top_row else 316.0
		var pos := Vector2(43.0 + float(i) * 408.0, 70.0) if top_row else Vector2(55.0 + float(i - 3) * 600.0, 337.0)
		if not _add_card(data, pos, Vector2(width, height)):
			missing += 1

	var status := "ВСЕ 5 АРТОВ НАЙДЕНЫ  ·  ПРОВЕРЬ ИХ В ИГРЕ" if missing == 0 else "НЕТ АРТОВ: %d/5  ·  ПРОВЕРЬ GIT PULL" % missing
	_add_label(self, status, Vector2(25, 667), Vector2(1230, 33), 16)


func _add_card(data: Dictionary, pos: Vector2, dimensions: Vector2) -> bool:
	var plate := Panel.new()
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(plate)
	plate.position = pos
	plate.size = dimensions
	UI.apply_v2_material_plate(plate)

	var art: Texture2D = null
	var id := String(data["id"])
	if data["group"] == "run":
		art = ART.get_run_texture(id)
	else:
		var path := ART.get_event_art_path(id, "")
		if not path.is_empty():
			var raw := Image.new()
			if raw.load_webp_from_buffer(FileAccess.get_file_as_bytes(path)) == OK:
				art = ImageTexture.create_from_image(raw)
	var image_height := dimensions.y - 46.0
	if art != null:
		var picture := TextureRect.new()
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		plate.add_child(picture)
		picture.position = Vector2(9, 8)
		picture.size = Vector2(dimensions.x - 18, image_height)
		picture.texture = art
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	else:
		_add_label(plate, "АРТ НЕ НАЙДЕН", Vector2(8, 8), Vector2(dimensions.x - 16, image_height), 15)

	_add_label(plate, String(data["label"]), Vector2(8, image_height + 14), Vector2(dimensions.x - 16, 26), 16)
	return art != null


func _add_label(owner: Control, caption: String, pos: Vector2, dimensions: Vector2, font_size: int) -> void:
	var label := Label.new()
	label.text = caption
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", UI.PARCHMENT_WARM)
	owner.add_child(label)
	label.position = pos
	label.size = dimensions
