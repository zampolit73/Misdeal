extends SceneTree
const CAMP := preload("res://scripts/travel/cinematic_v5/camp_v5.gd")
const SQUIRE := preload("res://scripts/travel/cinematic_v5/squire_v5.gd")
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
	var stage := CAMP.new()
	root.add_child(stage)
	for id in CAMP.CAMP_IDS:
		for party in PARTIES:
			for action in CAMP.camp_actions(id,party):
				for companion in ([false,true] if "ranger" in party else [false]):
					cases += 1
					var name := "%s/%s/%s/%s" % [id,action,str(party),str(companion)]
					_check(stage.configure_scene(id,party,action,companion),name+" configure")
					if not stage.available: continue
					_check(stage.actors.size()==party.size() and stage.roles==party,name+" actual party")
					_check(is_instance_valid(stage.jack)==companion,name+" actual companion")
					_check(is_instance_valid(stage.squire)==(id=="borrowed_boots"),name+" Squire is Boots only")
					if is_instance_valid(stage.squire):
						var artisan: Node2D = stage.squire
						var cel: Sprite2D = artisan.sprite
						_check(artisan.scale==CAMP.BOOTS_PROJECTION and artisan.z_index==5 and cel.position==Vector2(SQUIRE.RECT.position),name+" source registered Squire")
						var seen: Dictionary = {}
						var hashes: Dictionary = {}
						for sample in [0.0,0.4,0.8,1.05,2.6,3.0,3.4,3.8,4.15,6.6]:
							stage.seek(sample)
							_check(artisan.pose==SQUIRE.pose_for(sample,action) and cel.visible==(artisan.pose!=SQUIRE.ORIGINAL),name+" deterministic Squire phase")
							seen[artisan.pose]=true
							if cel.visible:
								_check(cel.texture.get_size()==Vector2(SQUIRE.RECT.size),name+" native Squire detail")
								hashes[artisan.pose]=hash(cel.texture.get_image().get_data())
						_check(seen.size()==5 and hashes.size()==4,name+" four authored phases plus original")
						_check(hashes.values().size()==4 and hashes[0]!=hashes[1] and hashes[0]!=hashes[2] and hashes[0]!=hashes[3] and hashes[1]!=hashes[2] and hashes[1]!=hashes[3] and hashes[2]!=hashes[3],name+" unique Squire cels")
						stage.seek(0)
					var initial := stage.party_feet.duplicate()
					for t in [0.0,1.2,2.44,2.82,3.21,3.22,3.55,3.87,4.25,5.12,6.6]:
						stage.seek(t)
						var after: bool = t>=CAMP.HANDOFF
						_check(stage.visible_roles.size()==party.size()-int(not stage.joining.is_empty() and not after),name+" one actor per actual member")
						if is_instance_valid(stage.waiting_layer):
							_check(stage.waiting_layer.visible==not after,name+" exactly one recruit/abandoned painting")
						if is_instance_valid(stage.state_layer):
							_check(stage.state_layer.visible==after and stage.prop_changed==after,name+" actual outcome after handoff")
						else:
							_check(not stage.prop_changed,name+" pass leaves props intact")
						if is_instance_valid(stage.camp_layer):
							_check(stage.camp_layer.visible==not stage.prop_changed,name+" only one Boot state")
						if is_instance_valid(stage.boot_reactions):
							_check(stage.boot_reactions.visible==after,name+" repair strap only after change")
						var tr: Transform2D = stage.world.transform
						_check(tr.origin.x<=0.001 and tr.origin.y<=0.001 and tr.origin.x+1280*tr.x.length()>=1279.9 and tr.origin.y+720*tr.y.length()>=719.9,name+" camera coverage")
						for role in party:
							var unit: Sprite2D = stage.actors[role]
							var foot: Vector2 = stage.party_feet[role]
							var info: Dictionary = stage.current_frame[role]
							var bounds := VIS.logical_image(unit.texture).get_used_rect()
							_check(info.clip in ["idle","walk","rise","kneel","attack"],name+" living pose")
							_check(unit.texture.get_image().get_width()==288,name+" HD actor")
							if id=="borrowed_boots" and t>=2.44 and t<=3.87 and action!="passed":
								_check(float(info.height)*tr.x.length()<=200.0,name+" roadside figure fits native HD detail")
								_check(foot.y<=570.0,name+" actor on distant roadside plane")
								_check(tr.x.length()<=1.05,name+" no excessive Boots close-up")
							if info.clip in ["kneel","rise"]:
								_check(unit.texture==stage.living_poses[role][info.frame],name+" dedicated living cel")
							if t==2.82 and role==stage.action_role:
								_check(info.clip==("attack" if action=="mage" else "kneel"),name+" actual interaction")
							if role==stage.joining and after and t<CAMP.RISE_END:
								_check(info.clip=="rise",name+" recruit rises once")
							_check(foot.is_finite() and float(info.height)>0 and unit.visible==(role in stage.visible_roles),name+" projected actor")
							_check(absf(unit.position.y+(float(bounds.end.y)-48.0)*unit.scale.y-foot.y)<0.03,name+" sole anchor")
						if is_instance_valid(stage.jack):
							var bounds := VIS.logical_image(stage.jack.texture).get_used_rect()
							_check(stage.jack.visible==("ranger" in stage.visible_roles),name+" actual companion follows ranger")
							_check(stage.jack.texture.get_image().get_width()==288,name+" HD Jack")
							_check(absf(stage.jack.scale.x*56.0-stage._ppm(stage.dog_foot.y)*0.95)<0.02,name+" normal adult dog projection")
							_check(absf(stage.jack.position.y+(float(bounds.end.y)-48.0)*stage.jack.scale.y-stage.dog_foot.y)<0.03,name+" dog sole")
					for role in party:
						_check(stage.party_feet[role].distance_to(initial[role])>100,name+" onward road progression")
					stage.seek(0)
					_check(stage.party_feet==initial and not stage.prop_changed and (not is_instance_valid(stage.squire) or stage.squire.pose==SQUIRE.ORIGINAL),name+" deterministic replay")
	_check(not stage.configure_scene("last_camp",["ranger"],"rescue_blood"),"no invented Knight")
	_check(not stage.configure_scene("ash_rest",["mage"],"recruit"),"no invented Ranger")
	_check(not stage.configure_scene("borrowed_boots",["knight","knight"],"repair"),"no duplicate party")
	_check(not stage.configure_scene("borrowed_boots",["knight"],"loot"),"no invented outcome")
	_check(not stage.configure_scene("ash_rest",["mage"],"ranger"),"no invented trainee")
	var preview := (load("res://scenes/dev/travel_camp_v5_preview.tscn") as PackedScene).instantiate()
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
	print("TRAVEL_CAMP_V5_SMOKE: %d contexts · %d checks · %d failures" % [cases,checks,errors])
	quit(0 if errors==0 else 1)
