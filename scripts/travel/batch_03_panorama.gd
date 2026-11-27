extends Node2D
## Batch 03 presentation. TravelTransition owns clock, input, and the route back.

const CATALOG := preload("res://scripts/travel/batch_03_catalog.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const REAR := preload("res://scripts/travel/campfire_walk.gd")
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const FOOTFALL := preload("res://assets/pixel/travel/batch_02/soles.json")
const OVERSCAN := 1.009
const ROAD_PAN := 1.2
const SPACING := 0.15
const WALK_FPS := 6.5
# Jack's standing silhouette on the same ground plane as an adult hero.
const JACK_STATURE := 0.34

var available := false
var planes: Dictionary = {}
var actor_metrics: Array[Dictionary] = []
var npc_visible := false
var soles: Dictionary = {}
var _scene: Dictionary
var _state: Dictionary
var _textures: Dictionary = {}
var _frames: Dictionary = {}
var _heights: Dictionary = {}
var _route := PackedVector2Array()
var _handoff: Array = []
var _joining := ""
var _handoff_time := 0.0
var _action := ""
var _time := 0.0
var _world := Transform2D.IDENTITY
var _jack: AnimatedSprite2D
var _occlusion: Sprite2D
var pilot_active := false
var pilot_lead_phase := 0.0
var pilot_tracks: Dictionary = {}
var pilot_base: Sprite2D

func build(background: String, _foreground: String, _underpaint: String, _sky: String) -> void:
	for id in CATALOG.DATA.data:
		var scene := CATALOG.scene_for(id)
		if background == CATALOG.ROOT.path_join(scene.folder).path_join(scene.master):
			_scene = scene
			break
	if _scene.is_empty():
		return
	for point in _scene.route:
		_route.append(_point(point))
	for label in ["Midground", "Foreground"]:
		var plane := Node2D.new()
		plane.name = label
		add_child(plane)
		planes[label] = plane
	available = _texture(str(_scene.master)) != null

func configure(context: Dictionary) -> void:
	_action = str(context.get("visual_action", ""))
	_state = CATALOG.action_for(str(context.get("resolved_card_id", "")),
		_action, context.get("party_roles", []))
	available = not _state.is_empty() and _route.size() == 3
	if not available:
		return
	pilot_active = str(context.get("resolved_card_id", "")) == "whispering_well"
	if pilot_active:
		pilot_base = V3.base_sprite(self, _texture(str(_scene.master)), "whispering_well")
	var party: String = _state.party
	_handoff = [] if _scene.handoff == null else _scene.handoff
	if party.begins_with("+"):
		_joining = "jack" if party == "+jack animal" else party.substr(1)
		_handoff_time = float(_handoff[1])
	var phases: Dictionary = _scene.phases
	for path in [_state.overlay, _scene.planes.foreground, _scene.planes.get("handoff_occlusion", "")] + phases.values():
		if not str(path).is_empty() and _texture(str(path)) == null:
			available = false
			return
	var rear := REAR.new()
	var facing: String = _scene.facing
	if facing == "ne" and not rear.build():
		available = false
		return
	for role in context.party_roles:
		var frames: SpriteFrames = REAR.frames[role] if facing == "ne" else ANIM.get_frames(role)
		if not _prepare_walk(role, frames, FOOTFALL.data[facing][role]):
			available = false
			return
	if bool(context.get("jack_companion", false)):
		if not _prepare_walk("jack", ANIM.get_frames("jack"), []):
			available = false
			return
		_jack = AnimatedSprite2D.new()
		_jack.name = "TravelJack"
		_jack.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		get_parent().add_child(_jack)
	if _joining == "mage" and _scene.planes.has("handoff_occlusion"):
		_occlusion = _plate(_scene.planes.handoff_occlusion, get_parent())
	_plate(_scene.planes.foreground, planes.Foreground)
	update_time(0.0, 4.0)

func _prepare_walk(role: String, frames: SpriteFrames, authored_soles: Array) -> bool:
	if frames == null or not frames.has_animation("walk"):
		return false
	_frames[role] = frames
	var feet: Array = []
	var height := 1
	for frame in range(frames.get_frame_count("walk")):
		var bounds := frames.get_frame_texture("walk", frame).get_image().get_used_rect()
		feet.append(bounds.end.y - 1)
		height = maxi(height, bounds.size.y)
	_heights[role] = height
	soles[role] = feet if authored_soles.is_empty() else authored_soles
	return true

func _point(pair: Array) -> Vector2:
	return Vector2(float(pair[0]), float(pair[1]))

func _plate(path: String, parent: Node) -> Sprite2D:
	var layer := Sprite2D.new()
	layer.centered = false
	layer.texture = _texture(path)
	parent.add_child(layer)
	return layer

func _texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if not _textures.has(path):
		var full := CATALOG.ROOT.path_join(_scene.folder).path_join(path)
		_textures[path] = load(full) as Texture2D if ResourceLoader.exists(full, "Texture2D") else null
	return _textures[path]

func update_time(time: float, duration: float) -> void:
	_time = time
	_world = V3.camera("whispering_well", time, duration) if pilot_active else Transform2D(0.0, Vector2.ONE * OVERSCAN, 0.0, Vector2(-3.4 - time * ROAD_PAN, -3.0))
	if pilot_active:
		V3.update_base(pilot_base, _world, time)
		npc_visible = (_joining == "mage" and time < _handoff_time) or (_action == "leave_lost" and time < 2.45)
	planes.Foreground.transform = _world
	if is_instance_valid(_occlusion):
		_occlusion.transform = _world
	queue_redraw()

func _draw() -> void:
	if not available or _state.is_empty():
		return
	draw_set_transform_matrix(_world)
	if pilot_active:
		_draw_pilot_well()
		return
	_draw_plate(_scene.master)
	npc_visible = false
	var phases: Dictionary = _scene.phases
	var party: String = _state.party
	if _action == "leave_lost":
		npc_visible = _time < 2.45
		if _time < 1.38:
			_draw_plate(_state.overlay)
		elif npc_visible:
			_draw_plate(phases.sink, 1.0 - smoothstep(1.72, 2.45, _time))
		return
	if _joining == "jack" and _time >= 0.63 and _time < _handoff_time:
		npc_visible = true
		_draw_plate(phases.treatment)
		return
	var waiting: bool = party.ends_with(" lost") or (not _handoff.is_empty() and _handoff[0] == "jack")
	var phase_switch: float = _handoff_time if not _joining.is_empty() else 0.84
	var entry_for_all: bool = not phases.is_empty() and _handoff.is_empty()
	if (_joining != "" or waiting or entry_for_all) and _time < phase_switch and phases.has("entry"):
		npc_visible = not _handoff.is_empty()
		_draw_plate(phases.entry)
	else:
		npc_visible = waiting and _joining.is_empty()
		_draw_plate(_state.overlay)


func _draw_pilot_well() -> void:
	# The existing frozen outcome plates remain the authority. Add local
	# ripples before NPC/outcome overlays, never a new reward or actor.
	V3.well_ripples(self, _action, _time)
	var phases: Dictionary = _scene.phases
	if _action == "leave_lost":
		var sink_blend := smoothstep(1.38, 1.68, _time)
		_draw_plate(_state.overlay, 1.0 - sink_blend)
		_draw_plate(phases.sink, sink_blend * (1.0 - smoothstep(1.72, 2.45, _time)))
	elif _joining == "mage":
		# The painted waiting actor must be gone before the live sprite appears.
		if _time < _handoff_time:
			_draw_plate(phases.entry, 1.0 - smoothstep(_handoff_time - 0.20, _handoff_time, _time))
		else:
			_draw_plate(_state.overlay, smoothstep(_handoff_time, _handoff_time + 0.30, _time))
	else:
		_draw_plate(_state.overlay, smoothstep(0.53, 1.03, _time))


func _draw_plate(path: String, opacity := 1.0) -> void:
	if not path.is_empty():
		draw_texture(_texture(path), Vector2.ZERO, Color(1, 1, 1, opacity))

func _road(progress: float) -> Vector2:
	return _route[0].lerp(_route[1], progress).lerp(_route[1].lerp(_route[2], progress), progress)

func _approach(time: float, duration: float, end: Vector2) -> Vector2:
	var u := clampf((time - _handoff_time) / (duration - _handoff_time), 0.0, 1.0)
	if pilot_active:
		u = smoothstep(0.0, 1.0, u)
	var a := _point(_handoff[3])
	var b := _point(_handoff[4])
	return a.lerp(b, u).lerp(b.lerp(end, u), u)


func _pilot_route_foot(time: float, duration: float, rank: int, walking: int) -> Vector2:
	var leading := 0.025 + maxf(walking - 1, 0) * SPACING
	var progress := lerpf(leading, 0.97, clampf(time / duration, 0.0, 1.0))
	return _road(clampf(progress - rank * SPACING, 0.0, 1.0)) + Vector2(0, rank * 6)


func _pilot_height(foot: Vector2) -> float:
	return float(_scene.height) * _perspective(foot.y)


func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, _layout: Resource) -> void:
	actor_metrics.clear()
	ground.contact_scales.resize(actors.size())
	if pilot_active:
		ground.gait_phases.resize(actors.size())
	var lead_found := false
	var ranger_phase := 0.0
	var walking := roles.size() - (1 if _joining in roles else 0)
	var leading := 0.025 + maxf(walking - 1, 0) * SPACING
	var progress := lerpf(leading, 0.97, time / duration)
	var ranger_foot := Vector2.ZERO
	var rank := 0
	var order: Array[Node2D] = []
	var submerged: AnimatedSprite2D
	if is_instance_valid(_occlusion):
		_occlusion.visible = false
	for i in range(actors.size()):
		var role := roles[i]
		var actor := actors[i]
		var foot: Vector2
		var phase := time * WALK_FPS + rank * 1.1
		var elevated := 0.0
		actor.visible = role != _joining or time >= _handoff_time
		if role == _joining:
			var destination := _road(0.97 - walking * SPACING) + Vector2(0, walking * 6)
			if _scene.has("handoff_exit"):
				destination = _point(_scene.handoff_exit)
			foot = _approach(time, duration, destination)
			var floor_y := float(_scene.get("handoff_ground_y", foot.y))
			elevated = lerpf(maxf(floor_y - foot.y, 0.0), 0.0, smoothstep(_handoff_time, 2.45, time))
			phase = maxf(0.0, time - _handoff_time) * WALK_FPS
			if pilot_active:
				if not pilot_tracks.has(role):
					pilot_tracks[role] = V3.gait(_approach.bind(duration, destination), _pilot_height, duration, _handoff_time)
				phase = V3.phase(pilot_tracks[role], time)
			if is_instance_valid(_occlusion) and actor.visible and foot.x < 681.0 and foot.y < 518.0:
				submerged = actor
				_occlusion.visible = true
		else:
			foot = _road(clampf(progress - rank * SPACING, 0.0, 1.0)) + Vector2(0, rank * 6)
			if pilot_active:
				if not pilot_tracks.has(role):
					pilot_tracks[role] = V3.gait(_pilot_route_foot.bind(duration, rank, walking), _pilot_height, duration)
				phase = V3.phase(pilot_tracks[role], time, float(rank) * 1.1)
				if not lead_found:
					pilot_lead_phase = phase
					lead_found = true
			rank += 1
		if pilot_active:
			ground.gait_phases[i] = phase
		if role == "ranger":
			ranger_foot = foot
			ranger_phase = phase
		ground.contact_scales[i] = 0.0
		if actor.visible:
			var factor := _stage_actor(actor, role, foot, phase, elevated)
			if submerged != actor:
				ground.contact_scales[i] = factor * 0.62
		contacts[i] = _world * foot
		order.append(actor)
	if is_instance_valid(_jack):
		var trailing := ranger_foot + Vector2(-112, 12) * _perspective(ranger_foot.y)
		var phase := ranger_phase * 1.30 if pilot_active else time * WALK_FPS
		_jack.visible = _joining != "jack" or time >= _handoff_time
		if _jack.visible:
			if _joining == "jack":
				trailing = _approach(time, duration, trailing)
				phase = (time - _handoff_time) * WALK_FPS
			_stage_actor(_jack, "jack", trailing, phase)
		order.append(_jack)
	var parent := actors[0].get_parent()
	if is_instance_valid(_jack) and _jack.get_index() < ground.get_index():
		parent.move_child(_jack, ground.get_index())
	if is_instance_valid(_occlusion) and _occlusion.get_index() < ground.get_index():
		parent.move_child(_occlusion, ground.get_index())
	order.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		return float(a.get_meta("sole_y", -1.0)) < float(b.get_meta("sole_y", -1.0)))
	if submerged != null:
		order.erase(submerged)
		order.push_front(_occlusion)
		order.push_front(submerged)
	# All walkers, including Jack, follow contact FX and precede foreground.
	for i in range(order.size()):
		parent.move_child(order[i], ground.get_index() + 1 + i)

func _perspective(ground_y: float) -> float:
	var horizon := float(_scene.horizon)
	return clampf((ground_y - horizon) / (_route[0].y - horizon), 0.30, 1.17)

func _stage_actor(actor: AnimatedSprite2D, role: String, foot: Vector2, phase: float, elevation := 0.0) -> float:
	var frames: SpriteFrames = _frames[role]
	var frame := int(phase) % frames.get_frame_count("walk")
	var depth := _perspective(foot.y + elevation)
	var height := float(_scene.height) * depth * (JACK_STATURE if role == "jack" else 1.0)
	var factor := height / float(_heights[role])
	actor.sprite_frames = frames
	actor.animation = "walk"
	actor.frame = frame
	actor.position = _world * (foot - Vector2(0, (float(soles[role][frame]) - 48.0) * factor))
	actor.scale = Vector2.ONE * factor * _world.x.length()
	actor.modulate = Color(0.88, 0.88, 0.91).lerp(Color(0.56, 0.59, 0.64), clampf((1.0 - depth) * 0.42, 0.0, 0.35))
	var contact := _world * foot
	actor.set_meta("sole_y", contact.y)
	actor_metrics.append({"role": role, "foot": contact, "height": height})
	return factor
