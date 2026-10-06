extends Control

const CARD_BACK_FILL := Color(0.052, 0.020, 0.026, 0.94)
const CARD_BACK_BORDER := Color(0.48, 0.18, 0.12, 0.72)
const CARD_BACK_INNER := Color(0.25, 0.075, 0.065, 0.56)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func refresh() -> void:
	queue_redraw()

func _draw() -> void:
	_draw_deck()
	_draw_discard()
	_draw_progress_spread()

func _draw_deck() -> void:
	var remaining := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		remaining = maxi(0, remaining - RunState.current_offer_ids.size())

	var base_rect := Rect2(166.0, 430.0, 76.0, 110.0)
	if remaining <= 0:
		_draw_empty_card_place(base_rect)
		return

	var layers := mini(4, remaining)
	for layer in range(layers):
		var offset := Vector2(float(layer) * -2.0, float(layer) * -2.5)
		_draw_card_back(
			Rect2(base_rect.position + offset, base_rect.size),
			deg_to_rad(-2.0 + float(layer) * 0.8),
			0.72 + float(layer) * 0.07
		)

func _draw_discard() -> void:
	var discarded := RunState.resolved_card_ids.size() + RunState.rejected_card_ids.size()
	var base_rect := Rect2(1038.0, 430.0, 76.0, 110.0)

	if discarded <= 0:
		_draw_empty_card_place(base_rect)
		return

	var visible_cards := mini(4, discarded)
	for index in range(visible_cards):
		var offset := Vector2(float(index) * 3.5, float(index) * -2.0)
		_draw_card_back(
			Rect2(base_rect.position + offset, base_rect.size),
			deg_to_rad(-5.0 + float(index) * 3.0),
			0.58 + float(index) * 0.10
		)

func _draw_empty_card_place(rect: Rect2) -> void:
	draw_rect(rect, Color(0.30, 0.11, 0.09, 0.12), false, 1.0)
	draw_rect(rect.grow(-6.0), Color(0.30, 0.11, 0.09, 0.07), false, 1.0)

func _draw_card_back(rect: Rect2, rotation: float, alpha: float) -> void:
	var center := rect.position + rect.size * 0.5
	draw_set_transform(center, rotation, Vector2.ONE)
	var local_rect := Rect2(-rect.size * 0.5, rect.size)

	var fill := CARD_BACK_FILL
	fill.a *= alpha
	var border := CARD_BACK_BORDER
	border.a *= alpha
	var inner := CARD_BACK_INNER
	inner.a *= alpha

	draw_rect(Rect2(local_rect.position + Vector2(3.0, 4.0), local_rect.size), Color(0, 0, 0, 0.22 * alpha))
	draw_rect(local_rect, fill)
	draw_rect(local_rect.grow(-3.0), border, false, 1.5)
	draw_rect(local_rect.grow(-9.0), inner, false, 1.0)

	var half := Vector2(11.0, 16.0)
	var diamond := PackedVector2Array([
		Vector2(0.0, -half.y),
		Vector2(half.x, 0.0),
		Vector2(0.0, half.y),
		Vector2(-half.x, 0.0),
		Vector2(0.0, -half.y)
	])
	draw_polyline(diamond, border.lightened(0.10), 1.5)
	draw_circle(Vector2.ZERO, 2.5, border.lightened(0.12))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_progress_spread() -> void:
	var resolved := RunState.cards_resolved
	var start_x := 500.0
	var y := 262.0
	var spacing := 22.0

	for index in range(RunState.ACT_CARD_TARGET):
		var center := Vector2(start_x + float(index) * spacing, y)
		var is_done := index < resolved
		var is_current := index == resolved and not RunState.is_boss_due()

		var fill := Color(0.18, 0.07, 0.07, 0.20)
		var border := Color(0.42, 0.16, 0.12, 0.22)
		if is_done:
			fill = Color(0.50, 0.27, 0.10, 0.54)
			border = Color(0.74, 0.45, 0.20, 0.58)
		elif is_current:
			fill = Color(0.54, 0.11, 0.07, 0.58)
			border = Color(0.88, 0.32, 0.15, 0.66)

		var diamond := PackedVector2Array([
			center + Vector2(0.0, -5.0),
			center + Vector2(4.0, 0.0),
			center + Vector2(0.0, 5.0),
			center + Vector2(-4.0, 0.0),
			center + Vector2(0.0, -5.0)
		])
		draw_colored_polygon(diamond, fill)
		draw_polyline(diamond, border, 1.0)

	var boss_center := Vector2(start_x + float(RunState.ACT_CARD_TARGET) * spacing + 11.0, y)
	var boss_active := RunState.is_boss_due() or RunState.active_card_id == RunState.BOSS_CARD_ID
	var boss_color := Color(0.50, 0.11, 0.07, 0.24)
	if boss_active:
		boss_color = Color(0.94, 0.28, 0.11, 0.72)

	draw_arc(boss_center, 7.0, 0.0, TAU, 16, boss_color, 1.5)
	var boss_mark := PackedVector2Array([
		boss_center + Vector2(0.0, -4.0),
		boss_center + Vector2(3.0, 0.0),
		boss_center + Vector2(0.0, 4.0),
		boss_center + Vector2(-3.0, 0.0),
		boss_center + Vector2(0.0, -4.0)
	])
	draw_polyline(boss_mark, boss_color, 1.0)
