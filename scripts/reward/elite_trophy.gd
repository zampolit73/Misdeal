extends Control

signal confirmed(index: int)
signal inspect_input(event: InputEvent, index: int)

const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const MOTION := preload("res://scripts/ui/ui_motion.gd")
const ART := "res://assets/pixel/ui/reward_elite_v1/"
const LAYOUT := preload("res://assets/pixel/ui/reward_elite_v1/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/reward_elite_v1/runtime/artifact_reward_plate.webp")
const BONE := Color("dcc4a0")
const INK := Color("302219")

var _cards: Array[Button] = []
var _highlights: Array[TextureRect] = []
var _confirm: Button
var _quote: Label
var _selected := -1


func build(ids: Array[String], title: String, quote: String, empty_cache_art: Texture2D) -> void:
	name = "EliteTrophy"
	z_index = 100
	size = Vector2(1280, 720)
	var design: Dictionary = LAYOUT.data
	UI.picture(self, PLATE, Rect2(Vector2.ZERO, size))
	UI.caption(self, UI.rect(design.title.rect), title, int(design.title.font_size), BONE)
	_quote = UI.caption(self, UI.rect(design.wizard_line.rect), "", int(design.wizard_line.font_size), BONE)
	_quote.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	show_message(quote)

	var fallback := ids[0] == "elite_gold"
	var physical_slots: Array = design.visible_slot_map["0_fallback" if fallback else str(ids.size())]
	for slot: Dictionary in design.slots:
		var index := physical_slots.find(slot.index)
		if index < 0:
			UI.picture(self, _texture(slot.inactive_texture), UI.rect(slot.rect))
		else:
			_build_slot(slot, index, ids[index], empty_cache_art)

	var action: Dictionary = design.button
	_confirm = UI.hotspot(self, UI.rect(action.rect), "Забрать золото" if fallback else "Взять реликвию")
	_confirm.name = "Confirm"
	var state_names := {"normal": "idle", "hover": "hover", "pressed": "pressed", "hover_pressed": "pressed", "disabled": "disabled"}
	for state in state_names:
		var style := StyleBoxTexture.new()
		style.texture = _texture(action.textures[state_names[state]])
		_confirm.add_theme_stylebox_override(state, style)
	var focus := StyleBoxFlat.new()
	focus.draw_center = false
	focus.set_border_width_all(1)
	focus.set_expand_margin_all(-14)
	focus.border_color = Color("a9815988")
	_confirm.add_theme_stylebox_override("focus", focus)
	UI.caption(_confirm, _local(action.text_rect, _confirm.position),
		"ЗАБРАТЬ ЗОЛОТО" if fallback else "ВЗЯТЬ РЕЛИКВИЮ", int(action.font_size), BONE)
	_confirm.pressed.connect(func() -> void: confirmed.emit(_selected))
	UI.caption(self, UI.rect(design.hint.rect), "← →  выбрать  ·  Enter  подтвердить  ·  ПКМ / F  подробности",
		int(design.hint.font_size), BONE)

	for index in _cards.size():
		var card := _cards[index]
		card.focus_neighbor_left = card.get_path_to(_cards[posmod(index - 1, _cards.size())])
		card.focus_neighbor_right = card.get_path_to(_cards[(index + 1) % _cards.size()])
		card.focus_neighbor_bottom = card.get_path_to(_confirm)
	_select(0, false)
	_cards[0].grab_focus()
	_fade_in(self, 0.0)
	for card in _cards:
		_fade_in(card, 0.06)


func _build_slot(slot: Dictionary, index: int, id: String, empty_cache_art: Texture2D) -> void:
	var area := UI.rect(slot.rect)
	var item := RunState.get_artifact(id) if id != "elite_gold" else null
	var title := item.title if item != null else "Опустевший тайник"
	var description := item.description if item != null else "+50 золота\nВсе известные артефакты уже у вас."
	var card := UI.hotspot(self, area, title)
	card.name = "Option%d" % index
	card.tooltip_text = title + "\n" + description
	_cards.append(card)
	var hover := UI.picture(card, _texture(slot.hover_overlay), Rect2(Vector2.ZERO, area.size))
	hover.hide()
	card.mouse_entered.connect(func() -> void: hover.visible = not card.disabled)
	card.mouse_exited.connect(hover.hide)
	var selected := UI.picture(card, _texture(slot.selected_overlay), Rect2(Vector2.ZERO, area.size))
	selected.modulate.a = 0.0
	_highlights.append(selected)
	if item != null:
		var marker := UI.caption(selected, _local(slot.selected_marker_rect, area.position), "ВЫБРАНО", 13, BONE)
		marker.add_theme_color_override("font_shadow_color", Color.BLACK)
	var art := UI.picture(card, ArtifactArtCatalog.get_reliquary_texture(id) if item != null else empty_cache_art,
		_local(slot.art_rect, area.position))
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var caption := UI.caption(card, _local(slot.title_rect, area.position), "", int(slot.title_font_size), INK)
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_font_size_override("font_size", int(slot.title_min_font_size) if title.length() > 23 else int(slot.title_font_size))
	caption.text = title
	var copy_area := _local(slot.description_rect, area.position)
	var copy := UI.caption(card, copy_area, "", int(slot.description_font_size), INK)
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# The authored descriptions fit the parchment. The reader remains available for full copy.
	copy.clip_text = true
	copy.text = description
	card.focus_entered.connect(_select.bind(index, false))
	card.pressed.connect(_select.bind(index, true))
	card.gui_input.connect(func(event: InputEvent) -> void: inspect_input.emit(event, index))


func show_message(message: String) -> void:
	_quote.text = message
	_quote.tooltip_text = message
	var font_size := int(LAYOUT.data.wizard_line.font_size)
	_quote.add_theme_font_size_override("font_size",
		int(LAYOUT.data.wizard_line.min_font_size) if message.length() > 90 else font_size)


func set_locked(locked: bool) -> void:
	_confirm.disabled = locked
	for card in _cards:
		card.disabled = locked
	if locked:
		var highlight := _highlights[_selected]
		var tween := MOTION.replace_tween(highlight, &"trophy_selection")
		tween.tween_property(highlight, "modulate:a", 0.48, 0.13)
	else:
		_select(_selected, true)


func _select(index: int, focus_confirm: bool) -> void:
	if _confirm.disabled:
		return
	_selected = index
	for i in _highlights.size():
		var highlight := _highlights[i]
		MOTION.replace_tween(highlight, &"trophy_selection").tween_property(highlight, "modulate:a",
			1.0 if i == index else 0.0, 0.14)
	_confirm.focus_neighbor_top = _confirm.get_path_to(_cards[index])
	if focus_confirm:
		_confirm.grab_focus()


func _fade_in(node: Control, delay: float) -> void:
	node.modulate.a = 0.0
	create_tween().tween_property(node, "modulate:a", 1.0, 0.24).set_delay(delay)


func _local(bounds: Array, origin: Vector2) -> Rect2:
	var rect := UI.rect(bounds)
	rect.position -= origin
	return rect


func _texture(path: String) -> Texture2D:
	return load(ART + path) as Texture2D
