extends Node2D

# The legal rectangles are shared with hero drag validation, but are never
# drawn as boxes or static slots. During dragging only, show a diffuse glow.
var regions: Array[Rect2] = []
var is_dragging := false


func set_regions(value: Array[Rect2]) -> void:
	regions = value.duplicate()
	is_dragging = false
	visible = not regions.is_empty()
	set_process(visible)
	queue_redraw()


func hide_markers() -> void:
	is_dragging = false
	set_process(false)
	visible = false


func _process(_delta: float) -> void:
	var dragging_now := false
	for child in get_parent().get_children():
		if child is BattleUnit:
			var unit := child as BattleUnit
			if unit.team == 0 and unit.alive and unit.dragging and unit.placement_enabled:
				dragging_now = true
				break

	if dragging_now != is_dragging:
		is_dragging = dragging_now
		queue_redraw()


func _draw() -> void:
	if not is_dragging:
		return

	# Layered faint floor ellipses reveal valid placement pockets only while
	# moving a hero. No rectangles, tile grid, or baked decorative circles.
	for region in regions:
		var center := region.position + region.size * 0.5
		var scale_on_floor := Vector2(region.size.x * 0.48, region.size.y * 0.48)
		draw_set_transform(center, 0.0, scale_on_floor)
		for radius in [1.0, 0.80, 0.60, 0.42]:
			draw_circle(Vector2.ZERO, radius, Color(0.81, 0.57, 0.29, 0.024))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
