extends Control

# Masks only baked sample cards that must be replaced by live run state.
# Future reference card-backs remain visible wherever they are already generic.

const CLOTH := Color(0.022, 0.010, 0.014, 0.965)
const CLOTH_EDGE := Color(0.16, 0.045, 0.040, 0.34)
const CARD_MASK_SIZE := Vector2(96.0, 138.0)
const NUMERAL_MASK_SIZE := Vector2(52.0, 24.0)
const SLOT_CENTERS := [
	Vector2(383.0, 51.0),
	Vector2(506.0, 84.0),
	Vector2(613.0, 146.0),
	Vector2(690.0, 244.0),
	Vector2(632.0, 358.0),
	Vector2(520.0, 430.0),
	Vector2(390.0, 470.0),
	Vector2(243.0, 448.0),
	Vector2(142.0, 352.0),
	Vector2(90.0, 250.0),
	Vector2(170.0, 134.0),
	Vector2(278.0, 82.0),
]
const SLOT_ROTATIONS_DEG := [0.0, 7.0, 10.0, 11.0, 9.0, 6.0, 0.0, -7.0, -10.0, -11.0, -9.0, -6.0]


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func refresh() -> void:
	queue_redraw()


func _draw() -> void:
	for index in range(SLOT_CENTERS.size()):
		if not _slot_needs_live_cover(index):
			continue
		_draw_slot_mask(index)


func _slot_needs_live_cover(index: int) -> bool:
	# The approved reference intentionally contains example cards in I–IV,
	# so those four positions always need a live replacement.
	if index < 4:
		return true

	# V–XII are already clean/generic card-backs in the reference. Mask them
	# only once that position becomes the current step or part of run history.
	return index <= RunState.cards_resolved


func _draw_slot_mask(index: int) -> void:
	var center: Vector2 = SLOT_CENTERS[index]
	var rotation := deg_to_rad(float(SLOT_ROTATIONS_DEG[index]))
	draw_set_transform(center, rotation, Vector2.ONE)

	var card_rect := Rect2(-CARD_MASK_SIZE * 0.5, CARD_MASK_SIZE)
	draw_rect(card_rect, CLOTH)
	draw_rect(card_rect.grow(-2.0), CLOTH_EDGE, false, 1.0)

	# Cover only the baked Roman numeral immediately above a replaced card.
	var numeral_rect := Rect2(
		Vector2(-NUMERAL_MASK_SIZE.x * 0.5, -CARD_MASK_SIZE.y * 0.5 - 22.0),
		NUMERAL_MASK_SIZE
	)
	draw_rect(numeral_rect, Color(CLOTH.r, CLOTH.g, CLOTH.b, 0.94))

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
