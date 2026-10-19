extends Control

# D269 headless contract for real Battle QA ambience / D264 floor guide.
# This verifies native resource wiring and isolated toggles, NOT art quality.
const PREVIEW_SCENE := preload("res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn")
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const CARD_ID := "court_of_the_mute"
const D271_ART_PATH := "res://assets/pixel/battle/arenas/court_of_the_mute_d271_painted_qa.webp.b64"
const D271_WEBP_SHA256 := "1eb45164d9c7418fb9c459d18c0640935452266aeecbb04d1e9d7bd527af8784"


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
	# D271 actual painted bitmap must be the exact verified source, never
	# the rejected D270 geometric SVG nor a downscaled gallery thumbnail.
	var encoded := FileAccess.get_file_as_string(D271_ART_PATH).strip_edges()
	var original_bytes := Marshalls.base64_to_raw(encoded)
	if original_bytes.size() < 100000 or original_bytes.sha256_text() != D271_WEBP_SHA256:
		_abort("D271 full-resolution painted WebP missing or byte mismatch")
		return
	var authored_image := Image.new()
	if authored_image.load_webp_from_buffer(original_bytes) != OK or authored_image.get_size() != Vector2i(1280, 720):
		_abort("D271 Court painted bitmap did not decode to 1280x720")
		return
	var backdrop := battle.get_node_or_null("BattleBackdrop")
	if backdrop == null or str(backdrop.get("arena_id")) != CARD_ID:
		_abort("D269 actual Battle uses a foreign arena plate")
		return
	var image_texture := backdrop.texture as Texture2D
	if image_texture == null or image_texture.get_width() != 1280 or image_texture.get_height() != 720:
		_abort("D271 Court painterly bitmap did not render 1280x720 in genuine Battle")
		return
	var pixels: Image = image_texture.get_image()
	if pixels == null or pixels.get_pixel(500, 650).a < 0.99 or pixels.get_pixel(640, 240).a < 0.99:
		_abort("D271 Court bitmap is missing its opaque architecture or legal lower floor")
		return
	print("D271_COURT_PAINTED_WEBP_NATIVE_PASS: actual Court Battle displays exact full-quality painted 1280x720 asset, D264 floor unchanged")

	# D271 B comparison must swap only backdrop textures, retain 1280x720
	# and the tracked D265 asset for rollback. Units and Court Verdict unchanged.
	var original_d271_texture: Texture2D = image_texture
	var art_event := InputEventKey.new()
	art_event.pressed = true
	art_event.keycode = KEY_B
	preview.call("_unhandled_key_input", art_event)
	if not bool(backdrop.get("court_qa_show_legacy")) or backdrop.texture == null or backdrop.texture == original_d271_texture:
		_abort("D271 B did not switch to tracked D265 rollback")
		return
	if backdrop.texture.get_width() != 1280 or backdrop.texture.get_height() != 720:
		_abort("D271 B fallback plate has wrong size")
		return
	preview.call("_unhandled_key_input", art_event)
	if bool(backdrop.get("court_qa_show_legacy")) or backdrop.texture == null or backdrop.texture.get_width() != 1280:
		_abort("D271 B failed to restore painted Court background")
		return
	if backdrop.texture.get_image().get_pixel(500, 650) != original_d271_texture.get_image().get_pixel(500, 650):
		_abort("D271 B did not restore original painted WebP image pixels")
		return
	print("D271_COURT_BACKGROUND_AB_NATIVE_PASS: painted D271 and original D265 toggle in genuine Battle with unchanged enemy/floor state")
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
