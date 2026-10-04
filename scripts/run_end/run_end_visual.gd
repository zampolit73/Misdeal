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
	_draw_table()
	_draw_three_marks()
	_draw_wizard_shadow()
	_draw_vignette()

func _draw_table() -> void:
	draw_rect(Rect2(0, 390, size.x, size.y - 390), Color(0.080, 0.038, 0.040, 1.0))
	for y in range(390, int(size.y), 60):
		draw_line(Vector2(0, y), Vector2(size.x, y), Color(0.17, 0.08, 0.075, 0.75), 2.0)
	draw_rect(Rect2(0, 390, size.x, size.y - 390), Color(0.30, 0.13, 0.10, 0.60), false, 4.0)

func _draw_three_marks() -> void:
	var glow := 0.78 + sin(pulse * 2.0) * 0.12
	for x in [500.0, 640.0, 780.0]:
		draw_rect(Rect2(x - 18, 432, 36, 54), Color(0.050, 0.028, 0.050, 1.0))
		draw_rect(Rect2(x - 18, 432, 36, 54), Color(0.52, 0.24, 0.20, 0.85), false, 2.0)
		draw_rect(Rect2(x - 5, 450, 10, 10), Color(0.82, 0.36, 0.22, glow))

func _draw_wizard_shadow() -> void:
	var cx := size.x * 0.5
	var hood := PackedVector2Array([
		Vector2(cx, 65),
		Vector2(cx + 110, 315),
		Vector2(cx + 54, 286),
		Vector2(cx, 310),
		Vector2(cx - 54, 286),
		Vector2(cx - 110, 315)
	])
	draw_colored_polygon(hood, Color(0.055, 0.020, 0.065, 0.82))
	draw_rect(Rect2(cx - 42, 155, 84, 72), Color(0.010, 0.008, 0.014, 0.90))
	draw_rect(Rect2(cx - 24, 180, 8, 4), Color(1.0, 0.20, 0.10, 0.70))
	draw_rect(Rect2(cx + 16, 180, 8, 4), Color(1.0, 0.20, 0.10, 0.70))

func _draw_vignette() -> void:
	for i in range(8):
		var inset := float(i) * 8.0
		var alpha := 0.025 + float(i) * 0.015
		draw_rect(Rect2(inset, inset, size.x - inset * 2, size.y - inset * 2), Color(0, 0, 0, alpha), false, 9.0)
