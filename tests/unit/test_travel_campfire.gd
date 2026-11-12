extends GutTest
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const DIR := "res://assets/pixel/travel/campfire_without_master/"
func after_each() -> void:
	get_tree().paused=false
	RunState.reset_run()
func test_immutable_source_routes_and_connected_art() -> void:
	assert_eq(FileAccess.get_sha256(DIR+"approved_reference.png"),"ea21184b5a2792ce5ac3d4226f95656a5b812caab6bd345d19ef6d138d94a53a")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"borrowed_boots"}),"res://resources/travel/campfire_without_master.tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"unsent_letters"}),"res://resources/travel/last_dawn_posthouse.tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"banner_seamstress"}),"res://resources/travel/last_dressing_station.tres")
	assert_eq(CATALOG.resource_for({"resolved_card_id":"false_weights"}),CATALOG.DEFAULT_LOCATION)
	var original := Image.new()
	original.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+"approved_reference.png"))
	var distinct: Dictionary = {}
	for outcome in ["repair","hobnails","passed"]:
		var image := Image.new()
		image.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+"camp_"+outcome+".png"))
		for point in [Vector2i(510,260),Vector2i(624,421),Vector2i(602,701)]:
			assert_eq(image.get_pixelv(point),original.get_pixelv(point),"Head, bone hand and worn boots must retain exact approved pixels")
		distinct[hash(image.get_data())]=true
	assert_eq(distinct.size(),3)
func test_outcomes_and_parties_are_read_only_grounded_and_enter_gate() -> void:
	RunState.choose_protagonist("knight")
	var before: Dictionary=SAVE.new().snapshot(RunState).state
	for outcome in ["repair","hobnails","passed"]:
		for roles in [["knight"],["knight","ranger","mage"]]:
			var view: CanvasLayer=load("res://scenes/travel/travel_transition.tscn").instantiate()
			view.context=CATALOG.context_for("borrowed_boots",outcome,roles)
			add_child(view)
			view.set_process(false)
			assert_true(view.available)
			assert_eq(view.panorama.outcome,outcome)
			assert_eq(view.panorama.speeds.Gate,view.panorama.speeds.Midground)
			assert_eq(view.panorama.speeds.Foreground,view.panorama.speeds.Midground)
			assert_gt(view.panorama.walk.road_length,view.data.party_origin.distance_to(view.panorama.walk.GATE_EXIT)+4.0,"The route must follow a real bend rather than a straight line")
			var feet: Array=view.contacts.duplicate()
			var scale_before: float=view.actors[0].scale.x
			view.elapsed=3.1
			view.update_frame()
			for i in range(roles.size()):
				var actor: AnimatedSprite2D=view.actors[i]
				assert_almost_eq(actor.position.y+(view.panorama.walk.soles[roles[i]][actor.frame]-48)*actor.scale.y,view.contacts[i].y,0.001)
				assert_lt(view.contacts[i].distance_to(view.panorama.walk.GATE_EXIT),feet[i].distance_to(view.panorama.walk.GATE_EXIT))
				assert_lt(view.contacts[i].y,feet[i].y)
			assert_lt(view.actors[0].scale.x,scale_before)
			assert_eq(view.panorama.reactions.strap.visible,outcome=="repair")
			assert_eq(view.caption.text,CATALOG.TEXT.borrowed_boots[outcome])
			assert_eq(SAVE.new().snapshot(RunState).state,before)
			view.free()
