extends "res://scripts/travel/cinematic_v5/rescue_v5.gd"
## Camp and equipment review only. Committed post-choice party and painted
## outcomes are presentation data, never re-resolved rewards or penalties.
const CAMP_IDS := ["last_camp", "ash_rest", "borrowed_boots"]
const CAMP_PROFILE := "res://resources/travel/cinematic_v5/camp_batch.json"
const BOOTS := preload("res://scripts/travel/campfire_panorama.gd")
const BOOTS_SHADER := preload("res://shaders/campfire_layer.gdshader")
const BOOTS_PROJECTION := Vector2(1280.0/1672.0,720.0/941.0)
const BOOTS_ACTIONS := ["repair","hobnails","passed"]
const CAMP_PASS := ["leave","passed"]
var camp_layer: Sprite2D
var boot_reactions: Node2D
var boot_rects: Dictionary = {}
var boots_materials: Array[ShaderMaterial] = []

static func camp_actions(id: String, party: Array) -> Array[String]:
	var result: Array[String] = []
	if id not in CAMP_IDS or party.is_empty() or party.size()>3: return result
	var seen: Array = []
	for role in party:
		if role not in ROLES or role in seen: return result
		seen.append(role)
	if id == "borrowed_boots":
		result.assign(BOOTS_ACTIONS)
	else:
		for key in CATALOG.scene_for(id).get("states",{}):
			if not CATALOG.action_for(id,str(key),party).is_empty(): result.append(str(key))
	return result

func _boot_piece(key: String, z: int, animated := false) -> Sprite2D:
	var tex := BOOTS.texture_at(BOOTS.DIR+key+".png")
	var r: Array = boot_rects.get(key,[])
	if tex == null or r.size()!=4: return null
	var piece := _sprite(tex,world,z,Vector2(r[0],r[1])*BOOTS_PROJECTION,false)
	piece.scale = BOOTS_PROJECTION
	piece.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if animated:
		var mat := ShaderMaterial.new()
		mat.shader = BOOTS_SHADER
		mat.set_shader_parameter("source_rect",Vector4(r[0],r[1],r[2],r[3]))
		mat.set_shader_parameter("kind",1)
		mat.set_shader_parameter("passed",key=="camp_passed")
		piece.material = mat
		boots_materials.append(mat)
	return piece

func _build_boots() -> bool:
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(BOOTS.DIR+"layers.json"))
	if not json is Dictionary: return false
	boot_rects = json
	var base := BOOTS.texture_at(BOOTS.DIR+"underpaint.png")
	if base == null: return false
	plate = V3.base_sprite(world,base,scene_id)
	plate.scale = Vector2(1280,720)/base.get_size()
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if _boot_piece("gate",1)==null or _boot_piece("road",2)==null: return false
	camp_layer = _boot_piece("camp_passed",3,true)
	if camp_layer==null: return false
	if action!="passed":
		state_layer = _boot_piece("camp_"+action,3,true)
		if state_layer==null: return false
	foreground = _boot_piece("foreground",1500)
	if foreground==null: return false
	if action=="repair":
		var strap := BOOTS.texture_at(BOOTS.DIR+"strap.png")
		if strap==null: return false
		boot_reactions = preload("res://scripts/travel/campfire_reactions.gd").new()
		boot_reactions.scale = BOOTS_PROJECTION
		boot_reactions.z_index = 4
		world.add_child(boot_reactions)
		boot_reactions.build(strap)
		boot_reactions.outcome = "repair"
	return true

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if resolved_action not in camp_actions(id,party): return false
	if not FileAccess.file_exists(CAMP_PROFILE) or not _load_living_poses(): return false
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(CAMP_PROFILE))
	if not json is Dictionary or not json.has(id): return false
	profile = json[id]
	scene_data = CATALOG.scene_for(id)
	var state: Dictionary = CATALOG.action_for(id,resolved_action,party) if id!="borrowed_boots" else {"party":"same","overlay":""}
	scene_id = id
	action = resolved_action
	roles.assign(party)
	order.assign(roles)
	joining = str(state.party).substr(1) if str(state.party).begins_with("+") else ""
	if not joining.is_empty():
		order.erase(joining)
		order.append(joining)
	action_role = "" if action in CAMP_PASS else (action if action in roles else order[0])
	if not action_role.is_empty():
		order.erase(action_role)
		order.push_front(action_role)
	jack_present = has_jack and "ranger" in roles
	if is_instance_valid(world): world.free()
	world = Node2D.new()
	world.name = "CampWorld"
	add_child(world)
	waiting_layer = null
	state_layer = null
	treatment_layer = null
	camp_layer = null
	boot_reactions = null
	jack = null
	jack_shadow = null
	boots_materials.clear()
	for dict in [actors,shadows,tracks,party_feet,current_frame,side_frames,walk_heights,rear_heights,routes]:
		dict.clear()
	visible_roles.clear()
	dog_track.clear()
	if id=="borrowed_boots":
		if not _build_boots(): return false
	else:
		var texture := _load_texture(CATALOG.ROOT.path_join(scene_data.folder).path_join(scene_data.master))
		if texture==null or texture.get_size()!=Vector2(1280,720): return false
		plate = V3.base_sprite(world,texture,id)
		plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		if not str(state.overlay).is_empty():
			state_layer = _layer(str(state.overlay),2)
			if state_layer==null: return false
		if not joining.is_empty() or str(state.party).ends_with(" lost"):
			waiting_layer = _layer(str(scene_data.phases.entry),3)
			if waiting_layer==null: return false
		foreground = _layer(str(scene_data.planes.foreground),1500)
		if foreground==null: return false
	shadow_texture = _make_shadow()
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
	var boot := scene_id=="borrowed_boots"
	var road := _points(profile.road)
	if role==joining: return {}
	if action in CAMP_PASS:
		return {"road":road}
	var target := _p(profile.targets[action])
	var rank_sign := 1.0 if boot else -1.0
	var spacing := 165.0 if boot else (270.0 if not joining.is_empty() and action!="rescue_gold" else 166.0)
	var wait := target + Vector2(rank_sign*spacing*rank,0)
	if rank>0:
		wait.y = float(profile.lane_y)+rank*11.0
		if boot:
			# The Squire is a close painted foreground figure. The actual
			# party waits on the smaller, more distant roadside plane.
			wait = _p(profile.wait_slots[rank])
	# Approach along the unobstructed foreground, then step to the actual prop.
	var start := _p(profile.entry)+Vector2(rank_sign*rank*spacing,rank*15.0)
	var approach: Array[Vector2] = [start]
	approach.append(Vector2(wait.x+rank_sign*64.0,float(profile.lane_y)+rank*11.0))
	approach.append(wait)
	var exit: Array[Vector2] = [wait]
	if boot:
		if rank==0:
			exit.append_array([Vector2(930,548),Vector2(1042,521)])
		elif rank==1:
			exit.append(Vector2(1042,521))
		else:
			exit.append(Vector2(1108,509))
		exit.append_array([Vector2(1054,477),Vector2(1084,416),Vector2(1118,350)])
	else:
		exit.append(Vector2(wait.x+65,float(profile.lane_y)+rank*11.0))
		if scene_id=="last_camp":
			exit.append(Vector2(maxf(800,wait.x+76),597+rank*7.0))
		else:
			exit.append(Vector2(maxf(806,wait.x+76),598+rank*7.0))
		exit.append_array(road.slice(4))
	return {"in":approach,"wait":wait,"out":exit}

func _hero_foot(time: float, role: String) -> Vector2:
	if role==joining:
		var path := _points(profile.join)
		return _path(path,smoothstep(RISE_END,DURATION,time))
	var route: Dictionary = routes[role]
	var rank := order.find(role)
	if action in CAMP_PASS:
		var u := clampf(time/DURATION-float(rank)*0.135,0,1)
		var point := _path(route.road,u)
		if time/DURATION < rank*0.135:
			point += Vector2((1 if scene_id=="borrowed_boots" else -1)*125.0*(rank-time/DURATION/0.135),9.0*(rank-time/DURATION/0.135))
		return point
	if time<ARRIVAL: return _path(route["in"],smoothstep(0,ARRIVAL,time))
	var depart := DEPARTURE
	# Followers at the gate side set off before the customer rejoins.
	if scene_id=="borrowed_boots" and rank>0:
		depart = HANDOFF+0.63-float(rank-1)*0.39
	if time<depart: return route.wait
	# Later party members follow the same road without merging into one slot.
	var end_fraction := 1.0-rank*0.17
	if scene_id=="borrowed_boots":
		# The waiting heroes are already nearer the gate. Let them lead out
		# instead of sending them back across the customer's path.
		end_fraction = 1.0-float(order.size()-1-rank)*0.27
	elif not joining.is_empty() and action!="rescue_gold" and rank>0:
		# Newly recovered hero starts between lead and rear guard.
		end_fraction = 0.56
	var u := smoothstep(depart,DURATION,time)*end_fraction
	return _path(route.out,u)

func _dog_foot(time: float) -> Vector2:
	var foot := _hero_foot(maxf(0,time-0.12),"ranger")
	var gap := _ppm(foot.y)*JACK_ROUTE_SPACING_M
	var sign_x := 1.0 if scene_id=="borrowed_boots" else -1.0
	# Constant ground-side offset; the reference body size is independent.
	var follow := foot+Vector2(sign_x*gap*0.48,gap*0.67)
	if scene_id=="borrowed_boots": follow.x = maxf(follow.x,foot.x-25.0)
	return follow

func _camera(t: float) -> Transform2D:
	var e := smoothstep(0.6,ARRIVAL,t)*(1.0-smoothstep(DEPARTURE,6.3,t))
	if action in CAMP_PASS: e *= 0.25
	var zoom := 1.012+e*(0.035 if scene_id=="borrowed_boots" else 0.11)
	var focus := Vector2(640,360).lerp(_p(profile.focus),e*0.78)
	return Transform2D(0,Vector2.ONE*zoom,0,Vector2(clampf(640-focus.x*zoom,1280-1280*zoom,0),clampf(360-focus.y*zoom,720-720*zoom,0)))

func _place_hero(role: String, t: float) -> void:
	var actor: Sprite2D = actors[role]
	var shade: Sprite2D = shadows[role]
	var foot := _hero_foot(t,role)
	var velocity := _hero_foot(minf(DURATION,t+0.055),role)-_hero_foot(maxf(0,t-0.055),role)
	var moving := velocity.length()>0.7
	var present := role!=joining or t>=HANDOFF
	var phase := V3.phase(tracks[role],t,float(order.find(role))*0.53)
	var facing := velocity
	if not moving:
		if role==action_role and t<DEPARTURE:
			facing = _p(profile.look[action])-foot
		elif role==joining:
			facing = Vector2.RIGHT
		elif t>=DEPARTURE:
			facing = foot-_hero_foot(maxf(0,t-0.32),role)
		else:
			facing = Vector2.LEFT if scene_id=="borrowed_boots" and t<DEPARTURE else Vector2.RIGHT
	var rear := moving and velocity.y < -absf(velocity.x)*0.52 and (t>=HANDOFF or action in CAMP_PASS)
	var set: SpriteFrames = rear_frames[role] if rear else side_frames[role]
	var clip := "walk" if moving else "idle"
	var frame := int(phase)%6 if moving else int(t*2.4)%4
	var pose_index := -1
	if role==joining and t>=HANDOFF and t<RISE_END:
		clip = "rise"
		pose_index = 2 if t<HANDOFF+0.23 else (3 if t<RISE_END-0.15 else 0)
	elif role==action_role and action not in CAMP_PASS and t>ARRIVAL+0.10 and t<HANDOFF+0.48:
		if action=="mage":
			clip = "attack"
			frame = mini(4,int(sin(PI*smoothstep(ARRIVAL+0.10,HANDOFF+0.48,t))*4.8))
		else:
			clip = "kneel"
			pose_index = 1 if t<2.82 else (2 if t<HANDOFF+0.12 else 3)
	var height := _height(foot,role)
	var factor := height/float(rear_heights[role] if rear and pose_index<0 else walk_heights[role])
	if pose_index>=0:
		frame = pose_index
		actor.texture = living_poses[role][pose_index]
	else:
		actor.texture = set.get_frame_texture(clip,frame)
	actor.texture_filter = VIS.filter_for(actor.texture)
	var bounds := VIS.logical_image(actor.texture).get_used_rect()
	actor.position = foot-Vector2(0,(float(bounds.end.y)-48.0)*factor)
	actor.scale = Vector2.ONE*factor
	actor.flip_h = facing.x<0
	actor.visible = present
	actor.z_index = 30+int(foot.y)
	actor.modulate = Color(0.95,0.88,0.81) if scene_id=="last_camp" else (Color(0.86,0.89,0.94) if scene_id=="ash_rest" else Color(0.87,0.84,0.81))
	shade.position = foot
	shade.scale = Vector2(height*0.55/64.0,height*0.10/20.0)
	shade.visible = present
	party_feet[role] = foot
	current_frame[role] = {"clip":clip,"frame":frame,"phase":phase,"foot":foot,"height":height}
	if present: visible_roles.append(role)

func seek(time: float) -> void:
	if not available: return
	elapsed = clampf(time,0,DURATION)
	var t := elapsed
	var after := t>=HANDOFF
	prop_changed = after and is_instance_valid(state_layer)
	world.transform = _camera(t)
	(plate.material as ShaderMaterial).set_shader_parameter("elapsed",t)
	if is_instance_valid(state_layer):
		state_layer.visible = after
		state_layer.modulate.a = 1.0
	if is_instance_valid(waiting_layer): waiting_layer.visible = not after
	if is_instance_valid(camp_layer): camp_layer.visible = not prop_changed
	for mat in boots_materials: mat.set_shader_parameter("elapsed",t)
	if is_instance_valid(boot_reactions):
		boot_reactions.visible = prop_changed
		boot_reactions.update_time(t)
	visible_roles.clear()
	for role in order: _place_hero(role,t)
	if is_instance_valid(jack): _place_dog(t)
