extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var wood_dark := Color(0.075, 0.035, 0.04, 1.0)
	var wood_mid := Color(0.13, 0.065, 0.065, 1.0)
	var seam := Color(0.22, 0.11, 0.09, 0.55)
	var rune := Color(0.45, 0.16, 0.18, 0.34)
	var edge := Color(0.32, 0.16, 0.11, 0.9)

	draw_rect(rect, wood_dark)

	var plank_height := 58.0
	var y := 0.0
	var plank_index := 0
	while y < size.y:
		var plank_rect := Rect2(0.0, y, size.x, plank_height)
		var shade := wood_mid.lightened(0.02) if plank_index % 2 == 0 else wood_mid.darkened(0.06)
		draw_rect(plank_rect, shade)
		draw_line(Vector2(0.0, y), Vector2(size.x, y), seam, 2.0)

		var knot_x := 90.0 + float((plank_index * 173) % 860)
		draw_arc(Vector2(knot_x, y + plank_height * 0.52), 12.0, 0.0, TAU, 20, seam, 2.0)
		draw_arc(Vector2(knot_x, y + plank_height * 0.52), 6.0, 0.0, TAU, 16, seam, 1.0)

		y += plank_height
		plank_index += 1

	draw_rect(rect, edge, false, 5.0)

	var center := size * 0.5
	var sigil_radius := minf(size.x, size.y) * 0.29
	draw_arc(center, sigil_radius, 0.0, TAU, 64, rune, 3.0)
	draw_arc(center, sigil_radius * 0.68, 0.0, TAU, 48, rune, 2.0)

	for i in range(6):
		var angle := TAU * float(i) / 6.0 - PI * 0.5
		var outer := center + Vector2(cos(angle), sin(angle)) * sigil_radius
		var inner := center + Vector2(cos(angle), sin(angle)) * sigil_radius * 0.38
		draw_line(inner, outer, rune, 2.0)

	var flame_color := Color(1.0, 0.52, 0.18, 0.88)
	var ember_color := Color(0.75, 0.16, 0.08, 0.34)
	for candle_x in [42.0, size.x - 42.0]:
		draw_rect(Rect2(candle_x - 8.0, 70.0, 16.0, 52.0), Color(0.68, 0.59, 0.44, 1.0))
		draw_circle(Vector2(candle_x, 63.0), 9.0, ember_color)
		draw_circle(Vector2(candle_x, 63.0), 4.5, flame_color)
