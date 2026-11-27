extends Node2D
## Isolated presentation pilot. No RunState, rewards, saves or live routing.
## Every object projects through one ground-plane scale; position is a pure
## function of local movie time so pause, seek and replay stay deterministic.

const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const LIGHT := preload("res://shaders/travel_v3_local_motion.gdshader")
const FX := preload("res://scripts/travel/cinematic_v5/forge_v5_fx.gd")
const ROOT := "res://assets/pixel/travel/cinematic_v5/curse_forge/"
const LEGACY := "res://assets/pixel/travel/batch_02/curse_forge/layers/"
const DURATION := 6.6
const HANDOFF := 3.22
# Native painted cels retain source detail; only their logical scale is
# converted to the common ground-plane projection (six times the old grid).
const SMITH_CELL := 576
const SMITH_SOLE := 534.0
const SMITH_FOOT := Vector2(337, 535)
const IMPACT := Vector2(449, 414)
const HORIZON := 280.0
const PIXELS_PER_DEPTH_METER := 0.55
const ROLES := ["knight", "ranger", "mage"]
const ACTIONS := ["dead_mans_shield", "blind_quiver", "cracked_focus", "leave"]
const BUYERS := {"dead_mans_shield":"knight", "blind_quiver":"ranger", "cracked_focus":"mage"}
const BODY_PX := {"knight":72.0, "ranger":71.0, "mage":68.0, "smith":444.0}
const STATURE_M := {"knight":1.83, "ranger":1.78, "mage":1.76, "smith":1.82}
const RACK_Y := 463.0
const RACK_TOP := 394.0
const PROP_X := [638.0, 770.0, 906.0]
const PROP_HEIGHT_M := [0.94, 0.89, 0.34]
const PROP_PATHS := ["release_shield.png", "release_quiver.png", "release_focus.png"]
const WALK_IN := 2.55
const WALK_OUT := 3.95

var available := false
var roles: Array[String] = []
var order: Array[String] = []
var action := "leave"
var jack_present := false
var actors: Dictionary = {}
var shadows: Dictionary = {}
var frames: Dictionary = {}
var tracks: Dictionary = {}
var props: Array[Sprite2D] = []
var party_feet: Dictionary = {}
var world: Node2D
var plate: Sprite2D
var smith: Sprite2D
var smith_pose := 0
var smith_frames: Array[Texture2D] = []
var blade: Sprite2D
var jack: Sprite2D
var jack_shadow: Sprite2D
var jack_frames: SpriteFrames
var jack_body_px := 1.0
var fx: Node2D
var shadow_texture: Texture2D
var elapsed := 0.0
var selected := -1
var current_frame: Dictionary = {}
var strikes: Array[float] = []

static func pixels_per_meter(foot_y: float) -> float:
	return maxf(1.0, (foot_y - HORIZON) * PIXELS_PER_DEPTH_METER)

static func body_height(role: String, foot_y: float) -> float:
	return float(STATURE_M[role]) * pixels_per_meter(foot_y)

static func allowed_actions(party: Array) -> Array[String]:
	var result: Array[String] = []
	for key in ACTIONS:
		if key == "leave" or BUYERS[key] in party:
			result.append(key)
	return result

func _load_image(path: String) -> Image:
	var image := Image.new()
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty(): return null
	var status := image.load_webp_from_buffer(bytes) if path.ends_with(".webp") else image.load_png_from_buffer(bytes)
	return image if status == OK else null

func _sprite(texture: Texture2D, parent: Node2D, z: int, at: Vector2, centered := true) -> Sprite2D:
	var node := Sprite2D.new()
	node.texture = texture
	node.centered = centered
	node.z_index = z
	node.position = at
	parent.add_child(node)
	return node

func _load_texture(path: String) -> Texture2D:
	var image := _load_image(path)
	return ImageTexture.create_from_image(image) if image != null else null

func _shadow(tex: Texture2D, at: Vector2, size_px: float, z: int) -> Sprite2D:
	var sprite := _sprite(tex, world, z, at)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.scale = Vector2(size_px * 0.52 / 64.0, size_px * 0.105 / 20.0)
	return sprite

func _make_shadow() -> Texture2D:
	var img := Image.create(64, 20, false, Image.FORMAT_RGBA8)
	for y in 20:
		for x in 64:
			var r := Vector2((x - 31.5) / 32.0, (y - 9.5) / 10.0).length()
			img.set_pixel(x, y, Color(0.012,0.009,0.008,0.45 * pow(maxf(0.0,1.0-r), 1.3)))
	return ImageTexture.create_from_image(img)

func configure(party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if party.is_empty() or party.size() > 3 or resolved_action not in allowed_actions(party):
		return false
	roles.clear()
	for role in party:
		if role not in ROLES or role in roles:
			return false
		roles.append(role)
	action = resolved_action
	jack_present = has_jack and "ranger" in roles
	order.assign(roles)
	if action != "leave":
		var buyer: String = BUYERS[action]
		order.erase(buyer)
		order.push_front(buyer) # staging only: the actual buyer approaches the rack
	selected = ACTIONS.find(action) if action != "leave" else -1
	strikes.assign([1.05, 2.92, 5.05] if action == "leave" else [1.05, 5.05])
	if is_instance_valid(world):
		remove_child(world)
		world.free()
	actors.clear()
	shadows.clear()
	frames.clear()
	tracks.clear()
	props.clear()
	party_feet.clear()
	smith_frames.clear()
	current_frame.clear()
	jack_body_px = 1.0
	jack = null
	jack_shadow = null
	world = Node2D.new()
	world.name = "ForgeWorld"
	add_child(world)
	var background := _load_texture(ROOT + "forge_plate.webp")
	var smith_image := _load_image(ROOT + "smith_atlas_hd.webp")
	var foreground := _load_texture(ROOT + "anvil_foreground.png")
	var blade_image := _load_texture(ROOT + "heated_blade.png")
	if background == null or smith_image == null or foreground == null or blade_image == null:
		return false
	if background.get_size() != Vector2(1280,720) or smith_image.get_size() != Vector2i(SMITH_CELL * 3, SMITH_CELL * 2):
		return false
	plate = _sprite(background, world, 0, Vector2.ZERO, false)
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var heat := ShaderMaterial.new()
	heat.shader = LIGHT
	heat.set_shader_parameter("scene_kind", -1)
	heat.set_shader_parameter("local_lights", PackedVector4Array([Vector4(118,328,44,57), Vector4.ZERO, Vector4.ZERO]))
	plate.material = heat
	shadow_texture = _make_shadow()
	fx = FX.new()
	fx.z_index = 3
	world.add_child(fx)
	# The smith is physically behind the freestanding object, whose exact
	# foreground pixels cover the lower torso/hand where appropriate.
	var smith_atlas := ImageTexture.create_from_image(smith_image)
	for i in 6:
		var cel := AtlasTexture.new()
		cel.atlas = smith_atlas
		cel.region = Rect2((i % 3) * SMITH_CELL, floori(i / 3.0) * SMITH_CELL, SMITH_CELL, SMITH_CELL)
		cel.filter_clip = true
		smith_frames.append(cel)
	_shadow(shadow_texture, SMITH_FOOT, body_height("smith",SMITH_FOOT.y), 1)
	smith = _sprite(smith_frames[0], world, 2, SMITH_FOOT)
	smith.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_sprite(foreground, world, 3, Vector2(377,410), false)
	blade = _sprite(blade_image,world,4,Vector2(452,410))
	blade.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	for i in 3:
		var image := _load_image(LEGACY + PROP_PATHS[i])
		if image == null or image.get_used_rect().size.y < 10:
			return false
		image = image.get_region(image.get_used_rect())
		var prop := _sprite(ImageTexture.create_from_image(image),world,2,Vector2(PROP_X[i], RACK_TOP),false)
		var f := float(PROP_HEIGHT_M[i]) * pixels_per_meter(RACK_Y) / image.get_height()
		prop.scale = Vector2.ONE * f
		prop.position -= Vector2(image.get_width()*f*0.5,image.get_height()*f)
		props.append(prop)
	for role in order:
		var set := ANIM.get_frames(role)
		if set == null or set.get_frame_count("walk") != 6 or set.get_frame_count("idle") != 4:
			return false
		if role == "ranger":
			set = _ranger_without_floor_marker(set)
		frames[role] = set
		actors[role] = _sprite(set.get_frame_texture("walk",0),world,8,Vector2.ZERO)
		actors[role].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		shadows[role] = _shadow(shadow_texture, Vector2.ZERO, 200.0, 7)
		var rank := order.find(role)
		var track := V3.gait(_foot.bind(rank), _height_at.bind(role), DURATION)
		# Six cels cover a natural step cycle (~0.51 body lengths), not
		# the denser gait used by the small, distant V3 walkers.
		track.pitch = 0.085
		tracks[role] = track
	if jack_present:
		jack_frames = ANIM.get_frames("jack")
		if jack_frames == null:
			return false
		for i in jack_frames.get_frame_count("walk"):
			jack_body_px = maxf(jack_body_px,float(jack_frames.get_frame_texture("walk",i).get_image().get_used_rect().size.y))
		jack = _sprite(jack_frames.get_frame_texture("walk",0),world,8,Vector2.ZERO)
		jack.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		jack_shadow = _shadow(shadow_texture,Vector2.ZERO,100.0,7)
	available = true
	seek(0.0)
	return true

# The approved Ranger walk includes a few neutral grey ground guide pixels
# at rows 88–89. Remove only those presentation markers in local copies;
# never edit or replace the shared combat atlas.
func _ranger_without_floor_marker(source: SpriteFrames) -> SpriteFrames:
	var output := SpriteFrames.new()
	output.remove_animation("default")
	for clip in ["idle","walk"]:
		output.add_animation(clip)
		output.set_animation_loop(clip,true)
		output.set_animation_speed(clip,source.get_animation_speed(clip))
		for i in source.get_frame_count(clip):
			var tex := source.get_frame_texture(clip,i)
			if clip == "walk":
				var image := tex.get_image()
				for y in range(88,90):
					for x in range(29,68):
						var c := image.get_pixel(x,y)
						if maxf(c.r,maxf(c.g,c.b))-minf(c.r,minf(c.g,c.b)) < 0.08 and maxf(c.r,maxf(c.g,c.b)) > 0.30:
							image.set_pixel(x,y,Color.TRANSPARENT)
				tex = ImageTexture.create_from_image(image)
			output.add_frame(clip,tex)
	return output

func _height_at(foot: Vector2, role: String) -> float:
	return body_height(role,foot.y)

func _target(rank: int) -> Vector2:
	var center: float = PROP_X[selected] + 10.0 if selected >= 0 else 808.0
	var spacing := minf(174.0,(1158.0-center)/maxf(1.0,float(order.size()-1)))
	var y := 522.0 if selected >= 0 and rank == 0 else (568.0 if rank == 1 else 598.0)
	return Vector2(center + float(rank)*spacing, y)

func _foot(time: float, rank: int) -> Vector2:
	var stop := _target(rank)
	if selected < 0:
		# Right-hand entrance keeps the smith visible during the first strike.
		var entry := Vector2(1080.0+rank*174.0, 576.0+float(rank%2)*19.0)
		return entry.lerp(entry-Vector2(790.0,8.0),clampf(time/DURATION,0.0,1.0))
	var start := stop + Vector2(365.0,52.0 if rank == 0 else 3.0)
	var end := stop + Vector2(-449.0,57.0 if rank == 0 else -6.0)
	if time < WALK_IN:
		var u := clampf(time / WALK_IN,0.0,1.0)
		var advance := u + sin(PI*u)*0.23
		return start.lerp(stop,advance)
	if time <= WALK_OUT:
		return stop
	var u := clampf((time-WALK_OUT)/(DURATION-WALK_OUT),0.0,1.0)
	var advance := u-sin(PI*u)*0.23
	if rank == 0:
		# Move onto the front walkway BEFORE passing the anvil footprint.
		# Same Bézier path drives feet and distance-aware walk cadence.
		var control := stop + Vector2(-60.0,88.0)
		return stop.lerp(control,advance).lerp(control.lerp(end,advance),advance)
	return stop.lerp(end,advance)

func _moving(time: float) -> bool:
	return selected < 0 or time < WALK_IN or time > WALK_OUT

func _smith_pose_at(time: float) -> int:
	for strike in strikes:
		var dt := time - strike
		if dt >= -0.83 and dt < 0.47:
			if dt < -0.62: return 0
			if dt < -0.39: return 1
			if dt < -0.13: return 2
			if dt < 0.0: return 3
			if dt < 0.13: return 4
			return 5
	# Distinct acknowledging pose while the selected hero stands at the stall.
	return 5 if selected >= 0 and time > 1.52 and time < 4.22 else 0

func _camera(time: float) -> Transform2D:
	var emphasis := smoothstep(1.1,2.7,time)*(1.0-smoothstep(4.0,5.8,time))
	var zoom := 1.012 + emphasis * 0.065
	var focus := 640.0 if selected < 0 else lerpf(620.0,PROP_X[selected],emphasis*0.6)
	var position := Vector2(clampf(640.0-focus*zoom,1280.0-1280.0*zoom,0.0), -(zoom-1.0)*340.0)
	return Transform2D(0.0,Vector2.ONE*zoom,0.0,position)

func _stage_actor(role: String, index: int, time: float) -> void:
	var foot := _foot(time,index)
	var frame_set: SpriteFrames = frames[role]
	var is_walking := _moving(time)
	var phase := V3.phase(tracks[role],time,float(index)*0.57)
	var label := "walk" if is_walking else "idle"
	var frame := int(phase)%6 if is_walking else int((time-WALK_IN)*2.7+index)%4
	var sprite: Sprite2D = actors[role]
	var f := body_height(role,foot.y) / float(BODY_PX[role])
	sprite.texture = frame_set.get_frame_texture(label,frame)
	sprite.flip_h = true
	sprite.scale = Vector2.ONE*f
	sprite.position = foot - Vector2(0,(89.0-48.0)*f)
	sprite.z_index = 8+int(foot.y)
	# Local light matches warm furnace and cooler rainy opening.
	var warmth := 1.0-smoothstep(420.0,860.0,foot.x)
	sprite.modulate = Color(0.80,0.83,0.91).lerp(Color(1.0,0.87,0.72),warmth)
	var shadow: Sprite2D = shadows[role]
	shadow.position = foot
	shadow.scale = Vector2(body_height(role,foot.y)*0.52/64.0,body_height(role,foot.y)*0.105/20.0)
	party_feet[role] = foot
	current_frame[role] = {"clip":label,"frame":frame,"phase":phase,"foot":foot,"height":body_height(role,foot.y)}

func seek(time: float) -> void:
	if not available:
		return
	elapsed = clampf(time,0.0,DURATION)
	world.transform = _camera(elapsed)
	(plate.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	smith_pose = _smith_pose_at(elapsed)
	smith.texture = smith_frames[smith_pose]
	smith.scale = Vector2.ONE*body_height("smith",SMITH_FOOT.y)/float(BODY_PX.smith)
	smith.position = SMITH_FOOT-Vector2(0,(SMITH_SOLE-SMITH_CELL*0.5)*smith.scale.y)
	for i in props.size():
		var item := props[i]
		var move := smoothstep(HANDOFF-0.26,HANDOFF,elapsed) if i == selected else 0.0
		var size := item.texture.get_size()*item.scale
		# Transfer happens behind the actual customer silhouette. No invented
		# wielded equipment/attack animation; after passing, the rack is empty.
		item.position = Vector2(PROP_X[i]-size.x*0.5+10.0*move,RACK_TOP-size.y+24.0*move)
		item.visible = i != selected or elapsed < HANDOFF
	for i in order.size():
		_stage_actor(order[i],i,elapsed)
	if is_instance_valid(jack):
		var ranger: Dictionary = current_frame.ranger
		var foot: Vector2 = ranger.foot
		var dog_height := pixels_per_meter(foot.y+11.0)*0.60
		foot += Vector2(dog_height*1.75,11.0)
		var label: String = ranger.clip
		var frame := int(ranger.phase*1.3)%jack_frames.get_frame_count("walk") if label=="walk" else 0
		jack.texture = jack_frames.get_frame_texture(label,frame)
		jack.flip_h = true
		var used := jack.texture.get_image().get_used_rect()
		var factor := dog_height/jack_body_px
		jack.scale = Vector2.ONE*factor
		jack.position = foot-Vector2(0,(float(used.end.y)-48.0)*factor)
		jack.z_index = 8+int(foot.y)
		jack.modulate = Color(0.86,0.86,0.88)
		jack_shadow.position = foot
		jack_shadow.scale = Vector2(dog_height/64.0,dog_height*0.20/20.0)
	fx.sample(elapsed,strikes,IMPACT)

func visible_prop_count() -> int:
	var result := 0
	for item in props:
		if item.visible: result += 1
	return result
