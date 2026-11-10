extends SceneTree
func _initialize() -> void:
	var selections: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/pixel/events/final_five/manifest.json")).selection
	for id in selections:
		var base: String = "res://assets/pixel/events/final_five/" + id + "/"
		DirAccess.make_dir_recursive_absolute(base)
		var source := Image.load_from_file("res://assets/pixel/events/final_five/sources/"+id+"/option_"+str(int(selections[id]))+".png")
		for spec in [["card",448,274],["backdrop",1280,720]]:
			var fitted := source.duplicate() as Image
			var scale: float = minf(float(spec[1])/source.get_width(),float(spec[2])/source.get_height())
			fitted.resize(roundi(source.get_width()*scale),roundi(source.get_height()*scale),Image.INTERPOLATE_LANCZOS)
			var canvas := Image.create(spec[1],spec[2],false,Image.FORMAT_RGB8)
			canvas.fill(Color("100e0e"))
			canvas.blit_rect(fitted,Rect2i(Vector2i.ZERO,fitted.get_size()),(canvas.get_size()-fitted.get_size())/2)
			assert(canvas.save_webp(base+spec[0]+".webp",false)==OK)
	quit()
