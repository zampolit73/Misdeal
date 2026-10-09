extends Control

const TABLE_CENTER := Vector2(640.0, 565.0)
const TABLE_RADIUS := Vector2(760.0, 218.0)
const CLOTH_RADIUS := Vector2(620.0, 188.0)
const SIGIL_CENTER := Vector2(640.0, 520.0)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.010, 0.007, 0.012, 1.0))
	_draw_oval_table()
	_draw_ritual_cloth()
	_draw_ritual_sigil()
	_draw_side_holders()
	_draw_front_drapery()
	_draw_vignette()

func _draw_oval_table() -> void:
	# The table is intentionally wider than the viewport. Only the curved front
	# and side edges are visible, matching the approved Variant C composition.
	var shadow := _ellipse_points(TABLE_CENTER + Vector2(0.0, 18.0), TABLE_RADIUS + Vector2(20.0, 14.0), 96)
	draw_colored_polygon(shadow, Color(0.0, 0.0, 0.0, 0.72))

	var outer := _ellipse_points(TABLE_CENTER, TABLE_RADIUS, 96)
	draw_colored_polygon(outer, Color(0.095, 0.034, 0.027, 1.0))
	draw_polyline(_closed(outer), Color(0.47, 0.18, 0.10, 0.68), 4.0, true)

	var inner_rim := _ellipse_points(TABLE_CENTER - Vector2(0.0, 4.0), TABLE_RADIUS - Vector2(28.0, 24.0), 96)
	draw_colored_polygon(inner_rim, Color(0.050, 0.022, 0.024, 1.0))
	draw_polyline(_closed(inner_rim), Color(0.31, 0.10, 0.075, 0.78), 2.0, true)

	# A restrained front highlight makes the tabletop read as a physical oval,
	# not a rectangular UI panel.
	var front_arc := _ellipse_arc(TABLE_CENTER, TABLE_RADIUS - Vector2(10.0, 10.0), deg_to_rad(18.0), deg_to_rad(162.0), 48)
	draw_polyline(front_arc, Color(0.64, 0.24, 0.12, 0.30), 2.0, true)

func _draw_ritual_cloth() -> void:
	var cloth := _ellipse_points(TABLE_CENTER - Vector2(0.0, 12.0), CLOTH_RADIUS, 96)
	draw_colored_polygon(cloth, Color(0.075, 0.014, 0.020, 0.92))
	draw_polyline(_closed(cloth), Color(0.48, 0.08, 0.07, 0.48), 2.0, true)

	var inner := _ellipse_points(TABLE_CENTER - Vector2(0.0, 14.0), CLOTH_RADIUS - Vector2(28.0, 24.0), 96)
	draw_polyline(_closed(inner), Color(0.72, 0.10, 0.08, 0.18), 1.0, true)

	# Broad woven bands instead of tiny random scratches: less "AI noise",
	# more deliberate table construction.
	for band in range(5):
		var radius := CLOTH_RADIUS - Vector2(70.0 + band * 62.0, 44.0 + band * 28.0)
		if radius.x <= 0.0 or radius.y <= 0.0:
			continue
		draw_polyline(
			_closed(_ellipse_points(TABLE_CENTER - Vector2(0.0, 12.0), radius, 80)),
			Color(0.44, 0.06, 0.055, 0.075),
			1.0,
			true
		)

func _draw_ritual_sigil() -> void:
	# One strong central motif replaces the old rectangular runner and small
	# progress diamonds. The Fate Spread remains the detailed progress view.
	var ring_a := _ellipse_points(SIGIL_CENTER, Vector2(370.0, 162.0), 72)
	var ring_b := _ellipse_points(SIGIL_CENTER, Vector2(294.0, 126.0), 72)
	var ring_c := _ellipse_points(SIGIL_CENTER, Vector2(205.0, 87.0), 72)
	draw_polyline(_closed(ring_a), Color(0.82, 0.10, 0.08, 0.34), 2.0, true)
	draw_polyline(_closed(ring_b), Color(0.78, 0.09, 0.07, 0.24), 1.5, true)
	draw_polyline(_closed(ring_c), Color(0.64, 0.08, 0.06, 0.18), 1.0, true)

	for index in range(12):
		var angle := deg_to_rad(-90.0 + float(index) * 30.0)
		var dir := Vector2(cos(angle), sin(angle))
		var a := SIGIL_CENTER + Vector2(dir.x * 112.0, dir.y * 48.0)
		var b := SIGIL_CENTER + Vector2(dir.x * 337.0, dir.y * 147.0)
		var alpha := 0.15 if index % 3 else 0.28
		draw_line(a, b, Color(0.75, 0.09, 0.07, alpha), 1.0, true)

	var diamond := PackedVector2Array([
		SIGIL_CENTER + Vector2(0.0, -92.0),
		SIGIL_CENTER + Vector2(95.0, 0.0),
		SIGIL_CENTER + Vector2(0.0, 92.0),
		SIGIL_CENTER + Vector2(-95.0, 0.0),
		SIGIL_CENTER + Vector2(0.0, -92.0),
	])
	draw_polyline(diamond, Color(0.90, 0.14, 0.08, 0.22), 1.3, true)

	# Two large crescent-like marks echo the approved concept without filling the
	# cloth with dozens of ornamental symbols.
	draw_arc(SIGIL_CENTER + Vector2(-315.0, 36.0), 31.0, deg_to_rad(58.0), deg_to_rad(302.0), 30, Color(0.72, 0.36, 0.16, 0.34), 5.0, true)
	draw_arc(SIGIL_CENTER + Vector2(315.0, 36.0), 31.0, deg_to_rad(-122.0), deg_to_rad(122.0), 30, Color(0.72, 0.36, 0.16, 0.34), 5.0, true)

func _draw_side_holders() -> void:
	_draw_holder(Rect2(72.0, 392.0, 214.0, 196.0), false)
	_draw_holder(Rect2(994.0, 392.0, 214.0, 196.0), true)

func _draw_holder(rect: Rect2, mirrored: bool) -> void:
	draw_rect(Rect2(rect.position + Vector2(7.0, 9.0), rect.size), Color(0.0, 0.0, 0.0, 0.48))
	draw_rect(rect, Color(0.040, 0.020, 0.020, 0.90))
	draw_rect(rect, Color(0.48, 0.27, 0.12, 0.80), false, 2.0)
	draw_rect(rect.grow(-6.0), Color(0.24, 0.11, 0.07, 0.82), false, 1.0)

	var plate := Rect2(rect.position + Vector2(22.0, 13.0), Vector2(rect.size.x - 44.0, 28.0))
	draw_rect(plate, Color(0.10, 0.045, 0.030, 0.94))
	draw_rect(plate, Color(0.62, 0.34, 0.14, 0.72), false, 1.5)

	var notch_x := rect.end.x - 18.0 if mirrored else rect.position.x + 18.0
	draw_circle(Vector2(notch_x, rect.position.y + rect.size.y * 0.5), 6.0, Color(0.58, 0.27, 0.10, 0.70), false, 1.5)

func _draw_front_drapery() -> void:
	# Sparse cloth masses at the lower corners make the edge feel staged and
	# theatrical while keeping the center readable.
	var left := PackedVector2Array([
		Vector2(0.0, 612.0), Vector2(178.0, 626.0), Vector2(294.0, 720.0), Vector2(0.0, 720.0)
	])
	var right := PackedVector2Array([
		Vector2(1280.0, 612.0), Vector2(1102.0, 626.0), Vector2(986.0, 720.0), Vector2(1280.0, 720.0)
	])
	draw_colored_polygon(left, Color(0.16, 0.020, 0.028, 0.74))
	draw_colored_polygon(right, Color(0.16, 0.020, 0.028, 0.74))
	draw_polyline(left, Color(0.38, 0.06, 0.06, 0.25), 1.0)
	draw_polyline(right, Color(0.38, 0.06, 0.06, 0.25), 1.0)

func _draw_vignette() -> void:
	for index in range(5):
		var inset := float(index) * 10.0
		var alpha := 0.016 + float(index) * 0.010
		draw_rect(
			Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0),
			Color(0.0, 0.0, 0.0, alpha),
			false,
			8.0
		)

func _ellipse_points(center: Vector2, radius: Vector2, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(segments):
		var angle := TAU * float(index) / float(segments)
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	return points

func _ellipse_arc(center: Vector2, radius: Vector2, start_angle: float, end_angle: float, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(segments + 1):
		var t := float(index) / float(segments)
		var angle := lerpf(start_angle, end_angle, t)
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	return points

func _closed(points: PackedVector2Array) -> PackedVector2Array:
	var closed := points.duplicate()
	if not points.is_empty():
		closed.append(points[0])
	return closed
