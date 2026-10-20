extends Control

# D311: Explicitly draw the selected third-variant Wizard plaque into a FIXED 286x153
# local rect. TextureRect's intrinsic imported-image minimum size could
# expand its drawn surface back to the 756x472 source resolution when
# dynamically parented in Godot, covering the entire battle arena.
# DrawCanvasItem has no texture-dependent minimum size.
const DESIGN_SIZE := Vector2(286, 153)

var art_texture: Texture2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2.ZERO
	queue_redraw()


func _draw() -> void:
	if art_texture == null:
		return
	draw_texture_rect(art_texture, Rect2(Vector2.ZERO, DESIGN_SIZE), false)
