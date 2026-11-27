extends RefCounted
## Ground-plane calibration only. One route/stature per location, independent
## of reward choice. The source plates and outcome staging manifests stay intact.
const DATA := preload("res://resources/travel/staging_v4.json")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const HAZE := preload("res://shaders/dressing_station_walk.gdshader")

static func profile(id: String) -> Dictionary:
	return DATA.data.get(id, {})

static func point(pair: Array) -> Vector2:
	return Vector2(float(pair[0]), float(pair[1]))

static func route(p: Dictionary) -> PackedVector2Array:
	var result := PackedVector2Array()
	for pair in p.route:
		result.append(point(pair))
	return result

static func depth(p: Dictionary, foot: Vector2) -> float:
	return clampf((foot.y - float(p.horizon)) / (float(p.route[0][1]) - float(p.horizon)), 0.28, 1.18)

static func height(p: Dictionary, foot: Vector2) -> float:
	return float(p.height) * depth(p, foot)

static func foot_at(time: float, p: Dictionary, duration: float, rank: int, count: int) -> Vector2:
	var spacing := float(p.get("spacing", 0.18))
	var start := 0.025 + maxf(count - 1, 0) * spacing
	var u := lerpf(start, 0.97, clampf(time / duration, 0.0, 1.0)) - rank * spacing
	var a := point(p.route[0])
	var b := point(p.route[1])
	var c := point(p.route[2])
	var center := a.lerp(b, u).lerp(b.lerp(c, u), u)
	var lanes: Array = p.get("lanes", [0, 0, 0])
	var lane := float(lanes[rank]) if count > 1 else 0.0
	return center + Vector2(lane * depth(p, center), rank * 7.0)

static func waypoint_path(points: Array, u: float) -> Vector2:
	var distance := 0.0
	for i in range(1, points.size()):
		distance += point(points[i - 1]).distance_to(point(points[i]))
	var target := distance * clampf(u, 0.0, 1.0)
	for i in range(1, points.size()):
		var a := point(points[i - 1])
		var b := point(points[i])
		var span := a.distance_to(b)
		if target <= span:
			return a.lerp(b, target / maxf(span, 0.001))
		target -= span
	return point(points.back())

# Shared route stage for the older parallax layouts. Only road-relative feet,
# pose and projected scale are changed; their actual scenery/props keep moving.
static func stage_legacy(id: String, actors: Array[AnimatedSprite2D], roles: Array[String],
		contacts: Array[Vector2], ground: Node2D, time: float, duration: float,
		road_offset: Vector2, layout: Resource, frames: Dictionary, soles: Dictionary) -> void:
	var p := profile(id)
	ground.contact_scales.resize(actors.size())
	ground.gait_phases.resize(actors.size())
	var direction := (point(p.route[0]) - point(p.route[2])).normalized()
	ground.dust_direction = direction
	for i in actors.size():
		var actor := actors[i]
		var role := roles[i]
		actor.sprite_frames = frames[role]
		actor.animation = "walk"
		var path := foot_at.bind(p, duration, i, actors.size())
		var stature := func(f: Vector2) -> float: return height(p, f)
		var phase := V3.actor_phase(ground, i, time, duration, path, stature)
		var foot: Vector2 = path.call(time)
		if not actor.has_meta("staging_height"):
			actor.set_meta("staging_height", V3.walk_height(actor.sprite_frames))
		var factor := height(p, foot) / float(actor.get_meta("staging_height"))
		actor.frame = int(phase) % actor.sprite_frames.get_frame_count("walk")
		actor.scale = Vector2.ONE * factor
		actor.flip_h = false
		var haze := clampf((1.0 - depth(p, foot)) * 0.36, 0.0, 0.28)
		actor.modulate = layout.party_tint.lerp(Color(0.56, 0.59, 0.64), haze)
		contacts[i] = foot + road_offset
		actor.position = contacts[i] - Vector2(0, (float(soles[role][actor.frame]) - 48.0) * factor)
		ground.contact_scales[i] = factor * 0.60
	var order: Array[int] = []
	var first := actors[0].get_index()
	for i in actors.size():
		order.append(i)
		first = mini(first, actors[i].get_index())
	order.sort_custom(func(a: int, b: int) -> bool: return contacts[a].y < contacts[b].y)
	for i in order.size():
		actors[order[i]].get_parent().move_child(actors[order[i]], first + i)
