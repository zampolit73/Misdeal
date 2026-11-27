extends GutTest

const B2 := preload("res://scripts/dev/travel_batch02_playtest.gd")
const B3 := preload("res://scripts/dev/travel_batch03_playtest.gd")
const STAGING := preload("res://scripts/travel/travel_staging_v4.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const TRIO := ["knight", "ranger", "mage"]

func _view(context: Dictionary) -> CanvasLayer:
	var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = context
	add_child(view)
	view.set_process(false)
	assert_true(view.available, str(context))
	return view

func _sample(view: CanvasLayer, time: float) -> void:
	view.elapsed = time
	view.update_frame()

func test_batch02_routes_and_projected_heights_are_independent_of_outcome() -> void:
	var reference := {}
	for i in B2.CASES.size():
		var context := B2.context_for_case(i, TRIO)
		var id: String = context.resolved_card_id
		if id == "rattling_bridge" and context.visual_action in ["recruit", "loot_recruitment", "abandon"]:
			continue # Changed party shape has its own legitimate formation.
		var view := _view(context)
		if not view.available:
			view.free()
			continue
		_sample(view, 1.5)
		var snapshot := {"contacts":view.contacts.duplicate(), "scale":[]}
		for actor in view.actors:
			snapshot.scale.append(actor.scale)
		if reference.has(id):
			assert_eq(snapshot, reference[id], id)
		else:
			reference[id] = snapshot
		view.free()
	assert_eq(reference.size(), 7)

func test_profile_route_is_seekable_and_depth_controls_height() -> void:
	for id in STAGING.DATA.data:
		var p := STAGING.profile(id)
		var near := STAGING.point(p.route[0])
		assert_almost_eq(STAGING.height(p, near), float(p.height), 0.001, id)
		if p.route[2][1] < p.route[0][1]:
			assert_lt(STAGING.height(p, STAGING.point(p.route[2])), float(p.height), id)
		for count in [1, 2, 3]:
			for rank in count:
				var before := STAGING.foot_at(0.0, p, 4.0, rank, count)
				for i in range(1, 21):
					var foot := STAGING.foot_at(i * 0.2, p, 4.0, rank, count)
					assert_gt(foot.distance_to(before), 0.05, id)
					assert_true(Rect2(20, 280, 1240, 435).has_point(foot), "%s %s" % [id,foot])
					before = foot

func test_elevated_recruits_keep_ground_stature_and_never_emit_floating_dust() -> void:
	for id in ["black_altar", "whispering_well"]:
		var context := CATALOG.context_for(id, "", TRIO, "", false, {"batch_03_action":"rescue_gold"})
		var view := _view(context)
		var i: int = view.role_ids.find("mage")
		var beat: float = view.panorama._handoff_time
		_sample(view, beat - 0.01)
		assert_false(view.actors[i].visible, id)
		_sample(view, beat)
		assert_true(view.actors[i].visible, id)
		assert_eq(view.ground_fx.contact_scales[i], 0.0, id)
		var scale: float = view.actors[i].scale.x / view.panorama._world.x.length()
		_sample(view, beat + 0.25)
		assert_almost_eq(view.actors[i].scale.x / view.panorama._world.x.length(), scale, 0.002, id)
		view.free()

func test_prisoner_handoff_progresses_toward_the_open_floor_without_reversal() -> void:
	var view := _view(CATALOG.context_for("chained_prisoner", "", TRIO, "", false, {"batch_03_action":"recruit"}))
	var i: int = view.role_ids.find("knight")
	var last := Vector2.ZERO
	for time in [1.04, 1.5, 2.0, 2.5, 3.0, 3.8]:
		_sample(view, time)
		var foot: Vector2 = view.panorama._world.affine_inverse() * view.contacts[i]
		assert_gte(foot.x, last.x, "No backtracking into the cell")
		assert_gte(foot.y, last.y, "Exit onto the corridor floor")
		last = foot
	view.free()
