extends Control

# D267: user-selected RICH original Court sprites at native x1 and x2.1.
# These are identical to the atlases staged in the game's strict library.
# Original source edge warnings remain open for visual review. D271 Court backdrop approved.
const PRODUCTION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const PATH := "res://assets/pixel/units/court_of_the_mute_qa/"
const BACKDROP := "res://assets/pixel/battle/arenas/court_of_the_mute_d271_painted_qa.webp.b64"
const ROLES: Array[String] = ["mute_magistrate", "ash_scrivener", "bone_bailiff"]
const TITLES: Array[String] = ["БЕЗМОЛВНЫЙ МАГИСТРАТ", "ПИСАРЬ ПРАХА", "КОСТЯНОЙ ПРИСТАВ"]
const STATES: Array[String] = ["idle", "walk", "attack", "hit", "death"]
const ANIM_LABELS: Array[String] = ["ОЖИДАНИЕ", "ХОДЬБА", "АТАКА", "УРОН", "СМЕРТЬ"]
const CARD_ID := "court_of_the_mute"
# D268 manual art-QA navigation for 27 SOURCE flags (not 27 proven broken sprites).
const REVIEW_FLAGS := {
	"mute_magistrate": {"walk": [2, 3], "attack": [0, 1, 3]},
	"bone_bailiff": {
		"idle": [0, 1, 2, 3], "walk": [0, 1, 2, 3, 4, 5],
		"attack": [0, 1, 2, 3, 4, 5], "hit": [0, 1, 2],
		"death": [3, 4, 5]
	}
}

var big: Dictionary = {}
var native: Dictionary = {}
var frames: Dictionary = {}
var current_state := "walk"
var facing_left := true
var paused := false
var current_frame := 0
var warning_cursor := -1
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
		_fail("D271 accepted painted Court backdrop cannot be decoded")
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
	for role in ROLES:
		var source: String = PATH + role + "_d267_rich_qa.webp.b64"
		var original := _image_from_base64(source, Vector2i(576, 480))
		if original == null:
			_fail("D267 chosen rich Court atlas unavailable: " + role)
			return
		var canonical: SpriteFrames = PRODUCTION_LIBRARY.get_frames(role)
		if canonical == null:
			_fail("D267 original rich Court atlas rejected by strict library: " + role)
			return
		for anim in STATES:
			if not canonical.has_animation(anim):
				_fail("D267 missing original state: %s/%s" % [role, anim])
				return
		frames[role] = canonical
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var x: float = float(240 + i * 402)
		_label(TITLES[i],Vector2(x - 192,153),Vector2(384,33),16)
		big[role] = _animated(frames[role],Vector2(x,354),2.1)
		native[role] = _animated(frames[role],Vector2(x,517),1.0)
	_label("D272 · УТВЕРЖДЁННЫЕ ПЕРСОНАЖИ · 75 КАДРОВ · РЕВИЗИЯ",Vector2(37,12),Vector2(1204,50),24)
	_label("МАСШТАБ ×2.1 · сравни захват предметов, движение и падение",Vector2(60,218),Vector2(1160,28),15)
	_label("БОЕВОЙ МАСШТАБ ×1",Vector2(60,438),Vector2(1160,23),13)
	caption = _label("",Vector2(58,570),Vector2(1160,27),13)
	_button("← ВЛЕВО",Vector2(58,70),Vector2(173,34)).pressed.connect(_set_facing.bind(true))
	_button("ВПРАВО →",Vector2(245,70),Vector2(173,34)).pressed.connect(_set_facing.bind(false))
	_button("◀ КАДР",Vector2(447,70),Vector2(157,34)).pressed.connect(_step_frame.bind(-1))
	_button("ПАУЗА / PLAY",Vector2(615,70),Vector2(183,34)).pressed.connect(_toggle_pause)
	_button("КАДР ▶",Vector2(808,70),Vector2(157,34)).pressed.connect(_step_frame.bind(1))
	_button("27 МЕТОК ▶",Vector2(976,70),Vector2(236,34)).pressed.connect(_next_warning)
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
	_label("D268 · 27 исходных меток: 5 Магистрат / 0 Писарь / 22 Пристав. Это точки проверки, не доказанные дефекты.",Vector2(62,599),Vector2(1152,27),13)
	print("D267_THREE_RICH_COURT_F6_PASS: Godot decoded 3 original 25-pose alpha animation atlases; idle/walk/attack/hit/death; native x1 and zoom x2; card39 still QA")
	print("D272_COURT_GALLERY_D271_PASS: accepted painted Court backdrop in all-three rich sprite inspection")
	print("D272_VISUAL_REVIEW: 27 original SOURCE flags need x1 grip, feet and Bailiff death3-5 inspection; not proven output crop defects")


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
	_update_caption()


func _play(state: String) -> void:
	current_state = state
	paused = false
	current_frame = 0
	for role in ROLES:
		for sprite in [big[role],native[role]]:
			var s := sprite as AnimatedSprite2D
			s.stop()
			s.play(state)
	_update_caption()


func _toggle_pause() -> void:
	paused = not paused
	for role in ROLES:
		for sprite in [big[role], native[role]]:
			var actor := sprite as AnimatedSprite2D
			if paused:
				actor.pause()
			else:
				actor.play(current_state)
	if paused:
		current_frame = (native[ROLES[0]] as AnimatedSprite2D).frame
	_update_caption()


func _step_frame(delta: int) -> void:
	paused = true
	var count: int = (frames[ROLES[0]] as SpriteFrames).get_frame_count(current_state)
	current_frame = posmod(current_frame + delta, count)
	for role in ROLES:
		for sprite in [big[role], native[role]]:
			var actor := sprite as AnimatedSprite2D
			actor.pause()
			actor.frame = current_frame
	_update_caption()


func _next_warning() -> void:
	# One combined D267 three-role review; focus only frames flagged by source QC.
	var flagged: Array[Dictionary] = []
	for role in ROLES:
		var by_state: Dictionary = REVIEW_FLAGS.get(role, {})
		for state in STATES:
			var frame_indices: Array = by_state.get(state, [])
			for index in frame_indices:
				flagged.append({"role": role, "state": state, "frame": int(index)})
	if flagged.size() != 27:
		_fail("D268 QC marker mismatch: expected 27 original source flags")
		return
	warning_cursor = (warning_cursor + 1) % flagged.size()
	var marked: Dictionary = flagged[warning_cursor]
	_play(String(marked["state"]))
	paused = true
	current_frame = int(marked["frame"])
	for role in ROLES:
		for sprite in [big[role], native[role]]:
			var actor := sprite as AnimatedSprite2D
			actor.pause()
			actor.frame = current_frame
	_update_caption(String(marked["role"]))


func _update_caption(focus_role: String = "") -> void:
	if caption == null:
		return
	var direction := "←" if facing_left else "→"
	var hint := "АВТОВОСПРОИЗВЕДЕНИЕ" if not paused else "ПАУЗА · КАДР %d" % current_frame
	var active_flags: Array[String] = []
	for role in ROLES:
		var by_state: Dictionary = REVIEW_FLAGS.get(role, {})
		var indices: Array = by_state.get(current_state, [])
		if paused and current_frame in indices:
			active_flags.append(role)
	var note := ""
	if not active_flags.is_empty():
		note = " · ПРОВЕРИТЬ ИСХОДНЫЙ КРАЙ: " + ", ".join(active_flags)
	if not focus_role.is_empty():
		note += " · ФОКУС: " + focus_role
	caption.text = "D268 / %s · %s · %s%s · #39 QA · 38/45" % [current_state.to_upper(), direction, hint, note]


func _unhandled_key_input(event: InputEvent) -> void:
	if not(event is InputEventKey) or not event.pressed or event.echo:
		return
	if event.keycode == KEY_G and floor_overlay:
		floor_overlay.visible = not floor_overlay.visible
	if event.keycode == KEY_A: _set_facing(true)
	if event.keycode == KEY_D: _set_facing(false)
	if event.keycode == KEY_SPACE: _toggle_pause()
	if event.keycode == KEY_LEFT: _step_frame(-1)
	if event.keycode == KEY_RIGHT: _step_frame(1)
	if event.keycode == KEY_N: _next_warning()
	for i in range(5):
		if event.keycode == KEY_1 + i: _play(STATES[i])


func _fail(reason: String) -> void:
	push_error("D268 THREE RICH COURT QA FAILURE: " + reason)
	_label(reason,Vector2(65,270),Vector2(1150,200),23)
