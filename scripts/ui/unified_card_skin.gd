extends RefCounted
## Unified Card System V1 — shared visual chrome, never owns game actions.
const FRAME := preload("res://assets/pixel/ui/unified_card_system_v1/card_face.webp")
const BUTTON_ROOT := "res://assets/pixel/ui/reward_development_v1/runtime/states/button_0_"
const INK := Color("#302018")
const BONE := Color("#f0d8b4")
const GOLD := Color("#d7ac75")
const MUTED := Color("#674938")
const STONE := Color("#161211")
const SPLIT := 0.45
const MINI_SPLIT := 0.72

static var _frames: Dictionary = {}
static var _fonts: Dictionary = {}
static var _buttons: Dictionary = {}

static func face(split: float = SPLIT, hidden: bool = false) -> Texture2D:
	var key := "%d:%s" % [roundi(split * 1000), hidden]
	if _frames.has(key):
		return _frames[key]
	var original := FRAME.get_image()
	var width := original.get_width()
	var height := original.get_height()
	var edge := roundi(height * SPLIT)
	var target := roundi(height * split)
	var top := original.get_region(Rect2i(0, 0, width, edge))
	var bottom := original.get_region(Rect2i(0, edge, width, height - edge))
	top.resize(width, target, Image.INTERPOLATE_LANCZOS)
	bottom.resize(width, height - target, Image.INTERPOLATE_LANCZOS)
	var image := original.duplicate() as Image
	image.blit_rect(top, Rect2i(Vector2i.ZERO, top.get_size()), Vector2i.ZERO)
	image.blit_rect(bottom, Rect2i(Vector2i.ZERO, bottom.get_size()), Vector2i(0, target))
	if hidden:
		# Dark, unillustrated face — no card IDs or future art ever supplied.
		var inner := Rect2i(roundi(width * 0.035), target, roundi(width * 0.93), roundi(height * 0.978) - target)
		image.fill_rect(inner, STONE)
	_frames[key] = ImageTexture.create_from_image(image)
	return _frames[key]

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
	if mask_baked:
		var backing := ColorRect.new()
		backing.name = "OldPlateMask"
		backing.color = STONE
		host.add_child(backing)
		place(backing, area)
		host.move_child(backing, 0)
	return frame

static func art_rect(extent: Vector2, split: float = SPLIT, tag: bool = true) -> Rect2:
	var top := 0.105 if tag else 0.045
	return Rect2(extent.x * 0.035, extent.y * top, extent.x * 0.93, extent.y * (split - top))

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

static func button_texture(state: String) -> Texture2D:
	if not _buttons.has(state):
		_buttons[state] = load(BUTTON_ROOT + state + ".webp") as Texture2D
	return _buttons[state]

static func action(host: Control, area: Rect2, value: String = "ВЫБРАТЬ", point: int = 16) -> TextureRect:
	var plate := TextureRect.new()
	plate.name = "UnifiedAction"
	plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	plate.texture = button_texture("idle")
	host.add_child(plate)
	place(plate, area)
	label(plate, "Caption", value, Rect2(Vector2.ZERO, area.size), point, BONE, true)
	return plate

static func refresh(button: Button, frame: TextureRect, plate: TextureRect, selected: bool = false) -> void:
	var highlighted := button.has_focus() or button.is_hovered()
	var state := "pressed" if selected else ("disabled" if button.disabled else ("pressed" if button.is_pressed() else ("hover" if highlighted else "idle")))
	plate.texture = button_texture(state)
	var brightness := 0.86 if button.disabled and not selected else (1.13 if highlighted or selected else 1.0)
	frame.modulate = Color(brightness, brightness, brightness)

static func bind_action(button: Button, frame: TextureRect, plate: TextureRect) -> void:
	var update := func() -> void: refresh(button, frame, plate)
	for signal_value: Signal in [button.mouse_entered, button.mouse_exited, button.focus_entered, button.focus_exited, button.button_down, button.button_up]:
		signal_value.connect(update)
	button.set_meta("unified_refresh", update)
	update.call()
