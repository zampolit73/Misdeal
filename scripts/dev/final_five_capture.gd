extends SceneTree
const EVENTS := preload("res://scripts/event/final_five_events.gd")
var state: Node
var destination := ""
var manifest: Array[Dictionary] = []
var comparison: Image

func _initialize() -> void: call_deferred("run")

func capture(label: String) -> void:
	var transition := root.get_node_or_null("SceneTransition")
	if transition == null: transition = root.get_node_or_null("SceneTransitionRuntime")
	while transition != null and transition.get("_busy"): await process_frame
	for settle in range(30): await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image.get_size()==Vector2i(1280,720))
	assert(image.save_png(destination.path_join(label+".png"))==OK)
	manifest.append({"frame":label,"scene":current_scene.scene_file_path,"gold":state.gold,"outcomes":state.event_outcomes.duplicate(),"resolved":state.cards_resolved})
	print("FINAL_FIVE_FRAME: ",label)

func open_scene(path: String) -> void:
	change_scene_to_file("res://scenes/"+path+".tscn")
	await process_frame
	await create_timer(1.8).timeout

func reset(id: String, poor: bool = false) -> void:
	state.reset_run()
	state.choose_protagonist("knight")
	state.gold = 0 if poor else 50
	state.cards_resolved = state.get_card(id).tier*4
	# Use an existing non-forced slot in the intended tier; leave combat schedule intact.
	for slot in range(state.cards_resolved, state.cards_resolved+4):
		state.cards_resolved = slot
		if slot % 4 != state.forced_combat_slots[state.get_card(id).tier]: break
	state.wizard_debt_active = not poor
	state.fate_spread_last_milestone_shown = 12
	state.wizard_wager_slots.clear()
	state.wizard_mark_slots.clear()
	state.wizard_meddling_slots.clear()

func run() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size()==1)
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size=Vector2i(1280,720)
	state=root.get_node("RunState")
	comparison=Image.create(1440,400,false,Image.FORMAT_RGB8)
	comparison.fill(Color("100e0e"))
	var column := 0
	for id in EVENTS.IDS:
		reset(id)
		# Sample genuine ordinary offers until this card appears; no injected pair.
		for attempt in range(1000):
			seed(attempt)
			state.current_offer_ids.clear()
			state.get_offer_cards()
			if state.current_offer_ids.has(id): break
		assert(state.current_offer_ids.has(id),"ordinary deal "+id)
		await open_scene("table/table")
		await create_timer(1.8).timeout
		await capture(id+"_table")
		for button in current_scene.offer_buttons:
			if button.get_meta("card_id","")==id:
				var image := root.get_texture().get_image()
				var bounds := Rect2i(button.get_global_rect())
				var card := image.get_region(bounds)
				card.convert(Image.FORMAT_RGB8)
				comparison.blit_rect(card,Rect2i(Vector2i.ZERO,card.get_size()),Vector2i(column*288,25))
				button.pressed.emit()
				break
		await create_timer(1.5).timeout
		assert(current_scene.scene_file_path=="res://scenes/event/act_choice.tscn")
		await capture(id+"_event")
		for index in range(3):
			if index>0:
				reset(id)
				state.active_card_id=id
				await open_scene("event/act_choice")
			var button := current_scene.get_node("Panel/Choices/Choice"+["A","B","C"][index]) as Button
			assert(not button.disabled)
			button.pressed.emit()
			await create_timer(0.35).timeout
			assert(state.get_event_outcome(id)==EVENTS.CHOICES[id][index][0])
			await capture(id+"_choice_"+str(index+1))
			current_scene.get_node("Panel/ContinueButton").pressed.emit()
			await create_timer(1.2).timeout
			assert(current_scene.scene_file_path=="res://scenes/table/table.tscn")
			await capture(id+"_return_"+str(index+1))
		reset(id,true)
		state.active_card_id=id
		await open_scene("event/act_choice")
		await capture(id+"_unavailable")
		column+=1
	assert(comparison.save_png(destination.path_join("comparison.png"))==OK)
	var file := FileAccess.open(destination.path_join("manifest.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(manifest,"\t"))
	print("FINAL_FIVE_NATIVE_PASS: ",manifest.size())
	quit()
