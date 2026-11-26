extends RefCounted
## Cursed Deck V2 — physical printed cards. Shared skin never owns game actions.
const FRAME := preload("res://assets/pixel/ui/cursed_deck_v2/card_face.webp")
const CARD_BACK := preload("res://assets/pixel/ui/cursed_deck_v2/card_back.webp")
const UNKNOWN := preload("res://assets/pixel/ui/cursed_deck_v2/card_unknown.webp")
const BUTTON_ROOT := "res://assets/pixel/ui/reward_development_v1/runtime/states/button_0_"
const INK := Color("#241e19")
const BONE := Color("#f0d8b4")
const GOLD := Color("#d7ac75")
const MUTED := Color("#493a30")
const STONE := Color("#161211")
const SPLIT := 0.45
const MINI_SPLIT := 0.72

static var _fonts: Dictionary = {}
static var _buttons: Dictionary = {}

static func face(_split: float = SPLIT, hidden: bool = false) -> Texture2D:
	# The paper is continuous; art/copy proportions change without deforming the print.
	return UNKNOWN if hidden else FRAME

static func serif(bold: bool = false) -> Font:
	if not _fonts.has(bold):
		var font := SystemFont.new()
		font.font_names = PackedStringArray(["Georgia", "Liberation Serif", "DejaVu Serif", "Times New Roman"])
		font.font_weight = 700 if bold else 400
		_fonts[bold] = font
	return _fonts[bold]

static func place(node: Control, area: Rect2) -> void:
	node.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	node.custom_minimum_size = Vector2.ZERO
	node.position = area.position
	node.size = area.size
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func mount(host: Control, area: Rect2, split: float = SPLIT, node_name := "UnifiedCardFrame", mask_baked := false) -> TextureRect:
	var frame := TextureRect.new()
	frame.name = node_name
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	frame.texture = face(split)
	host.add_child(frame)
	place(frame, area)
	host.move_child(frame, 0)
	var highlight := Panel.new()
	highlight.name = "PaperFocus"
	var edge := StyleBoxFlat.new()
	edge.draw_center = false
	edge.set_border_width_all(2)
	edge.border_color = Color("e3d1aaad")
	edge.set_corner_radius_all(9)
	highlight.add_theme_stylebox_override("panel", edge)
	frame.add_child(highlight)
	place(highlight, Rect2(Vector2(4, 4), area.size - Vector2(8, 8)))
	highlight.hide()
	if mask_baked:
		var backing := ColorRect.new()
		backing.name = "OldPlateMask"
		backing.color = STONE
		host.add_child(backing)
		place(backing, area)
		host.move_child(backing, 0)
	return frame

static func art_rect(extent: Vector2, split: float = SPLIT, tag: bool = true) -> Rect2:
	var top := 0.105 if tag else 0.060
	return Rect2(extent.x * 0.061, extent.y * top, extent.x * 0.878, extent.y * (split - top))

static func fit_art(art: TextureRect, area: Rect2, cover: bool = true) -> void:
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED if cover else TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.material = null
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	place(art, area)

static func style_label(label: Label, area: Rect2, point: int, ink: Color, bold: bool = false, wrap: bool = true) -> void:
	label.add_theme_font_override("font", serif(bold))
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", ink)
	label.add_theme_constant_override("outline_size", 0)
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 0)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	place(label, area)

static func label(host: Control, node_name: String, value: String, area: Rect2, point: int, ink: Color, bold: bool = false) -> Label:
	var result := Label.new()
	result.name = node_name
	result.text = value
	host.add_child(result)
	style_label(result, area, point, ink, bold)
	while point > 11 and result.get_line_count() * result.get_line_height() > area.size.y:
		point -= 1
		result.add_theme_font_size_override("font_size", point)
	result.size = area.size
	return result

static func blank_button(button: Button) -> void:
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled", "focus"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())

static func button_texture(state: String, on_paper: bool = true) -> Texture2D:
	# On a card the action is printed ink and two quiet rules, not a metal button.
	# The existing cabinet is a separate physical surface and keeps its dark plate.
	var key := state + ("_paper" if on_paper else "_cabinet")
	if not _buttons.has(key):
		if not on_paper:
			_buttons[key] = load(BUTTON_ROOT + state + ".webp") as Texture2D
		else:
			var image := Image.create_empty(256, 48, false, Image.FORMAT_RGBA8)
			image.fill(Color.TRANSPARENT)
			var ink := Color("48392c99")
			match state:
				"hover":
					ink = Color("392b1dd9")
					image.fill_rect(Rect2i(8, 4, 240, 40), Color("e8dab02a"))
				"pressed":
					ink = Color("6b2623dc")
					image.fill_rect(Rect2i(8, 4, 240, 40), Color("74342b1e"))
				"disabled":
					ink = Color("5c50485c")
			image.fill_rect(Rect2i(10, 1, 236, 2), ink)
			image.fill_rect(Rect2i(36, 45, 184, 1), ink)
			_buttons[key] = ImageTexture.create_from_image(image)
	return _buttons[key]

static func action(host: Control, area: Rect2, value: String = "ВЫБРАТЬ", point: int = 16,
		on_paper: bool = true) -> TextureRect:
	var plate := TextureRect.new()
	plate.name = "UnifiedAction"
	plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plate.texture = button_texture("idle", on_paper)
	host.add_child(plate)
	place(plate, area)
	label(plate, "Caption", value, Rect2(Vector2.ZERO, area.size), point, INK if on_paper else BONE, true)
	return plate

static func shade_frame(frame: TextureRect, brightness: float) -> void:
	var value := clampf(brightness, 0.87, 1.06)
	frame.modulate = Color(value, value, value)
	var edge := frame.get_node_or_null("PaperFocus") as Panel
	if edge != null:
		edge.visible = brightness > 1.01

static func refresh(button: Button, frame: TextureRect, plate: TextureRect, selected: bool = false) -> void:
	var highlighted := button.has_focus() or button.is_hovered()
	var state := "pressed" if selected else ("disabled" if button.disabled else ("pressed" if button.is_pressed() else ("hover" if highlighted else "idle")))
	plate.texture = button_texture(state)
	var brightness := 0.86 if button.disabled and not selected else (1.13 if highlighted or selected else 1.0)
	shade_frame(frame, brightness)

static func bind_action(button: Button, frame: TextureRect, plate: TextureRect) -> void:
	var update := func() -> void: refresh(button, frame, plate)
	for signal_value: Signal in [button.mouse_entered, button.mouse_exited, button.focus_entered, button.focus_exited, button.button_down, button.button_up]:
		signal_value.connect(update)
	button.set_meta("unified_refresh", update)
	update.call()
