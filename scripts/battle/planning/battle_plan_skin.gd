extends RefCounted
## Text-free DS3 materials for the Combat Planning dock only.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const FRAGMENTS := preload("res://scripts/ui/battle_reference_fragments.gd")
const DOSSIER := preload("res://assets/pixel/ui/squad_dossier_d413/panel.webp")
const PARCHMENT_SOURCE := preload("res://assets/pixel/ui/card_ds3_locked/front_frame.webp")
const METAL_SOURCE := preload("res://assets/pixel/ui/battle_ds3_d303/idle_game.webp")
const BATTLE_RED := preload("res://assets/pixel/ui/battle_ds3_d303/fight_button_game.webp")
const SEAL := preload("res://assets/pixel/ui/squad_dossier_d287/ruby_crest.webp")
const INK := Color("#24160e")
const PALE := Color("#f4d4a2")
const GILT := Color("#bd8c56")
const PAPER := Rect2(91, 354, 204, 29)
const METAL := Rect2(110, 12, 398, 86)
const RED_PLATE := Rect2(4, 17, 516, 136)

static func serif(bold: bool = false) -> SystemFont:
	var font := SystemFont.new()
	font.font_names = PackedStringArray(["Georgia", "Cambria", "Noto Serif", "DejaVu Serif"])
	font.font_weight = 700 if bold else 400
	return font

static func slice(source: Texture2D, region: Rect2) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = source
	texture.region = region
	texture.filter_clip = true
	return texture

static func textured(texture: Texture2D, edge: float, tint: Color = Color.WHITE) -> StyleBoxTexture:
	var box := StyleBoxTexture.new()
	box.texture = texture
	box.modulate_color = tint
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		box.set_texture_margin(side, edge)
		box.set_content_margin(side, 5.0 if side in [SIDE_LEFT, SIDE_RIGHT] else 0.0)
	return box

static func frame(compact: bool) -> StyleBoxTexture:
	var box := textured(slice(DOSSIER, Rect2(7, 8, 754, 497)), 31, Color(1.02, 0.95, 0.88))
	if compact:
		box.texture_margin_top = 16
		box.texture_margin_bottom = 16
	box.expand_margin_left = 20
	box.expand_margin_right = 20
	box.expand_margin_top = 5
	box.expand_margin_bottom = 4
	return box

static func mount(parent: Control, texture: Texture2D, at: Vector2, dimensions: Vector2, flip: bool = false) -> TextureRect:
	var art := TextureRect.new()
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.texture = texture
	art.flip_h = flip
	art.position = at
	art.size = dimensions
	parent.add_child(art)
	return art

static func action(button: Button, font: Font, primary: bool = false) -> void:
	var texture := slice(BATTLE_RED, RED_PLATE) if primary else slice(METAL_SOURCE, METAL)
	var tones := [Color("#d4ac9c"), Color("#f0cbb3"), Color("#a27d71")] if primary else [
		Color("#cdc0ae"), Color("#f4e1ca"), Color("#a99886")]
	for state in ["normal", "hover", "pressed", "hover_pressed"]:
		var tone: Color = tones[0 if state == "normal" else (1 if state == "hover" else 2)]
		button.add_theme_stylebox_override(state, textured(texture, 10 if primary else 12, tone))
	button.add_theme_stylebox_override("disabled", textured(texture, 10 if primary else 12, Color("#786c65")))
	button.add_theme_stylebox_override("focus", focus())
	button.add_theme_font_override("font", font)
	for name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(name, PALE)

static func focus() -> StyleBoxFlat:
	var box := DS3.make_plate(Color.TRANSPARENT, PALE, 1, 0)
	box.draw_center = false
	return box

static func order(button: Button, filled: bool, selected: bool) -> void:
	var paper := slice(PARCHMENT_SOURCE, PAPER)
	var metal := slice(METAL_SOURCE, METAL)
	var texture: Texture2D = paper if filled else metal
	var normal := Color("#e8e3db") if selected else Color(0.99, 1.0, 1.02)
	if not filled:
		normal = Color("#b5a291")
	button.add_theme_stylebox_override("normal", textured(texture, 8, normal))
	button.add_theme_stylebox_override("hover", textured(texture, 8, Color(1.06, 1.04, 1.02) if filled else Color("#ebd4b7")))
	button.add_theme_stylebox_override("pressed", textured(texture, 8, Color("#d1c0ac")))
	button.add_theme_stylebox_override("focus", focus())

static func field(control: Control, font: Font) -> void:
	var paper := slice(PARCHMENT_SOURCE, PAPER)
	for state in ["normal", "hover", "pressed"]:
		var style := textured(paper, 8, Color(1.06, 1.04, 1.02) if state == "hover" else Color.WHITE)
		style.content_margin_left = 9
		style.content_margin_right = 9
		control.add_theme_stylebox_override(state, style)
	control.add_theme_stylebox_override("focus", focus())
	control.add_theme_font_override("font", font)
	for name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		control.add_theme_color_override(name, INK)
	if control is OptionButton:
		control.add_theme_constant_override("modulate_arrow", 1)
		var choices: PopupMenu = control.get_popup()
		choices.add_theme_font_override("font", font)
		choices.add_theme_color_override("font_color", PALE)
		choices.add_theme_color_override("font_hover_color", PALE.lightened(0.24))
		choices.add_theme_stylebox_override("panel", DS3.make_plate(DS3.OBSIDIAN, GILT, 1, 4))
		choices.add_theme_stylebox_override("hover", DS3.make_plate(Color("#42241d"), GILT, 0, 0))

static func etched_border(canvas: Control, selected: bool = false) -> void:
	var w := canvas.size.x
	var h := canvas.size.y
	var rim := PackedVector2Array([
		Vector2(7, 1), Vector2(w - 7, 1), Vector2(w - 1, 7), Vector2(w - 1, h - 7),
		Vector2(w - 7, h - 1), Vector2(7, h - 1), Vector2(1, h - 7), Vector2(1, 7), Vector2(7, 1),
	])
	canvas.draw_polyline(rim, Color("#21130e"), 3.0, true)
	canvas.draw_polyline(rim, PALE if selected else GILT.darkened(0.30), 1.0, true)
	for x in [2.0, w - 2.0]:
		canvas.draw_circle(Vector2(x, h * 0.5), 2.2, Color("#3b271a"), true, -1.0, true)
		canvas.draw_circle(Vector2(x, h * 0.5), 0.95, GILT, true, -1.0, true)

static func emblem(canvas: Control, role: String) -> void:
	var at := canvas.size * 0.5
	var radius := 14.0
	var fill := Color("#391e1a") if role != "ranger" else Color("#29251d")
	canvas.draw_circle(at, radius, Color("#0e0907"), true, -1.0, true)
	canvas.draw_circle(at, radius - 1.4, fill, true, -1.0, true)
	canvas.draw_arc(at, radius - 1.3, 0.0, TAU, 28, GILT, 1.0, true)
	canvas.draw_arc(at, radius - 3.1, 0.0, TAU, 24, GILT.darkened(0.45), 1.0, true)
	for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		var tip: Vector2 = at + direction * radius
		canvas.draw_circle(tip, 1.4, PALE, true, -1.0, true)
	var shape: String = {"knight": "defense", "ranger": "bow", "mage": "book"}[role]
	glyph(canvas, shape, at, 0.83, PALE)

static func glyph(canvas: CanvasItem, kind: String, at: Vector2, scale: float, color: Color) -> void:
	canvas.draw_set_transform(at, 0.0, Vector2.ONE * scale)
	match kind:
		"defense":
			_path(canvas, [[-7,-7], [0,-9], [7,-7], [6,2], [3,6], [0,9], [-3,6], [-6,2], [-7,-7]], color)
			_path(canvas, [[0,-6], [0,6]], color)
		"assault":
			for direction in [-1.0, 1.0]:
				_path(canvas, [[-7*direction,-8], [-6*direction,-4], [4*direction,5], [8*direction,9]], color)
				_path(canvas, [[-7*direction,-8], [-3*direction,-7], [5*direction,4]], color)
				_path(canvas, [[0,7], [6*direction,1]], color)
		"hunt":
			canvas.draw_arc(Vector2.ZERO, 6.5, 0.0, TAU, 24, color, 1.5, true)
			for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				canvas.draw_line(direction * 4.0, direction * 9.8, color, 1.4, true)
			canvas.draw_circle(Vector2.ZERO, 1.15, color, true, -1.0, true)
		"time":
			_path(canvas, [[-6,-7], [6,-7], [0,0], [6,7], [-6,7], [0,0], [-6,-7]], color)
		"end":
			_path(canvas, [[0,-7], [6,0], [0,7], [-6,0], [0,-7]], color)
			canvas.draw_circle(Vector2.ZERO, 1.6, color, true, -1.0, true)
		"bow":
			canvas.draw_arc(Vector2(-4, 0), 8, -1.27, 1.27, 18, color, 1.6, true)
			_path(canvas, [[-1,-8], [-1,8]], color)
			_path(canvas, [[-8,5], [7,-5], [3,-5]], color)
			_path(canvas, [[7,-5], [6,-1]], color)
		"book":
			_path(canvas, [[0,-5], [-4,-7], [-9,-6], [-9,5], [-4,4], [0,7], [4,4], [9,5], [9,-6], [4,-7], [0,-5], [0,7]], color)
			_path(canvas, [[-7,-3], [-3,-2]], color)
			_path(canvas, [[3,-2], [7,-3]], color)
	canvas.draw_set_transform(Vector2.ZERO)

static func _path(canvas: CanvasItem, corners: Array, color: Color) -> void:
	var points := PackedVector2Array()
	for corner in corners:
		points.append(Vector2(corner[0], corner[1]))
	canvas.draw_polyline(points, color, 1.65, true)
