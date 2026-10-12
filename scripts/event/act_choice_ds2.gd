extends RefCounted

# DS2 presentation for the ActChoice events other than Gravedigger Shop.
# It only reads already-configured Button text/state/art; events keep their
# original purchase, rescue, leave and progression handlers.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

static func apply(scene: Control) -> void:
	var panel := scene.get_node("Panel") as Panel
	var choices := scene.get_node("Panel/Choices") as HBoxContainer
	var buttons: Array[Button] = [
		scene.get_node("Panel/Choices/ChoiceA") as Button,
		scene.get_node("Panel/Choices/ChoiceB") as Button,
		scene.get_node("Panel/Choices/ChoiceC") as Button
	]
	# Keep existing authored event background artwork visible outside the
	# physical UI elements; never replace it with the Fate Spread plate.
	var shade := ColorRect.new()
	shade.name = "DS2EventShade"
	shade.color = Color(0.024, 0.012, 0.015, 0.58)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene.move_child(shade, panel.get_index())

	for path in [
		"FeatureHeader", "Panel/Title", "Panel/Type",
		"Panel/Description", "Panel/WizardLine",
		"Panel/EventArtFrame", "Panel/EventHeroArt",
		"Panel/GoldChip", "Panel/StateChip"
	]:
		(scene.get_node(path) as CanvasItem).visible = false
	panel.position = Vector2.ZERO
	panel.size = Vector2(1280, 720)
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())

	var header := _plate(panel, "DS2EventHeader", Vector2(176, 22), Vector2(928, 146), true)
	var kind: Label = scene.get_node("Panel/Type") as Label
	var title: Label = scene.get_node("Panel/Title") as Label
	var description: Label = scene.get_node("Panel/Description") as Label
	var wizard: Label = scene.get_node("Panel/WizardLine") as Label
	_text(header, "MISDEAL  /  %s" % kind.text, Vector2(22, 7), Vector2(884, 23), 12, UI.AGED_BRONZE)
	var title_size := 26 if title.text.length() > 27 else 29
	_text(header, title.text, Vector2(20, 30), Vector2(888, 43), title_size, UI.PARCHMENT_WARM)
	var quote := _text(header, wizard.text, Vector2(18, 74), Vector2(892, 34), 13, UI.TEXT)
	quote.tooltip_text = "%s\n%s" % [description.text, wizard.text]

	# Reuse real live state labels so changes on _finish() remain visible.
	var gold := scene.get_node("Panel/Gold") as Label
	var artifacts := scene.get_node("Panel/Artifacts") as Label
	gold.visible = true
	artifacts.visible = true
	panel.move_child(gold, panel.get_child_count() - 1)
	panel.move_child(artifacts, panel.get_child_count() - 1)
	gold.position = Vector2(196, 130)
	gold.size = Vector2(205, 26)
	artifacts.position = Vector2(403, 130)
	artifacts.size = Vector2(680, 26)
	gold.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	artifacts.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	gold.add_theme_font_size_override("font_size", 13)
	artifacts.add_theme_font_size_override("font_size", 11)
	gold.add_theme_color_override("font_color", UI.PARCHMENT_WARM)
	artifacts.add_theme_color_override("font_color", UI.PARCHMENT_WARM)

	var visible_count := 0
	for button in buttons:
		if button.visible:
			visible_count += 1
	var card_width := 292.0
	var row_width := float(visible_count) * card_width + float(maxi(0, visible_count - 1)) * 26.0
	# Container sizes MUST follow child minimums to avoid a right-shifted row.
	for button in buttons:
		button.custom_minimum_size = Vector2(card_width, 410)
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	choices.add_theme_constant_override("separation", 26)
	choices.alignment = BoxContainer.ALIGNMENT_BEGIN
	choices.position = Vector2((1280 - row_width) * 0.5, 179)
	choices.size = Vector2(row_width, 410)
	choices.set_deferred("position", Vector2((1280 - row_width) * 0.5, 179))
	choices.set_deferred("size", Vector2(row_width, 410))

	for i in range(buttons.size()):
		if buttons[i].visible:
			_style_card(buttons[i], i)

	var footer := _plate(panel, "DS2EventFooter", Vector2(176, 602), Vector2(928, 100))
	var footer_line := _text(footer, description.text, Vector2(15, 6), Vector2(611, 50), 13, UI.PARCHMENT_WARM, HORIZONTAL_ALIGNMENT_LEFT)
	footer_line.tooltip_text = description.text
	var leave := scene.get_node("Panel/LeaveButton") as Button
	var cont := scene.get_node("Panel/ContinueButton") as Button
	leave.position = Vector2(825, 627)
	leave.size = Vector2(257, 48)
	cont.position = leave.position
	cont.size = leave.size
	UI.apply_action_button(leave, UI.AGED_BRONZE, true)
	UI.apply_action_button(cont, UI.AGED_BRONZE, true)
	panel.move_child(leave, panel.get_child_count() - 1)
	panel.move_child(cont, panel.get_child_count() - 1)
	panel.move_child(scene.get_node("Panel/Result"), panel.get_child_count() - 1)


static func _style_card(button: Button, index: int) -> void:
	var full_text: String = button.text
	button.tooltip_text = full_text
	button.text = ""
	UI.apply_v2_reward_card(button)
	for name in ["ChoiceDivider", "ChoiceBadge"]:
		(button.get_node(name) as CanvasItem).visible = false
	var caption := "I" if index == 0 else ("II" if index == 1 else "III")
	_text(button, caption + "  /  ВЫБОР", Vector2(12, 10), Vector2(268, 24), 12, UI.PARCHMENT_WARM)
	var art_frame := _plate(button, "DS2EventArtFrame", Vector2(14, 41), Vector2(264, 181))
	var art := button.get_node("ChoiceArt") as TextureRect
	button.move_child(art_frame, art.get_index())
	art.position = Vector2(19, 46)
	art.size = Vector2(254, 171)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.modulate = Color.WHITE
	art_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var parchment := _plate(button, "DS2EventParchment", Vector2(14, 233), Vector2(264, 163), false, true)
	var lines := full_text.split("\n", false)
	var headline: String = lines[0].strip_edges() if not lines.is_empty() else "ВЫБОР"
	var remaining := ""
	for i in range(1, lines.size()):
		if not remaining.is_empty():
			remaining += "\n"
		remaining += lines[i].strip_edges()
	var headline_size := 13 if headline.length() > 34 else 15
	_text(parchment, headline, Vector2(10, 6), Vector2(244, 42), headline_size, Color(0.19, 0.09, 0.07))
	var rule := ColorRect.new()
	rule.color = Color(0.42, 0.24, 0.14, 0.75)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parchment.add_child(rule)
	rule.position = Vector2(23, 50)
	rule.size = Vector2(218, 1)
	var detail := _text(parchment, remaining, Vector2(12, 55), Vector2(240, 75), 12, Color(0.22, 0.15, 0.12))
	detail.tooltip_text = full_text
	var status: String = "ДОСТУПНО" if not button.disabled else "НЕДОСТУПНО"
	_text(parchment, status, Vector2(10, 134), Vector2(244, 22), 12,
		Color(0.38, 0.28, 0.15) if not button.disabled else Color(0.57, 0.16, 0.11))
	button.modulate = Color.WHITE if not button.disabled else Color(0.81, 0.79, 0.76, 1)


static func show_result(scene: Control) -> void:
	var footer := scene.get_node_or_null("Panel/DS2EventFooter") as Panel
	if footer != null:
		for child in footer.get_children():
			if child is Label:
				(child as Label).visible = false


static func _plate(parent: Control, node_name: String, pos: Vector2, dimensions: Vector2, prominent: bool = false, parchment: bool = false) -> Panel:
	var plate := Panel.new()
	plate.name = node_name
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(plate)
	plate.position = pos
	plate.size = dimensions
	if parchment:
		UI.apply_v2_parchment_plate(plate)
	else:
		UI.apply_v2_material_plate(plate, prominent)
	return plate


static func _text(parent: Control, value: String, pos: Vector2, dimensions: Vector2, font_size: int, ink: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", ink)
	parent.add_child(label)
	label.position = pos
	label.size = dimensions
	label.text = value
	return label
