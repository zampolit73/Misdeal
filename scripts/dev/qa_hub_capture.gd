extends SceneTree
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
var destination := ""
func _initialize() -> void: call_deferred("run")
func wait_hub() -> Node:
	for _frame in range(600):
		await process_frame
		if current_scene!=null and current_scene.scene_file_path=="res://scenes/dev/qa_hub.tscn": return current_scene
	assert(false,"F10 must return to hub")
	return null
func run() -> void:
	destination=OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(destination)
	change_scene_to_file("res://scenes/dev/qa_hub.tscn")
	var hub := await wait_hub()
	await process_frame
	var session: Node=root.get_node("QAHubSession")
	assert(session.available)
	var previous_save: RefCounted=session.original_save
	var previous_memory: RefCounted=session.original_memory
	assert(SAVE.shared!=previous_save and MEMORY.shared!=previous_memory)
	assert(SAVE.shared.path.begins_with("user://qa_hub/") and MEMORY.shared.path.begins_with("user://qa_hub/"))
	hub._show_group("TRAVEL")
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(destination+"/travel.png")
	var entries: Array=hub.get_entries()
	var travelled := 0
	var exercised := 0
	for entry in entries:
		if entry.group!="TRAVEL": continue
		assert(session.launch_entry(entry,{"roles":["knight","ranger","mage"],"gold":200}))
		await process_frame
		await process_frame
		var preview: Node=current_scene
		assert(preview.get("view")!=null and preview.view.available,entry.title)
		if entry.has("case_count"):
			for local_case in range(int(entry.case_count)):
				assert(preview.local_case==local_case and preview.view.available)
				var event:=InputEventKey.new()
				event.pressed=true
				event.keycode=KEY_RIGHT
				preview._unhandled_key_input(event)
				await process_frame
		if entry.scene.ends_with("travel_batch02_playtest.tscn"):
			preview.view.set_process(false)
			preview.view.elapsed=1.15
			preview.view.update_frame()
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png(destination+"/in_preview.png")
		session.return_to_hub()
		hub=await wait_hub()
		travelled+=1
	var card_rows: Array=[]
	for entry in entries:
		if entry.get("prep")=="card": card_rows.append(entry)
	for entry in card_rows:
		assert(session.prepare(entry,{"roles":["knight","ranger","mage"],"gold":200,"upgrades":true}),entry.title)
		assert(root.get_node("RunState").active_card_id==entry.card_id)
		exercised+=1
	for id in ["card:candle_seller","card:graveyard_ambush"]:
		for entry in entries:
			if entry.id!=id: continue
			assert(session.launch_entry(entry,{"roles":["knight","ranger","mage"],"gold":200,"upgrades":true}))
			await process_frame
			await process_frame
			assert(current_scene.scene_file_path==entry.scene)
			session.replay()
			await process_frame
			await process_frame
			assert(current_scene.scene_file_path==entry.scene)
			if id=="card:candle_seller":
				current_scene.choice_a.pressed.emit()
				current_scene.continue_button.pressed.emit()
				await process_frame
				assert(root.has_node("TravelTransition"))
			else:
				root.get_node("RunMenu").open_menu()
				assert(paused)
			session.return_to_hub()
			hub=await wait_hub()
			assert(not paused and root.get_node("RunMenu").menu==null)
	for entry in entries:
		if not str(entry.prep).begins_with("reward_") and not str(entry.prep).begins_with("fate") and not str(entry.prep).begins_with("end_"): continue
		assert(session.launch_entry(entry,{"roles":["knight","ranger","mage"],"gold":200}),entry.title)
		await process_frame
		await process_frame
		assert(current_scene.scene_file_path==entry.scene)
		session.return_to_hub()
		hub=await wait_hub()
	hub.get_node("Search").text="книга"
	hub._show_group("СОБЫТИЯ")
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(destination+"/search.png")
	print("QA_HUB_NATIVE_PASS: ",entries.size()," indexed routes; ",travelled," actual Travel launch/return; ",exercised," live cards prepared; actual event/battle/reward/fate/end launch/replay/return; isolated save+memory")
	# Remove the developer session and verify its original singleton references.
	session.queue_free()
	await process_frame
	assert(SAVE.shared==previous_save and MEMORY.shared==previous_memory)
	quit()
