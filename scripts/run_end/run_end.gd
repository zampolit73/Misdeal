extends Control

@onready var summary_label: Label = $Summary
@onready var wizard_line: Label = $WizardLine
@onready var new_run_button: Button = $NewRunButton

func _ready() -> void:
	new_run_button.pressed.connect(_on_new_run_pressed)
	var fate_lines: Array[String] = []
	for role in RunState.HERO_ROLES:
		if role == RunState.protagonist_role:
			continue
		var label := "Рыцарь" if role == "knight" else ("Следопыт" if role == "ranger" else "Маг")
		var fate := RunState.get_companion_fate(role)
		var fate_text := "В ОТРЯДЕ" if fate == RunState.FATE_JOINED else ("ПОТЕРЯН" if fate == RunState.FATE_LOST else "НЕ ВСТРЕЧЕН")
		fate_lines.append("%s: %s" % [label, fate_text])

	summary_label.text = "Пройдено карт: %d/%d\nПобед в боях: %d\nЗолото: %d\nОтряд: %s\n%s\nРазвитие героев: %s\nБонус здоровья от событий: %+d\nБонус урона от событий: %+d\nАртефакты: %s" % [
		RunState.cards_resolved,
		RunState.ACT_CARD_TARGET,
		RunState.deals_survived,
		RunState.gold,
		RunState.get_party_roles_text(),
		"   |   ".join(fate_lines),
		RunState.get_hero_upgrade_titles_text(),
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus),
		RunState.get_artifact_titles_text()
	]
	wizard_line.text = "Двенадцать карт и мой надзиратель. Пожалуй, ты заслужил ещё одну партию."

func _on_new_run_pressed() -> void:
	new_run_button.disabled = true
	RunState.reset_run()
	get_tree().change_scene_to_file("res://scenes/class_select/class_select.tscn")
