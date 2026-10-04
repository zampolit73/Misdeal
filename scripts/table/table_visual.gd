extends Control

var pulse := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	if fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	var wall := Color(0.030, 0.024, 0.035, 1.0)
	var wood_a := Color(0.105, 0.050, 0.048, 1.0)
	var wood_b := Color(0.085, 0.040, 0.042, 1.0)
	var seam := Color(0.20, 0.095, 0.085, 0.72)
	var rune := Color(0.46, 0.17, 0.17, 0.34)

	draw_rect(Rect2(Vector2.ZERO, size), wall)
	_draw_wall()
	_draw_table(wood_a, wood_b, seam)
	_draw_sigil(rune)
	_draw_candles()
	_draw_deck()
	_draw_vignette()

func _draw_wall() -> void:
	var brick_w := 64.0
	var brick_h := 34.0
	for row in range(5):
		var offset := 0.0 if row % 2 == 0 else brick_w * 0.5
		for col in range(int(size.x / brick_w) + 2):
			var x := float(col) * brick_w - offset
			var rect := Rect2(x + 2.0, float(row) * brick_h + 2.0, brick_w - 4.0, brick_h - 4.0)
			var shade := Color(0.052, 0.039, 0.055, 1.0).darkened(float((row + col) % 3) * 0.04)
			draw_rect(rect, shade)
			draw_rect(rect, Color(0.10, 0.075, 0.10, 0.65), false, 1.0)

	draw_rect(Rect2(0.0, 165.0, size.x, 5.0), Color(0.22, 0.10, 0.10, 0.9))

func _draw_table(wood_a: Color, wood_b: Color, seam: Color) -> void:
	var top := 170.0
	draw_rect(Rect2(0.0, top, size.x, size.y - top), wood_a)

	var plank_h := 58.0
	var row := 0
	var y := top
	while y < size.y:
		var shade := wood_a if row % 2 == 0 else wood_b
		draw_rect(Rect2(0.0, y, size.x, plank_h), shade)
		draw_line(Vector2(0.0, y), Vector2(size.x, y), seam, 2.0)

		for knot_x in [180.0 + float((row * 97) % 280), 760.0 + float((row * 71) % 300)]:
			draw_rect(Rect2(knot_x, y + 23.0, 18.0, 5.0), Color(0.055, 0.022, 0.026, 0.72))
			draw_rect(Rect2(knot_x + 5.0, y + 19.0, 7.0, 13.0), Color(0.065, 0.027, 0.030, 0.52))

		y += plank_h
		row += 1

	draw_rect(Rect2(0.0, top, size.x, size.y - top), Color(0.36, 0.16, 0.12, 0.75), false, 4.0)

func _draw_sigil(rune: Color) -> void:
	var center := Vector2(size.x * 0.5, 445.0)
	draw_arc(center, 178.0, 0.0, TAU, 48, rune, 3.0)
	draw_arc(center, 106.0, 0.0, TAU, 40, rune, 2.0)

	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 106.0, center + dir * 178.0, rune, 2.0)

	var diamond := PackedVector2Array([
		center + Vector2(0, -42),
		center + Vector2(42, 0),
		center + Vector2(0, 42),
		center + Vector2(-42, 0),
		center + Vector2(0, -42)
	])
	draw_polyline(diamond, rune.lightened(0.08), 2.0)

func _draw_candles() -> void:
	var flicker := 1.0 + sin(pulse * 10.0) * 0.08
	for pos in [Vector2(52, 132), Vector2(1220, 132), Vector2(90, 610), Vector2(1185, 610)]:
		draw_rect(Rect2(pos.x - 7.0, pos.y, 14.0, 34.0), Color(0.63, 0.50, 0.34, 1.0))
		draw_rect(Rect2(pos.x - 5.0, pos.y + 4.0, 4.0, 10.0), Color(0.80, 0.70, 0.52, 0.55))
		draw_rect(Rect2(pos.x - 3.0, pos.y - 12.0, 6.0, 12.0 * flicker), Color(1.0, 0.38, 0.08, 1.0))
		draw_rect(Rect2(pos.x - 1.0, pos.y - 9.0, 2.0, 7.0 * flicker), Color(1.0, 0.82, 0.28, 1.0))
		draw_circle(pos + Vector2(0, -6), 15.0, Color(0.78, 0.20, 0.04, 0.08))

func _draw_deck() -> void:
	var origin := Vector2(28.0, 360.0)
	for i in range(4):
		var offset := Vector2(float(i) * 3.0, float(i) * -3.0)
		var rect := Rect2(origin + offset, Vector2(62.0, 92.0))
		draw_rect(rect, Color(0.045, 0.025, 0.050, 1.0))
		draw_rect(rect, Color(0.48, 0.20, 0.23, 1.0), false, 2.0)
		draw_rect(rect.grow(-8.0), Color(0.16, 0.06, 0.12, 1.0), false, 2.0)
		var center := rect.get_center()
		draw_rect(Rect2(center - Vector2(5, 5), Vector2(10, 10)), Color(0.65, 0.28, 0.24, 0.65))

func _draw_vignette() -> void:
	for i in range(7):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.014
		draw_rect(Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0), Color(0, 0, 0, alpha), false, 9.0)
