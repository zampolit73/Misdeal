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
	var hood := Color(0.18, 0.055, 0.20, 1.0)
	var hood_dark := Color(0.065, 0.020, 0.080, 1.0)
	var outline := Color(0.48, 0.20, 0.42, 1.0)
	var skin_shadow := Color(0.035, 0.020, 0.040, 1.0)
	var gold := Color(0.62, 0.42, 0.20, 1.0)
	var glow := 0.78 + sin(pulse * 2.4) * 0.18
	var eye := Color(1.0, 0.22, 0.10, glow)

	var cx := size.x * 0.5
	var bottom := size.y - 5.0

	var shoulders := PackedVector2Array([
		Vector2(18, bottom),
		Vector2(54, 84),
		Vector2(cx - 34, 68),
		Vector2(cx + 34, 68),
		Vector2(size.x - 54, 84),
		Vector2(size.x - 18, bottom)
	])
	draw_colored_polygon(shoulders, hood_dark)

	var hood_poly := PackedVector2Array([
		Vector2(cx, 5),
		Vector2(size.x - 38, 104),
		Vector2(cx + 30, 88),
		Vector2(cx, 96),
		Vector2(cx - 30, 88),
		Vector2(38, 104)
	])
	draw_colored_polygon(hood_poly, hood)
	draw_polyline(PackedVector2Array([
		hood_poly[0], hood_poly[1], hood_poly[2], hood_poly[3], hood_poly[4], hood_poly[5], hood_poly[0]
	]), outline, 3.0)

	draw_rect(Rect2(cx - 33, 39, 66, 47), skin_shadow)
	draw_rect(Rect2(cx - 22, 49, 14, 5), Color(0.20, 0.035, 0.04, 0.45))
	draw_rect(Rect2(cx + 8, 49, 14, 5), Color(0.20, 0.035, 0.04, 0.45))
	draw_rect(Rect2(cx - 18, 50, 7, 4), eye)
	draw_rect(Rect2(cx + 11, 50, 7, 4), eye)
	draw_rect(Rect2(cx - 12, 72, 24, 2), Color(0.38, 0.13, 0.16, 0.8))

	draw_rect(Rect2(cx - 23, 15, 46, 4), gold)
	draw_rect(Rect2(cx - 20, 7, 4, 12), gold)
	draw_rect(Rect2(cx - 2, 3, 4, 16), gold)
	draw_rect(Rect2(cx + 16, 7, 4, 12), gold)

	var orb := Vector2(size.x - 25, size.y - 22)
	draw_rect(Rect2(orb - Vector2(8, 8), Vector2(16, 16)), Color(0.15, 0.035, 0.20, 1.0))
	draw_rect(Rect2(orb - Vector2(4, 4), Vector2(8, 8)), Color(0.86, 0.18, 0.52, glow))
	draw_rect(Rect2(orb - Vector2(11, 11), Vector2(22, 22)), Color(0.52, 0.20, 0.62, glow * 0.55), false, 2.0)
