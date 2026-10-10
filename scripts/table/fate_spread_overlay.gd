extends Control

const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const BOSS_SEAL_SCRIPT := preload("res://scripts/table/fate_boss_seal_visual.gd")

signal closed

const SLOT_SIZE := Vector2(88.0, 126.0)
const SLOT_CENTER := Vector2(390.0, 260.0)
const BOSS_SIZE := Vector2(142.0, 194.0)
const SLOT_CENTERS := [
	Vector2(383.0, 51.0),
	Vector2(506.0, 84.0),
	Vector2(613.0, 146.0),
	Vector2(690.0, 244.0),
	Vector2(632.0, 358.0),
	Vector2(520.0, 430.0),
	Vector2(390.0, 470.0),
	Vector2(243.0, 448.0),
	Vector2(142.0, 352.0),
	Vector2(90.0, 250.0),
	Vector2(170.0, 134.0),
	Vector2(278.0, 82.0),
]
const SLOT_ROTATIONS_DEG := [0.0, 7.0, 10.0, 11.0, 9.0, 6.0, 0.0, -7.0, -10.0, -11.0, -9.0, -6.0]

const SLOT_FILL := Color(0.030, 0.020, 0.026, 0.96)
const SLOT_BORDER := Color(0.34, 0.22, 0.19, 0.78)
const SLOT_DONE := Color(0.76, 0.44, 0.18, 0.96)
const SLOT_CURRENT := Color(0.95, 0.26, 0.12, 1.0)
const SLOT_FUTURE := Color(0.20, 0.16, 0.18, 0.74)
const BOSS_BORDER := Color(0.92, 0.18, 0.10, 1.0)

@onready var frame: Panel = $Frame
@onready var subtitle: Label = $Frame/Subtitle
@onready var phase_label: Label = $Frame/Phase
@onready var counts_label: Label = $Frame/Counts
@onready var spread_area: Control = $Frame/SpreadArea
@onready var reference_cleanup: Control = $Frame/SpreadArea/ReferenceCleanup
@onready var seal_visual: Control = $Frame/SpreadArea/SealVisual
@onready var close_button: Button = $Frame/Close
@onready var held_art: TextureRect = $Frame/HeldPanel/Art
@onready var held_title: Label = $Frame/HeldPanel/CardTitle
@onready var held_title_plate: ColorRect = $Frame/HeldPanel/TitlePlate
@onready var held_status: Label = $Frame/HeldPanel/Status
@onready var discard_card_layer: Control = $Frame/DiscardPanel/CardLayer
@onready var discard_art: TextureRect = $Frame/DiscardPanel/CardLayer/Art
@onready var discard_title: Label = $Frame/DiscardPanel/CardLayer/CardTitle
@onready var discard_title_plate: ColorRect = $Frame/DiscardPanel/CardLayer/TitlePlate
@onready var discard_status: Label = $Frame/DiscardPanel/Status
@onready var detail_panel: Panel = $Frame/DetailPanel
@onready var detail_title: Label = $Frame/DetailPanel/Title
@onready var detail_body: Label = $Frame/DetailPanel/Body

var slot_panels: Array[Panel] = []
var boss_panel: Panel
var boss_art: TextureRect
var boss_title: Label
var boss_seal_visual: Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 4095
	close_button.pressed.connect(close)
	_build_slots()
	refresh()
	_animate_in()


func refresh() -> void:
	var remaining: int = maxi(0, RunState.ACT_CARD_TARGET - RunState.cards_resolved)
	subtitle.text = (
		"КОСТЯНОЙ НАДЗИРАТЕЛЬ ЖДЁТ"
		if remaining == 0
		else "ДО КОСТЯНОГО НАДЗИРАТЕЛЯ: %d %s" % [remaining, _card_word(remaining)]
	)
	phase_label.text = _get_phase_text()
	_apply_phase_style()
	counts_label.text = "ПРОЙДЕНО: %d   |   ОТВЕРГНУТО: %d   |   УДЕРЖАНО: %d" % [
		RunState.resolved_card_ids.size(),
		RunState.rejected_card_ids.size(),
		1 if RunState.has_held_card() else 0
	]

	if reference_cleanup != null and reference_cleanup.has_method("refresh"):
		reference_cleanup.call("refresh")
	if seal_visual != null and seal_visual.has_method("refresh"):
		seal_visual.call("refresh")
	_refresh_slots()
	_refresh_boss()
	_refresh_held()
	_refresh_discard()


func close() -> void:
	if not is_inside_tree():
		return
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.12)
	tween.tween_property(frame, "scale", Vector2(0.985, 0.985), 0.12)
	await tween.finished
	closed.emit()
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.pressed and not key_event.echo and (key_event.keycode == KEY_R or key_event.keycode == KEY_ESCAPE):
			get_viewport().set_input_as_handled()
			close()


func _build_slots() -> void:
	for index in range(RunState.ACT_CARD_TARGET):
		var panel := Panel.new()
		panel.name = "FateSlot%02d" % (index + 1)
		panel.size = SLOT_SIZE
		panel.mouse_filter = Control.MOUSE_FILTER_STOP
		panel.pivot_offset = SLOT_SIZE * 0.5
		panel.mouse_entered.connect(_on_slot_mouse_entered.bind(index))
		panel.mouse_exited.connect(_on_slot_mouse_exited.bind(index))

		var center: Vector2 = SLOT_CENTERS[index]
		panel.position = center - SLOT_SIZE * 0.5
		panel.rotation = deg_to_rad(float(SLOT_ROTATIONS_DEG[index]))
		spread_area.add_child(panel)

		var roman := Label.new()
		roman.name = "Roman"
		roman.position = Vector2(-4.0, -20.0)
		roman.size = Vector2(SLOT_SIZE.x + 8.0, 18.0)
		roman.text = _roman(index + 1)
		roman.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		roman.add_theme_font_size_override("font_size", 12)
		roman.add_theme_color_override("font_color", Color(0.92, 0.72, 0.46, 0.96))
		roman.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(roman)

		var art := TextureRect.new()
		art.name = "Art"
		art.position = Vector2(6.0, 6.0)
		art.size = Vector2(76.0, 70.0)
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(art)

		var symbol := Label.new()
		symbol.name = "Symbol"
		symbol.position = Vector2(6.0, 6.0)
		symbol.size = Vector2(76.0, 70.0)
		symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		symbol.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		symbol.add_theme_font_size_override("font_size", 28)
		symbol.add_theme_color_override("font_color", Color(0.46, 0.40, 0.42, 0.72))
		symbol.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(symbol)

		var title_plate := ColorRect.new()
		title_plate.name = "TitlePlate"
		title_plate.position = Vector2(6.0, 80.0)
		title_plate.size = Vector2(76.0, 40.0)
		title_plate.color = Color(0.78, 0.68, 0.52, 0.98)
		title_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(title_plate)

		var title := Label.new()
		title.name = "CardTitle"
		title.position = Vector2(8.0, 82.0)
		title.size = Vector2(72.0, 36.0)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title.add_theme_font_size_override("font_size", 9)
		title.add_theme_color_override("font_color", Color(0.20, 0.12, 0.09, 0.98))
		title.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(title)

		slot_panels.append(panel)

	boss_panel = Panel.new()
	boss_panel.name = "BossSlot"
	boss_panel.size = BOSS_SIZE
	boss_panel.position = SLOT_CENTER - BOSS_SIZE * 0.5
	boss_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spread_area.add_child(boss_panel)

	var boss_roman := Label.new()
	boss_roman.position = Vector2(0.0, -24.0)
	boss_roman.size = Vector2(BOSS_SIZE.x, 20.0)
	boss_roman.text = "XIII"
	boss_roman.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_roman.add_theme_font_size_override("font_size", 15)
	boss_roman.add_theme_color_override("font_color", Color(1.0, 0.42, 0.22, 1.0))
	boss_panel.add_child(boss_roman)

	boss_art = TextureRect.new()
	boss_art.position = Vector2(8.0, 8.0)
	boss_art.size = Vector2(126.0, 112.0)
	boss_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boss_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	boss_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	boss_panel.add_child(boss_art)

	boss_title = Label.new()
	boss_title.position = Vector2(8.0, 128.0)
	boss_title.size = Vector2(126.0, 54.0)
	boss_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	boss_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	boss_title.add_theme_font_size_override("font_size", 10)
	boss_panel.add_child(boss_title)

	boss_seal_visual = BOSS_SEAL_SCRIPT.new() as Control
	if boss_seal_visual != null:
		boss_seal_visual.name = "ChainSeal"
		boss_seal_visual.position = Vector2.ZERO
		boss_seal_visual.size = BOSS_SIZE
		boss_seal_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
		boss_panel.add_child(boss_seal_visual)


func _on_slot_mouse_entered(index: int) -> void:
	if index < 0 or index >= slot_panels.size():
		return
	if index >= RunState.resolved_card_ids.size():
		return

	var panel := slot_panels[index]
	panel.z_index = 30
	var tween := panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "scale", Vector2(1.10, 1.10), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1.08, 1.02, 0.94, 1.0), 0.12)

	_show_history_detail(index)


func _on_slot_mouse_exited(index: int) -> void:
	if index < 0 or index >= slot_panels.size():
		return
	var panel := slot_panels[index]
	panel.z_index = 0
	var tween := panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.10)
	tween.tween_property(panel, "modulate", Color.WHITE, 0.10)

	detail_panel.visible = false


func _show_history_detail(index: int) -> void:
	var entry: Dictionary = RunState.get_fate_choice_history_entry(index)
	if entry.is_empty():
		return

	var chosen_id := String(entry.get("chosen", ""))
	var rejected_id := String(entry.get("rejected", ""))
	var chosen_card: RunCardData = RunState.get_card(chosen_id)
	var rejected_card: RunCardData = null
	if not rejected_id.is_empty():
		rejected_card = RunState.get_card(rejected_id)
	var chosen_title: String = chosen_card.title if chosen_card != null else chosen_id
	var rejected_title: String = rejected_card.title if rejected_card != null else "—"

	detail_title.text = "%s  •  %s" % [_roman(index + 1), chosen_title]
	detail_body.text = "ВЫБРАНО: %s   |   ОТВЕРГНУТО: %s" % [chosen_title, rejected_title]
	_position_history_detail()
	detail_panel.visible = true


func _position_history_detail() -> void:
	var mouse := get_viewport().get_mouse_position()
	var panel_size := detail_panel.size
	var target := mouse + Vector2(18.0, 18.0)

	if target.x + panel_size.x > 1266.0:
		target.x = mouse.x - panel_size.x - 18.0
	if target.y + panel_size.y > 706.0:
		target.y = mouse.y - panel_size.y - 18.0

	target.x = clampf(target.x, 12.0, 1268.0 - panel_size.x)
	target.y = clampf(target.y, 118.0, 708.0 - panel_size.y)
	detail_panel.position = target


func play_milestone(milestone: int) -> void:
	if milestone != 4 and milestone != 8 and milestone != 12:
		return

	await get_tree().create_timer(0.24).timeout
	if not is_inside_tree():
		return

	var flash_color := Color(1.0, 0.48, 0.18, 1.0)
	if milestone >= 8:
		flash_color = Color(1.0, 0.28, 0.10, 1.0)
	if milestone >= 12:
		flash_color = Color(1.0, 0.16, 0.06, 1.0)

	var original_phase_scale := phase_label.scale
	phase_label.pivot_offset = phase_label.size * 0.5
	var phase_tween := phase_label.create_tween()
	phase_tween.tween_property(phase_label, "modulate", flash_color, 0.10)
	phase_tween.parallel().tween_property(phase_label, "scale", Vector2(1.08, 1.08), 0.10)
	phase_tween.tween_property(phase_label, "modulate", Color.WHITE, 0.28)
	phase_tween.parallel().tween_property(phase_label, "scale", original_phase_scale, 0.28)

	if seal_visual != null:
		var seal_tween := seal_visual.create_tween()
		seal_tween.tween_property(seal_visual, "modulate", Color(1.6, 0.72, 0.48, 1.0), 0.08)
		seal_tween.tween_property(seal_visual, "modulate", Color.WHITE, 0.32)

	var milestone_index := milestone - 1
	if milestone_index >= 0 and milestone_index < slot_panels.size():
		var milestone_panel := slot_panels[milestone_index]
		if milestone_panel.visible:
			milestone_panel.z_index = 40
			var card_tween := milestone_panel.create_tween()
			card_tween.tween_property(milestone_panel, "scale", Vector2(1.16, 1.16), 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			card_tween.parallel().tween_property(milestone_panel, "modulate", flash_color, 0.10)
			card_tween.tween_property(milestone_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			card_tween.parallel().tween_property(milestone_panel, "modulate", Color.WHITE, 0.20)
			card_tween.tween_callback(_reset_slot_z.bind(milestone_panel))

	var counts_tween := counts_label.create_tween()
	counts_label.pivot_offset = counts_label.size * 0.5
	counts_tween.tween_property(counts_label, "scale", Vector2(1.035, 1.035), 0.08)
	counts_tween.tween_property(counts_label, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if boss_panel != null:
		var base_position := boss_panel.position
		var shake := boss_panel.create_tween()
		shake.tween_property(boss_panel, "position", base_position + Vector2(-5.0, 1.0), 0.045)
		shake.tween_property(boss_panel, "position", base_position + Vector2(5.0, -1.0), 0.045)
		shake.tween_property(boss_panel, "position", base_position + Vector2(-3.0, 0.0), 0.045)
		shake.tween_property(boss_panel, "position", base_position, 0.07)

func _reset_slot_z(panel: Panel) -> void:
	if panel != null and is_instance_valid(panel):
		panel.z_index = 0


func _refresh_slots() -> void:
	for index in range(slot_panels.size()):
		var panel := slot_panels[index]
		var art := panel.get_node("Art") as TextureRect
		var symbol := panel.get_node("Symbol") as Label
		var title_plate := panel.get_node("TitlePlate") as ColorRect
		var title := panel.get_node("CardTitle") as Label

		var card_id := ""
		var state := "future"
		if index < RunState.resolved_card_ids.size():
			card_id = RunState.resolved_card_ids[index]
			state = "done"
		elif index == RunState.cards_resolved and RunState.has_active_card() and RunState.active_card_id != RunState.BOSS_CARD_ID:
			card_id = RunState.active_card_id
			state = "current"
		elif index == RunState.cards_resolved and not RunState.is_boss_due():
			state = "current"

		if not card_id.is_empty():
			var card := RunState.get_card(card_id)
			art.texture = CARD_ART_CATALOG.get_run_card_texture(card_id)
			art.visible = art.texture != null
			symbol.visible = false
			title.text = card.title if card != null else card_id
		else:
			art.texture = null
			art.visible = false
			symbol.visible = true
			symbol.text = "◆" if state == "current" else _future_symbol(index)
			title.text = "СЛЕДУЮЩАЯ" if state == "current" else "НЕИЗВЕСТНО"

		var use_reference_future: bool = state == "future" and index >= 4 and index != 11
		panel.visible = not use_reference_future
		if use_reference_future:
			continue

		var accent := SLOT_FUTURE
		if state == "done":
			accent = SLOT_DONE
		elif state == "current":
			accent = SLOT_CURRENT

		if state == "done":
			title_plate.visible = true
			title.visible = true
			title_plate.color = Color(0.82, 0.73, 0.58, 0.98)
			title.add_theme_color_override("font_color", Color(0.18, 0.10, 0.07, 1.0))
		elif state == "current":
			title_plate.visible = true
			title.visible = true
			title_plate.color = Color(0.12, 0.055, 0.045, 0.98)
			title.add_theme_color_override("font_color", Color(0.92, 0.76, 0.54, 1.0))
		else:
			# A live future replacement (currently XII) should read like the
			# reference's physical card-backs, not like a HUD card.
			title_plate.visible = false
			title.visible = false

		_apply_panel_style(panel, accent, state == "current", state)


func _refresh_boss() -> void:
	var active: bool = RunState.is_boss_due() or RunState.active_card_id == RunState.BOSS_CARD_ID or RunState.boss_defeated

	# Before XIII becomes active, use the approved reference's chained skull card
	# directly. It is part of the visual target and is not run-specific state.
	boss_panel.visible = active
	if not active:
		boss_art.texture = null
		boss_art.visible = false
		if boss_seal_visual != null:
			boss_seal_visual.visible = false
		return

	_apply_panel_style(boss_panel, BOSS_BORDER, true, "boss")
	if boss_seal_visual != null:
		boss_seal_visual.visible = true
		if boss_seal_visual.has_method("configure"):
			boss_seal_visual.call("configure", RunState.cards_resolved, true)

	boss_title.add_theme_color_override("font_color", Color(1.0, 0.72, 0.48, 1.0))
	boss_art.texture = CARD_ART_CATALOG.get_run_card_texture(RunState.BOSS_CARD_ID)
	boss_art.visible = boss_art.texture != null
	boss_title.text = "КОСТЯНОЙ\nНАДЗИРАТЕЛЬ"


func _refresh_held() -> void:
	if RunState.has_held_card():
		var card_id: String = RunState.held_card_id
		var card := RunState.get_card(card_id)
		held_art.texture = CARD_ART_CATALOG.get_run_card_texture(card_id)
		held_art.visible = held_art.texture != null
		held_title.text = card.title if card != null else card_id
		held_title.visible = true
		held_title_plate.visible = true
		held_title_plate.color = Color(0.80, 0.70, 0.55, 0.98)
		held_title.add_theme_color_override("font_color", Color(0.20, 0.12, 0.08, 1.0))
		held_status.text = "1/1 • ВЕРНЁТСЯ"
	else:
		held_art.texture = null
		held_art.visible = false
		held_title.text = ""
		held_title.visible = false
		held_title_plate.visible = false
		held_status.text = "1/1 СВОБОДНО" if not RunState.fate_hold_used else "0/1 ИСПОЛЬЗОВАНО"


func _refresh_discard() -> void:
	var rejected_count: int = RunState.rejected_card_ids.size()
	discard_status.text = "%d %s" % [rejected_count, _card_word(rejected_count)]
	discard_card_layer.visible = rejected_count > 0
	if rejected_count <= 0:
		discard_art.texture = null
		discard_art.visible = false
		discard_title.text = ""
		discard_title.visible = false
		discard_title_plate.visible = false
		return

	var card_id: String = RunState.rejected_card_ids[rejected_count - 1]
	var card := RunState.get_card(card_id)
	discard_art.texture = CARD_ART_CATALOG.get_run_card_texture(card_id)
	discard_art.visible = discard_art.texture != null
	discard_title.text = card.title if card != null else card_id
	discard_title.visible = true
	discard_title_plate.visible = true
	discard_title_plate.color = Color(0.80, 0.70, 0.55, 0.98)
	discard_title.add_theme_color_override("font_color", Color(0.20, 0.12, 0.08, 1.0))


func _animate_in() -> void:
	modulate.a = 0.0
	frame.pivot_offset = frame.size * 0.5
	frame.scale = Vector2(0.985, 0.985)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.14)
	tween.tween_property(frame, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	var reveal_index := 0
	for panel in slot_panels:
		if not panel.visible:
			continue
		panel.scale = Vector2(0.90, 0.90)
		panel.modulate = Color(0.78, 0.68, 0.64, 0.0)
		var card_tween := panel.create_tween()
		card_tween.set_parallel(true)
		var delay := 0.05 + float(reveal_index) * 0.035
		card_tween.tween_property(panel, "scale", Vector2.ONE, 0.18).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		card_tween.tween_property(panel, "modulate", Color.WHITE, 0.14).set_delay(delay)
		reveal_index += 1

	if boss_panel != null and boss_panel.visible:
		boss_panel.pivot_offset = boss_panel.size * 0.5
		boss_panel.scale = Vector2(0.88, 0.88)
		boss_panel.modulate.a = 0.0
		var boss_tween := boss_panel.create_tween()
		boss_tween.set_parallel(true)
		boss_tween.tween_property(boss_panel, "scale", Vector2.ONE, 0.24).set_delay(0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		boss_tween.tween_property(boss_panel, "modulate:a", 1.0, 0.18).set_delay(0.18)

	if seal_visual != null:
		seal_visual.modulate.a = 0.36
		var seal_entry := seal_visual.create_tween()
		seal_entry.tween_property(seal_visual, "modulate:a", 1.0, 0.30).set_delay(0.08)

	call_deferred("_pulse_current_slot_after_entry")


func _pulse_current_slot_after_entry() -> void:
	await get_tree().create_timer(0.38).timeout
	if not is_inside_tree():
		return

	if RunState.is_boss_due() and boss_panel != null and boss_panel.visible:
		var boss_pulse := boss_panel.create_tween()
		boss_pulse.tween_property(boss_panel, "scale", Vector2(1.045, 1.045), 0.10).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		boss_pulse.tween_property(boss_panel, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		return

	var current_index := RunState.cards_resolved
	if current_index < 0 or current_index >= slot_panels.size():
		return

	var panel := slot_panels[current_index]
	if not panel.visible:
		return

	var pulse_tween := panel.create_tween()
	pulse_tween.tween_property(panel, "scale", Vector2(1.065, 1.065), 0.09).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	pulse_tween.parallel().tween_property(panel, "modulate", Color(1.10, 0.88, 0.72, 1.0), 0.09)
	pulse_tween.tween_property(panel, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pulse_tween.parallel().tween_property(panel, "modulate", Color.WHITE, 0.15)


func _apply_panel_style(panel: Panel, accent: Color, strong: bool, state := "future") -> void:
	var style := StyleBoxFlat.new()

	if panel == boss_panel:
		style.bg_color = Color(0.025, 0.012, 0.015, 0.22 if not strong else 0.78)
	elif state == "done":
		style.bg_color = Color(0.54, 0.39, 0.24, 0.98)
	elif state == "current":
		style.bg_color = Color(0.055, 0.018, 0.020, 0.98)
	else:
		style.bg_color = Color(0.030, 0.026, 0.028, 0.98)

	style.border_width_left = 3 if strong or state == "done" else 2
	style.border_width_top = 3 if strong or state == "done" else 2
	style.border_width_right = 3 if strong or state == "done" else 2
	style.border_width_bottom = 3 if strong or state == "done" else 2

	if state == "done":
		style.border_color = Color(0.91, 0.68, 0.39, 0.98)
	elif state == "future":
		style.border_color = Color(0.28, 0.23, 0.22, 0.92)
	else:
		style.border_color = accent

	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.62)
	style.shadow_size = 10 if strong else 6
	panel.add_theme_stylebox_override("panel", style)


func _apply_phase_style() -> void:
	var color := Color(0.88, 0.56, 0.28, 1.0)
	if RunState.cards_resolved >= 8:
		color = Color(1.0, 0.30, 0.14, 1.0)
	elif RunState.cards_resolved >= 4:
		color = Color(0.94, 0.42, 0.20, 1.0)
	if RunState.is_boss_due() or RunState.cards_resolved >= RunState.ACT_CARD_TARGET:
		color = Color(1.0, 0.20, 0.08, 1.0)
	phase_label.add_theme_color_override("font_color", color)
	phase_label.add_theme_color_override("font_shadow_color", Color(0.22, 0.02, 0.01, 0.90))
	phase_label.add_theme_constant_override("shadow_offset_x", 1)
	phase_label.add_theme_constant_override("shadow_offset_y", 1)


func _get_phase_text() -> String:
	if RunState.cards_resolved < 4:
		return "I–IV  •  ПЕРВАЯ РАЗДАЧА"
	if RunState.cards_resolved < 8:
		return "V–VIII  •  СТОЛ ПОМНИТ"
	if RunState.cards_resolved < RunState.ACT_CARD_TARGET:
		return "IX–XII  •  ПОСЛЕДНЯЯ РАЗДАЧА"
	return "XIII  •  ПРИГОВОР"


func _future_symbol(_index: int) -> String:
	# Future card types are not predetermined by the current deck logic.
	# Keep unrevealed slots genuinely unknown instead of faking route intel.
	return "?"


func _roman(value: int) -> String:
	var numerals: Array[String] = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"]
	if value < 1 or value > numerals.size():
		return "?"
	return numerals[value - 1]


func _card_word(value: int) -> String:
	var mod100 := value % 100
	var mod10 := value % 10
	if mod100 >= 11 and mod100 <= 14:
		return "КАРТ"
	if mod10 == 1:
		return "КАРТА"
	if mod10 >= 2 and mod10 <= 4:
		return "КАРТЫ"
	return "КАРТ"
