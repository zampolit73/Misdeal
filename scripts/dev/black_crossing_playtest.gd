extends Control

# D188 reproducible QA-only full gameplay route: battle → reward → table.
# Card is registered in CARD_PATHS for QA but intentionally NOT ACT1_CARD_IDS.
const ENCOUNTER_PATH := "res://resources/encounters/black_crossing.tres"
const ARENA_PATH := "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64"


func _ready() -> void:
	if RunState.ACT1_CARD_IDS.size() != 36 or RunState.ACT1_CARD_IDS.has("black_crossing"):
		_block("D188 must stay outside the 36-card random pool.")
		return
	if RunState.CARD_PATHS.get("black_crossing", "") != "res://resources/cards/black_crossing.tres":
		_block("D188 QA-only Black Crossing card path is missing.")
		return
	if not FileAccess.file_exists(ARENA_PATH):
		_block("D188 approved storm arena is missing.")
		return
	if load(ENCOUNTER_PATH) as EncounterData == null:
		_block("D188 original Black Crossing encounter failed to load.")
		return
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		_block("D188 could not select Knight.")
		return
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append("black_crossing")
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card("black_crossing"):
		_block("D188 QA-only Black Crossing card could not be selected.")
		return
	if RunState.selected_encounter_path != ENCOUNTER_PATH:
		_block("D188 card choice did not route to Black Crossing.")
		return
	call_deferred("_enter_battle")


func _enter_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")


func _block(message: String) -> void:
	var label := Label.new()
	label.position = Vector2(120, 260)
	label.size = Vector2(1040, 230)
	label.text = "D188 / PLAYTEST BLOCKED\n\n" + message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(0.95, 0.40, 0.34))
	add_child(label)
	push_error(message)
