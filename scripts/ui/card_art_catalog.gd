extends RefCounted

const ARTIFACT_ART_CATALOG := preload("res://scripts/ui/artifact_art_catalog.gd")

const RUN_CELL_SIZE := Vector2i(224, 137)
const RUN_SHEET_SIZE := Vector2i(1120, 685)
const RUN_COLUMNS := 5
const UI_CELL_SIZE := Vector2i(304, 194)
const UI_SHEET_SIZE := Vector2i(1520, 582)
const UI_COLUMNS := 5

const RUN_ATLAS_PATH := "res://assets/pixel/ui/approved_card_art/run_hd.bin"
const UI_ATLAS_PATH := "res://assets/pixel/ui/approved_card_art/ui_hd.bin"

const REDRAW_V4_CELL_SIZE := Vector2i(224, 137)
const REDRAW_V4_SHEET_SIZE := Vector2i(1120, 548)
const REDRAW_V4_COLUMNS := 5
const REDRAW_V4_ATLAS_PATH := "res://assets/pixel/ui/visual_pass_v4/cards_hd.bin"
const BONE_WARDEN_CARD_PATH := "res://assets/pixel/ui/visual_pass_v6/bone_warden_card.webp"
const BONE_WARDEN_CARD_SIZE := Vector2i(448, 274)

const REDRAW_V4_INDEX := {
	"bone_patrol": 0,
	"graveyard_ambush": 1,
	"gallows_volley": 2,
	"rattling_bridge": 3,
	"lost_purse": 4,
	"whispering_well": 5,
	"ossuary_gate": 6,
	"grave_bell": 7,
	"bone_warden": 8,
	"faceless_card": 9,
	"black_altar": 10,
	"blood_ledger": 11,
	"gravedigger_shop": 12,
	"last_camp": 13,
	"debtor_bones": 14,
	"crypt_guard": 15,
	"wizard_tithe": 16,
	"curse_forge": 17,
	"chained_prisoner": 18,
}

const REDRAW_V5_CELL_SIZE := Vector2i(224, 137)
const REDRAW_V5_SHEET_SIZE := Vector2i(1120, 137)
const REDRAW_V5_COLUMNS := 5
const REDRAW_V5_PARTS: Array[String] = [
	"res://assets/pixel/ui/visual_pass_v5/cards/part_00.txt",
	"res://assets/pixel/ui/visual_pass_v5/cards/part_01.txt",
	"res://assets/pixel/ui/visual_pass_v5/cards/part_02.txt",
	"res://assets/pixel/ui/visual_pass_v5/cards/part_03.txt",
]

const REDRAW_V5_INDEX := {
	"ash_rest": 0,
	"bone_crush": 1,
	"candle_seller": 2,
	"bone_tax": 3,
	"death_wager": 4,
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
static var redraw_v4_sheet_texture: Texture2D
static var redraw_v5_sheet_texture: Texture2D
static var bone_warden_card_texture: Texture2D

static func get_run_card_texture(card_id: String) -> Texture2D:
	if card_id == "bone_warden":
		var warden_texture: Texture2D = _get_bone_warden_card_texture()
		if warden_texture != null:
			return warden_texture

	if card_id == "broken_crown":
		var crown_texture: Texture2D = ARTIFACT_ART_CATALOG.get_texture("broken_crown")
		if crown_texture != null:
			return crown_texture

	if REDRAW_V5_INDEX.has(card_id):
		var redraw_v5_sheet: Texture2D = _get_redraw_v5_sheet()
		if redraw_v5_sheet != null:
			return _get_cell(
				redraw_v5_sheet,
				int(REDRAW_V5_INDEX[card_id]),
				REDRAW_V5_CELL_SIZE,
				REDRAW_V5_COLUMNS
			)

	if REDRAW_V4_INDEX.has(card_id):
		var redraw_sheet: Texture2D = _get_redraw_v4_sheet()
		if redraw_sheet != null:
			return _get_cell(
				redraw_sheet,
				int(REDRAW_V4_INDEX[card_id]),
				REDRAW_V4_CELL_SIZE,
				REDRAW_V4_COLUMNS
			)
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

static func _get_bone_warden_card_texture() -> Texture2D:
	if bone_warden_card_texture == null:
		bone_warden_card_texture = _decode_sheet(
			BONE_WARDEN_CARD_PATH,
			BONE_WARDEN_CARD_SIZE,
			"Bone Warden v6 card"
		)
	return bone_warden_card_texture


static func _get_redraw_v5_sheet() -> Texture2D:
	if redraw_v5_sheet_texture == null:
		redraw_v5_sheet_texture = _decode_split_sheet(
			REDRAW_V5_PARTS,
			REDRAW_V5_SHEET_SIZE,
			"visual-redraw v5"
		)
	return redraw_v5_sheet_texture


static func _decode_split_sheet(
	part_paths: Array[String],
	expected_size: Vector2i,
	label: String
) -> Texture2D:
	var encoded := ""
	for part_path: String in part_paths:
		if not FileAccess.file_exists(part_path):
			push_error("Missing approved %s art atlas part: %s" % [label, part_path])
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Approved %s art atlas decoded to an empty buffer." % label)
		return null

	var image := Image.new()
	var error: Error = image.load_webp_from_buffer(bytes)
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


static func _get_redraw_v4_sheet() -> Texture2D:
	if redraw_v4_sheet_texture == null:
		redraw_v4_sheet_texture = _decode_sheet(
			REDRAW_V4_ATLAS_PATH,
			REDRAW_V4_SHEET_SIZE,
			"visual-redraw v4"
		)
	return redraw_v4_sheet_texture


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
