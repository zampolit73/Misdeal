extends SceneTree
const VIEW := preload("res://scenes/travel/travel_transition.tscn")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
var dest: String
var frame_count := 0
func _initialize() -> void: call_deferred("run")
func run() -> void:
	dest = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(dest)
	for outcome in ["release","read","passed"]:
		var view: CanvasLayer = VIEW.instantiate()
		view.context = CATALOG.context_for("unsent_letters",outcome,["knight","ranger","mage"])
		root.add_child(view)
		assert(view.available)
		view.set_process(false)
		for time in [0.4,0.8,1.3,1.8,2.5,3.4,3.95]:
			view.elapsed = time
			view.update_frame()
			await shot(outcome+"_%03d"%int(time*100))
		if outcome=="release":
			for pose in range(10):
				view.elapsed=1.4+(pose+0.1)/24.0
				view.update_frame()
				await shot("flight_%02d"%pose)
		view.elapsed=1.8
		view.update_frame()
		view.set_process(true)
		paused=true
		await process_frame
		await RenderingServer.frame_post_draw
		var frozen := root.get_texture().get_image().get_data()
		await create_timer(0.12,true).timeout
		await RenderingServer.frame_post_draw
		assert(view.elapsed==1.8)
		assert(root.get_texture().get_image().get_data()==frozen,"Paused posthouse changed pixels")
		await shot(outcome+"_paused")
		paused=false
		view.set_process(false)
		for actor in view.actors: actor.visible=false
		view.ground_fx.visible=false
		await shot(outcome+"_base")
		view.queue_free()
		await process_frame
		await process_frame
	for outcome in ["release","read","passed"]:
		for roles in [["knight"],["ranger","mage"]]:
			var view: CanvasLayer = VIEW.instantiate()
			view.context=CATALOG.context_for("unsent_letters",outcome,roles)
			root.add_child(view)
			view.set_process(false)
			view.elapsed=1.8
			view.update_frame()
			await shot(outcome+"_party_%d"%roles.size())
			view.queue_free()
			await process_frame
			await process_frame
	var baseline := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var orphans := int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))
	for i in range(20):
		var view: CanvasLayer = VIEW.instantiate()
		view.context=CATALOG.context_for("unsent_letters",["release","read","passed"][i%3],["knight","ranger","mage"])
		root.add_child(view)
		view.finish()
		view.finish()
		var reference: WeakRef = weakref(view)
		view.queue_free()
		await process_frame
		await process_frame
		assert(reference.get_ref()==null)
	assert(int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))==baseline)
	assert(int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))==orphans)
	var count: int=preload("res://scripts/travel/posthouse_panorama.gd")._textures.size()
	assert(count==11)
	FileAccess.open(dest.path_join("metrics.json"),FileAccess.WRITE).store_string(JSON.stringify({"native_frames":frame_count,"replay_cycles":20,"textures":count,"node_delta":int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))-baseline,"orphan_delta":int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT))-orphans},"  "))
	print("POSTHOUSE_VISUAL_PASS: ",frame_count," frames; all three outcomes/parties; paused pixels; 20 replay/free cycles; 11 shared textures")
	quit()
func shot(id: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join(id+".png"))
	frame_count+=1
