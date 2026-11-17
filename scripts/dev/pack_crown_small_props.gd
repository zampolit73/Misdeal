extends SceneTree
## Pack imagegen edits into local alpha layers; keep the approved background exact.
const ROOT := "res://assets/pixel/travel/batch_02/broken_crown/small_props/"
const PATCH := Rect2i(704,316,210,126)

func _initialize() -> void:
	call_deferred("run")

func resized(path: String) -> Image:
	var image := Image.load_from_file(path)
	assert(image!=null and not image.is_empty(),path)
	image.convert(Image.FORMAT_RGBA8)
	image.resize(1280,720,Image.INTERPOLATE_LANCZOS)
	return image

func run() -> void:
	var base := resized(ROOT+"source/approved_master.png")
	assert(base.save_png(ROOT+"layers/base_1280.png")==OK)
	for key in ["wear","break","melt"]:
		var edited := resized(ROOT+"source/"+key+"_edit.png")
		var layer := Image.create(1280,720,false,Image.FORMAT_RGBA8)
		layer.fill(Color.TRANSPARENT)
		for y in range(PATCH.position.y,PATCH.end.y):
			for x in range(PATCH.position.x,PATCH.end.x):
				var distance := minf(minf(x-PATCH.position.x,PATCH.end.x-1-x),minf(y-PATCH.position.y,PATCH.end.y-1-y))
				var pixel := edited.get_pixel(x,y)
				pixel.a=smoothstep(0.0,12.0,distance)
				layer.set_pixel(x,y,pixel)
		assert(layer.save_png(ROOT+"layers/"+key+"_state.png")==OK)
	print("CROWN_SMALL_PACK_PASS: exact approved base + three bounded alpha layers")
	quit()
