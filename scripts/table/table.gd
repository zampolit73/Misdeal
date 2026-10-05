extends Control

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var offer_a_button: Button = $Cards/BonePatrolCard
@onready var offer_b_button: Button = $Cards/GraveyardCard
@onready var hidden_card_a: Button = $Cards/GallowsVolleyCard
@onready var hidden_card_b: Button = $Cards/WhisperingWellCard

var offer_buttons: Array[Button] = []
var default_wizard_line := ""
var selection_locked := false

func _ready() -> void:
	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
		return

	offer_buttons = [offer_a_button, offer_b_button]
	hidden_card_a.visible = false
	hidden_card_b.visible = false

	_refresh_table()

func _refresh_table() -> void:
	var condition_text := RunState.get_run_condition_text()
	stats_label.text = "%s     ЗОЛОТО %d     РАЗВИТИЕ %d     ЗДОРОВЬЕ %+d     УРОН %+d" % [
		RunState.get_progress_text(),
		RunState.gold,
		RunState.hero_upgrade_ids.size(),
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]
	if not condition_text.is_empty():
		stats_label.text += "     %s" % condition_text

	if RunState.is_boss_due():
		default_wizard_line = "Двенадцать карт позади. Осталась та, которую я берег."
	elif RunState.has_active_card():
		default_wizard_line = "Ты уже выбрал карту. Она всё ещё ждёт, пока ты закончишь начатое."
	elif RunState.cards_resolved < 4:
		default_wizard_line = "Начнём вежливо. Выбери, чем именно испортить себе вечер."
	elif RunState.wizard_debt_active:
		default_wizard_line = "Я помню твой долг. Следующий бой тоже будет помнить."
	elif RunState.cards_resolved < 8:
		default_wizard_line = "Теперь ставки становятся интереснее. Выбирай."
	else:
		default_wizard_line = "До надзирателя недалеко. Ошибки становятся дороже."

	wizard_line.text = default_wizard_line

	var offers := RunState.get_offer_cards()
	for index in range(offer_buttons.size()):
		var button := offer_buttons[index]
		if index >= offers.size():
			button.visible = false
			continue

		button.visible = true
		_setup_offer_button(button, offers[index])

func _setup_offer_button(button: Button, card: RunCardData) -> void:
	var art := button.get_node("Art") as TextureRect
	var title_label := button.get_node("Title") as Label
	var type_label := button.get_node("Type") as Label
	var description_label := button.get_node("Description") as Label
	var hint_label := button.get_node("Hint") as Label

	title_label.text = card.title
	type_label.text = card.type_label
	description_label.text = card.card_text
	hint_label.text = _get_hint_text(card)
	button.tooltip_text = ""
	button.disabled = false
	button.modulate = Color.WHITE

	if not card.art_path.is_empty():
		var texture := load(card.art_path) as Texture2D
		if texture != null:
			art.texture = texture

	_apply_card_style(button, card)
	button.pressed.connect(_choose_card.bind(card))
	button.mouse_entered.connect(_preview_card.bind(card))
	button.mouse_exited.connect(_restore_wizard_line)

func _get_hint_text(card: RunCardData) -> String:
	if RunState.has_active_card():
		return "ПОВТОРИТЬ"
	if card.card_id == RunState.BOSS_CARD_ID:
		return "ПРИНЯТЬ ВЫЗОВ"
	return "ВЫБРАТЬ"

func _apply_card_style(button: Button, card: RunCardData) -> void:
	var combat_like := card.type_label == "БОЙ" or card.type_label == "ЭЛИТА" or card.type_label == "БОСС"
	var event_like := not combat_like

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.025, 0.050, 0.054, 0.985) if event_like else Color(0.050, 0.026, 0.028, 0.985)
	normal.border_width_left = 3
	normal.border_width_top = 3
	normal.border_width_right = 3
	normal.border_width_bottom = 3
	normal.border_color = Color(0.22, 0.58, 0.56, 1.0) if event_like else Color(0.48, 0.21, 0.14, 1.0)
	normal.shadow_color = Color(0, 0, 0, 0.60)
	normal.shadow_size = 8

	var hover := normal.duplicate() as StyleBoxFlat
	hover.border_width_left = 4
	hover.border_width_top = 4
	hover.border_width_right = 4
	hover.border_width_bottom = 4
	hover.border_color = Color(0.36, 0.90, 0.82, 1.0) if event_like else Color(0.92, 0.45, 0.16, 1.0)
	hover.shadow_size = 12

	if card.card_id == RunState.BOSS_CARD_ID:
		normal.border_color = Color(0.72, 0.20, 0.12, 1.0)
		hover.border_color = Color(1.0, 0.42, 0.18, 1.0)

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)

	var type_label := button.get_node("Type") as Label
	var title_label := button.get_node("Title") as Label
	type_label.add_theme_color_override(
		"font_color",
		Color(0.34, 0.84, 0.76, 1.0) if event_like else Color(0.93, 0.55, 0.32, 1.0)
	)
	title_label.add_theme_color_override(
		"font_color",
		Color(0.68, 0.92, 0.86, 1.0) if event_like else Color(0.95, 0.83, 0.65, 1.0)
	)

	if card.card_id == RunState.BOSS_CARD_ID:
		type_label.add_theme_color_override("font_color", Color(1.0, 0.40, 0.24, 1.0))
		title_label.add_theme_color_override("font_color", Color(1.0, 0.76, 0.48, 1.0))

func _preview_card(card: RunCardData) -> void:
	if selection_locked:
		return
	wizard_line.text = card.wizard_line

func _restore_wizard_line() -> void:
	if selection_locked:
		return
	wizard_line.text = default_wizard_line

func _choose_card(card: RunCardData) -> void:
	if selection_locked:
		return

	if not RunState.choose_card(card.card_id):
		return

	selection_locked = true
	_disable_offer_buttons()
	wizard_line.text = card.wizard_line
	await get_tree().create_timer(0.25).timeout

	match card.resolution_type:
		"combat":
			get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
		"event", "prototype":
			get_tree().change_scene_to_file(card.target_path)
		_:
			push_warning("Unknown run card resolution type: %s" % card.resolution_type)
			selection_locked = false
			_refresh_table()

func _disable_offer_buttons() -> void:
	for button in offer_buttons:
		button.disabled = true
