extends Control

@onready var summary_label: Label = $Summary
@onready var wizard_line: Label = $WizardLine
@onready var new_run_button: Button = $NewRunButton

func _ready() -> void:
	new_run_button.pressed.connect(_on_new_run_pressed)
	summary_label.text = "Пройдено карт: %d/%d\nПобед в боях: %d\nЗолото: %d\nРазвитие героев: %s\nБонус здоровья от событий: %+d\nБонус урона от событий: %+d\nАртефакты: %s" % [
		RunState.cards_resolved,
		RunState.ACT_CARD_TARGET,
		RunState.deals_survived,
		RunState.gold,
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
