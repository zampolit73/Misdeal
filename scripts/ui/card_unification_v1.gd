extends RefCounted

# Optional Wave 1 art overrides. Legacy atlases stay authoritative unless a
# separately packaged, approved 448x274/608x388 WebP exists on disk.
# This file contains no gameplay or UI layout changes.
const ROOT := "res://assets/pixel/card_unification_v1"

const RUN_CARDS := {
	"bone_patrol": "run/bone_patrol.webp",
	"graveyard_ambush": "run/graveyard_ambush.webp",
	"gallows_volley": "run/gallows_volley.webp",
	"whispering_well": "run/whispering_well.webp",
}

const EVENTS := {
	"curse_forge": "event/curse_forge.webp",
	"black_altar": "event/black_altar.webp",
	"chained_prisoner": "event/chained_prisoner.webp",
	"rattling_bridge": "event/rattling_bridge.webp",
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
	return _get_texture(RUN_CARDS, card_id, Vector2i(448, 274))

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
