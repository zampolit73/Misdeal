extends SceneTree
const RELIC := preload("res://scripts/travel/cinematic_v5/relic_v5.gd")
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var cases := 0
var checks := 0
var errors := 0
func _initialize() -> void:
	_run.call_deferred()
func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		errors += 1
		push_error(message)
func _run() -> void:
	var stage := RELIC.new()
	root.add_child(stage)
	for id in RELIC.RELIC_IDS:
		for party in PARTIES:
			for action in RELIC.relic_actions(id,party):
				for companion in ([false,true] if "ranger" in party else [false]):
					cases += 1
					var name := "%s/%s/%s/%s" % [id,action,str(party),str(companion)]
					_check(stage.configure_scene(id,party,action,companion),name+" configure")
					if not stage.available: continue
					_check(stage.actors.size()==party.size() and stage.roles==party,name+" actual party")
					_check(is_instance_valid(stage.jack)==companion,name+" actual companion")
					_check(is_instance_valid(stage.detail)==(action!="leave"),name+" insert only on interaction")
					var initial := stage.party_feet.duplicate()
					var poses: Dictionary = {}
					for t in [0.0,1.2,2.44,2.45,2.65,2.82,3.04,3.21,3.22,3.65,4.02,5.12,6.6]:
						stage.seek(t)
						var after: bool = t>=RELIC.HANDOFF and action!="leave"
						var insert: bool = action!="leave" and t>=RELIC.DETAIL_IN and t<RELIC.DETAIL_OUT
						_check(stage.visible_roles.size()==party.size(),name+" actual members")
						_check(stage.world.visible==not insert,name+" no giant and hero composited together")
						_check(stage.prop_changed==after and stage.worksite.visible==not after,name+" exact worksite state")
						if is_instance_valid(stage.state_layer):
							_check(stage.state_layer.visible==after,name+" one changed worksite")
							_check(stage.detail.visible==insert and stage.detail_state.visible==after,name+" separate insert and state")
							var expected := -1
							if insert and not after and stage.detail_animated:
								var old_t := lerpf(0.48,1.46,clampf((t-RELIC.DETAIL_IN)/(RELIC.HANDOFF-RELIC.DETAIL_IN),0.0,1.0))
								for i in stage.detail_cels.size():
									if float(stage.detail_cels[i].time)<=old_t+0.00001: expected=i
							_check(stage.detail_pose.visible==(expected>=0) and stage.pose_index==expected,name+" native action sequence")
							if stage.detail_pose.visible: poses[stage.pose_index]=true
						var tr: Transform2D = stage.world.transform
						_check(tr.origin.x<=0.001 and tr.origin.y<=0.001 and tr.origin.x+1280*tr.x.length()>=1279.9 and tr.origin.y+720*tr.y.length()>=719.9,name+" camera coverage")
						for role in party:
							var unit: Sprite2D = stage.actors[role]
							var foot: Vector2 = stage.party_feet[role]
							var info: Dictionary = stage.current_frame[role]
							var bounds := VIS.logical_image(unit.texture).get_used_rect()
							_check(info.clip in ["idle","walk","kneel","attack"],name+" living pose")
							_check(unit.texture.get_image().get_width()==288,name+" HD actor")
							_check(foot.is_finite() and float(info.height)>0 and float(info.height)*tr.x.length()<230,name+" projected actor")
							_check(absf(unit.position.y+(float(bounds.end.y)-48.0)*unit.scale.y-foot.y)<0.03,name+" sole anchor")
						if is_instance_valid(stage.jack):
							var bounds := VIS.logical_image(stage.jack.texture).get_used_rect()
							_check(stage.jack.visible and stage.jack.texture.get_image().get_width()==288,name+" HD adult Jack")
							_check(absf(stage.jack.scale.x*56.0-stage._ppm(stage.dog_foot.y)*0.95)<0.02,name+" normal adult dog projection")
							_check(absf(stage.jack.position.y+(float(bounds.end.y)-48.0)*stage.jack.scale.y-stage.dog_foot.y)<0.03,name+" dog sole")
					if action!="leave": _check(poses.size()>=2 if stage.detail_animated else poses.is_empty(),name+" authored motion or single impact")
					for role in party:
						_check(stage.party_feet[role].distance_to(initial[role])>100,name+" onward route")
					stage.seek(0)
					_check(stage.party_feet==initial and not stage.prop_changed and stage.world.visible,name+" deterministic replay")
	_check(not stage.configure_scene("debtor_bones",["knight","knight"],"safe"),"no duplicate party")
	_check(not stage.configure_scene("wizard_tithe",["mage"],"gamble_success"),"no invented action")
	_check(not stage.configure_scene("broken_crown",["jack"],"wear"),"no invented hero")
	var preview := (load("res://scenes/dev/travel_relic_v5_preview.tscn") as PackedScene).instantiate()
	root.add_child(preview)
	preview.set_process(false)
	_check(preview.stage.available,"F6 loads")
	for key in [KEY_X,KEY_X,KEY_1,KEY_RIGHT,KEY_Q,KEY_E,KEY_J,KEY_P,KEY_R,KEY_Z,KEY_3]:
		var event := InputEventKey.new()
		event.pressed = true
		event.keycode = key
		preview._unhandled_key_input(event)
		_check(preview.stage.available,"F6 control valid")
	preview.free()
	stage.free()
	print("TRAVEL_RELIC_V5_SMOKE: %d contexts · %d checks · %d failures" % [cases,checks,errors])
	quit(0 if errors==0 else 1)
