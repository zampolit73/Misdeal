extends SceneTree

# D315 visual-unification smoke: actual F6 gallery + real Reward + live
# independent controls. Does not grant items, mutate deck or change mechanics.
const GALLERY := "res://scenes/dev/d315_card_ds3_gallery.tscn"
const REWARD := "res://scenes/reward/reward.tscn"
const SKIN := preload("res://scripts/ui/card_ds3_skin.gd")

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
        if card.pressed.get_connections().is_empty():
            _fail("visual gallery card lost its inspector control")
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
