extends Control

signal action_requested(action: String)

const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const DESIGN := preload("res://assets/pixel/ui/merchant_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/merchant_v2/merchant_plate.webp")
const BONE := Color("e5c8ab")
const INK := Color("251810")
const MUTED := Color("7a5d4b")

var message: Label
var _stats: Array[Label] = []
var _offers: Dictionary = {}
var _items: Array[Button] = []
var _leave: Button


func build(title: String, intro: String) -> void:
	name = "Merchant"
	size = Vector2(1280, 720)
	UI.picture(self, PLATE, Rect2(Vector2.ZERO, size))
	var layout: Dictionary = DESIGN.data
	for area: Array in layout.stats:
		_stats.append(_copy(area, "", 18, BONE))
	_copy(layout.title, title, 36, BONE)
	_copy(layout.intro, intro, 17, BONE)
	_copy(layout.keyboard, "Enter", 17, BONE)
	_copy(layout.hint, "— купить", 17, BONE)
	message = _copy(layout.feedback, "", 15, BONE)
	message.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	message.mouse_filter = Control.MOUSE_FILTER_PASS
	_leave = _hotspot(layout.leave, "Вернуться к столу", "leave")
	_copy(layout.leave, "ВЕРНУТЬСЯ К СТОЛУ", 21, BONE)

	var relic_index := 0
	for item: String in RunState.camp_stop.stock:
		var kind := item.get_slice("/", 0)
		match kind:
			"relic":
				_mount(layout.relics[relic_index], item)
				relic_index += 1
			"upgrade":
				_mount(layout.upgrade, item)
			"heal":
				_mount(layout.heal, item)
	for slot in range(relic_index, layout.relics.size()):
		_empty_offer(layout.relics[slot])
	if not RunState.camp_stop.stock.any(func(item: String) -> bool: return item.begins_with("upgrade/")):
		_empty_offer(layout.upgrade)
	refresh()


func refresh() -> Array[Button]:
	var values := ["ЗОЛОТО  %d" % RunState.gold, "ОТРЯД  %d/3" % RunState.get_party_size(),
		"РАЗВИТИЕ  %d" % RunState.hero_upgrade_ids.size(), "ДОП.  " + RunState.get_extra_upgrade_progress_text(),
		"РЕЛИКВИИ  %d" % RunState.artifact_ids.size()]
	for i in _stats.size():
		_stats[i].text = values[i]
	for item: String in _offers:
		var offer: Dictionary = _offers[item]
		var button: Button = offer.button
		var reason := STOPS.restriction(RunState, item)
		button.disabled = not reason.is_empty()
		var price := STOPS.price(RunState, item)
		offer.price.text = "%d ЗОЛОТА" % price
		offer.plate.texture = UNIFIED.button_texture("disabled" if button.disabled else "idle")
		offer.price.visible = not button.disabled
		offer.status.visible = button.disabled
		offer.status.text = "%d золота\n%s" % [price, reason]
		offer.status.tooltip_text = offer.status.text
		if button.disabled:
			for points in range(13, 9, -1):
				offer.status.add_theme_font_size_override("font_size", points)
				if offer.status.get_line_count() * offer.status.get_line_height() <= offer.status.size.y:
					break
		if offer.art != null:
			offer.art.modulate = Color("a09390") if button.disabled else Color.WHITE
	var focused := get_viewport().gui_get_focus_owner() as Button
	if not _leave.has_focus() and (focused not in _items or focused.disabled):
		for button in _items:
			if not button.disabled:
				button.grab_focus()
				return _items
		_leave.grab_focus()
	return _items


func _mount(slot: Dictionary, item: String) -> void:
	var id := item.get_slice("/", 1)
	var title := "ЛЕЧЕБНАЯ ПОВЯЗКА"
	var description := "До %d%% макс. HP каждому герою." % roundi(STOPS.SHOP_HEAL * 100)
	var art: TextureRect
	if item.begins_with("relic/"):
		var artifact := RunState.get_artifact(id)
		title = artifact.title
		description = artifact.description
		var texture := ArtifactArtCatalog.get_reliquary_texture(id)
		if texture != null:
			var pixels := texture.get_image()
			art = UI.picture(self, ImageTexture.create_from_image(pixels.get_region(pixels.get_used_rect())), UI.rect(slot.art))
			art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	elif item.begins_with("upgrade/"):
		var role := RunState.get_hero_unit_data(id).unit_name
		title = "РАЗВИТИЕ · " + role
		var upgrade := _listed_upgrade(id, item)
		description = "Улучшения исчерпаны."
		if upgrade != null:
			title = "%s · %s" % [role, upgrade.title]
			description = upgrade.description
	_copy(slot.name, title.to_upper(), 17, INK, 13)
	var copy := _copy(slot.description, description, 15 if item.begins_with("relic/") else 14, INK)
	copy.add_theme_constant_override("line_spacing", 0)
	var point := copy.get_theme_font_size("font_size")
	var font := copy.get_theme_font("font")
	var area := UI.rect(slot.description)
	while point > 12 and font.get_multiline_string_size(description, HORIZONTAL_ALIGNMENT_CENTER, area.size.x, point).y + 4 > area.size.y:
		point -= 1
	copy.add_theme_font_size_override("font_size", point)
	copy.mouse_filter = Control.MOUSE_FILTER_PASS
	copy.tooltip_text = description
	var button := _hotspot(slot.price, title, item)
	button.tooltip_text = "%s\n%s" % [title, description]
	_items.append(button)
	var plate := UNIFIED.action(button, Rect2(Vector2.ZERO, button.size), "", 15)
	var purchase := _copy(slot.price, "", 17, UNIFIED.BONE)
	var status_label := _copy(slot.price, "", 13, UNIFIED.BONE)
	var refresh_plate := func() -> void:
		plate.texture = UNIFIED.button_texture("disabled" if button.disabled else ("pressed" if button.is_pressed() else ("hover" if button.has_focus() or button.is_hovered() else "idle")))
	for signal_value: Signal in [button.focus_entered, button.focus_exited, button.mouse_entered, button.mouse_exited, button.button_down, button.button_up]:
		signal_value.connect(refresh_plate)
	_offers[item] = {"button": button, "art": art, "plate": plate, "price": purchase, "status": status_label}


func _listed_upgrade(role: String, item: String) -> HeroUpgradeData:
	if item in RunState.camp_stop.sold:
		for index in range(RunState.extra_hero_upgrade_ids.size() - 1, -1, -1):
			var upgrade := RunState.get_hero_upgrade(RunState.extra_hero_upgrade_ids[index])
			if upgrade != null and upgrade.target_role == role:
				return upgrade
	var id := RunState.get_next_extra_hero_upgrade_id(role)
	return RunState.get_hero_upgrade(id) if not id.is_empty() else null


func _empty_offer(slot: Dictionary) -> void:
	var area := UI.rect(slot.price)
	var matte := ColorRect.new()
	matte.color = Color("1c1514")
	matte.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.put(self, matte, area.grow(-5))
	_copy(slot.name, "НЕТ В ПРОДАЖЕ", 15, INK)


func _hotspot(bounds: Array, title: String, action: String) -> Button:
	var button := UI.hotspot(self, UI.rect(bounds), title)
	button.name = "Offer_" + action.replace("/", "_")
	for state in ["hover", "focus", "pressed", "disabled"]:
		var finish := StyleBoxFlat.new()
		finish.draw_center = state in ["pressed", "disabled"]
		finish.bg_color = Color("0e0a0a60")
		finish.set_border_width_all(1)
		finish.set_corner_radius_all(5)
		finish.set_expand_margin_all(-4)
		finish.border_color = Color("927054") if state != "disabled" else Color("3f302d")
		button.add_theme_stylebox_override(state, finish)
	button.pressed.connect(func() -> void: action_requested.emit(action))
	return button


func _copy(bounds: Array, value: String, point: int, color: Color, min_point: int = 0) -> Label:
	var area := UI.rect(bounds)
	var label := UI.caption(self, area, "", point, color)
	label.add_theme_font_override("font", UNIFIED.serif())
	var font := label.get_theme_font("font")
	while point > min_point and min_point > 0 and font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > area.size.x:
		point -= 1
	label.add_theme_font_size_override("font_size", point)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = value
	label.clip_text = true
	return label
