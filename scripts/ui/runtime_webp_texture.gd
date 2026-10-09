extends TextureRect

@export_file("*.webp") var webp_path := ""
@export var expected_size := Vector2i.ZERO
@export var use_nearest_filter := true

static var _texture_cache: Dictionary = {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST if use_nearest_filter else CanvasItem.TEXTURE_FILTER_LINEAR
	if not webp_path.is_empty():
		load_webp_path(webp_path, expected_size)

func load_webp_path(path: String, target_size: Vector2i = Vector2i.ZERO) -> Texture2D:
	webp_path = path
	expected_size = target_size

	var cache_key := "%s|%dx%d" % [path, target_size.x, target_size.y]
	if _texture_cache.has(cache_key):
		texture = _texture_cache[cache_key] as Texture2D
		return texture

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open runtime WebP: %s" % path)
		texture = null
		return null

	var bytes := file.get_buffer(file.get_length())
	if bytes.is_empty():
		push_error("Runtime WebP is empty: %s" % path)
		texture = null
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode runtime WebP '%s': %s" % [path, error_string(error)])
		texture = null
		return null

	if target_size != Vector2i.ZERO and (
		image.get_width() != target_size.x or image.get_height() != target_size.y
	):
		image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)

	var rendered := ImageTexture.create_from_image(image)
	_texture_cache[cache_key] = rendered
	texture = rendered
	return rendered
