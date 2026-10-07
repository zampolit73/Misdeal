
extends Control

@onready var title_label: Label = $Title
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

	var last_deal_text := "не использована"
	if RunState.last_deal_used:
		last_deal_text = RunState.last_deal_payment_text if not RunState.last_deal_payment_text.is_empty() else "принята"

	summary_label.text = "Пройдено карт: %d/%d\nПобед в боях: %d\nЗолото: %d\nОтряд: %s\n%s\nРазвитие героев: %s\nБонус здоровья от событий: %+d\nБонус урона от событий: %+d\nАртефакты: %s\nПоследняя сделка: %s" % [
		RunState.cards_resolved,
		RunState.ACT_CARD_TARGET,
		RunState.deals_survived,
		RunState.gold,
		RunState.get_party_roles_text(),
		"   |   ".join(fate_lines),
		RunState.get_hero_upgrade_titles_text(),
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus),
		RunState.get_artifact_titles_text(),
		last_deal_text
	]

	if RunState.run_failed:
		title_label.text = "ПАРТИЯ ПРОИГРАНА"
		title_label.add_theme_color_override("font_color", Color(0.86, 0.34, 0.28, 1.0))
		wizard_line.text = RunState.run_end_reason if not RunState.run_end_reason.is_empty() else "Эта версия жизни закончилась раньше, чем ты рассчитывал."
	else:
		title_label.text = "ЗАБЕГ ЗАВЕРШЁН"
		wizard_line.text = "Двенадцать карт и мой надзиратель. Пожалуй, ты заслужил ещё одну партию."

func _on_new_run_pressed() -> void:
	new_run_button.disabled = true
	RunState.reset_run()
	get_tree().change_scene_to_file("res://scenes/class_select/class_select.tscn")
