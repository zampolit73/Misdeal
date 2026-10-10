extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

@onready var backdrop_art: TextureRect = $BackdropArt
@onready var title_label: Label = $Title
@onready var summary_panel: Panel = $SummaryPanel
@onready var summary_label: Label = $Summary
@onready var wizard_line: Label = $WizardLine
@onready var new_run_button: Button = $NewRunButton

func _ready() -> void:
	MISDEAL_UI_KIT.apply_panel($SummaryPanel, MISDEAL_UI_KIT.BRONZE, true)
	MISDEAL_UI_KIT.apply_title(title_label, MISDEAL_UI_KIT.GOLD)
	MISDEAL_UI_KIT.apply_subtitle(wizard_line, MISDEAL_UI_KIT.BRONZE)
	MISDEAL_UI_KIT.apply_action_button(new_run_button, MISDEAL_UI_KIT.GOLD, true)
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

	call_deferred("_animate_run_end_in")


func _animate_run_end_in() -> void:
	backdrop_art.modulate.a = 0.72
	title_label.pivot_offset = title_label.size * 0.5
	title_label.scale = Vector2(0.94, 0.94)
	title_label.modulate.a = 0.0
	wizard_line.modulate.a = 0.0

	summary_panel.pivot_offset = summary_panel.size * 0.5
	summary_panel.scale = Vector2(0.975, 0.975)
	summary_panel.modulate.a = 0.0
	summary_label.modulate.a = 0.0

	new_run_button.pivot_offset = new_run_button.size * 0.5
	new_run_button.scale = Vector2(0.97, 0.97)
	new_run_button.modulate.a = 0.0

	var backdrop_tween := backdrop_art.create_tween()
	backdrop_tween.tween_property(backdrop_art, "modulate:a", 0.90, 0.32)

	var title_tween := title_label.create_tween()
	title_tween.set_parallel(true)
	title_tween.tween_property(title_label, "modulate:a", 1.0, 0.17).set_delay(0.05)
	title_tween.tween_property(title_label, "scale", Vector2.ONE, 0.22).set_delay(0.05).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	var line_tween := wizard_line.create_tween()
	line_tween.tween_property(wizard_line, "modulate:a", 1.0, 0.18).set_delay(0.13)

	var panel_tween := summary_panel.create_tween()
	panel_tween.set_parallel(true)
	panel_tween.tween_property(summary_panel, "modulate:a", 1.0, 0.18).set_delay(0.18)
	panel_tween.tween_property(summary_panel, "scale", Vector2.ONE, 0.22).set_delay(0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	var summary_tween := summary_label.create_tween()
	summary_tween.tween_property(summary_label, "modulate:a", 1.0, 0.20).set_delay(0.24)

	var button_tween := new_run_button.create_tween()
	button_tween.set_parallel(true)
	button_tween.tween_property(new_run_button, "modulate:a", 1.0, 0.16).set_delay(0.34)
	button_tween.tween_property(new_run_button, "scale", Vector2.ONE, 0.18).set_delay(0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_new_run_pressed() -> void:
	new_run_button.disabled = true
	await _animate_new_run_commit()
	RunState.reset_run()
	SCENE_ROUTER.change_to(self, "res://scenes/class_select/class_select.tscn")


func _animate_new_run_commit() -> void:
	new_run_button.pivot_offset = new_run_button.size * 0.5
	var tween := new_run_button.create_tween()
	tween.tween_property(new_run_button, "scale", Vector2(0.96, 0.94), 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(new_run_button, "scale", Vector2(1.035, 1.035), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_run_button, "scale", Vector2.ONE, 0.055)
	await tween.finished
