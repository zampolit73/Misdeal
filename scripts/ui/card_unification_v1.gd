extends RefCounted

# Optional Wave 1 art overrides. Legacy atlases stay authoritative unless a
# separately packaged, approved 448x274/608x388 WebP exists on disk.
# This file contains no gameplay or UI layout changes.
const ROOT := "res://assets/pixel/card_unification_v1"

# D147: approved full-bleed raster takes priority; keep legacy SVG as a safe fallback.
const BONE_SHEPHERD_CARD_SVG := "res://assets/pixel/card_unification_v1/run/bone_shepherd.svg"
# D152 D168-approved scene-led illustration v2 (448x274); original v1 remains tracked for rollback.
# Export-safe WebP bytes are in GitHub, no manual ZIP steps required.
const D152_CARD_WEBP_B64 := "res://assets/pixel/card_unification_v1/run/defiled_laboratory_scene_v2.webp.b64"
# D153 chosen 3rd scene concept, QA preview ONLY; NOT in ACT1_CARD_IDS.
const D153_CARD_WEBP_B64 := "res://assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64"
# D182 candidate art only; card #37 remains unavailable in normal deck.
const D182_CARD_WEBP_B64 := "res://assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64"
# D200: card #38 user-selected THIRD image, 448x274 scene artwork; QA ONLY.
const D200_CARD_WEBP_B64 := "res://assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64"
# D261: user explicitly selected SECOND Court of the Mute art, QA only. No #39 release.
const D261_COURT_CARD_WEBP_B64 := "res://assets/pixel/card_unification_v1/run/court_of_the_mute_selected_v1.webp.b64"

const RUN_CARDS := {
	# D331 user-approved individual card scene compositions.
	"bone_crush": "run/bone_crush_d331_approved_option2.webp",
	"blood_ledger": "run/blood_ledger_d331_approved_scribe.webp",
	# D319 user-picked third Black Altar painting, derived from approved triptych.
	"black_altar": "run/black_altar_d319_option3.webp",
	"bone_patrol": "run/bone_patrol_d333_approved_tower.webp",
	# D335: user-approved third, restrained pixel-art necromancer courtyard ritual.
	"bone_ritual": "run/bone_ritual_d335_approved_option3.webp",
	"bone_shepherd": "run/bone_shepherd.webp",
	# D151 candidate; not dealt until both original enemy atlases pass native F6 review.
	"funeral_procession": "run/funeral_procession.webp",
	# D150: two original painterly 448x274 scene illustrations.
	"moon_seal": "run/moon_seal.webp",
	"echo_crypt": "run/echo_crypt.webp",
	# D336 user-confirmed FIRST Graveyard Ambush image; preserve old WebP as fallback.
	"graveyard_ambush": "run/graveyard_ambush_d336_approved_option1.webp",
	# D337: approved FIRST Gallows Volley concept; crop keeps all 3 skeletons + gallows.
	"gallows_volley": "run/gallows_volley_d337_approved_option1.webp",
	# D340: FIRST of the final three ghost-reflection wells: face in black water.
	"whispering_well": "run/whispering_well_d340_approved_option1.webp",
	# D341: user-approved live elderly gravedigger, minimally cleaned background, original colors.
	"gravedigger_shop": "run/gravedigger_shop_d341_approved_cleansed_scene.webp",
	# D342: approved Ash Rest sunset camp after removing the distant valley ruins.
	"ash_rest": "run/ash_rest_d342_approved_clean_horizon.webp",
	# D343: user-approved close-up of a dead hand, gold purse, HEAD OUT OF FRAME.
	"lost_purse": "run/lost_purse_d343_approved_headless_corpse.webp",
	# D344: approved candle merchant, thin muted candles, gothic candle cabinet behind.
	"candle_seller": "run/candle_seller_d344_approved_slim_candles_new_cabinet.webp",
	# D338: user-selected SECOND of the final swamp-swarm pair; four melee raiders.
	"bone_swarm": "run/bone_swarm_d338_approved_option2.webp",
	# D339: user-approved THIRD Grave Crossfire scene (2 flanking archers, 1 guard).
	"grave_crossfire": "run/grave_crossfire_d339_approved_option3.webp",
}

const EVENTS := {
	"curse_forge": "event/curse_forge.webp",
	"black_altar": "event/black_altar.webp",
	"chained_prisoner": "event/chained_prisoner.webp",
	"rattling_bridge": "event/rattling_bridge.webp",
	"candle_seller": "event/candle_seller.webp",
	"last_camp": "event/last_camp.webp",
}

const UPGRADES := {
	"knight_iron_oath": "upgrade/knight_iron_oath.webp",
	"ranger_arrowstorm": "upgrade/ranger_arrowstorm.webp",
	"mage_glass_heart": "upgrade/mage_glass_heart.webp",
}

const REWARDS := {
	"gold_windfall": "reward/gold_windfall.webp",
	"relic_wager": "reward/relic_wager.webp",
}

static var _texture_cache: Dictionary = {}

static func get_run_texture(card_id: String) -> Texture2D:
	if card_id == "court_of_the_mute":
		return _get_d261_selected_texture()
	if card_id == "black_lantern_road":
		return _get_d200_candidate_texture()
	if card_id == "black_crossing":
		return _get_d182_candidate_texture()
	if card_id == "threadbare_theatre":
		return _get_d153_candidate_texture()
	if card_id == "defiled_laboratory":
		return _get_d152_card_texture()
	if card_id == "bone_shepherd":
		var approved_raster := _get_texture(RUN_CARDS, card_id, Vector2i(448, 274))
		if approved_raster != null:
			return approved_raster
		if not _texture_cache.has(BONE_SHEPHERD_CARD_SVG):
			var unique_art := load(BONE_SHEPHERD_CARD_SVG) as Texture2D
			if unique_art == null or unique_art.get_size() != Vector2(448, 274):
				push_error("Bone Shepherd original card illustration missing or invalid.")
				return null
			_texture_cache[BONE_SHEPHERD_CARD_SVG] = unique_art
		return _texture_cache[BONE_SHEPHERD_CARD_SVG] as Texture2D
	if card_id == "moon_seal" or card_id == "echo_crypt":
		var event_scene := _get_texture(RUN_CARDS, card_id, Vector2i(448, 274))
		if event_scene != null:
			return event_scene
		# Missing/invalid binary art must not break an event's card UI.
		var fallback_id := "whispering_well" if card_id == "moon_seal" else "gravedigger_shop"
		return _get_texture(RUN_CARDS, fallback_id, Vector2i(448, 274))
	var explicit_card := _get_texture(RUN_CARDS, card_id, Vector2i(448, 274))
	if explicit_card != null:
		return explicit_card
	# Use approved event backgrounds as card art when no standalone card exists.
	# Keep the legacy atlas as fallback if the new image is absent or invalid.
	# A missing/invalid event image falls through to CardArtCatalog's fallback.
	return _get_event_card_texture(card_id)


# One original 448x274 D152 card image; never fall back to a different battle card.
# Original user-approved third theatre composition. 448x274, QA preview only.
static func _get_d153_candidate_texture() -> Texture2D:
	if _texture_cache.has(D153_CARD_WEBP_B64):
		return _texture_cache[D153_CARD_WEBP_B64] as Texture2D
	if not FileAccess.file_exists(D153_CARD_WEBP_B64):
		push_warning("D153 approved card preview missing: " + D153_CARD_WEBP_B64)
		return null
	var encoded: String = FileAccess.get_file_as_string(D153_CARD_WEBP_B64).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_warning("D153 card preview base64 rejected.")
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK or image.get_size() != Vector2i(448, 274):
		push_warning("D153 card preview rejected (expected 448x274 WebP).")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	if texture != null:
		_texture_cache[D153_CARD_WEBP_B64] = texture
	return texture



# D261: scene-first, user-selected SECOND court illustration. No alternative art
# fallback is allowed for this unreleased card — a missing or corrupt export
# should FAIL preview rather than silently display a different encounter.
static func _get_d261_selected_texture() -> Texture2D:
	if _texture_cache.has(D261_COURT_CARD_WEBP_B64):
		return _texture_cache[D261_COURT_CARD_WEBP_B64] as Texture2D
	if not FileAccess.file_exists(D261_COURT_CARD_WEBP_B64):
		push_error("D261 approved option 2 card art missing: " + D261_COURT_CARD_WEBP_B64)
		return null
	var encoded: String = FileAccess.get_file_as_string(D261_COURT_CARD_WEBP_B64).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("D261 selected art base64 failed to decode.")
		return null
	var img := Image.new()
	if img.load_webp_from_buffer(bytes) != OK or img.get_size() != Vector2i(448, 274):
		push_error("D261 selected option 2 must decode to WebP 448x274.")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(img)
	if texture != null:
		_texture_cache[D261_COURT_CARD_WEBP_B64] = texture
	return texture


# D200: the exact user-chosen third Black Lantern Road scene (no UI text).
# This art is registered for a standalone preview, NOT for regular dealing.
static func _get_d200_candidate_texture() -> Texture2D:
	if _texture_cache.has(D200_CARD_WEBP_B64):
		return _texture_cache[D200_CARD_WEBP_B64] as Texture2D
	if not FileAccess.file_exists(D200_CARD_WEBP_B64):
		push_error("D200 chosen Black Lantern Road card art missing: " + D200_CARD_WEBP_B64)
		return null
	var encoded: String = FileAccess.get_file_as_string(D200_CARD_WEBP_B64).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("D200 card art could not decode base64.")
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK or image.get_size() != Vector2i(448, 274):
		push_error("D200 card art must be the chosen 448x274 WebP.")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	if texture != null:
		_texture_cache[D200_CARD_WEBP_B64] = texture
	return texture


# D182: strict decode of the approved third illustration, isolated to this card.
static func _get_d182_candidate_texture() -> Texture2D:
	if _texture_cache.has(D182_CARD_WEBP_B64):
		return _texture_cache[D182_CARD_WEBP_B64] as Texture2D
	if not FileAccess.file_exists(D182_CARD_WEBP_B64):
		push_error("D182 approved Black Crossing art missing: " + D182_CARD_WEBP_B64)
		return null
	var encoded: String = FileAccess.get_file_as_string(D182_CARD_WEBP_B64).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("D182 approved card WebP could not decode base64.")
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK or image.get_size() != Vector2i(448, 274):
		push_error("D182 approved card art must be 448x274 WebP.")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	if texture != null:
		_texture_cache[D182_CARD_WEBP_B64] = texture
	return texture


static func _get_d152_card_texture() -> Texture2D:
	if _texture_cache.has(D152_CARD_WEBP_B64):
		return _texture_cache[D152_CARD_WEBP_B64] as Texture2D
	if not FileAccess.file_exists(D152_CARD_WEBP_B64):
		push_warning("D152 authored card art missing: " + D152_CARD_WEBP_B64)
		return null
	var encoded: String = FileAccess.get_file_as_string(D152_CARD_WEBP_B64).strip_edges()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_warning("D152 authored card art cannot decode base64.")
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(bytes) != OK or image.get_size() != Vector2i(448, 274):
		push_warning("D152 authored card art rejected (expected 448x274 WebP).")
		return null
	var texture: Texture2D = ImageTexture.create_from_image(image)
	if texture != null:
		_texture_cache[D152_CARD_WEBP_B64] = texture
	return texture


static func _get_event_card_texture(card_id: String) -> Texture2D:
	var path := _path(EVENTS, card_id)
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
	var key := path + ":run_card"
	if _texture_cache.has(key):
		return _texture_cache[key] as Texture2D

	var image := Image.new()
	var err := image.load_webp_from_buffer(FileAccess.get_file_as_bytes(path))
	if err != OK or Vector2i(image.get_width(), image.get_height()) != Vector2i(1280, 720):
		push_warning("Wave 1 event art invalid for deal card, using old atlas: %s" % path)
		return null

	# Crop to the real 448:274 landscape ratio without stretching characters.
	var width := roundi(float(image.get_height()) * 448.0 / 274.0)
	var left := maxi(0, floori(float(image.get_width() - width) * 0.5))
	image = image.get_region(Rect2i(left, 0, width, image.get_height()))
	image.resize(448, 274, Image.INTERPOLATE_LANCZOS)
	var texture := ImageTexture.create_from_image(image)
	_texture_cache[key] = texture
	return texture

static func get_upgrade_texture(upgrade_id: String) -> Texture2D:
	return _get_texture(UPGRADES, upgrade_id, Vector2i(608, 388))

static func get_reward_texture(reward_key: String) -> Texture2D:
	return _get_texture(REWARDS, reward_key, Vector2i(608, 388))

static func get_event_art_path(card_id: String, original: String) -> String:
	var path := _path(EVENTS, card_id)
	if path.is_empty() or not FileAccess.file_exists(path):
		return original
	if not _texture_cache.has(path + ":event_valid"):
		var probe := Image.new()
		var err := probe.load_webp_from_buffer(FileAccess.get_file_as_bytes(path))
		var valid := err == OK and Vector2i(probe.get_width(), probe.get_height()) == Vector2i(1280, 720)
		_texture_cache[path + ":event_valid"] = valid
		if not valid:
			push_warning("Wave 1 event art decode/size invalid, using previous approved background: %s" % path)
	return path if bool(_texture_cache[path + ":event_valid"]) else original

static func _get_texture(paths: Dictionary, art_id: String, expected_size: Vector2i) -> Texture2D:
	var path := _path(paths, art_id)
	if path.is_empty() or not FileAccess.file_exists(path):
		return null

	if _texture_cache.has(path):
		return _texture_cache[path] as Texture2D

	var data := FileAccess.get_file_as_bytes(path)
	if data.is_empty():
		push_warning("Wave 1 card art is empty, using previous approved texture: %s" % path)
		return null

	var image := Image.new()
	var err := image.load_webp_from_buffer(data)
	if err != OK or Vector2i(image.get_width(), image.get_height()) != expected_size:
		push_warning("Wave 1 card art invalid dimensions/decode, using previous texture: %s" % path)
		return null

	var texture := ImageTexture.create_from_image(image)
	_texture_cache[path] = texture
	return texture

static func _path(paths: Dictionary, art_id: String) -> String:
	if not paths.has(art_id):
		return ""
	return ROOT + "/" + String(paths[art_id])
