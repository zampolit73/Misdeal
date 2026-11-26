extends GutTest

const ACT := preload("res://scenes/event/act_choice.tscn")
const WELL := preload("res://scenes/event/whispering_well.tscn")
const SKIN := preload("res://scripts/ui/unified_card_skin.gd")


func after_each() -> void:
	RunState.reset_run()


func test_every_production_event_has_readable_cards_for_solo_and_trio() -> void:
	var total := 0
	for path in DirAccess.get_files_at("res://resources/cards"):
		if not path.ends_with(".tres"):
			continue
		var definition := load("res://resources/cards/" + path) as RunCardData
		if definition == null or definition.target_path not in [ACT.resource_path, WELL.resource_path]:
			continue
		total += 1
		for party_size in [1, 3]:
			_reset(definition.card_id, 100, "ranger" if definition.card_id == "jack" else "knight")
			if party_size == 3:
				for role in ["knight", "ranger", "mage"]:
					if RunState.can_recruit_companion(role):
						RunState.recruit_companion(role, "QA")
			var event := _open(WELL if definition.target_path == WELL.resource_path else ACT)
			await get_tree().process_frame
			var row := event.get_node("Choices" if definition.target_path == WELL.resource_path else "Panel/Choices") as HBoxContainer
			assert_eq(row.get_global_rect(), Rect2(96, 169, 1088, 454), definition.card_id)
			var visible_cards := 0
			for card: Button in row.get_children():
				if not card.visible:
					continue
				visible_cards += 1
				var art := card.get_node("ChoiceArt") as TextureRect
				assert_not_null(art.texture, definition.card_id)
				var frame := card.get_node_or_null("DecisionFrame") as TextureRect
				assert_not_null(frame, definition.card_id)
				if frame != null:
					assert_eq(frame.get_global_rect(), card.get_global_rect(), definition.card_id)
					assert_eq(frame.mouse_filter, Control.MOUSE_FILTER_IGNORE)
					assert_lt(frame.z_index, art.z_index)
				assert_true(row.get_global_rect().encloses(card.get_global_rect()), definition.card_id)
				for key in ["Action", "Cost", "Outcome", "Availability"]:
					var label := card.get_node("Copy/" + key) as Label
					if not label.text.is_empty():
						assert_true(label.get_theme_color("font_color") in [SKIN.GOLD, SKIN.COPY, SKIN.NEGATIVE], "V3 event copy contrast: " + key)
						assert_lte(float(label.get_line_count() * (label.get_line_height() + 1)), label.size.y,
							"%s/%s/%s: %s" % [definition.card_id, card.name, key, label.text])
				if card.disabled:
					assert_false(card.get_node("Copy/Availability").text.is_empty(), definition.card_id)
					assert_eq(card.focus_mode, Control.FOCUS_NONE)
			assert_between(visible_cards, 2, 4, definition.card_id)
			event.queue_free()
			await get_tree().process_frame
	assert_eq(total, 24, "Inventory of production event screens")


func test_well_coin_restriction_focus_hover_and_single_recruitment() -> void:
	_reset("whispering_well", 24)
	var event := _open(WELL)
	await get_tree().process_frame
	var blood := _card(event, "Choices/AcceptGift")
	var coin := _card(event, "Choices/PayCoin")
	var leave := _card(event, "Choices/Leave")
	assert_eq(_text(blood, "Cost"), "−12 макс. HP")
	assert_string_contains(_text(blood, "Outcome"), "Шёпот под кожей")
	assert_eq(_text(coin, "Cost"), "−25 золота")
	assert_eq(_text(coin, "Availability"), "Недостаточно золота")
	assert_eq(blood.get_node(blood.focus_neighbor_right), leave)
	coin.mouse_entered.emit()
	assert_eq(event.get_node("EventContext/Hint").text, "Недостаточно золота")
	coin.pressed.emit()
	assert_eq(RunState.gold, 24)
	assert_false(RunState.is_role_in_party("mage"))
	event.queue_free()
	await get_tree().process_frame
	_reset("whispering_well", 25)
	event = _open(WELL)
	coin = _card(event, "Choices/PayCoin")
	coin.pressed.emit()
	coin.pressed.emit()
	assert_eq(RunState.gold, 0)
	assert_true(RunState.is_role_in_party("mage"))
	assert_eq(_text(coin, "Availability"), "ВЫБРАНО")
	assert_string_contains(event.get_node("Result").text, "Теперь он идёт с вами")


func test_well_without_recruitment_shows_random_relic_and_preserves_party_on_exit() -> void:
	_reset("whispering_well", 25, "mage")
	var event := _open(WELL)
	assert_string_contains(_text(_card(event, "Choices/PayCoin"), "Outcome"), "случайную реликвию")
	var leave := _card(event, "Choices/Leave")
	assert_eq(_text(leave, "Outcome"), "Уйти без награды.")
	leave.pressed.emit()
	assert_true(RunState.is_role_in_party("mage"))
	assert_eq(RunState.gold, 25)


func test_tax_uses_live_discount_and_rescue_scar() -> void:
	_reset("bone_tax", 20, "mage")
	RunState.record_castle_fact(RunState.CASTLE_FACT_RATIONS, "false_weights")
	RunState.add_rescue_scar("knight")
	var event := _open(ACT)
	var gold := _card(event, "Panel/Choices/ChoiceA")
	var scar := _card(event, "Panel/Choices/ChoiceB")
	assert_eq(_text(gold, "Cost"), "−20 золота")
	assert_false(gold.disabled)
	assert_eq(_text(scar, "Cost"), "Без платы")
	assert_string_contains(_text(scar, "Outcome"), "при спасении рыцаря")
	scar.pressed.emit()
	assert_eq(RunState.gold, 20)
	assert_eq(_text(scar, "Availability"), "ВЫБРАНО")


func test_echo_displays_both_tradeoffs_and_specific_restrictions() -> void:
	_reset("unsent_letters", 100)
	RunState.defiance_order_ready = true
	var event := _open(ACT)
	var mail := _card(event, "Panel/Choices/ChoiceA")
	assert_eq(_text(mail, "Cost"), "−10 золота")
	assert_eq(_text(mail, "Availability"), "«Неповиновение» уже подготовлено")
	_reset("last_signal", 100)
	RunState.activate_wizard_debt()
	event = _open(ACT)
	var truth := _card(event, "Panel/Choices/ChoiceA")
	assert_string_contains(_text(truth, "Outcome"), "двойная награда будет потеряна")
	truth.pressed.emit()
	truth.pressed.emit()
	assert_false(RunState.wizard_debt_active)
	assert_eq(RunState.gold, 80)
	_reset("banner_seamstress", 100)
	event = _open(ACT)
	var bandages := _card(event, "Panel/Choices/ChoiceA")
	assert_string_contains(_text(bandages, "Outcome"), "+12 макс. HP")
	assert_string_contains(_text(bandages, "Outcome"), "−0,5 урона")
	assert_string_contains(_text(bandages, "Outcome"), "до конца забега")


func _reset(id: String, amount: int, role: String = "knight") -> void:
	RunState.reset_run()
	RunState.choose_protagonist(role)
	RunState.active_card_id = id
	RunState.gold = amount


func _open(scene: PackedScene) -> Control:
	var event := scene.instantiate() as Control
	add_child_autofree(event)
	return event


func _card(event: Control, path: String) -> Button:
	return event.get_node(path) as Button


func _text(card: Button, field: String) -> String:
	return (card.get_node("Copy/" + field) as Label).text
