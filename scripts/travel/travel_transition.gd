extends CanvasLayer
signal finished
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const PANORAMA := preload("res://scripts/travel/travel_panorama.gd")
const GROUND_FX := preload("res://scripts/travel/travel_ground_fx.gd")
const WALK_FPS := 6.5
const BODY_SPEED := 20.0
static var _soles: Dictionary = {}
var context: Dictionary = {}
var data_path := ""
var data: Resource
var elapsed := 0.0
var done := false
var available := false
var stage: Control
var composition: CanvasGroup
var matte: ColorRect
var panorama: Node2D
var actors: Array[AnimatedSprite2D] = []
var role_ids: Array[String] = []
var contacts: Array[Vector2] = []
var ground_fx: Node2D
var caption: Label
var wizard: Label
var title: Label
var fog: ColorRect
var exit_shade: ColorRect
var skip_button: Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if data_path.is_empty(): data_path = preload("res://scripts/travel/travel_catalog.gd").resource_for(context)
	data = load(data_path) as Resource if ResourceLoader.exists(data_path) else null
	if data == null: return
	matte = ColorRect.new()
	matte.color = Color.BLACK
	matte.modulate.a = 0.0
	add_child(matte)
	stage = Control.new()
	stage.name = "TravelStage"
	stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.size = Vector2(1280,720)
	add_child(stage)
	# Fade the flattened painting ONCE. Per-child inherited alpha exposes
	# overlapping cutout boundaries during a cross-dissolve over Event/Reward.
	composition = CanvasGroup.new()
	composition.self_modulate.a = 0.0
	composition.fit_margin = 2.0
	composition.clear_margin = 2.0
	stage.add_child(composition)
	if data.panorama_script == null: return
	panorama = data.panorama_script.new()
	composition.add_child(panorama)
	panorama.build(data.background_path,data.foreground_path,data.underpaint_path,data.sky_path)
	if not panorama.available: return
	if panorama.has_method("configure"): panorama.call("configure",context)
	fog = ColorRect.new()
	fog.position = data.fog_rect.position
	fog.size = data.fog_rect.size
	fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mist := ShaderMaterial.new()
	mist.shader = preload("res://shaders/travel_fog.gdshader")
	fog.material = mist
	panorama.add_child(fog)
	panorama.move_child(fog,panorama.planes.Midground.get_index())
	ground_fx = GROUND_FX.new()
	composition.add_child(ground_fx)
	for role in context.get("party_roles",[]):
		if role not in ["knight","ranger","mage"]: continue
		var frames: SpriteFrames = ANIM.get_frames(role)
		if frames == null or not frames.has_animation("walk"): return
		var sprite := AnimatedSprite2D.new()
		sprite.sprite_frames = frames
		sprite.animation = "walk"
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.scale = Vector2.ONE * (1.80 if role == "knight" else 1.72) * float(data.party_scale)
		sprite.modulate = data.party_tint
		composition.add_child(sprite)
		actors.append(sprite)
		role_ids.append(role)
		contacts.append(Vector2.ZERO)
		_measure_soles(role,frames)
	if actors.is_empty(): return
	var foreground: Node2D = panorama.planes.Foreground
	foreground.reparent(composition,false)
	foreground.visible = true
	exit_shade = ColorRect.new()
	exit_shade.color = UI.VOID
	exit_shade.size = stage.size
	exit_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	composition.add_child(exit_shade)
	_build_ui(str(data.title))
	available = true
	update_frame()

func _build_ui(scene_title: String) -> void:
	var gradient := Gradient.new()
	gradient.set_color(0,Color(0.016,0.018,0.025,0))
	gradient.set_color(1,Color(0.016,0.018,0.025,0.88))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 2
	texture.height = 128
	texture.fill_from = Vector2(0,0)
	texture.fill_to = Vector2(0,1)
	var scrim := TextureRect.new()
	scrim.name = "NarrativeGradient"
	scrim.texture = texture
	scrim.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scrim.position = Vector2(0,584)
	scrim.size = Vector2(1280,136)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	composition.add_child(scrim)
	caption = text(str(context.get("narration_text","")),Vector2(160,622),Vector2(960,52),UI.TYPE_SECTION)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Liberation Serif","DejaVu Serif","Times New Roman"])
	caption.add_theme_font_override("font",serif)
	wizard = text(str(context.get("wizard_line","")),Vector2(180,682),Vector2(920,24),UI.TYPE_META)
	wizard.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wizard.add_theme_color_override("font_color",UI.TEXT_SECONDARY)
	title = text(scene_title,Vector2(52,34),Vector2(920,28),UI.TYPE_BODY)
	title.add_theme_color_override("font_color",UI.TEXT_SECONDARY)
	skip_button = Button.new()
	skip_button.text = "ПРОПУСТИТЬ · ESC"
	skip_button.position = Vector2(1072,30)
	skip_button.size = Vector2(164,34)
	UI.apply_action_button(skip_button,UI.AGED_BRONZE,false)
	skip_button.modulate.a = 0.78
	skip_button.add_theme_font_size_override("font_size",UI.TYPE_CAPTION)
	composition.add_child(skip_button)
	skip_button.pressed.connect(finish)

func text(value: String, pos: Vector2, dimensions: Vector2, points: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size",points)
	label.add_theme_color_override("font_color",UI.TEXT)
	label.add_theme_color_override("font_shadow_color",Color(0.01,0.01,0.02,0.95))
	label.add_theme_constant_override("shadow_offset_y",2)
	label.add_theme_constant_override("shadow_outline_size",2)
	composition.add_child(label)
	return label

static func _measure_soles(role: String, frames: SpriteFrames) -> void:
	if _soles.has(role): return
	var heights: Array[int] = []
	for frame in range(frames.get_frame_count("walk")):
		var image := frames.get_frame_texture("walk",frame).get_image()
		var bottom := 80
		for y in range(image.get_height()-1,55,-1):
			var found := false
			for x in range(30,65):
				if image.get_pixel(x,y).a > 0.5:
					found = true
					break
			if found:
				bottom = y
				break
		heights.append(bottom)
	_soles[role] = heights

func _process(delta: float) -> void:
	if done or not available or get_tree().paused: return
	elapsed += delta
	update_frame()
	if elapsed >= duration(): finish()

func duration() -> float:
	return clampf(float(context.get("duration_sec",4.0)),3.0,5.0)

func update_frame() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var fit := minf(viewport_size.x / 1280.0,viewport_size.y / 720.0)
	stage.scale = Vector2.ONE * fit
	stage.position = (viewport_size - Vector2(1280,720)*fit) * 0.5
	matte.size = viewport_size
	var time := minf(elapsed,duration())
	panorama.update_time(time,duration())
	composition.self_modulate.a = smoothstep(0.0,0.36,time)
	matte.modulate.a = composition.self_modulate.a
	for i in range(actors.size()):
		var sprite := actors[i]
		var phase := time * WALK_FPS + i * 1.1
		sprite.frame = int(phase) % sprite.sprite_frames.get_frame_count("walk")
		# Held support poses follow the road; advance on the next authored pose.
		var plant := (BODY_SPEED + float(panorama.speeds.Road)) * fposmod(phase,1.0) / WALK_FPS
		var foot := Vector2(data.party_origin.x + time * BODY_SPEED - i * data.party_spacing - plant,data.party_origin.y + i * data.party_depth_step)
		if actors.size() == 1: foot.x += 60
		sprite.position = foot - Vector2(0,(_soles[role_ids[i]][sprite.frame]-48)*sprite.scale.y)
		contacts[i] = foot
	ground_fx.update_contacts(contacts,time)
	(fog.material as ShaderMaterial).set_shader_parameter("elapsed",time)
	var leave := smoothstep(duration()-0.60,duration()-0.15,time)
	exit_shade.modulate.a = leave * 0.36
	var text_alpha := smoothstep(0.52,0.92,time) * (1.0-smoothstep(duration()-0.65,duration()-0.18,time))
	caption.modulate.a = text_alpha
	wizard.modulate.a = text_alpha * 0.85
	title.modulate.a = 1.0 - smoothstep(2.1,3.2,time) * 0.5

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_SPACE,KEY_ENTER,KEY_KP_ENTER,KEY_ESCAPE]:
		get_viewport().set_input_as_handled()
		finish()

func finish() -> void:
	if done: return
	done = true
	finished.emit()
