extends SceneTree
## Production routing contract; the navigation probe avoids renderer-only
## scene swap waits in headless. Uses the real Catalog, Router and Transition.
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const FORGE := preload("res://scripts/travel/cinematic_v5/forge_v5.gd")
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
class NavigationProbe extends Node:
	var _busy := false
	var paths: Array[String] = []
	func change_to(path: String) -> void:
		paths.append(path)
var checks := 0
var failures := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _context(party: Array, action: String, jack := false) -> Dictionary:
	return CATALOG.context_for("curse_forge","",party,"test",false,{"visual_action":action,"jack_companion":jack})

func _run() -> void:
	var router := load("res://scripts/core/scene_router.gd") as Script
	var original := root.get_node_or_null("SceneTransition")
	if original != null: original.name = "OriginalTransitionQA"
	var probe := NavigationProbe.new()
	probe.name = "SceneTransition"
	root.add_child(probe)
	var fallback_only := "--fallback-only" in OS.get_cmdline_user_args()
	var cases := 0
	if not fallback_only:
		for group in PARTIES:
			for action in FORGE.allowed_actions(group):
				var ctx := _context(group,action,"ranger" in group)
				var owner := Node.new()
				root.add_child(owner)
				var before := probe.paths.size()
				router.after_resolution(owner,ctx)
				router.after_resolution(owner,ctx)
				var view := root.get_node_or_null("TravelTransition")
				_check(view != null and view.available and is_instance_valid(view.forge_v5),"production selects V5")
				if view == null or not view.available or not is_instance_valid(view.forge_v5):
					if view != null: view.finish()
					await process_frame
					owner.free()
					continue
				cases += 1
				view.set_process(false)
				_check(view.context == ctx,"context unchanged")
				_check(is_equal_approx(view.duration(),FORGE.DURATION),"approved 6.6 second clock")
				_check(view.forge_v5.roles == group and view.forge_v5.action == action,"real committed roles/action")
				_check(is_instance_valid(view.forge_v5.jack) == ("ranger" in group),"real companion")
				_check(view.composition.get_node_or_null("ForgeV5Picture") != null and view.skip_button.get_parent() == view.composition,"movie below existing UI")
				_check(view.caption.text == ctx.narration_text and view.wizard.text == ctx.wizard_line,"existing narration")
				view._process(3.21)
				_check(view.forge_v5.visible_prop_count()==3,"rack before handoff")
				paused = true
				view._process(0.5)
				_check(is_equal_approx(view.elapsed,3.21),"pause holds movie clock")
				paused = false
				view._process(0.02)
				_check(view.forge_v5.visible_prop_count()==(3 if action=="leave" else 2),"committed outcome only")
				var calls := [0]
				view.finished.connect(func(): calls[0]+=1)
				if action == "leave":
					view._process(FORGE.DURATION)
				else:
					var key := InputEventKey.new()
					key.pressed = true
					key.keycode = KEY_ESCAPE
					view._input(key)
				view.finish()
				_check(calls[0]==1 and probe.paths.size()==before+1,"one finish and one navigation")
				_check(probe.paths.back()=="res://scenes/table/table.tscn","returns to table")
				await process_frame
				owner.free()
		# Other event still opts into the exact legacy 4-second presentation.
		var owner := Node.new()
		root.add_child(owner)
		router.after_resolution(owner,CATALOG.context_for("candle_seller","",["knight"],"",false,{"choice_role":"knight"}))
		var old := root.get_node_or_null("TravelTransition")
		_check(old != null and old.available and not is_instance_valid(old.forge_v5) and is_equal_approx(old.duration(),4.0),"other event remains V4")
		if old != null: old.finish()
		await process_frame
		owner.free()
	else:
		# Run with the HD atlas temporarily absent ONLY in a disposable fixture.
		var owner := Node.new()
		root.add_child(owner)
		router.after_resolution(owner,_context(["knight"],"dead_mans_shield"))
		var old := root.get_node_or_null("TravelTransition")
		_check(old != null and old.available and not is_instance_valid(old.forge_v5) and is_equal_approx(old.duration(),4.0),"missing V5 asset falls back to V4")
		if old != null: old.finish()
		await process_frame
		_check(probe.paths.size()==1,"fallback returns to table once")
		owner.free()
	probe.free()
	if original != null: original.name = "SceneTransition"
	print("TRAVEL_FORGE_V5_LIVE_SMOKE: %d V5 contexts · %d checks · %d failures (fallback-only=%s)" % [cases,checks,failures,fallback_only])
	quit(0 if failures == 0 else 1)
