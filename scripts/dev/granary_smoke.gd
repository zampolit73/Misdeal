extends SceneTree
## Five native frames, three F6 outcomes, one actual Event -> Travel -> Table.
const SAVE := preload("res://scripts/core/run_save_service.gd")
const EVENTS := preload("res://scripts/event/final_five_events.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
var dest := ""
func _initialize() -> void: call_deferred("run")
func run() -> void:
	dest=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://.tmp/scene04/native"
	DirAccess.make_dir_recursive_absolute(dest)
	change_scene_to_file("res://scenes/dev/dead_rations_granary_playtest.tscn")
	await process_frame
	await process_frame
	for outcome in ["fair","silence","passed"]:
		current_scene.outcome=outcome
		current_scene._replay()
		var view: CanvasLayer=current_scene.view
		assert(view.available and view.actors.size()==3)
		await create_timer(0.6).timeout
		if outcome=="passed": await shot("begin")
		var feet: Array=view.contacts.duplicate()
		var scale_before: float=view.actors[0].scale.x
		await create_timer(1.2).timeout
		await shot(outcome)
		for i in range(3):
			assert(view.contacts[i].y<feet[i].y,"Party must follow the road into depth")
			assert(view.contacts[i].distance_to(Vector2(1140,380))<feet[i].distance_to(Vector2(1140,380)),"Party must approach the open gate through the bend")
		assert(view.actors[0].scale.x<scale_before)
		if outcome=="passed":
			paused=true
			var clock: float=view.elapsed
			await create_timer(0.15,true).timeout
			assert(view.elapsed==clock)
			paused=false
			await create_timer(1.55).timeout
			await shot("trio_late")
			await create_timer(0.75).timeout
		else: await create_timer(2.3).timeout
		assert(current_scene.view!=view)
	current_scene.roles.assign(["knight"])
	current_scene._replay()
	await create_timer(2.7).timeout
	await shot("solo")
	await create_timer(1.45).timeout
	current_scene.view.skip_button.pressed.emit()
	await process_frame
	await process_frame
	var state:=root.get_node("RunState")
	state.reset_run()
	state.choose_protagonist("knight")
	state.gold=50
	state.active_card_id="false_weights"
	change_scene_to_file("res://scenes/event/act_choice.tscn")
	await process_frame
	await create_timer(0.35).timeout
	current_scene.choice_a.pressed.emit()
	assert(state.cards_resolved==1 and state.gold==38 and state.get_event_outcome("false_weights")=="fair")
	assert(is_equal_approx(state.party_hp_bonus,16.0))
	var before: Dictionary=SAVE.new().snapshot(state).state
	current_scene.continue_button.pressed.emit()
	current_scene.continue_button.pressed.emit()
	await process_frame
	var travel:=root.get_node("TravelTransition")
	assert(travel.available and travel.data_path==CATALOG.LOCATIONS.false_weights)
	await create_timer(1.2).timeout
	assert(SAVE.new().snapshot(state).state==before)
	travel.skip_button.pressed.emit()
	travel.skip_button.pressed.emit()
	var deadline:=Time.get_ticks_msec()+10000
	while current_scene==null or current_scene.scene_file_path!="res://scenes/table/table.tscn" or root.has_node("TravelTransition") or root.get_node("SceneTransition").get("_busy"):
		assert(Time.get_ticks_msec()<deadline)
		await process_frame
	assert(state.cards_resolved==1 and state.gold==38 and is_equal_approx(state.party_hp_bonus,16.0))
	current_scene.queue_free()
	await process_frame
	await process_frame
	print("GRANARY_NATIVE_PASS: three full outcomes, NE rear walk, shrinking trio/solo, pause/skip, Event -> Scene05 -> Table, effects once")
	quit()
func shot(id: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join(id+".png"))
