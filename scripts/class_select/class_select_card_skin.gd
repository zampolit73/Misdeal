extends RefCounted

const UI_MOTION := preload("res://scripts/ui/ui_motion.gd")

# D415: dossier artwork/material language on the production protagonist choice.
# All portraits, copy and choice buttons remain real interactive Godot nodes.
const FRAME_PATH := "res://assets/pixel/ui/squad_dossier_d413/panel.webp"
const CARD_SIZE := Vector2(272.0, 338.0)
static var _frame: Texture2D
static var _heading: SystemFont

static func _frame_texture() -> Texture2D:
	if _frame == null:
		var image := Image.new()
		image.load_webp_from_buffer(FileAccess.get_file_as_bytes(FRAME_PATH))
		image.resize(384, 256, Image.INTERPOLATE_LANCZOS)
		_frame = ImageTexture.create_from_image(image)
	return _frame

static func heading_font() -> Font:
	if _heading == null:
		_heading = SystemFont.new()
		_heading.font_names = PackedStringArray(["Georgia", "Liberation Serif", "DejaVu Serif", "Times New Roman"])
	return _heading

static func prepare_screen(scene: Control) -> void:
	var title := scene.get_node("Frame/Title") as Label
	title.add_theme_font_override("font", heading_font())
	title.add_theme_font_size_override("font_size", 26)
	var help := Label.new()
	help.name = "ChoiceKeys"
	help.text = "← →  — выбрать героя     ENTER — принять судьбу"
	help.position = Vector2(340, 148)
	help.size = Vector2(600, 26)
	help.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	help.add_theme_font_size_override("font_size", 13)
	help.add_theme_color_override("font_color", Color("d9bf96"))
	help.add_theme_color_override("font_shadow_color", Color.BLACK)
	help.add_theme_constant_override("shadow_offset_y", 2)
	help.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene.get_node("Frame").add_child(help)


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
	paper.color = Color("141115")
	button.add_child(paper)
	button.move_child(paper, 0)

	var art_mat := ColorRect.new()
	art_mat.name = "ArtMount"
	art_mat.position = Vector2(8.0, 8.0)
	art_mat.size = Vector2(256.0, 189.0)
	art_mat.color = Color("#37231b")
	art_mat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(art_mat)
	button.move_child(art_mat, 1)

	var portrait := button.get_node("Portrait") as TextureRect
	_rect(portrait, Vector2(12.0, 12.0), Vector2(248.0, 180.0))
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var name := button.get_node("ClassTitle") as Label
	_rect(name, Vector2(17.0, 197.0), Vector2(238.0, 30.0))
	name.add_theme_font_size_override("font_size", 22)
	name.add_theme_font_override("font", heading_font())
	name.add_theme_color_override("font_color", Color("#ebcd9f"))
	name.clip_text = true

	var role := button.get_node("Role") as Label
	_rect(role, Vector2(18.0, 230.0), Vector2(236.0, 20.0))
	role.add_theme_font_size_override("font_size", 12)
	role.add_theme_color_override("font_color", Color("#bb9b77"))
	role.clip_text = true

	var divider := ColorRect.new()
	divider.name = "CaptionRule"
	divider.position = Vector2(42.0, 254.0)
	divider.size = Vector2(188.0, 1.0)
	divider.color = Color("#936748")
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(divider)

	var desc := button.get_node("Description") as Label
	_rect(desc, Vector2(23.0, 260.0), Vector2(226.0, 52.0))
	desc.add_theme_font_size_override("font_size", 14)
	desc.add_theme_font_override("font", heading_font())
	desc.add_theme_color_override("font_color", Color("#d6c5b0"))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	desc.clip_text = true

	var plate := button.get_node("StatsPlate") as ColorRect
	_rect(plate, Vector2(22.0, 265.0), Vector2(228.0, 42.0))
	plate.color = Color(0.42, 0.22, 0.12, 0.17)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.visible = false

	var stats := button.get_node("Stats") as Label
	_rect(stats, Vector2(21.0, 265.0), Vector2(230.0, 42.0))
	stats.add_theme_font_size_override("font_size", 17)
	stats.add_theme_color_override("font_color", Color("#f0ce97"))
	stats.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stats.clip_text = true
	stats.visible = false

	var frame_art := NinePatchRect.new()
	frame_art.name = "IllustratedFrame"
	frame_art.position = Vector2.ZERO
	frame_art.size = CARD_SIZE
	frame_art.texture = _frame_texture()
	frame_art.draw_center = false
	frame_art.patch_margin_left = 30
	frame_art.patch_margin_right = 30
	frame_art.patch_margin_top = 24
	frame_art.patch_margin_bottom = 24
	frame_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(frame_art)

	# Gold edge sits ABOVE the painted frame, never over the portrait or copy.
	# Hover gets a discreet line; click-selection keeps a stronger permanent rim.
	var selection_rim := Panel.new()
	selection_rim.name = "SelectionRim"
	selection_rim.position = Vector2(2.0, 2.0)
	selection_rim.size = CARD_SIZE - Vector2(4.0, 4.0)
	selection_rim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	selection_rim.visible = false
	button.add_child(selection_rim)
	var chosen := Label.new()
	chosen.name = "ChosenSeal"
	chosen.text = "ВЫБРАН"
	chosen.position = Vector2(163, 19)
	chosen.size = Vector2(87, 24)
	chosen.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chosen.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	chosen.add_theme_font_size_override("font_size", 12)
	chosen.add_theme_color_override("font_color", Color("ffe0a8"))
	var seal := StyleBoxFlat.new()
	seal.bg_color = Color("541b1c")
	seal.border_color = Color("bf915a")
	seal.set_border_width_all(1)
	chosen.add_theme_stylebox_override("normal", seal)
	chosen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chosen.visible = false
	button.add_child(chosen)


static func set_state(button: Button, selected: bool, hovered: bool, dimmed: bool) -> void:
	(button.get_node("ChosenSeal") as Label).visible = selected
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
	var rim := button.get_node_or_null("SelectionRim") as Panel
	if rim != null:
		rim.visible = selected or hovered
		if rim.visible:
			var gilding := StyleBoxFlat.new()
			gilding.draw_center = false
			var width := 3 if selected else 2
			gilding.border_width_left = width
			gilding.border_width_top = width
			gilding.border_width_right = width
			gilding.border_width_bottom = width
			gilding.border_color = Color(1.0, 0.77, 0.39, 0.98) if selected else Color(0.95, 0.71, 0.40, 0.70)
			gilding.shadow_size = 8 if selected else 3
			gilding.shadow_color = Color(0.85, 0.36, 0.075, 0.60) if selected else Color(0.57, 0.32, 0.12, 0.26)
			rim.add_theme_stylebox_override("panel", gilding)
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("pressed", style)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var art := button.get_node_or_null("IllustratedFrame") as NinePatchRect
	if art != null:
		art.modulate = Color(1, 0.99, 0.96) if (hovered or selected) else Color(0.94, 0.91, 0.86)
	# The choice card remains a single focus/hit target.
	if dimmed:
		button.modulate = Color(0.82, 0.79, 0.77, 0.94)
	else:
		button.modulate = Color.WHITE
	var target_scale := Vector2(1.022, 1.022) if hovered else Vector2(1.012, 1.012) if selected else Vector2.ONE
	if not button.has_meta("d417_card_home_y"):
		button.set_meta("d417_card_home_y", button.position.y)
	var tween := UI_MOTION.replace_tween(button, &"d417_card_hover")
	tween.set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", target_scale, 0.16)
	tween.tween_property(button, "position:y", float(button.get_meta("d417_card_home_y")) - (7.0 if hovered else (3.0 if selected else 0.0)), 0.16)


static func prepare_confirm(button: Button) -> void:
	UI_MOTION.bind_button(button)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_font_override("font", heading_font())
	# A restrained metal inset gives the CTA a physical crimson enamel edge.
	var gleam := ColorRect.new()
	gleam.name = "GildedTopEdge"
	gleam.position = Vector2(10.0, 3.0)
	gleam.size = Vector2(358.0, 1.0)
	gleam.color = Color(0.97, 0.72, 0.39, 0.61)
	gleam.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(gleam)
	var shadow_edge := ColorRect.new()
	shadow_edge.name = "PressedLowerEdge"
	shadow_edge.position = Vector2(11.0, 37.0)
	shadow_edge.size = Vector2(356.0, 1.0)
	shadow_edge.color = Color(0.15, 0.04, 0.035, 0.80)
	shadow_edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(shadow_edge)
	button.add_theme_color_override("font_color", Color("#f7d8a8"))
	button.add_theme_color_override("font_hover_color", Color("#fff0cc"))
	button.add_theme_color_override("font_disabled_color", Color("#a98869"))
	button.focus_mode = Control.FOCUS_ALL
	update_confirm(button)


static func update_confirm(button: Button) -> void:
	var base := StyleBoxFlat.new()
	base.bg_color = Color("#76251d") if not button.disabled else Color("#301914")
	base.border_width_left = 3
	base.border_width_top = 2
	base.border_width_right = 3
	base.border_width_bottom = 4
	base.border_color = Color("#d3a15e") if not button.disabled else Color("#775037")
	base.shadow_color = Color(0.52, 0.14, 0.055, 0.62) if not button.disabled else Color(0, 0, 0, 0.35)
	base.shadow_size = 12
	var gleam := button.get_node_or_null("GildedTopEdge") as ColorRect
	if gleam != null:
		gleam.visible = not button.disabled
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
