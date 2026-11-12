extends GutTest
const VIEW := preload("res://scenes/travel/travel_transition.tscn")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const POST := preload("res://scripts/travel/posthouse_panorama.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const DIR := "res://assets/pixel/travel/last_dawn_posthouse/"
func after_each() -> void:
	get_tree().paused = false
	RunState.reset_run()
func make_view(outcome: String, roles: Array = ["knight","ranger","mage"]) -> CanvasLayer:
	var view: CanvasLayer = VIEW.instantiate()
	view.context = CATALOG.context_for("unsent_letters",outcome,roles)
	add_child(view)
	view.set_process(false)
	return view
func test_exact_approved_source_and_card_to_resource_selection() -> void:
	assert_eq(FileAccess.get_sha256(DIR+"approved_reference.png"),"e4a3f62457071e431e7d01b739925db44a3ae9c8da4a13d51928e2f790d10bf5")
	for outcome in ["release","read","passed"]:
		var context := CATALOG.context_for("unsent_letters",outcome,["ranger"])
		assert_eq(CATALOG.resource_for(context),"res://resources/travel/last_dawn_posthouse.tres")
	for id in ["false_weights","last_signal","graveyard_ambush"]:
		assert_eq(CATALOG.resource_for({"resolved_card_id":id}),CATALOG.DEFAULT_LOCATION)
	assert_true(CATALOG.context_for("unsent_letters","wrong",["knight"]).is_empty())
func test_twenty_real_bone_poses_with_distinct_flight_and_clear_margins() -> void:
	var atlas := POST.texture_at(DIR+"bone_pigeon.png").get_image()
	assert_eq(atlas.get_size(),Vector2i(960,768))
	var unique: Dictionary = {}
	var heights: Array[int] = []
	for i in range(20):
		var frame := atlas.get_region(Rect2i(i%5*192,i/5*192,192,192))
		var bounds := frame.get_used_rect()
		assert_true(bounds.has_area())
		assert_gt(bounds.position.x,1)
		assert_gt(bounds.position.y,1)
		assert_lt(bounds.end.x,191)
		assert_lt(bounds.end.y,191)
		unique[hash(frame.get_data())] = true
		if i>=10: heights.append(bounds.size.y)
	assert_eq(unique.size(),20)
	assert_gt(float(heights.max()),float(heights.min())*1.3,"Wings need a real up/down stroke")
func test_release_launches_one_bird_and_one_letter_once() -> void:
	var view := make_view("release")
	assert_true(view.available)
	var fx: Node2D = view.panorama.reactions
	assert_eq(fx.bird.get_child_count(),1)
	var poses: Dictionary = {}
	for tick in range(81):
		view.elapsed = tick * 0.05
		view.update_frame()
		if view.elapsed>=1.4 and view.elapsed<2.8: poses[fx.bird.frame]=true
	assert_eq(fx.launch_count,1)
	assert_eq(poses.size(),10)
	assert_false(fx.bird.visible)
	assert_same(fx.letter.get_parent(),fx.bird)
	assert_false(fx.paper.visible)
	view.free()
func test_read_and_passed_stay_perched_and_have_distinct_props() -> void:
	for outcome in ["read","passed"]:
		var view := make_view(outcome)
		var fx: Node2D = view.panorama.reactions
		for time in [0.0,0.4,1.8,3.9]:
			view.elapsed = time
			view.update_frame()
			assert_eq(fx.bird.position,fx.REST)
			assert_true(fx.bird.visible)
			assert_false(fx.letter.visible)
			assert_eq(fx.paper.visible,outcome=="read")
		assert_eq(fx.launch_count,0)
		for material in view.panorama.materials: assert_eq(material.get_shader_parameter("passed"),outcome=="passed")
		view.free()
func test_all_parties_outcomes_are_read_only_grounded_and_pause_safe() -> void:
	RunState.choose_protagonist("knight")
	var before: Dictionary = SAVE.new().snapshot(RunState).state
	for outcome in ["release","read","passed"]:
		for roles in [["knight"],["ranger","mage"],["knight","ranger","mage"]]:
			var view := make_view(outcome,roles)
			assert_eq(view.actors.size(),roles.size())
			assert_eq(view.panorama.planes.size(),7)
			view.elapsed=1.8
			view.update_frame()
			for i in range(view.actors.size()):
				var actor: AnimatedSprite2D = view.actors[i]
				assert_almost_eq(actor.position.y+(view._soles[roles[i]][actor.frame]-48)*actor.scale.y,view.contacts[i].y,0.001)
			view.set_process(true)
			get_tree().paused=true
			var point: Vector2=view.panorama.reactions.bird.position
			var frame: int=view.panorama.reactions.bird.frame
			await get_tree().create_timer(0.03,true).timeout
			assert_lte(view.caption.size.x,960.0,"Posthouse narration must stay in the V2 reader")
			assert_lte(view.caption.get_line_count(),2)
			assert_eq(view.elapsed,1.8)
			assert_eq(view.panorama.reactions.bird.position,point)
			assert_eq(view.panorama.reactions.bird.frame,frame)
			view.finish()
			get_tree().paused=false
			assert_eq(SAVE.new().snapshot(RunState).state,before)
			view.free()
func test_source_pigeon_removed_patch_and_replay_cache_are_bounded() -> void:
	var reference := POST.texture_at(DIR+"approved_reference.png").get_image()
	var patch := POST.texture_at(DIR+"perch_patch.png").get_image()
	var runtime := POST.texture_at(DIR+"posthouse.png").get_image()
	var before := 0
	var after := 0
	var baked := 0
	for y in range(12,58):
		for x in range(10,92):
			var a := reference.get_pixel(x+710,y+140)
			var b := patch.get_pixel(x,y)
			var c := runtime.get_pixel(x+710,y+140)
			if a.r>a.b+0.05 and a.g<0.55: before+=1
			if b.r>b.b+0.05 and b.g<0.55: after+=1
			if c.r>c.b+0.05 and c.g<0.55: baked+=1
	assert_gt(before,100)
	assert_lt(after,before/4,"Ordinary pigeon cannot remain in the backing art")
	assert_lt(baked,before/4,"Runtime posthouse pixels must already have the ordinary bird removed")
	var view := make_view("read")
	var tex: Texture2D=view.panorama.reactions.bird.texture
	view.free()
	var size := POST._textures.size()
	for i in range(10):
		view=make_view(["release","read","passed"][i%3])
		assert_same(view.panorama.reactions.bird.texture,tex)
		var ref: WeakRef=weakref(view)
		view.queue_free()
		await get_tree().process_frame
		assert_null(ref.get_ref())
	assert_eq(POST._textures.size(),size)
