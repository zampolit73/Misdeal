extends SceneTree
## Native production V2 overlays with a full party for artistic comparison.
const QA := preload("res://scripts/dev/travel_batch02_playtest.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var dest := OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(dest)
	for index in range(31):
		var spec: Array=QA.CASES[index]
		var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context=QA.context_for_case(index,["knight","ranger","mage"])
		root.add_child(view)
		view.set_process(false)
		assert(view.available)
		for moment in [0.65,1.15,2.50]:
			view.elapsed=moment
			view.update_frame()
			await process_frame
			await RenderingServer.frame_post_draw
			assert(root.get_texture().get_image().save_png(dest.path_join("%02d_%s_%s_%03d.png" % [index+1,spec[0],spec[1],int(round(moment*100))]))==OK)
		view.queue_free()
		await process_frame
	var sheet := Image.create(1280,1440,false,Image.FORMAT_RGB8)
	for index in range(31):
		var spec: Array=QA.CASES[index]
		var frame := Image.load_from_file(dest.path_join("%02d_%s_%s_250.png" % [index+1,spec[0],spec[1]]))
		frame.convert(Image.FORMAT_RGB8)
		frame.resize(320,180,Image.INTERPOLATE_LANCZOS)
		sheet.blit_rect(frame,Rect2i(0,0,320,180),Vector2i(index%4*320,index/4*180))
	sheet.save_png(dest.path_join("contact_sheet.png"))
	print("BATCH02_REVIEW_PASS: 31 production overlays, full party, 93 native frames")
	quit()
