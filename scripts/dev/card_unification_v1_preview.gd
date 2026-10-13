extends Control

# Self-contained local F6 check for the exact 13 optional D130 candidate
# textures. It is deliberately not connected to RunState or runtime screens.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ART := preload("res://scripts/ui/card_unification_v1.gd")

const ROWS := [
	[
		{"key": "bone_patrol", "title": "КОСТЯНОЙ ПАТРУЛЬ", "group": "run"},
		{"key": "graveyard_ambush", "title": "ЗАСАДА НА КЛАДБИЩЕ", "group": "run"},
		{"key": "gallows_volley", "title": "ЗАЛП ВИСЕЛИЦЫ", "group": "run"},
		{"key": "whispering_well", "title": "ШЕПЧУЩИЙ КОЛОДЕЦ", "group": "run"}
	],
	[
		{"key": "curse_forge", "title": "ПРОКЛЯТАЯ КУЗНЯ", "group": "event"},
		{"key": "black_altar", "title": "ЧЁРНЫЙ АЛТАРЬ", "group": "event"},
		{"key": "chained_prisoner", "title": "СКОВАННЫЙ ПЛЕННИК", "group": "event"},
		{"key": "rattling_bridge", "title": "ГРЕМЯЩИЙ МОСТ", "group": "event"}
	],
	[
		{"key": "knight_iron_oath", "title": "ЖЕЛЕЗНАЯ КЛЯТВА", "group": "upgrade"},
		{"key": "ranger_arrowstorm", "title": "ШТОРМ СТРЕЛ", "group": "upgrade"},
		{"key": "mage_glass_heart", "title": "СТЕКЛЯННОЕ СЕРДЦЕ", "group": "upgrade"},
		{"key": "gold_windfall", "title": "ЗОЛОТОЙ КУШ", "group": "reward"},
		{"key": "relic_wager", "title": "СТАВКА НА РЕЛИКВИЮ", "group": "reward"}
	]
]

func _ready() -> void:
	var backing := ColorRect.new()
	backing.color = Color(0.035, 0.025, 0.029, 1.0)
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backing)
	backing.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_add_label(self, "MISDEAL  /  ПРОСМОТР АРТОВ D130", Vector2(38, 12), Vector2(1200, 37), 27, UI.PARCHMENT_WARM)

	var missing := 0
	for row_index in range(ROWS.size()):
		var entries: Array = ROWS[row_index]
		var width_per := 268.0 if row_index < 2 else 218.0
		var gap := 17.0 if row_index < 2 else 15.0
		var total := float(entries.size()) * width_per + float(entries.size() - 1) * gap
		var start := (1280.0 - total) * 0.5
		var top := 60.0 + float(row_index) * 208.0
		for i in range(entries.size()):
			var entry: Dictionary = entries[i]
			if not _make_card(entry, Vector2(start + float(i) * (width_per + gap), top), Vector2(width_per, 190)):
				missing += 1

	var msg := "ВСЕ 13 ФАЙЛОВ НАЙДЕНЫ  ·  ПРОВЕРЬ КАЧЕСТВО В GODOT" if missing == 0 else ("НЕТ ФАЙЛОВ: %d/13  ·  РАСПАКУЙ ZIP В КОРЕНЬ ПРОЕКТА" % missing)
	_add_label(self, msg, Vector2(35, 692), Vector2(1210, 23), 14, UI.PARCHMENT_WARM)


func _make_card(data: Dictionary, pos: Vector2, dimensions: Vector2) -> bool:
	var panel := Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)
	panel.position = pos
	panel.size = dimensions
	UI.apply_v2_material_plate(panel)

	var group := String(data["group"])
	var id := String(data["key"])
	var image: Texture2D
	match group:
		"run":
			image = ART.get_run_texture(id)
		"upgrade":
			image = ART.get_upgrade_texture(id)
		"reward":
			image = ART.get_reward_texture(id)
		"event":
			var path: String = ART.get_event_art_path(id, "")
			if not path.is_empty():
				var loaded := Image.new()
				if loaded.load_webp_from_buffer(FileAccess.get_file_as_bytes(path)) == OK:
					image = ImageTexture.create_from_image(loaded)

	if image != null:
		var rect := TextureRect.new()
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(rect)
		rect.position = Vector2(9, 8)
		rect.size = Vector2(dimensions.x - 18, 147)
		rect.texture = image
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	else:
		_add_label(panel, "НЕТ НОВОГО АРТА", Vector2(8, 8), Vector2(dimensions.x - 16, 147), 14, UI.TEXT_SECONDARY)

	_add_label(panel, String(data["title"]), Vector2(8, 158), Vector2(dimensions.x - 16, 25), 13 if dimensions.x >= 260 else 11, UI.PARCHMENT_WARM)
	return image != null


func _add_label(parent: Control, value: String, pos: Vector2, dimensions: Vector2, size: int, color: Color) -> void:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	label.position = pos
	label.size = dimensions
	label.text = value
