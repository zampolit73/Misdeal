extends GutTest
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const DIR := "res://assets/pixel/travel/last_dressing_station/"

func after_each() -> void:
	get_tree().paused = false
	RunState.reset_run()

func test_source_and_location_routing() -> void:
	assert_eq(FileAccess.get_sha256(DIR+"approved_reference.png"),"3c7b2626b2028b156cc6556a8ab148721e2987763ceda451e5d38a28ca47a34d")
	for outcome in ["bandages","standard","passed"]:
		assert_eq(CATALOG.resource_for(CATALOG.context_for("banner_seamstress",outcome,["knight"])),"res://resources/travel/last_dressing_station.tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"unsent_letters"}),"res://resources/travel/last_dawn_posthouse.tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"borrowed_boots"}),CATALOG.DEFAULT_LOCATION)
	assert_eq(load(CATALOG.DEFAULT_LOCATION).party_solo_offset,60.0)
	assert_eq(load(CATALOG.LOCATIONS.unsent_letters).party_solo_offset,60.0)

func test_outcomes_are_distinct_and_presentation_never_grants_effects() -> void:
	RunState.choose_protagonist("knight")
	var before: Dictionary = SAVE.new().snapshot(RunState).state
	var variants: Dictionary = {}
	for outcome in ["bandages","standard","passed"]:
		var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context = CATALOG.context_for("banner_seamstress",outcome,["knight"])
		add_child(view)
		view.set_process(false)
		assert_true(view.available)
		assert_eq(view.panorama.planes.size(),7)
		assert_eq(view.panorama.outcome,outcome)
		variants[hash(view.panorama.arches.texture.get_image().get_data())] = true
		view.elapsed = 3.1
		view.update_frame()
		assert_eq(view.panorama.reactions.scrap.visible,outcome=="bandages")
		assert_eq(view.panorama.reactions.rolls.visible,outcome=="bandages")
		assert_eq(view.panorama.reactions.scissors.visible,outcome=="standard")
		assert_eq(view.panorama.reactions.scrap.position,Vector2(858,804))
		assert_eq(SAVE.new().snapshot(RunState).state,before)
		view.free()
	# Passed and standard retain the same intact upper banner; bandages differs.
	assert_eq(variants.size(),2)

func test_party_soles_pause_and_skip_keep_existing_contract() -> void:
	for roles in [["knight"],["ranger","mage"],["knight","ranger","mage"]]:
		var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context = CATALOG.context_for("banner_seamstress","passed",roles)
		add_child(view)
		view.elapsed = 1.8
		view.update_frame()
		assert_eq(view.actors.size(),roles.size())
		for i in range(roles.size()):
			var actor: AnimatedSprite2D = view.actors[i]
			assert_almost_eq(actor.position.y+(view._soles[roles[i]][actor.frame]-48)*actor.scale.y,view.contacts[i].y,0.001)
			assert_gt(view.contacts[i].x,650.0)
			assert_lt(view.contacts[i].x,1100.0)
		get_tree().paused = true
		await get_tree().create_timer(0.03,true).timeout
		assert_eq(view.elapsed,1.8)
		var finished := [0]
		view.finished.connect(func(): finished[0]+=1)
		view.finish()
		view.finish()
		assert_eq(finished[0],1)
		get_tree().paused = false
		view.free()
