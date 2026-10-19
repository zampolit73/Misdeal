extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const WIZARD_DEFAULT := "— Начнём с простого. Выбери ту версию себя, которой ещё доверяешь."
const WIZARD_REACTIONS := {
	"knight": "— Этот всё ещё верит, что сталь решает больше, чем страх.",
	"ranger": "— Всегда ищет выход. Даже там, где я предусмотрел только вход.",
	"mage": "— Любопытный ум. Жаль, что он редко думает о последствиях."
}

# Keep the original source-backed class values, not mock-up numbers.
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
@onready var confirm_button: Button = $Frame/ConfirmButton
@onready var wizard_line: Label = $Frame/WizardLine

var unit_sheet_texture: Texture2D
var selected_role := ""
var hovered_role := ""
var choosing := false
var card_buttons: Dictionary = {}


func _ready() -> void:
	card_buttons = {
		"knight": knight_button,
		"ranger": ranger_button,
		"mage": mage_button
	}
	for role in HERO_ROLES:
		var button: Button = card_buttons[role]
		CARD_SKIN.prepare(button)
		var unit: Resource = load(RunState.HERO_UNIT_PATHS[role]) as Resource
		if unit != null:
			(button.get_node("Stats") as Label).text = "%d HP    •    %d УРОН" % [
				roundi(float(unit.get("max_hp"))),
				roundi(float(unit.get("damage")))
			]
		else:
			push_error("ClassSelect missing hero data for " + role)
		button.pressed.connect(_select_role.bind(role))
		button.mouse_entered.connect(_on_card_hover.bind(role, true))
		button.mouse_exited.connect(_on_card_hover.bind(role, false))
	confirm_button.pressed.connect(_confirm_choice)
	CARD_SKIN.prepare_confirm(confirm_button)
	confirm_button.disabled = true
	_refresh_cards()
	call_deferred("_animate_cards_in")


func _select_role(role: String) -> void:
	if choosing or not card_buttons.has(role):
		return
	# A click only marks the card. It must NOT start a run.
	selected_role = role
	wizard_line.text = WIZARD_REACTIONS.get(role, WIZARD_DEFAULT)
	confirm_button.disabled = false
	_refresh_cards()


func _on_card_hover(role: String, entered: bool) -> void:
	if choosing:
		return
	hovered_role = role if entered else ("" if hovered_role == role else hovered_role)
	if not selected_role.is_empty() and hovered_role.is_empty():
		wizard_line.text = WIZARD_REACTIONS.get(selected_role, WIZARD_DEFAULT)
	elif hovered_role.is_empty():
		wizard_line.text = WIZARD_DEFAULT
	else:
		wizard_line.text = WIZARD_REACTIONS.get(hovered_role, WIZARD_DEFAULT)
	_refresh_cards()


func _refresh_cards() -> void:
	for role in HERO_ROLES:
		var button: Button = card_buttons[role]
		var active := role == selected_role
		var preview := role == hovered_role
		var other := not selected_role.is_empty() and not active and not preview
		var stats := button.get_node("Stats") as Label
		var desc := button.get_node("Description") as Label
		var plate := button.get_node("StatsPlate") as ColorRect
		var show_stats := active or preview
		stats.visible = show_stats
		plate.visible = show_stats
		desc.visible = not show_stats
		CARD_SKIN.set_state(button, active, preview, other)
		button.z_index = 15 if (preview or active) else 0
	CARD_SKIN.update_confirm(confirm_button)


func _animate_cards_in() -> void:
	for i in range(HERO_ROLES.size()):
		var card: Button = card_buttons[HERO_ROLES[i]]
		card.pivot_offset = card.size * 0.5
		card.modulate.a = 0.0
		var tween := create_tween()
		tween.tween_property(card, "modulate:a", 1.0, 0.26).set_delay(float(i) * 0.07)


func _input(event: InputEvent) -> void:
	if choosing or not (event is InputEventKey):
		return
	var key := event as InputEventKey
	if not key.pressed or key.echo:
		return
	if key.keycode == KEY_LEFT or key.keycode == KEY_RIGHT:
		var index := HERO_ROLES.find(selected_role)
		if index == -1:
			index = 0 if key.keycode == KEY_RIGHT else HERO_ROLES.size() - 1
		else:
			index = posmod(index + (1 if key.keycode == KEY_RIGHT else -1), HERO_ROLES.size())
		hovered_role = ""
		_select_role(HERO_ROLES[index])
		get_viewport().set_input_as_handled()
	elif (key.keycode == KEY_ENTER or key.keycode == KEY_KP_ENTER) and not selected_role.is_empty():
		get_viewport().set_input_as_handled()
		_confirm_choice()


func _confirm_choice() -> void:
	if choosing or selected_role.is_empty():
		return
	# RunState is updated ONLY after explicit confirmation.
	if not RunState.choose_protagonist(selected_role):
		return
	choosing = true
	confirm_button.disabled = true
	for role in HERO_ROLES:
		(card_buttons[role] as Button).disabled = true
	wizard_line.text = "— Вот так ты это помнишь, — говорит Волшебник."
	var chosen_button: Button = card_buttons[selected_role]
	for role in HERO_ROLES:
		var button: Button = card_buttons[role]
		var tween := create_tween()
		if button == chosen_button:
			button.z_index = 25
			tween.tween_property(button, "scale", Vector2(1.065, 1.065), 0.15)
		else:
			tween.tween_property(button, "modulate", Color(0.47, 0.44, 0.43, 0.58), 0.15)
	await get_tree().create_timer(0.28).timeout
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
