extends SceneTree
## Reproducible source-pixel cutouts and tightly masked, retained repair plates.
const DIR := "res://assets/pixel/travel/last_dressing_station/"
const SIZE := Vector2i(1672,941)
var rectangles: Dictionary = {}

func _initialize() -> void: call_deferred("run")

func read_image(file: String) -> Image:
	var image := Image.new()
	assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+file)) == OK)
	image.convert(Image.FORMAT_RGBA8)
	if image.get_size()!=SIZE: image.resize(SIZE.x,SIZE.y,Image.INTERPOLATE_LANCZOS)
	return image

func mask_for(polygons: Array, holes: Array = []) -> Image:
	var svg := '<svg xmlns="http://www.w3.org/2000/svg" width="1672" height="941">'
	for points in polygons: svg += '<polygon fill="white" points="'+str(points)+'"/>'
	for points in holes: svg += '<polygon fill="black" points="'+str(points)+'"/>'
	var mask := Image.new()
	assert(mask.load_svg_from_string(svg+'</svg>')==OK)
	return mask

func patch(target: Image, edit: Image, polygons: Array) -> void:
	var mask := mask_for(polygons)
	var bounds := mask.get_used_rect()
	for y in range(bounds.position.y,bounds.end.y):
		for x in range(bounds.position.x,bounds.end.x):
			var alpha := mask.get_pixel(x,y).a
			if alpha>0.0: target.set_pixel(x,y,target.get_pixel(x,y).lerp(edit.get_pixel(x,y),alpha))

func layer(id: String, source: Image, polygons: Array, holes: Array = []) -> void:
	var mask := mask_for(polygons,holes)
	var output := Image.create(SIZE.x,SIZE.y,false,Image.FORMAT_RGBA8)
	for y in range(SIZE.y):
		for x in range(SIZE.x):
			var alpha := mask.get_pixel(x,y).r*mask.get_pixel(x,y).a
			if alpha<=0.0: continue
			var color := source.get_pixel(x,y)
			color.a *= alpha
			output.set_pixel(x,y,color)
	var bounds := output.get_used_rect()
	assert(bounds.has_area())
	output.get_region(bounds).save_png(DIR+id+".png")
	rectangles[id] = [bounds.position.x,bounds.position.y,bounds.size.x,bounds.size.y]

func run() -> void:
	assert(FileAccess.get_sha256(DIR+"approved_reference.png")=="3c7b2626b2028b156cc6556a8ab148721e2987763ceda451e5d38a28ca47a34d")
	var source := read_image("approved_reference.png")
	var plain := read_image("plain_cloth_edit.png")
	# Only the cloth below the hands; never replace either character or the bed.
	patch(source,plain,["290,647 356,644 415,646 454,658 469,694 527,724 583,748 628,771 648,815 676,851 685,880 653,904 602,907 555,886 506,849 458,819 413,789 370,773 330,748 306,714 294,680"])
	var cut := source.duplicate() as Image
	patch(cut,read_image("cut_banner_edit.png"),["141,39 209,43 302,61 390,76 426,90 424,159 405,246 399,330 414,389 397,398 371,387 349,395 318,386 283,394 252,411 219,434 203,420 182,390 170,349 161,300 151,241 146,179"])
	var saved := source.duplicate() as Image
	patch(saved,read_image("scissors_rest_edit.png"),["303,579 319,581 336,603 367,611 406,618 455,634 460,645 441,647 388,634 350,630 331,625 314,614 305,596"])
	# A displaced tool is original source pixels, not a new drawn pair of hands.
	layer("scissors",read_image("approved_reference.png"),["304,581 314,584 325,598 331,610 352,614 458,638 457,642 348,624 329,621 318,616 308,606"])
	layer("scrap",source,["524,778 551,784 565,802 554,815 532,807 521,794"])
	layer("bandage_rolls",source,["234,731 254,724 296,725 323,735 352,738 358,760 350,772 317,778 267,768 235,752"])
	var skyline := "0,0 1672,0 1672,380 1590,397 1532,377 1510,367 1460,353 1420,342 1388,334 1354,316 1312,307 1284,303 1278,278 1261,266 1252,263 1249,233 1237,225 1223,222 1207,223 1202,240 1186,249 1184,285 1167,292 1163,306 1125,313 1120,331 1080,354 1030,370 0,520"
	# Sky visible through the actual arch openings keeps its approved pixels.
	var shell := "0,0 1054,0 1040,25 1082,34 1118,56 1136,80 1110,119 1082,168 1070,212 1065,264 1073,307 1068,353 1077,404 1080,446 1102,494 1130,537 1103,573 1070,605 1058,663 1073,690 1024,713 969,724 900,756 824,780 766,827 720,875 693,941 0,941"
	var holes := ["740,270 753,236 777,201 804,167 824,148 847,171 869,210 885,248 895,282 905,330 902,386 866,416 832,440 785,466 747,495", "513,248 526,216 544,192 562,216 578,244 587,276 592,317 584,356 568,388 546,396 526,367", "518,83 537,59 558,49 582,92 594,126 584,148 558,158 530,164"]
	# A few-pixel overscan of each shared edge keeps filtered plates watertight.
	layer("sky",source,[skyline], [shell])
	layer("sky_openings",source,holes)
	layer("distant_battlefield",source,["1020,318 1672,239 1672,738 971,770 810,682"])
	var connected_stone := "712,373 755,329 801,311 830,293 855,282 864,271 876,268 883,241 894,238 906,257 916,261 918,279 947,284 969,274 989,271 1008,296 1020,309 1059,310 1083,338 1111,356 1090,472 1014,537 890,567 770,585"
	layer("fortifications",source,[connected_stone])
	for variant in ["passed","bandages","standard"]:
		var image: Image = cut if variant=="bandages" else (saved if variant=="standard" else source)
		layer("arches_"+variant,image,[shell],["0,562 1672,562 1672,941 0,941"]+holes)
		# One watertight original-pixel plate: the opening masks contain linen
		# and stone too, and must not drift independently of their arch frame.
		layer("station_"+variant,image,[shell,connected_stone])
	layer("road",source,["0,941 646,841 751,773 854,729 1006,689 1110,645 1200,596 1319,567 1461,555 1672,564 1672,941"])
	layer("foreground",source,["1236,941 1291,879 1373,809 1433,775 1442,726 1459,673 1473,627 1505,590 1550,554 1582,538 1629,521 1672,519 1672,941", "0,779 78,831 149,868 183,941 0,941"])
	FileAccess.open(DIR+"layers.json",FileAccess.WRITE).store_string(JSON.stringify(rectangles,"  "))
	print("DRESSING_STATION_PACK_PASS: immutable source, local cloth repairs, unified station/arches plate")
	quit()
