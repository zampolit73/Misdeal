extends SceneTree
const VIEW := preload("res://scenes/travel/travel_transition.tscn")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
var destination: String
func _initialize() -> void: call_deferred("run")
func run() -> void:
	destination = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(destination)
	var orphan_baseline := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	var matrix := [["knight"],["ranger","mage"],["knight","ranger","mage"]]
	var updates: Array[int] = []
	for roles in matrix:
		var view: CanvasLayer = VIEW.instantiate()
		view.context = CATALOG.context_for("borrowed_boots","passed",roles)
		view.data_path = CATALOG.DEFAULT_LOCATION
		root.add_child(view)
		assert(view.available)
		view.set_process(false)
		for time in [0.08,0.38,0.90,1.80,3.40,3.85,4.0]:
			view.elapsed = time
			var before := Time.get_ticks_usec()
			view.update_frame()
			updates.append(Time.get_ticks_usec()-before)
			await shot("party_%d_t_%03d"%[roles.size(),int(time*100)])
		view.elapsed = 1.8
		view.update_frame()
		view.set_process(true)
		paused = true
		await process_frame
		await RenderingServer.frame_post_draw
		var frozen := root.get_texture().get_image().get_data()
		await create_timer(0.16,true).timeout
		await RenderingServer.frame_post_draw
		assert(view.elapsed == 1.8)
		assert(root.get_texture().get_image().get_data() == frozen,"Paused pixels moved")
		await shot("party_%d_paused"%roles.size())
		view.finish()
		view.finish()
		paused = false
		view.queue_free()
		await process_frame
		await process_frame
	var resize_view: CanvasLayer = VIEW.instantiate()
	resize_view.context = CATALOG.context_for("last_signal","passed",matrix[1])
	root.add_child(resize_view)
	resize_view.set_process(false)
	resize_view.elapsed = 1.8
	for size in [Vector2i(1024,768),Vector2i(1600,900)]:
		root.size = size
		await process_frame
		await process_frame
		resize_view.update_frame()
		assert(resize_view.stage.scale.x == resize_view.stage.scale.y)
		await shot("resize_%dx%d"%[size.x,size.y])
	resize_view.queue_free()
	root.size = Vector2i(1280,720)
	await process_frame
	await process_frame
	# Repeated open/skip/free must not accumulate travel nodes or decode copies.
	var nodes_before := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	for i in range(20):
		var view: CanvasLayer = VIEW.instantiate()
		view.context = CATALOG.context_for("last_signal","passed",matrix[i%3])
		root.add_child(view)
		view.finish()
		var reference: WeakRef = weakref(view)
		view.queue_free()
		await process_frame
		await process_frame
		assert(reference.get_ref() == null)
	assert(int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)) == nodes_before)
	assert(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)) == orphan_baseline)
	var textures: Dictionary = preload("res://scripts/travel/travel_panorama.gd")._textures
	assert(textures.size() == 4,"Texture cache grew on replay")
	var total := 0
	for sample in updates: total += sample
	var metrics := {"native_frames":26,"repeated_views":20,"cached_textures":textures.size(),"mean_update_usec":float(total)/updates.size(),"max_update_usec":updates.max(),"orphan_delta":int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))-orphan_baseline}
	FileAccess.open(destination.path_join("metrics.json"),FileAccess.WRITE).store_string(JSON.stringify(metrics,"  "))
	print("TRAVEL_V2_VISUAL_PASS: 26 frames; solo/duo/trio; paused pixels; 20 open/skip/free cycles; ",metrics)
	quit()
func shot(id: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(destination.path_join(id+".png"))
