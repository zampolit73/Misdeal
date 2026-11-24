extends RefCounted

const LAYOUT := preload("res://assets/pixel/ui/table_navigation_v5/layout_1280x720.json")
const ASSETS := "res://assets/pixel/ui/table_navigation_v5/"
const SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const INK := Color("#dfc6a4")
const BOOK_FINISH := preload("res://shaders/table_book_finish.gdshader")


static func apply(button: Button, object: String) -> void:
	var spec: Dictionary = LAYOUT.data.objects[object]
	var bounds := _rect(spec.rect)
	button.text = ""
	button.accessibility_name = spec.label
	button.custom_minimum_size = Vector2.ZERO
	button.position = bounds.position
	button.size = bounds.size
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	for state in ["normal", "hover", "pressed", "focus", "hover_pressed", "disabled"]:
		button.add_theme_stylebox_override(state, StyleBoxEmpty.new())
	var texture_rect := Rect2(Vector2.ZERO, bounds.size)
	if object != "memory":
		var shadow := picture(button, spec.texture, Rect2(Vector2(2, 4), bounds.size))
		var shadow_material := ShaderMaterial.new()
		shadow_material.shader = BOOK_FINISH
		shadow_material.set_shader_parameter("contact_shadow", true)
		shadow.material = shadow_material
	var prop := picture(button, spec.texture, texture_rect)
	if object == "memory":
		picture(button, spec.light_texture, texture_rect).name = "GlassLight"
	else:
		var finish := ShaderMaterial.new()
		finish.shader = BOOK_FINISH
		prop.material = finish
	var highlight := picture(button, spec.focus_texture, texture_rect)
	highlight.modulate = Color(0.81, 0.74, 0.65, 0.55)
	highlight.hide()
	var caption := Label.new()
	caption.name = "Caption"
	caption.text = spec.label
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.clip_text = true
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.add_theme_font_override("font", SKIN.heading_font())
	caption.add_theme_font_size_override("font_size", int(spec.font_size))
	caption.add_theme_color_override("font_color", INK)
	var area := _rect(spec.label_rect_local)
	caption.position = area.position
	caption.size = area.size
	button.add_child(caption)
	var refresh := func() -> void: highlight.visible = not button.disabled and (button.is_hovered() or button.has_focus())
	button.mouse_entered.connect(refresh)
	button.mouse_exited.connect(refresh)
	button.focus_entered.connect(refresh)
	button.focus_exited.connect(refresh)


static func picture(parent: Control, asset: String, area: Rect2) -> TextureRect:
	var part := TextureRect.new()
	part.texture = load(ASSETS + asset) as Texture2D
	part.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	part.mouse_filter = Control.MOUSE_FILTER_IGNORE
	part.position = area.position
	part.size = area.size
	parent.add_child(part)
	return part


static func _rect(values: Array) -> Rect2:
	return Rect2(values[0], values[1], values[2], values[3])
