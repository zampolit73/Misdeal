extends Control

var pulse_time := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse_time += delta
	queue_redraw()

func _draw() -> void:
	var center := size * Vector2(0.5, 0.52)
	var hood_color := Color(0.13, 0.045, 0.17, 1.0)
	var hood_shadow := Color(0.055, 0.018, 0.075, 1.0)
	var inner_color := Color(0.012, 0.009, 0.018, 1.0)
	var trim_color := Color(0.48, 0.18, 0.45, 1.0)
	var metal_color := Color(0.62, 0.48, 0.30, 1.0)
	var glow := 0.78 + sin(pulse_time * 2.2) * 0.18
	var eye_color := Color(1.0, 0.22, 0.12, glow)

	var shoulder_y := size.y - 6.0
	var shoulders := PackedVector2Array([
		Vector2(15.0, shoulder_y),
		Vector2(55.0, center.y + 24.0),
		Vector2(center.x, center.y + 15.0),
		Vector2(size.x - 55.0, center.y + 24.0),
		Vector2(size.x - 15.0, shoulder_y)
	])
	draw_colored_polygon(shoulders, hood_shadow)

	var hood_points := PackedVector2Array([
		Vector2(center.x, 3.0),
		Vector2(size.x - 30.0, size.y - 5.0),
		Vector2(30.0, size.y - 5.0)
	])
	draw_colored_polygon(hood_points, hood_color)
	draw_polyline(PackedVector2Array([
		hood_points[0],
		hood_points[1],
		hood_points[2],
		hood_points[0]
	]), trim_color, 3.0)

	draw_circle(center + Vector2(0.0, 12.0), 45.0, inner_color)
	draw_arc(center + Vector2(0.0, 12.0), 45.0, PI * 1.12, PI * 1.88, 28, trim_color, 2.0)

	draw_circle(center + Vector2(-17.0, 6.0), 7.5, Color(0.45, 0.05, 0.04, 0.18))
	draw_circle(center + Vector2(17.0, 6.0), 7.5, Color(0.45, 0.05, 0.04, 0.18))
	draw_circle(center + Vector2(-17.0, 6.0), 4.0, eye_color)
	draw_circle(center + Vector2(17.0, 6.0), 4.0, eye_color)

	draw_line(center + Vector2(-14.0, 29.0), center + Vector2(14.0, 29.0), Color(0.36, 0.16, 0.18, 0.7), 2.0)

	var crown_y := 8.0
	draw_line(Vector2(center.x - 22.0, crown_y + 10.0), Vector2(center.x + 22.0, crown_y + 10.0), metal_color, 2.0)
	draw_line(Vector2(center.x - 18.0, crown_y + 10.0), Vector2(center.x - 12.0, crown_y), metal_color, 2.0)
	draw_line(Vector2(center.x, crown_y + 10.0), Vector2(center.x, crown_y - 3.0), metal_color, 2.0)
	draw_line(Vector2(center.x + 18.0, crown_y + 10.0), Vector2(center.x + 12.0, crown_y), metal_color, 2.0)

	var orb_center := Vector2(size.x - 24.0, size.y - 23.0)
	draw_circle(orb_center, 11.0, Color(0.18, 0.03, 0.23, 0.9))
	draw_arc(orb_center, 14.0, 0.0, TAU, 20, Color(0.55, 0.18, 0.65, glow * 0.65), 2.0)
	draw_circle(orb_center, 4.0, Color(0.9, 0.25, 0.55, glow))
