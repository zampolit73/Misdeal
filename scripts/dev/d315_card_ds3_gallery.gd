extends Control

# D315 - standalone F6 gallery of EVERY current RunCardData resource.
# This is an inspection surface; it NEVER deals cards or alters RunState.
const CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const SKIN := preload("res://scripts/ui/card_ds3_skin.gd")
const CARD_DIR := "res://resources/cards/"

var gallery_grid: GridContainer
var details_label: Label
var card_count := 0
var missing_art: Array[String] = []

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
        _card_widget(title, type_name, full_text, tex, card_count + 1, card_id)
        card_count += 1

    # Hero development and prize cards share the very same material system.
    for upgrade_key in CATALOG.UPGRADE_INDEX.keys():
        var key := String(upgrade_key)
        _card_widget(key.replace("_", " ").to_upper(), "УЛУЧШЕНИЕ",
            "Точный эффект показан в настоящей награде.", CATALOG.get_upgrade_texture(key),
            0, key)
    for reward_key in CATALOG.REWARD_INDEX.keys():
        var key := String(reward_key)
        _card_widget(key.replace("_", " ").to_upper(), "НАГРАДА",
            "Точный эффект показан в настоящей награде.", CATALOG.get_reward_texture(key),
            0, key)
    details_label.text = "Исходные карты: %d · Прочие иллюстрации: %d · Без арта: %d · Прокрутка вниз, нажатие для полного текста" % [
        card_count, CATALOG.UPGRADE_INDEX.size() + CATALOG.REWARD_INDEX.size(), missing_art.size()
    ]
    if not missing_art.is_empty():
        push_warning("D315 card illustration catalogue gaps: " + ", ".join(missing_art))

func _card_widget(title: String, type_name: String, description: String,
        art: Texture2D, sequence: int, card_id: String) -> void:
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
    var pic := button.get_node("Art") as TextureRect
    pic.texture = art
    (button.get_node("Title") as Label).text = title
    (button.get_node("Type") as Label).text = type_name
    (button.get_node("Description") as Label).text = description
    (button.get_node("Hint") as Label).text = "ОТКРЫТЬ ОПИСАНИЕ"
    (button.get_node("Mark") as Label).visible = false
    if sequence > 0:
        SKIN.update_table_roman(button, (sequence - 1) % 12 + 1)
    else:
        (button.get_node("DS3Roman") as Label).text = "✦"
    button.tooltip_text = title + "\n" + description
    button.pressed.connect(_show_full_copy.bind(title, description))

func _show_full_copy(title: String, description: String) -> void:
    details_label.text = title + "  —  " + description.replace("\n", " ")
