extends Control

const INK := Color(0.018, 0.016, 0.026, 1.0)
const STONE_DARK := Color(0.050, 0.058, 0.066, 1.0)
const STONE_MID := Color(0.105, 0.115, 0.118, 1.0)
const BONE := Color(0.60, 0.56, 0.46, 1.0)
const TEAL := Color(0.12, 0.56, 0.50, 1.0)
const TEAL_DARK := Color(0.025, 0.16, 0.16, 1.0)

var pulse := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	if fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), INK)
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
			var shade := STONE_DARK.darkened(float((row + col) % 3) * 0.035)
			draw_rect(rect, shade)
			draw_rect(rect, Color(STONE_MID.r, STONE_MID.g, STONE_MID.b, 0.46), false, 1.0)

func _draw_floor() -> void:
	draw_rect(Rect2(0.0, 288.0, size.x, size.y - 288.0), Color(0.030, 0.032, 0.038, 1.0))
	for y in range(288, int(size.y), 64):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.10, 0.10, 0.11, 0.42), 1.0)
	for x in range(0, int(size.x), 96):
		draw_line(Vector2(x, 288), Vector2(x, size.y), Color(0.10, 0.10, 0.11, 0.30), 1.0)

func _draw_well() -> void:
	var center := Vector2(size.x * 0.5, 300.0)
	var glow := 0.92 + sin(pulse * 2.0) * 0.04
	draw_circle(center + Vector2(0, 18), 104.0, Color(TEAL.r, TEAL.g, TEAL.b, 0.035 * glow))

	draw_rect(Rect2(center.x - 82, center.y - 30, 164, 70), STONE_MID)
	draw_rect(Rect2(center.x - 82, center.y - 30, 164, 70), Color(BONE.r, BONE.g, BONE.b, 0.34), false, 2.0)
	draw_rect(Rect2(center.x - 96, center.y - 44, 192, 18), STONE_DARK)
	draw_rect(Rect2(center.x - 96, center.y - 44, 192, 18), Color(BONE.r, BONE.g, BONE.b, 0.24), false, 2.0)

	draw_rect(Rect2(center.x - 68, center.y - 22, 136, 44), TEAL_DARK)
	draw_rect(Rect2(center.x - 58, center.y - 14, 116, 26), Color(TEAL.r, TEAL.g, TEAL.b, 0.44 * glow))
	draw_rect(Rect2(center.x - 43, center.y - 8, 86, 7), Color(0.48, 0.76, 0.68, 0.20 * glow))

	for x in [center.x - 78, center.x - 30, center.x + 24]:
		draw_rect(Rect2(x, center.y - 23, 34, 62), Color(0.13, 0.16, 0.16, 1.0), false, 2.0)

func _draw_candles() -> void:
	var flicker := 1.0 + sin(pulse * 9.0) * 0.035
	for pos in [Vector2(310, 245), Vector2(970, 245)]:
		draw_rect(Rect2(pos.x - 6, pos.y, 12, 30), BONE.darkened(0.18))
		draw_rect(Rect2(pos.x - 2, pos.y - 10, 4, 10 * flicker), Color(0.48, 0.72, 0.62, 1.0))

func _draw_vignette() -> void:
	for i in range(7):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.014
		draw_rect(Rect2(inset, inset, size.x - inset * 2, size.y - inset * 2), Color(0, 0, 0, alpha), false, 9.0)
