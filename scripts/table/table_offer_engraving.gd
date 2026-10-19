extends Control

# D277: painterly-restrained engraved corners and bronze fittings on the
# live parchment. All geometry stays outside readable title/lore/CTA text.
# Replaces no original encounter artwork and handles no mouse input.

const METAL := Color(0.52, 0.28, 0.14, 0.74)
const GLINT := Color(0.82, 0.56, 0.30, 0.84)
const SHADOW := Color(0.23, 0.12, 0.065, 0.72)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	# Thin perimeter engraving under the art and inside the outer frame.
	draw_line(Vector2(12.0, 164.0), Vector2(12.0, 295.0), METAL, 1.0)
	draw_line(Vector2(260.0, 164.0), Vector2(260.0, 295.0), METAL, 1.0)
	draw_line(Vector2(12.0, 163.0), Vector2(31.0, 163.0), GLINT, 1.0)
	draw_line(Vector2(241.0, 163.0), Vector2(260.0, 163.0), GLINT, 1.0)
	draw_line(Vector2(12.0, 295.0), Vector2(32.0, 295.0), METAL, 1.0)
	draw_line(Vector2(240.0, 295.0), Vector2(260.0, 295.0), METAL, 1.0)
	_corner(Vector2(12.0, 163.0), 1.0, 1.0)
	_corner(Vector2(260.0, 163.0), -1.0, 1.0)
	_corner(Vector2(12.0, 295.0), 1.0, -1.0)
	_corner(Vector2(260.0, 295.0), -1.0, -1.0)
	# Two small hand-worked sigils interrupt the type divider, avoiding text.
	_diamond(Vector2(20.0, 215.0), 2.8)
	_diamond(Vector2(252.0, 215.0), 2.8)
	# A wax-red pin with worn bronze rim at the corners of the action strap.
	_rivet(Vector2(23.0, 317.0))
	_rivet(Vector2(249.0, 317.0))

func _corner(p: Vector2, sx: float, sy: float) -> void:
	var path := PackedVector2Array([
		p + Vector2(0.0, sy * 18.0),
		p + Vector2(sx * 5.0, sy * 12.0),
		p + Vector2(sx * 5.0, sy * 5.0),
		p + Vector2(sx * 12.0, sy * 5.0),
		p + Vector2(sx * 18.0, 0.0)
	])
	draw_polyline(path, METAL, 1.25, true)
	draw_line(p + Vector2(sx * 4.0, sy * 9.0), p + Vector2(sx * 10.0, sy * 4.0), GLINT, 1.0)
	_diamond(p + Vector2(sx * 6.0, sy * 6.0), 2.0)

func _diamond(p: Vector2, radius: float) -> void:
	draw_colored_polygon(PackedVector2Array([
		p + Vector2(0.0, -radius),
		p + Vector2(radius, 0.0),
		p + Vector2(0.0, radius),
		p + Vector2(-radius, 0.0)
	]), METAL)

func _rivet(p: Vector2) -> void:
	draw_circle(p, 3.1, SHADOW)
	draw_circle(p, 2.2, GLINT)
	draw_circle(p + Vector2(-0.5, -0.5), 0.9, Color("#6d2b23"))
