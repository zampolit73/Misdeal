extends TextureRect

const PART_PATHS: Array[String] = [
	"res://assets/pixel/main/approved_splash_hd/part_00.txt",
	"res://assets/pixel/main/approved_splash_hd/part_01.txt",
	"res://assets/pixel/main/approved_splash_hd/part_02.txt",
	"res://assets/pixel/main/approved_splash_hd/part_03.txt",
	"res://assets/pixel/main/approved_splash_hd/part_04.txt",
	"res://assets/pixel/main/approved_splash_hd/part_05.txt",
]

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_load_approved_splash()

func _load_approved_splash() -> void:
	var encoded := ""
	for path in PART_PATHS:
		if not FileAccess.file_exists(path):
			push_error("Missing approved main-menu splash chunk: %s" % path)
			return
		encoded += FileAccess.get_file_as_string(path).strip_edges()

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Approved main-menu splash decoded to an empty buffer.")
		return

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved main-menu splash WebP: %s" % error_string(error))
		return

	if image.get_width() != 1280 or image.get_height() != 720:
		push_warning(
			"Approved main-menu splash decoded at %dx%d, expected 1280x720."
			% [image.get_width(), image.get_height()]
		)

	texture = ImageTexture.create_from_image(image)
