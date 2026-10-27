extends GutTest

# D361: complete first-act card-art readiness audit against shipped resources.
# This checks actual runtime catalog/fallback art for EVERY offered card and XIII.
# It does not render the final UI, play fights or replace human F5 acceptance.
const STATE := preload("res://scripts/core/run_state.gd")
const CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const EXPECTED_ACT1_CARDS := 39
const MIN_ART_SIZE := Vector2i(200, 120)


func test_all_first_act_cards_and_boss_have_loadable_art_and_targets() -> void:
    var cards: Array[String] = []
    var unique_ids := {}
    for card_id in STATE.ACT1_CARD_IDS:
        var id := String(card_id)
        assert_false(unique_ids.has(id), "Duplicate Act I card ID: " + id)
        unique_ids[id] = true
        cards.append(id)
    assert_eq(cards.size(), EXPECTED_ACT1_CARDS, "Act I deck size changed unexpectedly")
    assert_false(unique_ids.has(STATE.BOSS_CARD_ID), "Boss must not be in the normal deck")
    cards.append(STATE.BOSS_CARD_ID)

    var missing_cards: Array[String] = []
    var invalid_targets: Array[String] = []
    var missing_art: Array[String] = []
    var wrong_sizes: Array[String] = []
    var displayed := 0
    for id in cards:
        var card_path := String(STATE.CARD_PATHS.get(id, ""))
        var card: RunCardData = null
        if not card_path.is_empty():
            card = load(card_path) as RunCardData
        if card == null or card.card_id != id:
            missing_cards.append(id)
            continue
        if card.title.strip_edges().is_empty() or card.card_text.strip_edges().is_empty():
            missing_cards.append(id + " (no title/description)")

        var target := load(card.target_path) if not card.target_path.is_empty() else null
        if card.resolution_type == "combat":
            if not (target is EncounterData):
                invalid_targets.append(id + " (combat encounter)")
        elif id == STATE.BOSS_CARD_ID or not (target is PackedScene):
            invalid_targets.append(id + " (event scene)")

        # Same resolution priority as the actual card gallery:
        # approved CardArtCatalog overrides first, .tres art_path fallback second.
        var painting: Texture2D = CATALOG.get_run_card_texture(id)
        if painting == null and not card.art_path.is_empty():
            painting = load(card.art_path) as Texture2D
        if painting == null:
            missing_art.append(id)
            continue
        var dimensions := Vector2i(painting.get_size())
        if dimensions.x < MIN_ART_SIZE.x or dimensions.y < MIN_ART_SIZE.y:
            wrong_sizes.append("%s (%dx%d)" % [id, dimensions.x, dimensions.y])
            continue
        var pixels := painting.get_image()
        if pixels == null or pixels.is_empty():
            missing_art.append(id + " (no decoded pixels)")
            continue
        displayed += 1

    assert_true(missing_cards.is_empty(), "Missing/malformed card resource: " + ", ".join(PackedStringArray(missing_cards)))
    assert_true(invalid_targets.is_empty(), "Invalid card target: " + ", ".join(PackedStringArray(invalid_targets)))
    assert_true(missing_art.is_empty(), "Missing/unreadable card art: " + ", ".join(PackedStringArray(missing_art)))
    assert_true(wrong_sizes.is_empty(), "Too-small card art: " + ", ".join(PackedStringArray(wrong_sizes)))
    assert_eq(displayed, EXPECTED_ACT1_CARDS + 1, "All 39 card illustrations plus boss XIII must display")
    print("D361_ART_READINESS_PASS: %d/%d card records (39 Act I + XIII), live catalog/fallback pixels and targets" % [
        displayed, EXPECTED_ACT1_CARDS + 1])
