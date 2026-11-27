extends SceneTree
## Production Catalog -> Router -> Transition; the navigation probe replaces Table rendering.
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const CAMP := preload("res://scripts/travel/cinematic_v5/camp_v5.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
class NavigationProbe extends Node:
	var _busy := false
	var paths: Array[String] = []
	func change_to(path: String) -> void:
		paths.append(path)
var checks := 0
var failures := 0
var cases := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _context(id: String, party: Array, action: String, jack: bool) -> Dictionary:
	return CATALOG.context_for(id,action,party,"wizard test",false,{"jack_companion":jack,"batch_03_action":action})

func _cue_count(view: Node, cue: String) -> int:
	var sample: AudioStream = root.get_node("SoundDirector").act1_sample(cue)
	var count := 0
	for child in view.get_children():
		if child is AudioStreamPlayer and child.stream == sample:
			count += 1
	return count

func _route(router: Script, probe: Node, id: String, party: Array, action: String, jack: bool) -> void:
	var ctx := _context(id,party,action,jack)
	_check(not ctx.is_empty() and ctx.get("visual_action","")==action,"catalog resolves committed action")
	var owner := Node.new()
	root.add_child(owner)
	var before: int = probe.paths.size()
	router.after_resolution(owner,ctx)
	router.after_resolution(owner,ctx)
	var view := root.get_node_or_null("TravelTransition")
	_check(view!=null and view.available and is_instance_valid(view.camp_v5),"production selects camp V5 "+id+"/"+action)
	if view==null or not view.available or not is_instance_valid(view.camp_v5):
		if view!=null: view.finish()
		await process_frame
		owner.free()
		return
	cases += 1
	view.set_process(false)
	var film: Node2D = view.camp_v5
	_check(not is_instance_valid(view.forge_v5) and not is_instance_valid(view.merchant_v5) and not is_instance_valid(view.road_v5),"renderers mutually exclusive")
	_check(view.context==ctx and film.roles==party and film.action==action and film.scene_id==id,"actual context unchanged")
	_check(is_instance_valid(film.jack)==(jack and "ranger" in party),"actual companion only")
	_check(is_equal_approx(view.duration(),CAMP.DURATION),"approved movie clock")
	_check(view.composition.get_node_or_null("CampV5Picture")!=null and view.skip_button.get_parent()==view.composition,"movie below travel UI")
	_check(view.caption.text==ctx.narration_text and view.wizard.text==ctx.wizard_line,"real narration retained")
	view._process(3.21)
	_check(film.visible_roles.size()==party.size()-int(not film.joining.is_empty()),"pre-handoff party")
	_check(not film.prop_changed,"no premature outcome")
	var cues := ["coins","metal","cloth-hit"]
	var counts := {}
	for cue in cues: counts[cue] = _cue_count(view,cue)
	paused = true
	view._process(0.5)
	_check(is_equal_approx(view.elapsed,3.21),"pause holds clock")
	paused = false
	view._process(0.02)
	_check(film.visible_roles.size()==party.size(),"actual post-handoff party")
	_check(film.prop_changed==(action!="leave"),"actual outcome state")
	var expected := "coins" if action=="rescue_gold" else ("metal" if action in ["knight","loot","abandon_loot"] else ("cloth-hit" if action in ["ranger","rescue_blood","recruit"] else ""))
	for cue in cues:
		_check(_cue_count(view,cue)==int(counts[cue])+int(cue==expected),"committed handoff cue")
	view._process(0.02)
	for cue in cues:
		_check(_cue_count(view,cue)==int(counts[cue])+int(cue==expected),"cue once")
	var calls := [0]
	view.finished.connect(func(): calls[0]+=1)
	if action=="leave":
		view._process(CAMP.DURATION)
	else:
		var key := InputEventKey.new()
		key.pressed = true
		key.keycode = KEY_ESCAPE if cases%2==0 else KEY_SPACE
		view._input(key)
	view.finish()
	_check(calls[0]==1 and probe.paths.size()==before+1,"one finish and one navigation")
	_check(probe.paths.back()=="res://scenes/table/table.tscn","returns to Table")
	await process_frame
	_check(root.get_node_or_null("TravelTransition")==null,"overlay cleaned")
	owner.free()

func _fallback(router: Script, probe: Node, id: String, action: String) -> void:
	var owner := Node.new()
	root.add_child(owner)
	var before: int = probe.paths.size()
	router.after_resolution(owner,_context(id,["knight"],action,false))
	var view := root.get_node_or_null("TravelTransition")
	_check(view!=null and view.available and not is_instance_valid(view.camp_v5) and is_equal_approx(view.duration(),4.0),"unaccepted scene or missing V5 profile stays V4")
	if view!=null:
		_check(view.composition.get_node_or_null("CampV5Picture")==null and view.panorama!=null,"only legacy picture remains")
		view.finish()
	await process_frame
	_check(probe.paths.size()==before+1,"fallback navigates once")
	owner.free()

func _run() -> void:
	var router := load("res://scripts/core/scene_router.gd") as Script
	var original := root.get_node_or_null("SceneTransition")
	if original!=null: original.name="OriginalTransitionQA"
	var probe := NavigationProbe.new()
	probe.name="SceneTransition"
	root.add_child(probe)
	var fallback_only := "--fallback-only" in OS.get_cmdline_user_args()
	if fallback_only:
		# Remove camp_batch.json only in a disposable fixture.
		await _fallback(router,probe,"last_camp","leave")
		await _fallback(router,probe,"ash_rest","leave")
	else:
		for id in ["last_camp","ash_rest"]:
			for party in PARTIES:
				for action in CAMP.camp_actions(id,party):
					await _route(router,probe,id,party,action,"ranger" in party)
			await _route(router,probe,id,["ranger"],"leave",false)
			var legacy := (load("res://scenes/travel/travel_transition.tscn") as PackedScene).instantiate()
			legacy.context=_context(id,["knight"],"leave",false)
			root.add_child(legacy)
			_check(legacy.available and not is_instance_valid(legacy.camp_v5) and is_equal_approx(legacy.duration(),4.0),"direct F6 remains V4")
			legacy.free()
		# The user's reported Boots scene and unaccepted rescue preview stay V4.
		await _fallback(router,probe,"borrowed_boots","repair")
		await _fallback(router,probe,"black_altar","leave")
	probe.free()
	if original!=null: original.name="SceneTransition"
	print("TRAVEL_CAMP_V5_LIVE_SMOKE: %d contexts · %d checks · %d failures (fallback-only=%s)"%[cases,checks,failures,fallback_only])
	quit(0 if failures==0 else 1)
