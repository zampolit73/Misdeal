extends RefCounted
## Decorative surfaces for event decisions. The scene's Button stays interactive.

const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const SPLIT := 0.40
const PANEL := preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
const HEIGHT := 454
const COPY_EXPANSION := 56

static var _plate: Texture2D
static func serif(bold: bool = false) -> Font:
	return UNIFIED.serif(bold)


static func mount(button: Button, extent: Vector2) -> void:
	UNIFIED.blank_button(button)
	UNIFIED.mount(button, Rect2(Vector2.ZERO, extent), SPLIT, "DecisionFrame")
	button.get_node("ChoiceArt").z_index = 1

static func shade(button: Button, brightness: float) -> void:
	var frame := button.get_node("DecisionFrame") as TextureRect
	frame.modulate = Color(brightness, brightness, brightness)


static func enlarge_copy(button: Button) -> void:
	var frame := button.get_node("DecisionFrame") as TextureRect
	frame.texture = UNIFIED.face(SPLIT - float(COPY_EXPANSION) / HEIGHT)


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
