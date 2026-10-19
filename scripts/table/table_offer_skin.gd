extends RefCounted

# D274 approved two-card parchment face. Only the live Table offer Buttons use it.
const PAPER_SHADER: Shader = preload("res://shaders/table_offer_parchment.gdshader")
const CARD_SIZE := Vector2(272.0, 338.0)
const BRONZE := Color("#a66b3d")

static func prepare(button: Button) -> void:
	button.custom_minimum_size = CARD_SIZE
	button.size = CARD_SIZE
	button.clip_contents = true
	if button.has_node("ParchmentFace"):
		return
	var paper := ColorRect.new()
	paper.name = "ParchmentFace"
	paper.position = Vector2(4.0, 4.0)
	paper.size = CARD_SIZE - Vector2(8.0, 8.0)
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var paper_material := ShaderMaterial.new()
	paper_material.shader = PAPER_SHADER
	paper.material = paper_material
	button.add_child(paper)
	button.move_child(paper, 0)
	var mount := _strip(button, "IllustrationMount", Vector2(8.0, 8.0), Vector2(256.0, 152.0), Color("#3d281a"))
	button.move_child(mount, 1)
	var action := _strip(button, "ChooseFace", Vector2(18.0, 302.0), Vector2(236.0, 29.0), Color("#66231d"))
	button.move_child(action, 2)
	var top_edge := _strip(button, "ChooseEdgeTop", Vector2(18.0, 302.0), Vector2(236.0, 2.0), BRONZE)
	button.move_child(top_edge, 3)
	var bottom_edge := _strip(button, "ChooseEdgeBottom", Vector2(18.0, 329.0), Vector2(236.0, 2.0), BRONZE)
	button.move_child(bottom_edge, 4)
	var divider := _strip(button, "InscriptionDivider", Vector2(42.0, 216.0), Vector2(188.0, 1.0), Color("#a77a50"))
	button.move_child(divider, 5)
	var art := button.get_node("Art") as TextureRect
	_set_rect(art, Vector2(12.0, 12.0), Vector2(248.0, 144.0))
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var title := button.get_node("Title") as Label
	_set_rect(title, Vector2(16.0, 161.0), Vector2(240.0, 44.0))
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color("#332119"))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.clip_text = true
	var category := button.get_node("Type") as Label
	_set_rect(category, Vector2(20.0, 202.0), Vector2(232.0, 17.0))
	category.add_theme_font_size_override("font_size", 11)
	category.add_theme_color_override("font_color", Color("#5b4531"))
	var description := button.get_node("Description") as Label
	_set_rect(description, Vector2(22.0, 223.0), Vector2(228.0, 74.0))
	description.add_theme_font_size_override("font_size", 13)
	description.add_theme_color_override("font_color", Color("#3b2a22"))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.clip_text = true
	var choose := button.get_node("Hint") as Label
	_set_rect(choose, Vector2(22.0, 306.0), Vector2(228.0, 22.0))
	choose.add_theme_font_size_override("font_size", 14)
	choose.add_theme_color_override("font_color", Color("#ffe1aa"))
	choose.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	choose.clip_text = true
	var mark := button.get_node("Mark") as Label
	_set_rect(mark, Vector2(20.0, 18.0), Vector2(230.0, 25.0))
	mark.add_theme_font_size_override("font_size", 12)
	mark.clip_text = true
	for data in [["CornerTL", Vector2(7.0, 157.0)], ["CornerTR", Vector2(243.0, 157.0)], ["CornerBL", Vector2(7.0, 301.0)], ["CornerBR", Vector2(243.0, 301.0)]]:
		var ornament := Label.new()
		ornament.name = String(data[0])
		ornament.text = "◆"
		ornament.position = data[1]
		ornament.size = Vector2(22.0, 22.0)
		ornament.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ornament.add_theme_color_override("font_color", BRONZE)
		ornament.add_theme_font_size_override("font_size", 12)
		button.add_child(ornament)

static func short_description(original: String) -> String:
	var plain := original.replace("\n", " ").strip_edges()
	const MAX_COPY := 100
	if plain.length() <= MAX_COPY:
		return plain
	var clipped := plain.substr(0, MAX_COPY)
	var word_end := clipped.rfind(" ")
	if word_end >= 55:
		clipped = clipped.substr(0, word_end)
	return clipped.strip_edges() + "…"

static func style_hold_button(button: Button) -> void:
	# Stay visible above a hovered card, which raises to z_index=20.
	button.z_index = 40
	var idle := StyleBoxFlat.new()
	idle.bg_color = Color("#1c1112")
	idle.border_width_left = 2
	idle.border_width_right = 2
	idle.border_width_top = 2
	idle.border_width_bottom = 2
	idle.border_color = BRONZE
	idle.shadow_color = Color(0.0, 0.0, 0.0, 0.65)
	idle.shadow_size = 4
	var hovered := idle.duplicate() as StyleBoxFlat
	hovered.bg_color = Color("#431d17")
	hovered.border_color = Color("#dfb77e")
	button.add_theme_stylebox_override("normal", idle)
	button.add_theme_stylebox_override("hover", hovered)
	button.add_theme_stylebox_override("pressed", hovered)
	button.add_theme_stylebox_override("disabled", idle.duplicate() as StyleBoxFlat)
	button.add_theme_color_override("font_color", Color("#f2d4a5"))
	button.add_theme_color_override("font_hover_color", Color("#fff0d3"))
	button.add_theme_color_override("font_disabled_color", Color("#a6a09c"))
	button.add_theme_font_size_override("font_size", 12)

static func _strip(host: Control, strip_name: String, at: Vector2, dimensions: Vector2, pigment: Color) -> ColorRect:
	var line := ColorRect.new()
	line.name = strip_name
	line.position = at
	line.size = dimensions
	line.color = pigment
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	host.add_child(line)
	return line

static func _set_rect(target: Control, at: Vector2, dimensions: Vector2) -> void:
	target.position = at
	target.size = dimensions
