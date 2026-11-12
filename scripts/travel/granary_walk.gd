extends "res://scripts/travel/campfire_walk.gd"
## Scene05-only hall projection; reuse existing NE presentation frames/soles.
const HALL_TRAVEL := 0.55
const HALL_HORIZON_Y := 285.0
func _prepare_road(origin: Vector2) -> void:
	if road_origin==origin: return
	road_origin=origin
	road.clear_points()
	road.bake_interval=2.0
	road.add_point(origin,Vector2.ZERO,Vector2(15,-75))
	road.add_point(Vector2(1140,380),Vector2(-25,55),Vector2.ZERO)
	road_length=road.get_baked_length()
func stage(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, road_offset: Vector2, layout: Resource) -> void:
	_prepare_road(layout.party_origin)
	ground.contact_scales.resize(actors.size())
	# Near-road screen spacing is converted once to longitudinal depth spacing.
	var depth_interval := float(layout.party_spacing)/road_length*0.65
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
		# travel and contracts intervals as the party approaches the far hall.
		var depth := 1.0+time/duration*HALL_TRAVEL+(actors.size()-1-i)*depth_interval
		if actors.size()==1: depth+=depth_interval
		var factor := 1.0/depth
		var distance := clampf((1.0-factor)/HALL_TRAVEL,0.0,1.0)*road_length
		var tangent := _road_tangent(distance)
		var lane := 0.0 if actors.size()==1 or i==actors.size()-1 else (-130.0 if i%2==0 else 90.0)
		var normal := Vector2(-tangent.y,tangent.x)
		var foot := _road_sample(distance)+normal*lane*factor+road_offset
		trail-=tangent
		var phase := time*6.5+i*1.1
		actor.frame=int(phase)%6
		# Ground-plane projection: equally tall people scale with sole height
		# above the road horizon, rather than shrinking independently of position.
		var ground_factor: float = (foot.y-road_offset.y-HALL_HORIZON_Y)/(layout.party_origin.y-HALL_HORIZON_Y)
		actor.scale=Vector2.ONE*float(layout.party_scale)*ground_factor
		actor.flip_h=false
		actor.position=foot-Vector2(0,(float(soles[role][actor.frame])-48.0)*actor.scale.y)
		contacts[i]=foot
		ground.contact_scales[i]=actor.scale.x*0.65
		(actor.material as ShaderMaterial).set_shader_parameter("haze_amount",clampf(0.04+(1.0-ground_factor)*0.42,0.04,0.34))
	ground.dust_direction=trail.normalized()
	# Keep nearer feet in front, while leaving the foreground/caption above all.
	var order: Array[int] = []
	var first := actors[0].get_index()
	for i in range(actors.size()):
		order.append(i)
		first=mini(first,actors[i].get_index())
	order.sort_custom(func(a: int,b: int) -> bool: return contacts[a].y<contacts[b].y)
	for index in range(order.size()): actors[order[index]].get_parent().move_child(actors[order[index]],first+index)
