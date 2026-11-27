extends GutTest

const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const B2 := preload("res://scripts/dev/travel_batch02_playtest.gd")
const B3 := preload("res://scripts/dev/travel_batch03_playtest.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const TRIO := ["knight", "ranger", "mage"]


func after_each() -> void:
	get_tree().paused = false


func _view(context: Dictionary) -> CanvasLayer:
	var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = context
	add_child(view)
	view.set_process(false)
	assert_true(view.available, str(context))
	return view


func _world(view: CanvasLayer) -> Transform2D:
	return view.panorama._world if view.context.resolved_card_id == "whispering_well" else view.panorama.world


func _sample(view: CanvasLayer, time: float) -> void:
	view.elapsed = time
	view.update_frame()


func test_distance_clock_stops_on_stationary_section_and_is_seekable() -> void:
	var path := func(time: float) -> Vector2: return Vector2(maxf(0.0, time - 1.0) * 40.0, 0.0)
	var height := func(_position: Vector2) -> float: return 200.0
	var track := V3.gait(path, height, 4.0)
	assert_almost_eq(V3.phase(track, 0.0), V3.phase(track, 1.0), 0.0001)
	assert_gt(V3.phase(track, 2.0), V3.phase(track, 1.0))
	assert_gt(V3.phase(track, 4.0), V3.phase(track, 3.0))
	assert_eq(V3.phase(track, 2.0), V3.phase(track, 2.0), "No accumulated or wall-clock state")
	assert_eq(V3.support_index(2.99), 0)
	assert_eq(V3.support_index(3.0), 1)
	assert_eq(V3.support_index(6.0), 2)


func test_all_19_outcomes_use_existing_art_and_move_grounded() -> void:
	var before: Dictionary = SAVE.new().snapshot(RunState).state
	var contexts: Array[Dictionary] = []
	for index in B2.CASES.size():
		if B2.CASES[index][0] in ["blood_ledger", "rattling_bridge"]:
			contexts.append(B2.context_for_case(index, TRIO))
	var cases: Array = B3.cases()
	for index in cases.size():
		if cases[index][0] == "whispering_well":
			contexts.append(B3.context_for_case(index, TRIO))
	assert_eq(contexts.size(), 19)
	for context in contexts:
		var view := _view(context)
		assert_true(view.panorama.pilot_active)
		assert_not_null(view.panorama.pilot_base.texture)
		assert_eq(view.panorama.pilot_base.material.shader, V3.LIGHT)
		var former: Array[Vector2] = []
		var previous_phases: Array[float] = []
		var previous_visibility: Array[bool] = []
		for time in [0.0, 0.4, 0.9, 1.12, 1.6, 2.4, 3.2, 3.9]:
			_sample(view, time)
			var world := _world(view)
			assert_true(world.origin.x <= 0.0 and world.origin.y <= 0.0)
			assert_true((world * V3.STAGE).x >= V3.STAGE.x and (world * V3.STAGE).y >= V3.STAGE.y)
			assert_eq(view.panorama.pilot_base.transform, world)
			assert_eq(view.panorama.pilot_base.material.get_shader_parameter("elapsed"), time)
			var next_positions: Array[Vector2] = []
			var phases: Array[float] = []
			var visibility: Array[bool] = []
			for i in view.actors.size():
				var actor: AnimatedSprite2D = view.actors[i]
				var local: Vector2 = world.affine_inverse() * view.contacts[i]
				var phase: float = view.ground_fx.gait_phases[i]
				next_positions.append(local)
				phases.append(phase)
				visibility.append(actor.visible)
				if actor.visible:
					var role: String = view.role_ids[i]
					var sole: float = view.panorama.soles[role][actor.frame]
					assert_almost_eq(actor.position.y + (sole - 48.0) * actor.scale.y, view.contacts[i].y, 0.002, role)
					if not former.is_empty() and previous_visibility[i]:
						assert_gt(local.distance_to(former[i]), 0.05, "%s %s stationary %s" % [context.resolved_card_id, context.visual_action, role])
						assert_gt(phase, previous_phases[i], "Only advance gait with travel")
				else:
					assert_eq(view.ground_fx.contact_scales[i], 0.0)
			former = next_positions
			previous_phases = phases
			previous_visibility = visibility
		get_tree().paused = true
		var phase_frozen: float = view.panorama.pilot_lead_phase
		var frozen: Transform2D = _world(view)
		view._process(0.1)
		assert_eq(view.panorama.pilot_lead_phase, phase_frozen)
		assert_eq(_world(view), frozen)
		get_tree().paused = false
		var finished := [0]
		view.finished.connect(func(): finished[0] += 1)
		view.finish()
		view.finish()
		assert_eq(finished[0], 1)
		view.free()
	assert_eq(SAVE.new().snapshot(RunState).state, before)


func test_rear_walk_solo_duo_trio_and_jack_continuity() -> void:
	for roles in [["knight"], ["knight", "ranger"], TRIO]:
		var context: Dictionary = CATALOG.context_for("blood_ledger", "gold", roles, "", false,
			{"visual_action": "gold", "jack_companion": true})
		var view := _view(context)
		assert_eq(view.role_ids, roles)
		_sample(view, 0.0)
		var starts: Array = []
		for i in roles.size():
			starts.append(_world(view).affine_inverse() * view.contacts[i])
		_sample(view, 0.4)
		for i in roles.size():
			assert_gt((_world(view).affine_inverse() * view.contacts[i]).distance_to(starts[i]), 0.5,
				"Every already-present hero moves from the start")
		if "ranger" in roles:
			assert_true(context.jack_companion)
			assert_true(is_instance_valid(view.panorama.pilot_jack))
			assert_true(view.panorama.pilot_jack.visible)
			assert_lt(view.ground_fx.get_index(), view.panorama.pilot_jack.get_index())
			assert_lt(view.panorama.pilot_jack.get_index(), view.panorama.planes.Foreground.get_index())
		else:
			assert_false(context.jack_companion)
			assert_null(view.panorama.pilot_jack)
		view.free()


func test_rescue_handoff_and_companion_never_duplicate_waiting_actor() -> void:
	var well := _view(CATALOG.context_for("whispering_well", "", TRIO, "", false,
		{"batch_03_action": "rescue_gold", "jack_companion": true}))
	var mage: int = well.role_ids.find("mage")
	_sample(well, 1.11)
	assert_false(well.actors[mage].visible)
	assert_true(well.panorama.npc_visible)
	assert_eq(well.ground_fx.contact_scales[mage], 0.0)
	_sample(well, 1.12)
	assert_true(well.actors[mage].visible)
	assert_false(well.panorama.npc_visible)
	assert_true(well.panorama._jack.visible)
	well.free()
	var bridge := _view(CATALOG.context_for("rattling_bridge", "", TRIO, "", false,
		{"visual_action": "recruit", "recruitment": true}))
	var ranger: int = bridge.role_ids.find("ranger")
	_sample(bridge, 0.89)
	assert_false(bridge.actors[ranger].visible)
	assert_true(bridge.panorama.npc_visible)
	_sample(bridge, 0.90)
	assert_true(bridge.actors[ranger].visible)
	assert_false(bridge.panorama.npc_visible)
	_sample(bridge, 3.0)
	var before: Vector2 = _world(bridge).affine_inverse() * bridge.contacts[ranger]
	_sample(bridge, 3.6)
	assert_gt((_world(bridge).affine_inverse() * bridge.contacts[ranger]).distance_to(before), 0.1)
	bridge.free()


func test_rollout_locations_use_v3_and_pilot_cues_keep_authored_beats() -> void:
	var candle := _view(B2.context_for_case(0, TRIO))
	assert_true(candle.panorama.pilot_active)
	assert_not_null(candle.panorama.pilot_base)
	candle.free()
	var bone_tax := _view(CATALOG.context_for("bone_tax", "", TRIO, "", false, {"batch_03_action": "gold"}))
	assert_true(bone_tax.panorama.pilot_active)
	assert_not_null(bone_tax.panorama.pilot_base)
	bone_tax.free()
	assert_eq(V3.action_time("whispering_well", "rescue_gold"), 1.12)
	assert_eq(V3.action_cue("whispering_well", "rescue_gold"), "coins")
	assert_eq(V3.action_cue("whispering_well", "leave"), "")
	assert_eq(V3.action_cue("blood_ledger", "leave"), "paper")
	assert_eq(V3.action_cue("rattling_bridge", "careful"), "creak")


func test_pilot_sound_cues_follow_gait_and_action_not_a_free_timer() -> void:
	var view := _view(CATALOG.context_for("rattling_bridge", "rush", ["knight"], "", false,
		{"visual_action": "rush", "roll_success": true}))
	_sample(view, 0.77)
	view._play_pilot_cues(0.70, "rattling_bridge")
	var creaks := 0
	for child in view.get_children():
		if child is AudioStreamPlayer and child.stream != null and child.stream.resource_path.ends_with("creak.ogg"):
			creaks += 1
	assert_eq(creaks, 0, "The outcome beat has not happened")
	_sample(view, 0.79)
	view._play_pilot_cues(0.77, "rattling_bridge")
	var support: int = view._pilot_last_support
	assert_eq(support, V3.support_index(view.panorama.pilot_lead_phase))
	view._play_pilot_cues(0.79, "rattling_bridge")
	var after_creaks := 0
	for child in view.get_children():
		if child is AudioStreamPlayer and child.stream != null and child.stream.resource_path.ends_with("creak.ogg"):
			after_creaks += 1
	assert_eq(after_creaks, 1, "Exactly one authored beat")
	_sample(view, 2.8)
	view._play_pilot_cues(0.79, "rattling_bridge")
	assert_gt(view._pilot_last_support, support)
	view.finish()
	for child in view.get_children():
		if child is AudioStreamPlayer:
			assert_false(child.playing)
	view.free()
