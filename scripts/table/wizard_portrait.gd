extends Control

var pulse_time := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse_time += delta
	queue_redraw()

func _draw() -> void:
	var center := size * Vector2(0.5, 0.54)
	var hood_color := Color(0.12, 0.06, 0.16, 1.0)
	var inner_color := Color(0.025, 0.018, 0.032, 1.0)
	var trim_color := Color(0.34, 0.16, 0.38, 1.0)
	var glow := 0.72 + sin(pulse_time * 2.2) * 0.18
	var eye_color := Color(0.86, 0.20, 0.16, glow)

	var hood_points := PackedVector2Array([
		Vector2(center.x, 8.0),
		Vector2(size.x - 22.0, size.y - 12.0),
		Vector2(22.0, size.y - 12.0)
	])
	draw_colored_polygon(hood_points, hood_color)
	draw_polyline(PackedVector2Array([
		hood_points[0],
		hood_points[1],
		hood_points[2],
		hood_points[0]
	]), trim_color, 3.0)

	draw_circle(center + Vector2(0.0, 12.0), 48.0, inner_color)
	draw_circle(center + Vector2(-17.0, 7.0), 4.5, eye_color)
	draw_circle(center + Vector2(17.0, 7.0), 4.5, eye_color)

	draw_arc(center + Vector2(0.0, 15.0), 33.0, 0.15, PI - 0.15, 24, trim_color, 2.0)
