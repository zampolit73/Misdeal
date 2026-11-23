extends CanvasLayer
## A presentation puppet from the arena painting. The BattleUnit is already
## on the field in its real formation underneath this temporary camera.

signal finished

const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const SEATED_POSE := preload("res://assets/pixel/battle/arenas/arena_redraw_v2/warden_throne_pose.png")
const DURATION := 1.95
const LEAN_START := 0.4
const STAND_START := 0.63
const STAND_END := 1.28
const CAMERA_HEADROOM := 64.0
const VAULT_SAMPLE_HEIGHT := 8.0
# The guide rows follow the crown, shoulders, hands, knees and soles in the
# painted pose. Lifting the pelvis and relaxing the arms leaves the feet set.
const COLUMNS := [0.0, 42.0, 80.0, 110.0, 150.0, 192.0, 225.0, 265.0, 306.0]
const ROWS := [0.0, 47.0, 88.0, 108.0, 145.0, 159.0, 186.0, 218.0, 247.0, 285.0, 337.0]
const BODY_LIFT := [46.0, 46.0, 46.0, 48.0, 55.0, 60.0, 48.0, 34.0, 16.0, 0.0, -3.0]
const EDGE_LIFT := [46.0, 46.0, 46.0, 29.0, -17.0, -17.0, 5.0, 13.0, 6.0, 0.0, -3.0]
const NARROWING := [0.0, 0.0, 0.0, 0.04, 0.38, 0.37, 0.21, 0.13, 0.07, 0.0, 0.0]

var _backdrop: BACKDROP
var _transition: CanvasLayer
var _camera := Node2D.new()
var _room := Sprite2D.new()
var _ceiling := Sprite2D.new()
var _figure := Polygon2D.new()
var _matte := ColorRect.new()
var _caption := Label.new()
var _elapsed := 0.0
var _throne_revealed := false
var _finished := false


func play(backdrop: BACKDROP) -> void:
	name = "WardenIntro"
	layer = 50
	_backdrop = backdrop
	_transition = get_tree().root.get_node_or_null("SceneTransition") as CanvasLayer
	add_child(_camera)
	_camera.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_camera.position.y = CAMERA_HEADROOM
	_room.centered = false
	_room.material = backdrop.material
	_camera.add_child(_room)
	# Extend the very top of the vault without reflecting the throne or crown.
	_ceiling.centered = false
	_ceiling.region_enabled = true
	_ceiling.region_rect = Rect2(0, 0, BACKDROP.BACKDROP_SIZE.x, VAULT_SAMPLE_HEIGHT)
	_ceiling.scale.y = CAMERA_HEADROOM / VAULT_SAMPLE_HEIGHT
	_ceiling.flip_v = true
	_ceiling.position.y = -CAMERA_HEADROOM
	_camera.add_child(_ceiling)
	var shadow := Gradient.new()
	shadow.offsets = PackedFloat32Array([0.0, 0.35, 1.0])
	shadow.colors = PackedColorArray([Color("#0e0c10"), Color(0.055, 0.047, 0.063, 0.9), Color(0.055, 0.047, 0.063, 0.0)])
	var falloff := GradientTexture2D.new()
	falloff.gradient = shadow
	falloff.width = 1
	falloff.height = int(CAMERA_HEADROOM)
	falloff.fill_to = Vector2.DOWN
	var vault_shadow := Sprite2D.new()
	vault_shadow.centered = false
	vault_shadow.texture = falloff
	vault_shadow.position.y = -CAMERA_HEADROOM
	vault_shadow.scale.x = BACKDROP.BACKDROP_SIZE.x
	_camera.add_child(vault_shadow)
	_set_camera_plate()
	_build_figure()

	_matte.color = Color("#0e0c10")
	_matte.position = Vector2(0, 664)
	_matte.size = Vector2(1280, 56)
	_matte.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_matte)
	_caption.text = "XIII  ·  КОСТЯНОЙ НАДЗИРАТЕЛЬ"
	_caption.position = Vector2(32, 674)
	_caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.apply_title(_caption, UI.GOLD)
	_caption.add_theme_font_size_override("font_size", 24)
	add_child(_caption)
	var hint := Label.new()
	hint.text = "Пропустить · клик или Esc"
	hint.position = Vector2(903, 7)
	hint.size.x = 313
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UI.apply_screen_copy(hint, UI.TEXT_SECONDARY)
	_caption.add_child(hint)


func _set_camera_plate() -> void:
	_room.texture = _backdrop.texture
	_ceiling.texture = _backdrop.texture


func _build_figure() -> void:
	var mesh_points := PackedVector2Array()
	var cells: Array[PackedInt32Array] = []
	var columns := COLUMNS.size()
	for y in ROWS:
		for x in COLUMNS:
			mesh_points.append(Vector2(x, y))
	for row in range(ROWS.size() - 1):
		for col in range(columns - 1):
			var a := row * columns + col
			cells.append(PackedInt32Array([a, a + 1, a + 1 + columns]))
			cells.append(PackedInt32Array([a, a + 1 + columns, a + columns]))
	_figure.position = Vector2(BACKDROP.WARDEN_THRONE_ORIGIN)
	_figure.texture = SEATED_POSE
	_figure.polygon = mesh_points
	_figure.uv = mesh_points
	_figure.polygons = cells
	_figure.hide()
	_camera.add_child(_figure)


func _process(delta: float) -> void:
	# Give the seated pose its full hold after SceneRouter's entry veil.
	if is_instance_valid(_transition) and _transition.get("_busy"):
		return
	_elapsed += delta
	if _elapsed >= DURATION:
		skip()
		return
	if _elapsed < LEAN_START:
		return
	if not _throne_revealed:
		_reveal_throne()
		_figure.show()
	var lean := smoothstep(LEAN_START, STAND_START, _elapsed)
	var rise := smoothstep(STAND_START, STAND_END, _elapsed)
	_pose(lean * (1.0 - rise), rise)
	var reveal := smoothstep(1.43, 1.74, _elapsed)
	_figure.modulate.a = 1.0 - reveal
	var settle := smoothstep(1.62, DURATION, _elapsed)
	_camera.position.y = lerpf(CAMERA_HEADROOM, 0.0, settle)
	_matte.modulate.a = 1.0 - settle
	_caption.modulate.a = 1.0 - settle


func _pose(lean: float, rise: float) -> void:
	var points := PackedVector2Array()
	for row in range(ROWS.size()):
		var y: float = ROWS[row]
		for x: float in COLUMNS:
			var body := 1.0 - smoothstep(23.0, 82.0, absf(x - 150.0))
			var lift := lerpf(EDGE_LIFT[row], BODY_LIFT[row], body)
			var bend := (1.0 - smoothstep(104.0, 285.0, y)) * lean
			var draw_x := lerpf(x, 150.0, NARROWING[row] * rise) + 12.0 * bend
			points.append(Vector2(draw_x, y - lift * rise + 12.0 * bend))
	_figure.polygon = points


func _input(event: InputEvent) -> void:
	var click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	if click or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		skip()


func _reveal_throne() -> void:
	_throne_revealed = true
	_backdrop.reveal_empty_warden_throne()
	_set_camera_plate()


func skip() -> void:
	if _finished:
		return
	_finished = true
	if not _throne_revealed:
		_reveal_throne()
	hide()
	set_process(false)
	set_process_input(false)
	finished.emit()
	queue_free()
