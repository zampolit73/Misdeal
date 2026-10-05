extends Control

const UNIT_TILE_SIZE: float = 96.0
const UNIT_SHEET_PARTS: Array[String] = [
	"res://assets/pixel/units/combat_units_v3/part_00.txt",
	"res://assets/pixel/units/combat_units_v3/part_01.txt",
	"res://assets/pixel/units/combat_units_v3/part_02.txt",
	"res://assets/pixel/units/combat_units_v3/part_03.txt",
	"res://assets/pixel/units/combat_units_v3/part_04.txt",
	"res://assets/pixel/units/combat_units_v3/part_05.txt",
	"res://assets/pixel/units/combat_units_v3/part_06.txt",
	"res://assets/pixel/units/combat_units_v3/part_07.txt",
	"res://assets/pixel/units/combat_units_v3/part_08.txt",
	"res://assets/pixel/units/combat_units_v3/part_09.txt",
]

@onready var knight_button: Button = $Frame/Cards/Knight
@onready var ranger_button: Button = $Frame/Cards/Ranger
@onready var mage_button: Button = $Frame/Cards/Mage
@onready var knight_portrait: TextureRect = $Frame/Cards/Knight/Portrait
@onready var ranger_portrait: TextureRect = $Frame/Cards/Ranger/Portrait
@onready var mage_portrait: TextureRect = $Frame/Cards/Mage/Portrait
@onready var status_label: Label = $Frame/Status

var unit_sheet_texture: Texture2D
var choosing := false

func _ready() -> void:
	knight_button.pressed.connect(_choose.bind("knight"))
	ranger_button.pressed.connect(_choose.bind("ranger"))
	mage_button.pressed.connect(_choose.bind("mage"))

	knight_portrait.texture = _get_role_texture("knight")
	ranger_portrait.texture = _get_role_texture("ranger")
	mage_portrait.texture = _get_role_texture("mage")

func _choose(role: String) -> void:
	if choosing:
		return
	if not RunState.choose_protagonist(role):
		return

	choosing = true
	knight_button.disabled = true
	ranger_button.disabled = true
	mage_button.disabled = true

	status_label.text = "— Вот так ты это помнишь, — говорит Волшебник."
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")

func _get_role_texture(role: String) -> Texture2D:
	var tile := Vector2i(-1, -1)
	match role:
		"knight":
			tile = Vector2i(0, 0)
		"ranger":
			tile = Vector2i(1, 0)
		"mage":
			tile = Vector2i(2, 0)
		_:
			return null

	var sheet := _get_unit_sheet_texture()
	if sheet == null:
		return null

	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(tile.x) * UNIT_TILE_SIZE, float(tile.y) * UNIT_TILE_SIZE),
		Vector2(UNIT_TILE_SIZE, UNIT_TILE_SIZE)
	)
	return atlas

func _get_unit_sheet_texture() -> Texture2D:
	if unit_sheet_texture != null:
		return unit_sheet_texture

	var encoded := ""
	for part_path in UNIT_SHEET_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing combat atlas part on class select: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Class select could not decode combat atlas base64.")
		return null

	var image := Image.new()
	var error := image.load_png_from_buffer(bytes)
	if error != OK:
		push_error("Class select could not decode combat atlas PNG: %s" % error_string(error))
		return null

	unit_sheet_texture = ImageTexture.create_from_image(image)
	return unit_sheet_texture
