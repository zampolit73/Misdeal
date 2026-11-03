extends GutTest

# D381: regression coverage for the production Fate Spread after an F5
# screenshot exposed baked sample HUD/cards bleeding through live progress.
const GEOMETRY := preload("res://scripts/table/fate_spread_geometry.gd")
const OVERLAY := preload("res://scenes/table/fate_spread_overlay.tscn")


func test_all_twelve_cards_share_layout_with_reference_masks() -> void:
	var overlay := OVERLAY.instantiate() as Control
	add_child_autofree(overlay)
	await get_tree().process_frame

	var panels: Array = overlay.get("slot_panels")
	assert_eq(panels.size(), 12, "Exactly I–XII remain on the physical Fate Spread")
	assert_eq(GEOMETRY.SLOT_CENTERS.size(), 12)
	assert_eq(GEOMETRY.SLOT_ROTATIONS_DEG.size(), 12)
	assert_gt(GEOMETRY.CARD_MASK_SIZE.x, GEOMETRY.SLOT_SIZE.x,
		"Baked card edges need a wider cover than their live replacement")
	assert_gt(GEOMETRY.CARD_MASK_SIZE.y, GEOMETRY.SLOT_SIZE.y)

	var cleanup := overlay.get_node("Frame/SpreadArea/ReferenceCleanup") as Control
	assert_not_null(cleanup)
	for index in range(12):
		var panel := panels[index] as Panel
		assert_not_null(panel)
		if panel == null:
			continue
		assert_eq(panel.size, GEOMETRY.SLOT_SIZE)
		assert_eq(panel.position, GEOMETRY.SLOT_CENTERS[index] - GEOMETRY.SLOT_SIZE * 0.5,
			"Live panel %d must align with its approved painted slot" % (index + 1))


func test_fifth_roman_clears_fourth_card_and_tiny_titles_do_not_wrap() -> void:
	var overlay := OVERLAY.instantiate() as Control
	add_child_autofree(overlay)
	await get_tree().process_frame
	var panels: Array = overlay.get("slot_panels")
	var fifth := panels[4] as Panel
	var marker := fifth.get_node("Roman") as Label
	assert_lte(marker.position.x + marker.size.x, 0.0,
		"Roman V must stand LEFT of its card rather than on top of IV's title")
	var title := fifth.get_node("CardTitle") as Label
	assert_eq(title.autowrap_mode, TextServer.AUTOWRAP_OFF,
		"Tiny Fate names must not spill onto the dark footer as two lines")
	assert_lt(title.position.y + title.size.y, GEOMETRY.SLOT_SIZE.y * 0.80,
		"The text rectangle must fit the physical parchment band")
	var boss := overlay.get("boss_panel") as Panel
	assert_true(boss != null, "XIII boss card remains present")


func test_header_is_opaque_and_phase_clears_first_roman() -> void:
	var overlay := OVERLAY.instantiate() as Control
	add_child_autofree(overlay)
	await get_tree().process_frame

	var mask := overlay.get_node("Frame/HeaderMask") as ColorRect
	var phase := overlay.get_node("Frame/Phase") as Label
	assert_eq(mask.color.a, 1.0, "Baked example counters must never show through")
	var first_roman_top: float = 140.0 + GEOMETRY.SLOT_CENTERS[0].y - GEOMETRY.SLOT_SIZE.y * 0.5 - 14.0
	assert_lt(phase.position.y + phase.size.y, first_roman_top,
		"Phase caption may not collide with the first physical Fate numeral")


func test_printed_sixth_slot_gets_correct_vi_until_it_becomes_live() -> void:
	RunState.reset_run()
	assert_true(RunState.choose_protagonist("knight"))
	var overlay := OVERLAY.instantiate() as Control
	add_child_autofree(overlay)
	await get_tree().process_frame

	var corrected := overlay.get_node("Frame/SpreadArea/CorrectedSixthRoman") as Label
	assert_eq(corrected.text, "VI", "Reference bitmap mistakenly labels the sixth slot V")
	assert_true(corrected.visible, "Future sixth card needs one clear VI label")
	assert_true(GEOMETRY.PRINTED_SIXTH_ROMAN_MASK.has_point(
		GEOMETRY.PRINTED_SIXTH_ROMAN_LABEL.get_center()),
		"Corrected numeral must sit inside the old painted V mask")

	RunState.cards_resolved = 5
	overlay.refresh()
	assert_false(corrected.visible,
		"Active VI uses its own attached Roman instead of a second floating label")
	var sixth := overlay.get("slot_panels")[5] as Panel
	assert_true(sixth.visible, "Actual sixth card must become live")
	RunState.reset_run()
