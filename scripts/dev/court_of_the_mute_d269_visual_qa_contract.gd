extends Control

# D269 headless contract for real Battle QA ambience / D264 floor guide.
# This verifies native resource wiring and isolated toggles, NOT art quality.
const PREVIEW_SCENE := preload("res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn")
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const CARD_ID := "court_of_the_mute"
const D270_ART_PATH := "res://assets/pixel/battle/arenas/court_of_the_mute_d270_empty_qa.svg"


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
	# New Court scene art is an authored SVG, no embedded sprite/UI raster:
	# record editability, dimensions and empty-stage resource wiring.
	var svg := FileAccess.get_file_as_string(D270_ART_PATH)
	if not svg.contains("<svg ") or not svg.contains("width=\"640\"") or svg.contains("<image ") or svg.contains("<text"):
		_abort("D270 empty editable 640px Court SVG file is malformed or has baked image/text")
		return
	var backdrop := battle.get_node_or_null("BattleBackdrop")
	if backdrop == null or str(backdrop.get("arena_id")) != CARD_ID:
		_abort("D269 actual Battle uses a foreign arena plate")
		return
	var image_texture := backdrop.texture as Texture2D
	if image_texture == null or image_texture.get_width() != 1280 or image_texture.get_height() != 720:
		_abort("D270 Court SVG failed to rasterize to exact 1280x720 in real Battle")
		return
	var pixels: Image = image_texture.get_image()
	if pixels == null or pixels.get_pixel(500, 650).a < 0.99 or pixels.get_pixel(640, 240).a < 0.99:
		_abort("D270 Court image is missing opaque throne or lower floor")
		return
	print("D270_COURT_EMPTY_SVG_NATIVE_PASS: actual Court Battle displays independent 1280x720 character-free editable vector QA, D264 floor untouched")

	# D270 B comparison must swap only Court texture, retain 1280×720 and
	# the prior D265 asset for rollback. Native Battle actors never change.
	var original_d270_texture: Texture2D = image_texture
	var art_event := InputEventKey.new()
	art_event.pressed = true
	art_event.keycode = KEY_B
	preview.call("_unhandled_key_input", art_event)
	if not bool(backdrop.get("court_qa_show_legacy")) or backdrop.texture == null or backdrop.texture == original_d270_texture:
		_abort("D270 B did not switch to tracked D265 rollback")
		return
	if backdrop.texture.get_width() != 1280 or backdrop.texture.get_height() != 720:
		_abort("D270 B fallback plate has wrong size")
		return
	preview.call("_unhandled_key_input", art_event)
	if bool(backdrop.get("court_qa_show_legacy")) or backdrop.texture == null or backdrop.texture.get_width() != 1280:
		_abort("D270 B failed to restore new empty stage")
		return
	print("D270_COURT_BACKGROUND_AB_NATIVE_PASS: D270 empty SVG and D265 original QA WebP toggled inside real Battle, no unit/bounds mutation")
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
