extends SceneTree
const PILOT := preload("res://scripts/dev/travel_pilot_batch01_playtest.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var dest := ""
func _initialize() -> void: call_deferred("run")
func wait_for_table() -> void:
	var deadline := Time.get_ticks_msec()+12000
	while current_scene==null or current_scene.scene_file_path!="res://scenes/table/table.tscn" or root.has_node("TravelTransition") or bool(root.get_node("SceneTransition").get("_busy")):
		assert(Time.get_ticks_msec()<deadline,"Travel must return once, under existing veil")
		await process_frame
func run() -> void:
	dest=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://.tmp/batch01/native"
	DirAccess.make_dir_recursive_absolute(dest)
	var state := root.get_node("RunState")
	for index in range(11):
		var spec: Array=PILOT.CASES[index]
		state.reset_run()
		state.choose_protagonist(spec[1] if spec[0]=="gravedigger_shop" and spec[1]!="leave" else "knight")
		var parties := [["knight","ranger","mage"],["knight","mage"],["knight"],["knight","ranger","mage"],["ranger","knight"],["mage"],["knight","ranger","mage"],["knight","ranger","mage"],["ranger","mage"],["knight"],["ranger"]]
		state.party_roles.assign(parties[index])
		state.gold=100
		state.wizard_debt_active=spec[0]=="last_signal" and spec[1]=="truth"
		if spec[0]=="gravedigger_shop" and spec[1]=="ranger": state.set_event_outcome("lost_purse","safe")
		if spec[0]=="gravedigger_shop" and spec[1]=="mage": state.set_event_outcome("lost_purse","all_in")
		var price: int=state.get_gravedigger_shop_price()
		state.active_card_id=spec[0]
		change_scene_to_file("res://scenes/event/act_choice.tscn")
		await process_frame
		await create_timer(0.10).timeout
		var event := current_scene
		var expected_gold := 100
		var expected_hp := 0.0
		var expected_upgrades: int=state.hero_upgrade_ids.size()
		var button: Button
		if spec[0]=="gravedigger_shop":
			if spec[1]=="leave": button=event.leave_button
			else:
				button=[event.choice_a,event.choice_b,event.choice_c][["knight","ranger","mage"].find(spec[1])]
				expected_gold-=price
				expected_upgrades+=1
		elif spec[0]=="last_signal":
			button=[event.choice_a,event.choice_b,event.choice_c][["truth","salvage","passed"].find(spec[1])]
			if spec[1]=="truth": expected_gold-=20
			if spec[1]=="salvage": expected_gold+=22
		else:
			if spec[1]=="untouched": button=event.leave_button
			else:
				var choice: int=["safe","greedy","all_in"].find(spec[1])
				button=[event.choice_a,event.choice_b,event.choice_c][choice]
				expected_gold+=[15,35,55][choice]
				expected_hp=[0.0,-10.0,-25.0][choice]
		assert(not button.disabled,"Real choice must be available for actual party and price")
		button.pressed.emit()
		button.pressed.emit()
		assert(state.gold==expected_gold and is_equal_approx(state.party_hp_bonus,expected_hp))
		assert(state.cards_resolved==1)
		assert(state.hero_upgrade_ids.size()==expected_upgrades)
		if spec[0]=="gravedigger_shop" and spec[1]!="leave": assert(state.get_event_outcome(spec[0])=="bought" and state.get_role_upgrade_count(spec[1])==1)
		if spec[0]=="last_signal" and spec[1]=="truth": assert(not state.wizard_debt_active)
		assert(event.travel_context.visual_action==spec[1])
		var before: Dictionary=SAVE.new().snapshot(state).state
		assert(not before.has("choice_role") and not before.has("visual_action"))
		event.continue_button.pressed.emit()
		event.continue_button.pressed.emit()
		await process_frame
		var view: CanvasLayer=root.get_node("TravelTransition")
		assert(view.available)
		view.set_process(false)
		for moment in [0.6,1.3,2.5,3.8]:
			view.elapsed=moment
			view.update_frame()
			await RenderingServer.frame_post_draw
			assert(SAVE.new().snapshot(state).state==before)
			if moment==0.6 and index in [1,3,7,9]: root.get_texture().get_image().save_png(dest.path_join("action_%02d.png" % index))
			if moment==2.5: root.get_texture().get_image().save_png(dest.path_join("%02d_%s_%s.png" % [index+1,spec[0],spec[1]]))
		paused=true
		var clock: float=view.elapsed
		view._process(0.8)
		assert(view.elapsed==clock)
		paused=false
		if index==10:
			view.set_process(true)
		else:
			view.elapsed=[0.1,0.75,3.8][index%3]
			view.update_frame()
			view.skip_button.pressed.emit()
			view.skip_button.pressed.emit()
		await wait_for_table()
		assert(state.gold==expected_gold and is_equal_approx(state.party_hp_bonus,expected_hp) and state.cards_resolved==1 and state.hero_upgrade_ids.size()==expected_upgrades)
		print("PILOT_ROUTE_PASS: "+spec[0]+":"+spec[1])
	# Reuse the actual native frames for one unified review, not package artwork.
	var sheet := Image.create(1280,540,false,Image.FORMAT_RGBA8)
	for index in range(11):
		var spec: Array=PILOT.CASES[index]
		var frame := Image.new()
		frame.load_png_from_buffer(FileAccess.get_file_as_bytes(dest.path_join("%02d_%s_%s.png" % [index+1,spec[0],spec[1]])))
		frame.resize(320,180,Image.INTERPOLATE_LANCZOS)
		sheet.blit_rect(frame,Rect2i(0,0,320,180),Vector2i(index%4*320,index/4*180))
	sheet.save_png(dest.path_join("contact_sheet.png"))
	current_scene.queue_free()
	await process_frame
	await process_frame
	print("PILOT_BATCH01_NATIVE_PASS: 11/11 real Event -> Resolution -> Travel -> Table; actual prices and effects once; pause, skips and natural completion; 11 native frames")
	quit()
