extends SceneTree

## Rebuilds the runtime card-frame WebP from the exact approved PNG.
## Godot Image.save_webp(lossy=false) preserves every opaque source pixel.
const SOURCE := "res://assets/source_archive/card_frame_d419/approved_blank_frame.png"
const OUTPUT := "res://assets/pixel/ui/card_ds3_locked/front_frame_d419.webp"

func _initialize() -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path(SOURCE))
	if image == null or image.is_empty():
		push_error("D419 approved frame source could not be loaded")
		quit(1)
		return
	if image.get_size() != Vector2i(1086, 1448):
		push_error("D419 source dimensions changed unexpectedly: %s" % image.get_size())
		quit(1)
	var result := image.save_webp(ProjectSettings.globalize_path(OUTPUT), false)
	if result != OK:
		push_error("D419 lossless WebP write failed: %s" % result)
		quit(1)
	print("D419_FRAME_PACK_PASS: %s %s" % [image.get_size(), FileAccess.get_sha256(OUTPUT)])
	quit(0)
