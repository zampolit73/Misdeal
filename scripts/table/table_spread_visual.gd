extends Control

const CARD_BACK_FILL := Color(0.055, 0.020, 0.026, 0.96)
const CARD_BACK_BORDER := Color(0.54, 0.20, 0.13, 0.92)
const CARD_BACK_INNER := Color(0.28, 0.085, 0.075, 0.82)

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func refresh() -> void:
	queue_redraw()

func _draw() -> void:
	_draw_offer_slots()
	_draw_deck()
	_draw_discard()
	_draw_progress_spread()

func _draw_offer_slots() -> void:
	if RunState.has_active_card() or RunState.is_boss_due():
		_draw_slot(Rect2(520.0, 332.0, 240.0, 346.0), 0.0)
		return

	_draw_slot(Rect2(382.0, 332.0, 240.0, 346.0), -0.045)
	_draw_slot(Rect2(658.0, 332.0, 240.0, 346.0), 0.045)

func _draw_slot(rect: Rect2, rotation: float) -> void:
	var center := rect.position + rect.size * 0.5
	draw_set_transform(center, rotation, Vector2.ONE)
	var local_rect := Rect2(-rect.size * 0.5, rect.size)
	draw_rect(local_rect, Color(0.012, 0.006, 0.010, 0.34))
	draw_rect(local_rect.grow(-5.0), Color(0.42, 0.13, 0.10, 0.20), false, 2.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_deck() -> void:
	var remaining := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		remaining = maxi(0, remaining - RunState.current_offer_ids.size())

	var base_rect := Rect2(128.0, 405.0, 106.0, 154.0)
	if remaining <= 0:
		draw_rect(base_rect, Color(0.22, 0.08, 0.07, 0.24), false, 2.0)
		return

	var layers := mini(5, remaining)
	for layer in range(layers):
		var offset := Vector2(float(layer) * -2.5, float(layer) * -3.0)
		_draw_card_back(Rect2(base_rect.position + offset, base_rect.size), -0.018 + float(layer) * 0.006, 0.72 + float(layer) * 0.055)

func _draw_discard() -> void:
	var discarded := RunState.resolved_card_ids.size() + RunState.rejected_card_ids.size()
	var center := Vector2(1092.0, 486.0)

	if discarded <= 0:
		draw_arc(center, 72.0, 0.0, TAU, 32, Color(0.32, 0.10, 0.09, 0.28), 2.0)
		return

	var visible_cards := mini(4, discarded)
	for index in range(visible_cards):
		var angle := deg_to_rad(-10.0 + float(index) * 6.0)
		var offset := Vector2(-18.0 + float(index) * 10.0, float(index) * -2.0)
		_draw_card_back(Rect2(center + offset - Vector2(46.0, 67.0), Vector2(92.0, 134.0)), angle, 0.64 + float(index) * 0.08)

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

	draw_rect(local_rect, Color(0, 0, 0, 0.28 * alpha))
	draw_rect(local_rect.grow(-2.0), fill)
	draw_rect(local_rect.grow(-4.0), border, false, 2.0)
	draw_rect(local_rect.grow(-10.0), inner, false, 2.0)

	var half := Vector2(17.0, 25.0)
	var diamond := PackedVector2Array([
		Vector2(0.0, -half.y),
		Vector2(half.x, 0.0),
		Vector2(0.0, half.y),
		Vector2(-half.x, 0.0),
		Vector2(0.0, -half.y)
	])
	draw_polyline(diamond, border.lightened(0.12), 2.0)
	draw_circle(Vector2.ZERO, 4.0, border.lightened(0.18))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_progress_spread() -> void:
	var resolved := RunState.cards_resolved
	var start := Vector2(397.0, 281.0)
	var card_size := Vector2(23.0, 30.0)
	var gap := 8.0

	draw_line(Vector2(385.0, 317.0), Vector2(895.0, 317.0), Color(0.44, 0.14, 0.11, 0.24), 2.0)

	for index in range(RunState.ACT_CARD_TARGET):
		var x := start.x + float(index) * (card_size.x + gap)
		var rect := Rect2(Vector2(x, start.y), card_size)
		var is_done := index < resolved
		var is_current := index == resolved and not RunState.is_boss_due()

		var fill := Color(0.035, 0.018, 0.024, 0.78)
		var border := Color(0.28, 0.12, 0.12, 0.58)
		if is_done:
			fill = Color(0.29, 0.15, 0.07, 0.92)
			border = Color(0.78, 0.48, 0.20, 0.94)
		elif is_current:
			fill = Color(0.20, 0.045, 0.035, 0.96)
			border = Color(0.94, 0.34, 0.16, 1.0)

		draw_rect(rect, fill)
		draw_rect(rect, border, false, 2.0)

		if is_done:
			draw_line(rect.position + Vector2(6.0, 15.0), rect.position + Vector2(10.0, 20.0), Color(1.0, 0.78, 0.42, 0.95), 2.0)
			draw_line(rect.position + Vector2(10.0, 20.0), rect.position + Vector2(18.0, 9.0), Color(1.0, 0.78, 0.42, 0.95), 2.0)

	var boss_rect := Rect2(Vector2(790.0, 276.0), Vector2(34.0, 40.0))
	var boss_active := RunState.is_boss_due() or RunState.active_card_id == RunState.BOSS_CARD_ID
	var boss_fill := Color(0.08, 0.018, 0.020, 0.88)
	var boss_border := Color(0.55, 0.12, 0.09, 0.82)
	if boss_active:
		boss_fill = Color(0.23, 0.035, 0.025, 0.98)
		boss_border = Color(1.0, 0.32, 0.12, 1.0)

	draw_rect(boss_rect, boss_fill)
	draw_rect(boss_rect, boss_border, false, 2.0)
	var boss_center := boss_rect.position + boss_rect.size * 0.5
	var boss_diamond := PackedVector2Array([
		boss_center + Vector2(0.0, -10.0),
		boss_center + Vector2(8.0, 0.0),
		boss_center + Vector2(0.0, 10.0),
		boss_center + Vector2(-8.0, 0.0),
		boss_center + Vector2(0.0, -10.0)
	])
	draw_polyline(boss_diamond, boss_border.lightened(0.16), 2.0)
