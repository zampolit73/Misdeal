extends Control

func _ready() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("ranger")
	RunState.gold = 50
	RunState.cards_resolved = 4
	RunState.current_offer_ids.assign(["jack","blood_ledger"])
	if RunState.choose_card("jack"):
		get_tree().call_deferred("change_scene_to_file","res://scenes/event/act_choice.tscn")
