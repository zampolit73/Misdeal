extends Control

var pulse := 0.0
var redraw_cooldown := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	redraw_cooldown -= delta
	if redraw_cooldown <= 0.0:
		redraw_cooldown = 0.06
		queue_redraw()

func _draw() -> void:
	_draw_choice_glows()
	_draw_embers()
	_draw_header_sigil()
	_draw_vignette()

func _draw_choice_glows() -> void:
	var breathe := 0.5 + 0.5 * sin(pulse * 1.8)
	var centers := [Vector2(276.0, 430.0), Vector2(640.0, 430.0), Vector2(1004.0, 430.0)]
	var colors := [
		Color(0.20, 0.46, 0.82, 0.030 + breathe * 0.010),
		Color(0.28, 0.64, 0.30, 0.030 + breathe * 0.010),
		Color(0.62, 0.34, 0.82, 0.030 + breathe * 0.010)
	]
	for index in range(centers.size()):
		draw_circle(centers[index], 180.0, colors[index])

func _draw_embers() -> void:
	for index in range(18):
		var seed := float(index + 1)
		var x := fmod(seed * 83.0 + pulse * (8.0 + float(index % 4)), maxf(1.0, size.x))
		var y := size.y - fmod(seed * 51.0 + pulse * (16.0 + float(index % 5) * 2.0), size.y + 50.0)
		draw_circle(Vector2(x, y), 1.0 + float(index % 2) * 0.5, Color(1.0, 0.24, 0.08, 0.045))

func _draw_header_sigil() -> void:
	var center := Vector2(size.x * 0.5, 88.0)
	var color := Color(0.92, 0.38, 0.18, 0.42)
	draw_arc(center, 15.0, 0.0, TAU, 24, color, 1.5)
	draw_line(center + Vector2(-24.0, 0.0), center + Vector2(24.0, 0.0), color, 1.0)
	draw_line(center + Vector2(0.0, -24.0), center + Vector2(0.0, 24.0), color, 1.0)

func _draw_vignette() -> void:
	for index in range(7):
		var inset := float(index) * 9.0
		var alpha := 0.020 + float(index) * 0.013
		draw_rect(Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0), Color(0.0, 0.0, 0.0, alpha), false, 10.0)
