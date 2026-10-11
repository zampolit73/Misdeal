extends Node2D

# Authored-chalk deployment guides are drawn from the same legal regions
# used by hero drag validation. They are not a second tactical grid.
var regions: Array[Rect2] = []


func set_regions(value: Array[Rect2]) -> void:
	regions = value.duplicate()
	visible = not regions.is_empty()
	queue_redraw()


func hide_markers() -> void:
	visible = false


func _draw() -> void:
	var chalk := Color(0.92, 0.77, 0.55, 0.68)
	var edge := Color(0.88, 0.71, 0.47, 0.39)
	for region in regions:
		# Restrained worn-stone tint, not the old blue debug rectangles.
		draw_rect(region, Color(0.24, 0.16, 0.08, 0.09))
		draw_rect(region, edge, false, 1.0)

		var columns: int = 3 if region.size.x >= 300.0 else (2 if region.size.x >= 160.0 else 1)
		var rows: int = 2 if region.size.y >= 105.0 else 1
		for row in range(rows):
			for column in range(columns):
				var center := region.position + Vector2(
					region.size.x * (float(column) + 0.5) / float(columns),
					region.size.y * (float(row) + 0.5) / float(rows)
				)
				# Ellipses follow the floor plane and never behave as fixed slots:
				# the player may drag anywhere inside the outlined legal regions.
				draw_set_transform(center, 0.0, Vector2(1.0, 0.38))
				draw_circle(Vector2.ZERO, 27.0, Color(0.025, 0.018, 0.013, 0.21))
				draw_arc(Vector2.ZERO, 25.0, 0.0, TAU, 32, chalk, 1.6)
				draw_arc(Vector2.ZERO, 19.0, 0.0, TAU, 32, Color(chalk.r, chalk.g, chalk.b, 0.24), 1.0)
				draw_line(Vector2(-32.0, 0.0), Vector2(-22.0, 0.0), edge, 1.0)
				draw_line(Vector2(22.0, 0.0), Vector2(32.0, 0.0), edge, 1.0)
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
