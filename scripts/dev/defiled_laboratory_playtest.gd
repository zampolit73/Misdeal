extends Control

# D152 visual QA + reproducible battle staging for the released 35th Act1 card.
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")

func _ready() -> void:
	if not RunState.ACT1_CARD_IDS.has("defiled_laboratory"):
		_show_blocker("D152 должна быть в обычной колоде Act 1 (35/45).")
		return
	for role in ["plague_alchemist", "unstable_homunculus"]:
		if ANIMATIONS.get_frames(role) == null:
			_show_blocker("Отсутствует полноценный оригинальный атлас: %s\nПроверьте оригинальные атласы D152 в GitHub." % role)
			return
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append("defiled_laboratory")
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card("defiled_laboratory"):
		_show_blocker("D152 QA card lookup failed")
		return
	call_deferred("_enter_battle")


func _enter_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")


func _show_blocker(value: String) -> void:
	var label := Label.new()
	label.position = Vector2(100.0, 220.0)
	label.size = Vector2(1080.0, 290.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = "D152 / PLAYTEST WAITING\n\n" + value
	label.add_theme_font_size_override("font_size", 23)
	label.add_theme_color_override("font_color", Color(0.93, 0.67, 0.44))
	add_child(label)
