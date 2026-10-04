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
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.014, 0.010, 0.018, 1.0))
	_draw_table()
	_draw_runner()
	_draw_sigil()
	_draw_props()
	_draw_candles()
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
	var runner := Rect2(102.0, 286.0, 1076.0, 390.0)
	draw_rect(runner, Color(0.155, 0.028, 0.034, 0.92))
	draw_rect(runner, Color(0.48, 0.16, 0.10, 0.88), false, 3.0)
	draw_rect(runner.grow(-8.0), Color(0.28, 0.065, 0.055, 0.55), false, 2.0)

	for y in [306.0, 654.0]:
		draw_line(Vector2(126.0, y), Vector2(1154.0, y), Color(0.55, 0.20, 0.12, 0.42), 2.0)

func _draw_sigil() -> void:
	var center := Vector2(size.x * 0.5, 505.0)
	var rune := Color(0.56, 0.18, 0.14, 0.30)
	draw_arc(center, 176.0, 0.0, TAU, 48, rune, 3.0)
	draw_arc(center, 96.0, 0.0, TAU, 40, rune, 2.0)

	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 96.0, center + dir * 176.0, rune, 2.0)

	var diamond := PackedVector2Array([
		center + Vector2(0, -46),
		center + Vector2(46, 0),
		center + Vector2(0, 46),
		center + Vector2(-46, 0),
		center + Vector2(0, -46)
	])
	draw_polyline(diamond, rune.lightened(0.08), 2.0)

func _draw_props() -> void:
	# Skull and goblet on the left.
	draw_circle(Vector2(48, 472), 26.0, Color(0.44, 0.38, 0.31, 1.0))
	draw_rect(Rect2(30, 484, 36, 20), Color(0.40, 0.34, 0.28, 1.0))
	draw_rect(Rect2(37, 465, 7, 7), Color(0.035, 0.026, 0.028, 1.0))
	draw_rect(Rect2(52, 465, 7, 7), Color(0.035, 0.026, 0.028, 1.0))

	draw_rect(Rect2(50, 355, 28, 9), Color(0.58, 0.38, 0.16, 1.0))
	draw_rect(Rect2(57, 364, 14, 35), Color(0.46, 0.28, 0.12, 1.0))
	draw_rect(Rect2(48, 397, 32, 8), Color(0.58, 0.38, 0.16, 1.0))

	# Hourglass and books on the right.
	draw_rect(Rect2(1208, 354, 24, 52), Color(0.40, 0.24, 0.12, 1.0), false, 3.0)
	draw_line(Vector2(1210, 357), Vector2(1230, 403), Color(0.60, 0.42, 0.22, 0.8), 2.0)
	draw_line(Vector2(1230, 357), Vector2(1210, 403), Color(0.60, 0.42, 0.22, 0.8), 2.0)

	for i in range(3):
		draw_rect(Rect2(1185 + i * 5, 455 - i * 10, 72, 16), Color(0.12 + i * 0.02, 0.045, 0.045, 1.0))
		draw_rect(Rect2(1185 + i * 5, 455 - i * 10, 72, 16), Color(0.40, 0.13, 0.10, 0.7), false, 2.0)

func _draw_candles() -> void:
	var flicker := 1.0 + sin(pulse * 11.0) * 0.08
	for pos in [
		Vector2(26, 306),
		Vector2(86, 610),
		Vector2(1196, 610),
		Vector2(1248, 320)
	]:
		draw_rect(Rect2(pos.x - 7.0, pos.y, 14.0, 38.0), Color(0.62, 0.49, 0.34, 1.0))
		draw_rect(Rect2(pos.x - 3.0, pos.y - 13.0, 6.0, 13.0 * flicker), Color(1.0, 0.38, 0.08, 1.0))
		draw_rect(Rect2(pos.x - 1.0, pos.y - 9.0, 2.0, 8.0 * flicker), Color(1.0, 0.82, 0.26, 1.0))
		draw_circle(pos + Vector2(0, -7), 16.0, Color(0.85, 0.18, 0.03, 0.07))

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
