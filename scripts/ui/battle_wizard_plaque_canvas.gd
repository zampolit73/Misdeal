extends Control

# D309: Explicitly draw the painted Wizard plaque into a FIXED 252x158
# local rect. TextureRect's intrinsic imported-image minimum size could
# expand its drawn surface back to the 756x472 source resolution when
# dynamically parented in Godot, covering the entire battle arena.
# DrawCanvasItem has no texture-dependent minimum size.
const DESIGN_SIZE := Vector2(252, 158)

var art_texture: Texture2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2.ZERO
	queue_redraw()


func _draw() -> void:
	if art_texture == null:
		return
	draw_texture_rect(art_texture, Rect2(Vector2.ZERO, DESIGN_SIZE), false)
