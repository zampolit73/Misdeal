extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

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
	_apply_ui_kit()
	knight_button.pressed.connect(_choose.bind("knight"))
	ranger_button.pressed.connect(_choose.bind("ranger"))
	mage_button.pressed.connect(_choose.bind("mage"))

	for button in [knight_button, ranger_button, mage_button]:
		button.mouse_entered.connect(_on_card_hover.bind(button, true))
		button.mouse_exited.connect(_on_card_hover.bind(button, false))

	_animate_screen_in()
	call_deferred("_animate_cards_in")

func _apply_ui_kit() -> void:
	MISDEAL_UI_KIT.apply_panel(frame, MISDEAL_UI_KIT.BRONZE, true)
	MISDEAL_UI_KIT.apply_title($Frame/Title, MISDEAL_UI_KIT.GOLD)
	MISDEAL_UI_KIT.apply_subtitle($Frame/WizardLine, MISDEAL_UI_KIT.BRONZE)
	MISDEAL_UI_KIT.apply_card_button(knight_button, MISDEAL_UI_KIT.KNIGHT)
	MISDEAL_UI_KIT.apply_card_button(ranger_button, MISDEAL_UI_KIT.RANGER)
	MISDEAL_UI_KIT.apply_card_button(mage_button, MISDEAL_UI_KIT.MAGE)


func _animate_screen_in() -> void:
	frame.pivot_offset = frame.size * 0.5
	frame.scale = Vector2(0.985, 0.985)
	frame.modulate.a = 0.0
	var tween := frame.create_tween()
	tween.set_parallel(true)
	tween.tween_property(frame, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(frame, "modulate:a", 1.0, 0.16)

func _animate_cards_in() -> void:
	var cards: Array[Button] = [knight_button, ranger_button, mage_button]
	for index in range(cards.size()):
		var button := cards[index]
		button.pivot_offset = button.size * 0.5
		button.scale = Vector2(0.975, 0.975)
		button.modulate.a = 0.0

		var tween := button.create_tween()
		tween.set_parallel(true)
		var delay := 0.05 + float(index) * 0.055
		tween.tween_property(button, "scale", Vector2.ONE, 0.20).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "modulate:a", 1.0, 0.16).set_delay(delay)


func _animate_choice_commit(selected_button: Button) -> void:
	var cards: Array[Button] = [knight_button, ranger_button, mage_button]
	for button in cards:
		button.pivot_offset = button.size * 0.5
		var tween := button.create_tween()
		tween.set_parallel(true)
		if button == selected_button:
			button.z_index = 20
			tween.tween_property(button, "scale", Vector2(1.045, 1.045), 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "modulate", Color(1.08, 1.0, 0.90, 1.0), 0.12)
		else:
			button.z_index = 0
			tween.tween_property(button, "scale", Vector2(0.985, 0.985), 0.12)
			tween.tween_property(button, "modulate", Color(0.46, 0.43, 0.46, 0.62), 0.12)

	await get_tree().create_timer(0.18).timeout


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

	var selected_button := knight_button
	if role == "ranger":
		selected_button = ranger_button
	elif role == "mage":
		selected_button = mage_button

	status_label.text = "— Вот так ты это помнишь, — говорит Волшебник."
	await _animate_choice_commit(selected_button)
	await get_tree().create_timer(0.12).timeout
	SCENE_ROUTER.change_to(self, "res://scenes/table/table.tscn")

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
