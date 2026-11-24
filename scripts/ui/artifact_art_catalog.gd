class_name ArtifactArtCatalog
extends RefCounted

const ATLAS_PATH := "res://assets/pixel/ui/artifact_polish/artifact_atlas.bin"
const CELL_SIZE := Vector2i(280, 180)
const SHEET_SIZE := Vector2i(560, 360)
const COLUMNS := 2
const RELIQUARY_ATLAS := preload("res://assets/pixel/ui/wizard_archive/relics.webp")
const RELIQUARY_LEGACY := preload("res://assets/pixel/ui/wizard_archive/legacy_relics.webp")
const RELIQUARY_CELL := 192
const RELIQUARY_IDS := [
	"sanguine_whetstone", "mourning_knot", "harvest_ring",
	"shieldbond", "ash_grimoire", "hollow_fletching",
	"watch_bell", "marked_coin", "scar_seal",
]

const ARTIFACT_INDEX := {
	"dead_mans_shield": 0,
	"blind_quiver": 1,
	"cracked_focus": 2,
	"broken_crown": 3,
}

static var _sheet_texture: Texture2D

static func get_reliquary_texture(artifact_id: String) -> Texture2D:
	var index := RELIQUARY_IDS.find(artifact_id)
	if index == -1:
		var legacy_index := int(ARTIFACT_INDEX.get(artifact_id, -1))
		return null if legacy_index < 0 else _reliquary_cell(RELIQUARY_LEGACY, legacy_index, 0)
	return _reliquary_cell(RELIQUARY_ATLAS, index % 3, floori(index / 3.0))


static func _reliquary_cell(sheet: Texture2D, column: int, row: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(column * RELIQUARY_CELL, row * RELIQUARY_CELL, RELIQUARY_CELL, RELIQUARY_CELL)
	atlas.filter_clip = true
	return atlas


static func get_texture(artifact_id: String) -> Texture2D:
	if not ARTIFACT_INDEX.has(artifact_id):
		return null
	var sheet := _get_sheet_texture()
	if sheet == null:
		return null

	var index := int(ARTIFACT_INDEX[artifact_id])
	var column := index % COLUMNS
	var row := index / COLUMNS
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * CELL_SIZE.x), float(row * CELL_SIZE.y)),
		Vector2(float(CELL_SIZE.x), float(CELL_SIZE.y))
	)
	return atlas

static func _get_sheet_texture() -> Texture2D:
	if _sheet_texture != null:
		return _sheet_texture
	if not FileAccess.file_exists(ATLAS_PATH):
		push_error("Missing artifact art atlas: %s" % ATLAS_PATH)
		return null

	var bytes := FileAccess.get_file_as_bytes(ATLAS_PATH)
	if bytes.is_empty():
		push_error("Artifact art atlas is empty.")
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode artifact art atlas: %s" % error_string(error))
		return null
	if image.get_width() != SHEET_SIZE.x or image.get_height() != SHEET_SIZE.y:
		push_error(
			"Artifact art atlas has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				SHEET_SIZE.x,
				SHEET_SIZE.y,
			]
		)
		return null

	_sheet_texture = ImageTexture.create_from_image(image)
	return _sheet_texture
