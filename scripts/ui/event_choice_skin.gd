extends RefCounted
## Decorative surfaces for event decisions. The scene's Button stays interactive.

const FRAME := preload("res://assets/pixel/ui/event_choice_visual_v2/decision_frame.png")
const PANEL := preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
const BRONZE := preload("res://shaders/event_choice_bronze.gdshader")
const HEIGHT := 454
const COPY_EXPANSION := 56

static var _plate: Texture2D
static var _expanded_frame: Texture2D
static var _serif: SystemFont
static var _bold: SystemFont
static var _bronze_material: ShaderMaterial


static func serif(bold: bool = false) -> Font:
	if _serif == null:
		_serif = SystemFont.new()
		_serif.font_names = PackedStringArray(["Georgia", "Liberation Serif", "DejaVu Serif", "Times New Roman"])
		_bold = _serif.duplicate() as SystemFont
		_bold.font_weight = 700
	return _bold if bold else _serif


static func mount(button: Button, extent: Vector2) -> void:
	var blank := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled", "focus"]:
		button.add_theme_stylebox_override(state, blank)
	var frame := TextureRect.new()
	frame.name = "DecisionFrame"
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.texture = FRAME
	if _bronze_material == null:
		_bronze_material = ShaderMaterial.new()
		_bronze_material.shader = BRONZE
	frame.material = _bronze_material
	frame.size = extent
	frame.z_index = 1
	button.add_child(frame)


static func shade(button: Button, brightness: float) -> void:
	var frame := button.get_node("DecisionFrame") as TextureRect
	frame.modulate = Color(brightness, brightness, brightness)


static func enlarge_copy(button: Button) -> void:
	if _expanded_frame == null:
		# The frame is sampled at 2× logical size. Redistribute height between
		# its art window and parchment while keeping the crests and title band.
		var source := FRAME.get_image()
		var result := source.duplicate() as Image
		var width := source.get_width()
		var src_edges := [64, 214, 263, 396]
		var dst_edges := [64, 214 - COPY_EXPANSION, 263 - COPY_EXPANSION, 396]
		for index in range(3):
			var band := source.get_region(Rect2i(0, int(src_edges[index]) * 2, width,
				(src_edges[index + 1] - src_edges[index]) * 2))
			band.resize(width, (dst_edges[index + 1] - dst_edges[index]) * 2, Image.INTERPOLATE_LANCZOS)
			result.blit_rect(band, Rect2i(Vector2i.ZERO, band.get_size()), Vector2i(0, dst_edges[index] * 2))
		_expanded_frame = ImageTexture.create_from_image(result)
	var frame := button.get_node("DecisionFrame") as TextureRect
	frame.texture = _expanded_frame


static func plate_style(compact: bool = false) -> StyleBoxTexture:
	if _plate == null:
		var image := PANEL.get_image()
		image.resize(384, 256, Image.INTERPOLATE_LANCZOS)
		_plate = ImageTexture.create_from_image(image)
	var box := StyleBoxTexture.new()
	box.texture = _plate
	box.texture_margin_left = 23
	box.texture_margin_right = 23
	box.texture_margin_top = 13 if compact else 23
	box.texture_margin_bottom = box.texture_margin_top
	box.set_content_margin_all(0)
	box.modulate_color = Color("a79c94")
	return box
