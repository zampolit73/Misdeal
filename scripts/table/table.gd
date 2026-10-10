extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const SQUAD_STATUS_SCENE := preload("res://scenes/table/squad_status.tscn")
const FATE_SPREAD_SCENE := preload("res://scenes/table/fate_spread_overlay.tscn")
const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

const LEFT_CARD_POSITION := Vector2(396.0, 366.0)
const RIGHT_CARD_POSITION := Vector2(654.0, 366.0)
const SINGLE_CARD_POSITION := Vector2(525.0, 366.0)
const DEAL_SOURCE_POSITION := Vector2(94.0, 408.0)
const DISCARD_TARGET_POSITION := Vector2(956.0, 408.0)
const LEFT_CARD_ROTATION := -0.024
const RIGHT_CARD_ROTATION := 0.024

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var wizard_backdrop: TextureRect = $WizardBackdrop
@onready var cards_root: Control = $Cards
@onready var offer_a_button: Button = $Cards/BonePatrolCard
@onready var offer_b_button: Button = $Cards/GraveyardCard
@onready var hold_a_button: Button = $Cards/HoldAButton
@onready var hold_b_button: Button = $Cards/HoldBButton
@onready var hidden_card_a: Button = $Cards/GallowsVolleyCard
@onready var hidden_card_b: Button = $Cards/WhisperingWellCard
@onready var squad_button: Button = $SquadButton
@onready var table_spread_visual: Control = $TableSpreadVisual
@onready var table_audio: Node = $TableAudio
@onready var deck_count_label: Label = $DeckCount
@onready var discard_count_label: Label = $DiscardCount
@onready var spread_progress_label: Label = $SpreadProgress
@onready var fate_spread_button: Button = $FateSpreadButton
@onready var wager_root: Control = $WagerOverlay/Root
@onready var wager_panel: Panel = $WagerOverlay/Root/WagerPanel
@onready var wager_risk_panel: Panel = $WagerOverlay/Root/WagerPanel/RiskPanel
@onready var wager_reward_panel: Panel = $WagerOverlay/Root/WagerPanel/RewardPanel
@onready var wager_risk_art: TextureRect = $WagerOverlay/Root/WagerPanel/RiskPanel/RiskArt
@onready var wager_reward_art: TextureRect = $WagerOverlay/Root/WagerPanel/RewardPanel/RewardArt
@onready var wager_accept_button: Button = $WagerOverlay/Root/WagerPanel/AcceptButton
@onready var wager_refuse_button: Button = $WagerOverlay/Root/WagerPanel/RefuseButton

var offer_buttons: Array[Button] = []
var squad_status: Control
var fate_spread_overlay: Control
var pending_fate_milestone := 0
var default_wizard_line := ""
var selection_locked := false
var deal_in_progress := false
var dealt_offer_signature := ""
var card_rest_positions: Dictionary = {}
var card_rest_rotations: Dictionary = {}
var card_motion_tweens: Dictionary = {}
var wizard_reaction_tween: Tween

func _ready() -> void:
	if RunState.is_run_complete():
		SCENE_ROUTER.change_to(self, "res://scenes/run_end/run_end.tscn")
		return

	offer_buttons = [offer_a_button, offer_b_button]
	_apply_ui_kit()
	hold_a_button.pressed.connect(_on_hold_button_pressed.bind(0))
	hold_b_button.pressed.connect(_on_hold_button_pressed.bind(1))
	hold_a_button.tooltip_text = "Один раз за Act 1: придержать эту карту и вернуть её через две раздачи."
	hold_b_button.tooltip_text = hold_a_button.tooltip_text
	for button in offer_buttons:
		button.pressed.connect(_on_offer_button_pressed.bind(button))
		button.mouse_entered.connect(_on_offer_button_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_offer_button_mouse_exited.bind(button))

	hidden_card_a.visible = false
	hidden_card_b.visible = false
	wager_root.visible = false
	wizard_backdrop.material = null
	wager_risk_art.material = null
	wager_reward_art.material = null
	wager_risk_art.texture = CARD_ART_CATALOG.get_run_card_texture("death_wager")
	wager_reward_art.texture = CARD_ART_CATALOG.get_reward_texture("gold_windfall")
	wager_risk_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	wager_reward_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	squad_button.pressed.connect(_toggle_squad_status)
	fate_spread_button.pressed.connect(_toggle_fate_spread)
	wager_accept_button.pressed.connect(_accept_wizard_wager)
	wager_refuse_button.pressed.connect(_refuse_wizard_wager)

	_configure_card_pivots()
	_refresh_table()

func _apply_ui_kit() -> void:
	MISDEAL_UI_KIT.apply_panel($HudPanel, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_panel($WizardLinePanel, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_subtitle(wizard_line, MISDEAL_UI_KIT.BRONZE)
	MISDEAL_UI_KIT.apply_action_button(squad_button, MISDEAL_UI_KIT.STEEL, false)
	MISDEAL_UI_KIT.apply_action_button(fate_spread_button, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_action_button(hold_a_button, MISDEAL_UI_KIT.STEEL, false)
	MISDEAL_UI_KIT.apply_action_button(hold_b_button, MISDEAL_UI_KIT.STEEL, false)

	for button in offer_buttons:
		MISDEAL_UI_KIT.apply_card_button(button, MISDEAL_UI_KIT.BRONZE)

	MISDEAL_UI_KIT.apply_panel(wager_panel, MISDEAL_UI_KIT.BRONZE, true)
	MISDEAL_UI_KIT.apply_panel(wager_risk_panel, MISDEAL_UI_KIT.EMBER, false)
	MISDEAL_UI_KIT.apply_panel(wager_reward_panel, MISDEAL_UI_KIT.GOLD, false)
	MISDEAL_UI_KIT.apply_action_button(wager_accept_button, MISDEAL_UI_KIT.EMBER, true)
	MISDEAL_UI_KIT.apply_action_button(wager_refuse_button, MISDEAL_UI_KIT.STEEL, false)


func _input(event: InputEvent) -> void:
	if selection_locked:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_viewport().set_input_as_handled()
			_toggle_fate_spread()
		elif event.keycode == KEY_TAB:
			get_viewport().set_input_as_handled()
			_toggle_squad_status()

func _toggle_fate_spread() -> void:
	if is_instance_valid(fate_spread_overlay):
		if fate_spread_overlay.has_method("close"):
			fate_spread_overlay.call("close")
		return

	if selection_locked or deal_in_progress or wager_root.visible:
		return

	if is_instance_valid(squad_status):
		squad_status.queue_free()
		squad_status = null
		cards_root.visible = true

	fate_spread_overlay = FATE_SPREAD_SCENE.instantiate() as Control
	if fate_spread_overlay == null:
		return

	# The inspection view owns the whole screen. Hide the live deal instead of
	# letting offer cards/hold controls compete with the historical spread.
	cards_root.visible = false
	fate_spread_button.visible = false
	spread_progress_label.visible = false

	fate_spread_overlay.z_index = 4095
	fate_spread_overlay.tree_exited.connect(_on_fate_spread_closed)
	add_child(fate_spread_overlay)

	if pending_fate_milestone > 0 and fate_spread_overlay.has_method("play_milestone"):
		var milestone := pending_fate_milestone
		pending_fate_milestone = 0
		fate_spread_overlay.call_deferred("play_milestone", milestone)


func _on_fate_spread_closed() -> void:
	fate_spread_overlay = null
	cards_root.visible = true
	fate_spread_button.visible = true
	spread_progress_label.visible = false


func _maybe_show_fate_milestone() -> void:
	if selection_locked or deal_in_progress or wager_root.visible:
		return
	if is_instance_valid(fate_spread_overlay) or is_instance_valid(squad_status):
		return

	var milestone: int = RunState.get_fate_milestone_due()
	if milestone <= 0:
		return

	RunState.mark_fate_milestone_shown(milestone)
	pending_fate_milestone = milestone
	_play_table_audio("milestone")
	_toggle_fate_spread()


func _toggle_squad_status() -> void:
	if is_instance_valid(fate_spread_overlay):
		return
	if is_instance_valid(squad_status):
		squad_status.queue_free()
		return

	squad_status = SQUAD_STATUS_SCENE.instantiate() as Control
	squad_status.z_index = 100
	squad_status.tree_exited.connect(_on_squad_status_closed)
	cards_root.visible = false
	add_child(squad_status)

func _on_squad_status_closed() -> void:
	cards_root.visible = true
	squad_status = null

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
	_refresh_hold_buttons(offers)
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
		var memory_event: String = RunState.wizard_memory_pending_event
		var memory_line := RunState.consume_wizard_memory_line()
		if not memory_line.is_empty():
			default_wizard_line = memory_line
			wizard_line.text = default_wizard_line
			call_deferred("_play_wizard_memory_tell", memory_event)

func _play_wizard_memory_tell(event_id: String) -> void:
	if event_id.is_empty() or not is_inside_tree():
		return

	if event_id == "deliberate_loner" or event_id == "companion_lost":
		var card_tween := cards_root.create_tween()
		card_tween.tween_property(cards_root, "modulate", Color(0.54, 0.42, 0.46, 0.72), 0.16)
		card_tween.tween_interval(0.18)
		card_tween.tween_property(cards_root, "modulate", Color.WHITE, 0.34)

		var line_tween := wizard_line.create_tween()
		line_tween.tween_property(wizard_line, "modulate", Color(1.0, 0.42, 0.30, 1.0), 0.14)
		line_tween.tween_interval(0.16)
		line_tween.tween_property(wizard_line, "modulate", Color.WHITE, 0.30)
	elif event_id == "rescue_scar":
		var line_tween := wizard_line.create_tween()
		line_tween.tween_property(wizard_line, "modulate", Color(1.0, 0.58, 0.38, 1.0), 0.14)
		line_tween.tween_interval(0.12)
		line_tween.tween_property(wizard_line, "modulate", Color.WHITE, 0.26)


func _setup_offer_button(button: Button, card: RunCardData) -> void:
	var art := button.get_node("Art") as TextureRect
	var title_label := button.get_node("Title") as Label
	var type_label := button.get_node("Type") as Label
	var description_label := button.get_node("Description") as Label
	var hint_label := button.get_node("Hint") as Label
	var mark_label := button.get_node("Mark") as Label

	button.set_meta("card_id", card.card_id)
	title_label.text = card.title
	type_label.text = _get_card_type_line(card)
	description_label.text = card.card_text
	hint_label.text = _get_hint_text(card)
	button.tooltip_text = ""
	button.disabled = false
	button.modulate = Color.WHITE

	var marked: bool = RunState.is_wizard_marked_card(card.card_id)
	mark_label.visible = marked
	if marked:
		hint_label.text = "ПЕЧАТЬ • +20 ЗОЛ. • ВРАГИ +15%"

	if RunState.is_card_held(card.card_id):
		hint_label.text = "УДЕРЖАНО • ВЕРНЁТСЯ ЧЕРЕЗ 2 КАРТЫ"

	art.texture = CARD_ART_CATALOG.get_run_card_texture(card.card_id)
	art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	art.material = null
	if art.texture == null and not card.art_path.is_empty():
		var texture := load(card.art_path) as Texture2D
		if texture != null:
			art.texture = texture

	_apply_card_style(button, card)

func _refresh_hold_buttons(offers: Array[RunCardData]) -> void:
	var hold_buttons: Array[Button] = [hold_a_button, hold_b_button]
	var show_hold: bool = offers.size() == 2 and not RunState.fate_hold_used and not RunState.has_active_card() and RunState.cards_resolved <= 9

	for index in range(hold_buttons.size()):
		var hold_button: Button = hold_buttons[index]
		hold_button.visible = show_hold and index < offers.size()
		hold_button.disabled = not hold_button.visible
		hold_button.text = "УДЕРЖАТЬ"

	if RunState.has_held_card():
		for index in range(offers.size()):
			if RunState.is_card_held(offers[index].card_id):
				hold_buttons[index].visible = true
				hold_buttons[index].disabled = true
				hold_buttons[index].text = "УДЕРЖАНО"
				for other_index in range(hold_buttons.size()):
					if other_index != index:
						hold_buttons[other_index].visible = false
				break

func _on_hold_button_pressed(offer_index: int) -> void:
	if selection_locked or deal_in_progress:
		return

	var offers := RunState.get_offer_cards()
	if offer_index < 0 or offer_index >= offers.size():
		return

	var card := offers[offer_index]
	var card_button := offer_buttons[offer_index]
	var hold_button := hold_a_button if offer_index == 0 else hold_b_button

	selection_locked = true
	_disable_offer_buttons()
	hold_a_button.disabled = true
	hold_b_button.disabled = true
	await _animate_card_hold_stamp(card_button, hold_button)

	if not RunState.hold_offer_card(card.card_id):
		selection_locked = false
		_restore_card_pose_immediate(card_button)
		_enable_offer_buttons()
		_refresh_hold_buttons(offers)
		return

	wizard_line.text = "«Хочешь оставить её на потом? Хорошо. Я верну её через две раздачи.»"
	if table_spread_visual != null and table_spread_visual.has_method("pulse_ritual"):
		table_spread_visual.call("pulse_ritual", "hold")
	_setup_offer_button(card_button, card)
	_refresh_hold_buttons(offers)
	await _animate_card_return_from_hold(card_button)

	selection_locked = false
	_enable_offer_buttons()
	_refresh_hold_buttons(offers)


func _animate_card_hold_stamp(card_button: Button, hold_button: Button) -> void:
	_kill_card_motion(card_button)
	card_button.pivot_offset = card_button.size * 0.5
	hold_button.pivot_offset = hold_button.size * 0.5

	var target_position := hold_button.position + hold_button.size * 0.5 - card_button.size * 0.5
	var tween := card_button.create_tween()
	card_motion_tweens[card_button.name] = tween
	tween.set_parallel(true)
	tween.tween_property(card_button, "position", target_position, 0.20).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(card_button, "rotation", 0.0, 0.18)
	tween.tween_property(card_button, "scale", Vector2(0.18, 0.18), 0.20).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(card_button, "modulate", Color(0.82, 0.72, 0.62, 0.86), 0.18)
	await tween.finished

	var stamp := hold_button.create_tween()
	stamp.tween_property(hold_button, "scale", Vector2(1.08, 0.92), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	stamp.tween_property(hold_button, "scale", Vector2.ONE, 0.11).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await stamp.finished


func _animate_card_return_from_hold(card_button: Button) -> void:
	var rest_position: Vector2 = card_rest_positions.get(card_button.name, card_button.position)
	var rest_rotation := float(card_rest_rotations.get(card_button.name, 0.0))
	var tween := card_button.create_tween()
	card_motion_tweens[card_button.name] = tween
	tween.set_parallel(true)
	tween.tween_property(card_button, "position", rest_position, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_button, "rotation", rest_rotation, 0.18)
	tween.tween_property(card_button, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_button, "modulate", Color.WHITE, 0.16)
	await tween.finished

func _get_button_card(button: Button) -> RunCardData:
	var card_id := String(button.get_meta("card_id", ""))
	if card_id.is_empty():
		return null
	return RunState.get_card(card_id)


func _on_offer_button_pressed(button: Button) -> void:
	var card := _get_button_card(button)
	if card == null:
		return
	if RunState.is_card_held(card.card_id):
		wizard_line.text = "«Нет-нет. Эту карту ты попросил придержать. Выбирай другую.»"
		return
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
		button.pivot_offset = Vector2(115.0, 139.0)

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

	var discard_count := RunState.rejected_card_ids.size()
	deck_count_label.text = "%02d" % deck_count
	discard_count_label.text = "%02d" % discard_count
	var remaining_to_boss: int = maxi(0, RunState.ACT_CARD_TARGET - RunState.cards_resolved)
	if RunState.is_boss_due():
		spread_progress_label.text = "XIII • ПРИГОВОР"
	else:
		spread_progress_label.text = "ДО XIII • %02d" % remaining_to_boss
	spread_progress_label.visible = false

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
	if table_spread_visual != null and table_spread_visual.has_method("pulse_deal"):
		table_spread_visual.call("pulse_deal")
	call_deferred("_play_deal_sounds", offers.size())

	var deal_mode := "neutral"
	if RunState.wizard_wagers_accepted > RunState.wizard_wagers_declined:
		deal_mode = "pleased"
	elif RunState.wizard_wagers_declined > RunState.wizard_wagers_accepted:
		deal_mode = "irritated"

	var visible_index := 0
	for button in offer_buttons:
		if not button.visible:
			continue

		var rest_position: Vector2 = card_rest_positions.get(button.name, button.position)
		var rest_rotation := float(card_rest_rotations.get(button.name, 0.0))
		var delay := float(visible_index) * (0.16 if deal_mode == "pleased" else (0.09 if deal_mode == "irritated" else 0.13))
		visible_index += 1

		var duration := 0.34
		var start_rotation := -0.15 + float(visible_index) * 0.018
		var start_scale := Vector2(0.08, 0.68)
		var start_modulate := Color(0.54, 0.38, 0.36, 0.22)
		if deal_mode == "pleased":
			duration = 0.40
			start_rotation = -0.08 + float(visible_index) * 0.012
			start_scale = Vector2(0.12, 0.72)
			start_modulate = Color(0.70, 0.52, 0.46, 0.30)
		elif deal_mode == "irritated":
			duration = 0.25
			start_rotation = (-0.24 if visible_index % 2 == 1 else 0.24)
			start_scale = Vector2(0.06, 0.88)
			start_modulate = Color(0.62, 0.22, 0.18, 0.34)

		_kill_card_motion(button)
		button.position = DEAL_SOURCE_POSITION
		button.rotation = start_rotation
		button.scale = start_scale
		button.modulate = start_modulate
		button.z_index = 6

		var tween := button.create_tween()
		card_motion_tweens[button.name] = tween
		tween.set_parallel(true)
		tween.tween_property(button, "position", rest_position, duration).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation", rest_rotation, duration).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "scale", Vector2.ONE, duration - 0.04).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "modulate", Color.WHITE, duration - 0.08).set_delay(delay)

	var total_delay := 0.56 if deal_mode == "pleased" else (0.38 if deal_mode == "irritated" else 0.50)
	total_delay += maxf(0.0, float(visible_index - 1) * (0.16 if deal_mode == "pleased" else (0.09 if deal_mode == "irritated" else 0.13)))
	call_deferred("_finish_deal_animation", total_delay)

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
		call_deferred("_maybe_show_fate_milestone")

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
		tween.tween_property(button, "position", rest_position + Vector2(0.0, -14.0), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "rotation", rest_rotation * 0.24, 0.12)
		tween.tween_property(button, "scale", Vector2(1.03, 1.03), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
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

func _pulse_wizard_reaction(kind: String = "attention") -> void:
	if wizard_backdrop == null:
		return

	if wizard_reaction_tween != null and wizard_reaction_tween.is_valid():
		wizard_reaction_tween.kill()

	var tint := Color(1.0, 0.92, 0.88, 1.0)
	var attack_time := 0.08
	var settle_time := 0.26
	match kind:
		"meddle":
			tint = Color(1.0, 0.70, 0.62, 1.0)
			attack_time = 0.06
			settle_time = 0.34
		"pleased":
			tint = Color(1.0, 0.86, 0.72, 1.0)
		"cold":
			tint = Color(0.82, 0.90, 1.0, 1.0)
			settle_time = 0.30
		"offer":
			tint = Color(1.0, 0.84, 0.78, 1.0)

	if table_spread_visual != null and table_spread_visual.has_method("pulse_ritual"):
		table_spread_visual.call("pulse_ritual", kind)

	wizard_reaction_tween = wizard_backdrop.create_tween()
	wizard_reaction_tween.tween_property(wizard_backdrop, "modulate", tint, attack_time)
	wizard_reaction_tween.tween_interval(0.04)
	wizard_reaction_tween.tween_property(wizard_backdrop, "modulate", Color.WHITE, settle_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _play_table_audio(event_name: String) -> void:
	if table_audio != null and table_audio.has_method("play_event"):
		table_audio.call("play_event", event_name)

func _get_card_type_line(card: RunCardData) -> String:
	match card.card_id:
		"bone_patrol":
			return "БОЙ • ФРОНТ"
		"graveyard_ambush":
			return "БОЙ • ДАЛЬНИЙ"
		"gallows_volley":
			return "БОЙ • 2 ЛУЧНИКА"
		"grave_bell":
			return "БОЙ • ЛЕЧЕНИЕ"
		"bone_crush":
			return "БОЙ • РОЙ"
		"crypt_guard":
			return "ЭЛИТА • AOE"
		"ossuary_gate":
			return "БОЙ • ЛЕЧЕНИЕ"
		"death_wager":
			return "СТАВКА • AOE + ДАЛЬНИЙ"
		"bone_swarm":
			return "БОЙ • БЫСТРЫЙ РОЙ"
		"grave_crossfire":
			return "БОЙ • ПЕРЕКРЁСТНЫЙ ОГОНЬ"
		"iron_wall":
			return "БОЙ • 2 СТРАЖА"
		"last_bell":
			return "БОЙ • 2 ЗВОНАРЯ"
		"firing_square":
			return "БОЙ • 4 ЛУЧНИКА"
		"bone_ritual":
			return "БОЙ • СМЕШАННЫЙ"
		"bone_warden":
			return "БОСС • AOE • ФАЗЫ"
		_:
			return card.type_label

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
	normal.bg_color = Color(0.032, 0.020, 0.021, 0.992)
	normal.border_width_left = 3
	normal.border_width_top = 3
	normal.border_width_right = 3
	normal.border_width_bottom = 3
	normal.border_color = Color(0.66, 0.42, 0.20, 1.0)
	normal.shadow_color = Color(0, 0, 0, 0.68)
	normal.shadow_size = 8

	var hover := normal.duplicate() as StyleBoxFlat
	hover.border_width_left = 4
	hover.border_width_top = 4
	hover.border_width_right = 4
	hover.border_width_bottom = 4
	hover.border_color = Color(0.98, 0.62, 0.26, 1.0)
	hover.shadow_color = Color(0.48, 0.12, 0.03, 0.58)
	hover.shadow_size = 12

	if card.card_id == RunState.BOSS_CARD_ID:
		normal.border_color = Color(0.72, 0.20, 0.12, 1.0)
		hover.border_color = Color(1.0, 0.42, 0.18, 1.0)
	elif RunState.is_wizard_marked_card(card.card_id):
		normal.border_color = Color(0.92, 0.48, 0.12, 1.0)
		normal.shadow_color = Color(0.62, 0.13, 0.03, 0.62)
		normal.shadow_size = 12
		hover.border_color = Color(1.0, 0.72, 0.22, 1.0)
		hover.shadow_color = Color(0.82, 0.22, 0.04, 0.72)
		hover.shadow_size = 16
	elif RunState.is_card_held(card.card_id):
		normal.border_color = Color(0.42, 0.68, 0.84, 1.0)
		hover.border_color = Color(0.62, 0.84, 1.0, 1.0)

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
	elif RunState.is_wizard_marked_card(card.card_id):
		type_label.add_theme_color_override("font_color", Color(1.0, 0.58, 0.18, 1.0))
		title_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.42, 1.0))

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
	_pulse_wizard_reaction("offer")
	wager_panel.pivot_offset = wager_panel.size * 0.5
	wager_panel.scale = Vector2(0.95, 0.95)
	wager_panel.modulate = Color(1.0, 0.80, 0.72, 0.0)
	wager_risk_panel.modulate.a = 0.0
	wager_reward_panel.modulate.a = 0.0

	var tween := wager_panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(wager_panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(wager_panel, "modulate", Color.WHITE, 0.16)

	var detail_tween := wager_panel.create_tween()
	detail_tween.set_parallel(true)
	detail_tween.tween_property(wager_risk_panel, "modulate:a", 1.0, 0.14).set_delay(0.07)
	detail_tween.tween_property(wager_reward_panel, "modulate:a", 1.0, 0.14).set_delay(0.11)

func _accept_wizard_wager() -> void:
	if not RunState.accept_pending_wizard_wager():
		return

	wager_root.visible = false
	selection_locked = false
	_refresh_table(false)
	default_wizard_line = "Вот и договорились. Следующий бой станет больнее, добыча — вдвое слаще. И я дам тебе ещё один приказ: «ЖЕРТВА»."
	wizard_line.text = default_wizard_line
	_pulse_wizard_reaction("pleased")

func _refuse_wizard_wager() -> void:
	if not RunState.decline_pending_wizard_wager():
		return

	wager_root.visible = false
	selection_locked = false
	_refresh_table(false)
	default_wizard_line = "Какая осторожность. Почти разочаровывает."
	wizard_line.text = default_wizard_line
	_pulse_wizard_reaction("cold")


func _play_pending_wizard_meddling() -> void:
	if not RunState.has_pending_wizard_meddling():
		selection_locked = false
		_enable_offer_buttons()
		return

	await get_tree().create_timer(0.46).timeout
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

	var rest_position: Vector2 = card_rest_positions.get(button.name, button.position)
	var rest_rotation := float(card_rest_rotations.get(button.name, button.rotation))
	var tell_rotation := rest_rotation + (-0.035 if offer_index == 0 else 0.035)
	var tell_tween := button.create_tween()
	tell_tween.set_parallel(true)
	tell_tween.tween_property(button, "position", rest_position + Vector2(0.0, -5.0), 0.10).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tell_tween.tween_property(button, "rotation", tell_rotation, 0.10)
	tell_tween.tween_property(button, "scale", Vector2(1.015, 1.015), 0.10)
	await tell_tween.finished

	var settle_tween := button.create_tween()
	settle_tween.set_parallel(true)
	settle_tween.tween_property(button, "position", rest_position, 0.10)
	settle_tween.tween_property(button, "rotation", rest_rotation, 0.10)
	settle_tween.tween_property(button, "scale", Vector2.ONE, 0.10)
	await settle_tween.finished
	await get_tree().create_timer(0.08).timeout

	wizard_line.text = "Нет. Эту карту я передумал отдавать."
	_pulse_wizard_reaction("meddle")
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

	var was_marked: bool = RunState.is_wizard_marked_card(card.card_id)
	if not RunState.choose_card(card.card_id):
		return

	selection_locked = true
	_disable_offer_buttons()
	hold_a_button.visible = false
	hold_b_button.visible = false
	if was_marked:
		wizard_line.text = "«Печать принята. +20 золота. А следующий бой получит свои +15% боли.»"
		_pulse_wizard_reaction("meddle")
	else:
		wizard_line.text = card.wizard_line
	await _animate_card_choice(card.card_id)

	match card.resolution_type:
		"combat":
			SCENE_ROUTER.change_to(self, "res://scenes/battle/battle.tscn")
		"event", "prototype":
			SCENE_ROUTER.change_to(self, card.target_path)
		_:
			push_warning("Unknown run card resolution type: %s" % card.resolution_type)
			selection_locked = false
			_refresh_table()

func _animate_card_choice(chosen_card_id: String) -> void:
	_play_table_audio("select")
	if table_spread_visual != null and table_spread_visual.has_method("pulse_ritual"):
		table_spread_visual.call("pulse_ritual", "choice")
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
			tween.tween_property(button, "position", SINGLE_CARD_POSITION + Vector2(0.0, 24.0), 0.30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "rotation", 0.0, 0.26)
			tween.tween_property(button, "scale", Vector2(1.08, 1.08), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "modulate", Color(1.08, 0.98, 0.90, 1.0), 0.22)
		else:
			has_rejected = true
			button.z_index = 8
			tween.tween_property(button, "position", DISCARD_TARGET_POSITION, 0.30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween.tween_property(button, "rotation", 0.13, 0.30)
			tween.tween_property(button, "scale", Vector2(0.42, 0.42), 0.30)
			tween.tween_property(button, "modulate", Color(0.48, 0.34, 0.32, 0.15), 0.28)

	if has_rejected:
		await get_tree().create_timer(0.22).timeout
		_update_spread_ui()
		_play_table_audio("discard")
		if table_spread_visual != null and table_spread_visual.has_method("pulse_discard"):
			table_spread_visual.call("pulse_discard")
		var discard_pulse := discard_count_label.create_tween()
		discard_count_label.pivot_offset = discard_count_label.size * 0.5
		discard_pulse.tween_property(discard_count_label, "scale", Vector2(1.16, 1.16), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		discard_pulse.tween_property(discard_count_label, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(0.12).timeout
	else:
		await get_tree().create_timer(0.32).timeout
		_update_spread_ui()


func _disable_offer_buttons() -> void:
	for button in offer_buttons:
		button.disabled = true
	hold_a_button.disabled = true
	hold_b_button.disabled = true


func _enable_offer_buttons() -> void:
	if deal_in_progress or selection_locked:
		return

	for button in offer_buttons:
		if button.visible:
			button.disabled = false

	var offers := RunState.get_offer_cards()
	_refresh_hold_buttons(offers)
	call_deferred("_maybe_show_fate_milestone")

