extends SceneTree
# Deterministic format/cell packing only. Original generated paintings remain intact.
func _initialize() -> void:
	var source := Image.new()
	assert(source.load_png_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/events/jack/approved_source.png")) == OK)
	source.convert(Image.FORMAT_RGBA8)
	for detail in {"pass":Rect2i(760,400,700,428),"token":Rect2i(360,380,320,220)}:
		var crop := source.get_region({"pass":Rect2i(760,400,700,428),"token":Rect2i(360,380,320,220)}[detail])
		crop.resize(448,274,Image.INTERPOLATE_LANCZOS)
		crop.save_webp("res://assets/pixel/events/jack/"+detail+".webp",false)
	var card := source.duplicate() as Image
	# Fit the full approved painting; no subject cropping or color treatment.
	card.resize(411,274,Image.INTERPOLATE_LANCZOS)
	var card_canvas := Image.create(448,274,false,Image.FORMAT_RGBA8)
	card_canvas.fill(Color("100d0e"))
	card_canvas.blit_rect(card,Rect2i(Vector2i.ZERO,card.get_size()),Vector2i(18,0))
	card_canvas.save_webp("res://assets/pixel/events/jack/card.webp",false)
	var encoded := FileAccess.open("res://assets/pixel/events/jack/card.webp.b64",FileAccess.WRITE)
	encoded.store_string(Marshalls.raw_to_base64(card_canvas.save_webp_to_buffer(false)))
	encoded.close()
	source.resize(1080,720,Image.INTERPOLATE_LANCZOS)
	var backdrop := Image.create(1280,720,false,Image.FORMAT_RGBA8)
	backdrop.fill(Color("100d0e"))
	backdrop.blit_rect(source,Rect2i(Vector2i.ZERO,source.get_size()),Vector2i(100,0))
	backdrop.save_webp("res://assets/pixel/events/jack/backdrop.webp",false)
	var board := Image.new()
	assert(board.load_png_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/units/jack/source.png")) == OK)
	board.convert(Image.FORMAT_RGBA8)
	var atlas := Image.create(576,480,false,Image.FORMAT_RGBA8)
	atlas.fill(Color.TRANSPARENT)
	var counts := [4,6,6,3,6]
	var drawings: Array[Image] = []
	var largest_width := 0
	var largest_height := 0
	for row in range(5):
		for col in range(counts[row]):
			var left := roundi(col * board.get_width()/6.0)
			var top := roundi(row * board.get_height()/5.0)
			var right := roundi((col+1)*board.get_width()/6.0)
			var bottom := roundi((row+1)*board.get_height()/5.0)
			var cell := board.get_region(Rect2i(left,top,right-left,bottom-top))
			var bounds := cell.get_used_rect()
			assert(bounds.has_area(),"Missing original pose")
			var drawing := cell.get_region(bounds)
			drawings.append(drawing)
			largest_width = maxi(largest_width,drawing.get_width())
			largest_height = maxi(largest_height,drawing.get_height())
	var factor := minf(80.0/largest_width,76.0/largest_height)
	var index := 0
	for row in range(5):
		for col in range(counts[row]):
			var drawing := drawings[index]
			drawing.resize(maxi(1,roundi(drawing.get_width()*factor)),maxi(1,roundi(drawing.get_height()*factor)),Image.INTERPOLATE_LANCZOS)
			atlas.blit_rect(drawing,Rect2i(Vector2i.ZERO,drawing.get_size()),Vector2i(col*96+(96-drawing.get_width())/2,row*96+91-drawing.get_height()))
			index += 1
	atlas.save_png("res://assets/pixel/units/jack/atlas.png")
	var file := FileAccess.open("res://assets/pixel/units/jack/atlas.webp.b64",FileAccess.WRITE)
	file.store_string(Marshalls.raw_to_base64(atlas.save_webp_to_buffer(false)))
	file.close()
	print("JACK_PACK_PASS: 25 source poses, five clear cells; approved painting preserved")
	quit()
