extends SceneTree
## Technical alpha cleanup/packing of 18 authored rear poses, never D412 edits.
const DIR := "res://assets/pixel/travel/campfire_without_master/rear_walk/"
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var source := Image.new()
	assert(source.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+"source.png"))==OK)
	source.convert(Image.FORMAT_RGBA8)
	var soles: Dictionary = {}
	for row in range(3):
		var role: String = ["knight","ranger","mage"][row]
		var cells: Array[Image] = []
		var max_height := 0
		for frame in range(6):
			var x0 := roundi(frame*source.get_width()/6.0)
			var x1 := roundi((frame+1)*source.get_width()/6.0)
			var y0 := roundi(row*source.get_height()/3.0)
			var y1 := roundi((row+1)*source.get_height()/3.0)
			var cell := source.get_region(Rect2i(x0,y0,x1-x0,y1-y0))
			for y in range(cell.get_height()):
				for x in range(cell.get_width()):
					var c := cell.get_pixel(x,y)
					# Only bright matte spill, not the actual dark crimson cape.
					if c.a<0.25 or (c.r>0.72 and c.g<0.18 and c.b<0.18) or (c.g>0.65 and c.r<0.2 and c.b<0.2):
						cell.set_pixel(x,y,Color.TRANSPARENT)
			max_height = maxi(max_height,cell.get_used_rect().size.y)
			cells.append(cell)
		var atlas := Image.create(576,96,false,Image.FORMAT_RGBA8)
		var factor := (76.0 if role=="knight" else 74.0)/max_height
		var heights: Array[int] = []
		var distinct: Dictionary = {}
		for frame in range(6):
			var cell := cells[frame]
			var top := cell.get_used_rect().position.y
			cell.resize(roundi(cell.get_width()*factor),roundi(cell.get_height()*factor),Image.INTERPOLATE_NEAREST)
			var padded := Image.create(96,96,false,Image.FORMAT_RGBA8)
			padded.blit_rect(cell,Rect2i(Vector2i.ZERO,cell.get_size()),Vector2i((96-cell.get_width())/2,10-roundi(top*factor)))
			var bottom := 80
			for y in range(94,50,-1):
				var found := false
				for x in range(26,70):
					if padded.get_pixel(x,y).a>0.5: found=true; break
				if found: bottom=y; break
			heights.append(bottom)
			distinct[hash(padded.get_data())]=true
			var bounds := padded.get_used_rect()
			assert(bounds.position.x>0 and bounds.position.y>0 and bounds.end.x<96 and bounds.end.y<96,"Rear walk must have transparent margins")
			atlas.blit_rect(padded,Rect2i(0,0,96,96),Vector2i(frame*96,0))
		assert(distinct.size()==6,"Six distinct authored walk poses required")
		atlas.save_png(DIR+role+".png")
		soles[role]=heights
	FileAccess.open(DIR+"soles.json",FileAccess.WRITE).store_string(JSON.stringify(soles,"  "))
	print("CAMPFIRE_REAR_PACK_PASS: 18 distinct rear poses, 96px cells, transparent margins")
	quit()

