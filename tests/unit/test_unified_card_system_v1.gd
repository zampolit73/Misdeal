extends GutTest

const SKIN := preload("res://scripts/ui/unified_card_skin.gd")
const DEVELOP := preload("res://scripts/reward/hero_development.gd")
const TROPHY := preload("res://scripts/reward/elite_trophy.gd")
const WAGER := preload("res://scripts/reward/death_wager_view.gd")
const MERCHANT := preload("res://scripts/table/merchant_view.gd")
const FATE := preload("res://scenes/table/fate_spread_overlay.tscn")

func after_each() -> void:
	RunState.reset_run()

func _assert_face(button: Button) -> void:
	var face := button.get_node("UnifiedCardFrame") as TextureRect
	assert_eq(face.get_rect(), Rect2(Vector2.ZERO, button.size))
	assert_eq(face.texture, SKIN.face())
	assert_eq(face.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	var cta := button.get_node("UnifiedAction") as TextureRect
	assert_true(face.get_rect().encloses(cta.get_rect()))
	assert_eq(cta.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	for child in button.get_children():
		if child is Label:
			assert_true(face.get_rect().encloses(child.get_rect()), str(child.name))
			assert_lte(float(child.get_line_count() * child.get_line_height()), child.size.y + 1, child.text)

func test_development_and_wager_use_same_face_and_keep_real_selection() -> void:
	var art := SKIN.FRAME
	var view := DEVELOP.new()
	add_child_autofree(view)
	var offers: Array[Dictionary] = [
		{"index": 0, "title": "ЖЕЛЕЗНАЯ КЛЯТВА", "role": "РЫЦАРЬ", "art": art, "effect": "+65 HP  •  −15% СКОРОСТЬ АТАКИ", "tooltip": "Полные сведения"},
		{"index": 1, "title": "РАЗМАШИСТЫЙ УДАР", "role": "РЫЦАРЬ", "art": art, "effect": "45% СПЛЭШ  •  −12% СКОРОСТЬ АТАКИ", "tooltip": "Полные сведения"},
	]
	view.build(offers, "РАЗВИТИЕ", "I", "ПКМ")
	await get_tree().process_frame
	for button in view._buttons:
		_assert_face(button)
	watch_signals(view)
	view._buttons[1].pressed.emit()
	assert_signal_emitted_with_parameters(view, "chosen", [1])
	view.set_locked(true, 1)
	assert_eq(view._buttons[1].get_node("UnifiedAction/Caption").text, "ВЫБРАНО")
	assert_true(view._buttons[0].disabled)
	var wager := WAGER.new()
	add_child_autofree(wager)
	var ids: Array[String] = ["gold", "artifact:dead_mans_shield", "bonus_upgrade"]
	var rewards: Array[Dictionary] = [
		{"title": "ЗОЛОТОЙ КУШ", "description": "+60 золота"},
		{"title": "ЩИТ МЕРТВЕЦА", "description": "Защита от удара"},
		{"title": "УДВОИТЬ СТАВКУ", "description": "Получить ещё один выбор развития героя.\nДоп. развитие: 0/3"}
	]
	wager.build(ids, rewards, "ВЫИГРЫШ", "", "")
	await get_tree().process_frame
	for button in wager._buttons:
		_assert_face(button)
	watch_signals(wager)
	wager._buttons[0].pressed.emit()
	assert_signal_emitted_with_parameters(wager, "chosen", [0])

func test_elite_selection_is_not_confirmation() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var view := TROPHY.new()
	add_child_autofree(view)
	var ids: Array[String] = ["dead_mans_shield", "cracked_focus", "broken_crown"]
	view.build(ids, "РЕЛИКВИИ", "", SKIN.FRAME)
	await get_tree().process_frame
	for button in view._cards:
		_assert_face(button)
	watch_signals(view)
	view._cards[1].pressed.emit()
	assert_eq(view._selected, 1)
	assert_eq(view._cards[1].get_node("UnifiedAction/Caption").text, "ВЫБРАНО")
	assert_eq(view._cards[0].get_node("UnifiedAction/Caption").text, "ВЫБРАТЬ")
	assert_false(view._cards[1].has_node("SelectedAction"))
	assert_signal_not_emitted(view, "confirmed")
	view._confirm.pressed.emit()
	assert_signal_emitted_with_parameters(view, "confirmed", [1])

func test_merchant_purchase_plate_displays_real_price_and_disabled_reason() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.gold = 100
	RunState.camp_stop = {"slot": 8, "stock": ["relic/dead_mans_shield", "heal"], "sold": []}
	var view := MERCHANT.new()
	add_child_autofree(view)
	view.build("ТОРГОВЕЦ", "")
	await get_tree().process_frame
	var offer: Dictionary = view._offers["relic/dead_mans_shield"]
	assert_true(offer.plate.texture in [SKIN.button_texture("idle", false), SKIN.button_texture("hover", false)])
	assert_true(offer.price.visible)
	RunState.gold = 0
	view.refresh()
	assert_true(offer.button.disabled)
	assert_true(offer.status.visible)
	assert_false(offer.status.text.is_empty())
	assert_eq(offer.plate.texture, SKIN.button_texture("disabled", false))

func test_future_and_empty_held_miniatures_do_not_reveal_art() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var spread := FATE.instantiate()
	add_child_autofree(spread)
	await get_tree().process_frame
	for slot in spread.slot_panels:
		assert_null(slot.get_node("Art").texture)
		assert_eq(slot.get_node("DS3CardFrame").texture, SKIN.face(SKIN.MINI_SPLIT, true))
	assert_eq(spread.get_node("Frame/HeldPanel/DS3SidebarFrame").texture, SKIN.face(SKIN.MINI_SPLIT, true))
	assert_false(spread.boss_panel.visible)
	assert_false(spread.get_node("Frame/HeldPanel/DS3SidebarArtWell").visible)
	assert_eq(spread.get_node("Frame/DiscardPanel/CardLayer/DS3SidebarFrame").texture, SKIN.CARD_BACK)
	assert_null(spread.get_node("Frame/DiscardPanel/CardLayer/Art").texture)
	for slot in spread.slot_panels:
		assert_false(slot.get_node("DS3ArtWell").visible)

func test_v2_paper_assets_and_action_ink() -> void:
	assert_eq(SKIN.FRAME.get_size(), Vector2(512, 768))
	assert_eq(SKIN.CARD_BACK.get_size(), SKIN.FRAME.get_size())
	assert_eq(SKIN.UNKNOWN.get_size(), SKIN.FRAME.get_size())
	assert_ne(SKIN.FRAME, SKIN.UNKNOWN)
	assert_ne(SKIN.CARD_BACK, SKIN.UNKNOWN)
	var idle := SKIN.button_texture("idle").get_image()
	assert_lt(idle.get_pixel(128, 24).a, 0.01, "Unadorned central printed action")
	assert_gt(idle.get_pixel(128, 1).a, 0.3, "Thin printed rule is visible")
	assert_ne(SKIN.button_texture("idle"), SKIN.button_texture("hover"))
	assert_ne(SKIN.button_texture("pressed"), SKIN.button_texture("disabled"))
	var button := Button.new()
	add_child_autofree(button)
	button.size = Vector2(272, 338)
	var frame := SKIN.mount(button, Rect2(Vector2.ZERO, button.size))
	var action := SKIN.action(button, Rect2(20, 286, 232, 39))
	assert_eq(action.get_node("Caption").get_theme_color("font_color"), SKIN.INK)
	SKIN.refresh(button, frame, action, true)
	assert_true(frame.get_node("PaperFocus").visible)
	assert_eq(action.texture, SKIN.button_texture("pressed"))
