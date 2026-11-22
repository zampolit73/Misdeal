extends Control

signal finished(message: String)

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ART := preload("res://scripts/ui/card_art_catalog.gd")
const BUILD := preload("res://scripts/ui/run_build_feedback.gd")

var _shop: bool
var _stock_rows: VBoxContainer
var _party: Label
var _message: Label
var _trainee: OptionButton
var _action_buttons: Array[Button] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 100
	_shop = RunState.camp_stop.slot == STOPS.SHOP_SLOT
	var shade := ColorRect.new()
	shade.color = Color(0.03, 0.02, 0.02, 0.78)
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var plate := Panel.new()
	plate.position = Vector2(120, 55)
	plate.size = Vector2(1040, 610)
	add_child(plate)
	UI.apply_v2_material_plate(plate, true)
	var heading := _label(plate, _title(), 32, UI.PARCHMENT_WARM)
	heading.position = Vector2(28, 24)
	var intro := _label(plate, _intro(), 15, UI.TEXT)
	intro.position = Vector2(29, 70)
	var art := TextureRect.new()
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.texture = ART.get_run_card_texture("gravedigger_shop" if _shop else "ash_rest")
	art.position = Vector2(28, 123)
	art.size = Vector2(355, 225)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.add_child(art)
	_party = _label(plate, "", 18, UI.PARCHMENT_WARM)
	_party.position = Vector2(29, 359)
	_party.add_theme_constant_override("line_spacing", 7)
	_stock_rows = VBoxContainer.new()
	_stock_rows.position = Vector2(414, 112)
	_stock_rows.size.x = 596
	_stock_rows.add_theme_constant_override("separation", 8)
	plate.add_child(_stock_rows)
	_message = _label(plate, "", 15, UI.PARCHMENT_WARM)
	_message.position = Vector2(29, 555)
	_message.size.x = 670
	_message.mouse_filter = Control.MOUSE_FILTER_PASS
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if _shop:
		var leave := Button.new()
		leave.text = "Вернуться к столу"
		leave.position = Vector2(778, 549)
		leave.size = Vector2(232, 39)
		plate.add_child(leave)
		UI.apply_action_button(leave, UI.BRONZE)
		leave.pressed.connect(_choose.bind("leave"))
	_render_choices()


func _title() -> String:
	if _shop: return "ТОРГОВЕЦ У ВОРОТ"
	return "ПЕРВЫЙ ПРИВАЛ" if RunState.camp_stop.slot == 4 else "ПОСЛЕДНЯЯ ПОДГОТОВКА"


func _intro() -> String:
	if _shop: return "После VIII · Запасы торговца ограничены. Покупки можно пропустить."
	return "После %s · Одна возможность перед возвращением к столу." % ("IV" if RunState.camp_stop.slot == 4 else "XII")


func _label(parent: Control, text: String, points: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", points)
	UI.apply_screen_copy(label, color, points >= 30)
	parent.add_child(label)
	return label


func _render_choices() -> void:
	var focus_index := _action_buttons.find(get_viewport().gui_get_focus_owner())
	for child in _stock_rows.get_children():
		_stock_rows.remove_child(child)
		child.queue_free()
	_action_buttons.clear()
	var lines := PackedStringArray(["Золото     %d" % RunState.gold, ""])
	for role in RunState.party_roles:
		lines.append("%s    %d / %d HP" % [_hero_name(role), ceili(RunState.get_hero_current_hp(role)), ceili(RunState.get_hero_max_hp(role))])
	_party.text = "\n".join(lines)
	if _shop:
		for item: String in RunState.camp_stop.stock:
			_shop_row(item)
	else:
		_add_row("Отдых", "Восстановить до %d%% макс. HP каждому герою." % roundi(STOPS.REST_HEAL * 100), "rest")
		_trainee = OptionButton.new()
		_trainee.custom_minimum_size.y = 34
		for role in RunState.party_roles:
			var index := _trainee.item_count
			_trainee.add_item(_hero_name(role))
			_trainee.set_item_metadata(index, role)
			_trainee.set_item_disabled(index, RunState.get_next_extra_hero_upgrade_id(role).is_empty())
			if role == RunState.get_least_developed_extra_role():
				_trainee.select(index)
		_stock_rows.add_child(_trainee)
		UI.apply_action_button(_trainee, UI.BRONZE)
		var training := _add_row("Тренировка", "", "")
		_trainee.item_selected.connect(func(_index: int) -> void: _update_training(training))
		training.pressed.connect(func() -> void: _choose(_training_action()))
		_update_training(training)
		var rite_text := "Нет подходящей реликвии."
		if not RunState.camp_stop.stock.is_empty():
			var artifact := RunState.get_artifact(String(RunState.camp_stop.stock[0]).get_slice("/", 1))
			rite_text = "%s · −%d текущего HP протагониста.\n%s" % [artifact.title, int(STOPS.rite_cost(RunState)), artifact.description]
		_add_row("Тёмный обряд", rite_text, "rite")
	for shift in _action_buttons.size():
		var index := (maxi(focus_index, 0) + shift) % _action_buttons.size()
		if not _action_buttons[index].disabled:
			_action_buttons[index].grab_focus()
			break


func _hero_name(role: String) -> String:
	return RunState.get_hero_unit_data(role).unit_name


func _training_action() -> String:
	return "upgrade/" + String(_trainee.get_selected_metadata())


func _update_training(button: Button) -> void:
	var role := _training_action().get_slice("/", 1)
	var upgrade_id := RunState.get_next_extra_hero_upgrade_id(role)
	button.disabled = upgrade_id.is_empty()
	button.text = "Тренировка — развитие исчерпано"
	if not upgrade_id.is_empty():
		var upgrade := RunState.get_hero_upgrade(upgrade_id)
		button.text = "Тренировка · %s\n%s" % [upgrade.title, upgrade.description]


func _shop_row(item: String) -> void:
	var id := item.get_slice("/", 1)
	var name: String
	var description: String
	match item.get_slice("/", 0):
		"relic":
			var artifact := RunState.get_artifact(id)
			name = artifact.title
			description = artifact.description
		"upgrade":
			var upgrade_id := RunState.get_next_extra_hero_upgrade_id(id)
			name = "Развитие · %s" % _hero_name(id)
			if not upgrade_id.is_empty():
				var upgrade := RunState.get_hero_upgrade(upgrade_id)
				name = "%s · %s" % [_hero_name(id), upgrade.title]
				description = upgrade.description
		"heal":
			name = "Лечебная повязка"
			description = "Восстановить до %d%% макс. HP каждому герою." % roundi(STOPS.SHOP_HEAL * 100)
	_add_row("%s  ·  %d золота" % [name, STOPS.price(RunState, item)], description, item)


func _add_row(title: String, description: String, action: String) -> Button:
	var button := Button.new()
	var reason := STOPS.restriction(RunState, action) if not action.is_empty() else ""
	button.text = title
	if not reason.is_empty():
		button.text += "  ·  " + reason
		button.disabled = true
	if not description.is_empty():
		button.text += "\n" + description
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.custom_minimum_size = Vector2(596, 78 if _shop else 92)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_stock_rows.add_child(button)
	UI.apply_action_button(button, UI.BRONZE if action != "rite" else UI.EMBER, action == "rest")
	button.add_theme_font_size_override("font_size", 15)
	if not action.is_empty():
		button.pressed.connect(_choose.bind(action))
	_action_buttons.append(button)
	return button


func _choose(action: String) -> void:
	var save := SAVE.instance()
	var previous: Dictionary = save.snapshot(RunState).state
	var before := BUILD.capture(RunState)
	var next_relic := ""
	if action.begins_with("relic/"):
		next_relic = action.get_slice("/", 1)
	elif action == "rite" and not RunState.camp_stop.stock.is_empty():
		next_relic = String(RunState.camp_stop.stock[0]).get_slice("/", 1)
	if not STOPS.apply(RunState, action):
		return
	if not save.write_slot(RunState):
		save.restore_values(RunState, previous)
		_message.text = save.error_message
		return
	var after := BUILD.capture(RunState)
	var delta := BUILD.changes(before, after, 1)
	if not next_relic.is_empty():
		var artifact := RunState.get_artifact(next_relic)
		if delta.is_empty(): delta = artifact.title + " · " + artifact.description
	if RunState.camp_stop.is_empty():
		var message := "Торговец закрыл свою лавку." if _shop else "Привал закончился. Волшебник раздаёт карты."
		finished.emit(delta if not delta.is_empty() else message)
		queue_free()
	else:
		_message.text = "Осталось %d золота." % RunState.gold
		if not delta.is_empty(): _message.text += " " + delta
		_message.tooltip_text = BUILD.changes(before, after)
		_render_choices()
