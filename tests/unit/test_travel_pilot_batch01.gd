extends GutTest
const PILOT := preload("res://scripts/dev/travel_pilot_batch01_playtest.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
func after_each() -> void:
	get_tree().paused=false
	RunState.reset_run()
func test_all_eleven_actions_subsets_contacts_pause_and_no_state_writes() -> void:
	RunState.choose_protagonist("knight")
	var snapshot: Dictionary=SAVE.new().snapshot(RunState).state
	var groups := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
	for index in range(11):
		for roles in groups:
			var context: Dictionary=PILOT.context_for_case(index,roles)
			var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
			view.context=context
			add_child(view)
			view.set_process(false)
			assert_true(view.available)
			assert_eq(view.role_ids,roles)
			for time in [0.6,1.3,2.5,3.8]:
				view.elapsed=time
				view.update_frame()
				assert_true(view.panorama.available)
				for i in range(roles.size()):
					var actor: AnimatedSprite2D=view.actors[i]
					assert_almost_eq(actor.position.y+(view.panorama.soles[roles[i]][actor.frame]-48)*actor.scale.y,view.contacts[i].y,0.001)
				assert_eq(SAVE.new().snapshot(RunState).state,snapshot)
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
func test_old_shop_context_and_invalid_role_never_invent_a_purchase() -> void:
	for fields in [{},{"choice_role":"bad"},{"choice_role":"mage"}]:
		var context: Dictionary=CATALOG.context_for("gravedigger_shop","bought",["knight"],"",false,fields)
		assert_eq(context.visual_action,"leave")
		assert_false(context.has("choice_role"))
	assert_eq(CATALOG.context_for("gravedigger_shop","bought",["mage"],"",false,{"choice_role":"mage"}).visual_action,"mage")
	assert_false(SAVE.FIELDS.has("visual_action"))
	assert_false(SAVE.FIELDS.has("choice_role"))
