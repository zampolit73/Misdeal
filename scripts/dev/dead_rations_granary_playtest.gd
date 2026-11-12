extends "res://scripts/dev/travel_transition_playtest.gd"
var outcome := "passed"
func _replay() -> void:
	get_tree().paused=false
	if is_instance_valid(view): view.queue_free()
	view=load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context=CATALOG.context_for("false_weights",outcome,roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()
func _update_help() -> void:
	help_label.text="F6 · 1/2/3 — отряд · Q — честный паёк · W — откуп · E — оставить · P — пауза · R — повтор · "+outcome
	if get_tree().paused: help_label.text+=" · ПАУЗА"
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_Q: outcome="fair"; _replay(); return
			KEY_W: outcome="silence"; _replay(); return
			KEY_E: outcome="passed"; _replay(); return
	super(event)
