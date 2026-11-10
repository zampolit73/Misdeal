extends SceneTree
const SAVE:=preload("res://scripts/core/run_save_service.gd")
const MEMORY:=preload("res://scripts/memory/memory_profile.gd")
var output: String
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var args:=OS.get_cmdline_user_args()
	output=args[0]
	DirAccess.make_dir_recursive_absolute(output)
	SAVE.shared=SAVE.new()
	SAVE.shared.path=output.path_join("qa_run.json")
	MEMORY.shared=MEMORY.new()
	var memory_path:=output.path_join("qa_memory.json")
	if (args.size()<2 or args[1]!="read") and FileAccess.file_exists(memory_path): DirAccess.remove_absolute(memory_path)
	MEMORY.shared.open_profile(memory_path)
	root.size=Vector2i(1280,720)
	var state:=root.get_node("RunState")
	if args.size()>1 and args[1]=="new-game":
		MEMORY.shared.unlocked.assign(["SG13"])
		assert(MEMORY.shared.save_profile())
		var screen: Control=load("res://scenes/main/main.tscn").instantiate()
		root.add_child(screen)
		current_scene=screen
		screen.call("_on_start_button_pressed")
		await create_timer(0.4).timeout
		await snap("new_game_confirmation")
		for child in screen.get_children():
			if child is ConfirmationDialog: child.confirmed.emit()
		await create_timer(0.8).timeout
		assert(current_scene.scene_file_path=="res://scenes/intro/intro.tscn")
		assert(MEMORY.shared.unlocked.is_empty())
		var reread:=MEMORY.new()
		reread.open_profile(memory_path)
		assert(reread.unlocked.is_empty())
		current_scene.free()
		state.choose_protagonist("knight")
		var table: Control=load(SAVE.TABLE).instantiate()
		root.add_child(table)
		current_scene=table
		if not await wait_table_ready(): return
		table.get_node("MemoryTable").open_viewer()
		await create_timer(0.3).timeout
		await snap("new_game_memory_zero")
		assert(MEMORY.shared.unlocked.is_empty())
		table.get_node("MemoryTable").viewer.close()
		await process_frame
		await process_frame
		print("NEW_GAME_MEMORY_RESET_PASS")
		quit()
		return
	if args.size()>1 and args[1]=="read":
		var loaded: Dictionary=SAVE.shared.read_slot(state)
		var screen: Control=load("res://scenes/main/main.tscn").instantiate()
		root.add_child(screen)
		current_scene=screen
		screen.get_node("ContinueButton").pressed.emit()
		if not await wait_table_ready(): return
		assert(current_scene.scene_file_path==SAVE.TABLE)
		assert(state.current_offer_ids==loaded.state.current_offer_ids)
		assert(state.gold==123)
		assert(state.cards_resolved==2)
		assert(state.has_castle_fact("orders_conflict"))
		assert(MEMORY.shared.unlocked.size()==2)
		assert(MEMORY.shared.earned==2)
		assert(MEMORY.shared.resolved("ranger",1,{},false,"0:moon_seal").is_empty())
		assert(state.party_roles.size()==3)
		assert(state.event_outcomes.get("jack")=="companion")
		print("RUN_SAVE_RESTART_PASS")
		quit()
		return
	if FileAccess.file_exists(SAVE.shared.path): DirAccess.remove_absolute(SAVE.shared.path)
	var main: Control=load("res://scenes/main/main.tscn").instantiate()
	root.add_child(main)
	current_scene=main
	await create_timer(0.5).timeout
	assert(main.get_node("ContinueButton").disabled)
	await snap("main_empty")
	main.free()
	state.reset_run()
	state.choose_protagonist("ranger")
	state.recruit_companion("knight","QA")
	state.recruit_companion("mage","QA")
	state.event_outcomes["jack"]="companion"
	for entry in [["moon_seal","_resolve_moon_seal","keep"],["echo_crypt","_resolve_echo_crypt","listen"]]:
		state.current_offer_ids.assign([entry[0],"bone_patrol"])
		assert(state.choose_card(entry[0]))
		var event_scene: Control=load("res://scenes/event/act_choice.tscn").instantiate()
		root.add_child(event_scene)
		current_scene=event_scene
		event_scene.call(entry[1],entry[2])
		await create_timer(0.3).timeout
		event_scene.free()
	assert(state.cards_resolved==2)
	state.gold=123
	var table: Control=load("res://scenes/table/table.tscn").instantiate()
	root.add_child(table)
	current_scene=table
	if not await wait_table_ready(): return
	var offers: Array=state.current_offer_ids.duplicate()
	assert(SAVE.shared.write_slot(state))
	await snap("table_saved")
	var menu:=root.get_node("RunMenu")
	menu.open_menu()
	await snap("pause")
	menu.close_menu()
	table.free()
	main=load("res://scenes/main/main.tscn").instantiate()
	root.add_child(main)
	current_scene=main
	await create_timer(0.4).timeout
	assert(not main.get_node("ContinueButton").disabled)
	await snap("main_continue")
	var data: Dictionary=SAVE.shared.read_slot(state)
	state.reset_run()
	assert(SAVE.shared.apply_slot(state,data))
	assert(state.current_offer_ids==offers)
	main.free()
	table=load("res://scenes/table/table.tscn").instantiate()
	root.add_child(table)
	current_scene=table
	if not await wait_table_ready(): return
	print("RUN_SAVE_NATIVE_PASS")
	menu.open_menu()
	menu.save_exit()
func snap(label: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(label+".png"))


func wait_table_ready() -> bool:
	var deadline := Time.get_ticks_msec()+15000
	while Time.get_ticks_msec()<deadline:
		var screen := current_scene
		if screen != null and screen.scene_file_path==SAVE.TABLE and not screen.get("selection_locked") and not screen.get("deal_in_progress"):
			return true
		# A real Table can require a wager decision, not just animation time.
		# Resolve it through the same live button as a player before saving.
		if screen != null and screen.scene_file_path==SAVE.TABLE and screen.get_node("WagerOverlay/Root").visible:
			screen.get_node("WagerOverlay/Root/WagerPanel/RefuseButton").pressed.emit()
		await create_timer(0.05).timeout
	push_error("RUN_SAVE_CAPTURE_FAIL: Table did not reach a safe checkpoint")
	quit(1)
	return false
