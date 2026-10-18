extends Control

# D255 QA ONLY: one full-pack review of all three user-approved B-style art
# directions, not registration of incomplete roles or card #38 release.
# 25 unique states per role, sourced from transparent 1374x1145 images.
const TEMP_ART_LOADER := preload("res://scripts/dev/black_lantern_d249_five_enemy_combat_qa.gd")
const ROLES: Array[String] = ["extinguished_guide", "oil_acolyte", "lantern_archer"]
const TITLES: Array[String] = ["ПОГАСШИЙ ПРОВОДНИК", "МАСЛЯНЫЙ СЛУЖКА", "СТРЕЛОК ФОНАРЕЙ"]
const SOURCES := {
	"extinguished_guide": "res://assets/pixel/units/black_lantern_road_qa/extinguished_guide_d255_rich25_qa.webp.b64",
	"oil_acolyte": "res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d255_rich25_qa.webp.b64",
	"lantern_archer": "res://assets/pixel/units/black_lantern_road_qa/lantern_archer_d255_rich25_qa.webp.b64"
}
const FACES_LEFT := {"extinguished_guide": true, "oil_acolyte": false, "lantern_archer": true}
const STATES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const STATE_TITLES: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]

@onready var backdrop: TextureRect = $BattleBackdrop

var sprite_sets: Dictionary = {}
var large_sprites: Dictionary = {}
var real_sprites: Dictionary = {}
var current_state := "walk"
var facing_left := true
var status_label: Label


func _ready() -> void:
	backdrop.call("set_arena_id", "black_lantern_road")
	if backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
		_fail("Лесная арена D209 не загрузилась")
		return
	var loader := TEMP_ART_LOADER.new() as Control
	for role in ROLES:
		var frames := loader.call("_read_temporary_original", str(SOURCES[role])) as SpriteFrames
		if frames == null:
			loader.free()
			_fail("Формат 25-кадрового QA-атласа не прошёл проверку: " + role)
			return
		sprite_sets[role] = frames
	loader.free()
	_make_interface()
	_apply_direction()
	_play_state("walk")
	print("D255: three user-approved visual directions; 75 distinct technical frames loaded, native motion ART QA pending.")


func _make_interface() -> void:
	var shade := ColorRect.new()
	shade.position = Vector2(38, 105)
	shade.size = Vector2(1204, 501)
	shade.color = Color(0.022, 0.025, 0.032, 0.88)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	_label("D255 · ТРИ ВРАГА / 75 КАДРОВ / ЕДИНАЯ ХУДОЖЕСТВЕННАЯ ПРОВЕРКА", Vector2(74, 16), Vector2(1135, 40), 23)
	status_label = _label("", Vector2(78, 567), Vector2(1115, 35), 15)
	for index in range(ROLES.size()):
		var role: String = ROLES[index]
		var x: float = float(234 + index * 405)
		_label(TITLES[index], Vector2(x - 184.0, 132.0), Vector2(368, 27), 17)
		large_sprites[role] = _sprite(sprite_sets[role], Vector2(x, 340), 2.1)
		real_sprites[role] = _sprite(sprite_sets[role], Vector2(x, 528), 1.0)
	_label("↑ УВЕЛИЧЕННЫЙ ×2.1", Vector2(58, 191), Vector2(1164, 27), 12)
	_label("БОЕВОЙ МАСШТАБ ×1", Vector2(60, 447), Vector2(1160, 25), 12)
	var left := _button("← ВЛЕВО", Vector2(72, 70), Vector2(175, 34))
	var right := _button("ВПРАВО →", Vector2(260, 70), Vector2(175, 34))
	left.pressed.connect(_set_facing.bind(true))
	right.pressed.connect(_set_facing.bind(false))
	for i in range(STATES.size()):
		var option := _button(STATE_TITLES[i], Vector2(85 + i * 231, 644), Vector2(206, 46))
		option.pressed.connect(_play_state.bind(STATES[i]))


func _sprite(frames: SpriteFrames, at: Vector2, magnification: float) -> AnimatedSprite2D:
	var actor := AnimatedSprite2D.new()
	actor.sprite_frames = frames
	actor.position = at
	actor.scale = Vector2.ONE * magnification
	actor.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	actor.z_index = 10
	add_child(actor)
	return actor


func _label(message: String, at: Vector2, dims: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = message
	label.position = at
	label.size = dims
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.97, 0.86, 0.69))
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.z_index = 20
	add_child(label)
	return label


func _button(message: String, at: Vector2, dims: Vector2) -> Button:
	var button := Button.new()
	button.text = message
	button.position = at
	button.size = dims
	button.add_theme_font_size_override("font_size", 17)
	add_child(button)
	return button


func _set_facing(left: bool) -> void:
	facing_left = left
	_apply_direction()


func _apply_direction() -> void:
	for role in ROLES:
		var mirror: bool = bool(FACES_LEFT[role]) != facing_left
		(large_sprites[role] as AnimatedSprite2D).flip_h = mirror
		(real_sprites[role] as AnimatedSprite2D).flip_h = mirror


func _play_state(state: String) -> void:
	current_state = state
	for role in ROLES:
		for sprite in [large_sprites[role], real_sprites[role]]:
			var actor := sprite as AnimatedSprite2D
			actor.stop()
			actor.play(state)
	if status_label != null:
		status_label.text = "%s · %s · ВСЕ ТРИ QA-КАНДИДАТА · ПРОВЕРЬ СЦЕПЛЕНИЕ ОРУЖИЯ И ДВИЖЕНИЕ В ×1" % [state.to_upper(), "←" if facing_left else "→"]


func _fail(reason: String) -> void:
	_label("D255 / QA FAIL: " + reason, Vector2(100, 264), Vector2(1070, 180), 24)
	push_error("D255: " + reason)