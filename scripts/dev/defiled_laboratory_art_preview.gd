extends Control

const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES := ["plague_alchemist", "unstable_homunculus"]
const LABELS := ["ЧУМНОЙ АЛХИМИК", "НЕСТАБИЛЬНЫЙ ГОМУНКУЛ"]
const STATES := ["idle", "walk", "attack", "hit", "death"]

var sprites: Array[AnimatedSprite2D] = []
var message: Label
var state_index := 0
var elapsed := 0.0


func _ready() -> void:
	var header := _label("D152 / ORIGINAL ANIMATION GALLERY", Vector2(70, 38), Vector2(1140, 60), 30)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message = _label("", Vector2(80, 596), Vector2(1120, 100), 19)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var issues: Array[String] = []
	for i in range(ROLES.size()):
		var role: String = String(ROLES[i])
		var title: Label = _label(String(LABELS[i]), Vector2(70.0 + 620.0 * i, 140), Vector2(540, 40), 22)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var frames: SpriteFrames = ANIMATIONS.get_frames(role)
		if frames == null:
			issues.append("%s: атлас отсутствует или не прошёл проверки" % role)
			continue
		var sprite := AnimatedSprite2D.new()
		sprite.name = role
		sprite.sprite_frames = frames
		sprite.position = Vector2(315.0 + 615.0 * i, 427.0)
		sprite.scale = Vector2(2.9, 2.9)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(sprite)
		sprites.append(sprite)
		for row_index in range(STATES.size()):
			var state_name: String = String(STATES[row_index])
			var expected_count: int = [4, 6, 6, 3, 6][row_index]
			if frames.get_frame_count(state_name) != expected_count:
				issues.append("%s: неполная анимация %s" % [role, state_name])
	if not issues.is_empty():
		message.text = "АРТ НЕ ГОТОВ / ЗАГРУЗКА НЕ ПРОШЛА\n" + "\n".join(issues)
		message.add_theme_color_override("font_color", Color(0.96, 0.44, 0.38))
		set_process(false)
		return
	message.text = "IDLE → WALK → ATTACK → HIT → DEATH, по 2 секунды\nПроверьте ступни, флаконы, руки, направления и движение. Только визуальный кандидат."
	_show_state()


func _label(value: String, pos: Vector2, extent: Vector2, font_size: int) -> Label:
	var node := Label.new()
	node.text = value
	node.position = pos
	node.size = extent
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", font_size)
	add_child(node)
	return node


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= 2.0:
		elapsed = 0.0
		state_index = (state_index + 1) % STATES.size()
		_show_state()


func _show_state() -> void:
	for sprite in sprites:
		sprite.play(String(STATES[state_index]))
