class_name BattleTargetPreview
extends Node2D

const PLAYER_LINE := Color(0.42, 0.72, 1.0, 0.34)
const ENEMY_LINE := Color(1.0, 0.30, 0.20, 0.46)
const PLAYER_MARK := Color(0.56, 0.82, 1.0, 0.72)
const ENEMY_MARK := Color(1.0, 0.42, 0.28, 0.82)

var active := false


func _ready() -> void:
	z_index = -20
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = false


func set_active(value: bool) -> void:
	active = value
	visible = value
	queue_redraw()


func _process(_delta: float) -> void:
	if active:
		queue_redraw()


func _draw() -> void:
	if not active:
		return

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue

		var unit := node as BattleUnit
		if not unit.alive or unit.combat_started:
			continue

		var target: BattleUnit = unit.get_preview_target()
		if target == null or not is_instance_valid(target):
			continue

		var from_point: Vector2 = to_local(unit.global_position) + Vector2(0.0, -8.0)
		var to_point: Vector2 = to_local(target.global_position) + Vector2(0.0, -8.0)
		var line_color: Color = PLAYER_LINE if unit.team == 0 else ENEMY_LINE
		var mark_color: Color = PLAYER_MARK if unit.team == 0 else ENEMY_MARK

		draw_line(from_point, to_point, line_color, 2.0, true)
		draw_circle(to_point, 6.0, mark_color, false, 2.0, true)
