extends Control

const HAND_COLOR := Color(0.42, 0.37, 0.40, 0.98)
const HAND_SHADOW := Color(0.010, 0.006, 0.012, 0.52)
const HAND_LIGHT := Color(0.68, 0.49, 0.39, 0.38)
const SLEEVE_COLOR := Color(0.055, 0.018, 0.031, 0.98)
const SLEEVE_EDGE := Color(0.42, 0.16, 0.12, 0.86)
const CUFF_COLOR := Color(0.31, 0.18, 0.12, 0.98)
const CUFF_LIGHT := Color(0.72, 0.43, 0.20, 0.72)

var deal_time := 0.0
var meddle_time := 0.0
var meddle_offer_index := -1

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(false)
	queue_redraw()

func play_deal() -> void:
	deal_time = 0.46
	set_process(true)
	queue_redraw()

func play_meddle(offer_index: int) -> void:
	meddle_offer_index = offer_index
	meddle_time = 0.62
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	deal_time = maxf(0.0, deal_time - delta)
	meddle_time = maxf(0.0, meddle_time - delta)
	queue_redraw()

	if deal_time <= 0.0 and meddle_time <= 0.0:
		set_process(false)

func _draw() -> void:
	var deal_amount := _pulse(deal_time, 0.46)
	var meddle_amount := _pulse(meddle_time, 0.62)

	var left_reach := deal_amount * 16.0
	var right_reach := 0.0
	if meddle_offer_index == 0:
		left_reach += meddle_amount * 36.0
	elif meddle_offer_index == 1:
		right_reach += meddle_amount * 36.0

	_draw_left_hand(Vector2(left_reach, deal_amount * 7.0), meddle_amount if meddle_offer_index == 0 else 0.0)
	_draw_right_hand(Vector2(-right_reach, meddle_amount * 6.0), meddle_amount if meddle_offer_index == 1 else 0.0)

func _pulse(time_left: float, duration: float) -> float:
	if time_left <= 0.0:
		return 0.0
	var progress := 1.0 - time_left / duration
	return sin(progress * PI)

func _draw_left_hand(offset: Vector2, danger: float) -> void:
	var wrist := Vector2(332.0, 291.0) + offset
	var palm := Vector2(300.0, 329.0) + offset
	var shadow_offset := Vector2(7.0, 9.0)

	var sleeve := PackedVector2Array([
		Vector2(250.0, 244.0) + offset,
		Vector2(360.0, 244.0) + offset,
		wrist + Vector2(17.0, 14.0),
		wrist + Vector2(-18.0, 17.0)
	])
	_draw_shadow_polygon(sleeve, shadow_offset)
	draw_colored_polygon(sleeve, SLEEVE_COLOR)
	draw_polyline(PackedVector2Array([sleeve[1], sleeve[2], sleeve[3], sleeve[0]]), SLEEVE_EDGE, 3.0)

	_draw_cuff(wrist, false, offset)

	var palm_shape := PackedVector2Array([
		palm + Vector2(-24.0, -13.0),
		palm + Vector2(13.0, -17.0),
		palm + Vector2(25.0, 1.0),
		palm + Vector2(11.0, 25.0),
		palm + Vector2(-21.0, 21.0),
		palm + Vector2(-30.0, 4.0)
	])
	_draw_shadow_polygon(palm_shape, shadow_offset)
	draw_colored_polygon(palm_shape, HAND_COLOR)
	draw_polyline(PackedVector2Array([palm_shape[0], palm_shape[1], palm_shape[2], palm_shape[3], palm_shape[4]]), HAND_LIGHT, 2.0)

	var knuckles := [
		palm + Vector2(-13.0, 9.0),
		palm + Vector2(-5.0, 15.0),
		palm + Vector2(4.0, 16.0),
		palm + Vector2(13.0, 11.0)
	]
	var tips := [
		palm + Vector2(-50.0, 42.0),
		palm + Vector2(-35.0, 51.0),
		palm + Vector2(-18.0, 53.0),
		palm + Vector2(-2.0, 47.0)
	]
	for index in range(4):
		_draw_finger(knuckles[index], tips[index], shadow_offset)

	_draw_finger(palm + Vector2(15.0, 0.0), palm + Vector2(41.0, 25.0), shadow_offset)

	if danger > 0.0:
		_draw_meddle_glow(palm + Vector2(-10.0, 18.0), danger)

func _draw_right_hand(offset: Vector2, danger: float) -> void:
	var wrist := Vector2(948.0, 291.0) + offset
	var palm := Vector2(980.0, 329.0) + offset
	var shadow_offset := Vector2(7.0, 9.0)

	var sleeve := PackedVector2Array([
		Vector2(920.0, 244.0) + offset,
		Vector2(1030.0, 244.0) + offset,
		wrist + Vector2(18.0, 17.0),
		wrist + Vector2(-17.0, 14.0)
	])
	_draw_shadow_polygon(sleeve, shadow_offset)
	draw_colored_polygon(sleeve, SLEEVE_COLOR)
	draw_polyline(PackedVector2Array([sleeve[0], sleeve[3], sleeve[2], sleeve[1]]), SLEEVE_EDGE, 3.0)

	_draw_cuff(wrist, true, offset)

	var palm_shape := PackedVector2Array([
		palm + Vector2(24.0, -13.0),
		palm + Vector2(-13.0, -17.0),
		palm + Vector2(-25.0, 1.0),
		palm + Vector2(-11.0, 25.0),
		palm + Vector2(21.0, 21.0),
		palm + Vector2(30.0, 4.0)
	])
	_draw_shadow_polygon(palm_shape, shadow_offset)
	draw_colored_polygon(palm_shape, HAND_COLOR)
	draw_polyline(PackedVector2Array([palm_shape[0], palm_shape[1], palm_shape[2], palm_shape[3], palm_shape[4]]), HAND_LIGHT, 2.0)

	var knuckles := [
		palm + Vector2(13.0, 9.0),
		palm + Vector2(5.0, 15.0),
		palm + Vector2(-4.0, 16.0),
		palm + Vector2(-13.0, 11.0)
	]
	var tips := [
		palm + Vector2(50.0, 42.0),
		palm + Vector2(35.0, 51.0),
		palm + Vector2(18.0, 53.0),
		palm + Vector2(2.0, 47.0)
	]
	for index in range(4):
		_draw_finger(knuckles[index], tips[index], shadow_offset)

	_draw_finger(palm + Vector2(-15.0, 0.0), palm + Vector2(-41.0, 25.0), shadow_offset)

	if danger > 0.0:
		_draw_meddle_glow(palm + Vector2(10.0, 18.0), danger)

func _draw_cuff(wrist: Vector2, mirrored: bool, offset: Vector2) -> void:
	var sign := -1.0 if mirrored else 1.0
	var cuff := PackedVector2Array([
		wrist + Vector2(-19.0, -9.0),
		wrist + Vector2(19.0, -9.0),
		wrist + Vector2(17.0 + sign * 2.0, 11.0),
		wrist + Vector2(-17.0 + sign * 2.0, 11.0)
	])
	draw_colored_polygon(cuff, CUFF_COLOR)
	draw_line(cuff[0], cuff[1], CUFF_LIGHT, 3.0)
	draw_line(cuff[2], cuff[3], Color(0.12, 0.06, 0.06, 0.82), 2.0)

func _draw_finger(start: Vector2, tip: Vector2, shadow_offset: Vector2) -> void:
	draw_line(start + shadow_offset, tip + shadow_offset, HAND_SHADOW, 12.0)
	draw_circle(tip + shadow_offset, 5.8, HAND_SHADOW)
	draw_line(start, tip, HAND_COLOR, 10.0)
	draw_circle(tip, 4.8, HAND_COLOR)
	draw_line(start + Vector2(1.0, -1.0), tip + Vector2(1.0, -1.0), HAND_LIGHT, 2.0)

func _draw_shadow_polygon(points: PackedVector2Array, offset: Vector2) -> void:
	var shadow := PackedVector2Array()
	for point in points:
		shadow.append(point + offset)
	draw_colored_polygon(shadow, HAND_SHADOW)

func _draw_meddle_glow(center: Vector2, amount: float) -> void:
	for index in range(4, 0, -1):
		var ratio := float(index) / 4.0
		var color := Color(0.92, 0.16, 0.07, 0.11 * amount * (1.0 - ratio * 0.42))
		draw_circle(center, 52.0 * ratio, color)
	draw_arc(center, 22.0 + amount * 8.0, 0.0, TAU, 24, Color(1.0, 0.34, 0.12, 0.62 * amount), 2.0)
