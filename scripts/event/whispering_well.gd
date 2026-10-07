extends Control

const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")

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
@onready var header_panel: Panel = $HeaderPanel
@onready var choices: HBoxContainer = $Choices

func _ready() -> void:
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
	_animate_screen_in()

func _refresh_choice_text() -> void:
	gold_label.text = "ЗОЛОТО %d   |   ОТРЯД %d/3   |   РАЗВИТИЕ %d   |   ДОП. %s   |   РЕЛИКВИИ %d" % [
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.get_extra_upgrade_progress_text(),
		RunState.artifact_ids.size()
	]

	if RunState.can_recruit_companion("mage"):
		accept_button.text = "ВЫТАЩИТЬ ЕГО КРОВЬЮ\n\n-20 здоровья отряду\nМАГ ПРИСОЕДИНИТСЯ"
		accept_button.disabled = false
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nВыкупить его у колодца\nМАГ ПРИСОЕДИНИТСЯ"
		pay_button.disabled = RunState.gold < 25
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
	var accept_texture: Texture2D = well_art
	var pay_texture: Texture2D = CARD_ART_CATALOG.get_reward_texture("relic_wager")

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
	leave_art.texture = well_art
	for art in [accept_art, pay_art, leave_art]:
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		art.visible = art.texture != null

	for button in [accept_button, pay_button, leave_button]:
		for style_name in ["normal", "hover", "pressed", "disabled"]:
			var source := button.get_theme_stylebox(style_name) as StyleBoxFlat
			if source == null:
				continue
			var styled := source.duplicate() as StyleBoxFlat
			styled.content_margin_top = 88.0
			styled.content_margin_bottom = 10.0
			button.add_theme_stylebox_override(style_name, styled)
		button.add_theme_font_size_override("font_size", 13)

	leave_art.modulate = Color(0.62, 0.70, 0.72, 0.74)

func _animate_screen_in() -> void:
	header_panel.pivot_offset = header_panel.size * 0.5
	header_panel.scale = Vector2(0.985, 0.985)
	header_panel.modulate.a = 0.0
	choices.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(header_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(header_panel, "modulate:a", 1.0, 0.16)
	tween.tween_property(choices, "modulate:a", 1.0, 0.24).set_delay(0.05)

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
		RunState.party_hp_bonus -= 20.0
		RunState.recruit_companion("mage", "Вы вытащили его из Шепчущего колодца собственной кровью.")
		RunState.resolve_whispering_well()
		result_label.text = "Вода становится чёрной. Молодой маг хватается за край и выбирается наружу.\nТеперь он идёт с вами."
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
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
