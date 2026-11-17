extends "res://scripts/dev/travel_transition_playtest.gd"
const BATCH := preload("res://scripts/travel/batch_02_catalog.gd")
const CASES := [["candle_seller","knight"],["candle_seller","ranger"],["candle_seller","mage"],["candle_seller","leave"],["blood_ledger","gold"],["blood_ledger","blood"],["blood_ledger","erase"],["blood_ledger","leave"],["debtor_bones","gamble_success"],["debtor_bones","gamble_failure"],["debtor_bones","safe"],["debtor_bones","break"],["debtor_bones","leave"],["wizard_tithe","gold"],["wizard_tithe","blood"],["wizard_tithe","refuse"],["broken_crown","wear"],["broken_crown","break"],["broken_crown","melt"],["broken_crown","leave"],["curse_forge","dead_mans_shield"],["curse_forge","blind_quiver"],["curse_forge","cracked_focus"],["curse_forge","leave"],["rattling_bridge","rush_success"],["rattling_bridge","rush_failure"],["rattling_bridge","scavenge"],["rattling_bridge","careful"],["rattling_bridge","recruit"],["rattling_bridge","loot_recruitment"],["rattling_bridge","abandon"]]
var index := 0

static func context_for_case(at: int, party: Array) -> Dictionary:
	var row: Array=CASES[posmod(at,CASES.size())]
	var actual := party.duplicate()
	if row[0]=="rattling_bridge":
		if row[1] in ["loot_recruitment","abandon"]: actual.erase("ranger")
		if row[1]=="recruit" and not actual.has("ranger"):
			if actual.size()==3: actual.pop_back()
			actual.append("ranger")
	if actual.is_empty(): actual=["knight"]
	return {"resolved_card_id":row[0],"visual_action":row[1],"outcome_id":"","party_roles":actual,"narration_text":BATCH.narration(row[0],row[1]),"wizard_line":"","duration_sec":4.0}

func _replay() -> void:
	get_tree().paused=false
	if is_instance_valid(view): view.queue_free()
	view=load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context=context_for_case(index,roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()

func _update_help() -> void:
	help_label.text="←/→ — 31 исход · 1/2/3 — отряд · P — пауза · R — повтор · %d/31 %s:%s" % [index+1,CASES[index][0],CASES[index][1]]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_LEFT,KEY_RIGHT]:
		index=posmod(index+(1 if event.keycode==KEY_RIGHT else -1),CASES.size())
		_replay()
		return
	super(event)
