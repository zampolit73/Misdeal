extends GutTest
const QA := preload("res://scripts/dev/travel_batch02_playtest.gd")
const MAP := preload("res://scripts/travel/batch_02_catalog.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")

func after_each() -> void:
	get_tree().paused=false
	RunState.reset_run()

func test_all_31_actions_actual_role_subsets_contact_pause_single_finish_and_no_state_writes() -> void:
	RunState.choose_protagonist("knight")
	var before: Dictionary=SAVE.new().snapshot(RunState).state
	var groups := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
	assert_eq(QA.CASES.size(),31)
	for index in range(31):
		for group in groups:
			var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
			view.context=QA.context_for_case(index,group)
			add_child(view)
			view.set_process(false)
			assert_true(view.available,str(QA.CASES[index]))
			assert_eq(view.role_ids,view.context.party_roles)
			for time in [0.65,1.15,2.50]:
				view.elapsed=time
				view.update_frame()
				for i in range(view.actors.size()):
					var actor: AnimatedSprite2D=view.actors[i]
					var sole: float=view.panorama.soles[view.role_ids[i]][actor.frame]
					assert_almost_eq(actor.position.y+(sole-48)*actor.scale.y,view.contacts[i].y,0.001)
				var visible_roles: Array=[]
				for metric in view.panorama.actor_metrics: visible_roles.append(metric.role)
				assert_eq(visible_roles.count("ranger")+(1 if view.panorama.npc_visible else 0),1 if view.role_ids.has("ranger") or view.panorama.npc_visible else 0)
				assert_eq(SAVE.new().snapshot(RunState).state,before)
			get_tree().paused=true
			var clock: float=view.elapsed
			view._process(1.0)
			assert_eq(view.elapsed,clock)
			get_tree().paused=false
			var finished := [0]
			view.finished.connect(func(): finished[0]+=1)
			view.finish()
			view.finish()
			assert_eq(finished[0],1)
			view.free()

func test_transient_mapping_requires_real_rng_purchase_and_recruit_context() -> void:
	for id in ["debtor_bones","rattling_bridge"]:
		var choice := "gamble" if id=="debtor_bones" else "rush"
		assert_true(CATALOG.context_for(id,choice,["knight"],"",false,{"visual_action":choice}).is_empty())
		for success in [false,true]:
			var context: Dictionary=CATALOG.context_for(id,choice,["knight"],"",false,{"visual_action":choice,"roll_success":success})
			assert_eq(context.visual_action,choice+("_success" if success else "_failure"))
	assert_true(CATALOG.context_for("curse_forge","",["knight"]).is_empty())
	for item in MAP.ACTIONS.curse_forge:
		assert_eq(CATALOG.context_for("curse_forge","",["knight"],"",false,{"visual_action":item}).visual_action,item)
	assert_true(CATALOG.context_for("candle_seller","",["knight"],"",false,{"choice_role":"mage"}).is_empty())
	assert_true(CATALOG.context_for("rattling_bridge","",["knight"],"",false,{"visual_action":"recruit","recruitment":true}).is_empty())
	assert_eq(CATALOG.context_for("rattling_bridge","",["knight","ranger"],"",false,{"visual_action":"recruit","recruitment":true}).visual_action,"recruit")
	for key in ["visual_action","roll_success","recruitment","choice_role"]: assert_false(SAVE.FIELDS.has(key))

func test_v2_overrides_and_seven_old_locations_remain_explicit() -> void:
	assert_eq(CATALOG.LOCATIONS.size(),14)
	for id in ["unsent_letters","banner_seamstress","borrowed_boots","false_weights"]:
		assert_false(str(CATALOG.LOCATIONS[id]).contains("batch_02"))
	for id in ["last_signal","gravedigger_shop","lost_purse"]: assert_true(str(CATALOG.LOCATIONS[id]).contains("pilot_01"))
	var data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string(MAP.ROOT+"staging.json"))
	var revisions := 0
	for scene in data.scenes:
		for action in scene.states:
			if action.get("v2_fixed",false):
				revisions+=1
				assert_true(float(action.actor_stage.near_height)>=310)
	assert_eq(revisions,11)

func test_invalid_batch_action_uses_existing_unavailable_fallback() -> void:
	var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context={"resolved_card_id":"curse_forge","visual_action":"unknown","party_roles":["knight"]}
	add_child(view)
	assert_false(view.available)
	view._process(1.0)
	view.free()
