extends "res://scripts/travel/cinematic_v5/forge_v5.gd"
## Review-only merchants; no live routing or gameplay mutation.
## Reuse the approved forge's scale, gait, shared unit textures and anchors.

const BATCH_ROOT := "res://assets/pixel/travel/cinematic_v5/merchant_batch/"
const PROFILE_PATH := "res://resources/travel/cinematic_v5/merchant_batch.json"
const IDS := ["candle_seller","blood_ledger","gravedigger_shop"]
const ROLE_ACTIONS := ["knight","ranger","mage","leave"]
const LEDGER_ACTIONS := ["gold","blood","erase","leave"]
var scene_id := ""
var profile: Dictionary = {}
var npc_foot := Vector2.ZERO
var npc_height := 0.0
var direction := 1.0
var lane := 600.0
var prop_states: Array = []
var state_indices: Array[int] = []
var prop_anchors: Array[Vector2] = []
var glow: Sprite2D
var fx_texture: Texture2D

static func scene_actions(id: String, party: Array) -> Array[String]:
	var result: Array[String] = []
	for key in (LEDGER_ACTIONS if id == "blood_ledger" else ROLE_ACTIONS):
		if id == "blood_ledger" or key == "leave" or key in party:
			result.append(key)
	return result

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if id not in IDS or party.is_empty() or party.size()>3 or resolved_action not in scene_actions(id,party):
		return false
	roles.clear()
	for role in party:
		if role not in ROLES or role in roles: return false
		roles.append(role)
	var profiles: Variant = JSON.parse_string(FileAccess.get_file_as_string(PROFILE_PATH))
	if not profiles is Dictionary or not profiles.has(id): return false
	profile = profiles[id]
	scene_id = id
	action = resolved_action
	order.assign(roles)
	if action in ROLES:
		order.erase(action)
		order.push_front(action)
	jack_present = has_jack and "ranger" in roles
	selected = -1 if action=="leave" else (0 if id=="blood_ledger" else ROLE_ACTIONS.find(action))
	direction = float(profile.dir)
	lane = float(profile.lane)
	npc_foot = Vector2(float(profile.foot[0]),float(profile.foot[1]))
	npc_height = float(profile.stature)*pixels_per_meter(npc_foot.y)
	if is_instance_valid(world):
		remove_child(world)
		world.free()
	actors.clear()
	shadows.clear()
	frames.clear()
	tracks.clear()
	props.clear()
	prop_states.clear()
	prop_anchors.clear()
	state_indices.clear()
	party_feet.clear()
	smith_frames.clear()
	current_frame.clear()
	jack = null
	jack_shadow = null
	jack_body_px = 1.0
	world = Node2D.new()
	world.name = "MerchantWorld"
	add_child(world)
	var prefix := BATCH_ROOT+id+"/"
	var background := _load_texture(prefix+"plate.webp")
	var atlas := _load_texture(prefix+"npc_atlas.webp")
	var counter := _load_texture(prefix+"counter.webp")
	if background==null or atlas==null or counter==null: return false
	if background.get_size()!=Vector2(1280,720) or atlas.get_size()!=Vector2.ONE*float(profile.npc_cell)*2.0: return false
	plate = _sprite(background,world,0,Vector2.ZERO,false)
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var heat := ShaderMaterial.new()
	heat.shader = LIGHT
	heat.set_shader_parameter("scene_kind",-1)
	var lamp: Array = profile.light
	heat.set_shader_parameter("local_lights",PackedVector4Array([Vector4(lamp[0],lamp[1],lamp[2],lamp[3]),Vector4.ZERO,Vector4.ZERO]))
	plate.material = heat
	shadow_texture = _make_shadow()
	_shadow(shadow_texture,npc_foot,npc_height,1)
	var cell := int(profile.npc_cell)
	for i in 4:
		var cel := AtlasTexture.new()
		cel.atlas = atlas
		cel.region = Rect2((i%2)*cell,floori(i/2.0)*cell,cell,cell)
		cel.filter_clip = true
		smith_frames.append(cel)
	smith = _sprite(smith_frames[0],world,2,npc_foot)
	smith.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	smith.scale = Vector2.ONE*npc_height/float(profile.npc_height)
	smith.position -= Vector2(0,(float(profile.npc_sole)-cell*0.5)*smith.scale.y)
	var front: Array = profile.counter_at
	_sprite(counter,world,3,Vector2(front[0],front[1]),false).texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	for i in profile.props.size():
		var states: Array[Texture2D] = []
		for j in int(profile.prop_variants[i]):
			var tex := _load_texture(prefix+"prop_%d_%d.webp"%[i,j])
			if tex == null: return false
			states.append(tex)
		prop_states.append(states)
		state_indices.append(0)
		var item: Array = profile.props[i]
		var anchor := Vector2(item[0],item[1])
		prop_anchors.append(anchor)
		var prop := _sprite(states[0],world,4,anchor,false)
		prop.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		# Physical object height at counter depth; ledger is horizontal, so
		# authoring height is its projected top-to-bottom silhouette.
		var factor := float(item[2])*pixels_per_meter(float(profile.counter_depth))/states[0].get_height()
		if scene_id=="blood_ledger": factor *= 2.1
		prop.scale = Vector2.ONE*factor
		prop.position -= Vector2(states[0].get_width()*factor*0.5,states[0].get_height()*factor)
		props.append(prop)
	fx_texture = _soft_glow()
	glow = _sprite(fx_texture,world,5,Vector2.ZERO)
	glow.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	glow.visible = false
	for role in order:
		var set := ANIM.get_frames(role)
		if set==null or set.get_frame_count("walk")!=6 or set.get_frame_count("idle")!=4: return false
		if role=="ranger": set = _ranger_without_floor_marker(set)
		frames[role] = set
		actors[role] = _sprite(set.get_frame_texture("walk",0),world,8,Vector2.ZERO)
		actors[role].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		shadows[role] = _shadow(shadow_texture,Vector2.ZERO,200.0,7)
		var track := V3.gait(_foot.bind(order.find(role)),_height_at.bind(role),DURATION)
		track.pitch = 0.085
		tracks[role] = track
	if jack_present:
		jack_frames = ANIM.get_frames("jack")
		if jack_frames==null: return false
		for i in jack_frames.get_frame_count("walk"):
			jack_body_px=maxf(jack_body_px,float(jack_frames.get_frame_texture("walk",i).get_image().get_used_rect().size.y))
		jack=_sprite(jack_frames.get_frame_texture("walk",0),world,8,Vector2.ZERO)
		jack.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
		jack_shadow=_shadow(shadow_texture,Vector2.ZERO,100.0,7)
	available=true
	seek(0.0)
	return true

func _target(rank: int) -> Vector2:
	var lead := float(profile.target)
	var spacing := 154.0
	return Vector2(lead-direction*rank*spacing,lane+float(rank%2)*17.0)

func _foot(time: float, rank: int) -> Vector2:
	var stop := _target(rank)
	var entry := Vector2(-120.0-rank*152.0 if direction>0 else 1400.0+rank*152.0,stop.y+7.0)
	var end := Vector2(1400.0-rank*152.0 if direction>0 else -120.0+rank*152.0,stop.y+7.0)
	if action=="leave":
		return entry.lerp(end,clampf(time/DURATION,0.0,1.0))
	entry = stop-Vector2(direction*440.0,-7.0)
	end = stop+Vector2(direction*480.0,7.0)
	if time<WALK_IN:
		var u := clampf(time/WALK_IN,0.0,1.0)
		return entry.lerp(stop,u+sin(PI*u)*0.23)
	if time<=WALK_OUT: return stop
	var u := clampf((time-WALK_OUT)/(DURATION-WALK_OUT),0.0,1.0)
	return stop.lerp(end,u-sin(PI*u)*0.23)

func _moving(time: float) -> bool:
	return action=="leave" or time<WALK_IN or time>WALK_OUT

func _camera(time: float) -> Transform2D:
	var emphasis := smoothstep(1.1,2.7,time)*(1.0-smoothstep(4.0,6.2,time))
	var zoom := 1.008+emphasis*0.028
	var focus := lerpf(640.0,npc_foot.x,emphasis*0.24)
	return Transform2D(0.0,Vector2.ONE*zoom,0.0,Vector2(clampf(640.0-focus*zoom,1280.0-1280.0*zoom,0.0),-(zoom-1.0)*340.0))

func _stage_actor(role: String, index: int, time: float) -> void:
	super._stage_actor(role,index,time)
	var unit: Sprite2D = actors[role]
	unit.flip_h = direction<0
	var warm := 1.0-smoothstep(80.0,520.0,absf(unit.position.x-npc_foot.x))
	unit.modulate=Color(0.81,0.84,0.92).lerp(Color(1.0,0.89,0.78),warm)

func _soft_glow() -> Texture2D:
	var img := Image.create(64,64,false,Image.FORMAT_RGBA8)
	for y in 64:
		for x in 64:
			var a := pow(maxf(0.0,1.0-Vector2((x-31.5)/32.0,(y-31.5)/32.0).length()),2.6)
			img.set_pixel(x,y,Color(1.0,0.62,0.25,a*0.38))
	return ImageTexture.create_from_image(img)

func _smith_pose_at(time: float) -> int:
	if time<0.85: return 0
	if time<1.72: return 1
	if time<HANDOFF: return 2
	if time<4.22: return 3
	if time<5.1: return 1
	return 0

func seek(time: float) -> void:
	if not available: return
	elapsed=clampf(time,0.0,DURATION)
	world.transform=_camera(elapsed)
	(plate.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	smith_pose=_smith_pose_at(elapsed)
	smith.texture=smith_frames[smith_pose]
	smith.flip_h=scene_id=="blood_ledger" and smith_pose==1
	for i in props.size():
		var next := 0
		if elapsed>=HANDOFF:
			if scene_id=="blood_ledger": next=LEDGER_ACTIONS.find(action)+1
			elif i==selected: next=1
		state_indices[i]=next
		props[i].texture=prop_states[i][next]
	# A restrained warm pulse follows the transaction, not an unrelated
	# spark shower. Leave never falsely indicates a purchase.
	glow.visible=action!="leave" and absf(elapsed-HANDOFF)<0.42
	glow.position=prop_anchors[maxi(0,selected)]-Vector2(0,20)
	glow.scale=Vector2.ONE*(0.85+0.15*sin(elapsed*14.0))
	glow.modulate.a=1.0-clampf(absf(elapsed-HANDOFF)/0.42,0.0,1.0)
	for i in order.size():
		_stage_actor(order[i],i,elapsed)
	if is_instance_valid(jack):
		var ranger: Dictionary=current_frame.ranger
		var foot: Vector2=ranger.foot
		var dog_height:=pixels_per_meter(foot.y+11.0)*0.60
		foot+=Vector2(-direction*dog_height*1.23,11.0)
		var label: String=ranger.clip
		var frame:=int(ranger.phase*1.3)%jack_frames.get_frame_count("walk") if label=="walk" else 0
		jack.texture=jack_frames.get_frame_texture(label,frame)
		jack.flip_h=direction<0
		var used:=jack.texture.get_image().get_used_rect()
		var factor:=dog_height/jack_body_px
		jack.scale=Vector2.ONE*factor
		jack.position=foot-Vector2(0,(float(used.end.y)-48.0)*factor)
		jack.z_index=8+int(foot.y)
		jack.modulate=Color(0.86,0.86,0.88)
		jack_shadow.position=foot
		jack_shadow.scale=Vector2(dog_height/64.0,dog_height*0.20/20.0)
