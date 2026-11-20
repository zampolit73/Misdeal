extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const TRAVEL_CATALOG := preload("res://scripts/travel/travel_catalog.gd")

const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const APPROVED_EVENT_CHOICE_ART := preload("res://scripts/ui/approved_event_choice_art.gd")
const CHOICE_VIEW := preload("res://scripts/ui/event_choice_presentation.gd")
const CHOICE_COPY := preload("res://scripts/event/event_choice_copy.gd")
const COIN_PRICE := 25

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
@onready var choices: HBoxContainer = $Choices

var choice_view := CHOICE_VIEW.new()


func _ready() -> void:
	add_child(choice_view)
	choice_view.track([accept_button, pay_button, leave_button])
	accept_button.pressed.connect(_on_accept_gift)
	pay_button.pressed.connect(_on_pay_coin)
	leave_button.pressed.connect(_on_leave)
	if RunState.can_recruit_companion("mage"):
		wizard_line.text = "«Ты слышишь его голос? В прошлый раз ты полез за ним.»"
		description_label.text = "Из чёрной воды зовёт молодой маг. Это не призрак — это момент, который вы однажды изменили."
	_refresh_choice_text()
	_apply_choice_art()
	for item: CanvasItem in [$Logo, $HudPanel, $HeaderPanel, $ResultPanel]:
		item.hide()
	$BackdropArt.load_webp_path("res://assets/pixel/event/v7/whispering_well.webp", Vector2i(1280, 720))
	$BackdropArt.modulate = Color.WHITE
	$BackdropShade.color = Color(0.025, 0.010, 0.015, 0.23)
	if accept_warning.visible:
		CHOICE_COPY.restrict(accept_button, accept_warning.text)
	if pay_warning.visible:
		CHOICE_COPY.restrict(pay_button, pay_warning.text)
	CHOICE_COPY.gold(pay_button, COIN_PRICE)
	for button in [accept_button, pay_button, leave_button]:
		CHOICE_COPY.prepare(button)
	choice_view.build(self, choices, $Title, wizard_line, description_label, result_label,
		[gold_label], [accept_button, pay_button, leave_button])


func _refresh_gold() -> void:
	gold_label.text = "ЗОЛОТО %d   |   ОТРЯД %d/3   |   РАЗВИТИЕ %d   |   ДОП. %s   |   РЕЛИКВИИ %d" % [
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.get_extra_upgrade_progress_text(),
		RunState.artifact_ids.size()
	]
	gold_label.tooltip_text = gold_label.text


func _refresh_choice_text() -> void:
	accept_warning.hide()
	pay_warning.hide()
	leave_warning.hide()
	_refresh_gold()

	if RunState.can_recruit_companion("mage"):
		accept_button.text = "ВЫТАЩИТЬ ЕГО КРОВЬЮ\n\n−12 макс. HP\nМаг присоединится.\nШёпот под кожей."
		accept_button.disabled = false
		pay_button.text = "БРОСИТЬ %d ЗОЛОТА\n\nМаг присоединится." % COIN_PRICE
		pay_button.disabled = RunState.gold < COIN_PRICE
		pay_warning.text = "Недостаточно золота"
		pay_warning.visible = pay_button.disabled
		leave_button.text = "ОТОЙТИ\n\nМаг будет потерян."
		return

	var gift_role := ""
	if RunState.can_claim_extra_hero_upgrade():
		gift_role = "mage"
		if RunState.get_next_extra_hero_upgrade_id(gift_role).is_empty():
			gift_role = RunState.get_least_developed_extra_role()

	if gift_role.is_empty():
		accept_button.text = "ПРИНЯТЬ ДАР\n\nКолодцу больше нечего изменить"
		accept_button.disabled = true
		accept_warning.text = "Нет доступного развития"
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
	pay_button.disabled = RunState.gold < COIN_PRICE or (not has_artifact and fallback_role.is_empty())
	if pay_button.disabled:
		pay_warning.text = "Недостаточно золота" if RunState.gold < COIN_PRICE else "Колодцу нечего предложить"
		pay_warning.visible = true

	if has_artifact:
		pay_button.text = "БРОСИТЬ %d ЗОЛОТА\n\nКолодец отдаст случайную реликвию" % COIN_PRICE
	elif not fallback_role.is_empty():
		var fallback_id := RunState.get_next_extra_hero_upgrade_id(fallback_role)
		var fallback_upgrade := RunState.get_hero_upgrade(fallback_id)
		pay_button.text = "БРОСИТЬ %d ЗОЛОТА\n\nРеликвий не осталось\n%s: %s" % [
			COIN_PRICE,
			_get_role_label(fallback_role),
			fallback_upgrade.title
		]
	else:
		pay_button.text = "БРОСИТЬ %d ЗОЛОТА\n\nКолодец молчит" % COIN_PRICE

	leave_button.text = "ОТОЙТИ ОТ КОЛОДЦА\n\nУйти без награды."

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


func _show_result() -> void:
	_refresh_gold()
	choice_view.show_result()


func _on_accept_gift() -> void:
	if accept_button.disabled:
		return

	if RunState.can_recruit_companion("mage"):
		_disable_choices()
		RunState.recruit_companion("mage", "Вы вытащили его из Шепчущего колодца собственной кровью. Шёпот остался под вашей кожей.")
		RunState.add_rescue_scar("mage")
		RunState.resolve_whispering_well()
		result_label.text = "Вода становится чёрной. Молодой маг выбирается наружу.\nШЁПОТ ПОД КОЖЕЙ: -12 макс. HP протагониста."
		_show_result()
		await get_tree().create_timer(0.8).timeout
		_return_to_table("rescue_blood")
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
	_show_result()
	await get_tree().create_timer(0.8).timeout
	_return_to_table("gift_upgrade")

func _on_pay_coin() -> void:
	if pay_button.disabled or RunState.gold < COIN_PRICE:
		return

	if RunState.can_recruit_companion("mage"):
		_disable_choices()
		RunState.gold -= COIN_PRICE
		RunState.recruit_companion("mage", "Вы выкупили его у Шепчущего колодца за двадцать пять монет.")
		RunState.resolve_whispering_well()
		result_label.text = "Монеты исчезают без всплеска. Колодец отпускает молодого мага.\nТеперь он идёт с вами."
		_show_result()
		await get_tree().create_timer(0.8).timeout
		_return_to_table("rescue_gold")
		return

	_disable_choices()
	RunState.gold -= COIN_PRICE

	var action := "pay_relic"
	var artifact_id := RunState.add_random_available_artifact()
	if artifact_id.is_empty():
		var upgrade_id := RunState.add_extra_upgrade_to_least_developed_role()
		if upgrade_id.is_empty():
			action = "pay_refund"
			RunState.gold += COIN_PRICE
			result_label.text = "Монета возвращается на край колодца. Ему больше нечего предложить."
		else:
			action = "pay_upgrade"
			var upgrade := RunState.get_hero_upgrade(upgrade_id)
			result_label.text = "Монета исчезает. Вместо реликвии вода переписывает героя.\n%s получает развитие: %s." % [
				_get_role_label(upgrade.target_role),
				upgrade.title
			]
	else:
		var artifact := RunState.get_artifact(artifact_id)
		result_label.text = "Монета исчезает без всплеска. Со дна всплывает реликвия: %s." % artifact.title

	RunState.resolve_whispering_well()
	_show_result()
	await get_tree().create_timer(0.8).timeout
	_return_to_table(action)

func _on_leave() -> void:
	if leave_button.disabled:
		return
	_disable_choices()
	var lost_mage := RunState.can_recruit_companion("mage")
	if lost_mage:
		RunState.lose_companion("mage", "Вы услышали его голос в колодце и всё равно отошли.")
	RunState.resolve_whispering_well()
	result_label.text = "Ты отходишь от края. Волшебник тихо смеётся."
	_show_result()
	await get_tree().create_timer(0.65).timeout
	_return_to_table("leave_lost" if lost_mage else "leave")

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

func _return_to_table(action: String) -> void:
	var travel := TRAVEL_CATALOG.context_for("whispering_well", "", RunState.party_roles,
		wizard_line.text, false, {"batch_03_action": action, "jack_companion": RunState.has_jack_companion()})
	RunState.complete_active_card()
	SCENE_ROUTER.after_resolution(self, travel)
