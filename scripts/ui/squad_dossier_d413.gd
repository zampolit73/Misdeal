extends RefCounted

# D413: strictly visual overlay. All controls and RunState calculations remain
# in squad_status / squad_dossier_v3; artwork never contains live UI text.
const ART := "res://assets/pixel/ui/squad_dossier_d413/"
static var _panel: Texture2D
static var _heading: SystemFont
static var _bold: SystemFont

static func _material(bright: bool = false) -> StyleBoxTexture:
	if _panel == null:
		var image := Image.new()
		image.load_webp_from_buffer(FileAccess.get_file_as_bytes(ART + "panel.webp"))
		# Keep sculpted border corners small and crisp at the native UI scale.
		image.resize(384, 256, Image.INTERPOLATE_LANCZOS)
		_panel = ImageTexture.create_from_image(image)
	var style := StyleBoxTexture.new()
	style.texture = _panel
	style.set_texture_margin(SIDE_LEFT, 30)
	style.set_texture_margin(SIDE_RIGHT, 30)
	style.set_texture_margin(SIDE_TOP, 24)
	style.set_texture_margin(SIDE_BOTTOM, 24)
	style.set_content_margin_all(8)
	style.modulate_color = Color(1.3, 1.15, 0.95) if bright else Color.WHITE
	return style

static func apply(scene: Control) -> void:
	if _heading == null:
		_heading = SystemFont.new()
		_heading.font_names = PackedStringArray(["Georgia", "Liberation Serif", "DejaVu Serif", "Times New Roman"])
		_bold = _heading.duplicate() as SystemFont
		_bold.font_weight = 700
	for path in ["Frame", "Frame/BuildPanel", "Frame/RelicsPanel", "Frame/CommonPanel"]:
		(scene.get_node(path) as Panel).add_theme_stylebox_override("panel", _material())
	var frame := scene.get_node("Frame") as Control
	# Give an equipped relic enough room for its real effect text, not just
	# the title above a tiny scrollbar. Longer collections still scroll.
	(scene.get_node("Frame/BuildPanel") as Control).size.y = 239
	var relics := scene.get_node("Frame/RelicsPanel") as Control
	relics.position.y = 355
	relics.size.y = 210
	(scene.get_node("Frame/BuildList") as Control).position.y = 265
	(scene.get_node("Frame/BuildList") as Control).size.y = 76
	(scene.get_node("Frame/RelicsList") as Control).position.y = 493
	(scene.get_node("Frame/RelicsList") as Control).size.y = 65
	for i in range(3):
		(frame.get_node("RelicSlot%d" % (i + 1)) as Control).position.y = 410
	(frame.get_node("RelicCount") as Control).position.y = 367
	for panel_path in ["Frame/BuildPanel", "Frame/RelicsPanel", "Frame/PortraitFrame"]:
		for decoration in scene.get_node(panel_path).get_children():
			if "Filigree" in str(decoration.name) or "LowerRule" in str(decoration.name):
				decoration.visible = false
	# Retain the original ornament resources for rollback/smoke contracts;
	# the new painted frame supplies its own cornerwork.
	for child in frame.get_children():
		if "DossierFiligree" in str(child.name):
			child.visible = false
	for path in ["Frame/Title", "Frame/HeroName", "Frame/StatsTitle", "Frame/BuildPanel/BuildTitle", "Frame/RelicsPanel/RelicsTitle", "Frame/PartyCaption"]:
		var label := scene.get_node(path) as Label
		label.add_theme_font_override("font", _heading)
		label.add_theme_color_override("font_color", Color("e8c591"))
	var title := scene.get_node("Frame/Title") as Label
	title.position = Vector2(260, 14)
	title.size = Vector2(650, 45)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	var hint := scene.get_node("Frame/Hint") as Label
	hint.position = Vector2(250, 65)
	hint.size = Vector2(690, 24)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	(scene.get_node("Frame/HeroName") as Label).add_theme_font_size_override("font_size", 31)
	(scene.get_node("Frame/PartyCaption") as Label).add_theme_font_size_override("font_size", 15)
	for path in ["Frame/BuildPanel/BuildTitle", "Frame/RelicsPanel/RelicsTitle"]:
		var label := scene.get_node(path) as Label
		label.position.x = 24
		label.add_theme_font_size_override("font_size", 21)
	for i in range(3):
		# Existing artifact tooltip now receives hover; it has no click action.
		(frame.get_node("RelicSlot%d" % (i + 1)) as Panel).mouse_filter = Control.MOUSE_FILTER_PASS
		var number := frame.get_node("UpgradeNumber%d" % (i + 1)) as Label
		number.add_theme_font_override("font", _heading)
		number.add_theme_font_size_override("font_size", 14)
		number.add_theme_color_override("font_color", Color("c9b28b"))
	for i in range(4):
		(frame.get_node("CommonPanel/Summary%d" % i) as Label).add_theme_font_size_override("font_size", 16)
	for role in ["knight", "ranger", "mage"]:
		var button := scene.get_node("Frame/" + role.capitalize() + "Button") as Button
		button.add_theme_stylebox_override("hover", _material(true))
		button.add_theme_stylebox_override("pressed", _material(true))
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color.TRANSPARENT
		focus.border_color = Color("dfb77e")
		focus.set_border_width_all(2)
		button.add_theme_stylebox_override("focus", focus)
		var label := button.get_node("RoleTitle") as Label
		label.add_theme_font_override("font", _heading)
		label.add_theme_font_size_override("font_size", 18)
	# A real overlay frame around the portrait leaves the painting intact.
	var portrait := scene.get_node("Frame/PortraitFrame") as Control
	var border := NinePatchRect.new()
	border.name = "D413PortraitBorder"
	border.texture = _panel
	border.draw_center = false
	border.patch_margin_left = 30
	border.patch_margin_right = 30
	border.patch_margin_top = 24
	border.patch_margin_bottom = 24
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.add_child(border)
	border.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for path in ["Frame/Stats", "Frame/BuildList", "Frame/RelicsList"]:
		var text := scene.get_node(path) as RichTextLabel
		text.add_theme_constant_override("line_separation", 5)
		text.add_theme_constant_override("table_h_separation", 8)
		text.add_theme_font_override("normal_font", _heading)
		text.add_theme_font_override("bold_font", _bold)
		text.add_theme_font_size_override("normal_font_size", 15)

static func refresh_selection(scene: Control, selected: String) -> void:
	for role in ["knight", "ranger", "mage"]:
		var button := scene.get_node("Frame/" + role.capitalize() + "Button") as Button
		button.add_theme_stylebox_override("normal", _material(role == selected))
		(button.get_node("RoleTitle") as Label).add_theme_color_override("font_color", Color("f6dbad") if role == selected else Color("cbbba4"))
