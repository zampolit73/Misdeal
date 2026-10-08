extends Control

var resolved_cards := 0
var unsealed := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func configure(resolved: int, is_unsealed: bool) -> void:
	resolved_cards = clampi(resolved, 0, 12)
	unsealed = is_unsealed
	queue_redraw()


func _draw() -> void:
	if unsealed:
		_draw_awakened_mark()
		return

	var fade: float = lerpf(0.86, 0.34, float(resolved_cards) / 12.0)
	var chain_color := Color(0.62, 0.30, 0.16, fade)
	var shadow_color := Color(0.06, 0.015, 0.012, fade * 0.86)

	_draw_chain(Vector2(9.0, 18.0), size - Vector2(9.0, 18.0), shadow_color, 5.0)
	_draw_chain(Vector2(9.0, 18.0), size - Vector2(9.0, 18.0), chain_color, 2.0)

	# The second chain visually breaks away during the final chapter.
	if resolved_cards < 8:
		_draw_chain(Vector2(size.x - 9.0, 18.0), Vector2(9.0, size.y - 18.0), shadow_color, 5.0)
		_draw_chain(Vector2(size.x - 9.0, 18.0), Vector2(9.0, size.y - 18.0), chain_color, 2.0)

	var seal_center := size * 0.5
	var seal_color := Color(0.72, 0.075, 0.035, 0.90 if resolved_cards < 8 else 0.62)
	draw_circle(seal_center, 18.0, Color(0.08, 0.012, 0.012, 0.92))
	draw_circle(seal_center, 15.0, seal_color)
	draw_circle(seal_center, 10.0, Color(0.20, 0.018, 0.014, 0.92), false, 1.5)
	var diamond := PackedVector2Array([
		seal_center + Vector2(0.0, -7.0),
		seal_center + Vector2(6.0, 0.0),
		seal_center + Vector2(0.0, 7.0),
		seal_center + Vector2(-6.0, 0.0),
		seal_center + Vector2(0.0, -7.0),
	])
	draw_polyline(diamond, Color(1.0, 0.48, 0.20, 0.82), 1.2, true)


func _draw_chain(from_point: Vector2, to_point: Vector2, color: Color, width: float) -> void:
	draw_line(from_point, to_point, color, width, true)
	var distance: float = from_point.distance_to(to_point)
	if distance <= 0.0:
		return
	var direction := from_point.direction_to(to_point)
	var normal := Vector2(-direction.y, direction.x)
	var steps: int = maxi(1, int(distance / 16.0))
	for index in range(1, steps):
		var center := from_point.lerp(to_point, float(index) / float(steps))
		var half_long: float = 5.0
		var half_short: float = 3.0
		var link := PackedVector2Array([
			center + direction * half_long,
			center + normal * half_short,
			center - direction * half_long,
			center - normal * half_short,
			center + direction * half_long,
		])
		draw_polyline(link, color, maxf(1.0, width * 0.55), true)


func _draw_awakened_mark() -> void:
	var center := size * 0.5
	var pulse := Color(1.0, 0.20, 0.07, 0.76)
	draw_circle(center, 24.0, Color(pulse.r, pulse.g, pulse.b, 0.12))
	draw_circle(center, 20.0, pulse, false, 1.8)
	draw_circle(center, 12.0, Color(pulse.r, pulse.g, pulse.b, 0.70), false, 1.0)
