extends "res://scripts/travel/cinematic_v5/forge_v5.gd"
## Approved road films. Actual post-resolution parties and action keys.
## Presentation only: no gameplay writes or new combat art.
const REAR := preload("res://scripts/travel/campfire_walk.gd")
const WELL_CATALOG := preload("res://scripts/travel/batch_03_catalog.gd")
const ROAD_ROOT := "res://assets/pixel/travel/cinematic_v5/road_batch/"
const BRIDGE := "res://assets/pixel/travel/batch_02/rattling_bridge/"
const WELL := "res://assets/pixel/travel/batch_03/scene_04_whispering_well/"
const PURSE := "res://assets/pixel/travel/pilot_01/lost_purse/"
const PROFILE := "res://resources/travel/cinematic_v5/road_batch.json"
const IDS := ["rattling_bridge","whispering_well","lost_purse"]
const BRIDGE_ACTIONS := ["rush_success","rush_failure","scavenge","careful","recruit","loot_recruitment","abandon"]
const WELL_ACTIONS := ["rescue_blood","rescue_gold","gift_upgrade","pay_relic","pay_upgrade","pay_refund","leave_lost","leave"]
const PURSE_ACTIONS := ["safe","greedy","all_in","untouched"]
const ARRIVAL := 2.55
const DEPARTURE := 3.95
const INSERT_IN := 2.48
const INSERT_OUT := 4.15
const MAGE_RIM := 3.48
const MAGE_EDGE := 3.74
const MAGE_LAND := 4.16
var scene_id := ""
var profile: Dictionary
var joining := ""
var state_layer: Sprite2D
var waiting_layer: Sprite2D
var sink_layer: Sprite2D
var foreground: Sprite2D
var well_rim: Sprite2D
var insert: Node2D
var insert_base: Sprite2D
var insert_result: Sprite2D
var insert_grip: Sprite2D
var ripple: Node2D
var rear_frames: Dictionary
var walk_heights: Dictionary = {}
var side_frames: Dictionary = {}
var side_heights: Dictionary = {}
var stop_point := Vector2.ZERO
var routes: Dictionary = {}
var visible_roles: Array[String] = []
var prop_changed := false
var shot := "wide"

static func scene_actions(id: String, party: Array) -> Array[String]:
	var valid: Array[String] = []
	if id == "rattling_bridge":
		for key in BRIDGE_ACTIONS:
			if key == "recruit" and (not "ranger" in party or party.size()<2): continue
			if key in ["loot_recruitment","abandon"] and "ranger" in party: continue
			valid.append(key)
	elif id == "whispering_well":
		for key in WELL_ACTIONS:
			if not WELL_CATALOG.action_for(id,key,party).is_empty(): valid.append(key)
	elif id == "lost_purse":
		valid.assign(PURSE_ACTIONS)
	return valid

func _p(value: Array) -> Vector2:
	return Vector2(float(value[0]),float(value[1]))

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	if id not in IDS or party.is_empty() or party.size()>3 or resolved_action not in scene_actions(id,party): return false
	roles.clear()
	for role in party:
		if role not in ROLES or role in roles: return false
		roles.append(role)
	if not FileAccess.file_exists(PROFILE): return false
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PROFILE))
	if not data is Dictionary or not data.has(id): return false
	profile = data[id]
	scene_id = id
	action = resolved_action
	joining = "ranger" if id=="rattling_bridge" and action=="recruit" else ("mage" if id=="whispering_well" and action.begins_with("rescue_") else "")
	order.assign(roles)
	if not joining.is_empty():
		order.erase(joining)
		order.append(joining)
	jack_present = has_jack and "ranger" in roles
	for node in [world,insert]:
		if is_instance_valid(node): node.free()
	world = Node2D.new()
	world.name = "RoadWorld"
	add_child(world)
	insert = null
	insert_grip = null
	state_layer = null
	waiting_layer = null
	sink_layer = null
	foreground = null
	well_rim = null
	ripple = null
	jack = null
	jack_shadow = null
	walk_heights.clear()
	side_frames.clear()
	side_heights.clear()
	actors.clear()
	shadows.clear()
	tracks.clear()
	party_feet.clear()
	current_frame.clear()
	routes.clear()
	visible_roles.clear()
	stop_point = _p(profile.get("recruit_stop",profile.stop) if action=="recruit" else profile.stop)
	var path := BRIDGE+"layers/base_1280.png" if id=="rattling_bridge" else (WELL+"master/scene.webp" if id=="whispering_well" else ROAD_ROOT+"lost_purse/plate.webp")
	var base := _load_texture(path)
	if base==null or base.get_size()!=Vector2(1280,720): return false
	plate = _sprite(base,world,0,Vector2.ZERO,false)
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if id!="lost_purse":
		var material := ShaderMaterial.new()
		material.shader = LIGHT
		material.set_shader_parameter("scene_kind",2 if id=="rattling_bridge" else 1)
		plate.material = material
	shadow_texture = _make_shadow()
	if not _load_scene_layers(): return false
	var rear := REAR.new()
	if id!="lost_purse" and not rear.build(): return false
	rear_frames = REAR.frames
	for role in order:
		var side := ANIM.get_frames(role)
		if side==null or side.get_frame_count("walk")!=6 or side.get_frame_count("idle")!=4: return false
		if role=="ranger": side = _ranger_without_floor_marker(side)
		side_frames[role] = side
		side_heights[role] = _walk_height(side)
		var walk: SpriteFrames = side if id=="lost_purse" else rear_frames[role]
		walk_heights[role] = _walk_height(walk)
		actors[role] = _sprite(walk.get_frame_texture("walk",0),world,30,Vector2.ZERO)
		actors[role].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		shadows[role] = _shadow(shadow_texture,Vector2.ZERO,170.0,20)
		routes[role] = _role_route(role)
		tracks[role] = V3.gait(_road_foot.bind(role),_road_height.bind(role),DURATION)
		tracks[role].pitch = maxf(0.076,float(tracks[role].total)/(DURATION*8.5))
	if jack_present:
		jack_frames = ANIM.get_frames("jack")
		if jack_frames==null or not jack_frames.has_animation("walk"): return false
		jack_body_px = _walk_height(jack_frames)
		jack = _sprite(jack_frames.get_frame_texture("walk",0),world,30,Vector2.ZERO)
		jack.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		jack_shadow = _shadow(shadow_texture,Vector2.ZERO,60.0,20)
	available = true
	seek(0.0)
	return true

func _walk_height(set: SpriteFrames) -> float:
	var h := 1.0
	for i in set.get_frame_count("walk"):
		h = maxf(h,float(set.get_frame_texture("walk",i).get_image().get_used_rect().size.y))
	return h

func _layer(path: String, z: int) -> Sprite2D:
	var tex := _load_texture(path)
	if tex==null or tex.get_size()!=Vector2(1280,720): return null
	var sprite := _sprite(tex,world,z,Vector2.ZERO,false)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	return sprite

func _load_scene_layers() -> bool:
	match scene_id:
		"rattling_bridge":
			if action not in ["careful","abandon"]:
				state_layer = _layer(BRIDGE+"layers/"+action+"_state.png",2)
				if state_layer==null: return false
			if action in ["recruit","loot_recruitment","abandon"]:
				var seated := _load_image(BRIDGE+"layers/ranger_seated.png")
				if seated==null: return false
				seated = seated.get_region(seated.get_used_rect())
				var foot := _p(profile.recruit_foot)
				var height := _ppm(foot.y)*1.08
				waiting_layer = _sprite(ImageTexture.create_from_image(seated),world,30,foot)
				var factor := height/seated.get_height()
				waiting_layer.scale = Vector2.ONE*factor
				waiting_layer.position -= Vector2(0,height*0.5)
				waiting_layer.z_index = 30+int(foot.y)
				waiting_layer.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
				waiting_layer.modulate = Color(0.85,0.87,0.92)
		"whispering_well":
			if action!="leave":
				state_layer = _layer(WELL+"outcomes/"+action+".png",3)
				if state_layer==null: return false
			if not joining.is_empty() or action=="leave_lost":
				waiting_layer = _layer(WELL+"layers/entry.png",4)
				if waiting_layer==null: return false
			if action=="leave_lost":
				sink_layer = _layer(WELL+"layers/sink.png",4)
				if sink_layer==null: return false
			foreground = _layer(WELL+"layers/foreground.png",1500)
			well_rim = _layer(WELL+"layers/handoff_occlusion.png",1000)
			if foreground==null or well_rim==null: return false
			# Ring geometry, existing authored well aperture. The same local
			# clock as actors and outcome drives the draw callback.
			ripple = Node2D.new()
			ripple.z_index = 2
			world.add_child(ripple)
			ripple.draw.connect(_draw_ripples)
		"lost_purse":
			var before := _load_texture(PURSE+"outcomes/untouched.png")
			var after := _load_texture(PURSE+"outcomes/"+action+".png")
			if before==null or after==null or before.get_size()!=Vector2(1280,720) or after.get_size()!=Vector2(1280,720): return false
			insert = Node2D.new()
			insert.name = "PurseDetailShot"
			insert.z_index = 2000
			add_child(insert)
			insert_base = _sprite(before,insert,0,Vector2.ZERO,false)
			insert_result = _sprite(after,insert,1,Vector2.ZERO,false)
			insert_base.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			insert_result.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			if action in ["safe","all_in"]:
				# Reuse the accepted V2 grasp art, not a detached or duplicated
				# coin/purse. The clean final then lies behind the live glove.
				var grip_tex := _load_texture(PURSE+"animation/"+("safe_grip.png" if action=="safe" else "purse_lift_grip.png"))
				if grip_tex==null: return false
				insert_grip = _sprite(grip_tex,insert,2,Vector2.ZERO,false)
				insert_grip.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
				insert_grip.scale = Vector2(1280.0/1672.0,720.0/941.0)
	return true

func _ppm(y: float) -> float:
	return maxf(1.0,(y-float(profile.horizon))*float(profile.ppm_per_y))

func _road_height(foot: Vector2, role: String) -> float:
	var support := foot.y
	if scene_id=="whispering_well" and role==joining:
		support = maxf(support,float(profile.recruit_ground_y))
	return float(STATURE_M[role])*_ppm(support)

func _role_route(role: String) -> Array[Vector2]:
	var rank := order.find(role)
	var points: Array[Vector2] = []
	for p in profile.entry: points.append(_p(p))
	points.append(stop_point)
	for p in profile.exit: points.append(_p(p))
	# Longitudinal separation in ground space contracts with distance, rather
	# than spreading a trio sideways over a narrow bridge or into the well.
	var offsets := [0.0,155.0,300.0]
	var depth: float = offsets[rank]
	for i in points.size():
		var pivot: Vector2 = points[i]
		var direction_vector := (points[mini(i+1,points.size()-1)]-points[maxi(i-1,0)]).normalized()
		var distance := depth*_ppm(pivot.y)/_ppm(stop_point.y)
		points[i] = pivot-direction_vector*distance
		if scene_id!="rattling_bridge" and rank==1 and role!=joining:
			points[i].y+=34.0*_ppm(pivot.y)/_ppm(stop_point.y)
	return points

func _polyline(points: Array, u: float) -> Vector2:
	var total := 0.0
	for i in range(1,points.size()): total+=points[i-1].distance_to(points[i])
	var distance := clampf(u,0.0,1.0)*total
	for i in range(1,points.size()):
		var length: float = points[i-1].distance_to(points[i])
		if distance<=length or i==points.size()-1: return points[i-1].lerp(points[i],clampf(distance/maxf(length,0.001),0.0,1.0))
		distance-=length
	return points[-1]

func _road_foot(time: float, role: String) -> Vector2:
	var points: Array = routes[role]
	if scene_id=="rattling_bridge" and action=="careful":
		# Cautious crossing has no transaction/stop. Advance continuously
		# on the same safe deck with no reward or damage prop change.
		return _polyline(points,clampf(time/DURATION,0.0,1.0))
	if role==joining:
		var start := _p(profile.recruit_foot)
		if time<=HANDOFF: return start
		if scene_id=="whispering_well":
			# Start submerged at the painted waiting torso height. Rise to
			# the near lip, cross its top, then step down onto the lane.
			if time<MAGE_RIM:
				return start.lerp(Vector2(520,375),smoothstep(HANDOFF,MAGE_RIM,time))
			if time<MAGE_EDGE:
				return Vector2(520,375).lerp(Vector2(625,390),smoothstep(MAGE_RIM,MAGE_EDGE,time))
			if time<MAGE_LAND:
				return Vector2(625,390).lerp(Vector2(650,550),smoothstep(MAGE_EDGE,MAGE_LAND,time))
			return _polyline([Vector2(650,550),Vector2(790,575),Vector2(995,520),Vector2(1150,402)],smoothstep(MAGE_LAND,DURATION,time))
		else:
			if time<DEPARTURE: return start.lerp(points[3],smoothstep(HANDOFF,DEPARTURE,time))
		return _polyline(points.slice(3),smoothstep(DEPARTURE,DURATION,time))
	var arrival: float = ARRIVAL
	if scene_id=="rattling_bridge" and action.begins_with("rush_"): arrival=2.25
	if time<arrival:
		return _polyline(points.slice(0,4),smoothstep(0.0,arrival,time))
	if time<DEPARTURE:
		if scene_id=="rattling_bridge" and action=="rush_failure" and role==order[0]:
			# A slip on the intact deck, never a fall over the rail.
			var slip := sin(PI*smoothstep(HANDOFF-0.16,HANDOFF+0.48,time))
			return points[3]+Vector2(-13,10)*slip
		return points[3]
	if scene_id=="lost_purse":
		# The detail shot hides the small time ellipsis as the party moves
		# past the slab. The return shot excludes the obsolete baked purse.
		return _polyline(points.slice(4),smoothstep(DEPARTURE,DURATION,time))
	return _polyline(points.slice(3),smoothstep(DEPARTURE,DURATION,time))

func _road_camera(t: float) -> Transform2D:
	if scene_id=="lost_purse" and t>=INSERT_OUT:
		var z := lerpf(1.50,1.47,smoothstep(INSERT_OUT,DURATION,t))
		return Transform2D(0,Vector2.ONE*z,0,Vector2(1280*(1-z),-210*(z-1)))
	var focus := _p(profile.focus)
	var e := smoothstep(0.7,ARRIVAL,t)*(1.0-smoothstep(DEPARTURE,6.4,t))
	var zoom := 1.012+e*(0.09 if scene_id=="rattling_bridge" else 0.075)
	var camera_focus := Vector2(640,360).lerp(focus,0.7*e)
	return Transform2D(0,Vector2.ONE*zoom,0,Vector2(clampf(640-camera_focus.x*zoom,1280-1280*zoom,0),clampf(360-camera_focus.y*zoom,720-720*zoom,0)))

func _place_hero(role: String,t: float) -> void:
	var actor: Sprite2D = actors[role]
	var shadow: Sprite2D = shadows[role]
	var foot := _road_foot(t,role)
	var present := role!=joining or t>=HANDOFF
	var velocity := _road_foot(minf(DURATION,t+0.06),role)-_road_foot(maxf(0,t-0.06),role)
	var moving := velocity.length()>0.7
	var is_rear := scene_id!="lost_purse" and moving and not (role==joining and scene_id=="whispering_well" and t<MAGE_LAND)
	# The recruited mage faces the actual route when clearing the rim;
	# the side pose is used only during the initial standing transition.
	var set: SpriteFrames = rear_frames[role] if is_rear else side_frames[role]
	var phase := V3.phase(tracks[role],t,float(order.find(role))*0.53)
	var label := "walk" if moving else "idle"
	var frame := int(phase)%6 if label=="walk" else int(t*2.7)%4
	actor.texture = set.get_frame_texture(label,frame)
	var bounds := actor.texture.get_image().get_used_rect()
	var height := _road_height(foot,role)
	var factor := height/float(walk_heights[role] if is_rear else side_heights[role])
	actor.position = foot-Vector2(0,(float(bounds.end.y)-48)*factor)
	actor.scale = Vector2.ONE*factor
	actor.flip_h = not moving and not is_rear and scene_id=="whispering_well" and role!=joining
	actor.rotation = 0.0
	if scene_id=="rattling_bridge" and action=="rush_failure" and role==order[0] and t>HANDOFF-0.16 and t<HANDOFF+0.48:
		actor.rotation = -sin(PI*smoothstep(HANDOFF-0.16,HANDOFF+0.48,t))*0.05
	actor.z_index = 30+int(foot.y)
	actor.modulate = Color(0.88,0.91,1.0) if scene_id=="whispering_well" else (Color(1.0,0.79,0.65) if scene_id=="lost_purse" else Color(0.90,0.91,0.95))
	actor.visible = present
	shadow.position = foot
	shadow.scale = Vector2(height*0.55/64,height*0.10/20)
	shadow.visible = present and not (role==joining and scene_id=="whispering_well" and t<MAGE_LAND)
	party_feet[role] = foot
	current_frame[role] = {"clip":"walk" if moving else "idle","frame":frame,"phase":phase,"foot":foot,"height":height}
	if present: visible_roles.append(role)

func _draw_ripples() -> void:
	if not is_instance_valid(ripple) or action=="leave": return
	# Existing V3 ring geometry and timing, translated to the V5 handoff.
	V3.well_ripples(ripple,action,elapsed-HANDOFF+V3.action_time("whispering_well",action))

func seek(time: float) -> void:
	if not available: return
	elapsed = clampf(time,0,DURATION)
	var t := elapsed
	shot = "detail" if scene_id=="lost_purse" and t>=INSERT_IN and t<INSERT_OUT else ("departure" if scene_id=="lost_purse" and t>=INSERT_OUT else "wide")
	prop_changed = t>=HANDOFF and action not in ["careful","abandon","leave","untouched"]
	world.transform = _road_camera(t)
	if plate.material is ShaderMaterial: plate.material.set_shader_parameter("elapsed",t)
	if is_instance_valid(state_layer):
		state_layer.visible = t>=HANDOFF and action!="leave_lost"
		state_layer.modulate.a = smoothstep(HANDOFF,HANDOFF+0.18,t)
	if is_instance_valid(waiting_layer):
		waiting_layer.visible = (joining.is_empty() and action!="leave_lost") or t<HANDOFF
		waiting_layer.modulate.a = 1.0
	if is_instance_valid(sink_layer):
		sink_layer.visible = t>=HANDOFF and t<HANDOFF+0.85
		sink_layer.modulate.a = 1.0-smoothstep(HANDOFF+0.22,HANDOFF+0.85,t)
	if is_instance_valid(well_rim):
		well_rim.visible = joining=="mage" and t>=HANDOFF and t<MAGE_RIM
	if is_instance_valid(ripple): ripple.queue_redraw()
	visible_roles.clear()
	for role in order: _place_hero(role,t)
	if is_instance_valid(jack):
		var rf: Dictionary = current_frame.ranger
		var foot: Vector2 = rf.foot
		var h := _ppm(foot.y)*0.60
		# Trail along the actual route, NOT to the outside of bridge rail.
		foot += Vector2(-h*0.78,h*0.36)
		var clip: String = rf.clip
		var frame := int(rf.phase*1.3)%jack_frames.get_frame_count("walk") if clip=="walk" else 0
		jack.texture = jack_frames.get_frame_texture(clip,frame)
		var scale_factor := h/jack_body_px
		var bounds := jack.texture.get_image().get_used_rect()
		jack.scale = Vector2.ONE*scale_factor
		jack.position = foot-Vector2(0,(float(bounds.end.y)-48)*scale_factor)
		jack.z_index = 30+int(foot.y)
		jack.modulate = Color(0.90,0.89,0.91)
		jack.visible = "ranger" in visible_roles
		jack_shadow.visible = jack.visible
		jack_shadow.position = foot
		jack_shadow.scale = Vector2(h/64,h*0.20/20)
	if is_instance_valid(insert):
		insert.visible = shot=="detail"
		world.visible = not insert.visible
		var zoom := lerpf(1.025,1.075,smoothstep(INSERT_IN,INSERT_OUT,t))
		insert.transform = Transform2D(0,Vector2.ONE*zoom,0,Vector2(-100*(zoom-1),-450*(zoom-1)))
		insert_result.modulate.a = (1.0 if t>=HANDOFF else 0.0) if is_instance_valid(insert_grip) else smoothstep(HANDOFF,HANDOFF+0.16,t)
		if is_instance_valid(insert_grip):
			var u := smoothstep(HANDOFF+0.12,INSERT_OUT-0.06,t)
			var start := Vector2(330,490) if action=="safe" else Vector2(160,490)
			insert_grip.position = (start+Vector2(420*u,560*u*u))*insert_grip.scale
			insert_grip.visible = shot=="detail" and t>=HANDOFF and t<INSERT_OUT-0.06
