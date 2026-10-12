extends Control

# Isolated Design System 2.0 review for the real Whispering Well event.
# No RunState calls, event resolution, reward grants, or scene navigation.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const WEBP_VIEW := preload("res://scripts/ui/runtime_webp_texture.gd")
const CHOICE_ART := preload("res://scripts/ui/approved_event_choice_art.gd")

const OFFERS := [
	{
		"eyebrow": "I  /  КРОВЬ",
		"title": "ВЫТАЩИТЬ ЕГО КРОВЬЮ",
		"effect": "−12 макс. HP",
		"detail": "Маг присоединится к отряду."
	},
	{
		"eyebrow": "II  /  МОНЕТЫ",
		"title": "БРОСИТЬ 25 ЗОЛОТА",
		"effect": "−25 золота",
		"detail": "Выкупить мага у колодца."
	},
	{
		"eyebrow": "III  /  ОТСТУПЛЕНИЕ",
		"title": "ОТОЙТИ",
		"effect": "Маг будет потерян",
		"detail": "Оставить его по ту сторону воды."
	}
]

var cards: Array[Button] = []
var selected_index := -1
var preview_no_gold := false
var status_label: Label
var inspect_button: Button
var gold_toggle: Button


func _ready() -> void:
	_build_backdrop()
	_build_header()
	_build_description()
	_build_cards()
	_build_footer()


func _build_backdrop() -> void:
	# Reuse the approved production Well illustration, not generated mock art.
	var background := WEBP_VIEW.new() as TextureRect
	background.set("webp_path", "res://assets/pixel/event/v7/whispering_well.webp")
	background.set("expected_size", Vector2i(1280, 720))
	background.set("use_nearest_filter", false)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var shade := ColorRect.new()
	shade.color = Color(0.028, 0.012, 0.015, 0.65)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _build_header() -> void:
	var plate := _panel(Vector2(167.0, 22.0), Vector2(946.0, 153.0), true)
	var meta := _label("MISDEAL   /   ДИЗАЙН-СИСТЕМА 2.0   /   СОБЫТИЕ", 12, UI.AGED_BRONZE)
	_place(meta, Vector2(188.0, 36.0), Vector2(904.0, 23.0))
	meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var title := _label("ШЕПЧУЩИЙ КОЛОДЕЦ", 30, UI.PARCHMENT_WARM)
	_place(title, Vector2(198.0, 67.0), Vector2(884.0, 42.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var wizard := _label("«Ты слышишь его голос? В прошлый раз ты полез за ним.»", 16, UI.TEXT)
	wizard.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	wizard.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wizard.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(wizard, Vector2(211.0, 112.0), Vector2(858.0, 40.0))


func _build_description() -> void:
	var plate := _panel(Vector2(174.0, 185.0), Vector2(932.0, 58.0), false)
	var body := _label("Из чёрной воды зовёт молодой маг. Решите, какой ценой вернуть его в отряд.", 16, UI.TEXT)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(body, Vector2(195.0, 191.0), Vector2(890.0, 46.0))


func _build_cards() -> void:
	for index in range(OFFERS.size()):
		var data: Dictionary = OFFERS[index]
		var button := Button.new()
		button.text = ""
		button.focus_mode = Control.FOCUS_ALL
		add_child(button)
		_place(button, Vector2(174.0 + float(index) * 318.0, 256.0), Vector2(292.0, 340.0))
		UI.apply_v2_reward_card(button)
		button.pressed.connect(_on_select.bind(index))
		button.mouse_entered.connect(_on_hover.bind(index))
		cards.append(button)
		_build_card_contents(button, data, index)


func _build_card_contents(button: Button, data: Dictionary, index: int) -> void:
	var eyebrow := _label(String(data["eyebrow"]), 13, UI.PARCHMENT_WARM)
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.add_child(eyebrow)
	_place(eyebrow, Vector2(15.0, 8.0), Vector2(262.0, 25.0))

	var art_plate := Panel.new()
	art_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(art_plate)
	_place(art_plate, Vector2(14.0, 38.0), Vector2(264.0, 135.0))
	UI.apply_v2_material_plate(art_plate)

	var art := TextureRect.new()
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.texture = CHOICE_ART.get_whispering_well_texture(index)
	art_plate.add_child(art)
	_place(art, Vector2(6.0, 6.0), Vector2(252.0, 123.0))

	var parchment := Panel.new()
	parchment.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parchment.clip_contents = true
	button.add_child(parchment)
	_place(parchment, Vector2(14.0, 183.0), Vector2(264.0, 141.0))
	UI.apply_v2_parchment_plate(parchment)

	var title := _label(String(data["title"]), 16, Color(0.18, 0.09, 0.07))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.clip_text = true
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parchment.add_child(title)
	_place(title, Vector2(10.0, 9.0), Vector2(244.0, 36.0))

	var divider := ColorRect.new()
	divider.color = Color(0.40, 0.23, 0.13, 0.74)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parchment.add_child(divider)
	_place(divider, Vector2(24.0, 49.0), Vector2(216.0, 1.0))

	var effect := _label(String(data["effect"]), 15, Color(0.43, 0.18, 0.10))
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect.clip_text = true
	effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effect.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parchment.add_child(effect)
	_place(effect, Vector2(10.0, 54.0), Vector2(244.0, 28.0))

	var detail := _label(String(data["detail"]), 13, Color(0.22, 0.16, 0.13))
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.clip_text = true
	detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parchment.add_child(detail)
	_place(detail, Vector2(13.0, 88.0), Vector2(238.0, 46.0))

	button.tooltip_text = "%s\n%s\n%s" % [
		String(data["title"]), String(data["effect"]), String(data["detail"])
	]


func _build_footer() -> void:
	_panel(Vector2(174.0, 610.0), Vector2(932.0, 90.0), false)

	status_label = _label("Выберите один из трёх ответов. Награды не выдаются.", 14, UI.PARCHMENT_WARM)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_place(status_label, Vector2(196.0, 626.0), Vector2(456.0, 40.0))

	var caption := _label("F6-ПРЕДПРОСМОТР   •   БЕЗ ИЗМЕНЕНИЯ ПРОХОЖДЕНИЯ", 11, UI.TEXT_SECONDARY)
	_place(caption, Vector2(196.0, 675.0), Vector2(470.0, 16.0))

	gold_toggle = Button.new()
	gold_toggle.text = "СИМ. 0 ЗОЛОТА"
	add_child(gold_toggle)
	_place(gold_toggle, Vector2(683.0, 628.0), Vector2(177.0, 46.0))
	UI.apply_action_button(gold_toggle, UI.MOONLIT_STEEL, false)
	gold_toggle.pressed.connect(_toggle_gold)

	inspect_button = Button.new()
	inspect_button.text = "ПРОВЕРИТЬ ВЫБОР"
	inspect_button.disabled = true
	add_child(inspect_button)
	_place(inspect_button, Vector2(870.0, 628.0), Vector2(214.0, 46.0))
	UI.apply_action_button(inspect_button, UI.AGED_BRONZE, true)
	inspect_button.pressed.connect(_inspect)


func _on_hover(index: int) -> void:
	if selected_index < 0 and not cards[index].disabled:
		status_label.text = "Предпросмотр: %s" % String(OFFERS[index]["title"])


func _on_select(index: int) -> void:
	if cards[index].disabled:
		return
	selected_index = index
	for i in range(cards.size()):
		UI.apply_v2_reward_card(cards[i], i == selected_index)
	status_label.text = "Отмечен ответ: %s" % String(OFFERS[index]["title"])
	inspect_button.disabled = false


func _toggle_gold() -> void:
	preview_no_gold = not preview_no_gold
	cards[1].disabled = preview_no_gold
	cards[1].modulate = Color(0.66, 0.61, 0.57, 0.72) if preview_no_gold else Color.WHITE
	gold_toggle.text = "СИМ. 25 ЗОЛОТА" if preview_no_gold else "СИМ. 0 ЗОЛОТА"
	if preview_no_gold and selected_index == 1:
		selected_index = -1
		inspect_button.disabled = true
	for i in range(cards.size()):
		UI.apply_v2_reward_card(cards[i], i == selected_index)
	if preview_no_gold:
		status_label.text = "Недостаточно золота: второй вариант недоступен."
	else:
		status_label.text = "25 золота: второй вариант снова доступен."


func _inspect() -> void:
	if selected_index < 0:
		return
	status_label.text = "Проверено: %s. Прохождение не изменено." % String(OFFERS[selected_index]["title"])


func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.apply_screen_copy(label, color, font_size >= 16)
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _panel(top_left: Vector2, dimensions: Vector2, prominent: bool) -> Panel:
	var panel := Panel.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)
	_place(panel, top_left, dimensions)
	UI.apply_v2_material_plate(panel, prominent)
	return panel


func _place(target: Control, top_left: Vector2, dimensions: Vector2) -> void:
	target.position = top_left
	target.size = dimensions
