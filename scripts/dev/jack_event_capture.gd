extends SceneTree
# Native production scene/choice/Battle evidence. No fake UI or substitute actors.
var destination := ""
var state: Node
var manifest: Array[Dictionary] = []

func _initialize() -> void:
	call_deferred("_run")

func _open(path: String) -> void:
	change_scene_to_file("res://scenes/"+path+".tscn")
	await process_frame
	await create_timer(0.7).timeout

func _reset() -> void:
	state.call("reset_run")
	state.call("choose_protagonist","ranger")
	state.set("gold",50)
	state.set("cards_resolved",4)
	state.set("wizard_mark_slots",[])
	state.set("wizard_meddling_slots",[])
	state.set("wizard_wager_slots",[])

func _capture(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.get_size() != Vector2i(1280,720):
		push_error("JACK_CAPTURE_FAIL: native viewport")
		quit(1)
		return
	image.save_png(destination.path_join(name+".png"))
	var actors: Array[Dictionary] = []
	if current_scene.scene_file_path == "res://scenes/battle/battle.tscn":
		for unit in current_scene.get("units"):
			actors.append({"role":unit.visual_role,"position":[unit.position.x,unit.position.y],"alive":unit.alive,"state":unit.frame_state})
	manifest.append({"name":name,"scene":current_scene.scene_file_path,"gold":state.get("gold"),"outcome":state.call("get_event_outcome","jack"),"party":state.get("party_roles").duplicate(),"actors":actors})
	print("JACK_NATIVE_FRAME: ",name)

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		quit(1)
		return
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280,720)
	state = root.get_node("RunState")
	seed(418)
	_reset()
	# Actual ordinary role-gated Tier1 deal, not a forced Jack offer.
	state.get("forced_combat_slots")[1] = 2
	for attempt in range(300):
		state.get("current_offer_ids").clear()
		state.call("get_offer_cards")
		if state.get("current_offer_ids").has("jack"): break
	if not state.get("current_offer_ids").has("jack"):
		push_error("JACK_CAPTURE_FAIL: no ordinary deal")
		quit(1)
		return
	await _open("table/table")
	for frame in range(300):
		if not current_scene.get("deal_in_progress"): break
		await process_frame
	await _capture("table_offer")
	for button in current_scene.get("offer_buttons"):
		if button.get_meta("card_id","") == "jack": button.pressed.emit()
	await create_timer(1.5).timeout
	if current_scene.scene_file_path != "res://scenes/event/act_choice.tscn":
		push_error("JACK_CAPTURE_FAIL: Table route")
		quit(1)
		return
	await _capture("event_rich")
	current_scene.get_node("Panel/Choices/ChoiceA").pressed.emit()
	await create_timer(0.35).timeout
	await _capture("recruited")
	current_scene.get_node("Panel/ContinueButton").pressed.emit()
	await create_timer(0.7).timeout
	if current_scene.scene_file_path != "res://scenes/table/table.tscn" or not state.call("has_jack_companion"):
		push_error("JACK_CAPTURE_FAIL: resolved return")
		quit(1)
		return
	state.get("current_offer_ids").assign(["bone_patrol","moon_seal"])
	state.call("choose_card","bone_patrol")
	await _open("battle/battle")
	await _capture("battle_preparation")
	current_scene.get_node("FightButton").pressed.emit()
	for frame in range(600):
		if current_scene.get("combat_live"): break
		await process_frame
	var pet: Node2D
	for unit in current_scene.get("units"):
		if unit.visual_role == "jack": pet = unit
	var pet_start := pet.position
	await create_timer(0.8).timeout
	if pet.position.distance_to(pet_start) < 20.0:
		push_error("JACK_CAPTURE_FAIL: pet did not move during real combat")
		quit(1)
		return
	await _capture("battle_live")
	for frame in range(600):
		if pet.get("frame_state") == "attack" or not pet.get("alive"): break
		await process_frame
	if not pet.get("alive") or pet.get("frame_state") != "attack":
		push_error("JACK_CAPTURE_FAIL: no natural pet attack")
		quit(1)
		return
	await _capture("pet_attack")
	pet.call("take_damage",1.0)
	await _capture("pet_hit")
	pet.call("take_damage",100000.0)
	await create_timer(0.7).timeout
	await _capture("pet_death")
	for unit in current_scene.get("units"):
		if unit.team == 1 and unit.alive: unit.take_damage(100000.0)
	await create_timer(0.8).timeout
	await _capture("battle_victory")
	current_scene.get_node("ResultOverlay/ContinueButton").pressed.emit()
	await create_timer(0.7).timeout
	if current_scene.scene_file_path != "res://scenes/reward/reward.tscn":
		push_error("JACK_CAPTURE_FAIL: reward route")
		quit(1)
		return
	await _capture("reward")
	for choice in ["passed","token","poor"]:
		_reset()
		state.set("active_card_id","jack")
		if choice == "poor": state.set("gold",24)
		await _open("event/act_choice")
		if choice != "poor":
			current_scene.get_node("Panel/Choices/Choice"+("B" if choice == "passed" else "C")).pressed.emit()
			await create_timer(0.35).timeout
		await _capture(choice)
	_reset()
	state.call("set_event_outcome","jack","recruited")
	state.call("recruit_companion","knight","native QA")
	state.call("recruit_companion","mage","native QA")
	state.set("selected_encounter_path","res://resources/encounters/firing_square.tres")
	await _open("battle/battle")
	await _capture("trio_wave_preparation")
	current_scene.get_node("FightButton").pressed.emit()
	for frame in range(600):
		if current_scene.get("combat_live"): break
		await process_frame
	for unit in current_scene.get("units"):
		if unit.team == 1 and unit.alive: unit.take_damage(100000.0)
	await create_timer(0.5).timeout
	await _capture("trio_wave_break")
	await _open("table/squad_status")
	current_scene.call("_select_role","ranger",false)
	await create_timer(0.3).timeout
	await _capture("dossier")
	var file := FileAccess.open(destination.path_join("manifest.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"frames":manifest},"  "))
	file.close()
	if manifest.size() != 16:
		push_error("JACK_CAPTURE_FAIL: incomplete matrix")
		quit(1)
		return
	print("JACK_EVENT_NATIVE_PASS: 16 actual frames, ordinary Table event route, three outcomes, pet movement/attack/hit/death and wave")
	quit()
