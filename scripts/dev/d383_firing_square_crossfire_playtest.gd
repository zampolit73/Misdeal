extends Control

# D383 F6-only, honest real-Battle preview. The picker changes ONLY this
# playtest process's RunState; no altered main game scene, no fake animation.
const ENCOUNTER_PATH := "res://resources/encounters/firing_square.tres"
const CARD_ID := "firing_square"

var party_picker: OptionButton
var formation_picker: OptionButton
var blocker: Label


func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.028, 0.020, 0.026, 1.0)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var panel := PanelContainer.new()
	panel.position = Vector2(310, 120)
	panel.size = Vector2(660, 470)
	add_child(panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 14)
	panel.add_child(stack)
	stack.add_child(_label("D383 — РАССТРЕЛЬНАЯ ПЛОЩАДЬ", 27))
	stack.add_child(_label("ДВЕ ВОЛНЫ · ОДНА ПЕРЕДЫШКА · НАСТОЯЩИЙ BATTLE", 17))
	stack.add_child(_label("После часового и двух лучников: атака с левого тыла и правого края. Переставьте героев и смените обычный приказ перед «ВОЛНА II». HP сохраняется.", 15))
	stack.add_child(_label("Размер отряда", 18))
	party_picker = OptionButton.new()
	party_picker.add_item("1 — Рыцарь", 1)
	party_picker.add_item("2 — Рыцарь + Следопыт", 2)
	party_picker.add_item("3 — Рыцарь + Следопыт + Маг", 3)
	party_picker.select(2)
	stack.add_child(party_picker)
	stack.add_child(_label("Построение первого огневого рубежа", 18))
	formation_picker = OptionButton.new()
	formation_picker.add_item("Линия огня", 0)
	formation_picker.add_item("Шахматный залп", 1)
	stack.add_child(formation_picker)
	var launch := Button.new()
	launch.text = "ЗАПУСТИТЬ БОЙ"
	launch.custom_minimum_size = Vector2(0.0, 50.0)
	launch.pressed.connect(_launch)
	stack.add_child(launch)
	blocker = _label("", 14)
	blocker.add_theme_color_override("font_color", Color(0.95, 0.38, 0.34))
	stack.add_child(blocker)

	var data := load(ENCOUNTER_PATH) as EncounterData
	if data == null or not data.has_second_wave():
		blocker.text = "Встреча «Расстрельная площадь» не содержит двух корректных волн."
		launch.disabled = true


func _label(message: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = message
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.91, 0.79, 0.66))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _launch() -> void:
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		blocker.text = "Не удалось создать тестовый забег."
		return
	var chosen_count: int = party_picker.get_selected_id()
	for index in range(1, chosen_count):
		var role: String = RunState.HERO_ROLES[index]
		RunState.recruit_companion(role, "D383 F6 crossfire pilot")
	RunState.active_card_id = CARD_ID
	RunState.select_encounter(ENCOUNTER_PATH)
	RunState.combat_formation_by_card[CARD_ID] = formation_picker.get_selected_id()
	call_deferred("_enter_battle")


func _enter_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
