extends Control

const SQUAD_STATUS_SCENE := preload("res://scenes/table/squad_status.tscn")
const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")

const LEFT_CARD_POSITION := Vector2(382.0, 332.0)
const RIGHT_CARD_POSITION := Vector2(658.0, 332.0)
const SINGLE_CARD_POSITION := Vector2(520.0, 332.0)
const DEAL_SOURCE_POSITION := Vector2(61.0, 309.0)
const DISCARD_TARGET_POSITION := Vector2(972.0, 313.0)
const LEFT_CARD_ROTATION := -0.045
const RIGHT_CARD_ROTATION := 0.045

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var offer_a_button: Button = $Cards/BonePatrolCard
@onready var offer_b_button: Button = $Cards/GraveyardCard
@onready var hidden_card_a: Button = $Cards/GallowsVolleyCard
@onready var hidden_card_b: Button = $Cards/WhisperingWellCard
@onready var squad_button: Button = $SquadButton
@onready var table_spread_visual: Control = $TableSpreadVisual
@onready var table_audio: Node = $TableAudio
@onready var deck_count_label: Label = $DeckCount
@onready var discard_count_label: Label = $DiscardCount
@onready var spread_progress_label: Label = $SpreadProgress
@onready var wager_root: Control = $WagerOverlay/Root
@onready var wager_panel: Panel = $WagerOverlay/Root/WagerPanel
@onready var wager_accept_button: Button = $WagerOverlay/Root/WagerPanel/AcceptButton
@onready var wager_refuse_button: Button = $WagerOverlay/Root/WagerPanel/RefuseButton

var offer_buttons: Array[Button] = []
var squad_status: Control
var default_wizard_line := ""
var selection_locked := false
var deal_in_progress := false
var dealt_offer_signature := ""
var card_rest_positions: Dictionary = {}
var card_rest_rotations: Dictionary = {}
var card_motion_tweens: Dictionary = {}

func _ready() -> void:
	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
		return

	offer_buttons = [offer_a_button, offer_b_button]
	for button in offer_buttons:
		button.pressed.connect(_on_offer_button_pressed.bind(button))
		button.mouse_entered.connect(_on_offer_button_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_offer_button_mouse_exited.bind(button))

	hidden_card_a.visible = false
	hidden_card_b.visible = false
	wager_root.visible = false
	squad_button.pressed.connect(_toggle_squad_status)
	wager_accept_button.pressed.connect(_accept_wizard_wager)
	wager_refuse_button.pressed.connect(_refuse_wizard_wager)

	_configure_card_pivots()
	_refresh_table()

func _input(event: InputEvent) -> void:
	if selection_locked:
		return

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

func _refresh_table(show_memory: bool = true) -> void:
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

	_layout_offer_cards(offers.size())
	_update_spread_ui()
	_animate_deal_if_needed(offers)

	if RunState.has_pending_wizard_meddling():
		selection_locked = true
		_disable_offer_buttons()
		wizard_line.text = "Подожди. Я ещё не закончил сдавать."
		call_deferred("_play_pending_wizard_meddling")
	elif RunState.has_pending_wizard_wager():
		selection_locked = true
		_disable_offer_buttons()
		wizard_line.text = "Прежде чем выбирать... сыграем поинтереснее?"
		call_deferred("_show_wizard_wager")
	elif show_memory and not RunState.is_boss_due():
		var memory_line := RunState.consume_wizard_memory_line()
		if not memory_line.is_empty():
			default_wizard_line = memory_line
			wizard_line.text = default_wizard_line

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

	art.texture = CARD_ART_CATALOG.get_run_card_texture(card.card_id)
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if art.texture == null and not card.art_path.is_empty():
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
	if selection_locked or deal_in_progress:
		return

	var card := _get_button_card(button)
	if card != null:
		_animate_card_hover(button, true)
		_preview_card(card)

func _on_offer_button_mouse_exited(button: Button) -> void:
	if not selection_locked and not deal_in_progress:
		_animate_card_hover(button, false)
	_restore_wizard_line()

func _configure_card_pivots() -> void:
	for button in offer_buttons:
		button.pivot_offset = Vector2(120.0, 173.0)

func _layout_offer_cards(offer_count: int) -> void:
	for index in range(offer_buttons.size()):
		var button := offer_buttons[index]
		if not button.visible:
			continue

		var rest_position := SINGLE_CARD_POSITION
		var rest_rotation := 0.0
		if offer_count > 1:
			if index == 0:
				rest_position = LEFT_CARD_POSITION
				rest_rotation = LEFT_CARD_ROTATION
			else:
				rest_position = RIGHT_CARD_POSITION
				rest_rotation = RIGHT_CARD_ROTATION

		card_rest_positions[button.name] = rest_position
		card_rest_rotations[button.name] = rest_rotation
		if not deal_in_progress:
			button.position = rest_position
			button.rotation = rest_rotation
			button.scale = Vector2.ONE
			button.modulate = Color.WHITE
			button.z_index = 2

func _update_spread_ui() -> void:
	var deck_count := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		deck_count = maxi(0, deck_count - RunState.current_offer_ids.size())

	var discard_count := RunState.resolved_card_ids.size() + RunState.rejected_card_ids.size()
	deck_count_label.text = "КОЛОДА  %02d" % deck_count
	discard_count_label.text = "СБРОС  %02d" % discard_count
	if RunState.is_boss_due():
		spread_progress_label.text = "XIII"
	else:
		spread_progress_label.text = "%02d/%02d" % [
			RunState.cards_resolved,
			RunState.ACT_CARD_TARGET
		]

	if table_spread_visual != null and table_spread_visual.has_method("refresh"):
		table_spread_visual.call("refresh")

func _animate_deal_if_needed(offers: Array[RunCardData]) -> void:
	var signature := ""
	for card in offers:
		signature += "%s|" % card.card_id

	if signature == dealt_offer_signature:
		return

	dealt_offer_signature = signature
	if RunState.has_active_card():
		deal_in_progress = false
		for button in offer_buttons:
			if button.visible:
				_restore_card_pose_immediate(button)
		return

	deal_in_progress = true
	_disable_offer_buttons()
	call_deferred("_play_deal_sounds", offers.size())

	var visible_index := 0
	for button in offer_buttons:
		if not button.visible:
			continue

		var rest_position: Vector2 = card_rest_positions.get(button.name, button.position)
		var rest_rotation := float(card_rest_rotations.get(button.name, 0.0))
		var delay := float(visible_index) * 0.13
		visible_index += 1

		_kill_card_motion(button)
		button.position = DEAL_SOURCE_POSITION
		button.rotation = -0.15 + float(visible_index) * 0.018
		button.scale = Vector2(0.08, 0.68)
		button.modulate = Color(0.54, 0.38, 0.36, 0.22)
		button.z_index = 6

		var tween := button.create_tween()
		card_motion_tweens[button.name] = tween
		tween.set_parallel(true)
		tween.tween_property(button, "position", rest_position, 0.34).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation", rest_rotation, 0.34).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "scale", Vector2.ONE, 0.30).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "modulate", Color.WHITE, 0.26).set_delay(delay)

	call_deferred("_finish_deal_animation", 0.50 + maxf(0.0, float(visible_index - 1) * 0.13))

func _play_deal_sounds(card_count: int) -> void:
	for index in range(card_count):
		if index > 0:
			await get_tree().create_timer(0.13).timeout
		_play_table_audio("deal")

func _finish_deal_animation(duration: float) -> void:
	await get_tree().create_timer(duration).timeout
	deal_in_progress = false
	for button in offer_buttons:
		if button.visible:
			_restore_card_pose_immediate(button)
	if not selection_locked:
		_enable_offer_buttons()

func _animate_card_hover(button: Button, raised: bool) -> void:
	if not card_rest_positions.has(button.name):
		return

	_kill_card_motion(button)
	var rest_position: Vector2 = card_rest_positions[button.name]
	var rest_rotation := float(card_rest_rotations.get(button.name, 0.0))
	var tween := button.create_tween()
	card_motion_tweens[button.name] = tween
	tween.set_parallel(true)

	if raised:
		button.z_index = 20
		tween.tween_property(button, "position", rest_position + Vector2(0.0, -18.0), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation", rest_rotation * 0.30, 0.12)
		tween.tween_property(button, "scale", Vector2(1.04, 1.04), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		button.z_index = 2
		tween.tween_property(button, "position", rest_position, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation", rest_rotation, 0.12)
		tween.tween_property(button, "scale", Vector2.ONE, 0.12)

func _restore_card_pose_immediate(button: Button) -> void:
	_kill_card_motion(button)
	if card_rest_positions.has(button.name):
		button.position = card_rest_positions[button.name]
		button.rotation = float(card_rest_rotations.get(button.name, 0.0))
	button.scale = Vector2.ONE
	button.modulate = Color.WHITE
	button.z_index = 2

func _kill_card_motion(button: Button) -> void:
	var tween_value = card_motion_tweens.get(button.name)
	if tween_value is Tween:
		var tween := tween_value as Tween
		if tween.is_valid():
			tween.kill()
	card_motion_tweens.erase(button.name)

func _play_table_audio(event_name: String) -> void:
	if table_audio != null and table_audio.has_method("play_event"):
		table_audio.call("play_event", event_name)

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

func _show_wizard_wager() -> void:
	if deal_in_progress:
		await get_tree().create_timer(0.70).timeout

	if not RunState.has_pending_wizard_wager():
		selection_locked = false
		_enable_offer_buttons()
		return

	wager_root.visible = true
	wager_panel.pivot_offset = wager_panel.size * 0.5
	wager_panel.scale = Vector2(0.92, 0.92)
	wager_panel.modulate = Color(1.0, 0.80, 0.72, 0.0)

	var tween := wager_panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(wager_panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(wager_panel, "modulate", Color.WHITE, 0.16)

func _accept_wizard_wager() -> void:
	if not RunState.accept_pending_wizard_wager():
		return

	wager_root.visible = false
	selection_locked = false
	_refresh_table(false)
	default_wizard_line = "Вот и договорились. Следующий бой станет больнее. Следующая обычная добыча — вдвое слаще."
	wizard_line.text = default_wizard_line

func _refuse_wizard_wager() -> void:
	if not RunState.decline_pending_wizard_wager():
		return

	wager_root.visible = false
	selection_locked = false
	_refresh_table(false)
	default_wizard_line = "Какая осторожность. Почти разочаровывает."
	wizard_line.text = default_wizard_line

func _play_pending_wizard_meddling() -> void:
	if not RunState.has_pending_wizard_meddling():
		selection_locked = false
		_enable_offer_buttons()
		return

	await get_tree().create_timer(0.72).timeout
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
	_restore_card_pose_immediate(button)
	button.pivot_offset = button.size * 0.5
	wizard_line.text = "Нет. Эту карту я передумал отдавать."
	_play_table_audio("meddle")

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
	if selection_locked or deal_in_progress:
		return

	if not RunState.choose_card(card.card_id):
		return

	_update_spread_ui()
	selection_locked = true
	_disable_offer_buttons()
	wizard_line.text = card.wizard_line
	await _animate_card_choice(card.card_id)

	match card.resolution_type:
		"combat":
			get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
		"event", "prototype":
			get_tree().change_scene_to_file(card.target_path)
		_:
			push_warning("Unknown run card resolution type: %s" % card.resolution_type)
			selection_locked = false
			_refresh_table()

func _animate_card_choice(chosen_card_id: String) -> void:
	_play_table_audio("select")
	var has_rejected := false

	for button in offer_buttons:
		if not button.visible:
			continue

		_kill_card_motion(button)
		var button_card_id := String(button.get_meta("card_id", ""))
		var tween := button.create_tween()
		card_motion_tweens[button.name] = tween
		tween.set_parallel(true)

		if button_card_id == chosen_card_id:
			button.z_index = 30
			tween.tween_property(button, "position", SINGLE_CARD_POSITION + Vector2(0.0, -28.0), 0.30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "rotation", 0.0, 0.26)
			tween.tween_property(button, "scale", Vector2(1.07, 1.07), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		else:
			has_rejected = true
			button.z_index = 8
			tween.tween_property(button, "position", DISCARD_TARGET_POSITION, 0.30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween.tween_property(button, "rotation", 0.13, 0.30)
			tween.tween_property(button, "scale", Vector2(0.42, 0.42), 0.30)
			tween.tween_property(button, "modulate", Color(0.48, 0.34, 0.32, 0.15), 0.28)

	if has_rejected:
		await get_tree().create_timer(0.08).timeout
		_play_table_audio("discard")
		await get_tree().create_timer(0.26).timeout
	else:
		await get_tree().create_timer(0.32).timeout

func _disable_offer_buttons() -> void:
	for button in offer_buttons:
		button.disabled = true

func _enable_offer_buttons() -> void:
	if deal_in_progress or selection_locked:
		return

	for button in offer_buttons:
		if button.visible:
			button.disabled = false
