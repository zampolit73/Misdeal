extends RefCounted
## Shared native Archive V3 materials. No collection, profile or input logic.
const MENU := preload("res://scripts/ui/system_dialog.gd")
const GRADE := preload("res://scripts/ui/wizard_archive_grade.gdshader")
const ROOM := preload("res://assets/pixel/ui/wizard_archive/library.webp")
const GOLD := Color("#e8cb95")
const COPY := Color("#e5dbc4")
const MUTED := Color("#b99b80")
const DEFEAT := Color("#e7a299")
const DETAIL_RECTS := [
	Rect2(834, 165, 348, 519),
	Rect2(834, 165, 348, 519),
	Rect2(622, 165, 561, 519),
	Rect2(671, 165, 513, 519),
]

static var _decoration_material: ShaderMaterial
static var _ink_material: ShaderMaterial


static func _place(parent: Control, child: Control, area: Rect2) -> void:
	child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(child)
	child.position = area.position
	child.size = area.size


static func plaque(parent: Control, area: Rect2, primary: bool = false) -> Panel:
	var panel := Panel.new()
	var style := MENU.plate_style(MENU.PRIMARY if primary else MENU.SECONDARY)
	if area.size.y > 110:
		style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
		style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	panel.add_theme_stylebox_override("panel", style)
	_place(parent, panel, area)
	return panel


static func style_button(button: Button, selected: bool = false) -> void:
	if button.has_meta(&"_archive_primary") and button.get_meta(&"_archive_primary") == selected:
		return
	button.set_meta(&"_archive_primary", selected)
	var texture := MENU.PRIMARY if selected else MENU.SECONDARY
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		var style := MENU.plate_style(texture)
		# The text is still the existing, independently positioned Label.
		for side in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			style.set_content_margin(side, 0.0)
		if state == "hover":
			style.modulate_color = Color(1.10, 1.07, 1.04)
		elif state == "disabled":
			style.modulate_color = Color(0.55, 0.55, 0.55)
		button.add_theme_stylebox_override(state, style)
	var focus := MENU.plate_style(texture)
	focus.draw_center = false
	focus.modulate_color = Color(1.3, 1.18, 1.09)
	for side in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
		focus.set_content_margin(side, 0.0)
	button.add_theme_stylebox_override("focus", focus)


static func present_page(plate: TextureRect, index: int) -> void:
	for child in plate.get_children():
		# Only non-interactive visual children are rebuilt on tab changes.
		child.free()
	var bounds: Rect2 = DETAIL_RECTS[index]
	var material := ShaderMaterial.new()
	material.shader = GRADE
	material.set_shader_parameter("full_plate", true)
	material.set_shader_parameter("room", ROOM)
	material.set_shader_parameter("detail_rect", Vector4(bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y))
	plate.material = material
	var details := plaque(plate, bounds)
	details.name = "ArchiveV3Details"
	# Keep source decorative art on the two pages that use it. These are
	# decorative only; the existing portraits and records stay live.
	if index == 2:
		_illustration(plate, Rect2(651, 243, 421, 106))
		_illustration(plate, Rect2(1080, 177, 80, 157))
		_illustration(plate, Rect2(1080, 566, 83, 101))
	elif index == 3:
		_illustration(plate, Rect2(695, 199, 463, 145), 0.64)


static func _illustration(plate: TextureRect, area: Rect2, opacity: float = 1.0) -> void:
	var atlas := AtlasTexture.new()
	atlas.atlas = plate.texture
	atlas.region = area
	atlas.filter_clip = true
	var picture := TextureRect.new()
	picture.texture = atlas
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if _ink_material == null:
		_ink_material = ShaderMaterial.new()
		_ink_material.shader = GRADE
		_ink_material.set_shader_parameter("illustration", true)
	picture.material = _ink_material
	picture.modulate.a = opacity
	_place(plate, picture, area)


static func mute_highlight(picture: TextureRect) -> void:
	if _decoration_material == null:
		_decoration_material = ShaderMaterial.new()
		_decoration_material.shader = GRADE
	picture.material = _decoration_material
