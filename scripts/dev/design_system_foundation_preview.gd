extends Control

# Optional design review scene; never loaded by the real game flow.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")


func _ready() -> void:
	var background := ColorRect.new()
	background.color = UI.VOID
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", UI.SPACE_8)
	margin.add_theme_constant_override("margin_right", UI.SPACE_8)
	margin.add_theme_constant_override("margin_top", UI.SPACE_6)
	margin.add_theme_constant_override("margin_bottom", UI.SPACE_6)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", UI.SPACE_4)
	margin.add_child(column)

	column.add_child(_text("MISDEAL  /  DESIGN SYSTEM 1.0", "title", UI.GOLD))
	column.add_child(_text("FOUNDATION  •  отдельная сцена для проверки токенов; не часть игрового меню", "meta", UI.TEXT_SECONDARY))
	column.add_child(_text("ЦВЕТ И СЕМАНТИКА", "section", UI.TEXT))
	var swatches := HBoxContainer.new()
	swatches.add_theme_constant_override("separation", UI.SPACE_2)
	column.add_child(swatches)
	_add_swatch(swatches, "Void", UI.VOID, true)
	_add_swatch(swatches, "Gold", UI.GOLD)
	_add_swatch(swatches, "Bronze", UI.BRONZE)
	_add_swatch(swatches, "Ember", UI.EMBER)
	_add_swatch(swatches, "Steel", UI.STEEL)
	_add_swatch(swatches, "Knight", UI.KNIGHT)
	_add_swatch(swatches, "Ranger", UI.RANGER)
	_add_swatch(swatches, "Mage", UI.MAGE)
	_add_swatch(swatches, "Text", UI.TEXT)

	column.add_child(_text("ЭТАЛОНЫ КОМПОНЕНТОВ", "section", UI.TEXT))
	var examples := HBoxContainer.new()
	examples.add_theme_constant_override("separation", UI.SPACE_6)
	column.add_child(examples)

	var panel := Panel.new()
	panel.custom_minimum_size = Vector2(565, 174)
	examples.add_child(panel)
	UI.apply_panel(panel, UI.BRONZE)
	var inner := VBoxContainer.new()
	inner.position = Vector2(UI.SPACE_6, UI.SPACE_4)
	inner.custom_minimum_size = Vector2(510, 146)
	inner.add_theme_constant_override("separation", UI.SPACE_3)
	panel.add_child(inner)
	inner.add_child(_text("ПОСЛЕДНИЙ ЗВОН", "section", UI.GOLD))
	inner.add_child(_text("Один источник цветов, типографики и интервалов.", "body", UI.TEXT_SECONDARY))
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", UI.SPACE_3)
	inner.add_child(actions)
	_add_button(actions, "ПРИНЯТЬ", UI.EMBER, true)
	_add_button(actions, "ОТКАЗАТЬСЯ", UI.STEEL, false)

	var secondary := Panel.new()
	secondary.custom_minimum_size = Vector2(560, 174)
	examples.add_child(secondary)
	UI.apply_panel(secondary, UI.STEEL)
	var other := VBoxContainer.new()
	other.position = Vector2(UI.SPACE_6, UI.SPACE_4)
	other.custom_minimum_size = Vector2(510, 146)
	other.add_theme_constant_override("separation", UI.SPACE_3)
	secondary.add_child(other)
	other.add_child(_text("ТАКТИЧЕСКИЙ ПРИКАЗ", "section", UI.GOLD))
	other.add_child(_text("НАТИСК — приоритет ближайшей цели.", "body", UI.TEXT_SECONDARY))
	var tactical := HBoxContainer.new()
	tactical.add_theme_constant_override("separation", UI.SPACE_3)
	other.add_child(tactical)
	_add_button(tactical, "НАТИСК", UI.BRONZE, false)
	_add_button(tactical, "ОХОТА", UI.BRONZE, false)
	_add_button(tactical, "СТРОЙ", UI.BRONZE, false)

	column.add_child(_text("ТИПОГРАФИКА  /  ОСНОВНЫЕ РОЛИ", "section", UI.TEXT))
	var sizes := HBoxContainer.new()
	sizes.add_theme_constant_override("separation", UI.SPACE_8)
	column.add_child(sizes)
	sizes.add_child(_text("Заголовок 28", "title", UI.GOLD))
	sizes.add_child(_text("Секция 20", "section", UI.TEXT))
	sizes.add_child(_text("Основной текст 16", "body", UI.TEXT))
	sizes.add_child(_text("Подпись 12", "caption", UI.TEXT_SECONDARY))
	column.add_child(_text("Шаг отступов: 4 / 8 / 12 / 16 / 24 / 32px. Игровой базис: 1280×720. Без декоративной сетки поверх арены.", "meta", UI.TEXT_SECONDARY))


func _text(value: String, role: String, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	UI.apply_text_role(label, role, color)
	return label


func _add_swatch(parent: HBoxContainer, label: String, color: Color, dark: bool = false) -> void:
	var wrapper := VBoxContainer.new()
	wrapper.custom_minimum_size = Vector2(122, 80)
	wrapper.add_theme_constant_override("separation", UI.SPACE_2)
	parent.add_child(wrapper)
	var sample := ColorRect.new()
	sample.custom_minimum_size = Vector2(122, 52)
	sample.color = color
	wrapper.add_child(sample)
	var title := _text(label, "caption", UI.TEXT_SECONDARY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wrapper.add_child(title)
	if dark:
		sample.color = UI.VOID.lightened(0.07)


func _add_button(parent: HBoxContainer, label: String, accent: Color, prominent: bool) -> void:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size.x = 135
	parent.add_child(button)
	UI.apply_action_button(button, accent, prominent)
	UI.apply_button_minimum(button, prominent)
	button.focus_mode = Control.FOCUS_NONE
