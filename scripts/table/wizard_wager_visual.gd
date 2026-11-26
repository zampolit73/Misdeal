extends RefCounted
## Approved Wizard Wager V1. Only this modal's presentation changes.
## The table and the existing RunState accept/refuse handlers stay authoritative.

const SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const PLATE := preload("res://assets/pixel/ui/wizard_wager_v1/wager_plate.webp")
const BONE := Color("eed7b7")
const INK := Color("2c1d15")

static func apply(scene: Control) -> void:
	var panel := scene.get_node("WagerOverlay/Root/WagerPanel") as Panel
	var scrim := scene.get_node("WagerOverlay/Root/Scrim") as ColorRect
	scrim.color.a = 0.40
	_place(panel, Rect2(268, 232, 744, 475))
	_clear_surface(panel)
	var picture := TextureRect.new()
	picture.name = "WagerPlate"
	picture.texture = PLATE
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_SCALE
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(picture)
	panel.move_child(picture, 0)
	_place(picture, Rect2(Vector2.ZERO, panel.size))

	# Hide legacy decorative chrome, not any actionable controls.
	for name in ["Sigil", "Divider", "ContractLine", "ContractSigil"]:
		panel.get_node(name).hide()
	_copy(panel.get_node("Title"), Rect2(181, 32, 382, 39), "СТАВКА ВОЛШЕБНИКА", 25, BONE)
	_copy(panel.get_node("Quote"), Rect2(40, 77, 664, 30),
		"«Следующий бой станет больнее. Добыча — вдвое слаще.»", 17, BONE)

	var risk := panel.get_node("RiskPanel") as Panel
	var reward := panel.get_node("RewardPanel") as Panel
	_offer(risk, Rect2(34, 238, 318, 102), "RiskArt", "ЦЕНА", "ВРАГИ +25% УРОНА", "Пока действует долг")
	_offer(reward, Rect2(394, 238, 316, 102), "RewardArt", "НАГРАДА", "ОБЫЧНАЯ ДОБЫЧА ×2", "Следующая обычная награда")

	var bonus := Label.new()
	bonus.name = "SacrificeBonus"
	panel.add_child(bonus)
	_copy(bonus, Rect2(190, 354, 364, 31), "Дополнительно: приказ «Жертва»", 17, BONE)
	var accept := panel.get_node("AcceptButton") as Button
	var refuse := panel.get_node("RefuseButton") as Button
	_button(accept, Rect2(67, 396, 295, 45))
	_button(refuse, Rect2(397, 396, 286, 45))
	for button in [accept, refuse]:
		var other := refuse if button == accept else accept
		var neighbor: NodePath = button.get_path_to(other)
		button.focus_neighbor_left = neighbor
		button.focus_neighbor_right = neighbor
		button.focus_neighbor_top = neighbor
		button.focus_neighbor_bottom = neighbor
		button.focus_next = neighbor
		button.focus_previous = neighbor

static func _offer(panel: Panel, bounds: Rect2, art_name: String, kicker: String, value: String, detail: String) -> void:
	_place(panel, bounds)
	_clear_surface(panel)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.get_node(art_name).hide()
	_copy(panel.get_node("Kicker"), Rect2(12, 3, bounds.size.x - 24, 24), kicker, 18, INK)
	_copy(panel.get_node("Value"), Rect2(12, 36, bounds.size.x - 24, 29), value, 22, INK)
	_copy(panel.get_node("Title"), Rect2(12, 68, bounds.size.x - 24, 24), detail, 16, INK)

static func _clear_surface(panel: Panel) -> void:
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	var chrome := panel.get_node_or_null("_MisdealChrome") as CanvasItem
	if chrome != null:
		chrome.hide()

static func _place(control: Control, bounds: Rect2) -> void:
	control.position = bounds.position
	control.size = bounds.size

static func _copy(label: Label, bounds: Rect2, value: String, point: int, color: Color) -> void:
	label.text = value
	label.add_theme_font_override("font", SKIN.heading_font())
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.clip_text = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	# Fit actual installed serif font at native 1280×720, without clipping.
	while point > 13 and SKIN.heading_font().get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > bounds.size.x - 4:
		point -= 1
		label.add_theme_font_size_override("font_size", point)
	_place(label, bounds)

static func _button(button: Button, bounds: Rect2) -> void:
	SKIN.prepare_action(button, 20)
	_place(button, bounds)
