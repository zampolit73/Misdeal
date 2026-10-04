extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var panel := Color(0.028, 0.023, 0.032, 0.98)
	var panel_inner := Color(0.055, 0.043, 0.055, 0.96)
	var border := Color(0.30, 0.22, 0.24, 1.0)
	var border_light := Color(0.48, 0.30, 0.27, 0.88)
	var corner := Color(0.56, 0.31, 0.23, 0.70)

	_draw_panel(Rect2(20.0, 14.0, 820.0, 96.0), panel, panel_inner, border, border_light)
	_draw_panel(Rect2(1015.0, 22.0, 230.0, 62.0), panel, panel_inner, border, border_light)
	_draw_panel(Rect2(20.0, 605.0, 1225.0, 100.0), panel, panel_inner, border, border_light)

	_draw_corner_marks(Rect2(20.0, 14.0, 820.0, 96.0), corner)
	_draw_corner_marks(Rect2(1015.0, 22.0, 230.0, 62.0), corner)
	_draw_corner_marks(Rect2(20.0, 605.0, 1225.0, 100.0), corner)

	draw_line(Vector2(375.0, 621.0), Vector2(375.0, 690.0), Color(0.20, 0.15, 0.18, 0.8), 2.0)
	draw_line(Vector2(875.0, 621.0), Vector2(875.0, 690.0), Color(0.20, 0.15, 0.18, 0.8), 2.0)

func _draw_panel(rect: Rect2, panel: Color, inner: Color, border: Color, border_light: Color) -> void:
	draw_rect(rect, panel)
	draw_rect(rect, border, false, 3.0)
	var inner_rect := rect.grow(-5.0)
	draw_rect(inner_rect, inner)
	draw_rect(inner_rect, border_light, false, 1.0)

func _draw_corner_marks(rect: Rect2, color: Color) -> void:
	var len := 12.0
	for corner in [
		rect.position + Vector2(6.0, 6.0),
		Vector2(rect.end.x - 6.0, rect.position.y + 6.0),
		Vector2(rect.position.x + 6.0, rect.end.y - 6.0),
		rect.end - Vector2(6.0, 6.0)
	]:
		draw_rect(Rect2(corner - Vector2(2.0, 2.0), Vector2(4.0, 4.0)), color)

	draw_line(rect.position + Vector2(8, 8), rect.position + Vector2(8 + len, 8), color, 2.0)
	draw_line(rect.position + Vector2(8, 8), rect.position + Vector2(8, 8 + len), color, 2.0)
	draw_line(Vector2(rect.end.x - 8, rect.position.y + 8), Vector2(rect.end.x - 8 - len, rect.position.y + 8), color, 2.0)
	draw_line(Vector2(rect.end.x - 8, rect.position.y + 8), Vector2(rect.end.x - 8, rect.position.y + 8 + len), color, 2.0)
	draw_line(Vector2(rect.position.x + 8, rect.end.y - 8), Vector2(rect.position.x + 8 + len, rect.end.y - 8), color, 2.0)
	draw_line(Vector2(rect.position.x + 8, rect.end.y - 8), Vector2(rect.position.x + 8, rect.end.y - 8 - len), color, 2.0)
	draw_line(rect.end - Vector2(8, 8), rect.end - Vector2(8 + len, 8), color, 2.0)
	draw_line(rect.end - Vector2(8, 8), rect.end - Vector2(8, 8 + len), color, 2.0)
