extends RefCounted
## Presentation-only Travel V3. Distance is normalized by projected character
## stature, so a small distant walker does not cycle like a close-up one.
const PILOTS := ["blood_ledger", "whispering_well", "rattling_bridge"]
const LOCATIONS := [
	"blood_ledger", "whispering_well", "rattling_bridge",
	"candle_seller", "debtor_bones", "wizard_tithe", "broken_crown", "curse_forge",
	"black_altar", "chained_prisoner", "jack", "last_camp", "ash_rest", "bone_tax",
	"faceless_card", "moon_seal", "echo_crypt",
	"last_signal", "gravedigger_shop", "lost_purse", "unsent_letters",
	"banner_seamstress", "borrowed_boots", "false_weights",
]
# Local masks in original 1280x720 plate coordinates, not screen space.
# Quiet locations intentionally have no artificial flame. Existing layered
# panoramas already carry their own authored environment effects.
const LIGHT_MASKS := {
	"candle_seller": [Vector4(868, 398, 20, 50), Vector4(1000, 395, 18, 45), Vector4(1128, 397, 18, 40)],
	"debtor_bones": [Vector4(1145, 392, 16, 30)],
	"wizard_tithe": [Vector4(335, 336, 12, 25), Vector4(875, 336, 12, 25)],
	"broken_crown": [Vector4(675, 390, 9, 20), Vector4(1166, 389, 10, 20)],
	"curse_forge": [Vector4(166, 306, 40, 38)],
	"black_altar": [Vector4(500, 430, 19, 38), Vector4(1148, 430, 19, 38)],
	"chained_prisoner": [Vector4(1043, 176, 14, 20)],
	"last_camp": [Vector4(572, 449, 36, 45)],
	"bone_tax": [Vector4(1109, 416, 13, 24)],
	"faceless_card": [Vector4(1110, 281, 14, 28)],
}
const CLOTH_MASKS := {
	"jack": Vector4(197, 273, 37, 46),
	"last_camp": Vector4(281, 367, 65, 53),
	"bone_tax": Vector4(943, 345, 100, 21),
	"faceless_card": Vector4(200, 112, 54, 76),
	"moon_seal": Vector4(91, 270, 22, 73),
}
const STAGE := Vector2(1280, 720)
const SAMPLES := 48
const LIGHT := preload("res://shaders/travel_v3_local_motion.gdshader")


static func enabled(id: String) -> bool:
	return id in LOCATIONS


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
	if id not in PILOTS:
		var lights := PackedVector4Array()
		for mask in LIGHT_MASKS.get(id, []):
			lights.append(mask)
		lights.resize(3)
		material.set_shader_parameter("local_lights", lights)
		material.set_shader_parameter("local_cloth", CLOTH_MASKS.get(id, Vector4.ZERO))
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
		"candle_seller", "debtor_bones":
			return 0.74
		"wizard_tithe", "broken_crown", "curse_forge":
			return 0.76
		"black_altar":
			return 1.02 if action.begins_with("rescue") else 0.84
		"chained_prisoner":
			return 1.04 if action == "recruit" else 0.84
		"last_camp":
			return 1.06 if action.begins_with("rescue") else 0.84
		"ash_rest":
			return 1.03 if action == "recruit" else 0.84
		"last_signal":
			return 0.60 if action == "salvage" else 0.54
		"gravedigger_shop":
			return 0.72
		"lost_purse":
			return 0.57 if action == "greedy" else 0.55
		"unsent_letters":
			return 1.40 if action == "release" else 0.84
		"banner_seamstress", "false_weights":
			return 0.84
	return 0.84


static func action_cue(id: String, action: String) -> String:
	match id:
		"blood_ledger":
			return "coins" if action == "gold" else "paper"
		"rattling_bridge":
			return "creak"
		"whispering_well":
			return "coins" if action.begins_with("pay_") or action == "rescue_gold" else ""
	if action in ["passed", "leave", "untouched", "abandon", "careful", "leave_lost"] or action.is_empty():
		return ""
	match id:
		"unsent_letters", "banner_seamstress", "faceless_card":
			return "paper"
		"lost_purse", "gravedigger_shop", "candle_seller":
			return "coins"
		"wizard_tithe":
			return "coins" if action == "gold" else ""
		"debtor_bones":
			return "dice" if action.begins_with("gamble") else "bones"
		"last_signal":
			return "paper" if action == "truth" else "metal"
		"black_altar", "last_camp":
			return "coins" if action == "rescue_gold" else ""
		"chained_prisoner", "broken_crown", "curse_forge":
			return "metal"
		"false_weights":
			return "stone-door" if action == "fair" else "coins"
		"echo_crypt", "bone_tax":
			return "stone-door"
	return ""


# Tracks belong to the living overlay; no static cache across parties/outcomes.
static func actor_phase(ground: Node2D, index: int, time: float, duration: float,
		path: Callable, stature: Callable) -> float:
	if not ground.gait_tracks.has(index):
		ground.gait_tracks[index] = gait(path, stature, duration)
	var value := phase(ground.gait_tracks[index], time, index * 1.1)
	ground.gait_phases[index] = value
	return value


static func walk_height(frames: SpriteFrames) -> float:
	var height := 1.0
	for n in frames.get_frame_count("walk"):
		height = maxf(height, frames.get_frame_texture("walk", n).get_image().get_used_rect().size.y)
	return height


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
