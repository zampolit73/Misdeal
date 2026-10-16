extends Control

# F6 QA: data and isolated moving-light logic only. No actual combat.
const CHECK := preload("res://scripts/dev/black_lantern_road_contract.gd")

func _ready() -> void:
	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color("#18161a")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var title := Label.new()
	title.position = Vector2(60, 90)
	title.size = Vector2(1160, 58)
	title.text = "D206 / ЧЁРНЫЕ ФОНАРИ — РЕСУРСЫ И СВЕТ"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 27)
	add_child(title)
	var result := Label.new()
	result.position = Vector2(90, 205)
	result.size = Vector2(1100, 300)
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result.add_theme_font_size_override("font_size", 21)
	add_child(result)
	var errors: Array[String] = CHECK.inspect()
	if errors.is_empty():
		result.text = "СТАТИЧЕСКИЕ ПРОВЕРКИ ПРОЙДЕНЫ\n5 уникальных UnitData • 2 расстановки • 5 врагов\nСвет ускоряет только освещённых врагов и снимает эффект\n\nАРТ / РЕАЛЬНЫЙ БОЙ / БАЛАНС ЕЩЁ НЕ ПРОВЕРЯЛИСЬ"
		result.add_theme_color_override("font_color", Color(0.69, 0.88, 0.73))
		print("D206 CONTRACT SMOKE PASS (not native battle QA)")
	else:
		result.text = "D206 / ОШИБКИ (%d)\n%s" % [errors.size(), "\n".join(errors)]
		result.add_theme_color_override("font_color", Color(1.0, 0.46, 0.38))
		for issue in errors:
			push_error("D206 CONTRACT: " + issue)
