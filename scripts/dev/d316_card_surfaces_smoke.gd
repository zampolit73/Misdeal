extends SceneTree

# D316: native check of the *actual* right-click card reader and I-XIII
# Fate Spread. D315 already tests the full card gallery and Reward options.
const SKIN := preload("res://scripts/ui/card_ds3_skin.gd")
const CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const INSPECT := "res://scenes/table/card_lore_inspect.tscn"
const SPREAD := "res://scenes/table/fate_spread_overlay.tscn"


func _initialize() -> void:
    call_deferred("_verify")


func _verify() -> void:
    var state := root.get_node_or_null("RunState")
    if state == null:
        state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
        state.name = "RunState"
        root.add_child(state)
    state.call("reset_run")
    if not state.call("choose_protagonist", "knight"):
        _fail("could not initialize test run")
        return

    var reader := (load(INSPECT) as PackedScene).instantiate() as Control
    root.add_child(reader)
    await process_frame
    var source_art := CATALOG.get_run_card_texture("grave_bell")
    if source_art == null:
        _fail("the actual Grave Bell illustration is not available")
        return
    reader.call("present", "МОГИЛЬНЫЙ ЗВОН", "БОЙ",
        "Звонарь исцеляет нежить. Проверка полного описания карты.", source_art)
    var card_frame := reader.get_node_or_null("Frame/DS3InspectFrame") as TextureRect
    var card_art := reader.get_node_or_null("Frame/LoreArt") as TextureRect
    var physical_title := reader.get_node_or_null("Frame/DS3InspectCardTitle") as Label
    var detailed_copy := reader.get_node_or_null("Frame/FullDescription") as RichTextLabel
    var close_button := reader.get_node_or_null("Frame/CloseButton") as Button
    if card_frame == null or card_frame.texture == null or card_frame.mouse_filter != Control.MOUSE_FILTER_IGNORE:
        _fail("inspector lacks the real DS3 frame or blocks input")
        return
    var inspect_well := reader.get_node_or_null("Frame/DS3InspectArtWell") as Panel
    if inspect_well == null or card_art == null or inspect_well.get_index() >= card_art.get_index():
        _fail("D322 full-card inspector has no recessed art well")
        return
    if card_art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
        _fail("D322 full-card inspector crops the source illustration")
        return
    if not (reader.get_node_or_null("Frame/DS3InspectStone") is ColorRect):
        _fail("inspector still double-stacks back border under front frame")
        return
    if card_frame.size != Vector2(225, 306) or card_art == null or card_art.material == null:
        _fail("full-card inspector dimensions/DS3 grade are incorrect")
        return
    if physical_title == null or physical_title.text != "МОГИЛЬНЫЙ ЗВОН":
        _fail("inspector's real title is not printed inside the painted card")
        return
    if detailed_copy == null or not detailed_copy.text.contains("Звонарь исцеляет нежить"):
        _fail("original scrollable long description disappeared")
        return
    if close_button == null or close_button.pressed.get_connections().is_empty():
        _fail("original card inspector close action was disconnected")
        return
    reader.call("close")
    await process_frame

    var spread := (load(SPREAD) as PackedScene).instantiate() as Control
    root.add_child(spread)
    await process_frame
    for number in range(1, 13):
        var slot := spread.get_node_or_null("Frame/SpreadArea/FateSlot%02d" % number) as Panel
        if slot == null or not slot.has_node("DS3CardFrame"):
            _fail("Fate Spread slot %d has no physical DS3 frame" % number)
            return
        var art := slot.get_node_or_null("Art") as TextureRect
        var art_well := slot.get_node_or_null("DS3ArtWell") as Panel
        if art_well == null or art == null or art_well.get_index() >= art.get_index():
            _fail("D322 Fate slot %d lacks inset art well" % number)
            return
        if art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
            _fail("D322 Fate slot %d still crops the scene" % number)
            return
        if not (slot.get_node_or_null("DS3CardStone") is ColorRect):
            _fail("Spread slot %d still has the duplicate back border" % number)
            return
        if (slot.get_node("DS3CardFrame") as TextureRect).mouse_filter != Control.MOUSE_FILTER_IGNORE:
            _fail("DS3 ornament blocks I-XII slot hover")
            return
    for path in [
        "Frame/SpreadArea/BossSlot/DS3CardFrame",
        "Frame/HeldPanel/DS3SidebarFrame",
        "Frame/DiscardPanel/CardLayer/DS3SidebarFrame"
    ]:
        if spread.get_node_or_null(path) == null:
            _fail("DS3 spread boss/held/discard visual missing at " + path)
            return
    if not (spread.get_node_or_null("Frame/HeldPanel/DS3SidebarArtWell") is Panel):
        _fail("D322 held Fate card lacks illustration inset")
        return
    if not (spread.get_node_or_null("Frame/DiscardPanel/CardLayer/DS3SidebarArtWell") is Panel):
        _fail("D322 discard card lacks illustration inset")
        return
    if not (spread.get_node_or_null("Frame/HeldPanel/DS3SidebarStone") is ColorRect):
        _fail("held card has duplicate border substrate")
        return
    if not (spread.get_node_or_null("Frame/DiscardPanel/CardLayer/DS3SidebarStone") is ColorRect):
        _fail("discarded card has duplicate border substrate")
        return
    print("D316_CARD_SURFACES_NATIVE_PASS: complete-card reader, I-XIII, held/discard, live texts and controls")
    spread.queue_free()
    await process_frame
    quit(0)


func _fail(reason: String) -> void:
    push_error("D316_CARD_SURFACES_FAIL: " + reason)
    quit(1)
