extends GutTest
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const DIR := "res://assets/pixel/travel/dead_rations_granary/"
func after_each() -> void:
	get_tree().paused=false
	RunState.reset_run()
func test_exact_source_and_card_route() -> void:
	assert_eq(FileAccess.get_sha256(DIR+"approved_reference.png"),"53322f3f1608f3988d91e48f9253c79dc97e70287234f1611d7fc9b87a545b91")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"false_weights"}),"res://resources/travel/dead_rations_granary.tres")
	for pair in [["borrowed_boots","campfire_without_master"],["banner_seamstress","last_dressing_station"],["unsent_letters","last_dawn_posthouse"]]:
		assert_eq(CATALOG.resource_for({"resolved_card_id":pair[0]}),"res://resources/travel/"+pair[1]+".tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"last_signal"}),CATALOG.DEFAULT_LOCATION)
func test_outcomes_grounded_party_and_no_replayed_effects() -> void:
	RunState.choose_protagonist("knight")
	var before: Dictionary=SAVE.new().snapshot(RunState).state
	for outcome in ["fair","silence","passed"]:
		for roles in [["knight"],["knight","ranger","mage"]]:
			var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
			view.context=CATALOG.context_for("false_weights",outcome,roles)
			add_child(view)
			view.set_process(false)
			assert_true(view.available)
			assert_eq(view.panorama.storage.visible,outcome=="fair")
			assert_eq(view.panorama.spilled_grain.visible,outcome=="fair")
			assert_eq(view.panorama.ledger.visible,outcome=="fair")
			assert_eq(view.panorama.reactions.coins.visible,outcome=="silence")
			assert_eq(view.panorama.speeds.Foreground,view.panorama.speeds.Midground)
			assert_eq(view.panorama.speeds.Storage,view.panorama.speeds.Midground)
			var feet: Array=view.contacts.duplicate()
			var initial_size: float=view.actors[0].scale.x
			view.elapsed=3.1
			view.update_frame()
			for i in range(roles.size()):
				var actor: AnimatedSprite2D=view.actors[i]
				assert_almost_eq(actor.position.y+(view.panorama.walk.soles[roles[i]][actor.frame]-48)*actor.scale.y,view.contacts[i].y,0.001)
				assert_lt(view.contacts[i].y,feet[i].y)
				assert_gt(view.contacts[i].x,feet[i].x)
			assert_lt(view.actors[0].scale.x,initial_size)
			assert_eq(view.caption.text,CATALOG.TEXT.false_weights[outcome])
			assert_eq(SAVE.new().snapshot(RunState).state,before)
			view.free()
