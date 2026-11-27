extends SceneTree
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const RESCUE := preload("res://scripts/travel/cinematic_v5/rescue_v5.gd")
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
	var stage := RESCUE.new()
	root.add_child(stage)
	for id in RESCUE.IDS:
		for party in PARTIES:
			for action in RESCUE.scene_actions(id,party):
				for companion in ([false,true] if "ranger" in party and id!="jack" else [false]):
					cases += 1
					var name := "%s/%s/%s/%s" % [id,action,str(party),str(companion)]
					_check(stage.configure_scene(id,party,action,companion),name+" config")
					if not stage.available: continue
					_check(stage.actors.size()==party.size() and stage.roles==party,name+" actual party")
					_check(is_instance_valid(stage.jack)==(action=="recruited" if id=="jack" else companion),name+" authoritative Jack")
					var initial := stage.party_feet.duplicate()
					for t in [0.0,1.2,2.44,2.82,3.21,3.22,3.55,3.87,4.25,4.55,5.12,6.6]:
						stage.seek(t)
						var after: bool = t>=RESCUE.HANDOFF
						var expected: int = party.size()-int(not stage.joining.is_empty() and not after)
						_check(stage.visible_roles.size()==expected,name+" actual party at handoff")
						if is_instance_valid(stage.waiting_layer):
							_check(not stage.waiting_layer.visible if after else (stage.waiting_layer.visible or (is_instance_valid(stage.treatment_layer) and stage.treatment_layer.visible)),name+" waiting actor once")
						if is_instance_valid(stage.state_layer):
							_check(stage.state_layer.visible==after,name+" authored outcome only after handoff")
						if id=="chained_prisoner" and action=="recruit" and after:
							_check(stage.state_layer.modulate.a==1.0,name+" gate fully open before exit")
						var tr: Transform2D = stage.world.transform
						_check(tr.origin.x<=0.001 and tr.origin.y<=0.001 and tr.origin.x+1280*tr.x.length()>=1279.9 and tr.origin.y+720*tr.y.length()>=719.9,name+" camera coverage")
						for role in party:
							var unit: Sprite2D = stage.actors[role]
							var foot: Vector2 = stage.party_feet[role]
							var info: Dictionary = stage.current_frame[role]
							var bounds := VIS.logical_image(unit.texture).get_used_rect()
							_check(info.clip!="death",name+" no combat death poses")
							if t == 2.82 and role == stage.action_role and action not in ["passed","leave","abandon"]:
								_check(info.clip==("attack" if role=="mage" else "kneel"),name+" correct ritual gesture")
							if info.clip in ["kneel","rise","step_down"]:
								_check(unit.texture==stage.living_poses[role][info.frame],name+" dedicated living cel")
							_check(foot.is_finite() and float(info.height)>0 and is_finite(info.height),name+" valid projection")
							_check(unit.visible==(role in stage.visible_roles),name+" actual actors")
							_check(absf(unit.position.y+(float(bounds.end.y)-48.0)*unit.scale.y-foot.y)<0.03,name+" authored sole")
							if not stage.joining.is_empty() and role==stage.joining and after and t<RESCUE.RISE_END:
								_check(info.clip=="rise",name+" distinct authored recovery poses")
						if is_instance_valid(stage.jack):
							_check(stage.jack.visible==("ranger" in stage.visible_roles and (id!="jack" or after)),name+" one companion after rescue")
							var b := VIS.logical_image(stage.jack.texture).get_used_rect()
							_check(stage.dog_clip!="death",name+" no dog defeat pose")
							if id=="jack" and t == 5.12:
								_check(stage.dog_clip=="walk",name+" dog running after treatment")
							_check(absf(stage.jack.scale.x*stage.jack_body_px-stage._ppm(stage.dog_foot.y)*RESCUE.JACK_STATURE_M)<0.02,name+" constant adult dog stature at each depth")
							_check(stage.jack_body_px==56.0,name+" standing reference not airborne stride")
							if id=="jack" and after and t<RESCUE.RISE_END:
								_check(stage.jack.texture==stage.living_poses["jack"][stage.dog_pose_index],name+" dedicated alert dog cel")
							_check(absf(stage.jack.position.y+(float(b.end.y)-48.0)*stage.jack.scale.y-stage.dog_foot.y)<0.03,name+" real dog sole")
							if id=="jack" and after and t<RESCUE.RISE_END:
								_check(stage.dog_clip=="rise",name+" dog rising poses")
					stage.seek(6.6)
					for role in party:
						if id=="jack":
							_check(stage.party_feet[role].x>initial[role].x,name+" forward progression")
						else:
							_check(stage.party_feet[role].x<float(stage.profile.wait[0][0]),name+" exits toward actual left passage")
					stage.seek(0.0)
					_check(stage.party_feet==initial and not stage.prop_changed,name+" deterministic replay")
	_check(not stage.configure_scene("jack",["knight"],"recruited"),"Jack requires Ranger")
	_check(not stage.configure_scene("black_altar",["knight"],"rescue_gold"),"actual Mage required")
	_check(not stage.configure_scene("chained_prisoner",["mage"],"recruit"),"actual Knight required")
	_check(not stage.configure_scene("black_altar",["mage","mage"],"leave"),"no duplicate heroes")
	_check(stage.configure_scene("jack",["ranger"],"passed",true) and not is_instance_valid(stage.jack),"pass never grants companion")
	_check(stage.configure_scene("jack",["ranger"],"recruited",false) and is_instance_valid(stage.jack),"recruit always grants companion")
	# At identical depth stationary and walking silhouettes share the same scale.
	stage.seek(RESCUE.HANDOFF)
	var standing: Rect2i = VIS.logical_image(stage.jack_frames.get_frame_texture("idle",0)).get_used_rect()
	_check(absf(standing.size.x*stage.jack.scale.x-114.0)<4.0,"Jack shelter handoff matches the painted 114px dog")
	for role in RESCUE.POSE_ROWS:
		var hashes := {}
		for pose in stage.living_poses[role]:
			var img: Image = pose.get_image()
			hashes[img.get_data().hex_encode().sha256_text()] = true
		_check(hashes.size()==4,"four distinct living cels for "+role)
	var preview := (load("res://scenes/dev/travel_rescue_v5_preview.tscn") as PackedScene).instantiate()
	root.add_child(preview)
	preview.set_process(false)
	_check(preview.stage.available and preview.scene_index==0,"actual F6 scene opens")
	for key in [KEY_X,KEY_X,KEY_1,KEY_RIGHT,KEY_Q,KEY_P,KEY_R]:
		var event := InputEventKey.new()
		event.pressed = true
		event.keycode = key
		preview._unhandled_key_input(event)
		_check(preview.stage.available,"F6 control keeps valid scene")
	_check(preview.scene_index==2 and "ranger" in preview.stage.roles,"Jack preview only legal Ranger composition")
	preview.free()
	print("TRAVEL_RESCUE_V5_SMOKE: %d contexts · %d checks · %d failures" % [cases,checks,errors])
	stage.free()
	quit(0 if errors==0 else 1)
