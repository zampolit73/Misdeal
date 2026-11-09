extends SceneTree
func _initialize() -> void:
	var directory := "res://assets/pixel/battle/arenas/defiled_laboratory_d421/"
	var image := Image.load_from_file(directory+"source.png")
	image.resize(1280,720,Image.INTERPOLATE_LANCZOS)
	var bytes := image.save_webp_to_buffer(false)
	var output := FileAccess.open(directory+"arena.webp.b64",FileAccess.WRITE)
	output.store_string(Marshalls.raw_to_base64(bytes))
	quit()
