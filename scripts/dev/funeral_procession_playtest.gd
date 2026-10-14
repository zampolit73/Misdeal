extends Control

# Isolated dev-only D151 battle entry; not included in Act1 deal pool.
func _ready() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append("funeral_procession")
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card("funeral_procession"):
		push_error("Funeral Procession card unavailable for dev preview")
		return
	call_deferred("_enter_battle")

func _enter_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
