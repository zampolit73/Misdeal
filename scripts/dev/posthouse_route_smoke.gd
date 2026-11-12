extends SceneTree
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var exits: Array = []
var dest := ""
func _initialize() -> void: call_deferred("run")
func run() -> void:
	dest=OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(dest)
	var state := root.get_node("RunState")
	for choice in range(3):
		var outcome: String=["release","read","passed"][choice]
		state.reset_run()
		state.choose_protagonist("knight")
		state.gold=50
		state.active_card_id="unsent_letters"
		await open("res://scenes/event/act_choice.tscn")
		current_scene.get(["choice_a","choice_b","choice_c"][choice]).pressed.emit()
		assert(state.cards_resolved==1)
		assert(state.event_outcomes.unsent_letters==outcome)
		var gold: int=state.gold
		assert(gold==(40 if outcome=="release" else 50))
		assert(state.defiance_order_ready==(outcome=="release"))
		assert(state.has_castle_fact(state.CASTLE_FACT_MARCH)==(outcome=="read"))
		var facts: Dictionary=state.castle_memory_facts.duplicate(true)
		var before: Dictionary=SAVE.new().snapshot(state).state
		current_scene.continue_button.pressed.emit()
		current_scene.continue_button.pressed.emit()
		await process_frame
		var view:=root.get_node("TravelTransition")
		assert(view.data_path==CATALOG.LOCATIONS.unsent_letters and view.available)
		var ref: WeakRef=weakref(view)
		view.tree_exiting.connect(on_exit.bind(ref))
		await create_timer(0.23).timeout
		assert(SAVE.new().snapshot(state).state==before,"Travel wrote progression")
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(dest.path_join(outcome+"_entry.png"))
		if outcome!="release":
			view.skip_button.pressed.emit()
			view.skip_button.pressed.emit()
		await wait_table()
		assert(ref.get_ref()==null)
		assert(state.cards_resolved==1 and state.gold==gold)
		assert(state.castle_memory_facts==facts)
		assert(exits.back()[0]==outcome)
		assert(exits.back()[1]==(1 if outcome=="release" else 0))
		var saved: Dictionary=SAVE.new().snapshot(state)
		assert(saved.scene=="res://scenes/table/table.tscn")
		state.reset_run()
		assert(SAVE.new().apply_slot(state,saved))
		await open(saved.scene)
		assert(not root.has_node("TravelTransition"))
	# Another real event still selects the original authored road.
	state.reset_run()
	state.choose_protagonist("knight")
	state.active_card_id="false_weights"
	await open("res://scenes/event/act_choice.tscn")
	current_scene.choice_c.pressed.emit()
	current_scene.continue_button.pressed.emit()
	await process_frame
	assert(root.get_node("TravelTransition").data_path==CATALOG.DEFAULT_LOCATION)
	root.get_node("TravelTransition").finish()
	await wait_table()
	assert(state.cards_resolved==1)
	await create_timer(0.5).timeout
	current_scene.queue_free()
	await process_frame
	await process_frame
	print("POSTHOUSE_ROUTES_PASS: release/read/passed Event -> own Travel -> Table; one launch; skip; unchanged costs/facts; Save/Load; other event -> original road")
	quit()
func on_exit(reference: WeakRef) -> void:
	var view: Node=reference.get_ref()
	assert(is_instance_valid(view))
	assert(root.get_node("SceneTransition").get("_veil").modulate.a==1.0)
	exits.append([view.context.outcome_id,view.panorama.reactions.launch_count])
func open(path: String) -> void:
	change_scene_to_file(path)
	await process_frame
	await create_timer(0.35).timeout
func wait_table() -> void:
	var deadline:=Time.get_ticks_msec()+15000
	while current_scene==null or current_scene.scene_file_path!="res://scenes/table/table.tscn" or root.has_node("TravelTransition") or root.get_node("SceneTransition").get("_busy"):
		assert(Time.get_ticks_msec()<deadline,"Posthouse route timeout")
		await process_frame
