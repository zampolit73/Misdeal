extends SceneTree
## Scene05 deterministic source cutouts and one bounded storage patch.
const DIR := "res://assets/pixel/travel/dead_rations_granary/"
const SIZE := Vector2i(1672,941)
var rectangles: Dictionary = {}
func _initialize() -> void: call_deferred("run")
func read_image(file: String) -> Image:
	var image := Image.new()
	assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+file))==OK)
	image.convert(Image.FORMAT_RGBA8)
	if image.get_size()!=SIZE: image.resize(SIZE.x,SIZE.y,Image.INTERPOLATE_LANCZOS)
	return image
func mask_for(polygons: Array) -> Image:
	var svg := '<svg xmlns="http://www.w3.org/2000/svg" width="1672" height="941">'
	for polygon in polygons: svg+='<polygon fill="white" points="'+str(polygon)+'"/>'
	var mask := Image.new()
	assert(mask.load_svg_from_string(svg+'</svg>')==OK)
	return mask
func layer(id: String, source: Image, polygons: Array, feather: float = 0.0) -> void:
	var mask := mask_for(polygons)
	var distance := PackedFloat32Array()
	if feather>0:
		distance.resize(SIZE.x*SIZE.y)
		for y in range(SIZE.y):
			for x in range(SIZE.x):
				var i := y*SIZE.x+x
				var d := 64.0 if mask.get_pixel(x,y).a>0.5 else 0.0
				if x>0: d=minf(d,distance[i-1]+1)
				if y>0: d=minf(d,distance[i-SIZE.x]+1)
				distance[i]=d
		for y in range(SIZE.y-1,-1,-1):
			for x in range(SIZE.x-1,-1,-1):
				var i := y*SIZE.x+x
				if x<SIZE.x-1: distance[i]=minf(distance[i],distance[i+1]+1)
				if y<SIZE.y-1: distance[i]=minf(distance[i],distance[i+SIZE.x]+1)
	var image := Image.create(SIZE.x,SIZE.y,false,Image.FORMAT_RGBA8)
	for y in range(SIZE.y):
		for x in range(SIZE.x):
			var alpha := mask.get_pixel(x,y).a
			if alpha<=0: continue
			if feather>0: alpha*=smoothstep(0.0,feather,distance[y*SIZE.x+x])
			var color := source.get_pixel(x,y)
			color.a*=alpha
			image.set_pixel(x,y,color)
	var bounds := image.get_used_rect()
	assert(bounds.has_area())
	image.get_region(bounds).save_png(DIR+id+".png")
	rectangles[id]=[bounds.position.x,bounds.position.y,bounds.size.x,bounds.size.y]
func run() -> void:
	assert(FileAccess.get_sha256(DIR+"approved_reference.png")=="53322f3f1608f3988d91e48f9253c79dc97e70287234f1611d7fc9b87a545b91")
	var original := read_image("approved_reference.png")
	# The opening is contained inside the existing frame, above both bone hands.
	var patch := Image.new()
	assert(patch.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+"storage_patch_source.png"))==OK)
	assert(patch.get_size()==Vector2i(166,180))
	patch.convert(Image.FORMAT_RGBA8)
	var storage := Image.create(1672,941,false,Image.FORMAT_RGBA8)
	storage.blit_rect(patch,Rect2i(0,0,166,180),Vector2i(570,260))
	layer("storage_fair",storage,["578,275 724,268 729,431 609,433 578,405"],3.0)
	# Keep arches, banners, desk, quartermaster and all dummies on one plate.
	# Only featureless floor inside the aisle has a tiny relative displacement.
	layer("floor",original,["1095,941 1100,790 1190,660 1320,535 1407,484 1466,484 1500,521 1482,580 1450,670 1455,745 1530,941"],26.0)
	layer("foreground",original,["0,649 188,643 263,671 473,735 693,738 735,726 924,698 1000,711 1028,770 1007,941 0,941", "1672,505 1600,521 1558,571 1553,614 1489,637 1468,712 1510,746 1672,821"])
	# Source brass coins; only alpha-cleared objects, no tabletop rectangle.
	layer("coins",original,["803,743 810,738 822,738 827,744 823,750 810,752 803,749", "826,733 836,732 845,737 843,742 832,743 825,740"])
	layer("ledger_edge",original,["393,722 431,718 462,733 486,750 482,764 436,773 405,764"])
	FileAccess.open(DIR+"layers.json",FileAccess.WRITE).store_string(JSON.stringify(rectangles,"  "))
	print("GRANARY_PACK_PASS: immutable source, bounded storage edit, connected architecture and source coins")
	quit()
