extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.014, 0.010, 0.018, 1.0))
	_draw_table()
	_draw_runner()
	_draw_sigil()
	_draw_vignette()

func _draw_table() -> void:
	var top := 255.0
	var wood_a := Color(0.095, 0.038, 0.032, 1.0)
	var wood_b := Color(0.075, 0.029, 0.029, 1.0)
	var seam := Color(0.19, 0.075, 0.060, 0.72)

	draw_rect(Rect2(0.0, top, size.x, size.y - top), wood_a)

	var plank_h := 54.0
	var row := 0
	var y := top
	while y < size.y:
		var shade := wood_a if row % 2 == 0 else wood_b
		draw_rect(Rect2(0.0, y, size.x, plank_h), shade)
		draw_line(Vector2(0.0, y), Vector2(size.x, y), seam, 2.0)
		y += plank_h
		row += 1

	draw_rect(Rect2(0.0, top, size.x, size.y - top), Color(0.34, 0.13, 0.09, 0.8), false, 4.0)

func _draw_runner() -> void:
	var runner := Rect2(124.0, 322.0, 1032.0, 354.0)
	draw_rect(runner, Color(0.125, 0.024, 0.030, 0.88))
	draw_rect(runner, Color(0.42, 0.13, 0.09, 0.76), false, 3.0)
	draw_rect(runner.grow(-8.0), Color(0.24, 0.050, 0.050, 0.42), false, 2.0)

	draw_line(Vector2(148.0, 654.0), Vector2(1132.0, 654.0), Color(0.48, 0.16, 0.10, 0.34), 2.0)

func _draw_sigil() -> void:
	var center := Vector2(size.x * 0.5, 512.0)
	var rune := Color(0.50, 0.14, 0.12, 0.24)
	draw_arc(center, 164.0, 0.0, TAU, 48, rune, 3.0)
	draw_arc(center, 90.0, 0.0, TAU, 40, rune, 2.0)

	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 90.0, center + dir * 164.0, rune, 2.0)

	var diamond := PackedVector2Array([
		center + Vector2(0, -42),
		center + Vector2(42, 0),
		center + Vector2(0, 42),
		center + Vector2(-42, 0),
		center + Vector2(0, -42)
	])
	draw_polyline(diamond, rune.lightened(0.08), 2.0)

func _draw_vignette() -> void:
	for i in range(7):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.014
		draw_rect(
			Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0),
			Color(0, 0, 0, alpha),
			false,
			9.0
		)
