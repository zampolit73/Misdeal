extends Control

@export var accent := Color(0.86, 0.30, 0.14, 1.0)
@export var secondary := Color(0.24, 0.08, 0.10, 1.0)
@export var ember_count := 18
@export var variant := "generic"

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
	_draw_table_shade()
	_draw_variant()
	_draw_embers()
	_draw_corner_marks()
	_draw_vignette()

func _draw_table_shade() -> void:
	draw_rect(Rect2(0.0, 0.0, size.x, 120.0), Color(0.01, 0.006, 0.012, 0.18))
	draw_rect(Rect2(0.0, 420.0, size.x, maxf(0.0, size.y - 420.0)), Color(0.008, 0.005, 0.009, 0.24))
	var breathe := 0.5 + 0.5 * sin(pulse * 1.7)
	draw_circle(Vector2(size.x * 0.5, 360.0), 280.0, Color(secondary.r, secondary.g, secondary.b, 0.025 + breathe * 0.012))

func _draw_variant() -> void:
	match variant:
		"forge":
			_draw_forge_glow()
		"chains":
			_draw_chain_marks()
		"altar":
			_draw_altar_marks()
		"bridge":
			_draw_bridge_fog()
		"candles":
			_draw_candle_glow()
		"bones":
			_draw_bone_marks()

func _draw_forge_glow() -> void:
	var flicker := 0.5 + 0.5 * sin(pulse * 8.0)
	draw_circle(Vector2(130.0, 470.0), 190.0, Color(1.0, 0.22, 0.04, 0.040 + flicker * 0.020))
	draw_circle(Vector2(1160.0, 470.0), 130.0, Color(0.92, 0.12, 0.03, 0.025 + flicker * 0.012))
	for index in range(10):
		var x := 74.0 + float(index) * 18.0 + sin(pulse * 3.0 + float(index)) * 6.0
		var y := 540.0 - fmod(pulse * (24.0 + float(index)) + float(index * 29), 190.0)
		draw_circle(Vector2(x, y), 1.4 + float(index % 2), Color(1.0, 0.45, 0.08, 0.15))

func _draw_chain_marks() -> void:
	var color := Color(accent.r, accent.g, accent.b, 0.10)
	for index in range(5):
		var y := 116.0 + float(index) * 112.0
		draw_arc(Vector2(58.0, y), 15.0, 0.0, TAU, 18, color, 2.0)
		draw_arc(Vector2(size.x - 58.0, y + 34.0), 15.0, 0.0, TAU, 18, color, 2.0)
		if index < 4:
			draw_line(Vector2(58.0, y + 15.0), Vector2(58.0, y + 97.0), color, 2.0)
			draw_line(Vector2(size.x - 58.0, y + 49.0), Vector2(size.x - 58.0, y + 131.0), color, 2.0)

func _draw_altar_marks() -> void:
	var center := Vector2(size.x * 0.5, 462.0)
	var breathe := 0.5 + 0.5 * sin(pulse * 2.4)
	var color := Color(accent.r, accent.g, accent.b, 0.08 + breathe * 0.025)
	draw_arc(center, 240.0, 0.0, TAU, 64, color, 2.0)
	draw_arc(center, 176.0, 0.0, TAU, 56, Color(color.r, color.g, color.b, color.a * 0.75), 1.0)
	for index in range(6):
		var angle := TAU * float(index) / 6.0
		draw_line(center + Vector2.from_angle(angle) * 176.0, center + Vector2.from_angle(angle) * 240.0, color, 1.0)

func _draw_bridge_fog() -> void:
	var drift := fmod(pulse * 16.0, 260.0)
	for index in range(5):
		var x := -150.0 + drift + float(index) * 310.0
		var y := 500.0 + float(index % 2) * 45.0
		draw_circle(Vector2(x, y), 130.0, Color(0.28, 0.48, 0.62, 0.026))
		draw_circle(Vector2(x + 110.0, y + 18.0), 84.0, Color(0.28, 0.48, 0.62, 0.018))

func _draw_candle_glow() -> void:
	var flicker := 0.5 + 0.5 * sin(pulse * 9.0)
	for point in [Vector2(90.0, 210.0), Vector2(1188.0, 210.0), Vector2(105.0, 590.0), Vector2(1175.0, 590.0)]:
		draw_circle(point, 64.0 + flicker * 8.0, Color(1.0, 0.38, 0.08, 0.030 + flicker * 0.014))

func _draw_bone_marks() -> void:
	var color := Color(0.78, 0.68, 0.52, 0.08)
	for index in range(7):
		var x := 75.0 + float(index) * 184.0
		var y := 600.0 + sin(float(index) * 1.4) * 22.0
		draw_line(Vector2(x - 12.0, y), Vector2(x + 12.0, y + 8.0), color, 3.0)
		draw_circle(Vector2(x - 13.0, y - 1.0), 3.0, color)
		draw_circle(Vector2(x + 13.0, y + 9.0), 3.0, color)

func _draw_embers() -> void:
	if ember_count <= 0:
		return

	for index in range(ember_count):
		var seed := float(index + 1)
		var x := fmod(seed * 91.0 + pulse * (7.0 + float(index % 5)), maxf(1.0, size.x))
		var y := size.y - fmod(seed * 47.0 + pulse * (15.0 + float(index % 4) * 2.5), size.y + 60.0)
		var radius := 0.8 + float(index % 3) * 0.45
		var alpha := 0.05 + float(index % 4) * 0.012
		draw_circle(Vector2(x, y), radius, Color(accent.r, accent.g, accent.b, alpha))

func _draw_corner_marks() -> void:
	var line_color := Color(accent.r, accent.g, accent.b, 0.18)
	var inset := 24.0
	var length := 62.0
	draw_line(Vector2(inset, inset), Vector2(inset + length, inset), line_color, 1.0)
	draw_line(Vector2(inset, inset), Vector2(inset, inset + length), line_color, 1.0)
	draw_line(Vector2(size.x - inset, inset), Vector2(size.x - inset - length, inset), line_color, 1.0)
	draw_line(Vector2(size.x - inset, inset), Vector2(size.x - inset, inset + length), line_color, 1.0)
	draw_line(Vector2(inset, size.y - inset), Vector2(inset + length, size.y - inset), line_color, 1.0)
	draw_line(Vector2(inset, size.y - inset), Vector2(inset, size.y - inset - length), line_color, 1.0)
	draw_line(Vector2(size.x - inset, size.y - inset), Vector2(size.x - inset - length, size.y - inset), line_color, 1.0)
	draw_line(Vector2(size.x - inset, size.y - inset), Vector2(size.x - inset, size.y - inset - length), line_color, 1.0)

func _draw_vignette() -> void:
	for index in range(7):
		var inset := float(index) * 9.0
		var alpha := 0.018 + float(index) * 0.012
		draw_rect(Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0), Color(0.0, 0.0, 0.0, alpha), false, 10.0)
