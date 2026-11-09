extends GutTest
const ART := preload("res://scripts/ui/card_art_catalog.gd")
const UPGRADES := ["knight_iron_oath", "knight_executioner", "knight_cleaver", "ranger_arrowstorm", "ranger_longshot", "ranger_beast_trail", "mage_glass_heart", "mage_overload", "mage_wildfire"]

func after_each() -> void:
	RunState.reset_run()

func _party() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "visual regression")
	RunState.recruit_companion("mage", "visual regression")

func _open(path: String) -> Control:
	var scene := load(path).instantiate() as Control
	add_child_autofree(scene)
	return scene

func _snapshot() -> Array:
	return [RunState.gold, RunState.hero_upgrade_ids.duplicate(), RunState.artifact_ids.duplicate(), RunState.party_roles.duplicate(), RunState.cards_resolved]

func test_approved_artwork_is_unchanged_including_all_three_live_hero_sources() -> void:
	var locks: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://docs/qa/visual_polish/art-locks.json"))
	assert_gte(locks.size(),20)
	for path in locks:
		var bytes := FileAccess.get_file_as_bytes("res://" + path)
		if locks[path].base64: bytes = Marshalls.base64_to_raw(bytes.get_string_from_utf8())
		var hash := HashingContext.new()
		hash.start(HashingContext.HASH_SHA256)
		hash.update(bytes)
		assert_eq(hash.finish().hex_encode(), locks[path].sha256, path)

func test_all_nine_reward_effects_fit_both_lines_inside_actual_painted_strip() -> void:
	_party()
	RunState.active_card_id = "bone_patrol"
	var reward := _open("res://scenes/reward/reward.tscn")
	await get_tree().process_frame
	for id in UPGRADES:
		reward.call("_set_upgrade_card",0,id,RunState.get_hero_upgrade(id))
		await get_tree().process_frame
		await get_tree().process_frame
		var label := reward.get_node("Rewards/BloodCoin/QuickEffect") as Label
		assert_true(Rect2(48,282,220,32).encloses(label.get_rect()),id)
		assert_lte(label.get_line_count(),2,id)
		assert_lte(label.get_line_count() * label.get_theme_font("font").get_height(label.get_theme_font_size("font_size")),label.size.y + 0.1,id)
		assert_gte(label.get_theme_font_size("font_size"),10)
	assert_eq(reward.get_node("BackdropReadouts/Deck").text,"%02d" % RunState.remaining_card_ids.size())
	assert_eq(reward.get_node("BackdropReadouts/Context").mouse_filter,Control.MOUSE_FILTER_IGNORE)
	assert_eq(reward.get_node("WizardBackdrop").get("webp_path"),"res://assets/pixel/table/d416_clean_center/table_clean.webp")

func test_reward_full_reader_preserves_state_owns_keyboard_focus_and_blocks_choice_behind_it() -> void:
	_party()
	RunState.active_card_id = "bone_patrol"
	var reward := _open("res://scenes/reward/reward.tscn")
	await get_tree().process_frame
	var button := reward.get_node("Rewards/BloodCoin") as Button
	button.grab_focus()
	var before := _snapshot()
	var input := InputEventKey.new()
	input.keycode = KEY_F
	input.pressed = true
	button.gui_input.emit(input)
	var reader := reward.get("_details") as Control
	assert_not_null(reader)
	assert_eq(reader.get_node("Frame/FullDescription").text,button.tooltip_text)
	assert_eq(get_viewport().gui_get_focus_owner(),reader.get_node("Frame/CloseButton"))
	await get_tree().process_frame
	var bottom := InputEventKey.new()
	bottom.pressed = true
	bottom.keycode = KEY_END
	reader.call("_input", bottom)
	var bar := (reader.get_node("Frame/FullDescription") as RichTextLabel).get_v_scroll_bar()
	assert_almost_eq(bar.value,maxf(bar.min_value,bar.max_value-bar.page),0.1)
	reward.call("_on_reward_button_pressed",0)
	assert_eq(_snapshot(),before)
	reader.call("close")
	await get_tree().process_frame
	assert_eq(get_viewport().gui_get_focus_owner(),button)
	assert_eq(_snapshot(),before)

func test_shop_uses_real_offer_art_and_resolved_states_match_a_real_purchase() -> void:
	_party()
	RunState.gold = 100
	RunState.active_card_id = "gravedigger_shop"
	var shop := _open("res://scenes/event/act_choice.tscn")
	var button := shop.get_node("Panel/Choices/ChoiceA") as Button
	var id := String(button.get_meta("choice_upgrade_id",""))
	assert_false(id.is_empty())
	assert_true(button.get_node("ChoiceArt").texture.get_image().get_data() == ART.get_upgrade_texture(id).get_image().get_data())
	var price := RunState.get_gravedigger_shop_price()
	var before := _snapshot()
	button.pressed.emit()
	assert_eq(RunState.gold,100-price)
	assert_true(RunState.has_hero_upgrade(id))
	assert_eq(button.get_node("DS2Parchment/PurchaseStatus").text,"ВЫБРАНО")
	for name in ["ChoiceA","ChoiceB","ChoiceC"]:
		var offer := shop.get_node("Panel/Choices/"+name) as Button
		assert_true(offer.disabled)
		assert_false(offer.get_node("DS2Parchment/PurchaseStatus").text.contains("ДОСТУПНО"))
	var after := _snapshot()
	preload("res://scripts/event/gravedigger_shop_ds2.gd").show_result(shop)
	assert_eq(_snapshot(),after)
	assert_ne(before,after)
	assert_false((shop.get_node("BackdropReadouts/Deck") as Control).get_global_rect().intersects((shop.get_node("Panel/Choices/ChoiceA") as Control).get_global_rect()))
	assert_eq(shop.get_node("BackdropReadouts/Deck").text,"%02d" % maxi(0,RunState.remaining_card_ids.size()-RunState.current_offer_ids.size()))
	assert_eq(shop.get_node("ShopDS2Backdrop").get("webp_path"),"res://assets/pixel/table/d416_clean_center/table_clean.webp")

func test_resolved_story_choices_do_not_advertise_available_actions() -> void:
	_party()
	RunState.active_card_id = "moon_seal"
	var event := _open("res://scenes/event/act_choice.tscn")
	event.get_node("Panel/Choices/ChoiceA").pressed.emit()
	for name in ["ChoiceA","ChoiceB","ChoiceC"]:
		assert_eq(event.get_node("Panel/Choices/"+name+"/DS2EventParchment/Availability").text,"ВЫБОР ЗАВЕРШЁН")
	assert_true(event.get_node("Panel/ContinueButton").visible)

func test_full_run_summary_scrolls_inside_its_panel_and_leaves_new_run_clear() -> void:
	_party()
	for id in UPGRADES: RunState.add_hero_upgrade(id)
	for id in ["dead_mans_shield","cracked_focus","broken_crown","blind_quiver"]: RunState.add_artifact(id)
	var before := _snapshot()
	var ending := _open("res://scenes/run_end/run_end.tscn")
	await get_tree().create_timer(0.8).timeout
	var scroll := ending.get_node("SummaryScroll") as ScrollContainer
	var label := scroll.get_node("Summary") as Label
	assert_gt(label.size.y,scroll.size.y)
	assert_true((ending.get_node("SummaryPanel") as Control).get_global_rect().encloses(scroll.get_global_rect()))
	assert_false(scroll.get_global_rect().intersects((ending.get_node("NewRunButton") as Control).get_global_rect()))
	for id in UPGRADES: assert_true(label.text.contains(RunState.get_hero_upgrade(id).title))
	scroll.scroll_vertical = 100000
	await get_tree().process_frame
	assert_gt(scroll.scroll_vertical,0)
	assert_true(label.text.contains("Последняя сделка"))
	assert_eq(_snapshot(),before)

func test_story_and_merchant_effect_paragraphs_keep_the_entire_real_modifier_visible() -> void:
	_party()
	RunState.gold = 100
	RunState.active_card_id = "blood_ledger"
	var event := _open("res://scenes/event/act_choice.tscn")
	await get_tree().process_frame
	var button := event.get_node("Panel/Choices/ChoiceA") as Button
	var id := String(button.get_meta("choice_upgrade_id",""))
	assert_false(id.is_empty())
	var detail := button.get_node("DS2EventParchment/ChoiceDetail") as Label
	assert_true(detail.text.contains(RunState.get_hero_upgrade(id).description))
	assert_lte(detail.get_line_count() * detail.get_theme_font("font").get_height(detail.get_theme_font_size("font_size")),detail.size.y)
	RunState.active_card_id = "gravedigger_shop"
	var shop := _open("res://scenes/event/act_choice.tscn")
	await get_tree().process_frame
	var offer := shop.get_node("Panel/Choices/ChoiceA") as Button
	var upgrade := RunState.get_hero_upgrade(String(offer.get_meta("choice_upgrade_id","")))
	var body := offer.get_node("DS2Parchment/UpgradeDetail") as Label
	assert_true(body.text.contains(upgrade.description))
	assert_lte(body.get_line_count() * body.get_theme_font("font").get_height(body.get_theme_font_size("font_size")),body.size.y)

func test_victory_action_draws_in_front_of_its_result_scrim() -> void:
	_party()
	RunState.active_card_id = "bone_patrol"
	RunState.select_encounter("res://resources/encounters/bone_patrol.tres")
	var battle := _open("res://scenes/battle/battle.tscn")
	battle.call("_finish_battle",true)
	var button := battle.get_node("ResultOverlay/ContinueButton") as Button
	var scrim := battle.get_node("ResultOverlay/ResultScrim") as Control
	assert_true(button.visible)
	assert_false(button.disabled)
	assert_true(button.get_canvas() == scrim.get_canvas())
	assert_gt(button.z_index,scrim.z_index)
	assert_eq(button.position,Vector2(964,619))
	assert_false(button.pressed.get_connections().is_empty())
