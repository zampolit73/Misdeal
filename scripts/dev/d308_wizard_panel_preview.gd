extends Control

# D308 - isolated Godot F6 art/UX test; not part of the normal Misdeal run.
# Production D307 methods own the actual Wizard skin and live text layout.
# This preview only replaces the canonical objective string with sample states.
const DS3 := preload("res://scripts/battle/battle_ds3_pass.gd")
const BATTLE_SCENE := "res://scenes/battle/battle.tscn"
const GRAVE_BELL := "res://resources/encounters/grave_bell.tres"

const RULES := [
	["Звонарь первым", "УСЛОВИЕ ВОЛШЕБНИКА\nЗвонарь должен пасть первым • +15 золота"],
	["Сохранить отряд", "УСЛОВИЕ ВОЛШЕБНИКА\nНикто не ниже 25% HP • +15 золота"],
	["Победить вовремя", "УСЛОВИЕ ВОЛШЕБНИКА\nПобедить за 16 сек • +15 золота"]
]

@onready var source_label: Label = $SideObjectivePanel/ObjectiveLabel
@onready var objective_panel: Panel = $SideObjectivePanel
@onready var rules_picker: OptionButton = $PreviewTools/RulePicker
@onready var phase_label: Label = $PreviewTools/PhaseLabel
@onready var note_label: Label = $PreviewTools/NoteLabel
@onready var top_status: Label = $PreviewTitle/Status

var _combat_phase := false
var _rule_index := 0
var _outcome := 0


func _ready() -> void:
	_style_preview_controls()
	DS3._style_side_objective(self)
	DS3._install_wizard_plaque(self)
	# Reuse the original rule strings seen in the production Battle.
	for rule in RULES:
		rules_picker.add_item(str(rule[0]))
	rules_picker.item_selected.connect(_on_rule_selected)
	$PreviewTools/PrepButton.pressed.connect(_set_phase.bind(false))
	$PreviewTools/CombatButton.pressed.connect(_set_phase.bind(true))
	$PreviewTools/NormalButton.pressed.connect(_set_outcome.bind(0))
	$PreviewTools/SuccessButton.pressed.connect(_set_outcome.bind(1))
	$PreviewTools/FailButton.pressed.connect(_set_outcome.bind(2))
	$PreviewTools/RealBattleButton.pressed.connect(_open_real_battle)
	rules_picker.select(0)
	_refresh_preview()


func _on_rule_selected(index: int) -> void:
	_rule_index = index
	_outcome = 0
	_refresh_preview()


func _set_outcome(index: int) -> void:
	_outcome = index
	_refresh_preview()


func _set_phase(combat_active: bool) -> void:
	_combat_phase = combat_active
	_refresh_preview()


func _refresh_preview() -> void:
	match _outcome:
		1:
			source_label.text = "УСЛОВИЕ ВЫПОЛНЕНО\nЗвонарь пал первым • награда после победы" if _rule_index == 0 else "УСЛОВИЕ ВЫПОЛНЕНО\nНаграда после победы • +15 золота"
		2:
			source_label.text = "УСЛОВИЕ ПРОВАЛЕНО • первым пал не звонарь" if _rule_index == 0 else "УСЛОВИЕ ПРОВАЛЕНО • условие не выполнено"
		_:
			source_label.text = str(RULES[_rule_index][1])
	# This is the actual production code, including the D306 fallback.
	DS3.sync_side_objective(self)
	DS3.position_side_objective(self, _combat_phase)
	phase_label.text = "Фаза: БОЙ" if _combat_phase else "Фаза: ПОДГОТОВКА"
	var title := "Выполнено" if _outcome == 1 else ("Провалено" if _outcome == 2 else "Активно")
	top_status.text = "Состояние: %s · %s" % [title, "в бою" if _combat_phase else "до боя"]
	note_label.text = "Открой настоящий бой, чтобы проверить расположение с героями.\nСейчас показан изолированный превью-режим без изменения правил игры."
	if objective_panel.get_node_or_null("D307WizardArt") == null:
		note_label.text = "Внимание: D307 WebP не загрузился. Работает запасное оформление D306."


func _open_real_battle() -> void:
	# F6 starts this as a separate Godot test process; no save is written.
	var state := get_node_or_null("/root/RunState")
	if state == null:
		push_error("D308: RunState autoload not found")
		return
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		push_error("D308: Failed to initialize test Knight")
		return
	state.call("recruit_companion", "ranger", "D308 test: Grave Bell art check")
	state.call("select_encounter", GRAVE_BELL)
	get_tree().change_scene_to_file(BATTLE_SCENE)


func _style_preview_controls() -> void:
	var plaque := StyleBoxFlat.new()
	plaque.bg_color = Color(0.030, 0.021, 0.024, 0.93)
	plaque.border_color = Color(0.59, 0.39, 0.22, 0.92)
	plaque.set_border_width_all(2)
	plaque.set_corner_radius_all(3)
	plaque.shadow_color = Color(0, 0, 0, 0.8)
	plaque.shadow_size = 8
	$PreviewTools.add_theme_stylebox_override("panel", plaque)
	$PreviewTitle.add_theme_stylebox_override("panel", plaque)
	for path in ["PrepButton", "CombatButton", "NormalButton", "SuccessButton", "FailButton", "RealBattleButton"]:
		var button := get_node("PreviewTools/" + path) as Button
		button.add_theme_font_size_override("font_size", 13)
		var frame := StyleBoxFlat.new()
		frame.bg_color = Color(0.13, 0.052, 0.043, 0.95)
		frame.border_color = Color(0.65, 0.42, 0.24, 0.85)
		frame.set_border_width_all(1)
		frame.set_corner_radius_all(2)
		button.add_theme_stylebox_override("normal", frame)
		var highlighted := frame.duplicate() as StyleBoxFlat
		highlighted.bg_color = Color(0.33, 0.11, 0.08, 0.98)
		highlighted.border_color = Color(0.95, 0.69, 0.38)
		button.add_theme_stylebox_override("hover", highlighted)
		button.add_theme_stylebox_override("pressed", highlighted)
