extends Control

# D197 full native gameplay route: battle → reward → table.
# Works while card #37 is QA-only (36/45) and after final release (37/45).
const ENCOUNTER_PATH := "res://resources/encounters/black_crossing.tres"
const ARENA_PATH := "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64"


func _ready() -> void:
	var live := RunState.ACT1_CARD_IDS.has("black_crossing")
	var expected_count := 37 if live else 36
	if RunState.ACT1_CARD_IDS.size() != expected_count:
		_block("Unexpected Act1 pool size for the current Black Crossing release phase.")
		return
	if RunState.CARD_PATHS.get("black_crossing", "") != "res://resources/cards/black_crossing.tres":
		_block("Black Crossing card lookup is missing.")
		return
	if not FileAccess.file_exists(ARENA_PATH):
		_block("D188 approved storm arena is missing.")
		return
	var encounter_resource: EncounterData = load(ENCOUNTER_PATH) as EncounterData
	if encounter_resource == null:
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
