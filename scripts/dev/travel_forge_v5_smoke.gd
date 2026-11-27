extends SceneTree
const FORGE := preload("res://scripts/travel/cinematic_v5/forge_v5.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
var checks := 0
var failures := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _run() -> void:
	var scene := FORGE.new()
	root.add_child(scene)
	var cases := 0
	for party in PARTIES:
		for action in FORGE.allowed_actions(party):
			cases += 1
			_check(scene.configure(party,action,"ranger" in party), "build %s %s" % [party,action])
			if not scene.available:
				continue
			_check(scene.actors.size()==party.size(),"actual party only")
			_check(is_instance_valid(scene.jack)==("ranger" in party),"real companion display")
			_check(scene.visible_prop_count()==3,"all artifacts before transaction")
			_check(scene.smith.texture_filter==CanvasItem.TEXTURE_FILTER_LINEAR,"painted smith uses smooth filtering")
			_check(scene.smith_frames.size()==6,"all six HD cels")
			_check(scene.smith_frames[0].get_size()==Vector2(FORGE.SMITH_CELL,FORGE.SMITH_CELL),"native-resolution smith cell")
			var seen_poses := {}
			var initial := scene.party_feet.duplicate()
			for t in [0.0,0.4,0.55,0.7,0.97,1.05,1.19,2.55,2.9,3.21,3.23,3.94,4.1,4.6,5.05,5.3,5.6,5.9,6.6]:
				scene.seek(t)
				seen_poses[scene.smith_pose] = true
				_check(is_equal_approx(scene.smith.scale.y*float(FORGE.BODY_PX.smith),FORGE.body_height("smith",FORGE.SMITH_FOOT.y)),"unchanged smith physical stature")
				_check((scene.smith.position+Vector2(0,(FORGE.SMITH_SOLE-FORGE.SMITH_CELL*0.5)*scene.smith.scale.y)).distance_to(FORGE.SMITH_FOOT)<0.01,"unchanged smith foot anchor")
				_check(scene.visible_prop_count()==(2 if action!="leave" and t>=FORGE.HANDOFF else 3),"only actual selected artifact disappears")
				var world: Transform2D = scene.world.transform
				_check(world.origin.x<=0.0 and world.origin.y<=0.0 and world.origin.x+1280.0*world.x.length()>=1279.9 and world.origin.y+720.0*world.x.length()>=719.9,"camera never exposes edges")
				for role in party:
					var actor: Sprite2D = scene.actors[role]
					var foot: Vector2 = scene.party_feet[role]
					_check(actor.texture_filter==CanvasItem.TEXTURE_FILTER_NEAREST,"hero pixel filtering unchanged")
					_check(absf(actor.position.y+(89.0-48.0)*actor.scale.y-foot.y)<0.01,"grounded sole")
					_check(is_equal_approx(actor.scale.y*float(FORGE.BODY_PX[role]),FORGE.body_height(role,foot.y)),"one physical stature projection")
					_check(foot.y>=520.0 and foot.y<=605.0,"ground corridor")
					if foot.x >= 375.0 and foot.x <= 535.0:
						_check(foot.y>552.0,"walk in front of the solid anvil, not through it")
			if action!="leave":
				_check(scene.order[0]==FORGE.BUYERS[action],"actual buyer approaches the rack")
				scene.seek(2.7)
				var stopped := scene.party_feet.duplicate()
				scene.seek(3.85)
				_check(stopped==scene.party_feet,"vanishing velocity during acknowledgment")
				_check(scene.current_frame[scene.order[0]].clip=="idle","idle during handoff")
			_check(seen_poses.size()==6,"six distinct smith poses used")
			scene.seek(6.6)
			for role in party:
				_check(scene.party_feet[role].x<initial[role].x-300.0,"continues forward")
			scene.seek(0.0)
			_check(scene.party_feet==initial and scene.visible_prop_count()==3,"seek/replay resets presentation")
	_check(scene.configure(["ranger"],"leave",false) and not is_instance_valid(scene.jack),"no invented companion")
	_check(not scene.configure(["mage"],"dead_mans_shield"),"invalid purchaser rejected")
	_check(not scene.configure(["knight","knight"],"leave"),"duplicates rejected")
	_check(absf(FORGE.body_height("smith",535.0)/FORGE.body_height("knight",535.0)-1.0)<0.02,"comparable NPC/hero stature at identical depth")
	_check(FORGE.body_height("knight",580.0)>FORGE.body_height("knight",532.0),"perspective grows toward camera")
	print("TRAVEL_FORGE_V5_SMOKE: %d contexts · %d checks · %d failures" % [cases,checks,failures])
	scene.free()
	quit(0 if failures==0 else 1)
