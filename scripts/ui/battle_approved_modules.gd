extends RefCounted

# D304 — The five USER-APPROVED standalone D303 painted UI modules.
# Intentionally inert unless the real source-derived art files exist.
# The older DS3 chrome remains the safe fallback on an uninstalled checkout.
#
# No battle data, UI labels, attack rules, party placement, or callbacks
# are modified here. All assets are text-free original picture modules.
const ART := "res://assets/pixel/ui/battle_ds3_d303/"
const REQUIRED := [
	"command_game.webp",
	"fight_panel_game.webp",
	"idle_game.webp",
	"selected_game.webp",
	"fight_button_game.webp",
]
const ORDERS := [
	"AssaultOrderButton", "HuntOrderButton", "FormationOrderButton",
	"SacrificeOrderButton", "DefianceOrderButton"
]

static var _images: Dictionary = {}


static func available() -> bool:
	for name in REQUIRED:
		if not ResourceLoader.exists(ART + name):
			return false
	return true


static func _texture(name: String) -> Texture2D:
	if _images.has(name):
		return _images[name] as Texture2D
	var result := load(ART + name) as Texture2D
	if result != null:
		_images[name] = result
	return result


static func apply(scene: Control) -> void:
	if not available():
		return
	var command := scene.get_node("BottomHudPanel") as Panel
	var fight := scene.get_node("FightHudPanel") as Panel
	for panel in [command, fight]:
		# Avoid stacking D298 SVGs, D299/D300 crops, D296 vector inlays,
		# and the actual approved full-panel art over one another.
		for child in panel.get_children():
			if child.name.begins_with("DS3"):
				child.hide()
		panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	_draw_module(command, "D304CommandArt", "command_game.webp",
		Vector2(0, -30), Vector2(691, 175))
	_draw_module(fight, "D304FightArt", "fight_panel_game.webp",
		Vector2(0, -30), Vector2(293, 175))
	for path in ORDERS:
		var choice := scene.get_node(path) as Button
		style_tactic(choice, choice.button_pressed)
	style_fight(scene.get_node("FightButton") as Button)
	# The real target toggle stays operable and readable above its illustrated
	# smaller niche. Continue/Restart keep their existing genuine button state.


static func style_tactic(button: Button, selected: bool) -> void:
	if button == null or not available():
		return
	var idle := _texture("idle_game.webp")
	var active := _texture("selected_game.webp")
	if idle == null or active == null:
		return
	_set_state(button, "normal", active if selected else idle)
	_set_state(button, "hover", active)
	_set_state(button, "pressed", active)
	_set_state(button, "hover_pressed", active)
	_set_state(button, "disabled", idle)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	# The artwork already contains the metal, highlight and inset plate.
	# Retain only the actual engraved order-specific glyph.
	var tool_mark := button.get_node_or_null("DS3EtchedToken") as Control
	if tool_mark != null:
		tool_mark.set("kind", "order_symbol_only")
		tool_mark.queue_redraw()
	for name in ["DS3SelectedInlay", "DS3OrderMark"]:
		var old_detail := button.get_node_or_null(name) as CanvasItem
		if old_detail != null:
			old_detail.hide()
	button.add_theme_color_override("font_color", Color("#f2d3a2"))
	button.add_theme_color_override("font_hover_color", Color("#fff0cb"))
	button.add_theme_color_override("font_pressed_color", Color("#fff0cb"))


static func style_fight(button: Button) -> void:
	if button == null or not available():
		return
	var red := _texture("fight_button_game.webp")
	if red == null:
		return
	for state in ["normal", "hover", "pressed", "hover_pressed"]:
		_set_state(button, state, red)
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	button.add_theme_color_override("font_color", Color("#f6d6a5"))


static func _set_state(button: Button, state: String, texture: Texture2D) -> void:
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.draw_center = true
	style.content_margin_left = 4.0
	style.content_margin_right = 4.0
	style.content_margin_top = 3.0
	style.content_margin_bottom = 3.0
	button.add_theme_stylebox_override(state, style)


static func _draw_module(panel: Panel, name: String, asset_name: String, at: Vector2, dimensions: Vector2) -> void:
	var art := panel.get_node_or_null(name) as TextureRect
	if art != null:
		return
	var texture := _texture(asset_name)
	if texture == null:
		push_warning("D304: Missing approved Battle module: " + asset_name)
		return
	art = TextureRect.new()
	art.name = name
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.position = at
	art.size = dimensions
	art.texture = texture
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	panel.add_child(art)
