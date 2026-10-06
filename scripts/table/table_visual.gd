extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.014, 0.010, 0.018, 1.0))
	_draw_table()
	_draw_light_pools()
	_draw_wood_details()
	_draw_runner()
	_draw_sigil()
	_draw_deck_zones()
	_draw_table_props()
	_draw_table_edge()
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

func _draw_light_pools() -> void:
	_draw_light_pool(Vector2(190.0, 370.0), Color(0.76, 0.26, 0.08, 0.11), 150.0)
	_draw_light_pool(Vector2(1090.0, 370.0), Color(0.76, 0.26, 0.08, 0.10), 150.0)
	_draw_light_pool(Vector2(640.0, 500.0), Color(0.46, 0.08, 0.08, 0.055), 255.0)

func _draw_light_pool(center: Vector2, color: Color, radius: float) -> void:
	for index in range(5, 0, -1):
		var ratio := float(index) / 5.0
		var layer := color
		layer.a *= (1.0 - ratio * 0.68)
		draw_circle(center, radius * ratio, layer)

func _draw_wood_details() -> void:
	var grain := Color(0.27, 0.10, 0.075, 0.24)
	var grain_dark := Color(0.025, 0.012, 0.016, 0.26)

	for row in range(7):
		var y := 276.0 + float(row) * 54.0
		var offset := 36.0 if row % 2 == 0 else 118.0
		for segment in range(4):
			var x := offset + float(segment) * 322.0
			draw_line(Vector2(x, y + 16.0), Vector2(x + 118.0, y + 13.0), grain, 1.0)
			draw_line(Vector2(x + 154.0, y + 34.0), Vector2(x + 254.0, y + 31.0), grain_dark, 1.0)

	var knots := [
		Vector2(72.0, 347.0),
		Vector2(302.0, 617.0),
		Vector2(1008.0, 294.0),
		Vector2(1190.0, 614.0)
	]
	for knot in knots:
		draw_arc(knot, 12.0, -0.8, 2.9, 16, Color(0.31, 0.11, 0.07, 0.34), 2.0)
		draw_arc(knot + Vector2(2.0, 1.0), 6.0, -0.6, 2.7, 12, Color(0.025, 0.010, 0.012, 0.36), 1.0)

func _draw_runner() -> void:
	var runner := Rect2(124.0, 322.0, 1032.0, 354.0)
	draw_rect(runner, Color(0.125, 0.024, 0.030, 0.90))
	draw_rect(runner, Color(0.42, 0.13, 0.09, 0.82), false, 3.0)
	draw_rect(runner.grow(-8.0), Color(0.24, 0.050, 0.050, 0.48), false, 2.0)

	for x in range(150, 1132, 36):
		draw_line(Vector2(float(x), 330.0), Vector2(float(x) + 10.0, 340.0), Color(0.47, 0.14, 0.10, 0.28), 1.0)
		draw_line(Vector2(float(x) + 10.0, 340.0), Vector2(float(x) + 20.0, 330.0), Color(0.47, 0.14, 0.10, 0.28), 1.0)

	draw_line(Vector2(148.0, 654.0), Vector2(1132.0, 654.0), Color(0.48, 0.16, 0.10, 0.38), 2.0)
	for x in range(152, 1130, 24):
		draw_line(Vector2(float(x), 660.0), Vector2(float(x) + 6.0, 670.0), Color(0.31, 0.08, 0.07, 0.38), 1.0)

func _draw_sigil() -> void:
	var center := Vector2(size.x * 0.5, 512.0)
	var rune := Color(0.56, 0.14, 0.12, 0.25)
	var rune_hot := Color(0.74, 0.20, 0.12, 0.12)
	draw_arc(center, 168.0, 0.0, TAU, 48, rune_hot, 7.0)
	draw_arc(center, 164.0, 0.0, TAU, 48, rune, 3.0)
	draw_arc(center, 90.0, 0.0, TAU, 40, rune, 2.0)

	for index in range(8):
		var angle := TAU * float(index) / 8.0
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 90.0, center + dir * 164.0, rune, 2.0)

	var diamond := PackedVector2Array([
		center + Vector2(0.0, -42.0),
		center + Vector2(42.0, 0.0),
		center + Vector2(0.0, 42.0),
		center + Vector2(-42.0, 0.0),
		center + Vector2(0.0, -42.0)
	])
	draw_polyline(diamond, rune.lightened(0.08), 2.0)

	for index in range(4):
		var angle := PI * 0.25 + PI * 0.5 * float(index)
		var rune_center := center + Vector2(cos(angle), sin(angle)) * 132.0
		_draw_small_rune(rune_center, angle, rune.lightened(0.12))

func _draw_small_rune(center: Vector2, rotation: float, color: Color) -> void:
	var direction := Vector2(cos(rotation), sin(rotation))
	var tangent := Vector2(-direction.y, direction.x)
	draw_line(center - direction * 8.0, center + direction * 8.0, color, 2.0)
	draw_line(center - tangent * 5.0, center + tangent * 5.0, color, 2.0)

func _draw_deck_zones() -> void:
	_draw_inlay(Rect2(84.0, 360.0, 194.0, 252.0), false)
	_draw_inlay(Rect2(1002.0, 360.0, 194.0, 252.0), true)

func _draw_inlay(rect: Rect2, mirrored: bool) -> void:
	var border := Color(0.47, 0.20, 0.13, 0.46)
	var inner := Color(0.68, 0.28, 0.15, 0.18)
	draw_rect(rect, Color(0.018, 0.010, 0.015, 0.18))
	draw_rect(rect, border, false, 2.0)
	draw_rect(rect.grow(-7.0), inner, false, 1.0)

	var sign := -1.0 if mirrored else 1.0
	var corner := rect.position + Vector2(22.0 if not mirrored else rect.size.x - 22.0, 22.0)
	draw_line(corner, corner + Vector2(sign * 18.0, 0.0), border, 2.0)
	draw_line(corner, corner + Vector2(0.0, 18.0), border, 2.0)

	var seal_center := rect.position + rect.size * 0.5
	draw_arc(seal_center, 39.0, 0.0, TAU, 28, Color(0.48, 0.13, 0.10, 0.18), 2.0)
	var diamond := PackedVector2Array([
		seal_center + Vector2(0.0, -17.0),
		seal_center + Vector2(14.0, 0.0),
		seal_center + Vector2(0.0, 17.0),
		seal_center + Vector2(-14.0, 0.0),
		seal_center + Vector2(0.0, -17.0)
	])
	draw_polyline(diamond, Color(0.58, 0.17, 0.11, 0.20), 2.0)

func _draw_table_props() -> void:
	_draw_coin(Vector2(310.0, 629.0), 10.0)
	_draw_coin(Vector2(326.0, 621.0), 8.0)
	_draw_coin(Vector2(338.0, 634.0), 7.0)

	var seal_center := Vector2(956.0, 628.0)
	draw_circle(seal_center, 17.0, Color(0.34, 0.035, 0.035, 0.92))
	draw_circle(seal_center, 13.0, Color(0.56, 0.07, 0.05, 0.90))
	draw_arc(seal_center, 8.0, 0.0, TAU, 18, Color(0.86, 0.30, 0.14, 0.58), 2.0)
	draw_line(seal_center + Vector2(-4.0, -5.0), seal_center + Vector2(5.0, 5.0), Color(0.92, 0.38, 0.18, 0.62), 2.0)
	draw_line(seal_center + Vector2(-5.0, 5.0), seal_center + Vector2(5.0, -5.0), Color(0.92, 0.38, 0.18, 0.62), 2.0)

	var ribbon := PackedVector2Array([
		seal_center + Vector2(-8.0, 13.0),
		seal_center + Vector2(-2.0, 13.0),
		seal_center + Vector2(-5.0, 35.0),
		seal_center + Vector2(-13.0, 28.0)
	])
	draw_colored_polygon(ribbon, Color(0.22, 0.022, 0.026, 0.86))

func _draw_coin(center: Vector2, radius: float) -> void:
	draw_circle(center + Vector2(2.0, 3.0), radius, Color(0, 0, 0, 0.30))
	draw_circle(center, radius, Color(0.45, 0.29, 0.10, 0.95))
	draw_arc(center, radius - 2.0, 0.0, TAU, 18, Color(0.82, 0.56, 0.20, 0.78), 2.0)
	draw_line(center + Vector2(-3.0, 0.0), center + Vector2(3.0, 0.0), Color(0.90, 0.66, 0.28, 0.62), 1.0)

func _draw_table_edge() -> void:
	var top := 676.0
	draw_rect(Rect2(0.0, top, size.x, size.y - top), Color(0.038, 0.016, 0.020, 0.96))
	draw_line(Vector2(0.0, top), Vector2(size.x, top), Color(0.48, 0.17, 0.10, 0.72), 3.0)
	draw_line(Vector2(0.0, top + 7.0), Vector2(size.x, top + 7.0), Color(0.12, 0.046, 0.040, 0.88), 2.0)

	for x in range(64, 1280, 128):
		draw_circle(Vector2(float(x), 699.0), 3.5, Color(0.35, 0.22, 0.12, 0.78))
		draw_circle(Vector2(float(x), 698.0), 1.5, Color(0.75, 0.49, 0.22, 0.65))

func _draw_vignette() -> void:
	for index in range(7):
		var inset := float(index) * 8.0
		var alpha := 0.025 + float(index) * 0.014
		draw_rect(
			Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0),
			Color(0, 0, 0, alpha),
			false,
			9.0
		)
