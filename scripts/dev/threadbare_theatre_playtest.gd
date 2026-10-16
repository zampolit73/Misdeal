extends Control

# D153 reproducible REAL battle/Reward QA for released Act1 card #36.
const ARENA_FILE := "res://assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64"

func _ready() -> void:
	if RunState.ACT1_CARD_IDS.size() != 37 or not RunState.ACT1_CARD_IDS.has("threadbare_theatre"):
		_block("D153 must remain in the 37-card live Act1 pool.")
		return
	if not FileAccess.file_exists(ARENA_FILE):
		_block("Missing original D153 theatre arena: " + ARENA_FILE)
		return
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		_block("Could not set up Knight")
		return
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append("threadbare_theatre")
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card("threadbare_theatre"):
		_block("Released Threadbare Theatre card selection failed")
		return
	call_deferred("_enter_real_battle")


func _enter_real_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")


func _block(message: String) -> void:
	var label := Label.new()
	label.position = Vector2(100, 230)
	label.size = Vector2(1080, 220)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = "D153 / PLAYTEST BLOCKED\n\n" + message
	label.add_theme_font_size_override("font_size", 23)
	add_child(label)
