extends RefCounted

# Reference polish only: never changes RunState, inventory or combat.
const ICON_DIR := "res://assets/pixel/ui/squad_dossier_d414/"
const ARTIFACTS := preload("res://scripts/ui/artifact_art_catalog.gd")
static var _icons: Dictionary = {}

static func _icon(name: String) -> Texture2D:
	if not _icons.has(name):
		var image := Image.new()
		image.load_svg_from_string(FileAccess.get_file_as_string(ICON_DIR + name + ".svg"))
		_icons[name] = ImageTexture.create_from_image(image)
	return _icons[name]

static func apply(scene: Control) -> void:
	var ribbon := StyleBoxFlat.new()
	ribbon.bg_color = Color("1c2736")
	ribbon.border_color = Color("65809b")
	ribbon.border_width_left = 3
	ribbon.border_width_top = 1
	ribbon.border_width_bottom = 1
	ribbon.set_content_margin(SIDE_LEFT, 8)
	ribbon.set_content_margin(SIDE_TOP, 3)
	ribbon.set_content_margin(SIDE_BOTTOM, 3)
	(scene.get_node("Frame/Specialization") as Label).add_theme_stylebox_override("normal", ribbon)
	for role in ["knight", "ranger", "mage"]:
		var button := scene.get_node("Frame/" + role.capitalize() + "Button") as Button
		var bar := ColorRect.new()
		bar.name = "D414SelectedBar"
		bar.position = Vector2(4, 6)
		bar.size = Vector2(3, 88)
		bar.color = Color("e9be7e")
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(bar)
	var footer := scene.get_node("Frame/CommonPanel") as Control
	var starts := [22, 300, 578, 856]
	for i in range(4):
		var label := footer.get_node("Summary%d" % i) as Label
		label.position.x = starts[i] + 27
		label.size.x = 225
		var glyph := TextureRect.new()
		glyph.name = "D414FooterIcon%d" % i
		glyph.texture = _icon(["party", "heart", "swords", "cadence"][i])
		glyph.position = Vector2(starts[i], 10)
		glyph.size = Vector2(19, 19)
		glyph.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		footer.add_child(glyph)
	for i in range(4):
		var rule := footer.get_node("ColumnRule%d" % [149,294,440,589][i]) as ColorRect
		rule.visible = i < 3
		rule.position.x = [280,558,836,1110][i]
	for i in range(3):
		var slot := scene.get_node("Frame/RelicSlot%d" % (i + 1)) as Panel
		var picture := TextureRect.new()
		picture.name = "D414ArtifactImage"
		picture.position = Vector2(7, 7)
		picture.size = Vector2(77, 61)
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(picture)

static func refresh(scene: Control, role: String, available: bool) -> void:
	for candidate in ["knight", "ranger", "mage"]:
		scene.get_node("Frame/" + candidate.capitalize() + "Button/D414SelectedBar").visible = candidate == role
	var artifacts: Array = RunState.get_artifacts_for_role(role) if available else []
	for i in range(3):
		var slot := scene.get_node("Frame/RelicSlot%d" % (i + 1)) as Panel
		var picture := slot.get_node("D414ArtifactImage") as TextureRect
		picture.texture = ARTIFACTS.get_texture(artifacts[i].artifact_id) if i < artifacts.size() else null
		picture.visible = picture.texture != null
		slot.get_node("Symbol").visible = not picture.visible
		if i < artifacts.size():
			slot.tooltip_text = artifacts[i].title + "\n" + artifacts[i].description
	var upgrades := RunState.get_role_upgrade_count(role) if available else 0
	for i in range(3):
		var gem := scene.get_node("Frame/UpgradeGem%d" % (i + 1)) as Panel
		var style := gem.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
		if i < upgrades:
			style.shadow_size = 7
			style.shadow_offset = Vector2.ZERO
			style.shadow_color = Color(0.9, 0.44, 0.12, 0.28)
		gem.add_theme_stylebox_override("panel", style)
	if available:
		var stats := scene.get_node("Frame/Stats") as RichTextLabel
		stats.add_theme_font_size_override("normal_font_size", 14)
		stats.add_theme_constant_override("table_h_separation", 6)
		var text := stats.text
		var names := ["ЗДОРОВЬЕ", "УРОН", "АТАК/СЕК", "ДАЛЬНОСТЬ", "СКОРОСТЬ", "УРОН/СЕК", "МИН. ДИСТ.", "РАДИУС", "ПОБОЧН. %"]
		var icons := ["heart", "swords", "cadence", "range", "speed", "burst", "range", "range", "burst"]
		for i in range(names.size()):
			var old := "[cell][color=#d0bfa4]%s[/color]" % names[i]
			var decorated := "[cell expand=3 shrink=false][img=16x16]%s%s.svg[/img]\u00a0[color=#d0bfa4]%s[/color]" % [ICON_DIR, icons[i], names[i]]
			text = text.replace(old, decorated)
		stats.text = text
