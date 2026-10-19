extends Control

# D267 QA ONLY: native x1/x2 visual review of three new user-approved rich
# motion atlas CANDIDATES. Structurally distinct is not art approval.
# Intentionally never registers them with the global animation library.
const LOADER := preload("res://scripts/dev/black_lantern_d249_five_enemy_combat_qa.gd")
const PRODUCTION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const PATH := "res://assets/pixel/units/court_of_the_mute_qa/"
const BACKDROP := "res://assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64"
const ROLES: Array[String] = ["mute_magistrate", "ash_scrivener", "bone_bailiff"]
const TITLES: Array[String] = ["БЕЗМОЛВНЫЙ МАГИСТРАТ", "ПИСАРЬ ПРАХА", "КОСТЯНОЙ ПРИСТАВ"]
const STATES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const ANIM_LABELS: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]
const CARD_ID := "court_of_the_mute"

var big: Dictionary = {}
var native: Dictionary = {}
var frames: Dictionary = {}
var current_state := "walk"
var facing_left := true
var caption: Label
var floor_overlay: ColorRect


func _ready() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_fail("QA must not release #39 into ordinary Act1 card pool")
		return
	var card: RunCardData = RunState.get_card(CARD_ID)
	if card == null or not card.target_path.is_empty():
		_fail("Card #39 must remain an unconnected QA card")
		return
	var background := _image_from_base64(BACKDROP, Vector2i(1280, 720))
	if background == null:
		_fail("D265 original empty Court backdrop cannot be decoded")
		return
	var paint := TextureRect.new()
	paint.texture = ImageTexture.create_from_image(background)
	paint.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	paint.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	paint.stretch_mode = TextureRect.STRETCH_SCALE
	paint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	paint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(paint)
	var veil := ColorRect.new()
	veil.position = Vector2(37, 114)
	veil.size = Vector2(1204, 492)
	veil.color = Color(0.033, 0.031, 0.038, 0.81)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(veil)
	var loader := LOADER.new() as Control
	for role in ROLES:
		# D267 historical prototype stays viewable after D267 rich original
		# roles were staged in the strict library; never swap this preview
		# for production without selecting the D267 art scene.
		var source: String = PATH + role + "_d267_rich_qa.webp.b64"
		var original := _image_from_base64(source, Vector2i(576, 480))
		if original == null:
			loader.free()
			_fail("D267 25-pose original animation source not valid: " + role)
			return
		var pose_frames := loader.call("_read_temporary_original", source) as SpriteFrames
		if pose_frames == null:
			loader.free()
			_fail("D267 native animation contract rejected: " + role)
			return
		frames[role] = pose_frames
	loader.free()
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var x: float = float(240 + i * 402)
		_label(TITLES[i],Vector2(x - 192,153),Vector2(384,33),16)
		big[role] = _animated(frames[role],Vector2(x,354),2.1)
		native[role] = _animated(frames[role],Vector2(x,517),1.0)
	_label("D267 · 3 УТВЕРЖДЁННЫХ ОБРАЗА · 75 КАДРОВ · QA АНИМАЦИИ",Vector2(37,12),Vector2(1204,50),24)
	_label("МАСШТАБ ×2.1 · сравни захват предметов, движение и падение",Vector2(60,218),Vector2(1160,28),15)
	_label("БОЕВОЙ МАСШТАБ ×1",Vector2(60,438),Vector2(1160,23),13)
	caption = _label("",Vector2(58,570),Vector2(1160,27),13)
	_button("← ВЛЕВО",Vector2(58,70),Vector2(173,34)).pressed.connect(_set_facing.bind(true))
	_button("ВПРАВО →",Vector2(245,70),Vector2(173,34)).pressed.connect(_set_facing.bind(false))
	for i in range(STATES.size()):
		_button(ANIM_LABELS[i],Vector2(75+i*229,637),Vector2(201,45)).pressed.connect(_play.bind(STATES[i]))
	floor_overlay = ColorRect.new()
	floor_overlay.position = Vector2(40,532)
	floor_overlay.size = Vector2(1228,178)
	floor_overlay.color = Color(0.15,0.7,0.4,0.09)
	floor_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	floor_overlay.visible = false
	add_child(floor_overlay)
	floor_overlay.z_index = 1
	_set_facing(true)
	_play("walk")
	print("D267_RICH_THREE_ROLE_F6_PASS: Godot decoded 3 original 25-pose alpha animation atlases; idle/walk/attack/hit/death; native x1 and zoom x2; card39 still QA")
	print("D267_VISUAL_ART_STATUS: source design USER-APPROVED; extracted motion/feet/seams pending native review; 27 flagged source seam/row-edge cases")


func _image_from_base64(path: String, dims: Vector2i) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var img := Image.new()
	if raw.is_empty() or img.load_webp_from_buffer(raw) != OK or img.get_size() != dims:
		return null
	return img


func _animated(atlas: SpriteFrames, center: Vector2, magnification: float) -> AnimatedSprite2D:
	var s := AnimatedSprite2D.new()
	s.sprite_frames = atlas
	s.position = center
	s.scale = Vector2.ONE * magnification
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.z_index = 10
	add_child(s)
	return s


func _button(title: String, pos: Vector2, size: Vector2) -> Button:
	var b := Button.new()
	b.text = title
	b.position = pos
	b.size = size
	b.add_theme_font_size_override("font_size",16)
	add_child(b)
	return b


func _label(title: String, pos: Vector2, size: Vector2, fontsize: int) -> Label:
	var t := Label.new()
	t.text = title
	t.position = pos
	t.size = size
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	t.add_theme_font_size_override("font_size",fontsize)
	t.add_theme_color_override("font_color",Color(0.93,0.82,0.66))
	t.add_theme_color_override("font_shadow_color",Color(0.0,0.0,0.0,0.9))
	t.add_theme_constant_override("shadow_offset_x",1)
	t.add_theme_constant_override("shadow_offset_y",1)
	t.z_index = 12
	add_child(t)
	return t


func _set_facing(left: bool) -> void:
	facing_left = left
	for role in ROLES:
		(big[role] as AnimatedSprite2D).flip_h = not left
		(native[role] as AnimatedSprite2D).flip_h = not left


func _play(state: String) -> void:
	current_state = state
	for role in ROLES:
		for sprite in [big[role],native[role]]:
			var s := sprite as AnimatedSprite2D
			s.stop()
			s.play(state)
	if caption:
		caption.text = "D267 QA / %s · %s · НЕ ВЫПУЩЕНО · 38/45" % [state.to_upper(),"←" if facing_left else "→"]


func _unhandled_key_input(event: InputEvent) -> void:
	if not(event is InputEventKey) or not event.pressed or event.echo:
		return
	if event.keycode == KEY_G and floor_overlay:
		floor_overlay.visible = not floor_overlay.visible
	if event.keycode == KEY_A: _set_facing(true)
	if event.keycode == KEY_D: _set_facing(false)
	for i in range(5):
		if event.keycode == KEY_1 + i: _play(STATES[i])


func _fail(reason: String) -> void:
	push_error("D267 THREE QA FAILURE: " + reason)
	_label(reason,Vector2(65,270),Vector2(1150,200),23)
