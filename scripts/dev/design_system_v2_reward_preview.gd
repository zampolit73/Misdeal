extends Control

# Isolated Design System 2.0 reward study.
# No RunState, SceneRouter, reward grants or production scene dependencies.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const CARD_ART := preload("res://scripts/ui/card_art_catalog.gd")
const WEBP_VIEW := preload("res://scripts/ui/runtime_webp_texture.gd")

const REWARD_SAMPLES := [
	{
		"art": "gold_windfall",
		"eyebrow": "I  /  ДОБЫЧА",
		"title": "ЗОЛОТОЙ КУШ",
		"effect": "+60 золота",
		"description": "Самый безопасный способ забрать выигрыш."
	},
	{
		"art": "relic_wager",
		"eyebrow": "II  /  РЕЛИКВИЯ",
		"title": "ДАР ИЗ СКЛЕПА",
		"effect": "Одна реликвия",
		"description": "Сила с ценой, о которой Волшебник умолчал."
	},
	{
		"art": "bonus_upgrade",
		"eyebrow": "III  /  СТАВКА",
		"title": "УДВОИТЬ СТАВКУ",
		"effect": "+1 выбор развития",
		"description": "Ещё один шанс переписать судьбу героя."
	}
]

var preview_cards: Array[Button] = []
var status_label: Label
var inspect_button: Button
var selected_index := -1


func _ready() -> void:
	_build_backdrop()
	_build_header()
	_build_cards()
	_build_footer()


func _build_backdrop() -> void:
	# Exactly the already-approved Variant C tabletop art, reused as a
	# backdrop. No changes to its file, Fate Spread rings or live table.
	var table_backdrop := WEBP_VIEW.new() as TextureRect
	table_backdrop.set("webp_path", "res://assets/pixel/table/approved_variant_c/table_exact.webp")
	table_backdrop.set("expected_size", Vector2i(1280, 720))
	table_backdrop.set("use_nearest_filter", false)
	table_backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	table_backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(table_backdrop)
	table_backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var shade := ColorRect.new()
	shade.color = Color(0.030, 0.013, 0.014, 0.53)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _build_header() -> void:
	var plate := PanelContainer.new()
	add_child(plate)
	_place(plate, Vector2(167.0, 22.0), Vector2(946.0, 144.0))
	UI.apply_v2_material_plate(plate, true)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	plate.add_child(column)

	var overline := _text("MISDEAL   /   ДИЗАЙН-СИСТЕМА 2.0   /   ОБРАЗЕЦ ЭКРАНА", 12, UI.AGED_BRONZE)
	overline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(overline)

	var title := _text("ВЫИГРЫШ СТАВКИ", 30, UI.PARCHMENT_WARM)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)

	var summary := _text("Вы пережили ставку. Волшебник предлагает ровно одну награду.", 16, UI.TEXT)
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(summary)


func _build_cards() -> void:
	var start_x := 175.0
	for index in range(REWARD_SAMPLES.size()):
		var data: Dictionary = REWARD_SAMPLES[index]
		var button := Button.new()
		button.text = ""
		button.focus_mode = Control.FOCUS_ALL
		add_child(button)
		_place(button, Vector2(start_x + float(index) * 318.0, 183.0), Vector2(292.0, 410.0))
		UI.apply_v2_reward_card(button, false)
		button.pressed.connect(_on_choice.bind(index))
		button.mouse_entered.connect(_on_hover.bind(index))
		preview_cards.append(button)
		_populate_card(button, data)


func _populate_card(button: Button, data: Dictionary) -> void:
	var eyebrow := _text(String(data["eyebrow"]), 13, UI.PARCHMENT_WARM)
	_place(eyebrow, Vector2(15.0, 11.0), Vector2(262.0, 25.0))
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.add_child(eyebrow)

	var art_border := Panel.new()
	art_border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(art_border, Vector2(14.0, 42.0), Vector2(264.0, 183.0))
	button.add_child(art_border)
	UI.apply_v2_material_plate(art_border, false)

	var art := TextureRect.new()
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.texture = CARD_ART.get_reward_texture(String(data["art"]))
	_place(art, Vector2(6.0, 6.0), Vector2(252.0, 171.0))
	art_border.add_child(art)

	var parchment := Panel.new()
	parchment.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(parchment, Vector2(14.0, 234.0), Vector2(264.0, 161.0))
	button.add_child(parchment)
	UI.apply_v2_parchment_plate(parchment)

	var headline := _text(String(data["title"]), 18, Color(0.18, 0.09, 0.07))
	_place(headline, Vector2(10.0, 12.0), Vector2(244.0, 28.0))
	headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parchment.add_child(headline)

	var rule := ColorRect.new()
	rule.color = Color(0.40, 0.23, 0.13, 0.74)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(rule, Vector2(24.0, 47.0), Vector2(216.0, 1.0))
	parchment.add_child(rule)

	var effect := _text(String(data["effect"]), 17, Color(0.43, 0.18, 0.10))
	_place(effect, Vector2(10.0, 57.0), Vector2(244.0, 27.0))
	effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parchment.add_child(effect)

	var description := _text(String(data["description"]), 14, Color(0.22, 0.16, 0.13))
	_place(description, Vector2(16.0, 92.0), Vector2(232.0, 54.0))
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parchment.add_child(description)


func _build_footer() -> void:
	var footer := PanelContainer.new()
	add_child(footer)
	_place(footer, Vector2(174.0, 608.0), Vector2(932.0, 87.0))
	UI.apply_v2_material_plate(footer, false)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	footer.add_child(row)

	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 5)
	row.add_child(details)

	status_label = _text("Выберите одну карту для проверки её состояния.", 15, UI.PARCHMENT_WARM)
	details.add_child(status_label)

	var footnote := _text("ТОЛЬКО F6-ПРЕДПРОСМОТР   •   БЕЗ НАГРАД И ИЗМЕНЕНИЙ ПРОХОЖДЕНИЯ", 11, UI.TEXT_SECONDARY)
	details.add_child(footnote)

	inspect_button = Button.new()
	inspect_button.text = "ПРОВЕРИТЬ ВЫБОР"
	inspect_button.custom_minimum_size = Vector2(200.0, 45.0)
	inspect_button.disabled = true
	row.add_child(inspect_button)
	UI.apply_action_button(inspect_button, UI.AGED_BRONZE, true)
	inspect_button.pressed.connect(_on_inspect)


func _on_hover(index: int) -> void:
	if selected_index >= 0:
		return
	status_label.text = "Предпросмотр: %s" % String(REWARD_SAMPLES[index]["title"])


func _on_choice(index: int) -> void:
	selected_index = index
	for i in range(preview_cards.size()):
		UI.apply_v2_reward_card(preview_cards[i], i == selected_index)
	status_label.text = "Отмечена карта: %s" % String(REWARD_SAMPLES[index]["title"])
	inspect_button.disabled = false


func _on_inspect() -> void:
	if selected_index < 0:
		return
	status_label.text = "Оформление проверено: %s. Награда не выдавалась." % String(REWARD_SAMPLES[selected_index]["title"])


func _text(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.apply_screen_copy(label, color, font_size >= 18)
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _place(target: Control, top_left: Vector2, dimensions: Vector2) -> void:
	target.position = top_left
	target.size = dimensions
