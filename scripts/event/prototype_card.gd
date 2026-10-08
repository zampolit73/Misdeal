extends Control

@onready var title_label: Label = $Panel/Title
@onready var type_label: Label = $Panel/Type
@onready var description_label: Label = $Panel/Description
@onready var wizard_line: Label = $Panel/WizardLine
@onready var result_label: Label = $Panel/Result
@onready var continue_button: Button = $Panel/ContinueButton
@onready var run_stats_label: Label = $RunStats
@onready var panel: Panel = $Panel

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)

	var card := RunState.get_active_card()
	if card == null:
		push_warning("Prototype card scene opened without an active run card.")
		SceneTransition.change_to("res://scenes/table/table.tscn")
		return

	title_label.text = card.title
	type_label.text = card.type_label
	description_label.text = card.card_text
	wizard_line.text = card.wizard_line
	result_label.text = card.prototype_result_text
	run_stats_label.text = "%s   |   ЗОЛОТО %d   |   ОТРЯД %d/3   |   РАЗВИТИЕ %d   |   РЕЛИКВИИ %d" % [
		RunState.get_progress_text(),
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.artifact_ids.size()
	]

	continue_button.mouse_entered.connect(_on_continue_hover.bind(true))
	continue_button.mouse_exited.connect(_on_continue_hover.bind(false))
	_animate_screen_in()

func _animate_screen_in() -> void:
	panel.pivot_offset = panel.size * 0.5
	panel.scale = Vector2(0.985, 0.985)
	panel.modulate.a = 0.0
	var tween := panel.create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.16)

func _on_continue_hover(hovered: bool) -> void:
	if continue_button.disabled:
		return
	continue_button.pivot_offset = continue_button.size * 0.5
	var tween := continue_button.create_tween()
	tween.tween_property(continue_button, "scale", Vector2(1.025, 1.025) if hovered else Vector2.ONE, 0.11).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_continue_pressed() -> void:
	continue_button.disabled = true
	RunState.complete_active_card()
	SceneTransition.change_to("res://scenes/table/table.tscn")
