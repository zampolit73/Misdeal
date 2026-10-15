extends Control

# D183 only: verified original enemy animation gallery. Never show another
# role's fallback art or silently claim missing .webp.b64 files are installed.
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES: Array[String] = ["drowned_ferryman", "drowned_hand"]
const NAMES: Array[String] = ["КОСТЯНОЙ ПЕРЕВОЗЧИК", "УТОПЛЕННИК"]
const ACTIONS: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const COUNTS: Array[int] = [4, 6, 6, 3, 6]

var _actors: Array[AnimatedSprite2D] = []
var _caption: Label
var _state_index: int = 0
var _elapsed: float = 0.0


func _ready() -> void:
	var backing := ColorRect.new()
	backing.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backing.color = Color(0.046, 0.059, 0.068)
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backing)

	var heading: Label = _label("D183 / ЧЁРНАЯ ПЕРЕПРАВА — АНИМАЦИИ", Vector2(70, 48), Vector2(1140, 70), 27)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption = _label("", Vector2(86, 574), Vector2(1108, 115), 19)
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	var problems: Array[String] = []
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var role_label: Label = _label(NAMES[i], Vector2(80 + i * 612, 160), Vector2(510, 50), 22)
		role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var frames: SpriteFrames = ANIMATION_LIBRARY.get_frames(role)
		if frames == null:
			problems.append("%s: нет готового WebP-атласа в GitHub" % role)
			continue
		for j in range(ACTIONS.size()):
			if frames.get_frame_count(ACTIONS[j]) != COUNTS[j]:
				problems.append("%s/%s: неверное количество кадров" % [role, ACTIONS[j]])
		if not problems.is_empty():
			continue
		var sprite := AnimatedSprite2D.new()
		sprite.name = role
		sprite.sprite_frames = frames
		sprite.position = Vector2(326 + i * 614, 421)
		sprite.scale = Vector2(3.0, 3.0)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(sprite)
		_actors.append(sprite)
	if not problems.is_empty():
		_caption.text = "D183 / АТЛАСЫ НЕ ГОТОВЫ\n" + "\n".join(problems) + "\nНикаких замен старой нежитью."
		_caption.add_theme_color_override("font_color", Color(0.99, 0.55, 0.43))
		set_process(false)
		return
	_caption.text = "IDLE → WALK → ATTACK → HIT → DEATH (2 секунды на состояние).\nПроверь полный рост, багор, кисти, ноги, отсутствие обрезаний и мерцания."
	_caption.add_theme_color_override("font_color", Color(0.71, 0.93, 0.76))
	_display()


func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed < 2.0:
		return
	_elapsed -= 2.0
	_state_index = (_state_index + 1) % ACTIONS.size()
	_display()


func _display() -> void:
	for sprite in _actors:
		sprite.play(ACTIONS[_state_index])


func _label(value: String, at: Vector2, size: Vector2, font_size: int) -> Label:
	var element := Label.new()
	element.text = value
	element.position = at
	element.size = size
	element.add_theme_font_size_override("font_size", font_size)
	add_child(element)
	return element
