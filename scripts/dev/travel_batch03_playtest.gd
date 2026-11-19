extends "res://scripts/dev/travel_transition_playtest.gd"

const BATCH := preload("res://scripts/travel/batch_03_catalog.gd")
const GROUPS := [
	["knight"], ["ranger"], ["mage"],
	["knight", "ranger"], ["knight", "mage"], ["ranger", "mage"],
	["knight", "ranger", "mage"],
]

var index := 0
var _cases := cases()

static func cases() -> Array:
	var rows := []
	for id in BATCH.DATA.data:
		for action in BATCH.scene_for(id).states:
			rows.append([id, action])
	return rows

static func context_for_case(at: int, preferred: Array) -> Dictionary:
	var row: Array = cases()[at]
	var best: Array = []
	var best_cost := 100
	for group in GROUPS:
		if BATCH.action_for(row[0], row[1], group).is_empty():
			continue
		var cost := absi(group.size() - preferred.size()) * 4
		for role in preferred:
			if role not in group:
				cost += 1
		if cost < best_cost:
			best = group
			best_cost = cost
	return CATALOG.context_for(row[0], "", best, "", false, {"batch_03_action": row[1]})

func _replay() -> void:
	get_tree().paused = false
	if is_instance_valid(view):
		view.queue_free()
	view = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = context_for_case(index, roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()

func _update_help() -> void:
	var row: Array = _cases[index]
	help_label.text = "←/→ — %d/%d · %s:%s · %s · 1/2/3 — отряд · P — пауза · R — повтор" % [
		index + 1, _cases.size(), row[0], row[1], ", ".join(view.role_ids)]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_LEFT, KEY_RIGHT]:
		index = posmod(index + (1 if event.keycode == KEY_RIGHT else -1), _cases.size())
		_replay()
		return
	super(event)
