extends RefCounted

const RUN_CELL_SIZE := Vector2i(224, 137)
const RUN_SHEET_SIZE := Vector2i(1120, 685)
const RUN_COLUMNS := 5
const UI_CELL_SIZE := Vector2i(304, 194)
const UI_SHEET_SIZE := Vector2i(1520, 582)
const UI_COLUMNS := 5

const RUN_ATLAS_PATH := "res://assets/pixel/ui/approved_card_art/run_hd.bin"
const UI_ATLAS_PATH := "res://assets/pixel/ui/approved_card_art/ui_hd.bin"

const RUN_OVERRIDE_PATHS := {
	"rattling_bridge": "res://assets/pixel/ui/visual_pass_v2/cards/rattling_bridge.txt",
	"lost_purse": "res://assets/pixel/ui/visual_pass_v2/cards/lost_purse.txt",
	"whispering_well": "res://assets/pixel/ui/visual_pass_v2/cards/whispering_well.txt",
}

const RUN_INDEX := {
	"bone_patrol": 0,
	"graveyard_ambush": 1,
	"gallows_volley": 2,
	"whispering_well": 3,
	"ash_rest": 4,
	"gravedigger_shop": 5,
	"curse_forge": 6,
	"grave_bell": 7,
	"black_altar": 8,
	"chained_prisoner": 9,
	"debtor_bones": 10,
	"wizard_tithe": 11,
	"bone_crush": 12,
	"crypt_guard": 13,
	"faceless_card": 14,
	"blood_ledger": 15,
	"broken_crown": 16,
	"last_camp": 17,
	"ossuary_gate": 18,
	"rattling_bridge": 19,
	"lost_purse": 20,
	"candle_seller": 21,
	"bone_tax": 22,
	"death_wager": 23,
	"bone_warden": 24,
}

const UPGRADE_INDEX := {
	"knight_iron_oath": 0,
	"knight_executioner": 1,
	"knight_cleaver": 2,
	"ranger_longshot": 3,
	"ranger_arrowstorm": 4,
	"ranger_beast_trail": 5,
	"mage_glass_heart": 6,
	"mage_overload": 7,
	"mage_wildfire": 8,
}

const REWARD_INDEX := {
	"blood_coin": 9,
	"relic_wager": 10,
	"bonus_upgrade": 11,
	"empty_cache": 12,
	"gold_windfall": 13,
	"elite_relic": 14,
}

static var run_sheet_texture: Texture2D
static var ui_sheet_texture: Texture2D
static var run_override_cache: Dictionary = {}

static func get_run_card_texture(card_id: String) -> Texture2D:
	var override_texture: Texture2D = _get_run_override(card_id)
	if override_texture != null:
		return override_texture
	if not RUN_INDEX.has(card_id):
		return null
	var sheet := _get_run_sheet()
	if sheet == null:
		return null
	return _get_cell(sheet, int(RUN_INDEX[card_id]), RUN_CELL_SIZE, RUN_COLUMNS)

static func get_upgrade_texture(upgrade_id: String) -> Texture2D:
	if not UPGRADE_INDEX.has(upgrade_id):
		return null
	var sheet := _get_ui_sheet()
	if sheet == null:
		return null
	return _get_cell(sheet, int(UPGRADE_INDEX[upgrade_id]), UI_CELL_SIZE, UI_COLUMNS)

static func get_reward_texture(reward_key: String) -> Texture2D:
	if not REWARD_INDEX.has(reward_key):
		return null
	var sheet := _get_ui_sheet()
	if sheet == null:
		return null
	return _get_cell(sheet, int(REWARD_INDEX[reward_key]), UI_CELL_SIZE, UI_COLUMNS)

static func _get_run_override(card_id: String) -> Texture2D:
	if run_override_cache.has(card_id):
		return run_override_cache[card_id] as Texture2D
	if not RUN_OVERRIDE_PATHS.has(card_id):
		return null

	var part_path: String = String(RUN_OVERRIDE_PATHS[card_id])
	if not FileAccess.file_exists(part_path):
		push_error("Missing visual-pass card art: %s" % part_path)
		return null

	var encoded: String = FileAccess.get_file_as_string(part_path).strip_edges()
	if encoded.is_empty():
		push_error("Visual-pass card art is empty: %s" % part_path)
		return null

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Could not decode visual-pass card art: %s" % card_id)
		return null

	var image := Image.new()
	var error: Error = image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not load visual-pass card art '%s': %s" % [card_id, error_string(error)])
		return null

	if image.get_width() != RUN_CELL_SIZE.x or image.get_height() != RUN_CELL_SIZE.y:
		image.resize(RUN_CELL_SIZE.x, RUN_CELL_SIZE.y, Image.INTERPOLATE_NEAREST)

	var texture := ImageTexture.create_from_image(image)
	run_override_cache[card_id] = texture
	return texture


static func _get_run_sheet() -> Texture2D:
	if run_sheet_texture == null:
		run_sheet_texture = _decode_sheet(RUN_ATLAS_PATH, RUN_SHEET_SIZE, "run-card")
	return run_sheet_texture

static func _get_ui_sheet() -> Texture2D:
	if ui_sheet_texture == null:
		ui_sheet_texture = _decode_sheet(UI_ATLAS_PATH, UI_SHEET_SIZE, "development/reward")
	return ui_sheet_texture

static func _decode_sheet(atlas_path: String, expected_size: Vector2i, label: String) -> Texture2D:
	if not FileAccess.file_exists(atlas_path):
		push_error("Missing approved %s art atlas: %s" % [label, atlas_path])
		return null

	var bytes := FileAccess.get_file_as_bytes(atlas_path)
	if bytes.is_empty():
		push_error("Approved %s art atlas decoded to an empty buffer." % label)
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved %s art atlas: %s" % [label, error_string(error)])
		return null

	if image.get_width() != expected_size.x or image.get_height() != expected_size.y:
		push_error(
			"Approved %s art atlas has unexpected size %dx%d; expected %dx%d." % [
				label,
				image.get_width(),
				image.get_height(),
				expected_size.x,
				expected_size.y,
			]
		)
		return null

	return ImageTexture.create_from_image(image)

static func _get_cell(sheet: Texture2D, index: int, cell_size: Vector2i, columns: int) -> Texture2D:
	var column := index % columns
	var row := index / columns
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * cell_size.x), float(row * cell_size.y)),
		Vector2(float(cell_size.x), float(cell_size.y))
	)
	return atlas
