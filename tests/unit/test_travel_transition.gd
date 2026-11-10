extends GutTest
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const ROUTER := preload("res://scripts/core/scene_router.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
class NavigationProbe extends Node:
	var _busy := false
	var paths: Array[String] = []
	func change_to(path: String) -> void: paths.append(path)
func after_each() -> void:
	CATALOG.enabled = true
	get_tree().paused = false
	RunState.reset_run()
func test_context_matches_all_fifteen_past_outcomes_and_party() -> void:
	for id in CATALOG.TEXT:
		for key in CATALOG.TEXT[id]:
			var roles := ["mage","ranger"]
			var ctx := CATALOG.context_for(id,key,roles)
			assert_eq(ctx.resolved_card_id,id)
			assert_eq(ctx.outcome_id,key)
			assert_eq(ctx.narration_text,CATALOG.TEXT[id][key])
			assert_eq(ctx.party_roles,roles)
			roles.clear()
			assert_eq(ctx.party_roles.size(),2)
			assert_false(ctx.has("next_card_id"))
	assert_true(CATALOG.context_for("bone_warden","victory",["knight"],"",true).is_empty())
	assert_true(CATALOG.context_for("graveyard_ambush","defeat",["knight"]).is_empty())
	CATALOG.enabled=false
	assert_true(CATALOG.context_for("borrowed_boots","repair",["knight"]).is_empty())
func test_visual_preserves_state_and_skip_emits_once_even_when_paused() -> void:
	RunState.choose_protagonist("mage")
	var before: Dictionary = SAVE.new().snapshot(RunState).state
	var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context=CATALOG.context_for("unsent_letters","read",RunState.party_roles)
	add_child(view)
	assert_true(view.available)
	assert_eq(view.actors.size(),1)
	var calls := [0]
	view.finished.connect(func(): calls[0]+=1)
	get_tree().paused=true
	var time: float=view.elapsed
	await get_tree().create_timer(0.05,true).timeout
	assert_eq(view.elapsed,time)
	view.finish()
	view.finish()
	assert_eq(calls[0],1)
	assert_eq(SAVE.new().snapshot(RunState).state,before)
	view.free()
func test_event_travel_route_applies_outcome_once_then_navigates_once() -> void:
	RunState.choose_protagonist("knight")
	RunState.active_card_id="banner_seamstress"
	var scene: Control=load("res://scenes/event/act_choice.tscn").instantiate()
	add_child(scene)
	scene.choice_a.pressed.emit()
	assert_eq(RunState.cards_resolved,1)
	assert_eq(RunState.party_hp_bonus,12.0)
	assert_eq(scene.travel_context.resolved_card_id,"banner_seamstress")
	var transition := get_tree().root.get_node("SceneTransition")
	transition.name="OriginalTransitionQA"
	var probe:=NavigationProbe.new()
	probe.name="SceneTransition"
	get_tree().root.add_child(probe)
	scene._return_to_table()
	scene._return_to_table()
	var view:=get_tree().root.get_node("TravelTransition")
	view.finish()
	await get_tree().process_frame
	assert_eq(probe.paths,["res://scenes/table/table.tscn"])
	assert_eq(RunState.cards_resolved,1)
	assert_eq(RunState.party_hp_bonus,12.0)
	probe.free()
	transition.name="SceneTransition"
	scene.free()

func test_disabled_flag_uses_original_router_without_overlay() -> void:
	var transition := get_tree().root.get_node("SceneTransition")
	transition.name="OriginalTransitionQA"
	var probe:=NavigationProbe.new()
	probe.name="SceneTransition"
	get_tree().root.add_child(probe)
	var owner:=Node.new()
	add_child(owner)
	var ctx:=CATALOG.context_for("borrowed_boots","passed",["knight"])
	CATALOG.enabled=false
	ROUTER.after_resolution(owner,ctx)
	ROUTER.after_resolution(owner,ctx)
	assert_eq(probe.paths,["res://scenes/table/table.tscn"])
	assert_false(get_tree().root.has_node("TravelTransition"))
	owner.free()
	probe.free()
	transition.name="SceneTransition"
func test_save_contains_no_travel_stage_or_context() -> void:
	RunState.choose_protagonist("ranger")
	RunState.active_card_id="unsent_letters"
	preload("res://scripts/event/final_five_events.gd").resolve(RunState,"unsent_letters","read")
	var ctx:=CATALOG.context_for("unsent_letters","read",RunState.party_roles)
	RunState.complete_active_card()
	assert_eq(ctx.resolved_card_id,"unsent_letters")
	assert_true(RunState.active_card_id.is_empty())
	var service:=SAVE.new()
	var saved:=service.snapshot(RunState)
	assert_eq(saved.scene,"res://scenes/table/table.tscn")
	assert_false(saved.state.has("travel_context"))
	RunState.reset_run()
	assert_true(service.apply_slot(RunState,saved))
	assert_eq(RunState.cards_resolved,1)
	assert_false(get_tree().root.has_node("TravelTransition"))

func test_all_skip_keys_and_natural_completion_emit_once() -> void:
	for key in [KEY_SPACE,KEY_ENTER,KEY_ESCAPE,KEY_KP_ENTER,0]:
		var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context=CATALOG.context_for("last_signal","passed",["ranger"])
		add_child(view)
		var calls: Array[int]=[0]
		view.finished.connect(func(): calls[0]+=1)
		if key==0:
			view._process(4.1)
		else:
			var input:=InputEventKey.new()
			input.keycode=key
			input.pressed=true
			view._input(input)
		view.finish()
		assert_eq(calls[0],1)
		view.free()
