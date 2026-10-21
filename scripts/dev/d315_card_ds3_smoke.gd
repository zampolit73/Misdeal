extends SceneTree

# D315 visual-unification smoke: actual F6 gallery + real Reward + live
# independent controls. Does not grant items, mutate deck or change mechanics.
const GALLERY := "res://scenes/dev/d315_card_ds3_gallery.tscn"
const REWARD := "res://scenes/reward/reward.tscn"
const SKIN := preload("res://scripts/ui/card_ds3_skin.gd")
const CATALOG := preload("res://scripts/ui/card_art_catalog.gd")

func _initialize() -> void:
    call_deferred("_verify")

func _verify() -> void:
    for path in [SKIN.FRONT, SKIN.BACK, SKIN.INK]:
        var img := load(path) as Texture2D
        if img == null:
            _fail("missing approved DS3 art " + path)
            return
    var front := load(SKIN.FRONT) as Texture2D
    if front.get_image().get_size() != Vector2i(375, 509):
        _fail("front art wrong native dimensions")
        return
    if front.get_image().get_pixel(200, 200).a > 0.05:
        _fail("D315 card front contains flattened illustration instead of live art")
        return

    # D321: avoid the real-Godot regression where fragment COLOR was already
    # multiplied by TEXTURE, then multiplied by the sampled illustration again.
    # Shader parsing/compilation is validated by the normal native CI import.
    var grade_source := FileAccess.get_file_as_string(
        "res://shaders/card_ds3_ink.gdshader"
    )
    if not grade_source.contains("card_vertex_tint = COLOR;"):
        _fail("DS3 card shader does not preserve vertex tint")
        return
    if not grade_source.contains("original.a) * card_vertex_tint;"):
        _fail("DS3 card shader may darken textures by multiplying COLOR twice")
        return
    if grade_source.contains("original.a) * COLOR;"):
        _fail("DS3 card shader repeats the texture multiplication")
        return

    # D319: the exact option-three scene must win over older Black Altar art.
    const ALTAR_ART = "res://assets/pixel/card_unification_v1/run/black_altar_d319_option3.webp"
    if not FileAccess.file_exists(ALTAR_ART):
        _fail("D319 selected Black Altar image not tracked")
        return
    if FileAccess.get_sha256(ALTAR_ART) != "3e873813db79ba9f67df9de00be07e80e177ad1f6429af36d6592f13ac6bde0e":
        _fail("D319 Black Altar art is not the approved option-three crop")
        return
    var selected_altar := CATALOG.get_run_card_texture("black_altar")
    if selected_altar == null or selected_altar.get_size() != Vector2(448, 274):
        _fail("D319 selected art did not override Black Altar catalog")
        return
    var preview := (load(GALLERY) as PackedScene).instantiate() as Control
    if preview == null:
        _fail("cannot instantiate complete card gallery")
        return
    root.add_child(preview)
    await process_frame
    var grid := preview.get_node("CardScroll/CardGrid") as GridContainer
    if grid == null or preview.get("card_count") < 40:
        _fail("the full card resource registry was not enumerated")
        return
    if not (preview.get("missing_art") as Array).is_empty():
        _fail("one or more original RunCardData illustrations unavailable: " +
            str(preview.get("missing_art")))
        return
    if grid.get_child_count() < 55:
        _fail("gallery is missing reward/upgrade card illustrations")
        return
    for child in grid.get_children():
        var card := child as Button
        if card == null:
            _fail("gallery contains a non-interactive card")
            return
        if not card.has_node("DS3CardFrame") or not card.has_node("DS3Roman"):
            _fail("card missing approved new physical face")
            return
        if (card.get_node("Art") as TextureRect).texture == null:
            _fail("a gallery card has no own illustration: " + card.name)
            return
        if (card.get_node("Art") as TextureRect).material == null:
            _fail("D315 red/black tone-mapping missing: " + card.name)
            return
        # D320 single-frame contract: a front must have ONE framed overlay
        # and an unframed opaque stone surface, never the framed card-back art.
        var base := card.get_node_or_null("DS3CardStone") as ColorRect
        if base == null or base.color != SKIN.FACE_STONE:
            _fail("DS3 gallery face still stacks a second bordered card texture: " + card.name)
            return
        if card.get_node("DS3CardFrame") is not TextureRect:
            _fail("DS3 gallery has no original painted FRONT frame: " + card.name)
            return
        var front_layers := 0
        for layer in card.get_children():
            if layer.name == "DS3CardFrame":
                front_layers += 1
        if front_layers != 1:
            _fail("DS3 gallery has more than one front frame: " + card.name)
            return
        # D323: catches native-size 375x509 frame clipping at the card edge.
        var physical_frame := card.get_node("DS3CardFrame") as TextureRect
        if not physical_frame.size.is_equal_approx(SKIN.TABLE_SIZE):
            _fail("D323 gallery frame is native-size/clipped, not card-size: " + card.name +
                " " + str(physical_frame.size))
            return
        if not (card.get_node("DS3CardStone") as ColorRect).size.is_equal_approx(SKIN.TABLE_SIZE):
            _fail("D323 gallery stone bounds differ from physical card: " + card.name)
            return
        # D322: the real illustration remains inside a separate art mount,
        # underneath the ONE exterior frame and above the unframed stone.
        var art := card.get_node("Art") as TextureRect
        var art_well := card.get_node_or_null("DS3ArtWell") as Panel
        if art_well == null or art_well.get_index() >= art.get_index():
            _fail("D322 gallery art is not recessed: " + card.name)
            return
        # D324: no stray second rectangular gilding around the landscape.
        var matte := art_well.get_theme_stylebox("panel") as StyleBoxFlat
        if matte == null or matte.border_width_left != 0 or matte.border_width_top != 0 or matte.border_width_right != 0 or matte.border_width_bottom != 0:
            _fail("D324 gallery has an unintended inset ornamental frame: " + card.name)
            return
        if matte.bg_color != SKIN.FACE_STONE:
            _fail("D324 art well has a visible mismatched matte: " + card.name)
            return
        if art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
            _fail("D322 gallery art still crops its scene: " + card.name)
            return
        if art.position.x <= art_well.position.x or art.position.y <= art_well.position.y:
            _fail("D322 gallery art has no matte inset: " + card.name)
            return
        if art.position.x + art.size.x >= art_well.position.x + art_well.size.x or art.position.y + art.size.y >= art_well.position.y + art_well.size.y:
            _fail("D322 gallery art escapes its mount: " + card.name)
            return
        if art_well.position.y + art_well.size.y >= (card.get_node("Title") as Label).position.y:
            _fail("D322 gallery art mount overlaps title text: " + card.name)
            return
        if not card.tooltip_text.is_empty():
            _fail("native tooltip blocks neighboring cards in gallery")
            return
        if card.pressed.get_connections().is_empty():
            _fail("visual gallery card lost its inspector control")
            return
    # D318: native geometry and click contract for all 55 entries.
    for child in grid.get_children():
        var card := child as Button
        var well := card.get_node_or_null("CardTextClip") as Control
        if well == null or not well.clip_contents:
            _fail("description has no vertically clipped card text well: " + card.name)
            return
        var body := well.get_node_or_null("Description") as Label
        var heading := card.get_node_or_null("Title") as Label
        var category := card.get_node_or_null("Type") as Label
        var hint := card.get_node_or_null("Hint") as Label
        var roman := card.get_node_or_null("DS3Roman") as Label
        if body == null or heading == null or category == null or hint == null:
            _fail("card missing live geometry: " + card.name)
            return
        if roman == null or roman.visible:
            _fail("gallery is showing a fake Fate numeral: " + card.name)
            return
        if category.position.y > 38 or category.position.y + category.size.y >= heading.position.y:
            _fail("type label intrudes into the artwork or title: " + card.name)
            return
        if heading.position.y + heading.size.y > well.position.y:
            _fail("title overlaps the body text well: " + card.name)
            return
        if well.position.y + well.size.y > hint.position.y:
            _fail("description overlaps the click hint: " + card.name)
            return
        if well.position.x < 0 or well.position.x + well.size.x > SKIN.TABLE_SIZE.x:
            _fail("description escapes card horizontal bounds: " + card.name)
            return
        # D325: true centering across all 55 cards, even after layout override.
        # D327: front_frame.webp art is asymmetrical: body optical center
        # is x147 and header tab center is x150, not Button center x136.
        var expected_center := SKIN.TABLE_COPY_CENTER_X
        for line in [heading, hint]:
            if line.horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER or line.vertical_alignment != VERTICAL_ALIGNMENT_CENTER:
                _fail("D325 card line is not centered: " + card.name + "/" + line.name)
                return
            if absf(line.position.x + line.size.x * 0.5 - expected_center) > 0.5:
                _fail("D325 card text box is off-center: " + card.name + "/" + line.name)
                return
        if absf(well.position.x + well.size.x * 0.5 - expected_center) > 0.5:
            _fail("D325 description box shifted off card center: " + card.name)
            return
        if body.horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER or body.vertical_alignment != VERTICAL_ALIGNMENT_CENTER:
            _fail("D325 description text is not centered: " + card.name)
            return
        # D326: test the *rendered* child rect, not only parent geometry and
        # alignment enum. An obsolete reparent transform can shift the text.
        if body.get_parent() != well:
            _fail("D326 description is no longer attached to its clip well: " + card.name)
            return
        if not body.position.is_equal_approx(Vector2.ZERO):
            _fail("D326 description retains an offset after reparent: " + card.name)
            return
        if not body.size.is_equal_approx(well.size):
            _fail("D326 description size does not match its text well: " + card.name)
            return
        if not is_equal_approx(body.anchor_left, 0.0) or not is_equal_approx(body.anchor_top, 0.0) or not is_equal_approx(body.anchor_right, 1.0) or not is_equal_approx(body.anchor_bottom, 1.0):
            _fail("D326 description is not anchored to the well: " + card.name)
            return
        var actual_center := (body.global_position.x + body.size.x * 0.5)
        var face_copy_center := card.global_position.x + SKIN.TABLE_COPY_CENTER_X
        if absf(actual_center - face_copy_center) > 0.5:
            _fail("D327 rendered description center differs from FRONT art: " + card.name)
            return
        if category.horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER:
            _fail("D325 type text is not centered in its physical tab: " + card.name)
            return
        if absf(category.position.x + category.size.x * 0.5 - SKIN.TABLE_TAB_CENTER_X) > 0.5:
            _fail("D327 category text is outside the black top inscription tab: " + card.name)
            return
        if category.size.x > 56.0:
            _fail("D327 category tab label is wider than approved ornate inset: " + card.name)
            return
        var roman_rect := card.get_node("DS3Roman") as Label
        if roman_rect.position.x + roman_rect.size.x > category.position.x:
            _fail("D327 true Fate numeral overlaps the category label: " + card.name)
            return
        if body.max_lines_visible > 2 or body.text.length() > 59:
            _fail("gallery preview exceeds two-line budget: " + card.name)
            return
    var altar := grid.get_node_or_null("Card_black_altar") as Button
    if altar == null:
        _fail("original Black Altar missing from gallery")
        return
    var source := load("res://resources/cards/black_altar.tres") as Resource
    var full_copy := String(source.get("card_text"))
    var short_body := altar.get_node("CardTextClip/Description") as Label
    if short_body.text == full_copy or full_copy.length() <= short_body.text.length():
        _fail("gallery exposed full narrative copy instead of a preview")
        return
    altar.pressed.emit()
    var reader := preview.get_node_or_null("DS3FullTextOverlay") as Control
    var reader_copy := preview.get("detail_copy") as RichTextLabel
    if reader == null or not reader.visible or reader_copy == null or reader_copy.text != full_copy:
        _fail("full-text scrolling reader did not preserve source copy")
        return
    var board := reader.get_node("ReaderBoard") as Panel
    if not (board.get_node("ReaderFullCopy") as RichTextLabel).scroll_active:
        _fail("full copy is not scrollable")
        return
    (board.get_node("ReaderClose") as Button).pressed.emit()
    if reader.visible:
        _fail("reader close action is broken")
        return
    preview.queue_free()
    await process_frame

    # Test Reward using the normal project autoload, but do not click rewards.
    var state := root.get_node_or_null("RunState")
    if state == null:
        state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
        state.name = "RunState"
        root.add_child(state)
    state.call("reset_run")
    if not state.call("choose_protagonist", "knight"):
        _fail("cannot initialize reward test")
        return
    var reward_scene := (load(REWARD) as PackedScene).instantiate() as Control
    root.add_child(reward_scene)
    await process_frame
    for name in ["BloodCoin", "IronWard", "TemperedSteel"]:
        var card := reward_scene.get_node("Rewards/" + name) as Button
        if card == null or not card.has_node("DS3CardFrame"):
            _fail("real Reward did not use DS3 physical painted card " + name)
            return
        var portrait := card.get_node_or_null("Portrait") as TextureRect
        var art_well := card.get_node_or_null("DS3ArtWell") as Panel
        if portrait == null or art_well == null or art_well.get_index() >= portrait.get_index():
            _fail("D322 reward art well missing or above portrait: " + name)
            return
        if portrait.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
            _fail("D322 reward portrait still crops its illustration: " + name)
            return
        # D325: Reward titles/effects/descriptions center at card x=146.
        for path in ["Role", "UpgradeTitle", "QuickEffect", "UpgradeDescription"]:
            var text_node := card.get_node_or_null(path) as Label
            if text_node == null:
                _fail("D325 Reward label is missing: " + name + "/" + path)
                return
            if text_node.horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER:
                _fail("D325 Reward text alignment is not centered: " + name + "/" + path)
                return
            if absf(text_node.position.x + text_node.size.x * 0.5 - SKIN.REWARD_COPY_CENTER_X) > 1.0:
                _fail("D325 Reward text box is off-center: " + name + "/" + path)
                return
        var matte := art_well.get_theme_stylebox("panel") as StyleBoxFlat
        if matte == null or matte.border_width_left != 0 or matte.border_width_top != 0 or matte.border_width_right != 0 or matte.border_width_bottom != 0:
            _fail("D324 Reward contains a duplicate inset outline: " + name)
            return
        var physical_frame := card.get_node("DS3CardFrame") as TextureRect
        if not physical_frame.size.is_equal_approx(Vector2(292, 410)):
            _fail("D323 Reward physical frame clipped to native texture dimensions: " + name)
            return
        if not (card.get_node_or_null("DS3CardStone") is ColorRect):
            _fail("DS3 reward card still stacks a second bordered back: " + name)
            return
        if (card.get_node("DS3CardFrame") as TextureRect).mouse_filter != Control.MOUSE_FILTER_IGNORE:
            _fail("card ornament intercepts real Reward input")
            return
        if card.pressed.get_connections().is_empty():
            _fail("original reward action lost " + name)
            return
    print("D315_CARD_DS3_NATIVE_PASS: full card atlas, reward UI, source art and preserved click handlers")
    reward_scene.queue_free()
    await process_frame
    quit(0)

func _fail(message: String) -> void:
    push_error("D315_CARD_DS3_FAIL: " + message)
    quit(1)
