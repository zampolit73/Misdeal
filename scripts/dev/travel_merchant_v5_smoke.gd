extends SceneTree
const BATCH := preload("res://scripts/travel/cinematic_v5/merchant_v5.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var checks := 0
var errors := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		errors += 1
		push_error(message)

func _run() -> void:
	var stage := BATCH.new()
	root.add_child(stage)
	var cases := 0
	for id in BATCH.IDS:
		for party in PARTIES:
			for action in BATCH.scene_actions(id,party):
				cases += 1
				_check(stage.configure_scene(id,party,action,"ranger" in party),"build "+id+" "+action+" "+str(party))
				if not stage.available: continue
				var before := stage.party_feet.duplicate()
				var seen := {}
				_check(stage.actors.size()==party.size(),"actual party only")
				_check(is_instance_valid(stage.jack)==("ranger" in party),"real Jack only")
				_check(stage.smith.texture_filter==CanvasItem.TEXTURE_FILTER_LINEAR,"painted texture linear")
				_check(stage.smith_frames.size()==4,"four independent painted poses")
				for t in [0.0,0.5,1.0,1.75,2.55,2.8,3.21,3.23,3.95,4.3,5.2,6.6]:
					stage.seek(t)
					seen[stage.smith_pose]=true
					_check(absf(stage.smith.scale.y*float(stage.profile.npc_height)-stage.npc_height)<0.01,"same NPC size for every pose")
					_check((stage.smith.position+Vector2(0,(float(stage.profile.npc_sole)-float(stage.profile.npc_cell)*0.5)*stage.smith.scale.y)).distance_to(stage.npc_foot)<0.01,"same sole for each pose")
					for i in stage.props.size():
						var expected := 0
						if t>=BATCH.HANDOFF:
							if id=="blood_ledger": expected=BATCH.LEDGER_ACTIONS.find(action)+1
							elif i==stage.selected: expected=1
						_check(stage.state_indices[i]==expected,"only authoritative chosen prop changes")
					for role in party:
						var foot: Vector2=stage.party_feet[role]
						var unit: Sprite2D=stage.actors[role]
						_check(foot.y>=stage.lane and foot.y<=stage.lane+24.01,"feet on in-front ground corridor")
						_check(absf(unit.position.y+(89.0-48.0)*unit.scale.y-foot.y)<0.01,"grounded sole")
						_check(absf(unit.scale.y*float(BATCH.BODY_PX[role])-BATCH.body_height(role,foot.y))<0.01,"single stature projection")
						_check(unit.flip_h==(stage.direction<0),"faces direction")
					var tr: Transform2D=stage.world.transform
					_check(tr.origin.x<=0.0 and tr.origin.y<=0.0 and tr.origin.x+1280.0*tr.x.length()>=1279.9 and tr.origin.y+720.0*tr.x.length()>=719.9,"camera coverage")
				_check(seen.size()==4,"four poses used in clip")
				if action!="leave":
					stage.seek(2.7)
					var stop:=stage.party_feet.duplicate()
					stage.seek(3.85)
					_check(stop==stage.party_feet,"party stops at transaction")
					_check(stage.current_frame[stage.order[0]].clip=="idle","idle during transaction")
					if action in BATCH.ROLES: _check(stage.order[0]==action,"correct selected buyer leads")
				stage.seek(BATCH.DURATION)
				for role in party:
					_check((stage.party_feet[role].x-before[role].x)*stage.direction>300.0,"party continues correct direction")
				stage.seek(0.0)
				_check(stage.party_feet==before and stage.state_indices.all(func(i):return i==0),"deterministic replay")
		_check(stage.configure_scene(id,["ranger"],"leave",false) and not is_instance_valid(stage.jack),"no invented companion")
		_check(not stage.configure_scene(id,["knight","knight"],"leave"),"duplicate party rejected")
	_check(not stage.configure_scene("candle_seller",["knight"],"mage"),"unavailable purchaser rejected")
	_check(not stage.configure_scene("not_a_scene",["knight"],"leave"),"unknown scene rejected")
	print("TRAVEL_MERCHANT_V5_SMOKE: %d contexts · %d checks · %d failures"%[cases,checks,errors])
	stage.free()
	quit(0 if errors==0 else 1)
