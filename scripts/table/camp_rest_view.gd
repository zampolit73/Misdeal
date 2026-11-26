extends Control

signal action_requested(action: String)

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ASSETS := "res://assets/pixel/ui/camp_rest_v2/"
const DESIGN := preload(ASSETS + "layout_1280x720.json")
const PLATE := preload(ASSETS + "runtime/rest_plate.webp")
const BONE := Color("e6cbaa")
const INK := Color("302019")
const RESTRICTION := Color("652c28")

var message: Label
var action_buttons: Array[Button] = []
var _trainee: OptionButton
var _training_description: Label


func build(title: String, intro: String) -> void:
	name = "CampRest"
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var layout: Dictionary = DESIGN.data
	UI.picture(self, PLATE, Rect2(0, 0, layout.canvas.width, layout.canvas.height))
	_copy(layout.status, "ЗОЛОТО: %d     ОТРЯД: %d/3     РАЗВИТИЕ: %d     ДОП.: %s     РЕЛИКВИИ: %d" % [
		RunState.gold, RunState.get_party_size(), RunState.hero_upgrade_ids.size(),
		RunState.get_extra_upgrade_progress_text(), RunState.artifact_ids.size()], 14)
	var heading := UI.caption(self, UI.rect(layout.heading), title, 32, BONE)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_copy(layout.intro, intro, 16, BONE, HORIZONTAL_ALIGNMENT_LEFT)
	var hp := PackedStringArray()
	for role in RunState.party_roles:
		hp.append("%s %d / %d HP" % [RunState.get_hero_unit_data(role).unit_name,
			ceili(RunState.get_hero_current_hp(role)), ceili(RunState.get_hero_max_hp(role))])
	_copy(layout.party_health, "     ".join(hp), 15, BONE, HORIZONTAL_ALIGNMENT_LEFT)
	message = _copy(layout.footer, "Enter — подтвердить  ·  Наведите на карту, чтобы прочитать полное описание", 15)
	message.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

	var rest: Dictionary = layout.cards[0]
	var rest_button := _card(rest, "ПЕРЕДОХНУТЬ")
	_set_description(rest_button, _description(rest), "Восстановить до %d%% макс. HP каждому герою." % [
		roundi(STOPS.rest_fraction(RunState) * 100)])
	rest_button.pressed.connect(func() -> void: action_requested.emit("rest"))
	_build_training(layout.cards[1])
	_build_rite(layout.cards[2])
	rest_button.grab_focus()


func _build_training(card: Dictionary) -> void:
	var button := _card(card, "ТРЕНИРОВКА")
	_training_description = _description(card)
	var default_role := RunState.get_least_developed_extra_role()
	if default_role.is_empty():
		_disable(card, button, STOPS.restriction(RunState, "upgrade/" + RunState.protagonist_role))
		return
	_trainee = OptionButton.new()
	_trainee.accessibility_name = "Герой для тренировки"
	_trainee.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_trainee.add_theme_font_size_override("font_size", 14)
	KIT.apply_action_button(_trainee, KIT.BRONZE)
	for role in RunState.party_roles:
		var index := _trainee.item_count
		_trainee.add_item(RunState.get_hero_unit_data(role).unit_name)
		_trainee.set_item_metadata(index, role)
		_trainee.set_item_disabled(index, not STOPS.restriction(RunState, "upgrade/" + role).is_empty())
		if role == default_role:
			_trainee.select(index)
	UI.put(self, _trainee, UI.rect(card.training_role_selector))
	button.focus_neighbor_bottom = button.get_path_to(_trainee)
	_trainee.focus_neighbor_top = _trainee.get_path_to(button)
	_trainee.item_selected.connect(func(_index: int) -> void: _update_training(button))
	button.pressed.connect(func() -> void: action_requested.emit("upgrade/" + String(_trainee.get_selected_metadata())))
	_update_training(button)


func _update_training(button: Button) -> void:
	var role := String(_trainee.get_selected_metadata())
	var upgrade := RunState.get_hero_upgrade(RunState.get_next_extra_hero_upgrade_id(role))
	_set_description(button, _training_description, "%s\n%s" % [upgrade.title, upgrade.description])


func _build_rite(card: Dictionary) -> void:
	var button := _card(card, "ТЁМНЫЙ ОБРЯД")
	if not RunState.camp_stop.stock.is_empty():
		var artifact := RunState.get_artifact(String(RunState.camp_stop.stock[0]).get_slice("/", 1))
		_set_description(button, _description(card), "%s\n−%d текущего HP протагониста\n%s" % [
			artifact.title, int(STOPS.rite_cost(RunState)), artifact.description])
	_disable(card, button, STOPS.restriction(RunState, "rite"))
	button.pressed.connect(func() -> void: action_requested.emit("rite"))


func _card(card: Dictionary, title: String) -> Button:
	var button := UI.hotspot(self, UI.rect(card.hit_area), title)
	for state: String in card.overlay_files:
		var style := StyleBoxTexture.new()
		style.texture = load(ASSETS + card.overlay_files[state]) as Texture2D
		button.add_theme_stylebox_override(state, style)
		if state == "pressed":
			button.add_theme_stylebox_override("hover_pressed", style)
	UI.caption(self, UI.rect(card.title), title, 20, BONE)
	action_buttons.append(button)
	return button


func _disable(card: Dictionary, button: Button, reason: String) -> void:
	if reason.is_empty():
		return
	button.disabled = true
	_copy(card.status, reason, 14, RESTRICTION)
	button.tooltip_text += ("\n" if not button.tooltip_text.is_empty() else "") + reason
	button.accessibility_description = button.tooltip_text


func _description(card: Dictionary) -> Label:
	var area := UI.rect(card.description)
	var box := Control.new()
	box.clip_contents = true
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.put(self, box, area)
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", INK)
	label.add_theme_constant_override("line_spacing", -4)
	UI.put(box, label, Rect2(Vector2.ZERO, area.size))
	return label


func _set_description(button: Button, label: Label, description: String) -> void:
	button.tooltip_text = description
	button.accessibility_description = description
	label.max_lines_visible = -1
	label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	label.text = description
	var bounds: Vector2 = label.get_parent().size
	var font := label.get_theme_font("font")
	var spacing := label.get_theme_constant("line_spacing")
	for points in range(15, 11, -1):
		label.add_theme_font_size_override("font_size", points)
		var lines := font.get_multiline_string_size(description, HORIZONTAL_ALIGNMENT_CENTER, bounds.x, points)
		var line_count := roundi(lines.y / font.get_height(points))
		if lines.y + maxi(0, line_count - 1) * spacing <= bounds.y:
			return
	label.max_lines_visible = floori((bounds.y + spacing) / (font.get_height(12) + spacing))
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS


func _copy(area: Array, value: String, points: int, color: Color = BONE, alignment := HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", points)
	UI.put(self, label, UI.rect(area))
	return label
