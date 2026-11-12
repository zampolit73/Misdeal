extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = preload("res://scripts/travel/travel_catalog.gd").context_for("borrowed_boots","passed",["knight","ranger","mage"])
	view.data_path = preload("res://scripts/travel/travel_catalog.gd").DEFAULT_LOCATION
	view.context.duration_sec = 30.0
	root.add_child(view)
	var dest := OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(dest)
	for i in range(5):
		await create_timer(0.65).timeout
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(dest.path_join("travel_%d.png"%i))
	view.free()
	var state := root.get_node("RunState")
	state.reset_run()
	state.choose_protagonist("knight")
	state.active_card_id="banner_seamstress"
	await open_scene("res://scenes/event/act_choice.tscn")
	current_scene.choice_a.pressed.emit()
	assert(state.cards_resolved==1 and state.party_hp_bonus==12.0)
	current_scene.continue_button.pressed.emit()
	await process_frame
	assert(root.has_node("TravelTransition"))
	var veil_at_dismiss: Array[float] = []
	root.get_node("TravelTransition").tree_exiting.connect(func(): veil_at_dismiss.append(root.get_node("SceneTransition").get("_veil").modulate.a))
	await create_timer(0.10).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join("event_entrance.png"))
	await create_timer(0.55).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join("event_revealed.png"))
	root.get_node("TravelTransition").finish()
	await wait_scene("res://scenes/table/table.tscn")
	assert(veil_at_dismiss.size()==1 and veil_at_dismiss[0]==1.0,"Travel popped above Table reveal")
	assert(state.cards_resolved==1 and state.party_hp_bonus==12.0)
	state.reset_run()
	state.choose_protagonist("knight")
	state.active_card_id="graveyard_ambush"
	state.select_encounter(state.get_card("graveyard_ambush").target_path)
	await open_scene("res://scenes/battle/battle.tscn")
	# Inject only victory, then exercise actual Reward buttons and routing.
	current_scene._finish_battle(true)
	current_scene.get_node("ResultOverlay/ContinueButton").pressed.emit()
	await wait_scene("res://scenes/reward/reward.tscn")
	assert(not root.has_node("TravelTransition"))
	if current_scene.reward_mode=="major_upgrade":
		current_scene.reward_buttons[0].pressed.emit()
		while current_scene.reward_mode=="major_upgrade": await process_frame
	var before_gold: int=state.gold
	current_scene.reward_buttons[0].pressed.emit()
	while not root.has_node("TravelTransition"): await process_frame
	assert(state.cards_resolved==1 and state.gold>before_gold)
	var paid_gold: int=state.gold
	# Natural ending as well as Event's immediate skip, through the real veil.
	root.get_node("TravelTransition").tree_exiting.connect(func(): veil_at_dismiss.append(root.get_node("SceneTransition").get("_veil").modulate.a))
	await create_timer(3.65).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(dest.path_join("reward_departure.png"))
	await wait_scene("res://scenes/table/table.tscn")
	assert(veil_at_dismiss.size()==2 and veil_at_dismiss[1]==1.0)
	assert(state.cards_resolved==1 and state.gold==paid_gold)
	# Saved Table loads directly through existing router, no presentation replay.
	var service := preload("res://scripts/core/run_save_service.gd").new()
	var slot: Dictionary=service.snapshot(state)
	state.reset_run()
	assert(service.apply_slot(state,slot))
	await open_scene(slot.scene)
	assert(not root.has_node("TravelTransition"))
	# Let existing table entrance tweens settle, then free the scene while the
	# tree is alive. Abrupt quit used to strand pending layout callbacks.
	await create_timer(0.8).timeout
	current_scene.queue_free()
	await process_frame
	await process_frame
	print("TRAVEL_NATIVE_PASS: frames; Event -> Travel -> Table; Battle(result) -> Reward -> Travel -> Table; direct load")
	quit()
func open_scene(path: String) -> void:
	change_scene_to_file(path)
	await process_frame
	await create_timer(0.4).timeout
func wait_scene(path: String) -> void:
	var deadline := Time.get_ticks_msec()+15000
	while current_scene==null or current_scene.scene_file_path!=path or root.has_node("TravelTransition"):
		assert(Time.get_ticks_msec()<deadline,"Travel route timeout: "+path)
		await process_frame
	var transition := root.get_node_or_null("SceneTransition")
	while transition != null and transition.get("_busy"): await process_frame
