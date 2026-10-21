extends Control

# D318: non-gameplay, F6-only visual QA of all independent card illustrations.
# Never mutate original RunCardData text, IDs, Fate ordinals or run state.
const CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const SKIN := preload("res://scripts/ui/card_ds3_skin.gd")
const CARD_DIR := "res://resources/cards/"
const PREVIEW_LIMIT := 56

var gallery_grid: GridContainer
var details_label: Label
var card_count := 0
var missing_art: Array[String] = []
var detail_overlay: Control
var detail_title: Label
var detail_category: Label
var detail_art: TextureRect
var detail_copy: RichTextLabel

func _ready() -> void:
    var background := ColorRect.new()
    background.color = Color("#0a0609")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(background)

    var heading := Label.new()
    heading.name = "GalleryHeading"
    heading.text = "MISDEAL — ПОЛНАЯ ГАЛЕРЕЯ КАРТ • DS3"
    heading.position = Vector2(30, 11)
    heading.size = Vector2(1150, 34)
    heading.add_theme_color_override("font_color", SKIN.GOLD)
    heading.add_theme_font_size_override("font_size", 25)
    add_child(heading)

    details_label = Label.new()
    details_label.name = "GalleryInfo"
    details_label.position = Vector2(30, 49)
    details_label.size = Vector2(1215, 38)
    details_label.add_theme_font_size_override("font_size", 13)
    details_label.add_theme_color_override("font_color", SKIN.BONE)
    details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    details_label.clip_text = true
    add_child(details_label)

    var scroll := ScrollContainer.new()
    scroll.name = "CardScroll"
    scroll.position = Vector2(31, 94)
    scroll.size = Vector2(1220, 608)
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    add_child(scroll)

    gallery_grid = GridContainer.new()
    gallery_grid.name = "CardGrid"
    gallery_grid.columns = 4
    gallery_grid.add_theme_constant_override("h_separation", 20)
    gallery_grid.add_theme_constant_override("v_separation", 18)
    scroll.add_child(gallery_grid)
    _populate()
    _make_detail_reader()

func _populate() -> void:
    var files := DirAccess.get_files_at(CARD_DIR)
    files.sort()
    for filename in files:
        if not filename.ends_with(".tres"):
            continue
        var resource := load(CARD_DIR + filename) as Resource
        if resource == null:
            continue
        var card_id := String(resource.get("card_id"))
        if card_id.is_empty():
            continue
        var title := String(resource.get("title"))
        var type_name := String(resource.get("type_label"))
        var full_text := String(resource.get("card_text"))
        var tex := CATALOG.get_run_card_texture(card_id)
        if tex == null:
            missing_art.append(card_id)
        _card_widget(title, type_name, full_text, tex, card_id)
        card_count += 1

    for upgrade_key in CATALOG.UPGRADE_INDEX.keys():
        var key := String(upgrade_key)
        _card_widget(key.replace("_", " ").to_upper(), "УЛУЧШЕНИЕ",
            "Точный эффект показан в настоящей награде.",
            CATALOG.get_upgrade_texture(key), key)
    for reward_key in CATALOG.REWARD_INDEX.keys():
        var key := String(reward_key)
        _card_widget(key.replace("_", " ").to_upper(), "НАГРАДА",
            "Точный эффект показан в настоящей награде.",
            CATALOG.get_reward_texture(key), key)
    details_label.text = "Исходные карты: %d · Прочие иллюстрации: %d · Без арта: %d · Нажмите карту, чтобы прочитать полный текст" % [
        card_count, CATALOG.UPGRADE_INDEX.size() + CATALOG.REWARD_INDEX.size(), missing_art.size()
    ]
    if not missing_art.is_empty():
        push_warning("D318 card art catalogue gaps: " + ", ".join(missing_art))

static func _short_copy(full_text: String) -> String:
    var text_value := full_text.replace("\r", " ").replace("\n", " ").strip_edges()
    while text_value.contains("  "):
        text_value = text_value.replace("  ", " ")
    if text_value.length() <= PREVIEW_LIMIT:
        return text_value
    var excerpt := text_value.substr(0, PREVIEW_LIMIT)
    var word_end := excerpt.rfind(" ")
    if word_end >= 35:
        excerpt = excerpt.substr(0, word_end)
    return excerpt.strip_edges() + "…"

func _card_widget(title: String, type_name: String, full_text: String,
        art: Texture2D, card_id: String) -> void:
    var button := Button.new()
    button.name = "Card_" + card_id
    button.custom_minimum_size = SKIN.TABLE_SIZE
    for node_name in ["Art", "Title", "Type", "Description", "Hint", "Mark"]:
        var node: Control = TextureRect.new() if node_name == "Art" else Label.new()
        node.name = node_name
        node.mouse_filter = Control.MOUSE_FILTER_IGNORE
        button.add_child(node)
    gallery_grid.add_child(button)
    if not SKIN.apply_table(button):
        return
    (button.get_node("Art") as TextureRect).texture = art

    # The original frame already has an empty black category tab at top right.
    # Never let category prose float across the painted encounter scene.
    var category := button.get_node("Type") as Label
    category.position = Vector2(174, 16)
    category.size = Vector2(78, 20)
    category.add_theme_font_size_override("font_size", 9)
    category.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    # Category is intentionally centered in its TOP-RIGHT TAB, not card body.
    category.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    category.text = type_name

    var heading := button.get_node("Title") as Label
    # D325: all front-facing gallery copy shares the 136px card center.
    heading.position = Vector2(43, 231)
    heading.size = Vector2(186, 30)
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    heading.add_theme_font_size_override("font_size", 12 if title.length() > 22 else 14)
    heading.max_lines_visible = 2
    heading.text = title

    # Label.clip_text clips horizontally but DOES NOT constrain multiline
    # vertical drawing. This explicit nested clipping well does both.
    var well := Control.new()
    well.name = "CardTextClip"
    well.position = Vector2(43, 264)
    well.size = Vector2(186, 36)
    well.clip_contents = true
    well.mouse_filter = Control.MOUSE_FILTER_IGNORE
    button.add_child(well)
    var body := button.get_node("Description") as Label
    body.reparent(well)
    body.position = Vector2.ZERO
    body.size = well.size
    body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    body.add_theme_font_size_override("font_size", 10)
    body.max_lines_visible = 2
    body.text = _short_copy(full_text)

    var hint := button.get_node("Hint") as Label
    hint.position = Vector2(43, 305)
    hint.size = Vector2(186, 21)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    hint.text = "ЧИТАТЬ КАРТУ"
    (button.get_node("Mark") as Label).hide()
    # Alphabetical catalogue order is NOT the 12-step Fate order.
    # Real Fate/held/discard numbering is owned by live gameplay.
    (button.get_node("DS3Roman") as Label).hide()
    # D319: Godot native tooltip floated across other cards in the real F6 screenshot.
    # The in-card Hint and explicit click-to-read modal already explain the action.
    button.tooltip_text = ""
    button.pressed.connect(_show_full_copy.bind(title, type_name, full_text, art))

func _label(parent: Control, node_name: String, pos: Vector2, extent: Vector2,
        font_size: int, tint: Color) -> Label:
    var label := Label.new()
    label.name = node_name
    label.position = pos
    label.size = extent
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.clip_text = true
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", tint)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(label)
    return label

func _make_detail_reader() -> void:
    detail_overlay = Control.new()
    detail_overlay.name = "DS3FullTextOverlay"
    detail_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    detail_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    detail_overlay.visible = false
    add_child(detail_overlay)

    var shade := ColorRect.new()
    shade.name = "DimmingBackdrop"
    shade.color = Color(0.025, 0.012, 0.018, 0.95)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.mouse_filter = Control.MOUSE_FILTER_STOP
    detail_overlay.add_child(shade)

    var board := Panel.new()
    board.name = "ReaderBoard"
    board.position = Vector2(105, 70)
    board.size = Vector2(1070, 580)
    board.mouse_filter = Control.MOUSE_FILTER_STOP
    var metal := StyleBoxFlat.new()
    metal.bg_color = Color("#180e12")
    metal.border_color = Color("#a67844")
    metal.set_border_width_all(2)
    metal.set_corner_radius_all(9)
    metal.content_margin_left = 14
    metal.content_margin_right = 14
    board.add_theme_stylebox_override("panel", metal)
    detail_overlay.add_child(board)

    var caption := _label(board, "ReaderEyebrow", Vector2(38, 19),
        Vector2(900, 29), 16, SKIN.GOLD)
    caption.text = "MISDEAL   /   АРХИВ КАРТ   /   DS3"

    detail_art = TextureRect.new()
    detail_art.name = "ReaderArt"
    detail_art.position = Vector2(38, 105)
    detail_art.size = Vector2(348, 315)
    detail_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    detail_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    detail_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
    board.add_child(detail_art)
    SKIN.grade(detail_art)

    detail_category = _label(board, "ReaderType", Vector2(422, 73),
        Vector2(560, 25), 14, SKIN.GOLD)
    detail_title = _label(board, "ReaderTitle", Vector2(420, 110),
        Vector2(600, 63), 26, SKIN.BONE)
    detail_title.max_lines_visible = 2

    detail_copy = RichTextLabel.new()
    detail_copy.name = "ReaderFullCopy"
    detail_copy.position = Vector2(421, 185)
    detail_copy.size = Vector2(600, 303)
    detail_copy.bbcode_enabled = false
    detail_copy.scroll_active = true
    detail_copy.fit_content = false
    detail_copy.selection_enabled = true
    detail_copy.add_theme_font_size_override("normal_font_size", 17)
    detail_copy.add_theme_color_override("default_color", SKIN.BONE)
    board.add_child(detail_copy)

    var footnote := _label(board, "ReaderFootnote", Vector2(42, 461),
        Vector2(352, 62), 13, Color("#c6a87f"))
    footnote.text = "Авторский текст без сокращений.\nПрокрутка справа • ESC — закрыть"

    var close := Button.new()
    close.name = "ReaderClose"
    close.text = "ЗАКРЫТЬ  ×"
    close.position = Vector2(845, 525)
    close.size = Vector2(176, 39)
    close.add_theme_font_size_override("font_size", 15)
    close.add_theme_color_override("font_color", SKIN.GOLD)
    close.pressed.connect(_close_reader)
    board.add_child(close)

func _show_full_copy(title: String, category: String, description: String,
        art: Texture2D) -> void:
    detail_title.text = title
    detail_category.text = category
    detail_copy.text = description
    detail_art.texture = art
    detail_overlay.show()
    detail_copy.scroll_to_line.call_deferred(0)

func _close_reader() -> void:
    detail_overlay.hide()

func _input(event: InputEvent) -> void:
    if detail_overlay == null or not detail_overlay.visible:
        return
    var key := event as InputEventKey
    if key != null and key.pressed and not key.echo and key.keycode == KEY_ESCAPE:
        _close_reader()
        get_viewport().set_input_as_handled()
