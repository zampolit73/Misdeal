extends "res://scripts/travel/cinematic_v5/rescue_v5.gd"
## Relic polish: one integrated live painting, real tabletop props, standing
## role-specific gestures and continuous approach/action/departure.
const RELIC_IDS := ["debtor_bones","wizard_tithe","broken_crown"]
const RELIC_PROFILE := "res://resources/travel/cinematic_v5/relic_batch.json"
const B02 := preload("res://scripts/travel/batch_02_catalog.gd")
const RELIC_ROOT := "res://assets/pixel/travel/cinematic_v5/relic_polish/"
const PROP := preload("res://scripts/travel/cinematic_v5/relic_props_v5.gd")
const LIVING := preload("res://shaders/travel_relic_living.gdshader")
const REFLECT := preload("res://shaders/travel_relic_reflection.gdshader")
const DETAIL_IN := 2.45 # action sound timestamp; no camera cut
const RELIC_DEPART := 4.16
static var _relic_textures: Dictionary = {}
static var _gesture_atlas: Image
static var _gesture_cache: Dictionary = {}
var transactions: Node2D
var gesture_frames: Dictionary = {}
var reflections: Dictionary = {}
var npc_patch: Sprite2D

static func relic_actions(id: String, party: Array) -> Array[String]:
	var result: Array[String] = []
	if id not in RELIC_IDS or party.is_empty() or party.size()>3: return result
	var seen: Array = []
	for role in party:
		if role not in ROLES or role in seen: return result
		seen.append(role)
	result.assign(B02.ACTIONS[id])
	return result

func _cached(path: String, expected: Vector2) -> Texture2D:
	if _relic_textures.has(path): return _relic_textures[path]
	var tex := _load_texture(path)
	if tex==null or tex.get_size()!=expected: return null
	_relic_textures[path]=tex
	return tex

func _mask(key: String) -> Vector4:
	var v: Array = profile.get(key,[0,0,0,0])
	return Vector4(v[0],v[1],v[2],v[3])

func _load_gestures() -> bool:
	if not _gesture_cache.is_empty():
		gesture_frames=_gesture_cache
		return true
	if not is_instance_valid(_gesture_atlas):
		_gesture_atlas = Image.new()
		if _gesture_atlas.load_webp_from_buffer(FileAccess.get_file_as_bytes(RELIC_ROOT+"gesture_heroes.webp"))!=OK: return false
	if _gesture_atlas.get_size()!=Vector2i(864,864): return false
	for y in ROLES.size():
		var row: Array[Texture2D] = []
		for x in 3:
			var cel := _gesture_atlas.get_region(Rect2i(x*288,y*288,288,288))
			if cel.get_used_rect().size==Vector2i.ZERO: return false
			var logical := cel.duplicate() as Image
			logical.resize(96,96,Image.INTERPOLATE_LANCZOS)
			row.append(VIS._texture(cel,ImageTexture.create_from_image(logical)))
		gesture_frames[ROLES[y]]=row
	_gesture_cache=gesture_frames
	return true

func _make_reflection(key: String) -> void:
	var node := _sprite(null,world,15,Vector2.ZERO)
	node.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var mat := ShaderMaterial.new()
	mat.shader=REFLECT
	mat.set_shader_parameter("alpha",float(profile.reflection))
	node.material=mat
	reflections[key]=node

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if resolved_action not in relic_actions(id,party): return false
	if not FileAccess.file_exists(RELIC_PROFILE) or not _load_gestures(): return false
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(RELIC_PROFILE))
	if not json is Dictionary or not json.has(id): return false
	profile = json[id]
	scene_id = id
	action = resolved_action
	roles.assign(party)
	order.assign(roles)
	joining = ""
	action_role = "" if action=="leave" else order[0]
	jack_present = has_jack and "ranger" in roles
	if is_instance_valid(world): world.free()
	world = Node2D.new()
	world.name = "ContinuousRelicWorld"
	add_child(world)
	waiting_layer = null
	state_layer = null
	treatment_layer = null
	foreground = null
	npc_patch = null
	jack = null
	jack_shadow = null
	for dict in [actors,shadows,tracks,party_feet,current_frame,side_frames,walk_heights,rear_heights,routes,reflections]:
		dict.clear()
	visible_roles.clear()
	dog_track.clear()
	var texture := _cached(RELIC_ROOT+id+"/plate.webp",Vector2(1280,720))
	if texture==null: return false
	plate = _sprite(texture,world,0,Vector2.ZERO,false)
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var mat := ShaderMaterial.new()
	mat.shader = LIVING
	var lights := PackedVector4Array()
	for mask in profile.lights: lights.append(Vector4(mask[0],mask[1],mask[2],mask[3]))
	lights.resize(3)
	mat.set_shader_parameter("lights",lights)
	for key in ["npc_hand","npc_hood","cloth"]: mat.set_shader_parameter(key,_mask(key))
	plate.material = mat
	if profile.has("npc_rect"):
		var rect := _mask("npc_rect")
		var patch := _cached(RELIC_ROOT+id+"/npc_gesture.webp",Vector2(rect.z,rect.w))
		if patch==null: return false
		npc_patch = _sprite(patch,world,1,Vector2(rect.x,rect.y),false)
		npc_patch.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	shadow_texture = _make_shadow()
	transactions = PROP.new()
	transactions.name = "LocalTransactions"
	world.add_child(transactions)
	if not transactions.build(id,action,profile,shadow_texture): return false
	var rear := REAR.new()
	if not rear.build(): return false
	rear_frames = REAR.frames
	for role in order:
		var source := VIS.side_frames(role)
		if source==null or source.get_frame_count("walk")!=6: return false
		var side := _ranger_without_floor_marker(source) if role=="ranger" else source
		side_frames[role] = side
		walk_heights[role] = _walk_height(side)
		rear_heights[role] = _walk_height(rear_frames[role])
		actors[role] = _sprite(side.get_frame_texture("idle",0),world,30,Vector2.ZERO)
		shadows[role] = _shadow(shadow_texture,Vector2.ZERO,170.0,20)
		if float(profile.reflection)>0.0: _make_reflection(role)
		routes[role] = _route(role)
		tracks[role] = V3.gait(_hero_foot.bind(role),_height.bind(role),DURATION)
		tracks[role].pitch = maxf(0.068,float(tracks[role].total)/(DURATION*8.5))
	if jack_present:
		jack_frames = VIS.side_frames("jack")
		if jack_frames==null or jack_frames.get_frame_count("walk")!=6: return false
		jack_body_px = VIS.DOG_REFERENCE_PX
		jack = _sprite(jack_frames.get_frame_texture("idle",0),world,30,Vector2.ZERO)
		jack_shadow = _shadow(shadow_texture,Vector2.ZERO,60.0,20)
		if float(profile.reflection)>0.0: _make_reflection("jack")
		dog_track = V3.gait(_dog_foot,_dog_height,DURATION)
		dog_track.pitch = maxf(0.06,float(dog_track.total)/(DURATION*9.0))
	available = true
	seek(0.0)
	return true

func _route(role: String) -> Dictionary:
	var rank := order.find(role)
	var start := _p(profile.entry)+_p(profile.entry_spacing)*rank
	if action=="leave":
		var road := _points(profile.road)
		road[0]=start
		return {"road":road}
	var wait := _p(profile.wait_slots[rank])
	var approach: Array[Vector2] = [start,start.lerp(wait,0.60)+Vector2(0,14),wait]
	var exit: Array[Vector2] = [wait]
	var turns := _points(profile.exit_turns)
	# Same-direction followers join from behind; reversed exit followers nearer
	# the arch peel away first rather than intersecting the customer's path.
	if bool(profile.exit_reversed):
		turns = turns.slice(mini(rank,turns.size()-2))
	exit.append_array(turns)
	return {"in":approach,"wait":wait,"out":exit}

func _hero_foot(t: float, role: String) -> Vector2:
	var rank := order.find(role)
	var route: Dictionary = routes[role]
	if action=="leave":
		return _path(route.road,clampf(t/DURATION*(1.0-rank*0.16),0.0,1.0))
	if t<ARRIVAL: return _path(route["in"],smoothstep(0.0,ARRIVAL,t))
	var reversed := bool(profile.exit_reversed)
	var depart := RELIC_DEPART + 0.12*(order.size()-1-rank if reversed else rank)
	if t<depart: return route.wait
	var fraction := 1.0-0.19*(order.size()-1-rank if reversed else rank)
	return _path(route.out,smoothstep(depart,DURATION,t)*fraction)

func _dog_foot(t: float) -> Vector2:
	var foot := _hero_foot(maxf(0.0,t-0.12),"ranger")
	var gap := _ppm(foot.y)*JACK_ROUTE_SPACING_M
	# Ground-side offset remains continuous through the cinematic cut.
	return foot+Vector2(-gap*0.70,gap*0.52)

func _camera(t: float) -> Transform2D:
	# A modest continuous dolly: the whole scene, everyone and all objects share
	# one transform. No second painting, change of perspective or fullscreen cut.
	var e := smoothstep(0.50,ARRIVAL+0.25,t)*(1.0-smoothstep(RELIC_DEPART,6.35,t))
	if action=="leave": e *= 0.24
	var zoom := 1.014+e*0.145
	var focus := Vector2(640,360).lerp(_p(profile.focus),e*0.78)
	return Transform2D(0,Vector2.ONE*zoom,0,Vector2(clampf(640-focus.x*zoom,1280-1280*zoom,0),clampf(360-focus.y*zoom,720-720*zoom,0)))

func _grade(foot: Vector2) -> Color:
	var a: Array = profile.ambient
	var b: Array = profile.warm
	var cool := Color(a[0],a[1],a[2])
	var warm := Color(b[0],b[1],b[2])
	var e := 1.0-smoothstep(38.0,float(profile.light_radius),foot.distance_to(_p(profile.light_at)))
	return cool.lerp(warm,e)

func _reflect(key: String, actor: Sprite2D, foot: Vector2, t: float) -> void:
	if not reflections.has(key): return
	var echo: Sprite2D = reflections[key]
	echo.texture=actor.texture
	echo.flip_h=actor.flip_h
	echo.flip_v=true
	echo.scale=Vector2(actor.scale.x,actor.scale.y*0.31)
	var bounds := VIS.logical_image(actor.texture).get_used_rect()
	echo.position=foot+Vector2(0,(float(bounds.end.y)-48.0)*echo.scale.y+1.0)
	echo.modulate=actor.modulate
	echo.visible=actor.visible
	(echo.material as ShaderMaterial).set_shader_parameter("elapsed",t)

func _place_hero(role: String, t: float) -> void:
	var actor: Sprite2D = actors[role]
	var shade: Sprite2D = shadows[role]
	var foot := _hero_foot(t,role)
	var velocity := _hero_foot(minf(DURATION,t+0.055),role)-_hero_foot(maxf(0,t-0.055),role)
	var moving := velocity.length()>0.65
	var phase := V3.phase(tracks[role],t,float(order.find(role))*0.53)
	var facing := velocity
	if not moving:
		if t<RELIC_DEPART and action!="leave": facing=_p(profile.look_at)-foot
		else: facing=foot-_hero_foot(maxf(0.0,t-0.32),role)
	var rear := moving and velocity.y < -absf(velocity.x)*0.54 and (t>=HANDOFF or action=="leave")
	var set: SpriteFrames = rear_frames[role] if rear else side_frames[role]
	var clip := "walk" if moving else "idle"
	var frame := int(phase)%6 if moving else int(t*2.4)%4
	if role==action_role and t>=ARRIVAL and t<RELIC_DEPART-0.20:
		clip="gesture"
		frame=0 if t<2.62 else (1 if t<3.38 else 2)
		actor.texture=gesture_frames[role][frame]
	else:
		actor.texture=set.get_frame_texture(clip,frame)
	var height := _height(foot,role)
	var factor := height/float(rear_heights[role] if rear else walk_heights[role])
	var bounds := VIS.logical_image(actor.texture).get_used_rect()
	actor.texture_filter=VIS.filter_for(actor.texture)
	actor.position=foot-Vector2(0,(float(bounds.end.y)-48.0)*factor)
	actor.scale=Vector2.ONE*factor
	actor.flip_h=facing.x<0
	actor.visible=true
	actor.z_index=30+int(foot.y)
	actor.modulate=_grade(foot)
	shade.position=foot+Vector2(-height*0.035,2)
	shade.scale=Vector2(height*0.65/64.0,height*0.12/20.0)
	shade.visible=true
	party_feet[role]=foot
	current_frame[role]={"clip":clip,"frame":frame,"phase":phase,"foot":foot,"height":height}
	visible_roles.append(role)
	_reflect(role,actor,foot,t)

func seek(time: float) -> void:
	if not available: return
	elapsed=clampf(time,0.0,DURATION)
	var t := elapsed
	world.visible=true
	world.transform=_camera(t)
	var gesture := 0.0 if action=="leave" else smoothstep(2.47,2.79,t)*(1.0-smoothstep(3.35,3.88,t))
	var mat := plate.material as ShaderMaterial
	mat.set_shader_parameter("elapsed",t)
	mat.set_shader_parameter("gesture",gesture*0.24)
	if scene_id=="broken_crown":
		mat.set_shader_parameter("trace",smoothstep(HANDOFF,HANDOFF+0.24,t) if action=="wear" else 0.0)
	if is_instance_valid(npc_patch):
		# Actual registered authored forearm/hand pose with localized feathered
		# perimeter; one continuous painted location, never an inserted view.
		npc_patch.modulate.a=gesture
		npc_patch.visible=gesture>0.005
	visible_roles.clear()
	for role in order: _place_hero(role,t)
	if is_instance_valid(jack):
		_place_dog(t)
		jack.modulate=_grade(dog_foot)
		_reflect("jack",jack,dog_foot,t)
	var hand := _p(profile.look_at)
	if not action_role.is_empty():
		var f: Vector2 = party_feet[action_role]
		var h: float = current_frame[action_role].height
		var dir := signf(hand.x-f.x)
		hand=f+Vector2(dir*h*(0.36 if t>=3.38 else 0.56),-h*0.53)
	transactions.seek(t,hand)
	prop_changed=transactions.resolved
