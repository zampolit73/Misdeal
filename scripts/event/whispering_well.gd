extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const APPROVED_EVENT_CHOICE_ART := preload("res://scripts/ui/approved_event_choice_art.gd")
const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

@onready var wizard_line: Label = $WizardLine
@onready var description_label: Label = $Description
@onready var gold_label: Label = $GoldLabel
@onready var result_label: Label = $Result
@onready var accept_button: Button = $Choices/AcceptGift
@onready var pay_button: Button = $Choices/PayCoin
@onready var leave_button: Button = $Choices/Leave
@onready var accept_art: TextureRect = $Choices/AcceptGift/ChoiceArt
@onready var pay_art: TextureRect = $Choices/PayCoin/ChoiceArt
@onready var leave_art: TextureRect = $Choices/Leave/ChoiceArt
@onready var accept_warning: Label = $Choices/AcceptGift/Warning
@onready var pay_warning: Label = $Choices/PayCoin/Warning
@onready var leave_warning: Label = $Choices/Leave/Warning
@onready var header_panel: Panel = $HeaderPanel
@onready var choices: HBoxContainer = $Choices

func _ready() -> void:
	_apply_ui_kit()
	accept_button.pressed.connect(_on_accept_gift)
	pay_button.pressed.connect(_on_pay_coin)
	leave_button.pressed.connect(_on_leave)
	for button in [accept_button, pay_button, leave_button]:
		button.mouse_entered.connect(_on_choice_hover.bind(button, true))
		button.mouse_exited.connect(_on_choice_hover.bind(button, false))

	if RunState.can_recruit_companion("mage"):
		wizard_line.text = "«Ты слышишь его голос? В прошлый раз ты полез за ним.»"
		description_label.text = "Из чёрной воды зовёт молодой маг. Это не призрак — это момент, который вы однажды изменили."
	_refresh_choice_text()
	_apply_choice_art()
	_sync_v2_choice_copy()
	_animate_screen_in()

func _apply_ui_kit() -> void:
	# Adopt the approved DS2 event-preview geometry on existing live controls.
	# Preserve all RunState conditions and pressed handlers below.
	$Logo.visible = false
	$HudPanel.visible = false
	$BackdropArt.modulate = Color.WHITE
	$BackdropShade.color = Color(0.025, 0.010, 0.015, 0.65)
	MISDEAL_UI_KIT.apply_v2_material_plate(header_panel, true)
	_place_v2(header_panel, Vector2(168, 24), Vector2(944, 156))
	MISDEAL_UI_KIT.apply_v2_material_plate($ResultPanel)
	_place_v2($ResultPanel, Vector2(174, 608), Vector2(932, 87))

	var title: Label = $Title
	_place_v2(title, Vector2(194, 55), Vector2(892, 39))
	title.add_theme_font_size_override("font_size", 30)
	MISDEAL_UI_KIT.apply_screen_copy(title, MISDEAL_UI_KIT.PARCHMENT_WARM, true)

	# The original scene stores GoldLabel BEFORE HeaderPanel, so the new
	# opaque DS2 header would otherwise paint over this important counter.
	gold_label.z_index = 1
	_place_v2(gold_label, Vector2(196, 32), Vector2(888, 20))
	gold_label.add_theme_font_size_override("font_size", 12)
	MISDEAL_UI_KIT.apply_screen_copy(gold_label, MISDEAL_UI_KIT.AGED_BRONZE)

	_place_v2(wizard_line, Vector2(197, 97), Vector2(886, 27))
	wizard_line.add_theme_font_size_override("font_size", 14)
	MISDEAL_UI_KIT.apply_screen_copy(wizard_line, MISDEAL_UI_KIT.TEXT)

	# Reserve a real inset before the bronze header bottom (y=180).
	# Two-line event copy must remain above the cards at y=196.
	_place_v2(description_label, Vector2(198, 128), Vector2(884, 38))
	description_label.add_theme_font_size_override("font_size", 13)
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	MISDEAL_UI_KIT.apply_screen_copy(description_label, MISDEAL_UI_KIT.TEXT_SECONDARY)

	_place_v2(result_label, Vector2(198, 619), Vector2(884, 60))
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_label.add_theme_font_size_override("font_size", 15)
	MISDEAL_UI_KIT.apply_screen_copy(result_label, MISDEAL_UI_KIT.PARCHMENT_WARM)

	_place_v2(choices, Vector2(173, 196), Vector2(934, 394))
	choices.add_theme_constant_override("separation", 26)
	for index in range(3):
		_build_v2_choice_card(index)


func _build_v2_choice_card(index: int) -> void:
	var button: Button = [accept_button, pay_button, leave_button][index]
	button.custom_minimum_size = Vector2(292, 394)
	button.focus_mode = Control.FOCUS_ALL
	button.text = ""
	MISDEAL_UI_KIT.apply_v2_reward_card(button)
	# Connect before the gameplay handler so the chosen card is visibly
	# highlighted during the original result/return animation.
	button.pressed.connect(_highlight_v2_choice.bind(button))

	# Panels intentionally sit behind the original in-game ChoiceArt node.
	var art_frame := Panel.new()
	art_frame.name = "DS2ArtFrame"
	art_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(art_frame)
	button.move_child(art_frame, 0)
	_place_v2(art_frame, Vector2(14, 43), Vector2(264, 180))
	MISDEAL_UI_KIT.apply_v2_material_plate(art_frame)

	var paper := Panel.new()
	paper.name = "DS2Parchment"
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	paper.clip_contents = true
	button.add_child(paper)
	button.move_child(paper, 1)
	_place_v2(paper, Vector2(14, 233), Vector2(264, 147))
	MISDEAL_UI_KIT.apply_v2_parchment_plate(paper)

	var eyebrow := _make_v2_label(["I / КРОВЬ", "II / МОНЕТА", "III / ОТКАЗ"][index], 13, MISDEAL_UI_KIT.PARCHMENT_WARM)
	eyebrow.name = "DS2Eyebrow"
	button.add_child(eyebrow)
	_place_v2(eyebrow, Vector2(12, 12), Vector2(268, 22))

	var title := _make_v2_label("", 16, Color(0.18, 0.09, 0.07))
	title.name = "DS2Title"
	paper.add_child(title)
	_place_v2(title, Vector2(9, 8), Vector2(246, 43))

	var rule := ColorRect.new()
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rule.color = Color(0.40, 0.23, 0.13, 0.74)
	paper.add_child(rule)
	_place_v2(rule, Vector2(24, 54), Vector2(216, 1))

	var effect := _make_v2_label("", 14, Color(0.43, 0.18, 0.10))
	effect.name = "DS2Effect"
	paper.add_child(effect)
	_place_v2(effect, Vector2(10, 62), Vector2(244, 27))

	var detail := _make_v2_label("", 13, Color(0.22, 0.16, 0.13))
	detail.name = "DS2Detail"
	paper.add_child(detail)
	_place_v2(detail, Vector2(13, 93), Vector2(238, 45))

	var art: TextureRect = [accept_art, pay_art, leave_art][index]
	_place_v2(art, Vector2(20, 49), Vector2(252, 168))
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE

	button.get_node("ChoiceDivider").visible = false
	button.get_node("ChoiceBadge").visible = false
	var warning: Label = [accept_warning, pay_warning, leave_warning][index]
	_place_v2(warning, Vector2(26, 359), Vector2(240, 18))
	warning.add_theme_font_size_override("font_size", 11)
	MISDEAL_UI_KIT.apply_screen_copy(warning, MISDEAL_UI_KIT.STATUS_DANGER)


func _sync_v2_choice_copy() -> void:
	var buttons: Array[Button] = [accept_button, pay_button, leave_button]
	var warnings: Array[Label] = [accept_warning, pay_warning, leave_warning]
	var recruiting: bool = RunState.can_recruit_companion("mage")
	for index in range(buttons.size()):
		var button := buttons[index]
		# Capture the *live* offer before hiding Button.text. Actual
		# availability and costs are determined by _refresh_choice_text().
		var offer := button.text
		var sections := offer.split("\n\n", false, 1)
		var title := String(sections[0]).strip_edges()
		var detail := String(sections[1]).strip_edges() if sections.size() > 1 else ""
		var effect := ""
		if index == 0:
			if recruiting:
				effect = "−12 макс. HP"
				detail = "ШЁПОТ ПОД КОЖЕЙ\nМАГ ПРИСОЕДИНИТСЯ"
			elif button.disabled:
				effect = "Дар недоступен"
			else:
				effect = "−15 здоровья отряду"
				detail = detail.trim_prefix("-15 здоровья отряду").strip_edges()
		elif index == 1:
			effect = "−25 золота"
			if recruiting:
				detail = "Выкупить его у колодца\nМАГ ПРИСОЕДИНИТСЯ"
			detail = detail.trim_prefix("БРОСИТЬ 25 ЗОЛОТА").strip_edges()
		else:
			effect = "Без платы"
			detail = "МАГ БУДЕТ ПОТЕРЯН" if recruiting else "Уйти без награды"

		var paper: Panel = button.get_node("DS2Parchment")
		var heading: Label = paper.get_node("DS2Title")
		var effect_label: Label = paper.get_node("DS2Effect")
		var detail_label: Label = paper.get_node("DS2Detail")
		heading.text = title
		effect_label.text = effect
		detail_label.text = detail
		if detail.length() > 55:
			detail_label.add_theme_font_size_override("font_size", 11)
		elif detail.length() > 34:
			detail_label.add_theme_font_size_override("font_size", 12)
		else:
			detail_label.add_theme_font_size_override("font_size", 13)
		if warnings[index].visible:
			# Keep the reason fully visible instead of clipping a long
			# unavailable-offer description beneath the red warning label.
			detail_label.text = "Нет доступного дара" if index == 0 else "Обмен недоступен"
			detail_label.size.y = 24.0
			button.modulate = Color(0.75, 0.73, 0.71, 1.0)
		else:
			detail_label.size.y = 45.0
			button.modulate = Color.WHITE
		button.tooltip_text = offer
		button.text = ""



func _highlight_v2_choice(chosen: Button) -> void:
	for button: Button in [accept_button, pay_button, leave_button]:
		MISDEAL_UI_KIT.apply_v2_reward_card(button, button == chosen)


func _make_v2_label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.clip_text = true
	label.add_theme_font_size_override("font_size", font_size)
	MISDEAL_UI_KIT.apply_screen_copy(label, color)
	return label


func _place_v2(control: Control, at: Vector2, dimensions: Vector2) -> void:
	control.position = at
	control.size = dimensions


func _refresh_choice_text() -> void:
	accept_warning.visible = false
	pay_warning.visible = false
	leave_warning.visible = false
	gold_label.text = "ЗОЛОТО %d   |   ОТРЯД %d/3   |   РАЗВИТИЕ %d   |   ДОП. %s   |   РЕЛИКВИИ %d" % [
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.get_extra_upgrade_progress_text(),
		RunState.artifact_ids.size()
	]

	if RunState.can_recruit_companion("mage"):
		accept_button.text = "ВЫТАЩИТЬ ЕГО КРОВЬЮ\n\nШЁПОТ ПОД КОЖЕЙ • -12 макс. HP\nМАГ ПРИСОЕДИНИТСЯ"
		accept_button.disabled = false
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nВыкупить его у колодца\nМАГ ПРИСОЕДИНИТСЯ"
		pay_button.disabled = RunState.gold < 25
		pay_warning.text = "НЕДОСТАТОЧНО ЗОЛОТА"
		pay_warning.visible = pay_button.disabled
		leave_button.text = "ОТОЙТИ\n\nМАГ БУДЕТ ПОТЕРЯН"
		return

	var gift_role := ""
	if RunState.can_claim_extra_hero_upgrade():
		gift_role = "mage"
		if RunState.get_next_extra_hero_upgrade_id(gift_role).is_empty():
			gift_role = RunState.get_least_developed_extra_role()

	if gift_role.is_empty():
		accept_button.text = "ПРИНЯТЬ ДАР\n\nКолодцу больше нечего изменить"
		accept_button.disabled = true
		accept_warning.text = "НЕЧЕГО ИЗМЕНИТЬ"
		accept_warning.visible = true
	else:
		var upgrade_id := RunState.get_next_extra_hero_upgrade_id(gift_role)
		var upgrade := RunState.get_hero_upgrade(upgrade_id)
		accept_button.text = "ПРИНЯТЬ ДАР\n\n-15 здоровья отряду\n%s: %s" % [
			_get_role_label(gift_role),
			upgrade.title
		]

	var has_artifact := not RunState.get_available_artifact_ids().is_empty()
	var fallback_role := RunState.get_least_developed_extra_role()
	pay_button.disabled = RunState.gold < 25 or (not has_artifact and fallback_role.is_empty())
	if pay_button.disabled:
		pay_warning.text = "НЕДОСТАТОЧНО ЗОЛОТА" if RunState.gold < 25 else "НЕЧЕГО ПРЕДЛОЖИТЬ"
		pay_warning.visible = true

	if has_artifact:
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nКолодец отдаст случайную реликвию"
	elif not fallback_role.is_empty():
		var fallback_id := RunState.get_next_extra_hero_upgrade_id(fallback_role)
		var fallback_upgrade := RunState.get_hero_upgrade(fallback_id)
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nРеликвий не осталось\n%s: %s" % [
			_get_role_label(fallback_role),
			fallback_upgrade.title
		]
	else:
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nКолодец молчит"

	leave_button.text = "ОТОЙТИ ОТ КОЛОДЦА"

func _apply_choice_art() -> void:
	var well_art := CARD_ART_CATALOG.get_run_card_texture("whispering_well")
	var accept_texture: Texture2D = APPROVED_EVENT_CHOICE_ART.get_whispering_well_texture(0)
	var pay_texture: Texture2D = APPROVED_EVENT_CHOICE_ART.get_whispering_well_texture(1)
	var leave_texture: Texture2D = APPROVED_EVENT_CHOICE_ART.get_whispering_well_texture(2)
	if accept_texture == null:
		accept_texture = well_art
	if pay_texture == null:
		pay_texture = CARD_ART_CATALOG.get_reward_texture("relic_wager")
	if leave_texture == null:
		leave_texture = well_art

	if not RunState.can_recruit_companion("mage"):
		var gift_role := "mage"
		if not RunState.can_claim_extra_hero_upgrade() or RunState.get_next_extra_hero_upgrade_id(gift_role).is_empty():
			gift_role = RunState.get_least_developed_extra_role()
		if not gift_role.is_empty():
			var gift_upgrade_id := RunState.get_next_extra_hero_upgrade_id(gift_role)
			if not gift_upgrade_id.is_empty():
				accept_texture = CARD_ART_CATALOG.get_upgrade_texture(gift_upgrade_id)

		if RunState.get_available_artifact_ids().is_empty():
			var fallback_role := RunState.get_least_developed_extra_role()
			if not fallback_role.is_empty():
				var fallback_id := RunState.get_next_extra_hero_upgrade_id(fallback_role)
				if not fallback_id.is_empty():
					pay_texture = CARD_ART_CATALOG.get_upgrade_texture(fallback_id)

	accept_art.texture = accept_texture
	pay_art.texture = pay_texture
	leave_art.texture = leave_texture
	for art in [accept_art, pay_art, leave_art]:
		art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		art.material = null
		art.visible = art.texture != null

	# Keep the approved DS2 card styling instead of restoring legacy
	# oversized Button text margins from the old event scene.
	leave_art.modulate = Color(0.86, 0.89, 0.92, 0.91)


func _animate_screen_in() -> void:
	header_panel.pivot_offset = header_panel.size * 0.5
	header_panel.scale = Vector2(0.985, 0.985)
	header_panel.modulate.a = 0.0
	choices.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(header_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(header_panel, "modulate:a", 1.0, 0.16)
	tween.tween_property(choices, "modulate:a", 1.0, 0.20).set_delay(0.04)

	call_deferred("_animate_choice_cards_in")


func _animate_choice_cards_in() -> void:
	var cards: Array[Button] = [accept_button, pay_button, leave_button]
	var visible_index := 0
	for button in cards:
		if not button.visible:
			continue

		button.pivot_offset = button.size * 0.5
		button.scale = Vector2(0.985, 0.985)
		button.modulate.a = 0.0

		var card_tween := button.create_tween()
		card_tween.set_parallel(true)
		var delay := 0.05 + float(visible_index) * 0.05
		card_tween.tween_property(button, "scale", Vector2.ONE, 0.17).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		card_tween.tween_property(button, "modulate:a", 1.0, 0.14).set_delay(delay)
		visible_index += 1

func _on_choice_hover(button: Button, hovered: bool) -> void:
	if button.disabled:
		return
	button.pivot_offset = button.size * 0.5
	var tween := button.create_tween()
	tween.tween_property(button, "scale", Vector2(1.025, 1.025) if hovered else Vector2.ONE, 0.11).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_accept_gift() -> void:
	if accept_button.disabled:
		return

	if RunState.can_recruit_companion("mage"):
		_disable_choices()
		RunState.recruit_companion("mage", "Вы вытащили его из Шепчущего колодца собственной кровью. Шёпот остался под вашей кожей.")
		RunState.add_rescue_scar("mage")
		RunState.resolve_whispering_well()
		result_label.text = "Вода становится чёрной. Молодой маг выбирается наружу.\nШЁПОТ ПОД КОЖЕЙ: -12 макс. HP протагониста."
		await get_tree().create_timer(0.8).timeout
		_return_to_table()
		return

	var role := ""
	if RunState.can_claim_extra_hero_upgrade():
		role = "mage"
		if RunState.get_next_extra_hero_upgrade_id(role).is_empty():
			role = RunState.get_least_developed_extra_role()
	if role.is_empty():
		return

	var upgrade_id := RunState.add_next_extra_hero_upgrade(role)
	if upgrade_id.is_empty():
		return

	_disable_choices()
	RunState.party_hp_bonus -= 15.0
	RunState.resolve_whispering_well()

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	result_label.text = "Вода обжигает горло. Здоровье отряда -15.\n%s получает развитие: %s." % [
		_get_role_label(role),
		upgrade.title
	]
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_pay_coin() -> void:
	if pay_button.disabled or RunState.gold < 25:
		return

	if RunState.can_recruit_companion("mage"):
		_disable_choices()
		RunState.gold -= 25
		RunState.recruit_companion("mage", "Вы выкупили его у Шепчущего колодца за двадцать пять монет.")
		RunState.resolve_whispering_well()
		result_label.text = "Монеты исчезают без всплеска. Колодец отпускает молодого мага.\nТеперь он идёт с вами."
		await get_tree().create_timer(0.8).timeout
		_return_to_table()
		return

	_disable_choices()
	RunState.gold -= 25

	var artifact_id := RunState.add_random_available_artifact()
	if artifact_id.is_empty():
		var upgrade_id := RunState.add_extra_upgrade_to_least_developed_role()
		if upgrade_id.is_empty():
			RunState.gold += 25
			result_label.text = "Монета возвращается на край колодца. Ему больше нечего предложить."
		else:
			var upgrade := RunState.get_hero_upgrade(upgrade_id)
			result_label.text = "Монета исчезает. Вместо реликвии вода переписывает героя.\n%s получает развитие: %s." % [
				_get_role_label(upgrade.target_role),
				upgrade.title
			]
	else:
		var artifact := RunState.get_artifact(artifact_id)
		result_label.text = "Монета исчезает без всплеска. Со дна всплывает реликвия: %s." % artifact.title

	RunState.resolve_whispering_well()
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_leave() -> void:
	_disable_choices()
	if RunState.can_recruit_companion("mage"):
		RunState.lose_companion("mage", "Вы услышали его голос в колодце и всё равно отошли.")
	RunState.resolve_whispering_well()
	result_label.text = "Ты отходишь от края. Волшебник тихо смеётся."
	await get_tree().create_timer(0.65).timeout
	_return_to_table()

func _get_role_label(role: String) -> String:
	match role:
		"knight":
			return "РЫЦАРЬ"
		"ranger":
			return "СЛЕДОПЫТ"
		"mage":
			return "МАГ"
		_:
			return "ГЕРОЙ"

func _disable_choices() -> void:
	accept_button.disabled = true
	pay_button.disabled = true
	leave_button.disabled = true

func _return_to_table() -> void:
	RunState.complete_active_card()
	SCENE_ROUTER.change_to(self, "res://scenes/table/table.tscn")
