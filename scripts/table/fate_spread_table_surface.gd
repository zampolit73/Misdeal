extends Control

# Quiet physical table treatment for the Fate Spread inspection screen.
# Kept procedural/live so the run history remains native UI.

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(18.0, 14.0, size.x - 36.0, size.y - 28.0)
	draw_rect(rect, Color(0.090, 0.022, 0.026, 0.82))

	# Worn inner cloth / leather field.
	var inner := rect.grow(-18.0)
	draw_rect(inner, Color(0.060, 0.016, 0.021, 0.88))
	draw_rect(inner, Color(0.34, 0.085, 0.055, 0.22), false, 1.0)

	# Restrained table grain and scratches; deterministic, not noisy wallpaper.
	for row in range(7):
		var y := 54.0 + float(row) * 66.0
		var offset := 28.0 if row % 2 == 0 else 86.0
		for segment in range(4):
			var x := offset + float(segment) * 176.0
			draw_line(
				Vector2(x, y),
				Vector2(minf(x + 94.0, size.x - 26.0), y - 3.0),
				Color(0.48, 0.14, 0.08, 0.075),
				1.0,
				true
			)

	# Old ritual stains under the live seal.
	var center := Vector2(390.0, 270.0)
	draw_circle(center, 184.0, Color(0.40, 0.025, 0.025, 0.16))
	draw_circle(center, 156.0, Color(0.64, 0.09, 0.055, 0.14), false, 2.0)

	# A few long cuts help the surface feel physical without competing with cards.
	var scratch := Color(0.60, 0.18, 0.10, 0.085)
	draw_line(Vector2(120.0, 116.0), Vector2(242.0, 102.0), scratch, 1.0, true)
	draw_line(Vector2(528.0, 430.0), Vector2(674.0, 446.0), scratch, 1.0, true)
	draw_line(Vector2(95.0, 410.0), Vector2(198.0, 425.0), scratch, 1.0, true)

	# Soft edge vignette.
	for index in range(5):
		var inset := 18.0 + float(index) * 10.0
		draw_rect(
			Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0),
			Color(0.0, 0.0, 0.0, 0.035 + float(index) * 0.012),
			false,
			7.0
		)
