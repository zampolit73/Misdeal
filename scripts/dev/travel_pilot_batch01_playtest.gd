extends "res://scripts/dev/travel_transition_playtest.gd"
const CASES := [["last_signal","truth"],["last_signal","salvage"],["last_signal","passed"],["gravedigger_shop","knight"],["gravedigger_shop","ranger"],["gravedigger_shop","mage"],["gravedigger_shop","leave"],["lost_purse","safe"],["lost_purse","greedy"],["lost_purse","all_in"],["lost_purse","untouched"]]
var index := 0
static func context_for_case(at: int, party: Array) -> Dictionary:
	var row: Array=CASES[posmod(at,CASES.size())]
	return CATALOG.context_for(row[0],"bought" if row[0]=="gravedigger_shop" and row[1]!="leave" else ("" if row[0]=="gravedigger_shop" else row[1]),party,"",false,{"choice_role":row[1]})
func _replay() -> void:
	get_tree().paused=false
	if is_instance_valid(view): view.queue_free()
	view=load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context=context_for_case(index,roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()
func _update_help() -> void:
	help_label.text="←/→ — 11 исходов · 1/2/3 — отряд · P — пауза · R — повтор · %d/11 %s:%s" % [index+1,CASES[index][0],CASES[index][1]]
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode in [KEY_LEFT,KEY_RIGHT]:
			index=posmod(index+(1 if event.keycode==KEY_RIGHT else -1),CASES.size())
			_replay()
			return
	super(event)
