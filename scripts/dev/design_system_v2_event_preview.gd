extends Control

# DS2 isolated event review. Never touches RunState or routes away.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const EVENT_ART := preload("res://scripts/ui/approved_event_choice_art.gd")
const CARD_ART := preload("res://scripts/ui/card_art_catalog.gd")
const WEBP_VIEW := preload("res://scripts/ui/runtime_webp_texture.gd")

const CHOICES := [
	{"name": "ВЫТАЩИТЬ ЕГО КРОВЬЮ", "effect": "−12 максимального HP", "detail": "Спасти мага из прежней жизни", "art": 0},
	{"name": "БРОСИТЬ 25 ЗОЛОТА", "effect": "−25 золота", "detail": "Выкупить мага у колодца", "art": 1},
	{"name": "ОТОЙТИ", "effect": "Без платы", "detail": "Маг будет потерян", "art": 2}
]

var status_label: Label
var cards: Array[Button] = []
var selected_index := -1


func _ready() -> void:
	var background := WEBP_VIEW.new() as TextureRect
	background.set("webp_path", "res://assets/pixel/table/approved_variant_c/table_exact.webp")
	background.set("expected_size", Vector2i(1280, 720))
	background.set("use_nearest_filter", false)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = Color(0.025, 0.010, 0.015, 0.65)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_header()
	_build_choices()
	_build_footer()


func _build_header() -> void:
	var header := Panel.new()
	add_child(header)
	_place(header, Vector2(168, 24), Vector2(944, 156))
	UI.apply_v2_material_plate(header, true)
	var kicker := _label("MISDEAL  /  СОБЫТИЕ  /  DESIGN SYSTEM 2.0", 12, UI.AGED_BRONZE)
	header.add_child(kicker)
	_place(kicker, Vector2(20, 12), Vector2(904, 20))
	kicker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var title := _label("ШЕПЧУЩИЙ КОЛОДЕЦ", 30, UI.PARCHMENT_WARM)
	header.add_child(title)
	_place(title, Vector2(20, 38), Vector2(904, 43))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var description := _label("Из чёрной воды зовёт маг. Какую цену ты заплатишь за его спасение?", 16, UI.TEXT)
	header.add_child(description)
	_place(description, Vector2(30, 94), Vector2(884, 45))
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _build_choices() -> void:
	for i in range(CHOICES.size()):
		var data: Dictionary = CHOICES[i]
		var button := Button.new()
		button.text = ""
		button.focus_mode = Control.FOCUS_ALL
		add_child(button)
		_place(button, Vector2(173 + i * 318, 196), Vector2(292, 394))
		UI.apply_v2_reward_card(button)
		button.pressed.connect(_select.bind(i))
		cards.append(button)

		var roman := _label(["I / КРОВЬ", "II / МОНЕТА", "III / ОТКАЗ"][i], 13, UI.PARCHMENT_WARM)
		button.add_child(roman)
		_place(roman, Vector2(12, 12), Vector2(268, 22))
		roman.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var frame := Panel.new()
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(frame)
		_place(frame, Vector2(14, 43), Vector2(264, 180))
		UI.apply_v2_material_plate(frame)
		var art := TextureRect.new()
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		art.texture = EVENT_ART.get_whispering_well_texture(int(data["art"]))
		if art.texture == null:
			art.texture = CARD_ART.get_run_card_texture("whispering_well")
		frame.add_child(art)
		_place(art, Vector2(6, 6), Vector2(252, 168))

		var paper := Panel.new()
		paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
		paper.clip_contents = true
		button.add_child(paper)
		_place(paper, Vector2(14, 233), Vector2(264, 147))
		UI.apply_v2_parchment_plate(paper)
		var title := _label(String(data["name"]), 16, Color(0.18, 0.09, 0.07))
		paper.add_child(title)
		_place(title, Vector2(9, 8), Vector2(246, 43))
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var line := ColorRect.new()
		line.color = Color(0.40, 0.23, 0.13, 0.74)
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		paper.add_child(line)
		_place(line, Vector2(24, 54), Vector2(216, 1))
		var effect := _label(String(data["effect"]), 15, Color(0.43, 0.18, 0.10))
		paper.add_child(effect)
		_place(effect, Vector2(10, 62), Vector2(244, 27))
		effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var detail := _label(String(data["detail"]), 13, Color(0.22, 0.16, 0.13))
		paper.add_child(detail)
		_place(detail, Vector2(13, 94), Vector2(238, 45))
		detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func _build_footer() -> void:
	var panel := Panel.new()
	add_child(panel)
	_place(panel, Vector2(174, 608), Vector2(932, 87))
	UI.apply_v2_material_plate(panel)
	status_label = _label("Выберите один из трёх исходов, чтобы проверить выделение.", 16, UI.PARCHMENT_WARM)
	panel.add_child(status_label)
	_place(status_label, Vector2(24, 10), Vector2(884, 31))
	var note := _label("ТОЛЬКО F6-ПРЕДПРОСМОТР   •   В ИГРЕ СОБЫТИЕ НЕ ИЗМЕНЕНО", 12, UI.TEXT_SECONDARY)
	panel.add_child(note)
	_place(note, Vector2(24, 42), Vector2(884, 20))


func _select(index: int) -> void:
	selected_index = index
	for i in range(cards.size()):
		UI.apply_v2_reward_card(cards[i], i == selected_index)
	status_label.text = "Проверка: %s. Игровое решение не принято." % String(CHOICES[index]["name"])


func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.apply_screen_copy(label, color, font_size >= 18)
	label.add_theme_font_size_override("font_size", font_size)
	label.clip_text = true
	return label


func _place(control: Control, position_value: Vector2, size_value: Vector2) -> void:
	control.position = position_value
	control.size = size_value
