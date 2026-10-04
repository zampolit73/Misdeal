extends Control

@onready var title_label: Label = $Title
@onready var summary_label: Label = $Summary
@onready var blood_coin_button: Button = $Rewards/BloodCoin
@onready var iron_ward_button: Button = $Rewards/IronWard
@onready var tempered_steel_button: Button = $Rewards/TemperedSteel

var reward_buttons: Array[Button] = []

func _ready() -> void:
	reward_buttons = [blood_coin_button, iron_ward_button, tempered_steel_button]

	var active_card := RunState.get_active_card()
	if active_card != null and active_card.card_id == "death_wager":
		_setup_death_wager_reward()
	elif active_card != null and active_card.card_id == "crypt_guard":
		_setup_elite_reward()
	else:
		_setup_normal_reward()

func _setup_normal_reward() -> void:
	var multiplier := RunState.get_reward_multiplier()

	if multiplier > 1:
		title_label.text = "ДВОЙНАЯ НАГРАДА"
		summary_label.text = "Долг погашен. Волшебник нехотя удваивает обычную награду."
		blood_coin_button.text = "КРОВАВАЯ МОНЕТА\n\n+50 золота\n\nДолг делает щедрость особенно подозрительной."
		iron_ward_button.text = "ЖЕЛЕЗНЫЙ ОБЕРЕГ\n\n+40 здоровья\nкаждому герою\n\nСегодня металл весит вдвое больше."
		tempered_steel_button.text = "ЗАКАЛЁННАЯ СТАЛЬ\n\n+6 урона\nкаждому герою\n\nВолшебник держит слово. Это тревожнее обмана."
	else:
		title_label.text = "ВЫБЕРИТЕ НАГРАДУ"
		summary_label.text = "Мертвецы затихли. Волшебник предлагает ровно одну милость."

	blood_coin_button.pressed.connect(_choose_normal_reward.bind("blood_coin"))
	iron_ward_button.pressed.connect(_choose_normal_reward.bind("iron_ward"))
	tempered_steel_button.pressed.connect(_choose_normal_reward.bind("tempered_steel"))

func _setup_death_wager_reward() -> void:
	title_label.text = "ВЫИГРЫШ СТАВКИ"
	summary_label.text = "Волшебник хмурится. Ставка сыграла — выбирайте усиленную награду."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг волшебнику остаётся до следующей обычной награды."

	blood_coin_button.text = "ЗОЛОТОЙ КУШ\n\n+75 золота\n\nРедкий случай: выигрыш действительно ваш."
	iron_ward_button.text = "ПЛОТЬ ПОБЕДИТЕЛЯ\n\n+50 здоровья\nкаждому герою"
	tempered_steel_button.text = "СМЕРТЕЛЬНАЯ ЗАТОЧКА\n\n+8 урона\nкаждому герою"

	blood_coin_button.pressed.connect(_choose_death_wager_reward.bind("gold"))
	iron_ward_button.pressed.connect(_choose_death_wager_reward.bind("hp"))
	tempered_steel_button.pressed.connect(_choose_death_wager_reward.bind("damage"))

func _setup_elite_reward() -> void:
	title_label.text = "ТРОФЕЙ СТРАЖА"
	summary_label.text = "Склеп открыт. Волшебник нехотя позволяет забрать одну реликвию."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг остаётся до следующей обычной награды."

	var available := RunState.get_available_artifact_ids()
	if available.is_empty():
		blood_coin_button.text = "ОПУСТЕВШИЙ ТАЙНИК\n\n+50 золота\n\nВсе известные артефакты уже у вас."
		blood_coin_button.pressed.connect(_choose_elite_gold)
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

		button.text = "%s\n\n%s" % [artifact.title, artifact.description]
		button.pressed.connect(_choose_artifact_reward.bind(artifact_id))

func _choose_death_wager_reward(choice: String) -> void:
	_disable_reward_buttons()

	match choice:
		"gold":
			RunState.gold += 75
		"hp":
			RunState.party_hp_bonus += 50.0
		"damage":
			RunState.party_damage_bonus += 8.0
		_:
			return

	await _finish_reward("Ставка оплачена полностью. Волшебник явно жалеет, что предложил её.")

func _choose_normal_reward(reward_id: String) -> void:
	_disable_reward_buttons()
	var doubled := RunState.get_reward_multiplier() > 1
	RunState.apply_reward(reward_id)
	var message := "Долг погашен. Награда удвоена." if doubled else "Взято. У каждого дара за этим столом есть цена."
	await _finish_reward(message)

func _choose_artifact_reward(artifact_id: String) -> void:
	_disable_reward_buttons()
	if not RunState.add_artifact(artifact_id):
		return

	var artifact := RunState.get_artifact(artifact_id)
	await _finish_reward("Трофей ваш: %s." % artifact.title)

func _choose_elite_gold() -> void:
	_disable_reward_buttons()
	RunState.gold += 50
	await _finish_reward("Реликвий больше нет. Зато в тайнике нашлось 50 золота.")

func _finish_reward(message: String) -> void:
	RunState.complete_active_card()
	summary_label.text = message
	await get_tree().create_timer(0.35).timeout

	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")

func _disable_reward_buttons() -> void:
	for button in reward_buttons:
		button.disabled = true
