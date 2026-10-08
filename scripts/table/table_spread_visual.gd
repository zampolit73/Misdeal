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
	var discarded := RunState.rejected_card_ids.size()
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
	var resolved: int = RunState.cards_resolved
	var center := Vector2(640.0, 430.0)
	var radius := Vector2(330.0, 176.0)

	# A restrained occult ring stays behind the live offer cards. The detailed
	# history lives in the Fate Spread overlay; this layer exists so progress is
	# still readable at a glance while dealing.
	draw_arc(center, 184.0, 0.0, TAU, 64, Color(0.46, 0.11, 0.08, 0.16), 1.0)
	draw_arc(center, 202.0, 0.0, TAU, 64, Color(0.68, 0.18, 0.10, 0.10), 1.0)

	for index in range(RunState.ACT_CARD_TARGET):
		var angle := deg_to_rad(-90.0 + float(index) * 30.0)
		var slot_center := center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y)
		var is_done: bool = index < resolved
		var is_current: bool = index == resolved and not RunState.is_boss_due()

		var fill := Color(0.11, 0.065, 0.075, 0.30)
		var border := Color(0.38, 0.24, 0.24, 0.38)
		var size := Vector2(5.0, 7.0)
		if is_done:
			fill = Color(0.62, 0.30, 0.09, 0.68)
			border = Color(0.88, 0.55, 0.22, 0.72)
			size = Vector2(5.5, 8.0)
		elif is_current:
			fill = Color(0.72, 0.10, 0.055, 0.84)
			border = Color(1.0, 0.38, 0.16, 0.94)
			size = Vector2(6.5, 9.0)

		var diamond := PackedVector2Array([
			slot_center + Vector2(0.0, -size.y),
			slot_center + Vector2(size.x, 0.0),
			slot_center + Vector2(0.0, size.y),
			slot_center + Vector2(-size.x, 0.0),
			slot_center + Vector2(0.0, -size.y)
		])
		draw_colored_polygon(diamond, fill)
		draw_polyline(diamond, border, 1.2)

		# Milestones make the act read as three four-card chapters.
		if index == 3 or index == 7 or index == 11:
			draw_circle(slot_center, 11.0, Color(border.r, border.g, border.b, 0.16), false, 1.0)

	var boss_active: bool = RunState.is_boss_due() or RunState.active_card_id == RunState.BOSS_CARD_ID
	var boss_fill := Color(0.18, 0.035, 0.035, 0.38)
	var boss_border := Color(0.54, 0.12, 0.08, 0.52)
	if boss_active:
		boss_fill = Color(0.64, 0.07, 0.035, 0.78)
		boss_border = Color(1.0, 0.30, 0.11, 0.94)

	draw_circle(center, 22.0, boss_fill)
	draw_circle(center, 22.0, boss_border, false, 2.0)
	draw_circle(center, 14.0, Color(boss_border.r, boss_border.g, boss_border.b, boss_border.a * 0.72), false, 1.0)
	var boss_mark := PackedVector2Array([
		center + Vector2(0.0, -8.0),
		center + Vector2(6.0, 0.0),
		center + Vector2(0.0, 8.0),
		center + Vector2(-6.0, 0.0),
		center + Vector2(0.0, -8.0)
	])
	draw_polyline(boss_mark, boss_border, 1.4)
