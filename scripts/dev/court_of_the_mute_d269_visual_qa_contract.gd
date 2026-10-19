extends Control

# D269 headless contract for real Battle QA ambience / D264 floor guide.
# This verifies native resource wiring and isolated toggles, NOT art quality.
const PREVIEW_SCENE := preload("res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn")
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const CARD_ID := "court_of_the_mute"


func _ready() -> void:
	call_deferred("_check")


func _check() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_abort("card #39 was inadvertently released")
		return
	var card: RunCardData = RunState.get_card(CARD_ID)
	if card == null or not card.target_path.is_empty():
		_abort("card #39 QA target path is no longer empty")
		return
	var preview := PREVIEW_SCENE.instantiate() as Control
	if preview == null:
		_abort("F6 Court preview scene missing")
		return
	add_child(preview)
	preview.call("_launch_real_battle")
	await get_tree().process_frame
	var battle := preview.get_node_or_null("Battle") as Control
	var atmosphere := preview.get_node_or_null("Battle/Arena") as Control
	var guide := preview.get_node_or_null("Battle/D269WalkableFloorGuide") as ColorRect
	if battle == null or atmosphere == null or guide == null:
		_abort("real F6 battle, ambience node or debug guide missing")
		return
	if guide.position != COURT_FLOOR.SCREEN_COMBAT_BOUNDS.position or guide.size != COURT_FLOOR.SCREEN_COMBAT_BOUNDS.size:
		_abort("green QA overlay no longer matches actual locked D264 floor")
		return
	if guide.visible or not bool(atmosphere.get("court_ambience_enabled")):
		_abort("D269 ambience defaults or hidden floor guide are wrong")
		return
	var backdrop := battle.get_node_or_null("BattleBackdrop")
	if backdrop == null or str(backdrop.get("arena_id")) != CARD_ID:
		_abort("D269 actual Battle uses a foreign arena plate")
		return

	var toggle := InputEventKey.new()
	toggle.pressed = true
	toggle.keycode = KEY_L
	preview.call("_unhandled_key_input", toggle)
	if bool(atmosphere.get("court_ambience_enabled")):
		_abort("L did not disable only Court extra atmosphere")
		return
	preview.call("_unhandled_key_input", toggle)
	if not bool(atmosphere.get("court_ambience_enabled")):
		_abort("L did not restore Court extra atmosphere")
		return
	toggle.keycode = KEY_G
	preview.call("_unhandled_key_input", toggle)
	if not guide.visible:
		_abort("G failed to display full exact lower stone floor")
		return
	preview.call("_unhandled_key_input", toggle)
	if guide.visible:
		_abort("G failed to hide QA floor overlay")
		return
	var court_units: Array = battle.get("units")
	if court_units.size() != 7 or battle.get("court_verdict_controller") == null:
		_abort("D269 visual inspector changed real Court actor/verdict contract")
		return
	print("D269_COURT_NATIVE_VISUAL_QA_PASS: actual F6 Battle renders Court QA plate, 7 original actors, D264 exact floor guide G and isolated ambience L, 38/45 live")
	get_tree().quit(0)


func _abort(reason: String) -> void:
	push_error("D269_COURT_NATIVE_VISUAL_QA_FAIL: " + reason)
	get_tree().quit(1)
