extends SceneTree
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const ROAD := preload("res://scripts/travel/cinematic_v5/road_v5.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var cases := 0
var checks := 0
var errors := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(condition: bool, message: String) -> void:
	checks+=1
	if not condition:
		errors+=1
		push_error(message)

func _run() -> void:
	var stage := ROAD.new()
	root.add_child(stage)
	for id in ROAD.IDS:
		for party in PARTIES:
			for action in ROAD.scene_actions(id,party):
				cases+=1
				var caption := "%s/%s/%s" % [id,action,str(party)]
				_check(stage.configure_scene(id,party,action,"ranger" in party),caption+" config")
				if not stage.available: continue
				var initial := stage.party_feet.duplicate()
				_check(stage.actors.size()==party.size(),caption+" actual party only")
				for t in [0.0,1.2,2.54,3.21,3.23,3.7,4.3,5.5,6.6]:
					stage.seek(t)
					var expected: int = party.size() - (1 if not stage.joining.is_empty() and t<ROAD.HANDOFF else 0)
					_check(stage.visible_roles.size()==expected,caption+" recruit present only after handoff")
					if is_instance_valid(stage.waiting_layer) and not stage.joining.is_empty():
						_check(stage.waiting_layer.visible==(t<ROAD.HANDOFF),caption+" no duplicate waiting recruit")
					if is_instance_valid(stage.jack):
						_check(stage.jack.visible==("ranger" in stage.visible_roles),caption+" companion follows actual Ranger")
					var tr: Transform2D = stage.world.transform
					_check(tr.origin.x<=0.01 and tr.origin.y<=0.01 and tr.origin.x+1280*tr.x.length()>=1279.9 and tr.origin.y+720*tr.y.length()>=719.9,caption+" camera coverage")
					for role in party:
						var unit: Sprite2D = stage.actors[role]
						var foot: Vector2 = stage.party_feet[role]
						var height: float = stage.current_frame[role].height
						var bounds := VIS.logical_image(unit.texture).get_used_rect()
						_check(absf(unit.position.y+(float(bounds.end.y)-48)*unit.scale.y-foot.y)<0.02,caption+" actual frame sole")
						_check(height>0 and is_finite(height) and foot.is_finite(),caption+" finite ground projection")
						_check(unit.visible==(role in stage.visible_roles),caption+" correct actor identity")
					if id=="lost_purse":
						var detail: bool = t>=ROAD.INSERT_IN and t<ROAD.INSERT_OUT
						_check(stage.insert.visible==detail and stage.world.visible!=detail,caption+" exclusive wide/detail shot")
						if action in ["safe","all_in"]:
							_check(is_instance_valid(stage.insert_grip),caption+" original grip present")
							_check(stage.insert_grip.visible==(detail and t>=ROAD.HANDOFF and t<ROAD.INSERT_OUT-0.06),caption+" grip only during pickup")
						else:
							_check(not is_instance_valid(stage.insert_grip),caption+" no invented grip")
						if t>=ROAD.INSERT_OUT:
							_check(-tr.origin.x/tr.x.length()>390.0,caption+" stale baked purse offscreen")
						if detail and t>ROAD.HANDOFF+0.16:
							_check(stage.insert_result.modulate.a>0.99,caption+" final actual outcome visible")
					elif is_instance_valid(stage.state_layer) and action!="leave_lost":
						_check(stage.state_layer.visible==(t>=ROAD.HANDOFF),caption+" outcome committed at handoff")
				if id=="rattling_bridge" and action=="careful":
					stage.seek(2.7)
					var before: Vector2 = stage.party_feet[party[0]]
					stage.seek(3.7)
					_check(stage.party_feet[party[0]].distance_to(before)>20.0,caption+" careful crosses without transaction stop")
				stage.seek(6.6)
				for role in party:
					_check(stage.party_feet[role].x>initial[role].x,caption+" progresses toward exit")
				stage.seek(0.0)
				_check(stage.party_feet==initial and not stage.prop_changed,caption+" deterministic replay")
			if "ranger" in party:
				var action: String = ROAD.scene_actions(id,party)[0]
				_check(stage.configure_scene(id,party,action,false) and not is_instance_valid(stage.jack),"no invented Jack")
	_check(not stage.configure_scene("rattling_bridge",["knight"],"recruit"),"no rescue without actual Ranger")
	_check(not stage.configure_scene("rattling_bridge",["knight","ranger"],"abandon"),"no lost Ranger in party")
	_check(not stage.configure_scene("whispering_well",["knight"],"rescue_gold"),"no rescue without actual mage")
	_check(not stage.configure_scene("lost_purse",["knight","knight"],"safe"),"duplicate party rejected")
	print("TRAVEL_ROAD_V5_SMOKE: %d contexts · %d checks · %d failures"%[cases,checks,errors])
	stage.free()
	quit(0 if errors==0 else 1)
