extends GutTest

# D365 visual rollback: restore the original optional pre-fight targets.
# A cursor must never reveal a surprise line during the live autobattle.
const TARGET_PREVIEW := preload("res://scripts/battle/target_preview.gd")


func test_preview_is_hidden_without_explicit_opt_in() -> void:
	var overlay := TARGET_PREVIEW.new() as BattleTargetPreview
	add_child_autofree(overlay)
	assert_false(overlay.active)
	assert_false(overlay.visible, "Targets must be hidden until explicitly enabled")
	overlay.set_active(true)
	assert_true(overlay.active)
	assert_true(overlay.visible)
	overlay.set_active(false)
	assert_false(overlay.active)
	assert_false(overlay.visible, "Turning targets off hides the entire overlay")


func test_preview_does_not_enable_hover_only_lines() -> void:
	var overlay := TARGET_PREVIEW.new() as BattleTargetPreview
	add_child_autofree(overlay)
	assert_false(overlay.has_method("_draw_hover_focus"), "No hover-target layer")
	assert_false(overlay.has_method("_get_hovered_unit"), "No cursor polling")
	assert_false(overlay.has_method("get_focus_target"), "No live-focus path")
	overlay.set_active(false)
	overlay._process(0.2)
	assert_false(overlay.visible, "Nothing appears on cursor movement or during combat")
