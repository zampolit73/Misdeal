extends SceneTree
## Uses actual Catalog -> Router -> Transition and SoundDirector. In headless,
## the navigation probe replaces the renderer-dependent Table scene swap.
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const MERCHANT := preload("res://scripts/travel/cinematic_v5/merchant_v5.gd")
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
	var outcome := "" if action=="leave" else action
	var presentation := {"jack_companion":jack}
	match id:
		"candle_seller":
			outcome = ""
			presentation.choice_role = action
		"blood_ledger":
			presentation.visual_action = action
		"gravedigger_shop":
			outcome = "" if action=="leave" else "bought"
			presentation.choice_role = action
	return CATALOG.context_for(id,outcome,party,"wizard test",false,presentation)

func _cue_count(view: Node, cue: String) -> int:
	var sample: AudioStream = root.get_node("SoundDirector").act1_sample(cue)
	var count := 0
	for child in view.get_children():
		if child is AudioStreamPlayer and child.stream == sample:
			count += 1
	return count

func _check_state(film: Node2D, id: String, action: String, after: bool) -> void:
	for i in film.props.size():
		var expected := 0
		if after:
			if id=="blood_ledger":
				expected = MERCHANT.LEDGER_ACTIONS.find(action)+1
			elif action!="leave" and i==MERCHANT.ROLE_ACTIONS.find(action):
				expected = 1
		_check(film.state_indices[i]==expected,"only committed prop state changes")
		if id=="candle_seller":
			_check(film.candle_pools[i].visible==(expected==0),"only consumed candle loses light")

func _check_route(router: Script, probe: Node, id: String, party: Array, action: String, jack: bool) -> void:
	var ctx := _context(id,party,action,jack)
	_check(not ctx.is_empty() and ctx.get("visual_action","")==action,"catalog maps actual committed choice")
	var owner := Node.new()
	root.add_child(owner)
	var before: int = probe.paths.size()
	router.after_resolution(owner,ctx)
	router.after_resolution(owner,ctx)
	var view := root.get_node_or_null("TravelTransition")
	_check(view!=null and view.available and is_instance_valid(view.merchant_v5),"production selects merchant V5")
	if view==null or not view.available or not is_instance_valid(view.merchant_v5):
		if view!=null: view.finish()
		await process_frame
		owner.free()
		return
	cases += 1
	view.set_process(false)
	var film: Node2D = view.merchant_v5
	_check(not is_instance_valid(view.forge_v5),"forge and merchant renderers are mutually exclusive")
	_check(view.context==ctx and film.roles==party and film.action==action and film.scene_id==id,"real context unchanged")
	_check(is_instance_valid(film.jack)==(jack and "ranger" in party),"actual companion only")
	_check(is_equal_approx(view.duration(),MERCHANT.DURATION),"approved movie clock")
	_check(view.composition.get_node_or_null("MerchantV5Picture")!=null and view.skip_button.get_parent()==view.composition,"movie below normal travel UI")
	_check(view.caption.text==ctx.narration_text and view.wizard.text==ctx.wizard_line,"normal narration retained")
	view._process(3.21)
	_check_state(film,id,action,false)
	var paper := _cue_count(view,"paper")
	var coins := _cue_count(view,"coins")
	paused = true
	view._process(0.5)
	_check(is_equal_approx(view.elapsed,3.21),"pause holds movie clock")
	_check_state(film,id,action,false)
	paused = false
	view._process(0.02)
	_check_state(film,id,action,true)
	var expect_paper := id=="blood_ledger" and action!="gold"
	var expect_coins := not expect_paper and action!="leave"
	_check(_cue_count(view,"paper")==paper+int(expect_paper) and _cue_count(view,"coins")==coins+int(expect_coins),"only correct transaction cue on handoff")
	view._process(0.02)
	_check(_cue_count(view,"paper")==paper+int(expect_paper) and _cue_count(view,"coins")==coins+int(expect_coins),"handoff cue not repeated")
	var calls := [0]
	view.finished.connect(func(): calls[0]+=1)
	if action=="leave":
		view._process(MERCHANT.DURATION)
	else:
		var key := InputEventKey.new()
		key.pressed = true
		key.keycode = KEY_ESCAPE if cases%2==0 else KEY_SPACE
		view._input(key)
	view.finish()
	_check(calls[0]==1 and probe.paths.size()==before+1,"one finish and one navigation")
	_check(probe.paths.back()=="res://scenes/table/table.tscn","returns to Table")
	await process_frame
	_check(root.get_node_or_null("TravelTransition")==null,"overlay cleaned up")
	owner.free()

func _check_fallback(router: Script, probe: Node, id: String) -> void:
	var party := ["knight"]
	var action := "gold" if id=="blood_ledger" else "knight"
	var ctx := _context(id,party,action,false)
	var owner := Node.new()
	root.add_child(owner)
	var before: int = probe.paths.size()
	router.after_resolution(owner,ctx)
	var view := root.get_node_or_null("TravelTransition")
	_check(view!=null and view.available and not is_instance_valid(view.merchant_v5) and not is_instance_valid(view.forge_v5) and is_equal_approx(view.duration(),4.0),"missing merchant prop falls back to V4 "+id)
	if view!=null:
		_check(view.composition.get_node_or_null("MerchantV5Picture")==null and view.panorama!=null,"only legacy picture remains")
		view.finish()
	await process_frame
	_check(probe.paths.size()==before+1 and probe.paths.back()=="res://scenes/table/table.tscn","fallback returns to Table once")
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
		# ONLY run with prop_0_1.webp temporarily absent for each merchant in a disposable fixture.
		for id in MERCHANT.IDS:
			await _check_fallback(router,probe,id)
	else:
		for id in MERCHANT.IDS:
			for party in PARTIES:
				for action in MERCHANT.scene_actions(id,party):
					await _check_route(router,probe,id,party,action,"ranger" in party)
			await _check_route(router,probe,id,["ranger"],"leave",false)
			# The existing QA drivers do not opt in; V4 remains directly inspectable.
			var legacy := (load("res://scenes/travel/travel_transition.tscn") as PackedScene).instantiate()
			legacy.context=_context(id,["knight"],"gold" if id=="blood_ledger" else "knight",false)
			root.add_child(legacy)
			_check(legacy.available and not is_instance_valid(legacy.merchant_v5) and is_equal_approx(legacy.duration(),4.0),"direct QA stays V4 "+id)
			legacy.free()
	probe.free()
	if original!=null: original.name="SceneTransition"
	print("TRAVEL_MERCHANT_V5_LIVE_SMOKE: %d V5 contexts · %d checks · %d failures (fallback-only=%s)"%[cases,checks,failures,fallback_only])
	quit(0 if failures==0 else 1)
