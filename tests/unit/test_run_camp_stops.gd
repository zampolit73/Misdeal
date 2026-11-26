extends GutTest

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")

func before_each() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")


func _resolve_at(slot: int) -> void:
	RunState.cards_resolved = slot - 1
	RunState.active_card_id = "moon_seal"
	RunState.complete_active_card()


func test_new_companion_enters_healthy_and_party_changes_preserve_wounds() -> void:
	RunState.record_battle_health("knight", 46.5)
	assert_true(RunState.lose_companion("mage", "Test"))
	assert_false(RunState.recruit_companion("mage", "Test"))
	assert_true(RunState.recruit_companion("ranger", "Test"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 46.5, 0.01)
	assert_almost_eq(RunState.get_hero_current_hp("ranger"), RunState.get_hero_max_hp("ranger"), 0.01)


func test_downed_hero_recovers_one_fifth_and_max_hp_increase_cannot_heal() -> void:
	RunState.recruit_companion("ranger", "Test")
	RunState.recruit_companion("mage", "Test")
	RunState.record_battle_health("knight", 0.0)
	var recovered := RunState.get_hero_max_hp("knight") * 0.20
	assert_almost_eq(RunState.get_hero_current_hp("knight"), recovered, 0.01)
	RunState.party_hp_bonus += 50.0
	assert_almost_eq(RunState.get_hero_current_hp("knight"), recovered, 0.01)
	RunState.party_hp_bonus -= 100.0
	RunState.clamp_party_health()
	assert_lte(RunState.get_hero_current_hp("knight"), RunState.get_hero_max_hp("knight"))


func test_victory_heals_each_hero_by_one_quarter_of_max_hp() -> void:
	RunState.recruit_companion("ranger", "Test")
	RunState.recruit_companion("mage", "Test")
	var knight_max := RunState.get_hero_max_hp("knight")
	var ranger_max := RunState.get_hero_max_hp("ranger")
	var mage_max := RunState.get_hero_max_hp("mage")
	RunState.record_battle_health("knight", knight_max * 0.50)
	RunState.record_battle_health("ranger", ranger_max * 0.90)
	RunState.record_battle_health("mage", 0.0)
	RunState.heal_party_after_victory()
	assert_almost_eq(RunState.get_hero_current_hp("knight"), knight_max * 0.75, 0.01)
	assert_almost_eq(RunState.get_hero_current_hp("ranger"), ranger_max, 0.01)
	assert_almost_eq(RunState.get_hero_current_hp("mage"), mage_max * 0.45, 0.01)


func test_rest_applies_once_and_does_not_resolve_a_fate_card() -> void:
	RunState.record_battle_health("knight", 64.0)
	_resolve_at(4)
	assert_eq(RunState.camp_stop.slot, 4)
	assert_true(STOPS.apply(RunState, "rest"))
	assert_almost_eq(RunState.get_hero_current_hp("knight"), 64.0 + RunState.get_hero_max_hp("knight") * 0.40, 0.01)
	assert_false(STOPS.apply(RunState, "rest"))
	assert_eq(RunState.cards_resolved, 4)


func test_last_rest_unlocks_xiii_without_spending_another_card() -> void:
	_resolve_at(12)
	assert_eq(RunState.camp_stop.slot, 12)
	assert_true(STOPS.apply(RunState, "upgrade/knight"))
	assert_eq(RunState.hero_upgrade_ids.size(), 1)
	assert_eq(RunState.cards_resolved, 12)
	assert_eq(RunState.get_offer_cards()[0].card_id, RunState.BOSS_CARD_ID)


func test_dark_rite_uses_displayed_blood_price_and_revokes_action() -> void:
	_resolve_at(4)
	var entry := RunState.get_hero_current_hp("knight")
	var cost := STOPS.rite_cost(RunState)
	assert_true(STOPS.apply(RunState, "rite"))
	assert_eq(RunState.artifact_ids.size(), 1)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), entry - cost, 0.01)
	assert_false(STOPS.apply(RunState, "rite"))


func test_shop_retains_inventory_and_purchases_across_load() -> void:
	RunState.recruit_companion("ranger", "Test")
	RunState.gold = 90
	RunState.record_battle_health("knight", 55.0)
	_resolve_at(8)
	var stock: Array = RunState.camp_stop.stock.duplicate()
	assert_true(STOPS.apply(RunState, "heal"))
	var service := SAVE.new()
	var saved := service.snapshot(RunState)
	RunState.reset_run()
	assert_true(service.apply_slot(RunState, saved))
	assert_eq(RunState.camp_stop.stock, stock)
	assert_eq(RunState.gold, 65)
	assert_false(STOPS.apply(RunState, "heal"))
	assert_true(STOPS.apply(RunState, stock[0]))
	assert_eq(RunState.gold, 15)
	assert_false(STOPS.apply(RunState, stock[1]))
	assert_true(STOPS.apply(RunState, "leave"))
	assert_true(RunState.camp_stop.is_empty())


func _open_rest_view() -> Control:
	var view := preload("res://scripts/table/camp_rest_view.gd").new()
	add_child_autofree(view)
	view.build("ПРИВАЛ", "QA")
	return view


func test_both_rest_screens_use_black_gold_cards_and_existing_art() -> void:
	var skin := preload("res://scripts/ui/unified_card_skin.gd")
	for slot in [4, 12]:
		RunState.camp_stop = STOPS.open(RunState, slot)
		var view := _open_rest_view()
		await get_tree().process_frame
		assert_eq(view.action_buttons.size(), 3)
		for button: Button in view.action_buttons:
			var frame := button.get_node("UnifiedCardFrame") as TextureRect
			var art := button.get_node("CardArt") as TextureRect
			var title := button.get_node("Title") as Label
			var description := button.get_node("Description") as Label
			var action := button.get_node("UnifiedAction") as TextureRect
			assert_eq(frame.texture, skin.FRAME)
			assert_eq(frame.get_rect(), Rect2(Vector2.ZERO, button.size))
			assert_eq(button.get_node("OldPlateMask").get_rect(), frame.get_rect())
			assert_true(art.texture is AtlasTexture)
			assert_eq(art.texture.atlas, view.PLATE)
			assert_true(art.get_rect().end.y <= title.position.y)
			assert_true(title.get_rect().end.y <= description.position.y)
			assert_true(description.get_rect().end.y <= action.position.y)
			assert_eq(title.get_theme_color("font_color"), skin.GOLD)
			assert_eq(description.get_theme_color("font_color"), skin.COPY)
			assert_eq(action.get_node("Caption").text, "ВЫБРАТЬ")
			assert_eq(art.mouse_filter, Control.MOUSE_FILTER_IGNORE)
			if description.max_lines_visible == -1:
				assert_true(button.tooltip_text.is_empty(), "Full face copy needs no overlapping popup")
			else:
				assert_eq(button.tooltip_text, description.text)
		view.queue_free()
		await get_tree().process_frame


func test_training_role_selector_and_action_are_independent() -> void:
	RunState.recruit_companion("mage", "QA")
	RunState.camp_stop = STOPS.open(RunState, 12)
	var view := _open_rest_view()
	await get_tree().process_frame
	var training: Button = view.action_buttons[1]
	var selector: OptionButton = view._trainee
	assert_eq(selector.get_parent(), training)
	assert_eq(training.get_node(training.focus_neighbor_bottom), selector)
	assert_eq(selector.get_node(selector.focus_neighbor_top), training)
	assert_eq(selector.item_count, 2)
	assert_true(training.get_node("Description").get_rect().end.y <= selector.position.y)
	assert_true(selector.get_rect().end.y <= training.get_node("UnifiedAction").position.y)
	watch_signals(view)
	selector.select(1)
	selector.item_selected.emit(1)
	var upgrade := RunState.get_hero_upgrade(RunState.get_next_extra_hero_upgrade_id("mage"))
	assert_string_contains(training.get_node("Description").text, upgrade.title)
	assert_signal_not_emitted(view, "action_requested")
	training.pressed.emit()
	assert_signal_emitted_with_parameters(view, "action_requested", ["upgrade/mage"])
	assert_eq(RunState.hero_upgrade_ids.size(), 0, "View only emits request; panel owns application")


func test_unavailable_camp_cards_show_visible_restriction_and_skip_focus() -> void:
	var skin := preload("res://scripts/ui/unified_card_skin.gd")
	while not RunState.add_next_extra_hero_upgrade("knight").is_empty():
		pass
	RunState.camp_stop = STOPS.open(RunState, 12)
	RunState.change_hero_hp("knight", -RunState.get_hero_current_hp("knight") + 1.0)
	var view := _open_rest_view()
	await get_tree().process_frame
	for index in [1, 2]:
		var button: Button = view.action_buttons[index]
		var reason := button.get_node("Availability") as Label
		assert_true(button.disabled)
		assert_eq(button.focus_mode, Control.FOCUS_NONE)
		assert_false(reason.text.is_empty())
		assert_eq(reason.get_theme_color("font_color"), skin.NEGATIVE)
		assert_eq(button.get_node("UnifiedAction/Caption").text, "НЕДОСТУПНО")
		assert_eq(button.get_node("UnifiedAction").texture, skin.button_texture("disabled"))
		assert_string_contains(button.accessibility_description, reason.text)


func test_actual_camp_panel_rest_saves_and_ignores_duplicate_selection() -> void:
	# A real, internally consistent four-card checkpoint through the offer API.
	for index in 4:
		var cards := RunState.get_offer_cards()
		assert_false(cards.is_empty())
		assert_true(RunState.choose_card(cards[0].card_id))
		RunState.complete_active_card()
	assert_eq(RunState.camp_stop.slot, 4)
	RunState.change_hero_hp("knight", -50.0)
	var wounded := RunState.get_hero_current_hp("knight")
	var max_hp := RunState.get_hero_max_hp("knight")
	var previous = SAVE.shared
	var service := SAVE.new()
	service.path = "user://camp_v3_qa_%d.json" % Time.get_ticks_usec()
	SAVE.shared = service
	var panel := preload("res://scripts/table/camp_stop_panel.gd").new()
	add_child_autofree(panel)
	await get_tree().process_frame
	watch_signals(panel)
	var rest: Button = panel._action_buttons[0]
	rest.pressed.emit()
	rest.pressed.emit()
	assert_signal_emit_count(panel, "finished", 1)
	assert_true(RunState.camp_stop.is_empty())
	assert_eq(RunState.cards_resolved, 4)
	assert_almost_eq(RunState.get_hero_current_hp("knight"), minf(max_hp, wounded + max_hp * STOPS.rest_fraction(RunState)), 0.01)
	var saved := service.read_slot(RunState)
	assert_false(saved.is_empty())
	if not saved.is_empty():
		assert_true(saved.state.camp_stop.is_empty())
		assert_eq(saved.state.cards_resolved, 4)
	DirAccess.remove_absolute(service.path)
	SAVE.shared = previous
