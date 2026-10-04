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
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.020, 0.028, 0.035, 1.0))
	_draw_wall()
	_draw_floor()
	_draw_well()
	_draw_candles()
	_draw_vignette()

func _draw_wall() -> void:
	var brick_w := 72.0
	var brick_h := 36.0
	for row in range(8):
		var offset := 0.0 if row % 2 == 0 else brick_w * 0.5
		for col in range(int(size.x / brick_w) + 2):
			var x := float(col) * brick_w - offset
			var rect := Rect2(x + 2.0, float(row) * brick_h + 2.0, brick_w - 4.0, brick_h - 4.0)
			var shade := Color(0.045, 0.060, 0.068, 1.0).darkened(float((row + col) % 3) * 0.05)
			draw_rect(rect, shade)
			draw_rect(rect, Color(0.08, 0.11, 0.12, 0.70), false, 1.0)

func _draw_floor() -> void:
	draw_rect(Rect2(0.0, 288.0, size.x, size.y - 288.0), Color(0.030, 0.038, 0.044, 1.0))
	for y in range(288, int(size.y), 48):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.07, 0.08, 0.085, 0.75), 1.0)
	for x in range(0, int(size.x), 64):
		draw_line(Vector2(x, 288), Vector2(x, size.y), Color(0.07, 0.08, 0.085, 0.55), 1.0)

func _draw_well() -> void:
	var center := Vector2(size.x * 0.5, 300.0)
	var glow := 0.78 + sin(pulse * 2.5) * 0.14
	draw_circle(center + Vector2(0, 18), 118.0, Color(0.04, 0.24, 0.25, 0.08 * glow))

	draw_rect(Rect2(center.x - 82, center.y - 30, 164, 70), Color(0.085, 0.105, 0.11, 1.0))
	draw_rect(Rect2(center.x - 82, center.y - 30, 164, 70), Color(0.18, 0.24, 0.24, 0.8), false, 3.0)
	draw_rect(Rect2(center.x - 96, center.y - 44, 192, 18), Color(0.11, 0.15, 0.15, 1.0))
	draw_rect(Rect2(center.x - 96, center.y - 44, 192, 18), Color(0.24, 0.33, 0.32, 0.9), false, 2.0)

	draw_rect(Rect2(center.x - 68, center.y - 22, 136, 44), Color(0.012, 0.055, 0.060, 1.0))
	draw_rect(Rect2(center.x - 58, center.y - 14, 116, 26), Color(0.025, 0.36, 0.35, 0.65 * glow))
	draw_rect(Rect2(center.x - 43, center.y - 8, 86, 8), Color(0.30, 0.90, 0.82, 0.30 * glow))

	for x in [center.x - 78, center.x - 30, center.x + 24]:
		draw_rect(Rect2(x, center.y - 23, 34, 62), Color(0.13, 0.16, 0.16, 1.0), false, 2.0)

func _draw_candles() -> void:
	var flicker := 1.0 + sin(pulse * 11.0) * 0.08
	for pos in [Vector2(310, 245), Vector2(970, 245), Vector2(245, 420), Vector2(1035, 420)]:
		draw_rect(Rect2(pos.x - 6, pos.y, 12, 30), Color(0.58, 0.54, 0.40, 1.0))
		draw_rect(Rect2(pos.x - 2, pos.y - 11, 4, 11 * flicker), Color(0.34, 0.95, 0.78, 1.0))
		draw_circle(pos + Vector2(0, -6), 13.0, Color(0.10, 0.65, 0.56, 0.08))

func _draw_vignette() -> void:
	for i in range(7):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.014
		draw_rect(Rect2(inset, inset, size.x - inset * 2, size.y - inset * 2), Color(0, 0, 0, alpha), false, 9.0)
