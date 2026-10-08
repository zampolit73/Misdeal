extends TextureRect

const SPLASH_PATH := "res://assets/pixel/main/approved_splash_hd/main_splash.webp"
const EXPECTED_SIZE := Vector2i(1280, 720)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_load_approved_splash()


func _load_approved_splash() -> void:
	var file := FileAccess.open(SPLASH_PATH, FileAccess.READ)
	if file == null:
		push_error("Missing approved main-menu splash: %s" % SPLASH_PATH)
		return

	var bytes: PackedByteArray = file.get_buffer(file.get_length())
	if bytes.is_empty():
		push_error("Approved main-menu splash is empty.")
		return

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved main-menu splash WebP: %s" % error_string(error))
		return

	if image.get_width() != EXPECTED_SIZE.x or image.get_height() != EXPECTED_SIZE.y:
		push_warning(
			"Approved main-menu splash decoded at %dx%d, expected %dx%d."
			% [image.get_width(), image.get_height(), EXPECTED_SIZE.x, EXPECTED_SIZE.y]
		)

	texture = ImageTexture.create_from_image(image)
