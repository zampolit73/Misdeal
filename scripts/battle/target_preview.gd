class_name BattleTargetPreview
extends Node2D

# D362: bulk intent remains opt-in before combat. A single hovered miniature
# always reveals its actual current target, including during the autobattle.
# Hover never changes AI targets, damage, tactics or RunState preferences.
const PLAYER_LINE := Color(0.42, 0.72, 1.0, 0.34)
const ENEMY_LINE := Color(1.0, 0.30, 0.20, 0.46)
const PLAYER_MARK := Color(0.56, 0.82, 1.0, 0.72)
const ENEMY_MARK := Color(1.0, 0.42, 0.28, 0.82)
const HOVER_INTERVAL := 0.05
const HOVER_PICK_RECT := Rect2(Vector2(-40.0, -80.0), Vector2(80.0, 125.0))

var active := false
var _redraw_elapsed := 0.0


func _ready() -> void:
	# Intent indicators should sit over the floor, never block a mouse click.
	z_index = 1500
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true


func set_active(value: bool) -> void:
	active = value
	# Off now means hover-only, not an invisible Node2D.
	visible = true
	queue_redraw()


func _process(delta: float) -> void:
	_redraw_elapsed += delta
	if _redraw_elapsed >= HOVER_INTERVAL:
		_redraw_elapsed = 0.0
		queue_redraw()


func _draw() -> void:
	if active:
		for node in get_tree().get_nodes_in_group("combat_units"):
			if not node is BattleUnit:
				continue
			var unit := node as BattleUnit
			if not unit.alive or unit.combat_started:
				continue
			var target := get_focus_target(unit)
			if target == null:
				continue
			var from_point := to_local(unit.global_position) + Vector2(0.0, -8.0)
			var to_point := to_local(target.global_position) + Vector2(0.0, -8.0)
			var line_color := PLAYER_LINE if unit.team == 0 else ENEMY_LINE
			var mark_color := PLAYER_MARK if unit.team == 0 else ENEMY_MARK
			_draw_intent_arrow(from_point, to_point, line_color, mark_color)

	_draw_hover_focus()


static func get_focus_target(unit: BattleUnit) -> BattleUnit:
	if unit == null or not is_instance_valid(unit) or not unit.alive:
		return null
	# The preparation preview uses exactly the chosen tactic; combat uses
	# the live AI-selected target, not a misleading recomputed prediction.
	var target: BattleUnit = unit.target if unit.combat_started else unit.get_preview_target()
	if target == null or not is_instance_valid(target) or not target.alive:
		return null
	return target


func _get_hovered_unit() -> BattleUnit:
	var pointer := to_local(get_global_mouse_position())
	var closest: BattleUnit = null
	var closest_distance := INF
	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue
		var unit := node as BattleUnit
		if not unit.alive:
			continue
		# UnitsLayer is the parent of the overlay and of each BattleUnit.
		var local := pointer - to_local(unit.global_position)
		if not HOVER_PICK_RECT.has_point(local):
			continue
		var distance := local.length_squared()
		if distance < closest_distance:
			closest = unit
			closest_distance = distance
	return closest


func _draw_hover_focus() -> void:
	var selected := _get_hovered_unit()
	if selected == null:
		return
	var target := get_focus_target(selected)
	if target == null:
		return
	var source_pos := to_local(selected.global_position) + Vector2(0.0, -12.0)
	var target_pos := to_local(target.global_position) + Vector2(0.0, -12.0)
	var accent := PLAYER_MARK if selected.team == 0 else ENEMY_MARK
	var beam := Color(accent.r, accent.g, accent.b, 0.55)
	_draw_intent_arrow(source_pos, target_pos, beam, accent)
	# Ellipses align with the existing contact shadows at the boots.
	for unit in [selected, target]:
		var floor_point := to_local(unit.global_position) + Vector2(0.0, 36.0)
		draw_set_transform(floor_point, 0.0, Vector2(1.0, 0.34))
		draw_arc(Vector2.ZERO, maxf(27.0, unit.body_radius + 6.0), 0.0, TAU, 36,
			Color(accent.r, accent.g, accent.b, 0.77), 2.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_intent_arrow(
	from_point: Vector2,
	to_point: Vector2,
	line_color: Color,
	mark_color: Color
) -> void:
	draw_line(from_point, to_point, line_color, 2.0, true)
	var direction := from_point.direction_to(to_point)
	if direction.length_squared() <= 0.001:
		return
	var backward := -direction
	var normal := Vector2(-direction.y, direction.x)
	var arrow_left := to_point + backward * 13.0 + normal * 6.0
	var arrow_right := to_point + backward * 13.0 - normal * 6.0
	draw_line(arrow_left, to_point, mark_color, 2.0, true)
	draw_line(arrow_right, to_point, mark_color, 2.0, true)
	draw_arc(to_point, 6.0, 0.0, TAU, 20, mark_color, 2.0, true)
