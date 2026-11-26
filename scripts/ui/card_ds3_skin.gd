extends RefCounted

# D315 — ONE visual card system, authored from the user-approved card sheet.
# All source texts, card IDs, effects, rewards, click handlers and art catalogs
# remain authoritative. Never paste composite card mockups over controls.
const UNIFIED := preload("res://scripts/ui/unified_card_skin.gd")
const FRONT := "res://assets/pixel/ui/card_ds3_locked/front_frame.webp"
const BACK := "res://assets/pixel/ui/card_ds3_locked/card_back.webp"
const INK := "res://assets/pixel/ui/card_ds3_locked/ink_substrate.webp"
const CARD_SHADER: Shader = preload("res://shaders/card_ds3_ink.gdshader")
const GOLD := Color("#e4b46c")
const INK_TEXT := Color("#251610")
const FACE_STONE := Color("#150d11")
const BONE := Color("#eddbbd")
const TABLE_SIZE := Vector2(272, 338)
# Printed paper is symmetric; live title and body share the physical center.
const TABLE_COPY_CENTER_X := 136.0
const TABLE_TAB_CENTER_X := 136.0
const REWARD_COPY_CENTER_X := 146.0

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
    # D323: assigning the texture FIRST activates its intrinsic 375x509
    # minimum size. Setting size before IGNORE_SIZE clamps the frame to that
    # native size, and the 272x338 Button clips its right/bottom edges.
    layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    layer.stretch_mode = TextureRect.STRETCH_SCALE
    layer.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    layer.texture = texture
    host.add_child(layer)
    layer.position = Vector2.ZERO
    layer.size = dimensions
    return layer

# D320: the old INK bitmap is a complete card back with its OWN gilt
# border and large compass. Under FRONT it created TWO frames and ghost
# ornament in every face. Front cards use borderless stone; backs unchanged.
static func _new_face_stone(host: Control, node_name: String, dimensions: Vector2) -> ColorRect:
    var stone := ColorRect.new()
    stone.name = node_name
    stone.color = FACE_STONE
    stone.position = Vector2.ZERO
    stone.size = dimensions
    stone.mouse_filter = Control.MOUSE_FILTER_IGNORE
    host.add_child(stone)
    return stone

# D322: a restrained recessed mount, never a second OUTER card frame.
# Original Art/Portrait nodes remain direct children for all live game updates.
static func _new_art_well(host: Control, node_name: String,
        at: Vector2, dimensions: Vector2) -> Panel:
    var well := Panel.new()
    well.name = node_name
    well.position = at
    well.size = dimensions
    well.mouse_filter = Control.MOUSE_FILTER_IGNORE
    # D324: native QA showed the visible 1px rectangle floating around
    # letterboxed landscape art. That is NOT the approved frame.
    # A seamless mount shares the stone color and has NO second outline.
    var style := StyleBoxFlat.new()
    style.bg_color = FACE_STONE
    style.draw_center = true
    style.set_border_width_all(0)
    well.add_theme_stylebox_override("panel", style)
    host.add_child(well)
    return well

static func _fit_art_in_well(art: TextureRect, at: Vector2, dimensions: Vector2) -> void:
    # Order matters here too: live Table Art may already hold a 448x274
    # texture when we apply its 211x188 authored inner rectangle.
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    _at(art, at, dimensions)

static func _at(control: Control, at: Vector2, dimensions: Vector2) -> void:
    control.position = at
    control.size = dimensions
    control.mouse_filter = Control.MOUSE_FILTER_IGNORE

static func grade(art: TextureRect) -> void:
    art.material = null
    art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR

static func apply_table(button: Button) -> bool:
    if button.has_node("DS3CardFrame"):
        return true
    button.custom_minimum_size = TABLE_SIZE
    button.size = TABLE_SIZE
    button.clip_contents = true
    _empty_button(button)
    var substrate := _new_face_stone(button, "DS3CardStone", TABLE_SIZE)
    button.move_child(substrate, 0)
    var window := UNIFIED.art_rect(TABLE_SIZE, 0.53)
    var well := _new_art_well(button, "DS3ArtWell", window.position, window.size)
    var frame := UNIFIED.mount(button, Rect2(Vector2.ZERO, TABLE_SIZE), 0.53, "DS3CardFrame")
    button.move_child(substrate, 0)
    button.move_child(well, 2)
    var art := button.get_node("Art") as TextureRect
    UNIFIED.fit_art(art, window)
    button.move_child(art, 3)
    var title := button.get_node("Title") as Label
    UNIFIED.style_label(title, Rect2(13, 181, 246, 38), 17, UNIFIED.INK, true)
    title.max_lines_visible = 2
    var category := button.get_node("Type") as Label
    UNIFIED.style_label(category, Rect2(67, 7, 138, 27), 13, UNIFIED.INK, true, false)
    var body := button.get_node("Description") as Label
    UNIFIED.style_label(body, Rect2(17, 219, 238, 62), 13, UNIFIED.INK)
    body.max_lines_visible = 3
    var hint := button.get_node("Hint") as Label
    var action := UNIFIED.action(button, Rect2(27, 286, 218, 39), "", 15)
    UNIFIED.style_label(hint, Rect2(29, 287, 214, 37), 15, UNIFIED.INK, true, false)
    button.move_child(hint, -1)
    var mark := button.get_node("Mark") as Label
    UNIFIED.style_label(mark, Rect2(12, 37, 248, 23), 11, Color("#ffd0a1"), true)
    var roman := UNIFIED.label(button, "DS3Roman", "", Rect2(25, 7, 40, 27), 12, UNIFIED.INK)
    UNIFIED.bind_action(button, frame, action)
    return true

static func update_table_roman(button: Button, number: int) -> void:
    var mark := button.get_node_or_null("DS3Roman") as Label
    if mark == null:
        return
    const ROMAN := ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII"]
    mark.text = ROMAN[clampi(number - 1, 0, 12)]

static func apply_table_backs(scene: Control) -> void:
    var back := UNIFIED.CARD_BACK
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
    if button.has_node("DS3CardFrame"):
        return true
    _empty_button(button)
    var extent := Vector2(292, 456)
    button.custom_minimum_size = extent
    button.focus_mode = Control.FOCUS_ALL
    button.clip_contents = true
    var frame := UNIFIED.mount(button, Rect2(Vector2.ZERO, extent), 0.45, "DS3CardFrame")
    var bottom := _new_face_stone(button, "DS3CardStone", extent)
    button.move_child(bottom, 0)
    var window := UNIFIED.art_rect(extent)
    var well := _new_art_well(button, "DS3ArtWell", window.position, window.size)
    button.move_child(well, 2)
    UNIFIED.fit_art(portrait, window, false)
    button.move_child(portrait, 3)
    style_reward_copy(button, role, heading, effect, description)
    return true

static func style_reward_copy(button: Button, role: Label, heading: Label,
        effect: Label, description: Label) -> void:
    if not button.has_node("DS3CardFrame"):
        return
    UNIFIED.style_label(role, Rect2(20, 7, 252, 34), 14, UNIFIED.INK, true)
    UNIFIED.style_label(heading, Rect2(16, 209, 260, 44), 19, UNIFIED.INK, true)
    UNIFIED.style_label(effect, Rect2(20, 254, 252, 58), 16, UNIFIED.INK)
    UNIFIED.style_label(description, Rect2(18, 314, 256, 83), 14, UNIFIED.INK)
    heading.max_lines_visible = 2
    effect.max_lines_visible = 2
    description.max_lines_visible = 4

static func apply_inspection(host: Control, illustration: TextureRect) -> bool:
    if host.has_node("DS3InspectFrame"):
        return true
    const AT := Vector2(76, 45)
    const EXTENT := Vector2(250, 340)
    var stone := _new_face_stone(host, "DS3InspectStone", EXTENT)
    stone.position = AT
    host.move_child(stone, illustration.get_index())
    var frame := UNIFIED.mount(host, Rect2(AT, EXTENT), 0.64, "DS3InspectFrame")
    host.move_child(frame, illustration.get_index() - 1)
    var window := UNIFIED.art_rect(EXTENT, 0.64)
    window.position += AT
    var well := _new_art_well(host, "DS3InspectArtWell", window.position, window.size)
    host.move_child(well, illustration.get_index())
    UNIFIED.fit_art(illustration, window)
    UNIFIED.label(host, "DS3InspectCardType", "", Rect2(AT + Vector2(15, 8), Vector2(220, 23)), 12, UNIFIED.INK, true)
    var title := UNIFIED.label(host, "DS3InspectCardTitle", "", Rect2(AT + Vector2(17, 221), Vector2(216, 62)), 20, UNIFIED.INK, true)
    title.max_lines_visible = 3
    UNIFIED.label(host, "DS3InspectCardHint", "ИЗ КНИГИ СУДЬБЫ", Rect2(AT + Vector2(14, 290), Vector2(222, 30)), 14, UNIFIED.MUTED)
    return true

static func apply_spread_slot(panel: Panel, art: TextureRect, title_plate: ColorRect,
        title: Label, dimensions: Vector2) -> void:
    if panel.has_node("DS3CardFrame"):
        return
    _mini(panel, art, title_plate, title, Vector2.ZERO, dimensions, "DS3Card")
    panel.clip_contents = false

static func apply_sidebar_card(host: Control, art: TextureRect,
        title_plate: ColorRect, title: Label, at: Vector2, dimensions: Vector2) -> void:
    if host.has_node("DS3SidebarFrame"):
        return
    _mini(host, art, title_plate, title, at, dimensions, "DS3Sidebar")

static func _mini(host: Control, art: TextureRect, title_plate: ColorRect, title: Label,
        at: Vector2, dimensions: Vector2, prefix: String) -> void:
    var bg := _new_face_stone(host, prefix + "Stone", dimensions)
    bg.position = at
    host.move_child(bg, art.get_index())
    var frame := UNIFIED.mount(host, Rect2(at, dimensions), UNIFIED.MINI_SPLIT, prefix + "Frame")
    host.move_child(frame, art.get_index() - 1)
    var window := UNIFIED.art_rect(dimensions, UNIFIED.MINI_SPLIT, false)
    window.position += at
    var well_name := "DS3ArtWell" if prefix == "DS3Card" else "DS3SidebarArtWell"
    var well := _new_art_well(host, well_name, window.position, window.size)
    host.move_child(well, art.get_index())
    UNIFIED.fit_art(art, window)
    title_plate.modulate.a = 0.0
    UNIFIED.style_label(title, Rect2(at + Vector2(dimensions.x * 0.06, dimensions.y * 0.73),
        Vector2(dimensions.x * 0.88, dimensions.y * 0.23)), 10 if dimensions.x < 110 else 12, UNIFIED.INK, true, true)
    title.max_lines_visible = 2
    title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS

static func set_mini_revealed(host: Control, revealed: bool, sidebar: bool = false) -> void:
    var frame := host.get_node_or_null("DS3SidebarFrame" if sidebar else "DS3CardFrame") as TextureRect
    if frame != null:
        frame.texture = UNIFIED.face(UNIFIED.MINI_SPLIT, not revealed)
    var well := host.get_node_or_null("DS3SidebarArtWell" if sidebar else "DS3ArtWell") as Panel
    if well != null:
        well.visible = revealed
