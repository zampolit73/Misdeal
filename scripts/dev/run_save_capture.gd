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
	root.size=Vector2i(1280,720)
	var state:=root.get_node("RunState")
	if args.size()>1 and args[1]=="read":
		var loaded: Dictionary=SAVE.shared.read_slot(state)
		var screen: Control=load("res://scenes/main/main.tscn").instantiate()
		root.add_child(screen)
		current_scene=screen
		screen.get_node("ContinueButton").pressed.emit()
		await create_timer(1.5).timeout
		assert(current_scene.scene_file_path==SAVE.TABLE)
		assert(state.current_offer_ids==loaded.state.current_offer_ids)
		assert(state.gold==123)
		assert(state.cards_resolved==2)
		assert(state.has_castle_fact("orders_conflict"))
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
	await create_timer(2.0).timeout
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
	await create_timer(1.5).timeout
	print("RUN_SAVE_NATIVE_PASS")
	menu.open_menu()
	menu.save_exit()
func snap(label: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(label+".png"))

