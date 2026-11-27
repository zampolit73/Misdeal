extends "res://scripts/travel/cinematic_v5/camp_v5.gd"
## Review-only relic movies: human-scale approach, separate source-registered
## insert, then the exact committed painted result and onward road.
const RELIC_IDS := ["debtor_bones","wizard_tithe","broken_crown"]
const RELIC_PROFILE := "res://resources/travel/cinematic_v5/relic_batch.json"
const B02 := preload("res://scripts/travel/batch_02_catalog.gd")
const RELIC_ROOT := "res://assets/pixel/travel/cinematic_v5/relic_batch/"
const DETAIL_IN := 2.45
const DETAIL_OUT := 4.02
static var _relic_textures: Dictionary = {}
var worksite: Sprite2D
var detail: Node2D
var detail_base: Sprite2D
var detail_state: Sprite2D
var detail_pose: Sprite2D
var detail_cels: Array[Dictionary] = []
var pose_index := -1
var detail_animated := false

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

func _worksite(key: String) -> Sprite2D:
	var tex := _cached(RELIC_ROOT+scene_id+"/worksite_"+key+".webp",Vector2(640,360))
	if tex==null: return null
	var part := _sprite(tex,world,3,_p(profile.origin),false)
	part.scale = Vector2.ONE*float(profile.projection)*2.0
	part.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var material := ShaderMaterial.new()
	material.shader = V3.LIGHT
	material.set_shader_parameter("scene_kind",-1)
	var masks := PackedVector4Array()
	for mask in V3.LIGHT_MASKS.get(scene_id,[]): masks.append(mask)
	masks.resize(3)
	material.set_shader_parameter("local_lights",masks)
	part.material = material
	return part

func _build_detail() -> bool:
	var legacy := B02.ROOT+scene_id+"/"
	var original := _cached(legacy+"layers/base_1280.png",Vector2(1280,720))
	var result := _cached(legacy+"layers/"+action+"_state.png",Vector2(1280,720))
	if original==null or result==null: return false
	detail = Node2D.new()
	detail.name = "OriginalRelicInsert"
	detail.z_index = 2000
	add_child(detail)
	detail_base = V3.base_sprite(detail,original,scene_id)
	detail_base.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	detail_state = _sprite(result,detail,2,Vector2.ZERO,false)
	detail_state.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	detail_pose = _sprite(null,detail,3,Vector2.ZERO,false)
	detail_pose.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var folder := legacy+"animation/"+action+"/"
	var manifest: Variant = JSON.parse_string(FileAccess.get_file_as_string(folder+"poses.json"))
	if not manifest is Dictionary or not manifest.get("poses",[]) is Array: return false
	for cel in manifest.poses:
		var rect: Array = cel.rect
		var tex := _cached(folder+str(cel.path),Vector2(float(rect[2]),float(rect[3])))
		if tex==null: return false
		detail_cels.append({"texture":tex,"at":Vector2(float(rect[0]),float(rect[1])),"time":float(cel.time)})
	detail_animated = false
	for cel in detail_cels:
		if cel.texture!=detail_cels[0].texture: detail_animated=true
	return not detail_cels.is_empty()

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if resolved_action not in relic_actions(id,party): return false
	if not FileAccess.file_exists(RELIC_PROFILE) or not _load_living_poses(): return false
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(RELIC_PROFILE))
	if not json is Dictionary or not json.has(id): return false
	profile = json[id]
	scene_id = id
	action = resolved_action
	roles.assign(party)
	order.assign(party)
	joining = ""
	action_role = "" if action=="leave" else order[0]
	profile["look"] = {action:profile.look_at}
	jack_present = has_jack and "ranger" in roles
	if is_instance_valid(world): world.free()
	if is_instance_valid(detail): detail.free()
	detail = null
	detail_base = null
	detail_state = null
	detail_pose = null
	detail_cels.clear()
	detail_animated = false
	world = Node2D.new()
	world.name = "RelicWorld"
	add_child(world)
	waiting_layer = null
	state_layer = null
	treatment_layer = null
	camp_layer = null
	squire = null
	boot_reactions = null
	foreground = null
	jack = null
	jack_shadow = null
	for dict in [actors,shadows,tracks,party_feet,current_frame,side_frames,walk_heights,rear_heights,routes]:
		dict.clear()
	visible_roles.clear()
	dog_track.clear()
	var texture := _cached(RELIC_ROOT+id+"/plate.webp",Vector2(1280,720))
	if texture==null: return false
	# Wide plate is independently authored. Never reuse old source light masks.
	plate = V3.base_sprite(world,texture,"")
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var lights := PackedVector4Array()
	for mask in profile.lights: lights.append(Vector4(mask[0],mask[1],mask[2],mask[3]))
	lights.resize(3)
	(plate.material as ShaderMaterial).set_shader_parameter("local_lights",lights)
	worksite = _worksite("base")
	if worksite==null: return false
	if action!="leave":
		state_layer = _worksite(action)
		if state_layer==null or not _build_detail(): return false
	shadow_texture = _make_shadow()
	var contact := _p(profile.origin)+_p(profile.contact)*float(profile.projection)
	var contact_shadow := _shadow(shadow_texture,contact,200.0,2)
	contact_shadow.scale = Vector2(float(profile.projection)*9.5,0.95)
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
		routes[role] = _route(role)
		tracks[role] = V3.gait(_hero_foot.bind(role),_height.bind(role),DURATION)
		tracks[role].pitch = maxf(0.068,float(tracks[role].total)/(DURATION*8.5))
	if jack_present:
		jack_frames = VIS.side_frames("jack")
		if jack_frames==null or jack_frames.get_frame_count("walk")!=6: return false
		jack_body_px = VIS.DOG_REFERENCE_PX
		jack = _sprite(jack_frames.get_frame_texture("idle",0),world,30,Vector2.ZERO)
		jack_shadow = _shadow(shadow_texture,Vector2.ZERO,60.0,20)
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
	var depart := DETAIL_OUT + 0.12*(order.size()-1-rank if reversed else rank)
	if t<depart: return route.wait
	var fraction := 1.0-0.19*(order.size()-1-rank if reversed else rank)
	return _path(route.out,smoothstep(depart,DURATION,t)*fraction)

func _dog_foot(t: float) -> Vector2:
	var foot := _hero_foot(maxf(0.0,t-0.12),"ranger")
	var gap := _ppm(foot.y)*JACK_ROUTE_SPACING_M
	# Ground-side offset remains continuous through the cinematic cut.
	return foot+Vector2(-gap*0.58,gap*0.69)

func _camera(t: float) -> Transform2D:
	var e := smoothstep(0.6,ARRIVAL,t)*(1.0-smoothstep(DETAIL_OUT,6.3,t))
	var zoom := 1.01+e*0.027
	var focus := Vector2(640,360).lerp(_p(profile.focus),e*0.65)
	return Transform2D(0,Vector2.ONE*zoom,0,Vector2(clampf(640-focus.x*zoom,1280-1280*zoom,0),clampf(360-focus.y*zoom,720-720*zoom,0)))

func seek(time: float) -> void:
	if not available: return
	super.seek(time)
	var after := elapsed>=HANDOFF
	worksite.visible = not prop_changed
	(worksite.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	if is_instance_valid(state_layer):
		(state_layer.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	var insert := action!="leave" and elapsed>=DETAIL_IN and elapsed<DETAIL_OUT
	world.visible = not insert
	pose_index = -1
	if not is_instance_valid(detail): return
	detail.visible = insert
	detail_state.visible = after
	detail_pose.visible = false
	if not insert: return
	(detail_base.material as ShaderMaterial).set_shader_parameter("elapsed",elapsed)
	# Sparse old manifests with a single result pose keep the original
	# painting until the actual impact. A small camera push supplies the beat.
	var zoom := 1.0+0.028*smoothstep(DETAIL_IN,HANDOFF,elapsed)
	detail.transform = Transform2D(0,Vector2.ONE*zoom,0,Vector2(-1250.0*(zoom-1.0),-440.0*(zoom-1.0)))
	if after or not detail_animated: return
	# Preserve the original local cel sequence and full-size source coordinates.
	var source_t := lerpf(0.48,1.46,clampf((elapsed-DETAIL_IN)/(HANDOFF-DETAIL_IN),0.0,1.0))
	for i in detail_cels.size():
		if float(detail_cels[i].time)<=source_t+0.00001: pose_index=i
	if pose_index>=0:
		var cel: Dictionary = detail_cels[pose_index]
		detail_pose.texture = cel.texture
		detail_pose.position = cel.at
		detail_pose.visible = true
