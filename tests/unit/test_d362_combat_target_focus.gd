extends GutTest

# D362: live target focus is informational only; the pre-fight bulk
# preview switch must not suppress a single hovered target in a real fight.
const TARGET_PREVIEW := preload("res://scripts/battle/target_preview.gd")


func test_hover_only_mode_remains_visible_after_bulk_preview_is_switched_off() -> void:
	var overlay := TARGET_PREVIEW.new() as BattleTargetPreview
	add_child_autofree(overlay)
	overlay.set_active(true)
	assert_true(overlay.active)
	assert_true(overlay.visible)
	overlay.set_active(false)
	assert_false(overlay.active)
	assert_true(overlay.visible, "Hover-only target focus must work in combat")


func test_combat_focus_uses_the_current_real_target_and_ignores_dead_units() -> void:
	# No scene/AI simulation: validate the exact read-only target handoff.
	var attacker := BattleUnit.new()
	var target := BattleUnit.new()
	attacker.alive = true
	attacker.combat_started = true
	attacker.target = target
	target.alive = true

	assert_eq(TARGET_PREVIEW.get_focus_target(attacker), target)
	target.alive = false
	assert_null(TARGET_PREVIEW.get_focus_target(attacker))
	target.alive = true
	attacker.alive = false
	assert_null(TARGET_PREVIEW.get_focus_target(attacker))

	attacker.target = null
	attacker.free()
	target.free()
