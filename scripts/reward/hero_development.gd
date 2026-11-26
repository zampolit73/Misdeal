extends Control

signal chosen(index: int)
signal inspect_input(event: InputEvent, index: int)

const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const ART := "res://assets/pixel/ui/reward_development_v1/"
const LAYOUT := preload("res://assets/pixel/ui/reward_development_v1/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/reward_development_v1/runtime/development_plate.webp")

var _buttons: Array[Button] = []
var _quote: Label
var _stats: Label
var _locked := false
var _picked := -1


func build(offers: Array[Dictionary], title: String, stage: String, hint: String) -> void:
	name = "HeroDevelopment"
	z_index = 100
	size = Vector2(1280, 720)
	var design: Dictionary = LAYOUT.data
	var light := Color(design.colors.light_text)
	UI.picture(self, PLATE, Rect2(Vector2.ZERO, size))
	_line(design.title, title, light)
	_line(design.stage, stage, light)
	_quote = _line(design.wizard_line, "", light)
	_stats = _line(design.run_stats, "", light)
	_line(design.footer, hint, light)
	var slots: Array = design.layout_by_offer_count.get(str(offers.size()), [])
	for slot: Dictionary in design.slots:
		var position_in_offer := slots.find(slot.index)
		if position_in_offer < 0:
			UI.picture(self, _texture(slot.inactive_texture), UI.rect(slot.rect))
		else:
			var button := _build_card(slot, offers[position_in_offer], design.colors)
			button.modulate.a = 0.0
			create_tween().tween_property(button, "modulate:a", 1.0, 0.22)
	for i in _buttons.size():
		var button := _buttons[i]
		button.focus_neighbor_left = button.get_path_to(_buttons[posmod(i - 1, _buttons.size())])
		button.focus_neighbor_right = button.get_path_to(_buttons[(i + 1) % _buttons.size()])
	if not _buttons.is_empty():
		_buttons[0].grab_focus()


func _build_card(slot: Dictionary, offer: Dictionary, _colors: Dictionary) -> Button:
	var area := UI.rect(slot.rect)
	var index := int(offer.index)
	var button := UI.hotspot(self, area, offer.title)
	button.name = "Option%d" % index
	button.tooltip_text = offer.tooltip
	_buttons.append(button)

	var extent := area.size
	var frame := UNIFIED.mount(button, Rect2(Vector2.ZERO, extent), 0.45, "UnifiedCardFrame", true)
	var art := UI.picture(button, offer.art, UNIFIED.art_rect(extent))
	UNIFIED.fit_art(art, UNIFIED.art_rect(extent))
	UNIFIED.label(button, "Role", offer.role, Rect2(15, 8, extent.x - 30, 34), 15, UNIFIED.INK, true)
	UNIFIED.label(button, "Title", offer.title, Rect2(16, extent.y * 0.46, extent.x - 32, 53), 21, UNIFIED.INK, true)
	_build_effect(button, Rect2(16, extent.y * 0.46 + 55, extent.x - 32, extent.y * 0.54 - 115), offer.effect, slot)
	var cta := UNIFIED.action(button, Rect2(25, extent.y - 54, extent.x - 50, 42), "ВЫБРАТЬ", 19)
	var refresh := func() -> void:
		UNIFIED.refresh(button, frame, cta, _locked and _picked == index)
		cta.get_node("Caption").text = "ВЫБРАНО" if _locked and _picked == index else "ВЫБРАТЬ"
	button.mouse_entered.connect(refresh)
	button.mouse_exited.connect(refresh)
	button.focus_entered.connect(refresh)
	button.focus_exited.connect(refresh)
	button.button_down.connect(refresh)
	button.button_up.connect(refresh)
	button.set_meta("refresh_style", refresh)
	button.pressed.connect(func() -> void: chosen.emit(index))
	button.gui_input.connect(func(event: InputEvent) -> void: inspect_input.emit(event, index))
	refresh.call()
	return button


func _build_effect(button: Button, area: Rect2, effect: String, slot: Dictionary) -> void:
	var lines := effect.split("  •  ", false)
	var font_size := int(slot.effect_font_size)
	var font := UNIFIED.serif()
	for line in lines:
		while font_size > int(slot.effect_min_font_size) and font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > area.size.x:
			font_size -= 1
	if lines.is_empty():
		return
	var row_height := area.size.y / lines.size()
	for i in lines.size():
		var line := lines[i]
		var ink := UNIFIED.NEGATIVE if line.begins_with("−") else UNIFIED.POSITIVE
		var label := UNIFIED.label(button, "Effect%d" % i, "", Rect2(area.position + Vector2(0, i * row_height), Vector2(area.size.x, row_height)), font_size, ink)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.text = line


func set_locked(locked: bool, index: int = -1) -> void:
	var previous := _picked
	_locked = locked
	_picked = index
	for button in _buttons:
		button.disabled = locked
		var refresh: Callable = button.get_meta("refresh_style")
		refresh.call()
	if not locked:
		var previous_button := get_node_or_null("Option%d" % previous) as Button
		if previous_button != null:
			previous_button.grab_focus()


func update_text(quote: String, stats: String) -> void:
	_fit_line(_quote, LAYOUT.data.wizard_line, quote)
	_fit_line(_stats, LAYOUT.data.run_stats, stats)


func _line(region: Dictionary, value: String, color: Color) -> Label:
	var label := UI.caption(self, UI.rect(region.rect), "", int(region.font_size), color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_fit_line(label, region, value)
	return label


func _fit_line(label: Label, region: Dictionary, value: String) -> void:
	var point := int(region.font_size)
	var minimum := int(region.min_font_size)
	var font := label.get_theme_font("font")
	while point > minimum and font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > label.size.x:
		point -= 1
	label.add_theme_font_size_override("font_size", point)
	label.text = value


func _local(bounds: Array, origin: Vector2) -> Rect2:
	var rect := UI.rect(bounds)
	rect.position -= origin
	return rect


func _texture(path: String) -> Texture2D:
	return load(ART + path) as Texture2D
