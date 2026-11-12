extends SceneTree
## Source-space masks, local shelf patches and measured overlap; no repaint.
const DIR := "res://assets/pixel/travel/campfire_without_master/"
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
func patch(target: Image, edit: Image, polygons: Array) -> void:
	var mask := mask_for(polygons)
	var r := mask.get_used_rect()
	for y in range(r.position.y,r.end.y):
		for x in range(r.position.x,r.end.x):
			var alpha := mask.get_pixel(x,y).a
			if alpha>0: target.set_pixel(x,y,target.get_pixel(x,y).lerp(edit.get_pixel(x,y),alpha))
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
	assert(FileAccess.get_sha256(DIR+"approved_reference.png")=="ea21184b5a2792ce5ac3d4226f95656a5b812caab6bd345d19ef6d138d94a53a")
	var original := read_image("approved_reference.png")
	var passed := original.duplicate() as Image
	# All generated pixels are restricted to spare footwear on the shelf.
	patch(passed,read_image("spares_edit.png"),["750,467 775,454 831,454 850,448 936,447 981,455 1003,486 1005,537 991,552 882,556 833,552 747,548"])
	var repair := passed.duplicate() as Image
	# Restoring original shelf RGB removes the light pair, not worn boots.
	patch(repair,original,["746,457 833,452 838,511 833,547 745,547"])
	patch(repair,original,["833,514 879,511 891,531 880,557 831,553"])
	var hobnails := passed.duplicate() as Image
	patch(hobnails,original,["872,447 986,447 1006,486 1006,548 884,548"])
	patch(hobnails,read_image("hobnails_edit.png"),["892,521 944,520 987,525 993,539 984,546 894,543"])
	layer("strap",passed,["838,523 845,518 860,516 873,518 880,523 878,532 867,543 851,552 839,550 846,536 854,530"])
	# This one connected plate includes canvas, poles, ropes, rack, saddle,
	# squire, his boots, kettle/tripod, embers and near debris. Never split them.
	var camp := "0,0 1060,0 1058,22 1000,65 1013,119 1024,177 1014,230 1025,294 1060,327 1100,340 1135,363 1180,365 1227,384 1258,410 1275,466 1297,508 1293,557 1307,603 1288,637 1250,655 1228,686 1196,700 1174,742 1165,798 1151,857 1140,897 1139,941 0,941"
	for outcome in ["passed","repair","hobnails"]:
		var source: Image = passed if outcome=="passed" else (repair if outcome=="repair" else hobnails)
		layer("camp_"+outcome,source,[camp])
	# Full-height original backing and the connected camp share displacement.
	# This preserves branch/rope/wall contacts and the exact portal silhouette;
	# the masked ground in front supplies restrained depth without arch cuts.
	layer("gate",original,["0,0 1672,0 1672,941 0,941"])
	layer("road",original,["990,941 1060,810 1220,660 1330,565 1415,485 1480,475 1555,535 1630,675 1672,780 1672,941"],22.0)
	# Front-left props retain the camp's identical displacement.
	layer("foreground",original,["0,590 57,586 129,618 205,640 263,695 281,730 352,708 405,735 454,789 503,833 539,886 641,908 684,941 0,941"])
	# Exact visible sky between canopy and gate; these contain no close rope.
	layer("sky_original",original,["1068,2 1134,2 1134,163 1070,165", "1017,152 1108,165 1109,263 1040,252"])
	FileAccess.open(DIR+"layers.json",FileAccess.WRITE).store_string(JSON.stringify(rectangles,"  "))
	print("CAMPFIRE_PACK_PASS: immutable source, three shelf states, connected camp and gate plates")
	quit()
