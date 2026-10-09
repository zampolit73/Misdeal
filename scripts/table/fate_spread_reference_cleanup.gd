extends Control

# Masks only the run-specific examples baked into the approved concept plate.
# The physical table, ritual circle and edge props stay visible underneath.

const CLOTH := Color(0.022, 0.010, 0.014, 0.975)
const CLOTH_EDGE := Color(0.16, 0.045, 0.040, 0.42)
const SLOT_MASK_SIZE := Vector2(104.0, 148.0)
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


func _draw() -> void:
	for index in range(SLOT_CENTERS.size()):
		_draw_rotated_mask(
			SLOT_CENTERS[index],
			SLOT_MASK_SIZE,
			deg_to_rad(float(SLOT_ROTATIONS_DEG[index]))
		)

	# The reference contains its own XIII label/card. Keep the red ritual glow,
	# but suppress the baked card/title immediately behind the live boss panel.
	draw_rect(Rect2(312.0, 146.0, 156.0, 224.0), Color(0.026, 0.010, 0.014, 0.93))
	draw_rect(Rect2(338.0, 132.0, 104.0, 24.0), Color(0.026, 0.010, 0.014, 0.90))


func _draw_rotated_mask(center: Vector2, mask_size: Vector2, rotation: float) -> void:
	draw_set_transform(center, rotation, Vector2.ONE)
	var rect := Rect2(-mask_size * 0.5, mask_size)
	draw_rect(rect, CLOTH)
	draw_rect(rect.grow(-2.0), CLOTH_EDGE, false, 1.0)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
