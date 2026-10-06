extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.014, 0.010, 0.018, 1.0))
	_draw_table()
	_draw_soft_runner()
	_draw_faint_sigil()
	_draw_table_edge()
	_draw_vignette()

func _draw_table() -> void:
	var top := 255.0
	var wood_a := Color(0.092, 0.036, 0.031, 1.0)
	var wood_b := Color(0.074, 0.028, 0.027, 1.0)
	var seam := Color(0.18, 0.070, 0.056, 0.34)

	draw_rect(Rect2(0.0, top, size.x, size.y - top), wood_a)

	var plank_h := 58.0
	var row := 0
	var y := top
	while y < size.y:
		var shade := wood_a if row % 2 == 0 else wood_b
		draw_rect(Rect2(0.0, y, size.x, plank_h), shade)
		draw_line(Vector2(0.0, y), Vector2(size.x, y), seam, 1.0)
		y += plank_h
		row += 1

	_draw_subtle_grain(top)

func _draw_subtle_grain(top: float) -> void:
	var light_grain := Color(0.24, 0.085, 0.064, 0.13)
	var dark_grain := Color(0.018, 0.009, 0.012, 0.16)

	for row in range(6):
		var y := top + 24.0 + float(row) * 61.0
		var offset := 70.0 if row % 2 == 0 else 160.0
		for segment in range(4):
			var x := offset + float(segment) * 300.0
			draw_line(Vector2(x, y), Vector2(x + 104.0, y - 2.0), light_grain, 1.0)
			draw_line(Vector2(x + 142.0, y + 18.0), Vector2(x + 224.0, y + 16.0), dark_grain, 1.0)

func _draw_soft_runner() -> void:
	var runner := Rect2(300.0, 315.0, 680.0, 365.0)
	draw_rect(runner, Color(0.095, 0.018, 0.024, 0.32))
	draw_line(runner.position, Vector2(runner.position.x + runner.size.x, runner.position.y), Color(0.40, 0.12, 0.09, 0.16), 1.0)
	draw_line(Vector2(runner.position.x, runner.position.y + runner.size.y), runner.position + runner.size, Color(0.40, 0.12, 0.09, 0.13), 1.0)

func _draw_faint_sigil() -> void:
	var center := Vector2(size.x * 0.5, 510.0)
	var rune := Color(0.58, 0.14, 0.11, 0.075)

	draw_arc(center, 150.0, 0.0, TAU, 48, rune, 2.0)
	draw_arc(center, 78.0, 0.0, TAU, 36, rune, 1.0)

	var diamond := PackedVector2Array([
		center + Vector2(0.0, -34.0),
		center + Vector2(34.0, 0.0),
		center + Vector2(0.0, 34.0),
		center + Vector2(-34.0, 0.0),
		center + Vector2(0.0, -34.0)
	])
	draw_polyline(diamond, rune.lightened(0.04), 1.0)

func _draw_table_edge() -> void:
	var top := 680.0
	draw_rect(Rect2(0.0, top, size.x, size.y - top), Color(0.035, 0.015, 0.019, 0.94))
	draw_line(Vector2(0.0, top), Vector2(size.x, top), Color(0.34, 0.11, 0.075, 0.44), 2.0)

func _draw_vignette() -> void:
	for index in range(6):
		var inset := float(index) * 9.0
		var alpha := 0.018 + float(index) * 0.010
		draw_rect(
			Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0),
			Color(0, 0, 0, alpha),
			false,
			8.0
		)
