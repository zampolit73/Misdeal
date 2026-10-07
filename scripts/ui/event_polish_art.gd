class_name EventPolishArt
extends RefCounted

const FORGE_SCENE_PATH := "res://assets/pixel/ui/event_polish/curse_forge_scene.bin"
const FORGE_SCENE_SIZE := Vector2i(682, 423)

static var _forge_scene_texture: Texture2D

static func get_forge_scene_texture() -> Texture2D:
	if _forge_scene_texture != null:
		return _forge_scene_texture
	if not FileAccess.file_exists(FORGE_SCENE_PATH):
		push_error("Missing Curse Forge scene art: %s" % FORGE_SCENE_PATH)
		return null

	var bytes := FileAccess.get_file_as_bytes(FORGE_SCENE_PATH)
	if bytes.is_empty():
		push_error("Curse Forge scene art is empty.")
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode Curse Forge scene art: %s" % error_string(error))
		return null
	if image.get_width() != FORGE_SCENE_SIZE.x or image.get_height() != FORGE_SCENE_SIZE.y:
		push_error(
			"Curse Forge scene art has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				FORGE_SCENE_SIZE.x,
				FORGE_SCENE_SIZE.y,
			]
		)
		return null

	_forge_scene_texture = ImageTexture.create_from_image(image)
	return _forge_scene_texture
