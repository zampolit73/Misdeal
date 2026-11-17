extends "res://scripts/dev/travel_transition_playtest.gd"
var driver: Script
var first_case := 0
var case_count := 1
var local_case := 0

func _ready() -> void:
	var session := get_node_or_null("/root/QAHubSession")
	var entry: Dictionary=session.last_entry if session!=null else {"batch":2,"case_start":0,"case_count":4}
	driver=load("res://scripts/dev/travel_pilot_batch01_playtest.gd" if int(entry.get("batch",2))==1 else "res://scripts/dev/travel_batch02_playtest.gd")
	first_case=int(entry.get("case_start",0))
	case_count=int(entry.get("case_count",1))
	if session!=null: roles.assign(session.last_options.get("roles",["knight","ranger","mage"]))
	super._ready()

func _replay() -> void:
	get_tree().paused=false
	if is_instance_valid(view): view.queue_free()
	view=load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context=driver.context_for_case(first_case+local_case,roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()

func _update_help() -> void:
	var row: Array=driver.get_script_constant_map().CASES[first_case+local_case]
	help_label.text="←/→ — %d/%d · %s:%s · 1/2/3 — отряд · P — пауза · R — повтор" % [local_case+1,case_count,row[0],row[1]]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_LEFT,KEY_RIGHT]:
		local_case=posmod(local_case+(1 if event.keycode==KEY_RIGHT else -1),case_count)
		_replay()
		return
	super(event)
