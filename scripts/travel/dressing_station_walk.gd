extends RefCounted
## Scene03-only rear walk and pinhole perspective on the marked road.
## No RunState/save writes; the V2 owner still supplies clock, pause and finish.
const DIR := "res://assets/pixel/travel/last_dressing_station/rear_walk/"
const VANISHING := Vector2(850,360)
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const HAZE := preload("res://shaders/dressing_station_walk.gdshader")
static var frames: Dictionary = {}
static var soles: Dictionary = {}

func build() -> bool:
	if not FileAccess.file_exists(DIR+"soles.json"): return false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR+"soles.json"))
	if not parsed is Dictionary: return false
	for role in ["knight","ranger","mage"]:
		if not parsed.get(role) is Array or parsed[role].size()!=6: return false
		if frames.has(role): continue
		if not FileAccess.file_exists(DIR+role+".png"): return false
		var image := Image.new()
		if image.load_png_from_buffer(FileAccess.get_file_as_bytes(DIR+role+".png"))!=OK or image.get_size()!=Vector2i(576,96): return false
		var texture := ImageTexture.create_from_image(image)
		var animation := SpriteFrames.new()
		animation.remove_animation("default")
		animation.add_animation("walk")
		animation.set_animation_speed("walk",6.5)
		animation.set_animation_loop("walk",true)
		for cell in range(6):
			var atlas := AtlasTexture.new()
			atlas.atlas = texture
			atlas.region = Rect2(cell*96,0,96,96)
			animation.add_frame("walk",atlas)
		frames[role]=VIS.rear_frames(role,"nw",animation)
	soles=parsed
	return true

func _gait_point(time: float, duration: float, index: int, count: int, origin: Vector2) -> Vector2:
	var depth := 1.0 + time / duration * 1.12 + (count - 1 - index) * 0.32
	if count == 1:
		depth += 0.30
	var lane := 0.0 if index == 0 else (14.0 if index % 2 == 1 else -14.0)
	return VANISHING + (origin - VANISHING + Vector2(0.4, -0.9) * lane) / depth


func stage(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, road_offset: Vector2, layout: Resource) -> void:
	ground.contact_scales.resize(actors.size())
	ground.gait_phases.resize(actors.size())
	ground.dust_direction = Vector2(0.92,0.40)
	for i in range(actors.size()):
		var actor := actors[i]
		var role := roles[i]
		if actor.sprite_frames!=frames[role]:
			actor.sprite_frames=frames[role]
			actor.texture_filter = VIS.frame_filter(actor.sprite_frames)
			actor.animation="walk"
			actor.modulate=Color.WHITE
			var material := ShaderMaterial.new()
			material.shader=HAZE
			actor.material=material
		# Constant world-space speed and intervals, projected onto this road.
		# Increasing depth reduces both screen displacement and apparent stature.
		var depth := 1.0+time/duration*1.12+(actors.size()-1-i)*0.32
		if actors.size()==1: depth+=0.30
		var factor := 1.0/depth
		var lane := 0.0 if i==0 else (14.0 if i%2==1 else -14.0)
		var foot: Vector2 = VANISHING+(layout.party_origin-VANISHING)*factor+Vector2(0.4,-0.9)*lane*factor+road_offset
		var path := _gait_point.bind(duration, i, actors.size(), layout.party_origin)
		var height := V3.walk_height(frames[role]) * float(layout.party_scale) if not ground.gait_tracks.has(i) else 1.0
		var stature := func(p: Vector2) -> float: return height * (p.y - VANISHING.y) / (layout.party_origin.y - VANISHING.y - lane * 0.9)
		var phase := V3.actor_phase(ground, i, time, duration, path, stature)
		actor.frame=int(phase)%6
		actor.scale=Vector2.ONE*float(layout.party_scale)*factor
		actor.flip_h=false
		actor.position=foot-Vector2(0,(float(soles[role][actor.frame])-48.0)*actor.scale.y)
		contacts[i]=foot
		ground.contact_scales[i]=actor.scale.x*0.65
		(actor.material as ShaderMaterial).set_shader_parameter("haze_amount",clampf((depth-1.0)*0.14,0.0,0.28))
	# Keep nearer feet in front, while leaving the foreground/caption above all.
	var order: Array[int] = []
	var first := actors[0].get_index()
	for i in range(actors.size()):
		order.append(i)
		first=mini(first,actors[i].get_index())
	order.sort_custom(func(a: int,b: int) -> bool: return contacts[a].y<contacts[b].y)
	for index in range(order.size()): actors[order[index]].get_parent().move_child(actors[order[index]],first+index)
