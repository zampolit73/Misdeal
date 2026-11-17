extends SceneTree
## Actual production buttons -> completion/save -> V2 -> existing Table router.
const QA := preload("res://scripts/dev/travel_batch02_playtest.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
var dest := ""
var records: Array[Dictionary] = []

func _initialize() -> void: call_deferred("run")

func wait_for_table() -> void:
	var deadline := Time.get_ticks_msec()+15000
	while current_scene==null or current_scene.scene_file_path!="res://scenes/table/table.tscn" or root.has_node("TravelTransition") or bool(root.get_node("SceneTransition").get("_busy")):
		assert(Time.get_ticks_msec()<deadline,"One existing route must return to Table")
		await process_frame

func seed_result(wanted: bool) -> void:
	for candidate in range(100):
		seed(candidate)
		if (randf()<0.5)==wanted:
			seed(candidate)
			return
	assert(false,"Known deterministic RNG fixture must exist")

func find_button(event: Node, card: String, action: String) -> Button:
	if action=="leave": return event.leave_button
	if card=="curse_forge":
		for node in event.find_children("*","Button",true,false):
			for connection in node.get_signal_connection_list("pressed"):
				var cb: Callable=connection.callable
				if cb.get_method()=="_resolve_forge" and cb.get_bound_arguments()==[action]: return node
		return null
	var actions: Array={"candle_seller":["knight","ranger","mage"],"blood_ledger":["gold","blood","erase"],"debtor_bones":["gamble_success","safe","break"],"wizard_tithe":["gold","blood","refuse"],"broken_crown":["wear","break","melt"],"rattling_bridge":["rush_success","scavenge","careful"]}[card]
	if card=="rattling_bridge" and action in ["recruit","loot_recruitment","abandon"]: actions=["recruit","loot_recruitment","abandon"]
	var normalized := action.replace("_failure","_success")
	var index: int=actions.find(normalized)
	return [event.choice_a,event.choice_b,event.choice_c][index] if index>=0 else null

func run() -> void:
	dest=OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://.tmp/batch02/native"
	DirAccess.make_dir_recursive_absolute(dest)
	var state := root.get_node("RunState")
	for index in range(31):
		var spec: Array=QA.CASES[index]
		var card: String=spec[0]
		var action: String=spec[1]
		state.reset_run()
		state.choose_protagonist(action if card=="candle_seller" and action!="leave" else "knight")
		var roles: Array=["knight","ranger","mage"]
		if index%3==1: roles=["knight","mage"]
		if index%3==2: roles=[state.protagonist_role]
		if card=="candle_seller" and action!="leave" and action not in roles: roles.append(action)
		if card=="rattling_bridge":
			if action in ["recruit","loot_recruitment","abandon"]: roles=["knight","mage"] if action!="loot_recruitment" else ["knight"]
			else: roles=["knight","ranger","mage"]
		state.party_roles.assign(roles)
		state.gold=200
		if card=="blood_ledger" and action=="erase": assert(state.add_hero_upgrade(state.get_next_available_hero_upgrade_id("knight")))
		var tithe_price: int=state.get_wizard_tithe_gold_price()
		var ledger_price: int=state.get_blood_ledger_gold_price()
		state.active_card_id=card
		change_scene_to_file("res://scenes/event/act_choice.tscn")
		await process_frame
		await create_timer(0.08).timeout
		var event := current_scene
		var button := find_button(event,card,action)
		assert(button!=null and not button.disabled,"Real button unavailable: "+card+":"+action)
		if action in ["gamble_success","rush_success"]: seed_result(true)
		if action in ["gamble_failure","rush_failure"]: seed_result(false)
		button.pressed.emit()
		var after: Dictionary=SAVE.new().snapshot(state).state
		button.pressed.emit()
		assert(SAVE.new().snapshot(state).state==after,"Repeated press must not award twice")
		assert(state.cards_resolved==1 and state.active_card_id.is_empty())
		assert(event.travel_context.get("visual_action")==action,"Actual choice must select exact V2 visual: "+card+":"+action)
		var expected_gold := 200
		var expected_hp := 0.0
		match card:
			"candle_seller":
				if action!="leave": expected_gold-=25;assert(state.hero_upgrade_ids.size()==1)
			"blood_ledger":
				if action=="gold": expected_gold-=ledger_price
				if action=="blood": expected_hp=-25.0
				if action=="erase": expected_gold+=70;assert(state.hero_upgrade_ids.is_empty())
			"debtor_bones":
				if action=="gamble_success": expected_gold+=45
				if action=="gamble_failure": expected_hp=-15.0;assert(state.party_damage_bonus==-1.0)
				if action=="safe": expected_gold+=15
				if action=="break": expected_gold+=25;expected_hp=-10.0
			"wizard_tithe":
				if action=="gold": expected_gold-=tithe_price
				if action=="blood": expected_hp=-20.0
			"broken_crown":
				if action=="wear": assert(state.has_artifact("broken_crown"))
				if action=="break": expected_gold+=40
			"curse_forge":
				if action!="leave": assert(state.artifact_ids==[action])
			"rattling_bridge":
				if action=="rush_success": expected_gold+=25
				if action=="rush_failure": expected_hp=-20.0
				if action=="scavenge": expected_gold+=15;expected_hp=-5.0
				if action=="loot_recruitment": expected_gold+=20
				if action=="recruit": assert(state.party_roles.count("ranger")==1 and state.has_rescue_scar("ranger"))
		assert(state.gold==expected_gold and is_equal_approx(state.party_hp_bonus,expected_hp))
		var saved: Dictionary=SAVE.new().snapshot(state)
		assert(SAVE.new().validate(saved,state))
		assert(not saved.state.has("visual_action") and not saved.state.has("roll_success"))
		event.continue_button.pressed.emit()
		event.continue_button.pressed.emit()
		await process_frame
		var view: CanvasLayer=root.get_node("TravelTransition")
		assert(view.available,"Native panorama unavailable: "+card)
		view.set_process(false)
		for moment in [0.45,0.65,0.85,1.15,1.50,2.50]:
			view.elapsed=moment
			view.update_frame()
			await RenderingServer.frame_post_draw
			assert(SAVE.new().snapshot(state).state==after)
			if moment in [0.65,1.15,2.50]: assert(root.get_texture().get_image().save_png(dest.path_join("%02d_%s_%s_%03d.png" % [index+1,card,action,int(round(moment*100))]))==OK)
			if card=="rattling_bridge":
				var rangers := 0
				for metric in view.panorama.actor_metrics:
					if metric.role=="ranger": rangers+=1
				assert(rangers+(1 if view.panorama.npc_visible else 0)<=1)
		paused=true
		var clock: float=view.elapsed
		view._process(0.7)
		assert(view.elapsed==clock)
		paused=false
		if index==30:
			view.elapsed=3.90
			view.set_process(true)
		elif index%2==0:
			var skip := InputEventKey.new();skip.pressed=true;skip.keycode=KEY_ESCAPE
			view._input(skip)
			view._input(skip)
		else:
			view.skip_button.pressed.emit()
			view.skip_button.pressed.emit()
		await wait_for_table()
		assert(state.gold==expected_gold and state.cards_resolved==1)
		# Restore the actual existing save snapshot: Table loads directly, without
		# a travel checkpoint and without repeating event effects or awards.
		assert(SAVE.new().apply_slot(state,saved))
		change_scene_to_file(SAVE.TABLE)
		await process_frame
		await process_frame
		assert(not root.has_node("TravelTransition") and state.gold==expected_gold and state.cards_resolved==1)
		records.append({"card":card,"action":action,"party":state.party_roles.duplicate(),"gold":state.gold,"hp_bonus":state.party_hp_bonus,"completed_once":true,"load_bypasses_travel":true,"control_times":[0.45,0.65,0.85,1.15,1.50,2.50]})
		print("BATCH02_ROUTE_PASS: "+card+":"+action)
	FileAccess.open(dest.path_join("results.json"),FileAccess.WRITE).store_string(JSON.stringify(records,"\t"))
	var sheet := Image.create(1280,1440,false,Image.FORMAT_RGB8)
	for index in range(31):
		var spec: Array=QA.CASES[index]
		var frame := Image.load_from_file(dest.path_join("%02d_%s_%s_250.png" % [index+1,spec[0],spec[1]]))
		frame.convert(Image.FORMAT_RGB8)
		frame.resize(320,180,Image.INTERPOLATE_LANCZOS)
		sheet.blit_rect(frame,Rect2i(0,0,320,180),Vector2i(index%4*320,index/4*180))
	sheet.save_png(dest.path_join("contact_sheet.png"))
	print("BATCH02_NATIVE_PASS: 31/31 real event routes, actual outcomes, effects once, party subsets, pause, skip, natural finish and save/load")
	quit()
