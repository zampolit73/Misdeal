extends RefCounted
## Presentation-only pilot. Distance is normalized by projected character
## stature, so a small distant walker does not cycle like a close-up one.
const PILOTS := ["blood_ledger", "whispering_well", "rattling_bridge"]
const STAGE := Vector2(1280, 720)
const SAMPLES := 48
const LIGHT := preload("res://shaders/travel_v3_local_motion.gdshader")


static func enabled(id: String) -> bool:
	return id in PILOTS


static func camera(id: String, time: float, duration: float) -> Transform2D:
	var u := smoothstep(0.0, 1.0, clampf(time / maxf(duration, 0.01), 0, 1))
	var zoom := lerpf(1.012, 1.027, u)
	var pan := lerpf(0.0, -4.0, u)
	if id == "rattling_bridge":
		zoom = lerpf(1.016, 1.040, u)
		pan = lerpf(0.0, -9.0, u)
	# Finite overscan, no exposed edges or independent actor/road drift.
	var margin := STAGE * (zoom - 1.0) * 0.5
	var origin := -margin + Vector2(clampf(pan, -margin.x, margin.x), 0)
	return Transform2D(0.0, Vector2.ONE * zoom, 0.0, origin)


static func base_sprite(parent: Node2D, texture: Texture2D, id: String) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = "TravelV3LivingPlate"
	sprite.centered = false
	sprite.texture = texture
	sprite.show_behind_parent = true
	var material := ShaderMaterial.new()
	material.shader = LIGHT
	material.set_shader_parameter("scene_kind", PILOTS.find(id))
	sprite.material = material
	parent.add_child(sprite)
	return sprite


static func update_base(sprite: Sprite2D, world: Transform2D, time: float) -> void:
	sprite.transform = world
	(sprite.material as ShaderMaterial).set_shader_parameter("elapsed", time)


static func gait(path: Callable, height_at: Callable, duration: float, start_time := 0.0) -> Dictionary:
	var span := maxf(duration - start_time, 0.01)
	var distances := PackedFloat32Array([0.0])
	var last: Vector2 = path.call(start_time)
	var total := 0.0
	for n in range(1, SAMPLES + 1):
		var point: Vector2 = path.call(start_time + span * float(n) / SAMPLES)
		var stature := maxf(1.0, (float(height_at.call(last)) + float(height_at.call(point))) * 0.5)
		total += point.distance_to(last) / stature
		distances.append(total)
		last = point
	# The existing six authored poses remain untouched. Match gait to distance,
	# limiting the nominal cadence rather than forcing 6.5 fps on short routes.
	var pitch := maxf(0.032, total / (span * 8.5))
	return {"start": start_time, "span": span, "distances": distances, "pitch": pitch, "total": total}


static func phase(track: Dictionary, time: float, offset: float = 0.0) -> float:
	if track.is_empty():
		return offset
	var position := clampf((time - float(track.start)) / float(track.span), 0.0, 1.0) * SAMPLES
	var left := mini(floori(position), SAMPLES - 1)
	var distances: PackedFloat32Array = track.distances
	var distance := lerpf(distances[left], distances[left + 1], position - left)
	return distance / float(track.pitch) + offset


static func action_time(id: String, action: String) -> float:
	match id:
		"blood_ledger":
			return 0.76
		"rattling_bridge":
			return 0.90 if action == "recruit" else 0.78
		"whispering_well":
			if action.begins_with("rescue"):
				return 1.12
			if action == "leave_lost":
				return 1.38
			return 0.84
	return 0.92


static func action_cue(id: String, action: String) -> String:
	match id:
		"blood_ledger":
			return "coins" if action == "gold" else "paper"
		"rattling_bridge":
			return "creak"
		"whispering_well":
			return "coins" if action.begins_with("pay_") or action == "rescue_gold" else ""
	return ""


static func support_index(gait_phase: float) -> int:
	# Two support contacts per six-frame cycle.
	return floori(gait_phase / 3.0)


static func bridge_embers(canvas: Node2D, time: float) -> void:
	for i in range(7):
		var age := fposmod(time * (0.65 + float(i % 3) * 0.08) + i * 0.137, 1.0)
		var point := Vector2(349 + sin(i * 2.9 + age * 3.4) * (4.0 + age * 11.0),
			326.0 - age * (35.0 + (i % 3) * 9.0))
		var opacity := sin(PI * age) * (0.32 + float(i % 2) * 0.11)
		canvas.draw_circle(point, 0.7 + float(i % 2) * 0.45, Color(1.0, 0.55, 0.18, opacity))


static func well_ripples(canvas: Node2D, action: String, time: float) -> void:
	var local := time - action_time("whispering_well", action)
	if action == "leave" or local < 0.0 or local > 1.55:
		return
	for i in range(2):
		var age := (local - i * 0.24) / 1.25
		if age < 0.0 or age > 1.0:
			continue
		var radius := lerpf(12.0, 103.0, age)
		var points := PackedVector2Array()
		for n in range(41):
			var angle := TAU * float(n) / 40.0
			points.append(Vector2(489, 344) + Vector2(cos(angle), sin(angle) * 0.20) * radius)
		var alpha := sin(PI * age) * 0.20
		# The dark well aperture bounds every ring; the original foreground,
		# rim and NPC/outcome overlays are still drawn above it.
		canvas.draw_polyline(points, Color(0.39, 0.52, 0.57, alpha), 1.25, true)
