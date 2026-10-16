extends Control

# D153 original-skeleton animation gate. Source art files must already be
# committed into GitHub; never show a previous enemy as a substitute.
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES: Array[String] = ["threadbare_puppeteer", "bone_marionette"]
const NAMES: Array[String] = ["КОСТЯНОЙ КУКЛОВОД", "КОСТЯНАЯ МАРИОНЕТКА"]
const ACTIONS: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]

var figures: Array[AnimatedSprite2D] = []
var caption_label: Label
var stage_index: int = 0
var stage_elapsed: float = 0.0


func _ready() -> void:
	var title: Label = _make_label("D153 / SKELETAL ANIMATION GALLERY", Vector2(72, 48), Vector2(1136, 70), 28)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption_label = _make_label("", Vector2(95, 589), Vector2(1090, 101), 19)
	caption_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var problems: Array[String] = []
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var name_label: Label = _make_label(NAMES[i], Vector2(82.0 + i * 600.0, 155.0), Vector2(516, 45), 23)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var frames: SpriteFrames = ANIMATION_LIBRARY.get_frames(role)
		if frames == null:
			problems.append("%s: оригинальный 25-кадровый атлас ещё не установлен" % role)
			continue
		for j in range(ACTIONS.size()):
			var state_name: String = ACTIONS[j]
			if frames.get_frame_count(state_name) != COUNTS[j]:
				problems.append("%s/%s: неправильное число кадров" % [role, state_name])
		if not problems.is_empty():
			continue
		var figure := AnimatedSprite2D.new()
		figure.name = role
		figure.sprite_frames = frames
		figure.position = Vector2(332.0 + i * 612.0, 430.0)
		figure.scale = Vector2(3.0, 3.0)
		figure.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(figure)
		figures.append(figure)
	if not problems.is_empty():
		caption_label.text = "D153 / АНИМАЦИИ ЕЩЁ НЕ ГОТОВЫ\n" + "\n".join(problems) + "\nD153 остаётся в колоде (37/45); исправь отсутствующие кадры."
		caption_label.add_theme_color_override("font_color", Color(0.98, 0.58, 0.44))
		set_process(false)
		return
	caption_label.text = "IDLE → WALK → ATTACK → HIT → DEATH (каждые 2 с).\nПроверь ноги, полный силуэт, нити, не повторяющиеся кадры и правильное направление."
	caption_label.add_theme_color_override("font_color", Color(0.68, 0.91, 0.74))
	_display_action()


func _process(delta: float) -> void:
	stage_elapsed += delta
	if stage_elapsed < 2.0:
		return
	stage_elapsed -= 2.0
	stage_index = (stage_index + 1) % ACTIONS.size()
	_display_action()


func _display_action() -> void:
	var state_name: String = ACTIONS[stage_index]
	for figure in figures:
		figure.play(state_name)


func _make_label(value: String, pos: Vector2, extent: Vector2, font_size: int) -> Label:
	var item := Label.new()
	item.text = value
	item.position = pos
	item.size = extent
	item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	item.add_theme_font_size_override("font_size", font_size)
	add_child(item)
	return item
