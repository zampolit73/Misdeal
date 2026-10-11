extends Control

# Isolated design review: every sample uses the same methods production uses.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const TOOLTIP_BUTTON := preload("res://scripts/ui/misdeal_tooltip_button.gd")

var selection_buttons: Array[Button] = []
var status_label: Label


func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = UI.VOID
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var padding := MarginContainer.new()
	add_child(padding)
	padding.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		padding.add_theme_constant_override("margin_%s" % side, UI.SPACE_8)
	for side in ["top", "bottom"]:
		padding.add_theme_constant_override("margin_%s" % side, UI.SPACE_6)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", UI.SPACE_3)
	padding.add_child(root)
	root.add_child(_text("MISDEAL  /  COMPONENTS 2.0", "title", UI.GOLD))
	root.add_child(_text("Живые состояния: наведите на кнопку, выберите приказ, проверьте отключённое действие и подсказку.", "meta", UI.TEXT_SECONDARY))
	root.add_child(_text("ОСНОВНЫЕ КОМПОНЕНТЫ", "section", UI.TEXT))

	var first := HBoxContainer.new()
	first.add_theme_constant_override("separation", UI.SPACE_4)
	root.add_child(first)
	var actions := _group(first, "ACTIONS / STATES")
	var row := _row(actions)
	_action(row, "ПРИНЯТЬ", UI.EMBER, true, "Выбран рискованный путь")
	_action(row, "ОТКАЗАТЬСЯ", UI.STEEL, false, "Отказ от ставки")
	var state_row := _row(actions)
	_action(state_row, "ОТКЛЮЧЕНО", UI.BRONZE, false, "", true)
	_action(state_row, "ОСМОТР", UI.GOLD, false, "Осмотр карты")
	actions.add_child(_text("Normal / Hover / Pressed / Disabled", "caption", UI.TEXT_SECONDARY))

	var cards := _group(first, "CARD SURFACES")
	var card_row := _row(cards)
	_card(card_row, "СКЛЕП", "Карта события", UI.BRONZE, false)
	_card(card_row, "СТАВКА", "Выбранная карта", UI.GOLD, true)
	cards.add_child(_text("Art & gameplay text remain independent", "caption", UI.TEXT_SECONDARY))

	var hints := _group(first, "TOOLTIPS / CHIPS")
	var hover_button := TOOLTIP_BUTTON.new() as Button
	hover_button.text = "НАВЕДИ НА МЕНЯ"
	hover_button.tooltip_text = "Показывает нативную подсказку с оформлением Misdeal."
	hover_button.custom_minimum_size = Vector2(235, 44)
	hints.add_child(hover_button)
	UI.apply_action_button(hover_button, UI.STEEL, false)
	UI.apply_button_minimum(hover_button)
	var tag := PanelContainer.new()
	UI.apply_chip(tag, UI.GOLD)
	hints.add_child(tag)
	var tag_text := _text("СТАТУС: ГОТОВО", "caption", UI.GOLD)
	tag_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag.add_child(tag_text)
	hints.add_child(_text("Нативная подсказка появится при Hover", "caption", UI.TEXT_SECONDARY))

	root.add_child(_text("БОЙ / ВЫБОР / ИНФОРМАЦИЯ", "section", UI.TEXT))
	var second := HBoxContainer.new()
	second.add_theme_constant_override("separation", UI.SPACE_4)
	root.add_child(second)
	var battle := _group(second, "BATTLE COMPACT")
	var battle_hud := Panel.new()
	battle_hud.custom_minimum_size = Vector2(345, 82)
	battle.add_child(battle_hud)
	UI.apply_battle_panel(battle_hud, UI.BRONZE, 0.74)
	var battle_label := _text("ТАКТИЧЕСКИЙ ПРИКАЗ", "meta", UI.GOLD)
	battle_label.position = Vector2(12, 9)
	battle_hud.add_child(battle_label)
	var battle_button := Button.new()
	battle_button.text = "БОЙ"
	battle_button.position = Vector2(12, 39)
	battle_button.size = Vector2(150, 33)
	battle_hud.add_child(battle_button)
	UI.apply_battle_button(battle_button, UI.EMBER, true)
	battle_button.pressed.connect(_set_status.bind("Бой — только демонстрация оформления"))
	battle.add_child(_text("Та же геометрия, что в действующем HUD", "caption", UI.TEXT_SECONDARY))

	var choice := _group(second, "SELECTED / TACTICS")
	var options := _row(choice)
	for label in ["НАТИСК", "ОХОТА", "СТРОЙ"]:
		var button := Button.new()
		button.text = label
		button.custom_minimum_size = Vector2(108, 40)
		options.add_child(button)
		selection_buttons.append(button)
		button.pressed.connect(_set_selected.bind(button))
	_set_selected(selection_buttons[0])
	choice.add_child(_text("Только визуальное состояние, не новая механика", "caption", UI.TEXT_SECONDARY))

	var help := _group(second, "HELP / INFO")
	var tooltip := UI.make_tooltip("Неповиновение: цена решения должна быть понятна до подтверждения.", UI.STEEL)
	tooltip.custom_minimum_size.x = 332
	help.add_child(tooltip)
	help.add_child(_text("Контрастный текст без лишней орнаментики", "caption", UI.TEXT_SECONDARY))

	status_label = _text("Система готова. Нажмите на пример, чтобы проверить состояние.", "meta", UI.TEXT_SECONDARY)
	root.add_child(status_label)
	root.add_child(_text("Эта сцена не подключена к игровому меню; арт арен, карты и боевые правила не менялись.", "caption", UI.TEXT_MUTED))


func _text(value: String, role: String, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	UI.apply_text_role(label, role, color)
	return label


func _group(parent: HBoxContainer, title: String) -> VBoxContainer:
	var box := PanelContainer.new()
	box.custom_minimum_size = Vector2(380, 202)
	parent.add_child(box)
	UI.apply_panel(box, UI.BRONZE, false)
	var margin := MarginContainer.new()
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_%s" % side, UI.SPACE_4)
	for side in ["top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, UI.SPACE_3)
	box.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", UI.SPACE_3)
	margin.add_child(column)
	column.add_child(_text(title, "meta", UI.GOLD))
	return column


func _row(parent: VBoxContainer) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UI.SPACE_2)
	parent.add_child(row)
	return row


func _action(parent: HBoxContainer, title: String, accent: Color, primary: bool, message: String, disabled: bool = false) -> void:
	var button := Button.new()
	button.text = title
	button.custom_minimum_size.x = 165
	parent.add_child(button)
	UI.apply_action_button(button, accent, primary)
	UI.apply_button_minimum(button, primary)
	button.disabled = disabled
	if not disabled:
		button.pressed.connect(_set_status.bind(message))


func _card(parent: HBoxContainer, name: String, subtitle: String, accent: Color, selected: bool) -> void:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(166, 112)
	UI.apply_card_surface(panel, accent, selected)
	parent.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", UI.SPACE_2)
	panel.add_child(column)
	column.add_child(_text(name, "meta", UI.GOLD))
	column.add_child(_text(subtitle, "caption", UI.TEXT_SECONDARY))


func _set_selected(selected_button: Button) -> void:
	for button in selection_buttons:
		UI.apply_selected_button(button, button == selected_button, UI.GOLD)
	if status_label != null:
		status_label.text = "Приказ выбран: %s (демо)" % selected_button.text


func _set_status(message: String) -> void:
	if status_label != null:
		status_label.text = message
