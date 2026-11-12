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
func source_patch(id: String, rect: Rect2i) -> Image:
	var image := Image.new()
	assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+id+"_source.png"))==OK)
	assert(image.get_size()==rect.size)
	image.convert(Image.FORMAT_RGBA8)
	var canvas := Image.create(SIZE.x,SIZE.y,false,Image.FORMAT_RGBA8)
	canvas.blit_rect(image,Rect2i(Vector2i.ZERO,rect.size),rect.position)
	return canvas
func run() -> void:
	assert(FileAccess.get_sha256(DIR+"approved_reference.png")=="53322f3f1608f3988d91e48f9253c79dc97e70287234f1611d7fc9b87a545b91")
	var original := read_image("approved_reference.png")
	# Storage upper opening and lower stock gap exclude hands, balance and straw.
	layer("storage_fair",source_patch("fair_storage",Rect2i(530,230,215,390)),[
		"557,256 731,244 733,455 710,453 620,416 607,390 580,390 560,400 542,391",
		"625,467 682,490 654,572 624,584"],3.0)
	layer("floor_fair",source_patch("fair_floor",Rect2i(935,660,280,265)),[
		"938,670 1003,687 1042,714 1085,739 1148,774 1202,793 1200,830 1148,851 1098,814 1054,779 1025,750 997,720 937,699"],6.0)
	layer("ledger_fair",source_patch("fair_ledger",Rect2i(310,655,185,125)),[
		"320,676 389,668 413,702 479,748 469,767 385,766 346,726"],2.0)
	layer("bribe_silence",source_patch("silence_bribe",Rect2i(365,733,135,60)),[
		"374,752 414,745 445,747 485,744 490,770 468,785 411,788 372,783"],3.0)
	# Remove the source's incidental loose coins in ALL states so only silence
	# shows a deliberate bribe; neither scoop nor weights is repainted.
	layer("clean_coins",source_patch("clean_coins",Rect2i(796,727,60,35)),[
		"800,739 827,729 850,732 851,748 838,758 804,756"],3.0)
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
