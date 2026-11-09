extends RefCounted

# D419 — ONE visual card system using the user's supplied front frame.
# All source texts, card IDs, effects, rewards, click handlers and art catalogs
# remain authoritative. Never paste composite card mockups over controls.
const FRONT := "res://assets/pixel/ui/card_ds3_locked/front_frame_d419.webp"
const FRONT_SOURCE := "res://assets/source_archive/card_frame_d419/approved_blank_frame.png"
const BACK := "res://assets/pixel/ui/card_ds3_locked/card_back.webp"
const INK := "res://assets/pixel/ui/card_ds3_locked/ink_substrate.webp"
const CARD_SHADER: Shader = preload("res://shaders/card_ds3_ink.gdshader")
const GOLD := Color("#e4b46c")
const INK_TEXT := Color("#251610")
const FACE_STONE := Color("#150d11")
const BONE := Color("#eddbbd")
const TABLE_SIZE := Vector2(272, 338)
# D419 uses the user's symmetrical blank frame. Runtime text remains live;
# its center now follows the frame's actual optical center.
const TABLE_COPY_CENTER_X := 136.0
const TABLE_TAB_CENTER_X := 136.0
# Preserve the accepted optical center of the 292 px reward card (D327).
const REWARD_COPY_CENTER_X := 158.0

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
    # Set size after IGNORE_SIZE so authored card dimensions remain exact.
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
# border and large compass. It remains a separate back; fronts use their
# exact approved D419 source and the shared stone is only a safety fallback.
static func _new_face_stone(host: Control, node_name: String, dimensions: Vector2) -> ColorRect:
    var stone := ColorRect.new()
    stone.name = node_name
    stone.color = FACE_STONE
    stone.position = Vector2.ZERO
    stone.size = dimensions
    stone.mouse_filter = Control.MOUSE_FILTER_IGNORE
    host.add_child(stone)
    return stone

# D419: the approved frame itself supplies a textured art well, so this
# transparent Control records the safe picture bounds without adding a second
# panel or outline. Original Art/Portrait nodes remain direct children.
static func _new_art_well(host: Control, node_name: String,
        at: Vector2, dimensions: Vector2) -> Panel:
    var well := Panel.new()
    well.name = node_name
    well.position = at
    well.size = dimensions
    well.mouse_filter = Control.MOUSE_FILTER_IGNORE
    # The new frame texture is the matte. This control only defines bounds.
    var style := StyleBoxFlat.new()
    style.bg_color = Color.TRANSPARENT
    style.draw_center = false
    style.set_border_width_all(0)
    well.add_theme_stylebox_override("panel", style)
    host.add_child(well)
    return well

static func _fit_art_in_well(art: TextureRect, at: Vector2, dimensions: Vector2) -> void:
    # Order matters: a live portrait may already have a large imported texture
    # when its smaller, frame-specific bounds are applied.
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    _at(art, at, dimensions)

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
    if frame == null:
        return false
    if button.has_node("DS3CardFrame"):
        return true
    button.custom_minimum_size = TABLE_SIZE
    button.size = TABLE_SIZE
    button.clip_contents = true
    _empty_button(button)
    var substrate := _new_face_stone(button, "DS3CardStone", TABLE_SIZE)
    button.move_child(substrate, 0)
    # The reference's painted top corners and compass remain clear. The
    # original landscape painting sits inside the open center of that frame.
    var frame_node := _new_art(button, "DS3CardFrame", frame, TABLE_SIZE)
    button.move_child(frame_node, 1)
    var art_well := _new_art_well(button, "DS3ArtWell",
        Vector2(22, 38), Vector2(228, 172))
    button.move_child(art_well, 2)
    var painting := button.get_node("Art") as TextureRect
    _fit_art_in_well(painting, Vector2(25, 41), Vector2(222, 166))
    grade(painting)
    button.move_child(painting, 3)

    var title := button.get_node("Title") as Label
    # D325: shared optical center x=136; do not offset title from prose.
    _at(title, Vector2(TABLE_COPY_CENTER_X - 114.0, 213), Vector2(228, 34))
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    title.add_theme_font_size_override("font_size", 14)
    # The supplied frame has a pale parchment title ribbon.
    title.add_theme_color_override("font_color", INK_TEXT)
    title.add_theme_color_override("font_outline_color", Color("#d9b683"))
    title.add_theme_constant_override("outline_size", 0)
    title.clip_text = true
    title.max_lines_visible = 2

    var category := button.get_node("Type") as Label
    # The new art has no category tab. Keep the authored type as a small
    # gold live label beneath the top compass, over the dark upper scene.
    _at(category, Vector2(TABLE_TAB_CENTER_X - 51.0, 25), Vector2(102, 16))
    category.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    category.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    category.add_theme_font_size_override("font_size", 8)
    category.add_theme_color_override("font_color", GOLD)
    category.clip_text = true

    var body := button.get_node("Description") as Label
    # D326: keep the live two-offer description at the same physical center.
    # It must not retain offsets/anchors from the old DS2 layout.
    body.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
    body.custom_minimum_size = Vector2.ZERO
    _at(body, Vector2(TABLE_COPY_CENTER_X - 108.0, 252), Vector2(216, 34))
    body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body.add_theme_font_size_override("font_size", 10)
    body.add_theme_color_override("font_color", BONE)
    body.clip_text = true
    body.max_lines_visible = 2

    var hint := button.get_node("Hint") as Label
    _at(hint, Vector2(TABLE_COPY_CENTER_X - 104.0, 288), Vector2(208, 14))
    hint.add_theme_font_size_override("font_size", 9)
    hint.add_theme_color_override("font_color", GOLD)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    hint.clip_text = true
    var mark := button.get_node("Mark") as Label
    _at(mark, Vector2(42, 52), Vector2(188, 20))
    mark.add_theme_color_override("font_color", Color("#ffb37e"))
    mark.add_theme_font_size_override("font_size", 11)

    var roman := Label.new()
    roman.name = "DS3Roman"
    # Distinct from the category tab; keeps authentic Fate I-XIII legible.
    roman.position = Vector2(10, 15)
    roman.size = Vector2(30, 19)
    roman.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    roman.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    roman.add_theme_color_override("font_color", GOLD)
    roman.add_theme_font_size_override("font_size", 12)
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
    if frame == null:
        return false
    if button.has_node("DS3CardFrame"):
        return true
    _empty_button(button)
    button.custom_minimum_size = Vector2(292, 456)
    button.focus_mode = Control.FOCUS_ALL
    button.clip_contents = true
    var bottom := _new_face_stone(button, "DS3CardStone", Vector2(292, 456))
    button.move_child(bottom, 0)
    var face := _new_art(button, "DS3CardFrame", frame, Vector2(292, 410))
    button.move_child(face, 1)
    var art_well := _new_art_well(button, "DS3ArtWell",
        Vector2(23, 47), Vector2(246, 210))
    button.move_child(art_well, 2)
    _fit_art_in_well(portrait, Vector2(27, 51), Vector2(238, 202))
    grade(portrait)
    button.move_child(portrait, 3)
    _at(role, Vector2(REWARD_COPY_CENTER_X - 108.0, 42), Vector2(216, 20))
    role.add_theme_color_override("font_color", GOLD)
    role.add_theme_font_size_override("font_size", 12)
    role.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    # D419: the 292x410 source uses a parchment title banner and a dark prose
    # well; headings use ink color while modifiers/copy use light text.
    _at(heading, Vector2(REWARD_COPY_CENTER_X - 108.0, 252), Vector2(216, 34))
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    heading.add_theme_color_override("font_color", INK_TEXT)
    heading.add_theme_color_override("font_outline_color", Color("#10090d"))
    heading.add_theme_constant_override("outline_size", 1)
    heading.add_theme_font_size_override("font_size", 15)
    heading.clip_text = true
    heading.max_lines_visible = 2
    _at(effect, Vector2(REWARD_COPY_CENTER_X - 110.0, 301), Vector2(220, 28))
    effect.add_theme_color_override("font_color", BONE)
    effect.add_theme_font_size_override("font_size", 10)
    effect.add_theme_constant_override("line_spacing", 0)
    effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    effect.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    effect.clip_text = true
    effect.max_lines_visible = 2
    _at(description, Vector2(REWARD_COPY_CENTER_X - 111.0, 330), Vector2(222, 40))
    description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description.add_theme_color_override("font_color", BONE)
    description.add_theme_font_size_override("font_size", 10)
    description.clip_text = true
    description.max_lines_visible = 4
    return true


static func style_reward_copy(button: Button, role: Label, heading: Label,
        effect: Label, description: Label) -> void:
    if not button.has_node("DS3CardFrame"):
        return
    role.add_theme_color_override("font_color", GOLD)
    heading.add_theme_color_override("font_color", INK_TEXT)
    effect.add_theme_color_override("font_color", BONE)
    effect.add_theme_constant_override("line_spacing", 0)
    description.add_theme_color_override("font_color", BONE)
    # Live changes to reward modes must not reintroduce the old dark title
    # or squash descriptions into the bottom 40 px of the frame.
    for label in [role, heading, effect, description]:
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _at(role, Vector2(REWARD_COPY_CENTER_X - 108.0, 42), Vector2(216, 20))
    _at(heading, Vector2(REWARD_COPY_CENTER_X - 108.0, 252), Vector2(216, 34))
    _at(effect, Vector2(REWARD_COPY_CENTER_X - 110.0, 301), Vector2(220, 28))
    _at(description, Vector2(REWARD_COPY_CENTER_X - 111.0, 330), Vector2(222, 40))


# D316: physical DS3 card inside the already existing non-destructive
# full-text inspection panel. This is a true card illustration, not a separate
# menu control; detailed lore stays in its original scrollable right column.
static func apply_inspection(host: Control, illustration: TextureRect) -> bool:
    var frame := _texture(FRONT)
    if frame == null:
        return false
    if host.has_node("DS3InspectFrame"):
        return true
    const CARD_AT := Vector2(38, 51)
    const CARD_EXTENT := Vector2(225, 306)
    var stone := _new_face_stone(host, "DS3InspectStone", CARD_EXTENT)
    stone.position = CARD_AT
    host.move_child(stone, illustration.get_index())
    var gilt := _new_art(host, "DS3InspectFrame", frame, CARD_EXTENT)
    gilt.position = CARD_AT
    host.move_child(gilt, illustration.get_index())
    var art_well := _new_art_well(host, "DS3InspectArtWell",
        CARD_AT + Vector2(17, 37), Vector2(191, 155))
    host.move_child(art_well, illustration.get_index())
    _fit_art_in_well(illustration, CARD_AT + Vector2(21, 40), Vector2(183, 147))
    grade(illustration)
    var plate_title := Label.new()
    plate_title.name = "DS3InspectCardTitle"
    plate_title.position = CARD_AT + Vector2(31, 191)
    plate_title.size = Vector2(163, 28)
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
    reading_mark.position = CARD_AT + Vector2(29, 252)
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
    if frame == null or panel.has_node("DS3CardFrame"):
        return
    var bg := _new_face_stone(panel, "DS3CardStone", dimensions)
    panel.move_child(bg, 0)
    var face := _new_art(panel, "DS3CardFrame", frame, dimensions)
    panel.move_child(face, 1)
    var artwork_height := dimensions.y * 0.48
    var art_pos := Vector2(dimensions.x * 0.08, dimensions.y * 0.13)
    var art_size := Vector2(dimensions.x * 0.84, artwork_height)
    var rim := maxf(1.0, dimensions.x * 0.013)
    var art_well := _new_art_well(panel, "DS3ArtWell",
        art_pos - Vector2.ONE * rim, art_size + Vector2.ONE * (rim * 2.0))
    panel.move_child(art_well, 2)
    _fit_art_in_well(art, art_pos, art_size)
    grade(art)
    panel.move_child(art, 3)
    title_plate.modulate.a = 0.0
    if dimensions.x < 110:
        # 100px physical fate cards have room for ONE line of ink on the
        # parchment banner (approximately y=0.62..0.73). The older two-line
        # label at y=0.72 spilled into the nearly black ornamental footer.
        # Full event names remain readable in the existing hover history.
        _at(title, Vector2(dimensions.x * 0.12, dimensions.y * 0.62),
            Vector2(dimensions.x * 0.76, dimensions.y * 0.12))
        title.autowrap_mode = TextServer.AUTOWRAP_OFF
        title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
        title.clip_text = true
    else:
        # XIII keeps its explicit two-line title and larger plaque.
        _at(title, Vector2(dimensions.x * 0.12, dimensions.y * 0.63),
            Vector2(dimensions.x * 0.76, dimensions.y * 0.14))
    title.add_theme_color_override("font_color", INK_TEXT)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 8 if dimensions.x < 110 else 11)
    # Fate Roman tabs deliberately protrude above the original slot bounds.
    panel.clip_contents = false

static func apply_sidebar_card(host: Control, art: TextureRect,
        title_plate: ColorRect, title: Label, at: Vector2, dimensions: Vector2) -> void:
    var frame := _texture(FRONT)
    if frame == null or host.has_node("DS3SidebarFrame"):
        return
    var bg := _new_face_stone(host, "DS3SidebarStone", dimensions)
    bg.position = at
    host.move_child(bg, art.get_index())
    var frame_node := _new_art(host, "DS3SidebarFrame", frame, dimensions)
    frame_node.position = at
    host.move_child(frame_node, art.get_index())
    var art_pos := at + Vector2(dimensions.x * 0.08, dimensions.y * 0.13)
    var art_size := Vector2(dimensions.x * 0.84, dimensions.y * 0.48)
    var rim := maxf(1.0, dimensions.x * 0.013)
    var art_well := _new_art_well(host, "DS3SidebarArtWell",
        art_pos - Vector2.ONE * rim, art_size + Vector2.ONE * (rim * 2.0))
    host.move_child(art_well, art.get_index())
    _fit_art_in_well(art, art_pos, art_size)
    grade(art)
    title_plate.modulate.a = 0.0
    _at(title, at + Vector2(dimensions.x * 0.12, dimensions.y * 0.63),
        Vector2(dimensions.x * 0.76, dimensions.y * 0.14))
    title.add_theme_color_override("font_color", INK_TEXT)
    title.add_theme_font_size_override("font_size", 10)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
