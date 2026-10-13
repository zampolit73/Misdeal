extends Control

# F6 convenience: launch the complete authored battle UI for the NEW card.
# Keeps the normal start/class-select/table screens untouched.
func _ready() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append("bone_shepherd")
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card("bone_shepherd"):
		push_error("Could not prepare the Bone Shepherd card for local play.")
		return
	call_deferred("_enter_battle")

func _enter_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
