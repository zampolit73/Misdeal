extends GutTest
const VIEW := preload("res://scenes/travel/travel_transition.tscn")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const PANORAMA := preload("res://scripts/travel/travel_panorama.gd")
func after_each() -> void: get_tree().paused = false
func make_view(roles: Array) -> CanvasLayer:
	var view: CanvasLayer = VIEW.instantiate()
	view.context = CATALOG.context_for("borrowed_boots","passed",roles)
	add_child(view)
	view.set_process(false)
	return view
func test_source_is_pr104_and_each_plane_has_independent_motion() -> void:
	assert_eq(FileAccess.get_sha256(PANORAMA.DIRECTORY+"source.png"),"17dfbcf2bc97045483c1ec03b92317d2feaefc43fe3f6b6ca750c75963f2f035")
	var view := make_view(["knight"])
	assert_true(view.available)
	assert_eq(view.panorama.planes.size(),6)
	view.elapsed = 0.0
	view.update_frame()
	var starts: Dictionary = {}
	for id in view.panorama.planes: starts[id] = view.panorama.planes[id].position.x
	view.elapsed = 4.0
	view.update_frame()
	var previous := -1.0
	for id in ["Sky","Mountains","Castle","Midground","Road","Foreground"]:
		var distance: float = starts[id]-view.panorama.planes[id].position.x
		assert_gt(distance,previous,id)
		previous = distance
	assert_same(view.panorama.planes.Castle.texture,PANORAMA.texture_at(PANORAMA.DIRECTORY+"source.png"))
	assert_same(view.panorama.planes.Road.texture,view.panorama.planes.Castle.texture)
	view.free()
func test_real_parties_have_grounded_soles_readable_spacing_and_no_atlas_edits() -> void:
	for roles in [["knight"],["ranger","mage"],["knight","ranger","mage"]]:
		var view := make_view(roles)
		assert_eq(view.actors.size(),roles.size())
		for frame in range(18):
			view.elapsed = frame / 6.5
			view.update_frame()
			for i in range(view.actors.size()):
				var actor: AnimatedSprite2D = view.actors[i]
				var sole: int = view._soles[roles[i]][actor.frame]
				assert_almost_eq(actor.position.y+(sole-48)*actor.scale.y,view.contacts[i].y,0.001)
				assert_false(actor.flip_h)
				if i > 0: assert_gt(view.contacts[i-1].x-view.contacts[i].x,110.0)
		view.free()
func test_pause_and_finish_freeze_all_local_animation() -> void:
	var view := make_view(["ranger","mage"])
	view.elapsed = 1.6
	view.update_frame()
	view.set_process(true)
	var frame: int = view.actors[0].frame
	var x: float = view.panorama.planes.Foreground.position.x
	get_tree().paused = true
	await get_tree().create_timer(0.08,true).timeout
	assert_eq(view.elapsed,1.6)
	assert_eq(view.actors[0].frame,frame)
	assert_eq(view.panorama.planes.Foreground.position.x,x)
	view.finish()
	get_tree().paused = false
	view._process(0.4)
	assert_eq(view.elapsed,1.6)
	view.free()
func test_enter_exit_and_all_fifteen_texts_fit_compact_reader() -> void:
	var view := make_view(["knight"])
	assert_eq(view.composition.self_modulate.a,0.0)
	view.elapsed = 1.0
	view.update_frame()
	assert_eq(view.composition.self_modulate.a,1.0)
	assert_eq(view.caption.modulate.a,1.0)
	for id in CATALOG.TEXT:
		for key in CATALOG.TEXT[id]:
			view.caption.text = CATALOG.TEXT[id][key]
			await get_tree().process_frame
			assert_lte(view.caption.get_line_count(),2,id+"/"+key)
	view.elapsed = 3.95
	view.update_frame()
	assert_eq(view.caption.modulate.a,0.0)
	assert_gt(view.exit_shade.modulate.a,0.3)
	var count := [0]
	view.finished.connect(func(): count[0]+=1)
	view.skip_button.pressed.emit()
	view.skip_button.pressed.emit()
	assert_eq(count[0],1,"Skip never waits for decorative fade")
	view.free()
func test_missing_art_is_unavailable_and_replays_reuse_texture_objects() -> void:
	assert_null(PANORAMA.texture_at("res://assets/missing-travel-art.png"))
	var bad: CanvasLayer = VIEW.instantiate()
	bad.data_path = "res://resources/missing-travel.tres"
	add_child(bad)
	assert_false(bad.available)
	bad._process(1.0)
	bad.free()
	var damaged := preload("res://scripts/data/travel_transition_data.gd").new()
	damaged.underpaint_path = "res://assets/missing-travel-art.png"
	var temporary := "user://travel_v2_missing_art_qa.tres"
	assert_eq(ResourceSaver.save(damaged,temporary),OK)
	bad = VIEW.instantiate()
	bad.data_path = temporary
	add_child(bad)
	assert_false(bad.available,"Missing required art must route via fallback")
	bad._process(1.0)
	bad.free()
	DirAccess.remove_absolute(temporary)
	var first := make_view(["mage"])
	var texture: Texture2D = first.panorama.planes.Castle.texture
	first.free()
	for i in range(8):
		var view := make_view(["knight","ranger","mage"])
		assert_same(view.panorama.planes.Castle.texture,texture)
		var reference: WeakRef = weakref(view)
		view.queue_free()
		await get_tree().process_frame
		assert_null(reference.get_ref())
	assert_eq(PANORAMA._textures.size(),4)
