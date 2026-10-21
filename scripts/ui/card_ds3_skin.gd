extends RefCounted

# D315 — ONE visual card system, authored from the user-approved card sheet.
# All source texts, card IDs, effects, rewards, click handlers and art catalogs
# remain authoritative. Never paste composite card mockups over controls.
const FRONT := "res://assets/pixel/ui/card_ds3_locked/front_frame.webp"
const BACK := "res://assets/pixel/ui/card_ds3_locked/card_back.webp"
const INK := "res://assets/pixel/ui/card_ds3_locked/ink_substrate.webp"
const CARD_SHADER: Shader = preload("res://shaders/card_ds3_ink.gdshader")
const GOLD := Color("#e4b46c")
const INK_TEXT := Color("#251610")
const BONE := Color("#eddbbd")
const TABLE_SIZE := Vector2(272, 338)

static var _textures: Dictionary = {}

static func _texture(path: String) -> Texture2D:
    if _textures.has(path):
        return _textures[path] as Texture2D
    var result := load(path) as Texture2D
    if result != null:
        _textures[path] = result
    return result

static func _empty_button(button: Button) -> void:
    var blank := StyleBoxEmpty.new()
    for state in ["normal", "hover", "pressed", "disabled", "focus"]:
        button.add_theme_stylebox_override(state, blank)
    button.add_theme_color_override("font_color", BONE)
    button.add_theme_color_override("font_hover_color", GOLD)

static func _new_art(host: Control, node_name: String, texture: Texture2D, dimensions: Vector2) -> TextureRect:
    var layer := TextureRect.new()
    layer.name = node_name
    layer.texture = texture
    layer.position = Vector2.ZERO
    layer.size = dimensions
    layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    layer.stretch_mode = TextureRect.STRETCH_SCALE
    layer.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    host.add_child(layer)
    return layer

static func _at(control: Control, at: Vector2, dimensions: Vector2) -> void:
    control.position = at
    control.size = dimensions
    control.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func grade(art: TextureRect) -> void:
    var mat := ShaderMaterial.new()
    mat.shader = CARD_SHADER
    art.material = mat
    art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR

static func apply_table(button: Button) -> bool:
    var frame := _texture(FRONT)
    var ink := _texture(INK)
    if frame == null or ink == null:
        return false
    if button.has_node("DS3CardFrame"):
        return true
    button.custom_minimum_size = TABLE_SIZE
    button.size = TABLE_SIZE
    button.clip_contents = true
    _empty_button(button)
    var substrate := _new_art(button, "DS3CardStone", ink, TABLE_SIZE)
    button.move_child(substrate, 0)
    var painting := button.get_node("Art") as TextureRect
    _at(painting, Vector2(30, 36), Vector2(213, 190))
    painting.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    grade(painting)
    button.move_child(painting, 1)
    var overlay := _new_art(button, "DS3CardFrame", frame, TABLE_SIZE)
    button.move_child(overlay, 2)

    var title := button.get_node("Title") as Label
    _at(title, Vector2(47, 232), Vector2(180, 28))
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    title.add_theme_font_size_override("font_size", 14)
    title.add_theme_color_override("font_color", INK_TEXT)
    title.clip_text = true
    title.max_lines_visible = 2

    var category := button.get_node("Type") as Label
    # D318: category belongs in the physical frame's top-right blank tab;
    # it must never obscure the unique encounter painting.
    _at(category, Vector2(174, 16), Vector2(78, 20))
    category.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    category.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    category.add_theme_font_size_override("font_size", 9)
    category.add_theme_color_override("font_color", GOLD)
    category.clip_text = true

    var body := button.get_node("Description") as Label
    _at(body, Vector2(43, 263), Vector2(186, 45))
    body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body.add_theme_font_size_override("font_size", 11)
    body.add_theme_color_override("font_color", BONE)
    body.clip_text = true
    body.max_lines_visible = 2

    var hint := button.get_node("Hint") as Label
    _at(hint, Vector2(52, 305), Vector2(169, 21))
    hint.add_theme_font_size_override("font_size", 11)
    hint.add_theme_color_override("font_color", GOLD)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    hint.clip_text = true
    var mark := button.get_node("Mark") as Label
    _at(mark, Vector2(34, 45), Vector2(204, 23))
    mark.add_theme_color_override("font_color", Color("#ffb37e"))
    mark.add_theme_font_size_override("font_size", 11)

    var roman := Label.new()
    roman.name = "DS3Roman"
    roman.position = Vector2(114, 11)
    roman.size = Vector2(49, 20)
    roman.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    roman.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    roman.add_theme_color_override("font_color", GOLD)
    roman.add_theme_font_size_override("font_size", 14)
    roman.mouse_filter = Control.MOUSE_FILTER_IGNORE
    button.add_child(roman)
    return true

static func update_table_roman(button: Button, number: int) -> void:
    var mark := button.get_node_or_null("DS3Roman") as Label
    if mark == null:
        return
    const ROMAN := ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII"]
    mark.text = ROMAN[clampi(number - 1, 0, 12)]

static func apply_table_backs(scene: Control) -> void:
    var back := _texture(BACK)
    if back == null:
        return
    # The sealed/dealt face stays hidden; only the original live Back textures
    # change. RunState's future-card privacy and transition timings remain.
    for path in ["OfferBackLeft", "OfferBackRight"]:
        var view := scene.get_node_or_null(path) as TextureRect
        if view != null:
            view.texture = back
            view.material = null
            view.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
            view.stretch_mode = TextureRect.STRETCH_SCALE

static func apply_reward(button: Button, portrait: TextureRect,
        role: Label, heading: Label, effect: Label, description: Label) -> bool:
    var frame := _texture(FRONT)
    var ink := _texture(INK)
    if frame == null or ink == null:
        return false
    if button.has_node("DS3CardFrame"):
        return true
    _empty_button(button)
    button.custom_minimum_size = Vector2(292, 410)
    button.focus_mode = Control.FOCUS_ALL
    button.clip_contents = true
    var bottom := _new_art(button, "DS3CardStone", ink, Vector2(292, 410))
    button.move_child(bottom, 0)
    _at(portrait, Vector2(27, 41), Vector2(238, 234))
    portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    grade(portrait)
    button.move_child(portrait, 1)
    var face := _new_art(button, "DS3CardFrame", frame, Vector2(292, 410))
    button.move_child(face, 2)
    _at(role, Vector2(38, 8), Vector2(216, 23))
    role.add_theme_color_override("font_color", GOLD)
    role.add_theme_font_size_override("font_size", 12)
    role.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _at(heading, Vector2(38, 285), Vector2(216, 31))
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    heading.add_theme_color_override("font_color", INK_TEXT)
    heading.add_theme_font_size_override("font_size", 15)
    _at(effect, Vector2(36, 328), Vector2(220, 27))
    effect.add_theme_color_override("font_color", GOLD)
    effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _at(description, Vector2(35, 355), Vector2(222, 45))
    description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description.add_theme_color_override("font_color", BONE)
    description.add_theme_font_size_override("font_size", 11)
    description.clip_text = true
    return true

static func style_reward_copy(button: Button, role: Label, heading: Label,
        effect: Label, description: Label) -> void:
    if not button.has_node("DS3CardFrame"):
        return
    role.add_theme_color_override("font_color", GOLD)
    heading.add_theme_color_override("font_color", INK_TEXT)
    effect.add_theme_color_override("font_color", GOLD)
    description.add_theme_color_override("font_color", BONE)
    var has_effect := effect.visible
    _at(effect, Vector2(36, 325), Vector2(220, 36 if has_effect else 0))
    _at(description, Vector2(35, 360 if has_effect else 325),
        Vector2(222, 40 if has_effect else 75))
    description.add_theme_font_size_override("font_size", 11)
    effect.add_theme_font_size_override("font_size", 11)
    # Long effect texts remain available in the original complete tooltip.

# D316: physical DS3 card inside the already existing non-destructive
# full-text inspection panel. This is a true card illustration, not a separate
# menu control; detailed lore stays in its original scrollable right column.
static func apply_inspection(host: Control, illustration: TextureRect) -> bool:
    var frame := _texture(FRONT)
    var ink := _texture(INK)
    if frame == null or ink == null:
        return false
    if host.has_node("DS3InspectFrame"):
        return true
    const CARD_AT := Vector2(38, 51)
    const CARD_EXTENT := Vector2(225, 306)
    var stone := _new_art(host, "DS3InspectStone", ink, CARD_EXTENT)
    stone.position = CARD_AT
    # Draw behind the real original illustration, not over the black title well.
    host.move_child(stone, illustration.get_index())
    _at(illustration, CARD_AT + Vector2(24, 32), Vector2(177, 179))
    illustration.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    grade(illustration)
    var gilt := _new_art(host, "DS3InspectFrame", frame, CARD_EXTENT)
    gilt.position = CARD_AT
    host.move_child(gilt, illustration.get_index() + 1)
    var plate_title := Label.new()
    plate_title.name = "DS3InspectCardTitle"
    plate_title.position = CARD_AT + Vector2(26, 216)
    plate_title.size = Vector2(174, 31)
    plate_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    plate_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    plate_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    plate_title.add_theme_font_size_override("font_size", 12)
    plate_title.add_theme_color_override("font_color", INK_TEXT)
    plate_title.clip_text = true
    plate_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
    host.add_child(plate_title)
    var reading_mark := Label.new()
    reading_mark.name = "DS3InspectCardHint"
    reading_mark.text = "ИЗ КНИГИ СУДЬБЫ"
    reading_mark.position = CARD_AT + Vector2(29, 265)
    reading_mark.size = Vector2(167, 19)
    reading_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    reading_mark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    reading_mark.add_theme_font_size_override("font_size", 10)
    reading_mark.add_theme_color_override("font_color", BONE)
    reading_mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
    host.add_child(reading_mark)
    return true


static func apply_spread_slot(panel: Panel, art: TextureRect, title_plate: ColorRect,
        title: Label, dimensions: Vector2) -> void:
    var frame := _texture(FRONT)
    var ink := _texture(INK)
    if frame == null or ink == null or panel.has_node("DS3CardFrame"):
        return
    var bg := _new_art(panel, "DS3CardStone", ink, dimensions)
    panel.move_child(bg, 0)
    var artwork_height := dimensions.y * 0.61
    _at(art, Vector2(dimensions.x * 0.13, dimensions.y * 0.10),
        Vector2(dimensions.x * 0.74, artwork_height))
    grade(art)
    panel.move_child(art, 1)
    var face := _new_art(panel, "DS3CardFrame", frame, dimensions)
    panel.move_child(face, 2)
    title_plate.modulate.a = 0.0
    _at(title, Vector2(dimensions.x * 0.10, dimensions.y * 0.72),
        Vector2(dimensions.x * 0.80, dimensions.y * 0.14))
    title.add_theme_color_override("font_color", INK_TEXT)
    title.add_theme_font_size_override("font_size", 8 if dimensions.x < 110 else 11)
    # Fate Roman tabs deliberately protrude above the original slot bounds.
    panel.clip_contents = false

static func apply_sidebar_card(host: Control, art: TextureRect,
        title_plate: ColorRect, title: Label, at: Vector2, dimensions: Vector2) -> void:
    var frame := _texture(FRONT)
    var ink := _texture(INK)
    if frame == null or ink == null or host.has_node("DS3SidebarFrame"):
        return
    var bg := _new_art(host, "DS3SidebarStone", ink, dimensions)
    bg.position = at
    host.move_child(bg, art.get_index())
    _at(art, at + Vector2(dimensions.x * 0.11, dimensions.y * 0.12),
        Vector2(dimensions.x * 0.78, dimensions.y * 0.57))
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    grade(art)
    var frame_node := _new_art(host, "DS3SidebarFrame", frame, dimensions)
    frame_node.position = at
    host.move_child(frame_node, art.get_index() + 1)
    title_plate.modulate.a = 0.0
    _at(title, at + Vector2(dimensions.x * 0.09, dimensions.y * 0.72),
        Vector2(dimensions.x * 0.82, dimensions.y * 0.13))
    title.add_theme_color_override("font_color", INK_TEXT)
    title.add_theme_font_size_override("font_size", 10)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
