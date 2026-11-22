extends Control
## Gameplay 2.0: optional non-Fate camp and one-stop merchant on the
## accepted Table backdrop. No painted UI, game logic lives in RunState.
signal finished

const SAVE := preload("res://scripts/core/run_save_service.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

var kind := ""
var title_label: Label
var state_label: Label
var details_label: Label
var choice_buttons: Dictionary = {}
var continue_button: Button
var chosen := false

func configure(stop_kind: String) -> void:
	kind = stop_kind

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	shade.color = Color(0.018, 0.012, 0.016, 0.88)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(820, 490)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.105, 0.077, 0.072, 0.98)
	style.border_color = Color(0.51, 0.38, 0.24, 0.96)
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(26)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	title_label = _label("", 30, Color(0.91, 0.77, 0.53), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(title_label)
	state_label = _label("", 15, Color(0.91, 0.83, 0.72), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(state_label)
	content.add_child(HSeparator.new())
	details_label = _label("", 14, Color(0.77, 0.68, 0.58), HORIZONTAL_ALIGNMENT_CENTER)
	content.add_child(details_label)

	if kind == "camp":
		title_label.text = "ПРИВАЛ У ПОГАСШЕГО ОГНЯ"
		_add_choice(content, "rest", "ЗАЛЕЧИТЬ РАНЫ — +40% макс. HP каждому герою")
		_add_choice(content, "train", "ТРЕНИРОВКА — развитие одного героя")
	else:
		title_label.text = "ЛАВКА МОГИЛЬЩИКА — ЗАПАСЫ"
		_add_choice(content, "artifact", "")
		_add_choice(content, "upgrade", "")
		_add_choice(content, "heal", "")

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(spacer)
	continue_button = Button.new()
	continue_button.custom_minimum_size = Vector2(0, 45)
	UI.apply_action_button(continue_button, UI.AGED_BRONZE, true)
	continue_button.pressed.connect(_on_continue)
	content.add_child(continue_button)
	_refresh()

func _label(value: String, size: int, tint: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = alignment
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", tint)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label

func _add_choice(parent: VBoxContainer, action: String, text: String) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(740, 67)
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UI.apply_action_button(button, UI.BRONZE, false)
	button.pressed.connect(_on_choice.bind(action))
	parent.add_child(button)
	choice_buttons[action] = button

func _refresh() -> void:
	var hearts: Array[String] = []
	for role in RunState.party_roles:
		var max_hp: float = float(RunState.get_effective_hero_stats(role).get("hp", 0.0))
		var actual: float = RunState.get_hero_current_hp(role)
		var display: String = {"knight":"Рыцарь", "ranger":"Следопыт", "mage":"Маг"}.get(role, role)
		hearts.append("%s %d/%d" % [display, roundi(actual), roundi(max_hp)])
	state_label.text = "     ·     ".join(hearts) + "     |     Золото: %d" % RunState.gold
	if kind == "camp":
		details_label.text = "Выберите восстановление или развитие. Привал не тратит карту судьбы."
		choice_buttons["train"].disabled = RunState.get_camp_upgrade_id().is_empty()
		choice_buttons["rest"].disabled = chosen
		if chosen:
			choice_buttons["train"].disabled = true
		continue_button.visible = chosen
		continue_button.text = "ВЕРНУТЬСЯ К СТОЛУ"
		return
	details_label.text = "Можно купить несколько товаров. Пропуск бесплатный. Реликвии и улучшения действуют в этом забеге."
	var artifact_id: String = RunState.get_shop_artifact_id()
	var upgrade_id: String = RunState.get_shop_upgrade_id()
	var artifact = RunState.get_artifact(artifact_id) if not artifact_id.is_empty() else null
	var upgrade = RunState.get_hero_upgrade(upgrade_id) if not upgrade_id.is_empty() else null
	var descriptions := {
		"artifact":"РЕЛИКВИЯ — %s — 40 золота" % (artifact.title if artifact != null else "Нет доступных"),
		"upgrade":"РАЗВИТИЕ — %s — 35 золота" % (upgrade.title if upgrade != null else "Нет доступных"),
		"heal":"ЛЕЧЕНИЕ ОТРЯДА — +30% макс. HP — 20 золота"
	}
	for action in choice_buttons:
		var btn: Button = choice_buttons[action]
		btn.text = descriptions[action] + (" — КУПЛЕНО" if RunState.shop_purchases.get(action, false) else "")
		btn.disabled = not RunState.can_buy_shop_item(action)
	continue_button.text = "ЗАКОНЧИТЬ ТОРГОВЛЮ"
	continue_button.visible = true

func _on_choice(action: String) -> void:
	if kind == "camp":
		if chosen or not RunState.resolve_camp(action):
			return
		chosen = true
		details_label.text = "Раны перевязаны." if action == "rest" else "Один герой получил развитие."
	else:
		if not RunState.buy_shop_item(action):
			return
		# Persist each purchased item so quitting cannot refund it.
	SAVE.instance().write_slot(RunState)
	_refresh()

func _on_continue() -> void:
	if kind == "camp" and not chosen:
		return
	if kind == "shop" and not RunState.leave_shop():
		return
	continue_button.disabled = true
	SAVE.instance().write_slot(RunState)
	finished.emit()
	queue_free()
