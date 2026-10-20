extends Control

# D296: vector-authored relief for genuine live Battle panels.
# This is decoration only: no event capture, text, fake buttons or bitmaps.
# Shape/cuts, grooves and patina are redrawn at native UI resolution.

var kind: String = "steel"


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	queue_redraw()


func _draw() -> void:
	var w := size.x
	var h := size.y
	if w < 48.0 or h < 40.0:
		return
	var warm := kind != "steel"
	var cut := 10.0 if warm else 7.0
	var metal := Color(0.61, 0.40, 0.23, 0.82) if warm else Color(0.54, 0.42, 0.33, 0.56)
	var lit := Color(0.93, 0.66, 0.35, 0.59) if warm else Color(0.77, 0.59, 0.42, 0.36)
	var dark := Color(0.015, 0.013, 0.020, 0.96)
	var face := Color(0.092, 0.060, 0.050, 0.90) if kind == "wood" else (Color(0.16, 0.055, 0.053, 0.92) if kind == "wager" else Color(0.037, 0.030, 0.037, 0.79))
	# Small clipped corners and stacked metal edges give a physical cross-section.
	draw_colored_polygon(_cut_rect(Rect2(0, 1, w, h - 2), cut), dark)
	draw_colored_polygon(_cut_rect(Rect2(2, 3, w - 4, h - 6), cut - 2), metal.darkened(0.49))
	draw_colored_polygon(_cut_rect(Rect2(3, 4, w - 6, h - 8), cut - 3), face)
	draw_polyline(_closed(_cut_rect(Rect2(1, 1, w - 2, h - 2), cut)), metal, 1.25, true)
	draw_polyline(_closed(_cut_rect(Rect2(5, 6, w - 10, h - 12), maxf(2.0, cut - 4.0))), metal.darkened(0.26), 1.0, true)
	# Upper-facing metal bevel and inset highlights, deliberately asymmetric.
	draw_line(Vector2(22, 4), Vector2(w - 24, 4), lit, 1.4, true)
	draw_line(Vector2(22, h - 6), Vector2(w - 24, h - 6), metal.darkened(0.56), 1.0, true)
	draw_line(Vector2(7, 17), Vector2(7, h - 18), Color(lit.r, lit.g, lit.b, lit.a * 0.47), 1.0, true)
	draw_line(Vector2(w - 8, 17), Vector2(w - 8, h - 18), Color(0.01, 0.01, 0.01, 0.75), 1.0, true)
	# Material engraving / restrained hairline wear. Deterministic per panel.
	for i in range(46 if warm else 29):
		var index := float(i)
		var py := 12.0 + fposmod(index * 19.31, h - 24.0)
		var px := 12.0 + fposmod(index * 47.71, w - 65.0)
		var length := minf(14.0 + fposmod(index * 23.37, 88.0), w - px - 11.0)
		var alpha := 0.033 if warm else 0.023
		var patina := Color(0.78, 0.54, 0.35, alpha) if i % 3 == 0 else Color(0.0, 0.0, 0.0, alpha * 1.8)
		draw_line(Vector2(px, py), Vector2(px + length, py + (1.0 if i % 4 == 0 else 0.0)), patina, 1.0)
	# Structural corner staples, not repeated ornamental clutter.
	for sx in [-1.0, 1.0]:
		for sy in [-1.0, 1.0]:
			var corner := Vector2(12 if sx < 0 else w - 12, 11 if sy < 0 else h - 11)
			draw_line(corner, corner + Vector2(-sx * 5, 0), metal, 1.0, true)
			draw_line(corner, corner + Vector2(0, -sy * 4), metal.darkened(0.15), 1.0, true)
			draw_circle(corner, 1.7, Color(0.75, 0.56, 0.33, 0.73) if warm else Color(0.57, 0.45, 0.36, 0.50))
	if kind == "wood":
		# Center medallion between split title-line details (outside button row).
		_draw_diamond(Vector2(w * 0.5, 7), 4.0, Color(0.90, 0.65, 0.37, 0.88))
	elif kind == "wager":
		# Oxblood wax polish catches the upper lip of the separate Fight holder.
		draw_line(Vector2(26, 10), Vector2(w - 26, 10), Color(0.78, 0.24, 0.17, 0.24), 2.0, true)


func _draw_diamond(center: Vector2, radius: float, ink: Color) -> void:
	var points := PackedVector2Array([
		center + Vector2(0, -radius), center + Vector2(radius, 0),
		center + Vector2(0, radius), center + Vector2(-radius, 0),
		center + Vector2(0, -radius)
	])
	draw_polyline(points, ink, 1.0, true)


func _cut_rect(bounds: Rect2, bevel: float) -> PackedVector2Array:
	var x := bounds.position.x
	var y := bounds.position.y
	var w := bounds.size.x
	var h := bounds.size.y
	return PackedVector2Array([
		Vector2(x + bevel, y), Vector2(x + w - bevel, y),
		Vector2(x + w, y + bevel), Vector2(x + w, y + h - bevel),
		Vector2(x + w - bevel, y + h), Vector2(x + bevel, y + h),
		Vector2(x, y + h - bevel), Vector2(x, y + bevel)
	])


func _closed(points: PackedVector2Array) -> PackedVector2Array:
	var closed := points.duplicate()
	closed.append(points[0])
	return closed
