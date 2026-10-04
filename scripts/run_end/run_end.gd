extends Control

@onready var summary_label: Label = $Summary
@onready var wizard_line: Label = $WizardLine
@onready var new_run_button: Button = $NewRunButton

func _ready() -> void:
	new_run_button.pressed.connect(_on_new_run_pressed)
	summary_label.text = "Пережито раздач: %d\nЗолото: %d\nБонус здоровья отряда: +%d\nБонус урона отряда: +%d" % [
		RunState.deals_survived,
		RunState.gold,
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]
	wizard_line.text = "Три раздачи. И ты всё ещё дышишь. Не привыкай."

func _on_new_run_pressed() -> void:
	new_run_button.disabled = true
	RunState.reset_run()
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
