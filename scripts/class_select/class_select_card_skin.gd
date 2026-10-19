extends RefCounted

# D279: applies already-approved D278 card materials to protagonist choice.
# All portraits, copy and choice buttons remain real interactive Godot nodes.
const FRAME_ASSET := preload("res://scripts/table/table_offer_frame_asset.gd")
const PAPER_SHADER: Shader = preload("res://shaders/table_offer_parchment.gdshader")
const CARD_SIZE := Vector2(272.0, 338.0)

static func prepare(button: Button) -> void:
	button.custom_minimum_size = CARD_SIZE
	button.clip_contents = true
	button.pivot_offset = CARD_SIZE * 0.5
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var paper := ColorRect.new()
	paper.name = "Parchment"
	paper.position = Vector2(4.0, 4.0)
	paper.size = CARD_SIZE - Vector2(8.0, 8.0)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = PAPER_SHADER
	paper.material = material
	button.add_child(paper)
	button.move_child(paper, 0)

	var art_mat := ColorRect.new()
	art_mat.name = "ArtMount"
	art_mat.position = Vector2(8.0, 8.0)
	art_mat.size = Vector2(256.0, 169.0)
	art_mat.color = Color("#37231b")
	art_mat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(art_mat)
	button.move_child(art_mat, 1)

	var portrait := button.get_node("Portrait") as TextureRect
	_rect(portrait, Vector2(12.0, 12.0), Vector2(248.0, 160.0))
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var name := button.get_node("ClassTitle") as Label
	_rect(name, Vector2(17.0, 180.0), Vector2(238.0, 35.0))
	name.add_theme_font_size_override("font_size", 20)
	name.add_theme_color_override("font_color", Color("#3c2016"))
	name.clip_text = true

	var role := button.get_node("Role") as Label
	_rect(role, Vector2(18.0, 220.0), Vector2(236.0, 24.0))
	role.add_theme_font_size_override("font_size", 12)
	role.add_theme_color_override("font_color", Color("#654331"))
	role.clip_text = true

	var divider := ColorRect.new()
	divider.name = "CaptionRule"
	divider.position = Vector2(42.0, 250.0)
	divider.size = Vector2(188.0, 1.0)
	divider.color = Color("#936748")
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(divider)

	var desc := button.get_node("Description") as Label
	_rect(desc, Vector2(23.0, 263.0), Vector2(226.0, 56.0))
	desc.add_theme_font_size_override("font_size", 14)
	desc.add_theme_color_override("font_color", Color("#4b3427"))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	desc.clip_text = true

	var plate := button.get_node("StatsPlate") as ColorRect
	_rect(plate, Vector2(22.0, 265.0), Vector2(228.0, 47.0))
	plate.color = Color(0.31, 0.20, 0.15, 0.10)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.visible = false

	var stats := button.get_node("Stats") as Label
	_rect(stats, Vector2(21.0, 267.0), Vector2(230.0, 42.0))
	stats.add_theme_font_size_override("font_size", 17)
	stats.add_theme_color_override("font_color", Color("#40231a"))
	stats.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stats.clip_text = true
	stats.visible = false

	var frame_art := TextureRect.new()
	frame_art.name = "IllustratedFrame"
	frame_art.position = Vector2.ZERO
	frame_art.size = CARD_SIZE
	frame_art.texture = FRAME_ASSET.get_texture()
	frame_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame_art.stretch_mode = TextureRect.STRETCH_SCALE
	frame_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(frame_art)


static func set_state(button: Button, selected: bool, hovered: bool, dimmed: bool) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.04, 0.04, 0.93)
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = Color("#806044")
	style.shadow_size = 10
	style.shadow_color = Color(0, 0, 0, 0.70)
	if hovered or selected:
		style.border_color = Color("#f1b568")
		style.shadow_size = 17
		style.shadow_color = Color(0.70, 0.30, 0.07, 0.75)
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("pressed", style)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var art := button.get_node_or_null("IllustratedFrame") as TextureRect
	if art != null:
		art.modulate = Color(1, 0.99, 0.96) if (hovered or selected) else Color(0.94, 0.91, 0.86)
	# The choice card remains a single focus/hit target.
	if dimmed:
		button.modulate = Color(0.78, 0.74, 0.71, 0.82)
	else:
		button.modulate = Color.WHITE
	var target_scale := Vector2(1.035, 1.035) if (hovered or selected) else Vector2.ONE
	# Do not stack new tweens on pointer jitter.
	if not button.scale.is_equal_approx(target_scale):
		button.scale = target_scale


static func prepare_confirm(button: Button) -> void:
	button.add_theme_font_size_override("font_size", 21)
	button.add_theme_color_override("font_color", Color("#f7d8a8"))
	button.add_theme_color_override("font_hover_color", Color("#fff0cc"))
	button.add_theme_color_override("font_disabled_color", Color("#a98869"))
	button.focus_mode = Control.FOCUS_ALL
	update_confirm(button)


static func update_confirm(button: Button) -> void:
	var base := StyleBoxFlat.new()
	base.bg_color = Color("#6c201c") if not button.disabled else Color("#301914")
	base.border_width_left = 3
	base.border_width_top = 3
	base.border_width_right = 3
	base.border_width_bottom = 3
	base.border_color = Color("#d2a064") if not button.disabled else Color("#775037")
	base.shadow_color = Color(0.38, 0.10, 0.04, 0.60) if not button.disabled else Color(0, 0, 0, 0.35)
	base.shadow_size = 10
	var hot := base.duplicate() as StyleBoxFlat
	hot.bg_color = Color("#922b24")
	hot.border_color = Color("#f2bf73")
	for name in ["normal", "disabled"]:
		button.add_theme_stylebox_override(name, base)
	for name in ["hover", "pressed", "focus"]:
		button.add_theme_stylebox_override(name, hot)


static func _rect(control: Control, where: Vector2, extent: Vector2) -> void:
	control.position = where
	control.size = extent
