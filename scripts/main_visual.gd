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
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.018, 0.014, 0.024, 1.0))
	_draw_sigil()
	_draw_cards()
	_draw_candles()
	_draw_eyes()
	_draw_vignette()

func _draw_sigil() -> void:
	var center := Vector2(size.x * 0.5, size.y * 0.53)
	var rune := Color(0.36, 0.12, 0.16, 0.28)
	draw_arc(center, 230.0, 0.0, TAU, 48, rune, 3.0)
	draw_arc(center, 150.0, 0.0, TAU, 40, rune, 2.0)
	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 150, center + dir * 230, rune, 2.0)

func _draw_cards() -> void:
	var center := Vector2(size.x * 0.5, 470)
	for entry in [
		{"offset": Vector2(-115, 0), "tilt": -1},
		{"offset": Vector2(0, -24), "tilt": 0},
		{"offset": Vector2(115, 0), "tilt": 1}
	]:
		var pos: Vector2 = center + entry["offset"]
		var rect := Rect2(pos - Vector2(42, 62), Vector2(84, 124))
		draw_rect(rect, Color(0.040, 0.025, 0.045, 0.94))
		draw_rect(rect, Color(0.48, 0.20, 0.22, 0.85), false, 3.0)
		draw_rect(rect.grow(-10), Color(0.16, 0.055, 0.11, 0.95), false, 2.0)
		draw_rect(Rect2(pos - Vector2(6, 6), Vector2(12, 12)), Color(0.70, 0.28, 0.22, 0.72))

func _draw_candles() -> void:
	var f := 1.0 + sin(pulse * 10.0) * 0.08
	for pos in [Vector2(190, 560), Vector2(1090, 560)]:
		draw_rect(Rect2(pos.x - 8, pos.y, 16, 46), Color(0.62, 0.52, 0.38, 1.0))
		draw_rect(Rect2(pos.x - 3, pos.y - 15, 6, 15 * f), Color(1.0, 0.42, 0.08, 1.0))
		draw_circle(pos + Vector2(0, -8), 18.0, Color(0.85, 0.20, 0.04, 0.08))

func _draw_eyes() -> void:
	var glow := 0.72 + sin(pulse * 2.2) * 0.20
	draw_rect(Rect2(590, 100, 12, 5), Color(1.0, 0.18, 0.10, glow))
	draw_rect(Rect2(678, 100, 12, 5), Color(1.0, 0.18, 0.10, glow))

func _draw_vignette() -> void:
	for i in range(8):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.015
		draw_rect(Rect2(inset, inset, size.x - inset * 2, size.y - inset * 2), Color(0, 0, 0, alpha), false, 9.0)
