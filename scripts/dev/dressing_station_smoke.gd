extends SceneTree
## Small native smoke: three actual F6 passes and one real event route.
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var dest := ""

func _initialize() -> void: call_deferred("run")

func run() -> void:
	dest = OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://.tmp/scene03/final"
	DirAccess.make_dir_recursive_absolute(dest)
	change_scene_to_file("res://scenes/dev/dressing_station_playtest.tscn")
	await process_frame
	await process_frame
	for outcome in ["bandages","standard","passed"]:
		current_scene.outcome = outcome
		current_scene._replay()
		var view: CanvasLayer = current_scene.view
		assert(view.available and view.actors.size()==3)
		await create_timer(1.8).timeout
		await shot(outcome)
		if outcome=="passed":
			paused = true
			var clock: float = view.elapsed
			await create_timer(0.15,true).timeout
			assert(view.elapsed==clock)
			paused = false
		await create_timer(2.3).timeout
		assert(current_scene.view!=view,"Natural ending must replay the F6 scene")
	current_scene.roles.assign(["knight"])
	current_scene._replay()
	await create_timer(2.7).timeout
	await shot("solo")
	current_scene.view.skip_button.pressed.emit()
	await process_frame
	await process_frame
	# Production choice handler applies the price once, before travel.
	var state := root.get_node("RunState")
	state.reset_run()
	state.choose_protagonist("knight")
	state.active_card_id = "banner_seamstress"
	change_scene_to_file("res://scenes/event/act_choice.tscn")
	await process_frame
	await create_timer(0.35).timeout
	current_scene.choice_a.pressed.emit()
	assert(state.cards_resolved==1 and state.party_hp_bonus==12.0 and state.party_damage_bonus==-0.5)
	var before: Dictionary = SAVE.new().snapshot(state).state
	current_scene.continue_button.pressed.emit()
	current_scene.continue_button.pressed.emit()
	await process_frame
	var travel := root.get_node("TravelTransition")
	assert(travel.available and travel.data_path==CATALOG.LOCATIONS.banner_seamstress)
	await create_timer(1.8).timeout
	await shot("event_route")
	assert(SAVE.new().snapshot(state).state==before)
	travel.skip_button.pressed.emit()
	travel.skip_button.pressed.emit()
	var deadline := Time.get_ticks_msec()+10000
	while current_scene==null or current_scene.scene_file_path!="res://scenes/table/table.tscn" or root.has_node("TravelTransition") or root.get_node("SceneTransition").get("_busy"):
		assert(Time.get_ticks_msec()<deadline)
		await process_frame
	assert(state.cards_resolved==1 and state.party_hp_bonus==12.0 and state.party_damage_bonus==-0.5)
	assert(CATALOG.resource_for({"resolved_card_id":"unsent_letters"})==CATALOG.LOCATIONS.unsent_letters)
	current_scene.queue_free()
	await process_frame
	await process_frame
	print("DRESSING_STATION_NATIVE_PASS: three full outcomes; trio/solo; pause/skip; Event -> Travel -> Table; effects once")
	quit()

func shot(id: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join(id+".png"))
