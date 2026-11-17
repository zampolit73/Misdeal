extends Node2D
## V2 batch-local presentation. Existing TravelTransition owns actors, clock and routing.
const ROOT := "res://assets/pixel/travel/batch_02/"
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const REAR := preload("res://scripts/travel/campfire_walk.gd")
var available := false
var planes: Dictionary = {}
var speeds := {"Road":1.2}
var scene: Dictionary = {}
var state: Dictionary = {}
var key := ""
var t := 0.0
var world := Transform2D.IDENTITY
var package_dir := ROOT
var images: Dictionary = {}
var textures: Dictionary = {}
var role_frames: Dictionary = {}
var heights: Dictionary = {}
var soles: Dictionary = {}
var original: Dictionary = {}
var npc: Sprite2D
var npc_visible := false
var actor_metrics: Array[Dictionary] = []

func image_at(path: String) -> Image:
	if images.has(path): return images[path]
	var image := Image.new()
	if not FileAccess.file_exists(ROOT+path) or image.load_png_from_buffer(FileAccess.get_file_as_bytes(ROOT+path))!=OK: return null
	image.convert(Image.FORMAT_RGBA8)
	images[path]=image
	return image

func texture_at(path: String) -> Texture2D:
	if not textures.has(path):
		var image := image_at(path)
		if image==null: return null
		textures[path]=ImageTexture.create_from_image(image)
	return textures[path]

func build(background: String, _foreground: String, _underpaint: String, _sky: String) -> void:
	var id := background.trim_prefix(ROOT).get_slice("/",0)
	var all: Variant=JSON.parse_string(FileAccess.get_file_as_string(ROOT+"staging.json"))
	if not all is Dictionary: return
	for entry in all.scenes:
		if str(entry.id)==id: original=entry.duplicate(true)
	if original.is_empty(): return
	scene=original.duplicate(true)
	if texture_at(id+"/layers/base_1280.png")==null: return
	for entry in original.states:
		if entry.key not in ["leave","careful","abandon"] and not FileAccess.file_exists(ROOT+id+"/layers/"+str(entry.key)+"_state.png"): return
	var rear := REAR.new()
	if scene.facing=="ne" and not rear.build(): return
	var metadata: Dictionary=JSON.parse_string(FileAccess.get_file_as_string(ROOT+"soles.json"))
	soles=metadata[scene.facing]
	for role in ["knight","ranger","mage"]:
		var frames: SpriteFrames=REAR.frames[role] if scene.facing=="ne" else ANIM.get_frames(role)
		if frames==null: return
		role_frames[role]=frames
		var height := 1
		for frame in range(6): height=maxi(height,frames.get_frame_texture("walk",frame).get_image().get_used_rect().size.y)
		heights[role]=float(height)
	# The painted architecture and props stay on one rigid plane. Foreground is
	# reserved for the seated recruit, so it remains above passing party members.
	for name in ["Midground","Foreground"]:
		var node := Node2D.new()
		node.name=name
		add_child(node)
		planes[name]=node
	if id=="rattling_bridge":
		var path := id+"/layers/ranger_seated.png"
		var image := image_at(path)
		if image==null: return
		npc=Sprite2D.new()
		npc.texture=texture_at(path)
		npc.region_enabled=true
		npc.region_rect=Rect2(image.get_used_rect())
		npc.centered=false
		npc.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
		npc.modulate=Color(0.83,0.85,0.89)
		planes.Foreground.add_child(npc)
	available=true

func configure(context: Dictionary) -> void:
	key=str(context.get("visual_action",""))
	state={}
	for entry in original.states:
		if entry.key==key: state=entry
	if state.is_empty():
		available=false
		return
	scene=original.duplicate(true)
	for field in state.get("actor_stage",{}): scene[field]=state.actor_stage[field]
	# Preload only this action's assets; per-instance caches free with the overlay.
	for path in [scene.folder+"/layers/"+key+"_state.png",scene.folder+"/layers/haze_strip.png"]:
		if FileAccess.file_exists(ROOT+path): texture_at(path)
	update_time(0,4)

func update_time(time: float, _duration: float) -> void:
	if not available: return
	t=time
	world=Transform2D(0,Vector2.ONE*1.008,0.0,Vector2(-4.0-t*1.2,-3.0))
	if npc!=null:
		npc_visible=key in ["recruit","loot_recruitment","abandon"] and (key!="recruit" or time<0.90)
		npc.visible=npc_visible
		var size := npc.region_rect.size
		var scale_factor := 122.0/size.y
		npc.scale=Vector2.ONE*scale_factor*1.008
		npc.position=world*(Vector2(1005,500)-Vector2(size.x*0.5,size.y)*scale_factor)
	queue_redraw()

func route(u: float) -> Vector2:
	var a:=Vector2(scene.route[0][0],scene.route[0][1])
	var b:=Vector2(scene.route[1][0],scene.route[1][1])
	var c:=Vector2(scene.route[2][0],scene.route[2][1])
	return (1-u)*(1-u)*a+2*(1-u)*u*b+u*u*c

func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, _duration: float, _layout: Resource) -> void:
	actor_metrics.clear()
	ground.contact_scales.resize(actors.size())
	var rank := 0
	var near_y := float(scene.route[0][1])
	var near_height := float(_layout.get_meta("party_near_height",scene.near_height))
	var passage_count := roles.size()-(1 if scene.id=="rattling_bridge" and key=="recruit" and roles.has("ranger") else 0)
	for i in range(actors.size()):
		var actor := actors[i]
		var role := roles[i]
		var joining: bool=scene.id=="rattling_bridge" and key=="recruit" and role=="ranger"
		actor.visible=not joining or time>=0.90
		var u:=clampf(0.08+time/4.0*float(scene.get("progress_span",0.80))-rank*0.20,0.0,1.0)
		var lane: float=float(scene.formation_lanes[rank]) if passage_count>1 else 0.0
		var foot:=route(u)+Vector2(lane,rank*8)
		var phase:=float(rank)*1.1
		if joining:
			foot=Vector2(1005,500).lerp(Vector2(1020,425),smoothstep(0.90,2.90,time))
			phase=1.1
		else: rank+=1
		var height:=near_height*(foot.y-float(scene.horizon))/(near_y-float(scene.horizon))
		actor.sprite_frames=role_frames[role]
		actor.animation="walk"
		actor.frame=int(time*6.5+phase)%6
		var scale_factor:=height/float(heights[role])
		actor.scale=Vector2.ONE*scale_factor*1.008
		actor.flip_h=false
		actor.position=world*(foot-Vector2(0,(float(soles[role][actor.frame])-48)*scale_factor))
		var haze:=clampf((near_y-foot.y)/(near_y-float(scene.horizon))*0.28,0,0.28)
		actor.modulate=Color(0.88,0.88,0.91).lerp(Color(0.52,0.57,0.64),haze)
		contacts[i]=world*foot
		ground.contact_scales[i]=scale_factor*0.6 if actor.visible else 0.0
		if actor.visible: actor_metrics.append({"role":role,"foot":contacts[i],"height":height})
	var order: Array[int]=[]
	var first:=actors[0].get_index()
	for i in range(actors.size()):
		order.append(i)
		first=mini(first,actors[i].get_index())
	order.sort_custom(func(a: int,b: int)->bool:return contacts[a].y<contacts[b].y)
	for i in range(order.size()): actors[order[i]].get_parent().move_child(actors[order[i]],first+i)

func tex(name: String) -> Texture2D:
	return texture_at(str(scene.folder)+"/layers/"+name+".png")
func draw_layer(name: String,alpha: float=1.0) -> void:
	if alpha>0: draw_texture(tex(name),Vector2.ZERO,Color(1,1,1,alpha))
func points(source: Array) -> PackedVector2Array:
	var r:=PackedVector2Array()
	for p in source: r.append(Vector2(p[0],p[1])*Vector2(1280.0/1672.0,720.0/941.0))
	return r
func polygon(texture: Texture2D,source: Array) -> void:
	var p:=points(source)
	var uv:=PackedVector2Array()
	for v in p: uv.append(v/Vector2(1280,720))
	draw_polygon(p,PackedColorArray([Color.WHITE]),uv,texture)
func state_layer(alpha: float=1.0) -> void: draw_layer(key+"_state",alpha)
func release_object(name: String,pivot: Vector2) -> void:
	if t<0.44:return
	state_layer()
	if t>=1.06:return
	var amount:=smoothstep(0.44,0.84,t)
	var opacity:=1.0-smoothstep(0.70,1.06,t)
	var delta:=Vector2(5.0*amount,-7.0*amount)
	var angle: float=deg_to_rad(1.6)*amount
	var transform:=Transform2D(angle,pivot+delta)*Transform2D(0,-pivot)
	draw_set_transform_matrix(world*transform)
	draw_texture(tex("release_"+name),Vector2.ZERO,Color(1,1,1,opacity))
	draw_set_transform_matrix(world)
func _draw() -> void:
	if not available or scene.is_empty():return
	world=Transform2D(0,Vector2.ONE*1.008,0.0,Vector2(-4.0-t*1.2,-3.0))
	draw_set_transform_matrix(world)
	draw_layer("base_1280")
	var progress:=smoothstep(0.42,1.18,t)
	match str(scene.id):
		"candle_seller":
			if key!="leave":
				state_layer(smoothstep(0.40,0.55,t))
				var cx:=1142.0 if key=="knight" else (1310.0 if key=="ranger" else 1475.0)
				var top:=450.0
				var poly: Array=[[cx-8,top],[cx+8,top],[cx+14,493],[cx+43,495],[cx+46,571],[cx+64,603],[cx-64,603],[cx-44,565],[cx-44,498],[cx-13,492]]
				if t<1.14:
					var pivot:=Vector2(cx*1280/1672,608.0*720/941)
					var sy:=1.0-progress*0.86
					var matrix:=Transform2D(0,Vector2(1,sy),0,pivot-Vector2(pivot.x,pivot.y*sy))
					draw_set_transform_matrix(world*matrix)
					polygon(tex("base_1280"),poly)
					draw_set_transform_matrix(world)
		"blood_ledger":
			if key=="leave":
				if t>=0.42 and t<0.90: draw_layer("book_half_closed")
				elif t>=0.90:state_layer()
			elif key in ["blood","erase"]:
				var width:=1280.0*progress
				draw_texture_rect_region(tex(key+"_state"),Rect2(0,0,width,720),Rect2(0,0,width,720))
			else:
				state_layer(smoothstep(0.65,0.80,t))

		"debtor_bones":
			if key.begins_with("gamble") and t>=0.40 and t<1.18:
				draw_layer("dice_clean")
				var initial: Array=[Vector2(1095,560),Vector2(1175,546),Vector2(1275,550)]
				var targets: Array=[Vector2(1035,574),Vector2(1185,532),Vector2(1320,584)] if key=="gamble_success" else [Vector2(1200,578),Vector2(1250,550),Vector2(1280,590)]
				for i in 3:
					var p: Vector2=initial[i]
					var f:=Vector2(1280.0/1672.0,720.0/941.0)
					var pos: Vector2=p.lerp(targets[i],progress)*f+Vector2(0,-8*sin(progress*PI))
					var angle:=sin(progress*PI)*(-0.5 if i%2==0 else 0.5)
					draw_set_transform_matrix(world*Transform2D(angle,pos)*Transform2D(0,-p*f))
					polygon(tex("base_1280"),[[p.x-35,p.y-26],[p.x-20,p.y-35],[p.x+29,p.y-28],[p.x+35,p.y+24],[p.x+18,p.y+35],[p.x-32,p.y+27]])
				draw_set_transform_matrix(world)
			elif key!="leave":state_layer(1.0 if t>=1.18 else 0.0)
			if key=="safe":
				state_layer(smoothstep(0.60,0.73,t))

		"wizard_tithe":
			if key=="refuse":
				if t>=0.43 and t<0.90:draw_layer("refuse_half_tipped")
				elif t>=0.90:state_layer()
			else:
				state_layer(progress)
				if key=="blood" and t>1.15 and t<2.0:
					var a:=0.20*(1.0-(t-1.15)/0.85)
					draw_set_transform_matrix(world*Transform2D(0,Vector2(1,0.18),0,Vector2(615,263)))
					draw_arc(Vector2.ZERO,5+16*(t-1.15),0,TAU,30,Color(0.48,0.10,0.06,a),1)
					draw_set_transform_matrix(world)
		"broken_crown":
			if key=="wear":
				state_layer(smoothstep(0.44,0.98,t))
			elif key!="leave":state_layer(progress)
		"curse_forge":
			if key!="leave":
				var name: String="shield" if key=="dead_mans_shield" else ("quiver" if key=="blind_quiver" else "focus")
				var pivots: Dictionary={"shield":Vector2(765,290),"quiver":Vector2(923,288),"focus":Vector2(1060,310)}
				release_object(name,pivots[name])
		"rattling_bridge":
			if key in ["rush_success","scavenge"]:
				state_layer(smoothstep(0.62,0.76,t))

			elif key=="rush_failure":state_layer(smoothstep(0.62,0.78,t))
			elif key in ["recruit","loot_recruitment"]:
				state_layer(smoothstep(0.44,0.96,t))

	draw_haze()
	draw_set_transform_matrix(Transform2D.IDENTITY)
func draw_haze() -> void:
	var path:=str(scene.folder)+"/layers/haze_strip.png"
	if FileAccess.file_exists(package_dir+path):
		draw_texture(texture_at(path),Vector2(-30-t*6,250))
