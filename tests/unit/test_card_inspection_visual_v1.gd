extends GutTest

const READER := preload("res://scenes/table/card_lore_inspect.tscn")
const TABLE := preload("res://scenes/table/table.tscn")
const REWARD := preload("res://scenes/reward/reward.tscn")

func after_each() -> void:
	RunState.reset_run()

func test_reader_real_plate_scroll_and_close() -> void:
	var prior := Button.new()
	add_child_autofree(prior)
	prior.grab_focus()
	var reader := READER.instantiate()
	add_child_autofree(reader)
	var text := "Длинное описание без скрытых исходов. ".repeat(40)
	reader.present("ДЛИННОЕ НАЗВАНИЕ КАРТЫ", "БОЙ • ПЕРЕКРЁСТНЫЙ ОГОНЬ", text, null)
	await get_tree().create_timer(0.35).timeout
	var frame: Panel = reader.frame
	var plate: TextureRect = frame.get_node("ReaderPlate")
	assert_eq(frame.size, Vector2(900, 452))
	assert_not_null(plate.texture)
	assert_eq(plate.texture.get_size(), Vector2(1800, 904))
	assert_eq(plate.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_eq(reader.lore_body.text, text)
	assert_false(reader.annotation.visible)
	assert_eq(reader.lore_kind.text, "БОЙ • ПЕРЕКРЁСТНЫЙ ОГОНЬ")
	assert_eq(frame.get_node("DS3InspectCardType").text, "БОЙ")
	var close_button: Button = frame.get_node("CloseButton")
	assert_eq(get_viewport().gui_get_focus_owner(), close_button)
	assert_eq(close_button.get_node(close_button.focus_next), close_button)
	assert_gt(reader.lore_body.get_v_scroll_bar().max_value, reader.lore_body.get_v_scroll_bar().page)
	_key(reader, KEY_END)
	assert_gt(reader.lore_body.get_v_scroll_bar().value, 0.0)
	_key(reader, KEY_HOME)
	assert_eq(reader.lore_body.get_v_scroll_bar().value, 0.0)
	assert_true(frame.get_global_rect().encloses(reader.lore_body.get_global_rect()))
	watch_signals(reader)
	_key(reader, KEY_ESCAPE)
	assert_signal_emit_count(reader, "closed", 1)
	assert_eq(get_viewport().gui_get_focus_owner(), prior)
	await get_tree().process_frame
	assert_false(is_instance_valid(reader))

func test_table_open_close_preserves_real_card_and_annotation() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.current_offer_ids.assign(["debtor_bones", "ash_rest"])
	RunState.wizard_mark_card_id = "debtor_bones"
	RunState.held_card_id = "debtor_bones"
	var table := TABLE.instantiate()
	add_child_autofree(table)
	await get_tree().create_timer(1.5).timeout
	var card: Button = table.get_node("Cards/BonePatrolCard")
	card.grab_focus()
	var offers := RunState.current_offer_ids.duplicate()
	var gold: int = RunState.gold
	table.call("_on_offer_inspect_requested", card)
	var reader: Control = table.card_lore_inspect
	assert_not_null(reader)
	if reader == null:
		return
	var resource := RunState.get_card("debtor_bones")
	assert_eq(reader.lore_title.text, resource.title)
	assert_eq(reader.lore_body.text, resource.card_text)
	assert_eq(reader.lore_kind.text, resource.type_label)
	assert_eq(reader.lore_art.texture, card.get_node("Art").texture)
	assert_true(reader.annotation.visible)
	assert_true(reader.annotation.text.contains("ПЕЧАТЬ: +%d золота" % RunState.get_wizard_mark_gold_reward()))
	assert_true(reader.annotation.text.contains("УДЕРЖАНО:"))
	assert_false(reader.lore_body.get_rect().intersects(reader.annotation.get_rect()))
	assert_true(table.has_table_modal())
	assert_false(table.can_open_table_modal())
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	reader.get_node("Scrim").gui_input.emit(click)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_false(table.has_table_modal())
	assert_eq(get_viewport().gui_get_focus_owner(), card)
	assert_eq(RunState.current_offer_ids, offers)
	assert_eq(RunState.gold, gold)
	assert_false(RunState.has_active_card())

func test_reward_reader_uses_live_upgrade_and_never_claims() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.active_card_id = "bone_patrol"
	var reward := REWARD.instantiate()
	add_child_autofree(reward)
	await get_tree().process_frame
	assert_eq(reward.reward_mode, "major_upgrade")
	var button: Button = reward.reward_buttons[0]
	button.grab_focus()
	var options: Array = reward.option_ids.duplicate()
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_RIGHT
	click.pressed = true
	reward.call("_on_reward_detail_input", click, 0)
	var reader: Control = reward._details
	assert_not_null(reader)
	if reader == null:
		return
	assert_eq(reader.lore_title.text, reward.upgrade_title_labels[0].text)
	assert_eq(reader.lore_kind.text, reward.upgrade_role_labels[0].text)
	assert_eq(reader.lore_body.text, button.tooltip_text)
	assert_eq(reader.lore_art.texture, reward.upgrade_portraits[0].texture)
	assert_false(reader.annotation.visible)
	reader.frame.get_node("CloseButton").pressed.emit()
	await get_tree().process_frame
	assert_null(reward._details)
	assert_eq(reward.option_ids, options)
	assert_false(reward.reward_completed)
	assert_eq(get_viewport().gui_get_focus_owner(), button)

func _key(reader: Control, code: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.pressed = true
	reader._input(event)
