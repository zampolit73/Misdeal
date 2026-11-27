extends GutTest

const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const B2 := preload("res://scripts/dev/travel_batch02_playtest.gd")
const B3 := preload("res://scripts/dev/travel_batch03_playtest.gd")
const P1 := preload("res://scripts/dev/travel_pilot_batch01_playtest.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const TRIO := ["knight", "ranger", "mage"]
const EARLIER := {
	"unsent_letters": ["release", "read", "passed"],
	"banner_seamstress": ["bandages", "standard", "passed"],
	"borrowed_boots": ["repair", "hobnails", "passed"],
	"false_weights": ["fair", "silence", "passed"],
}

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

func _contexts() -> Array[Dictionary]:
	var contexts: Array[Dictionary] = []
	for i in B2.CASES.size():
		contexts.append(B2.context_for_case(i, TRIO))
	for i in B3.cases().size():
		contexts.append(B3.context_for_case(i, TRIO))
	for i in P1.CASES.size():
		contexts.append(P1.context_for_case(i, TRIO))
	for id in EARLIER:
		for action in EARLIER[id]:
			contexts.append(CATALOG.context_for(id, action, TRIO))
	return contexts

func _sole(view: CanvasLayer, actor: AnimatedSprite2D, role: String) -> float:
	if view.panorama.get("soles") is Dictionary:
		return float(view.panorama.soles[role][actor.frame])
	if view.panorama.get("walk") != null:
		return float(view.panorama.walk.soles[role][actor.frame])
	return float(view._soles[role][actor.frame])

func test_all_126_outcomes_use_grounded_distance_clock_and_are_read_only() -> void:
	var contexts := _contexts()
	assert_eq(contexts.size(), 126)
	var locations := {}
	var before: Dictionary = SAVE.new().snapshot(RunState).state
	for context in contexts:
		var id: String = context.resolved_card_id
		locations[id] = true
		assert_true(V3.enabled(id), id)
		var view := _view(context)
		if not view.available:
			view.free()
			continue
		var previous: Array[float] = []
		var previous_feet: Array[Vector2] = []
		var previous_visible: Array[bool] = []
		for time in [0.0, 0.40, 1.3, 2.45, 3.8]:
			_sample(view, time)
			assert_eq(view.ground_fx.gait_phases.size(), view.actors.size(), id)
			var phases: Array[float] = []
			var feet: Array[Vector2] = []
			var visibility: Array[bool] = []
			for i in view.actors.size():
				var actor: AnimatedSprite2D = view.actors[i]
				var phase: float = view.ground_fx.gait_phases[i]
				var foot: Vector2 = view.contacts[i]
				phases.append(phase)
				feet.append(foot)
				visibility.append(actor.visible)
				assert_true(is_finite(phase), id)
				if actor.visible:
					assert_almost_eq(actor.position.y + (_sole(view, actor, view.role_ids[i]) - 48.0) * actor.scale.y, foot.y, 0.003, id)
					if not previous.is_empty() and previous_visible[i]:
						assert_gt(phase, previous[i], "%s %s must advance" % [id, view.role_ids[i]])
						assert_gt(foot.distance_to(previous_feet[i]), 0.05, id)
				else:
					assert_eq(view.ground_fx.contact_scales[i], 0.0, id)
			previous = phases
			previous_feet = feet
			previous_visible = visibility
		_sample(view, 1.3)
		var seek: Array = view.ground_fx.gait_phases.duplicate()
		_sample(view, 3.8)
		_sample(view, 1.3)
		assert_eq(view.ground_fx.gait_phases, seek, id + " deterministic seek")
		view.free()
	assert_eq(locations.size(), 24)
	assert_eq(locations.keys().size(), V3.LOCATIONS.size())
	assert_eq(SAVE.new().snapshot(RunState).state, before)
	assert_false(V3.enabled("bone_warden"))
	assert_false(V3.enabled("generic_battle_road"))

func test_companion_continuity_for_all_24_locations_without_extra_hero_slots() -> void:
	var seen := {}
	for context in _contexts():
		var id: String = context.resolved_card_id
		if seen.has(id) or "ranger" not in context.party_roles:
			continue
		if id == "jack" and context.visual_action != "recruited":
			continue
		context["jack_companion"] = true
		var view := _view(context)
		if not view.available:
			view.free()
			continue
		_sample(view, 2.0)
		var dog := view.composition.get_node_or_null("TravelJack") as AnimatedSprite2D
		assert_not_null(dog, id)
		if dog != null:
			assert_true(dog.visible, id)
			assert_eq(view.actors.size(), context.party_roles.size(), id)
			assert_lt(view.ground_fx.get_index(), dog.get_index(), id)
			assert_lt(dog.get_index(), view.panorama.planes.Foreground.get_index(), id)
		view.free()
		seen[id] = true
	assert_eq(seen.size(), 24)

func test_real_companion_flag_and_recruit_handoffs_remain_authoritative() -> void:
	for id in ["lost_purse", "false_weights", "wizard_tithe"]:
		var action := "safe" if id == "lost_purse" else ("fair" if id == "false_weights" else "gold")
		var yes := CATALOG.context_for(id, action, TRIO, "", false, {"jack_companion": true})
		var no := CATALOG.context_for(id, action, ["knight"], "", false, {"jack_companion": true})
		assert_true(yes.jack_companion, id)
		assert_false(no.jack_companion, id)
	for id in ["black_altar", "last_camp", "chained_prisoner", "ash_rest", "jack"]:
		var action := "rescue_gold" if id in ["black_altar", "last_camp"] else ("recruited" if id == "jack" else "recruit")
		var context := CATALOG.context_for(id, "", TRIO, "", false, {"batch_03_action": action})
		var view := _view(context)
		var handoff: float = view.panorama._handoff_time
		var joiner: AnimatedSprite2D
		if id == "jack":
			joiner = view.panorama._jack
		else:
			joiner = view.actors[view.role_ids.find(view.panorama._joining)]
		_sample(view, handoff - 0.001)
		assert_false(joiner.visible, id)
		assert_true(view.panorama.npc_visible, id)
		_sample(view, handoff)
		assert_true(joiner.visible, id)
		assert_false(view.panorama.npc_visible, id)
		view.free()
