extends "res://scripts/travel/cinematic_v5/forge_v5.gd"
## Isolated V5 ritual/rescue/companion films. No gameplay, saves or live routing.
## Scene-owned world paths and exact existing painted outcome states.
const CATALOG := preload("res://scripts/travel/batch_03_catalog.gd")
const REAR := preload("res://scripts/travel/campfire_walk.gd")
const PROFILE := "res://resources/travel/cinematic_v5/rescue_batch.json"
const IDS := ["black_altar", "chained_prisoner", "jack"]
const ARRIVAL := 2.45
const DEPARTURE := 4.02
const RISE_END := 3.86
const ALTAR_LAND := 4.55
const DOG_JOIN := 5.10
var scene_id := ""
var profile: Dictionary
var scene_data: Dictionary
var joining := ""
var action_role := ""
var waiting_layer: Sprite2D
var state_layer: Sprite2D
var treatment_layer: Sprite2D
var foreground: Sprite2D
var side_frames: Dictionary = {}
var original_frames: Dictionary = {}
var rear_frames: Dictionary
var walk_heights: Dictionary = {}
var rear_heights: Dictionary = {}
var routes: Dictionary = {}
var visible_roles: Array[String] = []
var prop_changed := false
var dog_foot := Vector2.ZERO
var dog_height := 0.0
var dog_clip := "idle"
var dog_track: Dictionary = {}

static func scene_actions(id: String, party: Array) -> Array[String]:
	var result: Array[String] = []
	if id not in IDS: return result
	for key in CATALOG.scene_for(id).get("states", {}):
		if not CATALOG.action_for(id, str(key), party).is_empty(): result.append(str(key))
	return result

func _p(v: Array) -> Vector2:
	return Vector2(float(v[0]), float(v[1]))

func _path(points: Array, u: float) -> Vector2:
	var distance := 0.0
	for i in range(1, points.size()): distance += points[i-1].distance_to(points[i])
	var remaining := clampf(u, 0.0, 1.0) * distance
	for i in range(1, points.size()):
		var length: float = points[i-1].distance_to(points[i])
		if remaining <= length or i == points.size()-1:
			return points[i-1].lerp(points[i], clampf(remaining / maxf(length, 0.001), 0.0, 1.0))
		remaining -= length
	return points[-1]

func _points(values: Array) -> Array[Vector2]:
	var result: Array[Vector2] = []
	for value in values: result.append(_p(value))
	return result

func _layer(path: String, z: int) -> Sprite2D:
	var tex := _load_texture(CATALOG.ROOT.path_join(scene_data.folder).path_join(path))
	if tex == null or tex.get_size() != Vector2(1280,720): return null
	var sprite := _sprite(tex, world, z, Vector2.ZERO, false)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	return sprite

func _walk_height(set: SpriteFrames) -> float:
	var h := 1.0
	for i in set.get_frame_count("walk"):
		h = maxf(h, float(set.get_frame_texture("walk", i).get_image().get_used_rect().size.y))
	return h

func configure_scene(id: String, party: Array, resolved_action: String, has_jack := false) -> bool:
	available = false
	var state := CATALOG.action_for(id, resolved_action, party)
	if id not in IDS or state.is_empty() or resolved_action not in scene_actions(id,party): return false
	if not FileAccess.file_exists(PROFILE): return false
	var json: Variant = JSON.parse_string(FileAccess.get_file_as_string(PROFILE))
	if not json is Dictionary or not json.has(id): return false
	profile = json[id]
	scene_data = CATALOG.scene_for(id)
	scene_id = id
	action = resolved_action
	roles.assign(party)
	order.assign(roles)
	joining = str(state.party).substr(1) if str(state.party).begins_with("+") and id != "jack" else ""
	action_role = "ranger" if id == "jack" else (action if action in roles else "")
	if not action_role.is_empty():
		order.erase(action_role)
		order.push_front(action_role)
	if not joining.is_empty():
		order.erase(joining)
		order.append(joining)
	if action_role.is_empty() and action not in ["leave","passed","abandon"]:
		action_role = order[0]
	# The Jack card's committed outcome is authoritative, never the preview toggle.
	jack_present = action == "recruited" if id == "jack" else has_jack and "ranger" in roles
	if is_instance_valid(world): world.free()
	world = Node2D.new()
	world.name = "RescueWorld"
	add_child(world)
	waiting_layer = null
	state_layer = null
	treatment_layer = null
	jack = null
	jack_shadow = null
	for dict in [actors, shadows, tracks, party_feet, current_frame, side_frames, original_frames, walk_heights, rear_heights, routes]:
		dict.clear()
	visible_roles.clear()
	dog_track.clear()
	var texture := _load_texture(CATALOG.ROOT.path_join(scene_data.folder).path_join(scene_data.master))
	if texture == null or texture.get_size() != Vector2(1280,720): return false
	plate = V3.base_sprite(world, texture, id)
	plate.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	# The outcome layers are registered to the exact approved plate. Only the
	# three action-dependent layers can replace the current state.
	if not str(state.overlay).is_empty():
		state_layer = _layer(str(state.overlay), 2)
		if state_layer == null: return false
	if not joining.is_empty() or str(state.party).ends_with(" lost") or id == "jack":
		waiting_layer = _layer(str(scene_data.phases.entry), 3)
		if waiting_layer == null: return false
	if id == "jack" and action == "recruited":
		treatment_layer = _layer(str(scene_data.phases.treatment), 4)
		if treatment_layer == null: return false
	foreground = _layer(str(scene_data.planes.foreground), 1500)
	if foreground == null: return false
	shadow_texture = _make_shadow()
	if id in IDS:
		var rear := REAR.new()
		if not rear.build(): return false
		rear_frames = REAR.frames
	for role in order:
		var source := ANIM.get_frames(role)
		if source == null or source.get_frame_count("walk") != 6 or source.get_frame_count("death") != 6: return false
		original_frames[role] = source
		var side := _ranger_without_floor_marker(source) if role == "ranger" else source
		side_frames[role] = side
		walk_heights[role] = _walk_height(side)
		rear_heights[role] = _walk_height(rear_frames[role])
		actors[role] = _sprite(side.get_frame_texture("idle", 0), world, 30, Vector2.ZERO)
		actors[role].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		shadows[role] = _shadow(shadow_texture, Vector2.ZERO, 170.0, 20)
		routes[role] = _route(role)
		tracks[role] = V3.gait(_hero_foot.bind(role), _height.bind(role), DURATION)
		tracks[role].pitch = maxf(0.068, float(tracks[role].total)/(DURATION*8.5))
	if jack_present:
		jack_frames = ANIM.get_frames("jack")
		if jack_frames == null or jack_frames.get_frame_count("death") != 6: return false
		jack_body_px = _walk_height(jack_frames)
		jack = _sprite(jack_frames.get_frame_texture("idle",0), world, 30, Vector2.ZERO)
		jack.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		jack_shadow = _shadow(shadow_texture, Vector2.ZERO, 60.0, 20)
		dog_track = V3.gait(_dog_foot, _dog_height, DURATION)
		dog_track.pitch = maxf(0.06, float(dog_track.total)/(DURATION*9.0))
	available = true
	seek(0.0)
	return true

func _ppm(y: float) -> float:
	return maxf(1.0, (y - float(profile.horizon)) * float(profile.ppm_per_y))

func _height(foot: Vector2, role: String) -> float:
	var support := foot.y
	# The tabletop/steps elevate the sole without moving the figure deeper.
	if scene_id == "black_altar" and (role == joining or role == order[0]):
		support = maxf(support, float(profile.elevated_support))
	return _ppm(support) * float(STATURE_M[role])

func _route(role: String) -> Dictionary:
	var rank := order.find(role)
	var wait := _p(profile.wait[rank])
	var approach := _points(profile.entry)
	# Trailing heroes stay on the open lane instead of climbing into props.
	if rank == 0:
		approach.append_array(_points(profile.approach))
	else:
		var offset := Vector2(180.0*rank, 14.0*rank)
		for i in approach.size(): approach[i] -= Vector2(offset.x, -offset.y)
		approach.append(wait)
	if approach[-1] != wait: approach.append(wait)
	var exit: Array[Vector2] = [wait]
	if scene_id == "jack":
		var road := _points(profile.exit)
		var tail := order.size()-1-rank
		if rank == 0: exit.append_array(road.slice(0,road.size()-tail))
		else: exit.append_array(road.slice(rank+1,road.size()-tail))
	elif scene_id == "black_altar":
		if rank == 0: exit.append_array(_points(profile.exit))
		elif rank == 1: exit.append_array([Vector2(450,607),Vector2(315,553),Vector2(218,492)])
		else: exit.append_array([Vector2(285,575),Vector2(220,505),Vector2(186,445)])
	else:
		if rank == 0: exit.append_array(_points(profile.exit))
		elif rank == 1: exit.append_array([Vector2(430,617),Vector2(285,585),Vector2(170,535),Vector2(100,500)])
		else: exit.append_array([Vector2(285,585),Vector2(170,535),Vector2(100,500),Vector2(60,474)])
	return {"in":approach, "wait":wait, "out":exit}

func _hero_foot(time: float, role: String) -> Vector2:
	if role == joining:
		var path := _points(profile.join)
		if time <= RISE_END: return path[0]
		if scene_id == "black_altar":
			if time < ALTAR_LAND:
				# Step across the front edge, lower onto the dais, then descend.
				return _path(path.slice(0,5), smoothstep(RISE_END, ALTAR_LAND, time))
			return _path(path.slice(4), smoothstep(ALTAR_LAND, DURATION, time))
		return _path(path, smoothstep(RISE_END, DURATION, time))
	var route: Dictionary = routes[role]
	if time < ARRIVAL:
		return _path(route["in"], smoothstep(0.0, ARRIVAL, time))
	if time < DEPARTURE: return route.wait
	return _path(route.out, smoothstep(DEPARTURE, DURATION, time))

func _dog_height(foot: Vector2) -> float:
	return _ppm(foot.y) * 0.67

func _dog_foot(time: float) -> Vector2:
	var ranger_foot := _hero_foot(time, "ranger")
	var h := _dog_height(ranger_foot)
	var follow := ranger_foot + Vector2(-h*0.56, h*0.90)
	if scene_id == "black_altar": follow.y = maxf(follow.y, 565.0)
	if scene_id == "jack":
		var delayed := _hero_foot(maxf(0.0,time-0.24), "ranger")
		var dh := _dog_height(delayed)
		follow = delayed + Vector2(-dh*0.18,dh*0.73)
		var path := _points(profile.join)
		if time <= RISE_END: return path[0]
		if time < DOG_JOIN:
			# Join the Ranger's actual route, not an invented hero-slot.
			var target := _hero_foot(DOG_JOIN-0.24, "ranger")
			var th := _dog_height(target)
			target += Vector2(-th*0.18, th*0.73)
			return _path([path[0],path[1],path[2],path[3],target], smoothstep(RISE_END,DOG_JOIN,time))
	return follow

func _camera(t: float) -> Transform2D:
	var e := smoothstep(0.65,ARRIVAL,t)*(1.0-smoothstep(DEPARTURE,6.35,t))
	var zoom := 1.012 + e*(0.16 if scene_id == "jack" else 0.12)
	var focus := Vector2(640,360).lerp(_p(profile.focus), 0.82*e)
	return Transform2D(0, Vector2.ONE*zoom, 0, Vector2(
		clampf(640-focus.x*zoom,1280-1280*zoom,0), clampf(360-focus.y*zoom,720-720*zoom,0)))

func _place_hero(role: String, t: float) -> void:
	var actor: Sprite2D = actors[role]
	var shade: Sprite2D = shadows[role]
	var foot := _hero_foot(t,role)
	var velocity := _hero_foot(minf(DURATION,t+0.055),role) - _hero_foot(maxf(0,t-0.055),role)
	var moving := velocity.length()>0.7
	var present := role != joining or t >= HANDOFF
	var phase := V3.phase(tracks[role], t, float(order.find(role))*0.53)
	var facing := velocity
	if not moving and t>DEPARTURE:
		facing = foot - _hero_foot(maxf(0,t-0.24),role)
	var rear := facing.y < -0.25 and ((scene_id == "jack" and foot.x > 890) or (scene_id != "jack" and t>DEPARTURE and foot.x < 330 and facing.x < 0))
	var set: SpriteFrames = rear_frames[role] if rear else side_frames[role]
	var clip := "walk" if moving else "idle"
	var frame := int(phase)%6 if moving else int(t*2.4)%4
	# Authored poses, used only as cinematic gestures (no combat events).
	if role == joining and t >= HANDOFF and t < RISE_END:
		set = original_frames[role]
		clip = "death"
		var first := 5 if scene_id == "black_altar" else 3
		frame = clampi(first-int(smoothstep(HANDOFF,RISE_END,t)*(first+1)),0,first)
	elif role == joining and scene_id == "black_altar" and t >= RISE_END and t < ALTAR_LAND:
		set = original_frames[role]
		clip = "walk" if t < 4.11 else "death"
		frame = int(phase)%6 if clip == "walk" else 2
	elif role == action_role and t > ARRIVAL+0.11 and t < HANDOFF+0.45 and action not in ["passed","leave","abandon"]:
		set = original_frames[role]
		var u := sin(PI*smoothstep(ARRIVAL+0.11,HANDOFF+0.45,t))
		# Mage's raised staff is an actual pose. Knight/Ranger kneel briefly;
		# no attack or death signals run, no extra weapon/grip is invented.
		clip = "attack" if role == "mage" else "death"
		frame = mini(4,int(u*4.8)) if clip == "attack" else mini(2,int(u*3.0))
	var height := _height(foot, role)
	var factor := height / float(rear_heights[role] if rear else walk_heights[role])
	actor.texture = set.get_frame_texture("walk", 0) if rear and clip == "idle" else set.get_frame_texture(clip, frame)
	var bounds := actor.texture.get_image().get_used_rect()
	actor.position = foot - Vector2(0,(float(bounds.end.y)-48.0)*factor)
	actor.scale = Vector2.ONE*factor
	actor.flip_h = facing.x < -0.5
	actor.visible = present
	actor.z_index = 30+int(foot.y)
	actor.modulate = Color(0.88,0.82,0.78) if scene_id == "black_altar" else (Color(0.94,0.86,0.78) if scene_id == "chained_prisoner" else Color(0.94,0.92,0.89))
	shade.position = foot
	shade.scale = Vector2(height*0.55/64.0,height*0.10/20.0)
	shade.visible = present and not (role == joining and scene_id == "black_altar" and t < ALTAR_LAND)
	party_feet[role] = foot
	current_frame[role] = {"clip":clip,"frame":frame,"phase":phase,"foot":foot,"height":height}
	if present: visible_roles.append(role)

func _place_dog(t: float) -> void:
	dog_foot = _dog_foot(t)
	dog_height = _dog_height(dog_foot)
	var velocity := _dog_foot(minf(DURATION,t+0.055)) - _dog_foot(maxf(0,t-0.055))
	var moving := velocity.length()>0.7
	dog_clip = "walk" if moving else "idle"
	var index := int(V3.phase(dog_track,t))%6 if moving else int(t*2.4)%4
	if scene_id == "jack" and t >= HANDOFF and t < RISE_END:
		dog_clip = "death"
		index = clampi(5-int(smoothstep(HANDOFF,RISE_END,t)*6),0,5)
	jack.texture = jack_frames.get_frame_texture(dog_clip,index)
	var factor := dog_height/jack_body_px
	var bounds := jack.texture.get_image().get_used_rect()
	jack.scale = Vector2.ONE*factor
	jack.position = dog_foot-Vector2(0,(float(bounds.end.y)-48.0)*factor)
	jack.z_index = 30+int(dog_foot.y)
	jack.flip_h = velocity.x < -0.5
	jack.modulate = Color(0.95,0.90,0.85)
	jack.visible = ("ranger" in visible_roles) and (scene_id != "jack" or t >= HANDOFF)
	jack_shadow.visible = jack.visible
	jack_shadow.position = dog_foot
	jack_shadow.scale = Vector2(dog_height/64.0,dog_height*0.19/20.0)

func seek(time: float) -> void:
	if not available: return
	elapsed = clampf(time,0,DURATION)
	var t := elapsed
	var after := t>=HANDOFF
	prop_changed = after and is_instance_valid(state_layer) and action not in ["leave","passed"]
	world.transform = _camera(t)
	(plate.material as ShaderMaterial).set_shader_parameter("elapsed",t)
	# Never show a painted recruit and the matching live one together.
	if is_instance_valid(state_layer):
		state_layer.visible = after
		# The cell opening is a clean cut, not transparent bars on the freed knight.
		state_layer.modulate.a = 1.0 if scene_id == "chained_prisoner" or is_instance_valid(waiting_layer) else smoothstep(HANDOFF,HANDOFF+0.18,t)
	if is_instance_valid(waiting_layer):
		waiting_layer.visible = not after
		if is_instance_valid(treatment_layer):
			waiting_layer.visible = t < ARRIVAL
			treatment_layer.visible = t >= ARRIVAL and not after
	visible_roles.clear()
	for role in order: _place_hero(role,t)
	if is_instance_valid(jack): _place_dog(t)
