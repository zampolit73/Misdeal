extends CanvasLayer
signal finished
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
var context: Dictionary = {}
var elapsed := 0.0
var done := false
var available := false
var stage: Control
var far: TextureRect
var near: TextureRect
var actors: Array[AnimatedSprite2D] = []
var caption: Label
var fog: ColorRect
func _ready() -> void:
	# Inherit actual game pause; skip is handled before the paused check.
	process_mode = Node.PROCESS_MODE_ALWAYS
	var data := load("res://resources/travel/ruined_castle_road.tres") as Resource
	if data == null: return
	stage = Control.new()
	add_child(stage)
	stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.size = Vector2(1280,720)
	var cover := ColorRect.new()
	cover.color = Color("090c12")
	cover.size = stage.size
	stage.add_child(cover)
	far = plate(str(data.background_path),Vector2(-30,-15),Vector2(1370,770))
	available = far.texture != null
	var cloth := ShaderMaterial.new()
	cloth.shader = preload("res://shaders/travel_cloth.gdshader")
	far.material = cloth
	for i in range(context.get("party_roles",[]).size()):
		var role: String = context.party_roles[i]
		var sprite := AnimatedSprite2D.new()
		sprite.sprite_frames = ANIM.get_frames(role)
		if sprite.sprite_frames == null: continue
		sprite.process_mode = Node.PROCESS_MODE_PAUSABLE
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.scale = Vector2.ONE*(2.05 if role=="knight" else 1.95)
		sprite.play("walk")
		sprite.frame = i % sprite.sprite_frames.get_frame_count("walk")
		stage.add_child(sprite)
		actors.append(sprite)
	near = plate(str(data.foreground_path),Vector2(-60,-32),Vector2(1420,650))
	fog = ColorRect.new()
	fog.position = Vector2(0,350)
	fog.size = Vector2(1280,120)
	fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fog.color = Color.WHITE
	var mist := ShaderMaterial.new()
	mist.shader = preload("res://shaders/travel_fog.gdshader")
	fog.material = mist
	stage.add_child(fog)
	var footer := ColorRect.new()
	footer.position = Vector2(0,583)
	footer.size = Vector2(1280,137)
	footer.color = Color(0.025,0.02,0.025,0.94)
	stage.add_child(footer)
	caption = text(str(context.get("narration_text","")),Vector2(110,601),Vector2(1060,55),21)
	text(str(context.get("wizard_line","")),Vector2(110,660),Vector2(900,35),14)
	text(str(data.title),Vector2(72,42),Vector2(960,40),25)
	var skip := Button.new()
	skip.text = "ПРОПУСТИТЬ · ESC"
	skip.position = Vector2(1010,50)
	skip.size = Vector2(220,38)
	UI.apply_action_button(skip,UI.AGED_BRONZE,false)
	stage.add_child(skip)
	skip.pressed.connect(finish)
	update_frame()
func plate(path: String, pos: Vector2, dimensions: Vector2) -> TextureRect:
	var node := TextureRect.new()
	var image := Image.new()
	if image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK:
		node.texture = ImageTexture.create_from_image(image)
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_SCALE
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.position = pos
	node.size = dimensions
	stage.add_child(node)
	return node
func text(value: String, pos: Vector2, dimensions: Vector2, points: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size",points)
	label.add_theme_color_override("font_color",Color("ddc9a4"))
	stage.add_child(label)
	return label
func _process(delta: float) -> void:
	if done or not available or get_tree().paused: return
	elapsed += delta
	update_frame()
	if elapsed >= float(context.get("duration_sec",4.0)): finish()
func update_frame() -> void:
	stage.scale = get_viewport().get_visible_rect().size / Vector2(1280,720)
	far.position.x = -30-elapsed*6
	(far.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	near.position.x = -60-elapsed*22
	for i in range(actors.size()):
		actors[i].position = Vector2(250+elapsed*112-i*105,491-i*3)
	caption.modulate.a = clampf((elapsed-0.35)/0.4,0,1)
	fog.position.x = sin(elapsed*0.3)*25
	(fog.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_SPACE,KEY_ENTER,KEY_KP_ENTER,KEY_ESCAPE]:
		get_viewport().set_input_as_handled()
		finish()
func finish() -> void:
	if done: return
	done = true
	for actor in actors: actor.pause()
	finished.emit()
