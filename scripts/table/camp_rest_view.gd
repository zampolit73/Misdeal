extends Control

signal action_requested(action: String)

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const ASSETS := "res://assets/pixel/ui/camp_rest_v2/"
const DESIGN := preload(ASSETS + "layout_1280x720.json")
const PLATE := preload(ASSETS + "runtime/rest_plate.webp")
const BONE := Color("e6cbaa")
const CARD_SPLIT := 0.43
const COPY_TOP := 239.0
const SELECTOR_Y := 351.0

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
	message = _copy(layout.footer, "Enter — подтвердить  ·  Tab / стрелки — выбор  ·  Наведение — если текст сокращён", 15)
	message.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

	var rest: Dictionary = layout.cards[0]
	var rest_button := _card(rest, "ПЕРЕДОХНУТЬ")
	_set_description(rest_button, _description(rest_button), "Восстановить до %d%% макс. HP каждому герою." % [
		roundi(STOPS.rest_fraction(RunState) * 100)])
	rest_button.pressed.connect(func() -> void: action_requested.emit("rest"))
	_build_training(layout.cards[1])
	_build_rite(layout.cards[2])
	var enabled: Array[Button] = []
	for button in action_buttons:
		if button.disabled:
			button.focus_mode = Control.FOCUS_NONE
		else:
			enabled.append(button)
	for index in enabled.size():
		var button := enabled[index]
		button.focus_neighbor_left = button.get_path_to(enabled[posmod(index - 1, enabled.size())])
		button.focus_neighbor_right = button.get_path_to(enabled[(index + 1) % enabled.size()])
	rest_button.grab_focus()


func _build_training(card: Dictionary) -> void:
	var button := _card(card, "ТРЕНИРОВКА")
	_training_description = _description(button, true)
	var default_role := RunState.get_least_developed_extra_role()
	if default_role.is_empty():
		_disable(button, STOPS.restriction(RunState, "upgrade/" + RunState.protagonist_role))
		return
	_trainee = OptionButton.new()
	_trainee.accessibility_name = "Герой для тренировки"
	_trainee.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_trainee.add_theme_font_override("font", UNIFIED.serif())
	_trainee.add_theme_font_size_override("font_size", 15)
	KIT.apply_action_button(_trainee, KIT.BRONZE)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		_trainee.add_theme_color_override(state, UNIFIED.GOLD)
	for role in RunState.party_roles:
		var index := _trainee.item_count
		_trainee.add_item(RunState.get_hero_unit_data(role).unit_name)
		_trainee.set_item_metadata(index, role)
		_trainee.set_item_disabled(index, not STOPS.restriction(RunState, "upgrade/" + role).is_empty())
		if role == default_role:
			_trainee.select(index)
	UI.put(button, _trainee, Rect2(22, SELECTOR_Y, button.size.x - 44, 30))
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
	var description := _description(button)
	if not RunState.camp_stop.stock.is_empty():
		var artifact := RunState.get_artifact(String(RunState.camp_stop.stock[0]).get_slice("/", 1))
		_set_description(button, description, "%s\n−%d текущего HP протагониста\n%s" % [
			artifact.title, int(STOPS.rite_cost(RunState)), artifact.description])
	_disable(button, STOPS.restriction(RunState, "rite"))
	button.pressed.connect(func() -> void: action_requested.emit("rite"))


func _card(card: Dictionary, title: String) -> Button:
	# The approved V2 plate contains the old frame and illustrations. Cover the
	# ENTIRE old frame including its projecting finials; sample only its art.
	var button := UI.hotspot(self, UI.rect(card.v3_card_rect), title)
	var extent := button.size
	var frame := UNIFIED.mount(button, Rect2(Vector2.ZERO, extent), CARD_SPLIT, "UnifiedCardFrame", true)
	var atlas := AtlasTexture.new()
	atlas.atlas = PLATE
	atlas.region = UI.rect(card.v3_art_crop)
	atlas.filter_clip = true
	var art := UI.picture(button, atlas, UNIFIED.art_rect(extent, CARD_SPLIT))
	art.name = "CardArt"
	UNIFIED.fit_art(art, UNIFIED.art_rect(extent, CARD_SPLIT))
	UNIFIED.label(button, "Kind", "ПРИВАЛ", Rect2(18, 9, extent.x - 36, 32), 15, UNIFIED.GOLD, true)
	UNIFIED.label(button, "Title", title, Rect2(15, 194, extent.x - 30, 40), 20, UNIFIED.GOLD, true)
	var action := UNIFIED.action(button, Rect2(25, extent.y - 50, extent.x - 50, 38), "ВЫБРАТЬ", 17)
	UNIFIED.bind_action(button, frame, action)
	action_buttons.append(button)
	return button


func _disable(button: Button, reason: String) -> void:
	if reason.is_empty():
		return
	button.disabled = true
	var description := button.get_node_or_null("Description") as Label
	if description != null:
		description.size.y = SELECTOR_Y - COPY_TOP - 6
		_fit_description(button, description)
	UNIFIED.label(button, "Availability", reason, Rect2(17, SELECTOR_Y, button.size.x - 34, 30), 14, UNIFIED.NEGATIVE, true)
	var action := button.get_node("UnifiedAction") as TextureRect
	(action.get_node("Caption") as Label).text = "НЕДОСТУПНО"
	button.get_meta("unified_refresh").call()
	button.accessibility_description += ("\n" if not button.accessibility_description.is_empty() else "") + reason
	if not button.tooltip_text.is_empty():
		button.tooltip_text += "\n" + reason


func _description(button: Button, training: bool = false) -> Label:
	var height := SELECTOR_Y - COPY_TOP - 6 if training else button.size.y - 55 - COPY_TOP
	return UNIFIED.label(button, "Description", "", Rect2(18, COPY_TOP, button.size.x - 36, height), 16, UNIFIED.COPY)


func _set_description(button: Button, label: Label, description: String) -> void:
	label.text = description
	button.accessibility_description = description
	_fit_description(button, label)


func _fit_description(button: Button, label: Label) -> void:
	# Prefer full text on the face. Native tooltip only when it really overflows,
	# so hovering ordinary cards no longer obstructs all three illustrations.
	label.max_lines_visible = -1
	label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	button.tooltip_text = ""
	var font := label.get_theme_font("font")
	for points in range(16, 12, -1):
		label.add_theme_font_size_override("font_size", points)
		var lines := font.get_multiline_string_size(label.text, HORIZONTAL_ALIGNMENT_CENTER, label.size.x, points)
		var line_count := roundi(lines.y / font.get_height(points))
		if lines.y + maxi(0, line_count - 1) * label.get_theme_constant("line_spacing") <= label.size.y:
			return
	label.max_lines_visible = maxi(1, floori((label.size.y + label.get_theme_constant("line_spacing")) / (font.get_height(13) + label.get_theme_constant("line_spacing"))))
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	button.tooltip_text = label.text


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
