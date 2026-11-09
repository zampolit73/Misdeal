extends GutTest
const MOTION := preload("res://scripts/ui/ui_motion.gd")

func after_each() -> void:
	RunState.reset_run()

func test_button_feedback_is_idempotent_visual_only_and_resets_when_disabled() -> void:
	var button := Button.new()
	button.position = Vector2(300, 200)
	button.size = Vector2(200, 40)
	add_child_autofree(button)
	MOTION.bind_button(button)
	MOTION.bind_button(button)
	assert_eq(button.get_child_count(), 1)
	watch_signals(button)
	await get_tree().process_frame
	button.button_down.emit()
	await get_tree().create_timer(0.10).timeout
	await get_tree().process_frame
	assert_lt(button.scale.x, 1.0)
	assert_signal_not_emitted(button, "pressed")
	button.disabled = true
	await get_tree().process_frame
	await get_tree().process_frame
	assert_eq(button.scale, Vector2.ONE)
	assert_eq(button.self_modulate, Color.WHITE)
	button.disabled = false
	button.button_up.emit()
	await get_tree().create_timer(0.17).timeout
	assert_eq(button.scale, Vector2.ONE)

func test_close_during_window_entrance_cancels_animation_and_repeated_close_is_safe() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var party := RunState.party_roles.duplicate()
	var scene := load("res://scenes/table/squad_status.tscn").instantiate() as Control
	add_child(scene)
	await get_tree().create_timer(0.07).timeout
	assert_gt(scene.get_node("Frame").modulate.a, 0.001)
	assert_lt(scene.get_node("Frame").modulate.a, 1.0)
	scene.call("_close")
	scene.call("_close")
	await get_tree().create_timer(0.25).timeout
	assert_false(is_instance_valid(scene))
	var instant := load("res://scenes/table/squad_status.tscn").instantiate() as Control
	add_child(instant)
	instant.call("_close")
	await get_tree().create_timer(0.25).timeout
	assert_false(is_instance_valid(instant), "Deferred entry must not revive an immediately closed popup")
	var spread := load("res://scenes/table/fate_spread_overlay.tscn").instantiate() as Control
	add_child(spread)
	watch_signals(spread)
	spread.call("close")
	spread.call("close")
	await get_tree().create_timer(0.25).timeout
	assert_false(is_instance_valid(spread))
	assert_eq(RunState.party_roles, party)

func test_rapid_card_hover_returns_to_rest_without_selecting_or_drifting() -> void:
	RunState.reset_run()
	var scene := load("res://scenes/class_select/class_select.tscn").instantiate() as Control
	add_child_autofree(scene)
	await get_tree().create_timer(0.45).timeout
	var button := scene.get_node("Frame/Cards/Ranger") as Button
	var home := button.position
	for i in range(12):
		button.mouse_entered.emit()
		button.mouse_exited.emit()
	await get_tree().create_timer(0.22).timeout
	assert_eq(button.position, home)
	assert_eq(button.scale, Vector2.ONE)
	assert_false(RunState.has_chosen_protagonist())
	button.mouse_entered.emit()
	await get_tree().create_timer(0.22).timeout
	assert_almost_eq(button.position.y, home.y - 7.0, 0.01)
	assert_gt(button.scale.x, 1.0)
	button.pressed.emit()
	button.mouse_exited.emit()
	await get_tree().create_timer(0.22).timeout
	assert_almost_eq(button.position.y, home.y - 3.0, 0.01)
	assert_false(RunState.has_chosen_protagonist())

	RunState.choose_protagonist("knight")
	var reward := load("res://scenes/reward/reward.tscn").instantiate() as Control
	add_child_autofree(reward)
	var offer := reward.get_node("Rewards/BloodCoin") as Button
	await get_tree().create_timer(0.04).timeout
	reward.call("_on_reward_hover", offer, true)
	reward.call("_reset_buttons")
	await get_tree().create_timer(0.05).timeout
	await get_tree().process_frame
	assert_eq(offer.scale, Vector2.ONE, "Reset cancels any delayed entrance/hover")
	assert_eq(offer.modulate, Color.WHITE)
	assert_eq(RunState.party_roles, ["knight"])
