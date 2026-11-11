extends SceneTree
## Deterministic technical alpha/crop/packing. No repainting of reference pixels.
const DIR := "res://assets/pixel/travel/last_dawn_posthouse/"
var original: Image
var bird_patch: Image
var heraldry: Array = []
var manifest: Dictionary = {}
func _initialize() -> void: call_deferred("run")
func read_png(path: String) -> Image:
	var image := Image.new()
	assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK)
	image.convert(Image.FORMAT_RGBA8)
	return image
func run() -> void:
	original = read_png(DIR+"approved_reference.png")
	if not OS.get_cmdline_user_args().is_empty():
		var repaired := read_png(OS.get_cmdline_user_args()[0])
		if repaired.get_size() != original.get_size(): repaired.resize(original.get_width(),original.get_height(),Image.INTERPOLATE_LANCZOS)
		repaired.get_region(Rect2i(710,140,110,110)).save_png(DIR+"perch_patch.png")
	else:
		assert(FileAccess.file_exists(DIR+"perch_patch.png"),"Keep the committed bird-removal patch when repacking")
	bird_patch = read_png(DIR+"perch_patch.png")
	heraldry = [[Rect2i(1117,199,34,74),read_png(DIR+"heraldry_left.png")],[Rect2i(1253,180,36,72),read_png(DIR+"heraldry_right.png")]]
	pack_bird()
	pack_paper()
	# Source-space polygons. The source stays byte-identical; only alpha added.
	layer("castle",[
		"850,320 878,293 935,294 935,267 998,264 998,241 1065,229 1065,185 1090,176 1107,182 1107,224 1201,202 1201,132 1215,123 1244,128 1256,137 1257,188 1307,166 1307,155 1321,147 1374,168 1384,124 1404,119 1428,127 1431,205 1455,205 1455,350 850,405",
		"1260,12 1315,0 1375,0 1384,70 1356,112 1330,158 1305,164 1280,134 1273,88"])
	layer("village",[
		"774,407 807,370 818,345 851,355 858,336 882,321 882,293 903,282 923,290 921,338 979,337 1017,316 1032,350 1046,379 1063,422 1054,531 1100,558 1090,665 774,710",
		"1000,470 1048,425 1088,422 1120,415 1165,424 1207,413 1224,435 1262,485 1255,547 1310,576 1311,649 1000,704",
		"1264,594 1280,455 1307,447 1315,558 1349,570 1355,400 1382,370 1404,379 1409,553 1420,500 1456,430 1492,453 1513,438 1525,473 1555,496 1572,484 1608,493 1630,565 1635,650 1264,686"])
	layer("posthouse",[
		"0,0 1030,0 1000,80 858,158 810,203 815,259 784,262 808,296 824,320 783,337 774,618 787,676 752,735 678,761 574,780 486,804 390,806 349,839 270,845 230,886 0,934",
		"770,516 811,491 849,479 868,489 903,488 909,505 948,500 962,505 980,526 1027,519 1043,537 1098,549 1166,578 1200,588 1210,634 1189,664 1139,688 1080,710 1000,720 934,740 842,738 770,716"])
	layer("road",["0,913 280,855 490,802 735,742 949,710 1115,679 1255,617 1435,600 1510,660 1590,746 1672,941 0,941"],["1400,941 1475,542 1672,440 1672,941"])
	layer("foreground",[
		"1477,0 1672,0 1672,96 1659,89 1659,582 1630,580 1631,87 1605,91 1607,269 1590,339 1577,401 1548,428 1533,389 1517,364 1504,323 1494,169 1490,95 1470,81",
		"1476,549 1518,546 1538,594 1672,575 1672,841 1410,895 1412,745 1458,700",
		"1260,941 1327,866 1412,809 1465,795 1509,804 1573,777 1672,743 1672,941"])
	# Preserve visible approved mountains above the castle, not a generic village.
	layer("mountain_original",["806,245 845,220 882,212 925,167 956,181 985,163 1020,132 1052,132 1106,65 1140,89 1165,127 1192,157 1196,182 1167,190 1134,202 1108,176 1070,181 1060,224 1003,240 943,275 850,310"])
	FileAccess.open(DIR+"layers.json",FileAccess.WRITE).store_string(JSON.stringify(manifest,"  "))
	print("POSTHOUSE_PACK_PASS: reference pixels, 20 bird poses, 4 paper poses, transparent cutouts")
	quit()
func layer(id: String, polygons: Array, holes: Array = []) -> void:
	var svg := '<svg xmlns="http://www.w3.org/2000/svg" width="1672" height="941">'
	for points in polygons: svg += '<polygon fill="white" points="'+str(points)+'"/>'
	for points in holes: svg += '<polygon fill="black" points="'+str(points)+'"/>'
	svg += '</svg>'
	var mask := Image.new()
	assert(mask.load_svg_from_string(svg) == OK)
	var image := Image.create(1672,941,false,Image.FORMAT_RGBA8)
	for y in range(941):
		for x in range(1672):
			var alpha := mask.get_pixel(x,y).r * mask.get_pixel(x,y).a
			if alpha < 0.001: continue
			var pixel := original.get_pixel(x,y)
			if id=="posthouse" and x>=710 and x<820 and y>=140 and y<250:
				var edge := minf(minf(float(x-710),float(819-x)),minf(float(y-140),float(249-y)))
				pixel = pixel.lerp(bird_patch.get_pixel(x-710,y-140),smoothstep(0.0,4.0,edge))
			if id=="castle":
				for correction in heraldry:
					var region: Rect2i = correction[0]
					if region.has_point(Vector2i(x,y)) and pixel.r>pixel.b+0.012 and pixel.r>pixel.g+0.005:
						var local := Vector2i(x,y)-region.position
						var edge := minf(minf(float(local.x),float(region.size.x-1-local.x)),minf(float(local.y),float(region.size.y-1-local.y)))
						pixel=pixel.lerp(correction[1].get_pixelv(local),smoothstep(0.0,2.0,edge))
			pixel.a *= alpha
			image.set_pixel(x,y,pixel)
	var bounds := image.get_used_rect()
	assert(bounds.has_area())
	image.get_region(bounds).save_png(DIR+id+".png")
	manifest[id] = [bounds.position.x,bounds.position.y,bounds.size.x,bounds.size.y]
func clean_cell(image: Image) -> Image:
	# The generator's transparent output can contain coloured matte spill.
	# Remove only saturated red/yellow/green spill and detached alpha islands.
	var w := image.get_width()
	var h := image.get_height()
	for y in range(h):
		for x in range(w):
			var c := image.get_pixel(x,y)
			if c.a < 0.22 or (c.r > c.g*1.9 and c.r > c.b*1.9) or (c.b < 0.12 and maxf(c.r,c.g)>0.35):
				image.set_pixel(x,y,Color.TRANSPARENT)
	var seen := PackedByteArray()
	seen.resize(w*h)
	var largest := PackedInt32Array()
	for y in range(h):
		for x in range(w):
			var start := y*w+x
			if seen[start] or image.get_pixel(x,y).a < 0.22: continue
			var queue := PackedInt32Array([start])
			seen[start] = 1
			var cursor := 0
			while cursor < queue.size():
				var p := queue[cursor]
				cursor += 1
				for offset in [Vector2i(-1,0),Vector2i(1,0),Vector2i(0,-1),Vector2i(0,1)]:
					var point: Vector2i = Vector2i(p%w,p/w)+Vector2i(offset)
					if point.x<0 or point.y<0 or point.x>=w or point.y>=h: continue
					var index: int = point.y*w+point.x
					if not seen[index] and image.get_pixelv(point).a>=0.22:
						seen[index]=1
						queue.append(index)
			if queue.size()>largest.size(): largest=queue
	var output := Image.create(w,h,false,Image.FORMAT_RGBA8)
	for p in largest: output.set_pixel(p%w,p/w,image.get_pixel(p%w,p/w))
	return output
func pack_bird() -> void:
	var source := read_png(DIR+"bone_pigeon_source.png")
	var atlas := Image.create(960,768,false,Image.FORMAT_RGBA8)
	var beaks: Array = []
	for i in range(20):
		var x0 := roundi((i%5)*source.get_width()/5.0)
		var x1 := roundi((i%5+1)*source.get_width()/5.0)
		var y0 := roundi((i/5)*source.get_height()/4.0)
		var y1 := roundi((i/5+1)*source.get_height()/4.0)
		var cell := clean_cell(source.get_region(Rect2i(x0,y0,x1-x0,y1-y0)))
		cell.resize(192,192,Image.INTERPOLATE_LANCZOS)
		atlas.blit_rect(cell,Rect2i(0,0,192,192),Vector2i(i%5*192,i/5*192))
		var beak := Vector2i(162,90)
		var found := false
		for x in range(187,120,-1):
			for y in range(40,125):
				if cell.get_pixel(x,y).a>0.8:
					beak=Vector2i(x,y)
					found=true
					break
			if found: break
		beaks.append([beak.x-96,beak.y-96+3])
	atlas.save_png(DIR+"bone_pigeon.png")
	FileAccess.open(DIR+"beaks.json",FileAccess.WRITE).store_string(JSON.stringify(beaks))
func pack_paper() -> void:
	var source := read_png(DIR+"paper_source.png")
	var atlas := Image.create(512,128,false,Image.FORMAT_RGBA8)
	for i in range(4):
		var x0 := roundi(i*source.get_width()/4.0)
		var x1 := roundi((i+1)*source.get_width()/4.0)
		var cell := clean_cell(source.get_region(Rect2i(x0,0,x1-x0,source.get_height())))
		var crop := cell.get_region(cell.get_used_rect())
		crop.resize(104,72,Image.INTERPOLATE_LANCZOS)
		atlas.blit_rect(crop,Rect2i(0,0,104,72),Vector2i(i*128+12,28))
	atlas.save_png(DIR+"open_paper.png")
