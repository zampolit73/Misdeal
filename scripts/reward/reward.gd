extends Control

@onready var title_label: Label = $Title
@onready var summary_label: Label = $Summary
@onready var hint_label: Label = $Hint
@onready var blood_coin_button: Button = $Rewards/BloodCoin
@onready var iron_ward_button: Button = $Rewards/IronWard
@onready var tempered_steel_button: Button = $Rewards/TemperedSteel

var reward_buttons: Array[Button] = []
var option_ids: Array[String] = ["", "", ""]
var reward_mode := ""

func _ready() -> void:
	reward_buttons = [blood_coin_button, iron_ward_button, tempered_steel_button]
	for index in range(reward_buttons.size()):
		reward_buttons[index].pressed.connect(_on_reward_button_pressed.bind(index))

	_setup_initial_reward()

func _setup_initial_reward() -> void:
	if RunState.is_major_upgrade_due_for_active_card():
		_setup_major_upgrade_reward()
	else:
		_setup_card_reward()

func _setup_major_upgrade_reward() -> void:
	reward_mode = "major_upgrade"
	_reset_buttons()

	var active_card := RunState.get_active_card()
	var tier_number := 1
	if active_card != null:
		tier_number = active_card.tier + 1

	title_label.text = "РАЗВИТИЕ ОТРЯДА"
	summary_label.text = "Первая победа этого этапа меняет одного героя. Выберите направление билда."
	hint_label.text = "Этап %d/3. Можно снова усиливать того же героя и собирать специализацию." % tier_number

	var offers := RunState.get_major_upgrade_offer_ids()
	_setup_upgrade_buttons(offers)

func _setup_bonus_upgrade_reward() -> void:
	reward_mode = "bonus_upgrade"
	_reset_buttons()
	title_label.text = "ЕЩЁ ОДНА СТАВКА"
	summary_label.text = "Вместо золота вы выторговали ещё одно изменение отряда."
	hint_label.text = "Это дополнительное улучшение не заменяет развитие этапа."

	var offers := RunState.get_bonus_upgrade_offer_ids()
	if offers.is_empty():
		RunState.gold += 60
		await _finish_reward("Больше менять нечего. Волшебник бросает вам 60 золота.")
		return

	_setup_upgrade_buttons(offers)

func _setup_upgrade_buttons(offers: Array[String]) -> void:
	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		if index >= offers.size():
			button.visible = false
			continue

		var upgrade_id := offers[index]
		var upgrade := RunState.get_hero_upgrade(upgrade_id)
		if upgrade == null:
			button.visible = false
			continue

		option_ids[index] = upgrade_id
		button.text = "%s\n\n%s\n\n%s" % [
			_get_role_label(upgrade.target_role),
			upgrade.title,
			upgrade.description
		]
		button.add_theme_color_override("font_color", _get_role_color(upgrade.target_role))
		button.add_theme_color_override("font_hover_color", _get_role_color(upgrade.target_role).lightened(0.16))

func _setup_card_reward() -> void:
	var active_card := RunState.get_active_card()
	if active_card != null and active_card.card_id == "death_wager":
		_setup_death_wager_reward()
	elif active_card != null and active_card.card_id == "crypt_guard":
		_setup_elite_reward()
	else:
		_setup_normal_loot()

func _setup_normal_loot() -> void:
	reward_mode = "normal_loot"
	_reset_buttons()

	var multiplier := RunState.get_reward_multiplier()
	var amount := 25 * multiplier

	title_label.text = "ДОБЫЧА"
	summary_label.text = "Развитие приходит редко. Золото — чаще."
	hint_label.text = "Золото тратится на событиях и в лавках."
	if multiplier > 1:
		title_label.text = "ДОЛГ ПОГАШЕН"
		summary_label.text = "Волшебник удваивает обычную добычу. На этот раз он держит слово."

	option_ids[0] = "blood_coin"
	blood_coin_button.text = "ЗАБРАТЬ ТРОФЕИ\n\n+%d золота\n\nБез вечных +HP и +урона. Только ресурс для следующих решений." % amount
	blood_coin_button.add_theme_color_override("font_color", Color(0.96, 0.78, 0.52, 1.0))
	iron_ward_button.visible = false
	tempered_steel_button.visible = false

func _setup_death_wager_reward() -> void:
	reward_mode = "death_wager"
	_reset_buttons()

	title_label.text = "ВЫИГРЫШ СТАВКИ"
	summary_label.text = "Вы пережили ставку. Теперь выбирайте, чем именно она окупится."
	hint_label.text = "Специальная награда не погашает ДОЛГ ВОЛШЕБНИКУ."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг остаётся до следующей обычной добычи."

	option_ids[0] = "gold"
	blood_coin_button.text = "ЗОЛОТОЙ КУШ\n\n+60 золота\n\nСамый безопасный способ забрать выигрыш."

	var artifacts := RunState.get_available_artifact_ids()
	artifacts.shuffle()
	if artifacts.is_empty():
		option_ids[1] = "fallback_gold"
		iron_ward_button.text = "ПУСТОЙ ТАЙНИК\n\n+50 золота\n\nВсе известные реликвии уже у вас."
	else:
		var artifact_id := artifacts[0]
		var artifact := RunState.get_artifact(artifact_id)
		option_ids[1] = "artifact:%s" % artifact_id
		iron_ward_button.text = "РЕЛИКВИЯ СТАВКИ\n\n%s\n\n%s" % [artifact.title, artifact.description]

	if RunState.can_claim_extra_hero_upgrade():
		option_ids[2] = "bonus_upgrade"
		tempered_steel_button.text = "УДВОИТЬ СТАВКУ\n\nПолучить ещё один выбор развития героя.\n\nДоп. развитие: %s" % RunState.get_extra_upgrade_progress_text()
	else:
		option_ids[2] = "extra_cap_gold"
		tempered_steel_button.text = "ПРЕДЕЛ ДОСТИГНУТ\n\nДоп. развитие %s\n\n+45 золота вместо усиления" % RunState.get_extra_upgrade_progress_text()

func _setup_elite_reward() -> void:
	reward_mode = "elite_artifact"
	_reset_buttons()

	title_label.text = "ТРОФЕЙ СТРАЖА"
	summary_label.text = "Склеп открыт. Волшебник нехотя позволяет забрать одну реликвию."
	hint_label.text = "Реликвии дополняют билд героя, но не заменяют его развитие."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг остаётся до следующей обычной добычи."

	var available := RunState.get_available_artifact_ids()
	if available.is_empty():
		option_ids[0] = "elite_gold"
		blood_coin_button.text = "ОПУСТЕВШИЙ ТАЙНИК\n\n+50 золота\n\nВсе известные артефакты уже у вас."
		iron_ward_button.visible = false
		tempered_steel_button.visible = false
		return

	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		if index >= available.size():
			button.visible = false
			continue

		var artifact_id: String = available[index]
		var artifact := RunState.get_artifact(artifact_id)
		if artifact == null:
			button.visible = false
			continue

		option_ids[index] = artifact_id
		button.text = "%s\n\n%s" % [artifact.title, artifact.description]

func _on_reward_button_pressed(index: int) -> void:
	if index < 0 or index >= reward_buttons.size():
		return
	if not reward_buttons[index].visible or option_ids[index].is_empty():
		return

	_disable_reward_buttons()
	var option_id := option_ids[index]

	match reward_mode:
		"major_upgrade":
			if not RunState.claim_major_upgrade(option_id):
				_enable_reward_buttons()
				return

			var upgrade := RunState.get_hero_upgrade(option_id)
			summary_label.text = "Выбрано: %s." % upgrade.title
			await get_tree().create_timer(0.22).timeout
			_setup_card_reward()

		"bonus_upgrade":
			if not RunState.claim_bonus_upgrade(option_id):
				_enable_reward_buttons()
				return

			var upgrade := RunState.get_hero_upgrade(option_id)
			await _finish_reward("Ставка изменила героя: %s." % upgrade.title)

		"normal_loot":
			RunState.apply_reward("blood_coin")
			await _finish_reward("Трофеи забраны. Остальное придётся выторговать у стола.")

		"death_wager":
			await _resolve_death_wager_option(option_id)

		"elite_artifact":
			await _resolve_elite_option(option_id)

func _resolve_death_wager_option(option_id: String) -> void:
	match option_id:
		"gold":
			RunState.gold += 60
			await _finish_reward("Ставка оплачена золотом. Волшебник явно жалеет, что предложил её.")
		"fallback_gold":
			RunState.gold += 50
			await _finish_reward("Реликвий не осталось. Вы забираете ещё 50 золота.")
		"bonus_upgrade":
			await get_tree().create_timer(0.18).timeout
			_setup_bonus_upgrade_reward()
		"extra_cap_gold":
			RunState.gold += 45
			await _finish_reward("Новых поблажек не будет. Волшебник бросает 45 золота вместо ещё одного изменения.")
		_:
			if not option_id.begins_with("artifact:"):
				_enable_reward_buttons()
				return

			var artifact_id := option_id.substr("artifact:".length())
			if not RunState.add_artifact(artifact_id):
				_enable_reward_buttons()
				return

			var artifact := RunState.get_artifact(artifact_id)
			await _finish_reward("Ставка оплачена реликвией: %s." % artifact.title)

func _resolve_elite_option(option_id: String) -> void:
	if option_id == "elite_gold":
		RunState.gold += 50
		await _finish_reward("Реликвий больше нет. Зато в тайнике нашлось 50 золота.")
		return

	if not RunState.add_artifact(option_id):
		_enable_reward_buttons()
		return

	var artifact := RunState.get_artifact(option_id)
	await _finish_reward("Трофей ваш: %s." % artifact.title)

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

func _get_role_color(role: String) -> Color:
	match role:
		"knight":
			return Color(0.72, 0.84, 0.98, 1.0)
		"ranger":
			return Color(0.66, 0.90, 0.58, 1.0)
		"mage":
			return Color(0.86, 0.66, 1.0, 1.0)
		_:
			return Color(0.94, 0.82, 0.62, 1.0)

func _reset_buttons() -> void:
	option_ids = ["", "", ""]
	for button in reward_buttons:
		button.visible = true
		button.disabled = false
		button.remove_theme_color_override("font_color")
		button.remove_theme_color_override("font_hover_color")

func _enable_reward_buttons() -> void:
	for button in reward_buttons:
		if button.visible:
			button.disabled = false

func _disable_reward_buttons() -> void:
	for button in reward_buttons:
		button.disabled = true

func _finish_reward(message: String) -> void:
	RunState.complete_active_card()
	summary_label.text = message
	await get_tree().create_timer(0.35).timeout

	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")
