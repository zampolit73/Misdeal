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
	if active_card != null and active_card.card_id == "crypt_guard":
		_setup_elite_reward()
	else:
		_setup_normal_reward()

func _setup_normal_reward() -> void:
	title_label.text = "ВЫБЕРИТЕ НАГРАДУ"
	summary_label.text = "Мертвецы затихли. Волшебник предлагает ровно одну милость."

	blood_coin_button.pressed.connect(_choose_normal_reward.bind("blood_coin"))
	iron_ward_button.pressed.connect(_choose_normal_reward.bind("iron_ward"))
	tempered_steel_button.pressed.connect(_choose_normal_reward.bind("tempered_steel"))

func _setup_elite_reward() -> void:
	title_label.text = "ТРОФЕЙ СТРАЖА"
	summary_label.text = "Склеп открыт. Волшебник нехотя позволяет забрать одну реликвию."

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

func _choose_normal_reward(reward_id: String) -> void:
	_disable_reward_buttons()
	RunState.apply_reward(reward_id)
	await _finish_reward("Взято. У каждого дара за этим столом есть цена.")

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
