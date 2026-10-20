extends Control

# D296: vector-authored relief for genuine live Battle panels.
# This is decoration only: no event capture, text, fake buttons or bitmaps.
# Shape/cuts, grooves and patina are redrawn at native UI resolution.

var kind: String = "steel"
var order_symbol: String = ""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)
	queue_redraw()


func _draw() -> void:
	var w := size.x
	var h := size.y
	if kind == "order" or kind == "order_selected":
		_draw_order(w, h, kind == "order_selected")
		return
	if w < 48.0 or h < 40.0:
		return
	var warm := kind != "steel"
	var cut := 10.0 if warm else 7.0
	var metal := Color(0.61, 0.40, 0.23, 0.82) if warm else Color(0.54, 0.42, 0.33, 0.35)
	var lit := Color(0.93, 0.66, 0.35, 0.59) if warm else Color(0.77, 0.59, 0.42, 0.36)
	var dark := Color(0.015, 0.013, 0.020, 0.96 if warm else 0.30)
	var face := Color(0.092, 0.060, 0.050, 0.90) if kind == "wood" else (Color(0.16, 0.055, 0.053, 0.92) if kind == "wager" else Color(0.037, 0.030, 0.037, 0.48))
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


# Tactic plaques are true Godot Buttons. This transparent child only draws
# edge tooling and the selected copper foot: text, tooltip and signals live
# on their original parent.
func _draw_order(w: float, h: float, selected: bool) -> void:
	if w < 60.0 or h < 28.0:
		return
	var rim := Color(0.82, 0.53, 0.30, 0.91) if selected else Color(0.48, 0.35, 0.26, 0.53)
	var gleam := Color(0.98, 0.78, 0.48, 0.83) if selected else Color(0.68, 0.48, 0.31, 0.37)
	# Raised top bevel, shadow foot and four individually cut metal corners.
	draw_line(Vector2(9, 3), Vector2(w - 9, 3), gleam, 1.2, true)
	draw_line(Vector2(9, h - 4), Vector2(w - 9, h - 4), rim.darkened(0.25), 1.1, true)
	for side in [-1.0, 1.0]:
		var x := 5.0 if side < 0.0 else w - 5.0
		draw_line(Vector2(x, 7), Vector2(x, h - 8), rim, 1.0, true)
		draw_line(Vector2(x, 7), Vector2(x - side * 5.0, 2), gleam, 1.0, true)
		draw_line(Vector2(x, h - 8), Vector2(x - side * 5.0, h - 3), rim, 1.0, true)
	if selected:
		draw_line(Vector2(18, h - 6), Vector2(w - 18, h - 6), Color(0.98, 0.70, 0.38, 0.94), 2.0, true)
	# On ordinary three-order layouts, each engraved token has its own tiny
	# truthful insignia. In dense four/five-order layouts text takes priority.
	if w >= 168.0:
		_draw_order_symbol(Vector2(37, h * 0.50), gleam)



func _draw_order_symbol(at: Vector2, tone: Color) -> void:
	match order_symbol:
		"AssaultOrderButton":
			# Crossed swords.
			draw_line(at + Vector2(-6, -6), at + Vector2(6, 6), tone, 1.6, true)
			draw_line(at + Vector2(6, -6), at + Vector2(-6, 6), tone, 1.6, true)
			draw_line(at + Vector2(-7, 1), at + Vector2(-1, 7), tone, 1.2, true)
			draw_line(at + Vector2(7, 1), at + Vector2(1, 7), tone, 1.2, true)
		"HuntOrderButton":
			# Curved bow and arrow.
			draw_arc(at + Vector2(-4, 0), 7.0, -PI * 0.46, PI * 0.46, 12, tone, 1.4, true)
			draw_line(at + Vector2(-2, -7), at + Vector2(-2, 7), tone, 1.0, true)
			draw_line(at + Vector2(-8, 0), at + Vector2(8, 0), tone, 1.4, true)
			draw_line(at + Vector2(5, -3), at + Vector2(8, 0), tone, 1.3, true)
			draw_line(at + Vector2(5, 3), at + Vector2(8, 0), tone, 1.3, true)
		"FormationOrderButton":
			# Shield.
			var shield := PackedVector2Array([
				at + Vector2(-6, -7), at + Vector2(6, -7),
				at + Vector2(6, 2), at + Vector2(0, 9),
				at + Vector2(-6, 2), at + Vector2(-6, -7)
			])
			draw_polyline(shield, tone, 1.35, true)
			draw_line(at + Vector2(0, -6), at + Vector2(0, 6), tone, 1.0, true)
		"SacrificeOrderButton":
			_draw_diamond(at, 7.0, tone)
			draw_line(at + Vector2(0, -5), at + Vector2(0, 5), tone, 1.15, true)
		"DefianceOrderButton":
			draw_arc(at + Vector2(-3, 0), 5.0, -PI * 0.65, PI * 0.70, 10, tone, 1.4, true)
			draw_arc(at + Vector2(3, 0), 5.0, PI * 0.35, PI * 1.65, 10, tone, 1.4, true)
			draw_line(at + Vector2(-1, -1), at + Vector2(2, -4), tone, 1.3, true)
