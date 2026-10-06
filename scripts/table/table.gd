extends Control

const SQUAD_STATUS_SCENE := preload("res://scenes/table/squad_status.tscn")

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var offer_a_button: Button = $Cards/BonePatrolCard
@onready var offer_b_button: Button = $Cards/GraveyardCard
@onready var hidden_card_a: Button = $Cards/GallowsVolleyCard
@onready var hidden_card_b: Button = $Cards/WhisperingWellCard
@onready var squad_button: Button = $SquadButton

var offer_buttons: Array[Button] = []
var squad_status: Control
var default_wizard_line := ""
var selection_locked := false

func _ready() -> void:
	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
		return

	offer_buttons = [offer_a_button, offer_b_button]
	for button in offer_buttons:
		button.pressed.connect(_on_offer_button_pressed.bind(button))
		button.mouse_entered.connect(_on_offer_button_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_offer_button_mouse_exited)

	hidden_card_a.visible = false
	hidden_card_b.visible = false
	squad_button.pressed.connect(_toggle_squad_status)

	_refresh_table()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB:
		get_viewport().set_input_as_handled()
		_toggle_squad_status()

func _toggle_squad_status() -> void:
	if is_instance_valid(squad_status):
		squad_status.queue_free()
		squad_status = null
		return

	squad_status = SQUAD_STATUS_SCENE.instantiate() as Control
	add_child(squad_status)

func _refresh_table() -> void:
	selection_locked = false
	var condition_text := RunState.get_run_condition_text()
	stats_label.text = "%s     ЗОЛОТО %d     ОТРЯД %d/3     РАЗВИТИЕ %d     РЕЛИКВИИ %d" % [
		RunState.get_progress_text(),
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.artifact_ids.size()
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

	if RunState.has_pending_wizard_meddling():
		selection_locked = true
		_disable_offer_buttons()
		wizard_line.text = "Подожди. Я ещё не закончил сдавать."
		call_deferred("_play_pending_wizard_meddling")

func _setup_offer_button(button: Button, card: RunCardData) -> void:
	var art := button.get_node("Art") as TextureRect
	var title_label := button.get_node("Title") as Label
	var type_label := button.get_node("Type") as Label
	var description_label := button.get_node("Description") as Label
	var hint_label := button.get_node("Hint") as Label

	button.set_meta("card_id", card.card_id)
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

func _get_button_card(button: Button) -> RunCardData:
	var card_id := String(button.get_meta("card_id", ""))
	if card_id.is_empty():
		return null
	return RunState.get_card(card_id)

func _on_offer_button_pressed(button: Button) -> void:
	var card := _get_button_card(button)
	if card != null:
		_choose_card(card)

func _on_offer_button_mouse_entered(button: Button) -> void:
	var card := _get_button_card(button)
	if card != null:
		_preview_card(card)

func _on_offer_button_mouse_exited() -> void:
	_restore_wizard_line()

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

func _play_pending_wizard_meddling() -> void:
	if not RunState.has_pending_wizard_meddling():
		selection_locked = false
		_enable_offer_buttons()
		return

	await get_tree().create_timer(0.55).timeout
	if not RunState.has_pending_wizard_meddling():
		selection_locked = false
		_enable_offer_buttons()
		return

	var offer_index := RunState.get_pending_wizard_meddling_index()
	if offer_index < 0 or offer_index >= offer_buttons.size():
		selection_locked = false
		_enable_offer_buttons()
		return

	var button := offer_buttons[offer_index]
	button.pivot_offset = button.size * 0.5
	wizard_line.text = "Нет. Эту карту я передумал отдавать."

	var close_tween := button.create_tween()
	close_tween.set_parallel(true)
	close_tween.tween_property(button, "scale", Vector2(0.06, 1.0), 0.16).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	close_tween.tween_property(button, "modulate", Color(0.52, 0.16, 0.14, 1.0), 0.16)
	await close_tween.finished

	var result := RunState.apply_pending_wizard_meddling()
	if result.is_empty():
		button.scale = Vector2.ONE
		button.modulate = Color.WHITE
		selection_locked = false
		_enable_offer_buttons()
		_restore_wizard_line()
		return

	var old_card := RunState.get_card(String(result.get("old_card_id", "")))
	var new_card := RunState.get_card(String(result.get("new_card_id", "")))
	if new_card == null:
		button.scale = Vector2.ONE
		button.modulate = Color.WHITE
		selection_locked = false
		_enable_offer_buttons()
		_refresh_table()
		return

	_setup_offer_button(button, new_card)
	var hint_label := button.get_node("Hint") as Label
	hint_label.text = "ПОДМЕНЕНО"

	button.scale = Vector2(0.06, 1.0)
	button.modulate = Color(1.0, 0.50, 0.34, 1.0)
	var open_tween := button.create_tween()
	open_tween.set_parallel(true)
	open_tween.tween_property(button, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(button, "modulate", Color.WHITE, 0.20)
	await open_tween.finished

	hint_label.text = _get_hint_text(new_card)
	var old_title := old_card.title if old_card != null else "та карта"
	default_wizard_line = "«%s»? Нет. Сегодня ты получишь «%s». Так интереснее." % [old_title, new_card.title]
	wizard_line.text = default_wizard_line
	selection_locked = false
	_enable_offer_buttons()

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

func _enable_offer_buttons() -> void:
	for button in offer_buttons:
		if button.visible:
			button.disabled = false
