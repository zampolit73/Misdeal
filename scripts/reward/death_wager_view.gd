extends Control

signal chosen(index: int)
signal inspect_input(event: InputEvent, index: int)

const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const ASSETS := "res://assets/pixel/ui/reward_death_wager_v12/"
const LAYOUT := preload(ASSETS + "layout_1280x720.json")
const PLATE := preload(ASSETS + "runtime/wager_plate.webp")
const BONE := Color("e2cbb0")
const INK := Color("332019")

var _buttons: Array[Button] = []
var _quote: Label


func build(ids: Array[String], offers: Array[Dictionary], title: String, quote: String, hint: String) -> Array[Texture2D]:
	name = "DeathWager"
	z_index = 100
	var design: Dictionary = LAYOUT.data
	size = Vector2(design.resolution[0], design.resolution[1])
	UI.picture(self, PLATE, Rect2(Vector2.ZERO, size))
	UI.caption(self, UI.rect(design.title.rect), title, int(design.title.font_size), BONE)
	_quote = _caption(self, UI.rect(design.summary.rect), quote, int(design.summary.font_size), BONE)
	_caption(self, UI.rect(design.hint.rect), hint, int(design.hint.font_size), BONE)
	var textures: Array[Texture2D] = []
	for index in ids.size():
		var slot: Dictionary = design.cards[index]
		var texture := _offer_art(ids[index], slot, design.cards[0].gold_art)
		textures.append(texture)
		_build_card(index, slot, offers[index], texture, ids[index].begins_with("artifact:"))
	for index in _buttons.size():
		var button := _buttons[index]
		button.focus_neighbor_left = button.get_path_to(_buttons[posmod(index - 1, _buttons.size())])
		button.focus_neighbor_right = button.get_path_to(_buttons[(index + 1) % _buttons.size()])
	_buttons[0].grab_focus()
	return textures


func _build_card(index: int, slot: Dictionary, offer: Dictionary, texture: Texture2D, relic: bool) -> void:
	var area := UI.rect(slot.hit_area)
	var button := UI.hotspot(self, area, offer.title)
	button.name = "Option%d" % index
	button.tooltip_text = "%s\n\n%s" % [offer.title, offer.description]
	button.accessibility_description = offer.description
	UNIFIED.blank_button(button)
	_buttons.append(button)
	var extent := area.size
	var frame := UNIFIED.mount(button, Rect2(Vector2.ZERO, extent), 0.45, "UnifiedCardFrame", true)
	var window := UNIFIED.art_rect(extent)
	var art := UI.picture(button, texture, window)
	UNIFIED.fit_art(art, window, not relic)
	UNIFIED.label(button, "Kind", "РЕЛИКВИЯ" if relic else "НАГРАДА", Rect2(14, 8, extent.x - 28, 34), 15, UNIFIED.INK, true)
	UNIFIED.label(button, "Title", String(offer.title).to_upper(), Rect2(14, extent.y * 0.46, extent.x - 28, 52), 22, UNIFIED.INK, true)
	UNIFIED.label(button, "Description", offer.description, Rect2(16, extent.y * 0.46 + 54, extent.x - 32, extent.y * 0.54 - 113), 17, UNIFIED.COPY)
	var cta := UNIFIED.action(button, Rect2(25, extent.y - 54, extent.x - 50, 42), "ВЫБРАТЬ", 19)
	UNIFIED.bind_action(button, frame, cta)
	button.pressed.connect(func() -> void: chosen.emit(index))
	button.gui_input.connect(func(event: InputEvent) -> void: inspect_input.emit(event, index))


func show_message(message: String) -> void:
	_quote.text = message
	var summary: Dictionary = LAYOUT.data.summary
	_fit(_quote, int(summary.font_size), float(summary.rect[3]))


func set_locked(locked: bool, selected := -1) -> void:
	for index in _buttons.size():
		var button := _buttons[index]
		button.disabled = locked
		var cta := button.get_node("UnifiedAction") as TextureRect
		UNIFIED.refresh(button, button.get_node("UnifiedCardFrame"), cta, locked and index == selected)
		cta.get_node("Caption").text = "ВЫБРАНО" if locked and index == selected else "ВЫБРАТЬ"
	if not locked:
		_buttons[maxi(0, selected)].grab_focus()


func _offer_art(id: String, slot: Dictionary, gold_art: String) -> Texture2D:
	if id.begins_with("artifact:"):
		var texture := ArtifactArtCatalog.get_reliquary_texture(id.get_slice(":", 1))
		if texture == null:
			return null
		var image := texture.get_image()
		var used := image.get_used_rect()
		return ImageTexture.create_from_image(image.get_region(used)) if used.has_area() else texture
	return load(ASSETS + (slot.upgrade_art if id == "bonus_upgrade" else gold_art)) as Texture2D


func _caption(parent: Control, area: Rect2, text: String, points: int, ink: Color) -> Label:
	var label := UI.caption(parent, area, "", points, ink)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.add_theme_constant_override("line_spacing", -2)
	label.text = text
	_fit(label, points, area.size.y)
	return label


func _fit(label: Label, points: int, height: float) -> void:
	for font_size in range(points, 11, -1):
		label.add_theme_font_size_override("font_size", font_size)
		if label.get_minimum_size().y <= height:
			break
	label.size.y = height


func _outline(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.draw_center = false
	style.set_border_width_all(1)
	style.set_corner_radius_all(9)
	style.set_expand_margin_all(-2)
	style.border_color = color
	return style


func _local(coordinates: Array, origin: Vector2) -> Rect2:
	var area := UI.rect(coordinates)
	area.position -= origin
	return area
