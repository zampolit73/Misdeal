extends Control

const ROLE_PORTRAITS := {
	"knight": preload("res://assets/pixel/class_select/v7/knight.webp"),
	"ranger": preload("res://assets/pixel/class_select/v7/ranger.webp"),
	"mage": preload("res://assets/pixel/class_select/v7/mage.webp"),
}

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
@onready var frame: Panel = $Frame

var unit_sheet_texture: Texture2D
var choosing := false

func _ready() -> void:
	knight_button.pressed.connect(_choose.bind("knight"))
	ranger_button.pressed.connect(_choose.bind("ranger"))
	mage_button.pressed.connect(_choose.bind("mage"))

	knight_portrait.texture = _get_role_texture("knight")
	ranger_portrait.texture = _get_role_texture("ranger")
	mage_portrait.texture = _get_role_texture("mage")

	for button in [knight_button, ranger_button, mage_button]:
		button.mouse_entered.connect(_on_card_hover.bind(button, true))
		button.mouse_exited.connect(_on_card_hover.bind(button, false))

	_animate_screen_in()

func _animate_screen_in() -> void:
	frame.pivot_offset = frame.size * 0.5
	frame.scale = Vector2(0.985, 0.985)
	frame.modulate.a = 0.0
	var tween := frame.create_tween()
	tween.set_parallel(true)
	tween.tween_property(frame, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(frame, "modulate:a", 1.0, 0.16)

func _on_card_hover(button: Button, hovered: bool) -> void:
	if button.disabled or choosing:
		return
	button.pivot_offset = button.size * 0.5
	var tween := button.create_tween()
	tween.tween_property(button, "scale", Vector2(1.022, 1.022) if hovered else Vector2.ONE, 0.11).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

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
	return ROLE_PORTRAITS.get(role) as Texture2D

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
