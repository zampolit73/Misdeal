extends RefCounted

# Scoped production DS2 skin. The existing ActChoice Buttons keep their
# original RunState checks, purchase signals, and resolve/leave handlers.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const WEBP := preload("res://scripts/ui/runtime_webp_texture.gd")
const ART := preload("res://scripts/ui/card_art_catalog.gd")

const ROLES := [
	{"id": "knight", "label": "РЫЦАРЬ", "name": "МОГИЛЬНЫЙ УРОК", "art": "knight_executioner"},
	{"id": "ranger", "label": "СЛЕДОПЫТ", "name": "ОХОТНИЧЬЯ СХЕМА", "art": "ranger_arrowstorm"},
	{"id": "mage", "label": "МАГ", "name": "ЗАПРЕТНАЯ ЗАПИСКА", "art": "mage_glass_heart"}
]

static func apply(scene: Control) -> void:
	var panel := scene.get_node("Panel") as Panel
	var choices := scene.get_node("Panel/Choices") as HBoxContainer
	var buttons: Array[Button] = [
		scene.get_node("Panel/Choices/ChoiceA") as Button,
		scene.get_node("Panel/Choices/ChoiceB") as Button,
		scene.get_node("Panel/Choices/ChoiceC") as Button
	]
	var full_description := (scene.get_node("Panel/Description") as Label).text
	var wizard_text := (scene.get_node("Panel/WizardLine") as Label).text

	# Replace only this event's background; never modify the actual Fate Spread.
	for path in [
		"WizardBackdrop", "BackdropShade", "FeatureSceneArt", "EventDecor",
		"Visual", "Logo", "FeatureHeader", "Panel/Title", "Panel/Type",
		"Panel/Description", "Panel/WizardLine", "Panel/EventArtFrame",
		"Panel/EventHeroArt", "Panel/GoldChip", "Panel/StateChip",
		"Panel/Gold", "Panel/Artifacts"
	]:
		(scene.get_node(path) as CanvasItem).visible = false

	var background := WEBP.new() as TextureRect
	background.name = "ShopDS2Backdrop"
	background.set("webp_path", "res://assets/pixel/table/approved_variant_c/table_exact.webp")
	background.set("expected_size", Vector2i(1280, 720))
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene.add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene.move_child(background, panel.get_index())

	var shade := ColorRect.new()
	shade.name = "ShopDS2Shade"
	shade.color = Color(0.025, 0.012, 0.016, 0.59)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene.add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene.move_child(shade, panel.get_index())

	panel.position = Vector2.ZERO
	panel.size = Vector2(1280.0, 720.0)
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())

	var header := _plate(panel, "ShopDS2Header", Vector2(176, 22), Vector2(928, 146), true)
	_label(header, "MISDEAL  /  ТОРГОВЕЦ", Vector2(20, 8), Vector2(888, 23), 12, UI.AGED_BRONZE)
	_label(header, "МАГАЗИН МОГИЛЬЩИКА", Vector2(20, 32), Vector2(888, 41), 29, UI.PARCHMENT_WARM)
	var dialogue := _label(header, wizard_text, Vector2(22, 77), Vector2(884, 36), 14, UI.TEXT)
	dialogue.tooltip_text = "%s\n%s" % [full_description, wizard_text]
	var money := _label(header, "", Vector2(22, 113), Vector2(884, 24), 15, UI.PARCHMENT_WARM)
	money.name = "CurrentGold"

	# The HBox minimum depends on child widths: resize children BEFORE the row.
	# This avoids the older Whispering Well's 50px rightward row drift.
	for button in buttons:
		button.custom_minimum_size = Vector2(292, 410)
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		# Keep the exact live offer wording accessible even when card copy is split.
		button.tooltip_text = button.text
		button.text = ""
		button.add_theme_font_size_override("font_size", 13)
	choices.add_theme_constant_override("separation", 26)
	choices.alignment = BoxContainer.ALIGNMENT_BEGIN
	choices.position = Vector2(176, 179)
	choices.size = Vector2(928, 410)
	choices.set_deferred("position", Vector2(176, 179))
	choices.set_deferred("size", Vector2(928, 410))

	var price: int = RunState.get_gravedigger_shop_price()
	for i in range(buttons.size()):
		_style_card(buttons[i], ROLES[i], i, price)

	var footer := _plate(panel, "ShopDS2Footer", Vector2(176, 602), Vector2(928, 100))
	var info := _label(footer, "Выберите улучшение. Цена списывается только при покупке.", Vector2(16, 7), Vector2(610, 28), 13, UI.PARCHMENT_WARM, HORIZONTAL_ALIGNMENT_LEFT)
	info.name = "Status"
	var note := _label(footer, "ЦЕНА УЧИТЫВАЕТ ИСТОРИЮ КОШЕЛЯ  •  ОДНА ПОКУПКА ЗА ВИЗИТ", Vector2(16, 38), Vector2(610, 19), 11, UI.TEXT_SECONDARY, HORIZONTAL_ALIGNMENT_LEFT)
	note.name = "Hint"

	var leave := scene.get_node("Panel/LeaveButton") as Button
	leave.position = Vector2(826, 626)
	leave.size = Vector2(256, 49)
	leave.text = "НИЧЕГО НЕ ПОКУПАТЬ"
	UI.apply_action_button(leave, UI.AGED_BRONZE, true)
	var cont := scene.get_node("Panel/ContinueButton") as Button
	cont.position = leave.position
	cont.size = leave.size
	UI.apply_action_button(cont, UI.AGED_BRONZE, true)
	# These gameplay nodes must draw over the new footer plate on resolve.
	panel.move_child(leave, panel.get_child_count() - 1)
	panel.move_child(cont, panel.get_child_count() - 1)
	panel.move_child(scene.get_node("Panel/Result"), panel.get_child_count() - 1)
	refresh_gold(scene)


static func _style_card(button: Button, data: Dictionary, index: int, price: int) -> void:
	var original_offer := button.tooltip_text
	if original_offer.is_empty():
		original_offer = String(button.get_meta("shop_original_offer", ""))
	UI.apply_v2_reward_card(button, false)
	button.modulate = Color.WHITE if not button.disabled else Color(0.78, 0.77, 0.75)
	for name in ["ChoiceDivider", "ChoiceBadge"]:
		(button.get_node(name) as CanvasItem).visible = false

	_label(button, "%d  /  %s" % [index + 1, String(data["label"])], Vector2(12, 10), Vector2(268, 24), 13, UI.PARCHMENT_WARM)
	var art_frame := _plate(button, "DS2ArtFrame", Vector2(14, 41), Vector2(264, 181))
	var art := button.get_node("ChoiceArt") as TextureRect
	# The frame draws behind the original real ChoiceArt node.
	button.move_child(art_frame, art.get_index())
	art.texture = ART.get_upgrade_texture(String(data["art"]))
	art.visible = art.texture != null
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.position = Vector2(19, 46)
	art.size = Vector2(254, 171)
	art.modulate = Color.WHITE

	var parchment := _plate(button, "DS2Parchment", Vector2(14, 233), Vector2(264, 163), false, true)
	_label(parchment, String(data["name"]), Vector2(9, 7), Vector2(246, 38), 16, Color(0.19, 0.09, 0.07))
	var rule := ColorRect.new()
	rule.color = Color(0.42, 0.24, 0.14, 0.75)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parchment.add_child(rule)
	rule.position = Vector2(23, 50)
	rule.size = Vector2(218, 1)
	_label(parchment, "ЦЕНА: %d ЗОЛОТА" % price, Vector2(9, 55), Vector2(246, 30), 17, Color(0.46, 0.19, 0.10))

	var role: String = String(data["id"])
	var upgrade_title := "Выбор развития героя."
	var full_upgrade_text := ""
	var upgrade_id := String(button.get_meta("choice_upgrade_id", ""))
	if not upgrade_id.is_empty():
		var upgrade = RunState.get_hero_upgrade(upgrade_id)
		if upgrade != null:
			upgrade_title = String(upgrade.title)
			full_upgrade_text = String(upgrade.description)
	var detail := _label(parchment, upgrade_title, Vector2(13, 88), Vector2(238, 31), 13, Color(0.22, 0.15, 0.12))
	var warning := ""
	if not RunState.is_role_in_party(role):
		warning = "ГЕРОЙ НЕ В ОТРЯДЕ"
	elif not RunState.can_claim_extra_hero_upgrade():
		warning = "ПРЕДЕЛ ДОП. РАЗВИТИЯ"
	elif upgrade_id.is_empty():
		warning = "ВСЕ ПУТИ ОСВОЕНЫ"
	elif RunState.gold < price:
		warning = "НЕ ХВАТАЕТ ЗОЛОТА"
	else:
		warning = "ДОСТУПНО К ПОКУПКЕ"
	_label(parchment, warning, Vector2(10, 123), Vector2(244, 30), 12,
		Color(0.38, 0.28, 0.15) if not button.disabled else Color(0.57, 0.16, 0.11))
	button.tooltip_text = "%s\n\n%s\n%s" % [original_offer, detail.text, full_upgrade_text]


static func refresh_gold(scene: Control) -> void:
	var label := scene.get_node_or_null("Panel/ShopDS2Header/CurrentGold") as Label
	if label == null:
		return
	label.text = "ЗОЛОТО: %d     •     ЦЕНА: %d     •     ОТРЯД: %d/3" % [
		RunState.gold,
		RunState.get_gravedigger_shop_price(),
		RunState.get_party_size()
	]


static func show_result(scene: Control) -> void:
	var status := scene.get_node_or_null("Panel/ShopDS2Footer/Status") as Label
	var hint := scene.get_node_or_null("Panel/ShopDS2Footer/Hint") as Label
	if status != null:
		status.visible = false
	if hint != null:
		hint.visible = false
	for path in ["Panel/Choices/ChoiceA", "Panel/Choices/ChoiceB", "Panel/Choices/ChoiceC"]:
		var card := scene.get_node(path) as Button
		card.modulate = Color(0.78, 0.77, 0.75)
	refresh_gold(scene)


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


static func _label(parent: Control, value: String, pos: Vector2, dimensions: Vector2, font_size: int, ink: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> Label:
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
	# Static texts are assigned only after their controls have tree geometry.
	label.text = value
	return label
