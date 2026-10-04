extends Control

@onready var summary_label: Label = $Summary
@onready var blood_coin_button: Button = $Rewards/BloodCoin
@onready var iron_ward_button: Button = $Rewards/IronWard
@onready var tempered_steel_button: Button = $Rewards/TemperedSteel

func _ready() -> void:
	blood_coin_button.pressed.connect(_choose_reward.bind("blood_coin"))
	iron_ward_button.pressed.connect(_choose_reward.bind("iron_ward"))
	tempered_steel_button.pressed.connect(_choose_reward.bind("tempered_steel"))

	summary_label.text = "Мертвецы затихли. Волшебник предлагает ровно одну милость."

func _choose_reward(reward_id: String) -> void:
	_disable_reward_buttons()
	RunState.apply_reward(reward_id)
	RunState.complete_active_card()
	summary_label.text = "Взято. У каждого дара за этим столом есть цена."
	await get_tree().create_timer(0.35).timeout

	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")

func _disable_reward_buttons() -> void:
	blood_coin_button.disabled = true
	iron_ward_button.disabled = true
	tempered_steel_button.disabled = true
