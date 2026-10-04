extends Control

var pulse := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	if fmod(pulse, 0.1) < delta:
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.026, 0.020, 0.030, 1.0))
	_draw_wall()
	_draw_floor()
	_draw_altars()
	_draw_candles()
	_draw_vignette()

func _draw_wall() -> void:
	for row in range(6):
		for col in range(12):
			var rect := Rect2(float(col) * 108.0 + 2.0, float(row) * 48.0 + 2.0, 104.0, 44.0)
			var shade := Color(0.050, 0.038, 0.052, 1.0).darkened(float((row + col) % 3) * 0.04)
			draw_rect(rect, shade)
			draw_rect(rect, Color(0.11, 0.075, 0.10, 0.55), false, 1.0)

func _draw_floor() -> void:
	draw_rect(Rect2(0, 288, size.x, size.y - 288), Color(0.040, 0.031, 0.042, 1.0))
	for y in range(288, int(size.y), 52):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.095, 0.068, 0.083, 0.65), 1.0)

func _draw_altars() -> void:
	var centers := [Vector2(275, 485), Vector2(640, 485), Vector2(1005, 485)]
	var accent := [
		Color(0.72, 0.20, 0.12, 0.72),
		Color(0.45, 0.55, 0.62, 0.72),
		Color(0.68, 0.46, 0.18, 0.72)
	]
	for i in range(3):
		var c: Vector2 = centers[i]
		draw_rect(Rect2(c.x - 98, c.y - 18, 196, 34), Color(0.075, 0.055, 0.068, 1.0))
		draw_rect(Rect2(c.x - 98, c.y - 18, 196, 34), accent[i], false, 2.0)
		draw_rect(Rect2(c.x - 72, c.y + 16, 144, 44), Color(0.048, 0.038, 0.050, 1.0))
		draw_rect(Rect2(c.x - 72, c.y + 16, 144, 44), Color(0.18, 0.13, 0.15, 0.75), false, 2.0)
		draw_rect(Rect2(c.x - 8, c.y - 30, 16, 16), accent[i].lightened(0.12))

func _draw_candles() -> void:
	var f := 1.0 + sin(pulse * 10.0) * 0.08
	for pos in [Vector2(85, 560), Vector2(1195, 560), Vector2(615, 250), Vector2(665, 250)]:
		draw_rect(Rect2(pos.x - 6, pos.y, 12, 30), Color(0.63, 0.52, 0.38, 1.0))
		draw_rect(Rect2(pos.x - 3, pos.y - 12, 6, 12 * f), Color(1.0, 0.45, 0.10, 1.0))
		draw_circle(pos + Vector2(0, -6), 14.0, Color(0.8, 0.18, 0.04, 0.07))

func _draw_vignette() -> void:
	for i in range(7):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.014
		draw_rect(Rect2(inset, inset, size.x - inset * 2, size.y - inset * 2), Color(0, 0, 0, alpha), false, 9.0)
