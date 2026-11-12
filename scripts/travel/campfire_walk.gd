extends RefCounted
## Scene04-only rear walk along the curved road, with depth projection.
## No RunState/save writes; the V2 owner still supplies clock, pause and finish.
const DIR := "res://assets/pixel/travel/campfire_without_master/rear_walk/"
const ROAD_CONTROL_NEAR := Vector2(1125,555)
const ROAD_CONTROL_FAR := Vector2(1055,430)
const GATE_EXIT := Vector2(1135,315)
const DEPTH_TRAVEL := 1.25
const HAZE := preload("res://shaders/dressing_station_walk.gdshader")
static var frames: Dictionary = {}
static var soles: Dictionary = {}
var road := Curve2D.new()
var road_origin := Vector2.INF
var road_length := 0.0

func _prepare_road(origin: Vector2) -> void:
	if road_origin==origin: return
	road_origin=origin
	road.clear_points()
	road.bake_interval=2.0
	road.add_point(origin,Vector2.ZERO,ROAD_CONTROL_NEAR-origin)
	road.add_point(GATE_EXIT,ROAD_CONTROL_FAR-GATE_EXIT,Vector2.ZERO)
	road_length=road.get_baked_length()

func _road_sample(distance: float) -> Vector2:
	return road.sample_baked(clampf(distance,0.0,road_length),true)

func _road_tangent(distance: float) -> Vector2:
	return (_road_sample(distance+2.0)-_road_sample(distance-2.0)).normalized()

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
		frames[role]=animation
	soles=parsed
	return true

func stage(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, road_offset: Vector2, layout: Resource) -> void:
	_prepare_road(layout.party_origin)
	ground.contact_scales.resize(actors.size())
	# Near-road screen spacing is converted once to longitudinal depth spacing.
	var depth_interval := float(layout.party_spacing)/road_length*0.65
	var finish_projection := 1.0-1.0/(1.0+DEPTH_TRAVEL+depth_interval*2.0)
	var trail := Vector2.ZERO
	for i in range(actors.size()):
		var actor := actors[i]
		var role := roles[i]
		if actor.sprite_frames!=frames[role]:
			actor.sprite_frames=frames[role]
			actor.animation="walk"
			actor.modulate=Color.WHITE
			var material := ShaderMaterial.new()
			material.shader=HAZE
			actor.material=material
		# Arc-length sampling keeps bends smooth; reciprocal depth slows screen
		# travel and contracts intervals as the party approaches the gate.
		var depth := 1.0+time/duration*DEPTH_TRAVEL+(actors.size()-1-i)*depth_interval
		if actors.size()==1: depth+=0.30
		var factor := 1.0/depth
		var distance := clampf((1.0-factor)/finish_projection,0.0,1.0)*road_length
		var tangent := _road_tangent(distance)
		var lane := 0.0 if i==0 else (14.0 if i%2==1 else -14.0)
		var normal := Vector2(-tangent.y,tangent.x)
		var foot := _road_sample(distance)+normal*lane*factor+road_offset
		trail-=tangent
		var phase := time*6.5+i*1.1
		actor.frame=int(phase)%6
		# Strengthen size falloff within the formation without moving road contacts.
		var rank_scale := pow(0.96,actors.size()-1-i)
		actor.scale=Vector2.ONE*float(layout.party_scale)*factor*rank_scale
		actor.flip_h=false
		actor.position=foot-Vector2(0,(float(soles[role][actor.frame])-48.0)*actor.scale.y)
		contacts[i]=foot
		ground.contact_scales[i]=actor.scale.x*0.65
		(actor.material as ShaderMaterial).set_shader_parameter("haze_amount",clampf(0.04+(depth-1.0)*0.19,0.04,0.34))
	ground.dust_direction=trail.normalized()
	# Keep nearer feet in front, while leaving the foreground/caption above all.
	var order: Array[int] = []
	var first := actors[0].get_index()
	for i in range(actors.size()):
		order.append(i)
		first=mini(first,actors[i].get_index())
	order.sort_custom(func(a: int,b: int) -> bool: return contacts[a].y<contacts[b].y)
	for index in range(order.size()): actors[order[index]].get_parent().move_child(actors[order[index]],first+index)

