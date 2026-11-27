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
func _key(stage: Node2D, slot: String) -> String:
	var prop: Sprite2D = stage.transactions.pieces.get(slot)
	return str(prop.get_meta("prop_key")) if is_instance_valid(prop) and prop.visible else ""
func _check_outcome(stage: Node2D, id: String, action: String, after: bool, name: String) -> void:
	match id:
		"debtor_bones":
			_check((_key(stage,"cracked")=="dice_broken")== (after and action=="break"),name+" broken dice exact")
			_check((_key(stage,"die0")!="")==not(after and action=="break"),name+" no duplicate whole dice")
			_check(_key(stage,"dish")==("empty_dish" if after and action in ["safe","gamble_success"] else "stake"),name+" exact stake")
			_check(_key(stage,"box")==("box_open" if after and action=="gamble_success" else "box_closed"),name+" exact payout box")
		"wizard_tithe":
			_check(_key(stage,"bowl")==({"gold":"chalice_gold","blood":"chalice_blood","refuse":"chalice_side"}[action] if after else "chalice_empty"),name+" exact chalice")
			_check(_key(stage,"scroll")==("scroll_open" if after and action=="refuse" else "scroll"),name+" exact scroll")
			_check((_key(stage,"blood_stain")!="")== (after and action=="blood" and stage.elapsed>RELIC.HANDOFF+0.04),name+" exact blood stain")
		"broken_crown":
			if after:
				_check(_key(stage,"crown")=="" and (_key(stage,"fragments")=="fragments")== (action=="break") and (_key(stage,"residue")=="residue")== (action=="melt"),name+" exact crown disposition")
			elif stage.elapsed<2.45 or action!="wear":
				_check(_key(stage,"crown")=="crown",name+" intact relic")
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
					var base: Sprite2D = stage.plate
					var world: Node2D=stage.world
					var initial := stage.party_feet.duplicate()
					var poses: Dictionary = {}
					for t in [0.0,1.2,2.46,2.8,3.21,3.22,3.55,3.95,4.2,5.2,6.6]:
						stage.seek(t)
						var after: bool = t>=RELIC.HANDOFF and action!="leave"
						_check(stage.world==world and stage.world.visible and stage.plate==base and stage.plate.visible,name+" one continuous composition")
						_check(stage.visible_roles.size()==party.size(),name+" no hidden party")
						_check(stage.prop_changed==after and stage.transactions.state_key==(action if after else "base"),name+" committed outcome state")
						_check_outcome(stage,id,action,after,name)
						var tr: Transform2D = stage.world.transform
						_check(tr.origin.x<=0.001 and tr.origin.y<=0.001 and tr.origin.x+1280*tr.x.length()>=1279.9 and tr.origin.y+720*tr.y.length()>=719.9,name+" camera coverage")
						if id!="broken_crown":
							_check(is_instance_valid(stage.npc_patch) and stage.npc_patch.visible==(action!="leave" and t>=2.8 and t<=3.55),name+" registered NPC gesture")
						for role in party:
							var unit: Sprite2D = stage.actors[role]
							var foot: Vector2 = stage.party_feet[role]
							var info: Dictionary = stage.current_frame[role]
							var bounds := VIS.logical_image(unit.texture).get_used_rect()
							_check(info.clip in ["idle","walk","gesture"],name+" upright living pose")
							_check(unit.texture.get_image().get_width()==288,name+" HD actor")
							_check(unit.visible and foot.is_finite() and float(info.height)>0 and float(info.height)*tr.x.length()<265,name+" grounded projection")
							_check(absf(unit.position.y+(float(bounds.end.y)-48.0)*unit.scale.y-foot.y)<0.03,name+" sole anchor")
							if info.clip=="gesture":
								_check(role==stage.action_role and unit.texture==stage.gesture_frames[role][info.frame],name+" actual standing gesture")
								poses[info.frame]=true
							if stage.reflections.has(role):
								var echo: Sprite2D=stage.reflections[role]
								_check(echo.visible and echo.texture==unit.texture and echo.flip_v,name+" wet-floor reflection tracks actor")
						if is_instance_valid(stage.jack):
							var bounds := VIS.logical_image(stage.jack.texture).get_used_rect()
							_check(stage.jack.visible and stage.jack.texture.get_image().get_width()==288,name+" HD adult Jack")
							_check(absf(stage.jack.scale.x*56.0-stage._ppm(stage.dog_foot.y)*0.95)<0.02,name+" normal adult dog projection")
							_check(absf(stage.jack.position.y+(float(bounds.end.y)-48.0)*stage.jack.scale.y-stage.dog_foot.y)<0.03,name+" dog sole")
					_check(poses.size()==(0 if action=="leave" else 3),name+" 3 genuine standing gesture phases or pass")
					for role in party:
						_check(stage.party_feet[role].distance_to(initial[role])>90,name+" onward route")
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
	print("TRAVEL_RELIC_POLISH_SMOKE: %d contexts · %d checks · %d failures" % [cases,checks,errors])
	quit(0 if errors==0 else 1)
