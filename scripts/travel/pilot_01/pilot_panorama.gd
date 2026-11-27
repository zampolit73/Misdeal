extends Node2D
## Batch01-only implementation of the existing V2 panorama contract.
const ROOT := "res://assets/pixel/travel/pilot_01/"
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const STAGING := preload("res://scripts/travel/travel_staging_v4.gd")
const REAR := preload("res://scripts/travel/campfire_walk.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const NW := preload("res://scripts/travel/dressing_station_walk.gd")
static var textures: Dictionary = {}
static var images: Dictionary = {}
var card_id := ""
var available := false
var planes: Dictionary = {}
var speeds := {"Sky":1.2,"Midground":1.2,"Road":1.2,"Action":1.2,"Foreground":1.2}
var dir := ""
var action := ""
var config: Dictionary = {}
var heroes: Dictionary = {}
var body: Sprite2D
var road: Sprite2D
var front: Sprite2D
var prop: Sprite2D
var mats: Array[ShaderMaterial] = []
var nw := NW.new()
var pose_key := ""
var role_frames: Dictionary = {}
var soles: Dictionary = {}
var heights: Dictionary = {}
func image_at(path: String) -> Image:
	if images.has(path): return images[path]
	var img := Image.new()
	if not FileAccess.file_exists(path) or img.load_png_from_buffer(FileAccess.get_file_as_bytes(path))!=OK: return null
	img.convert(Image.FORMAT_RGBA8)
	images[path]=img
	return img
func texture_at(path: String) -> Texture2D:
	if textures.has(path): return textures[path]
	var img := image_at(path)
	if img==null: return null
	textures[path]=ImageTexture.create_from_image(img)
	return textures[path]
func composite(path: String, rect: Rect2i) -> Texture2D:
	var key := dir+path
	if textures.has(key+"|composite"): return textures[key+"|composite"]
	var patch := image_at(key)
	if patch==null: return null
	var image := image_at(dir+"source/original_master.png").duplicate() as Image
	image.blend_rect(patch,Rect2i(Vector2i.ZERO,patch.get_size()),rect.position)
	textures[key+"|composite"]=ImageTexture.create_from_image(image)
	return textures[key+"|composite"]
func build(background: String, foreground: String, _underpaint: String, _sky: String) -> void:
	dir=ROOT+card_id+"/"
	var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(ROOT+"staging.json"))
	if not parsed is Dictionary or not parsed.scenes.has(card_id): return
	config=parsed.scenes[card_id].duplicate(true)
	var p := STAGING.profile(card_id)
	var facing: String = p.get("facing", config.facing)
	heroes=parsed.hero_reference[config.facing]
	if texture_at(background)==null or texture_at(foreground)==null or texture_at(dir+"layers/motion_mask.png")==null: return
	if facing == "nw" and not nw.build(): return
	var rear := REAR.new()
	if facing == "ne" and not rear.build(): return
	for role in ["knight","ranger","mage"]:
		role_frames[role] = NW.frames[role] if facing == "nw" else (REAR.frames[role] if facing == "ne" else ANIM.get_frames(role))
		soles[role] = REAR.soles[role] if facing == "ne" else heroes[role].soles
		heights[role]=float(heroes[role].max_visible_height)
	for id in speeds:
		var plane := Node2D.new()
		plane.name=id
		add_child(plane)
		planes[id]=plane
	body=_sprite("Midground")
	road=_sprite("Road",dir+"layers/ground_plane.png")
	front=_sprite("Foreground",foreground)
	prop=Sprite2D.new()
	prop.centered=false
	prop.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	planes.Action.add_child(prop)
	available=true
	update_time(0,4)
func _sprite(plane: String, mask: String = "") -> Sprite2D:
	var s := Sprite2D.new()
	s.centered=false
	s.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	var mat := ShaderMaterial.new()
	mat.shader=preload("res://shaders/pilot_batch_scene.gdshader")
	mat.set_shader_parameter("motion_mask",texture_at(dir+"layers/motion_mask.png"))
	mat.set_shader_parameter("mute_lost_purse_sunset",card_id=="lost_purse")
	if not mask.is_empty():
		mat.set_shader_parameter("use_alpha_mask",true)
		mat.set_shader_parameter("alpha_mask",texture_at(mask))
	s.material=mat
	mats.append(mat)
	planes[plane].add_child(s)
	return s
func configure(context: Dictionary) -> void:
	action=str(context.get("visual_action",context.get("outcome_id","")))
	var allowed: Array=[]
	match card_id:
		"last_signal": allowed=["truth","salvage","passed"]
		"gravedigger_shop": allowed=["knight","ranger","mage","leave"]
		"lost_purse": allowed=["safe","greedy","all_in","untouched"]
	if action not in allowed: action=str(config.base)
	if card_id=="gravedigger_shop" and action!="leave" and (str(context.get("outcome_id",""))!="bought" or str(context.get("choice_role",""))!=action): action="leave"
	if card_id=="gravedigger_shop" and action!="leave":
		for mat in mats: mat.set_shader_parameter("shine_mask",texture_at(dir+"layers/"+action+"_shading_mask_1280.png"))
	update_time(0,4)
func update_time(time: float, duration: float) -> void:
	if not available: return
	for id in planes: planes[id].position=Vector2(-32-1.2*(time-duration*0.5),-18)
	var tex: Texture2D=texture_at(dir+"source/original_master.png")
	pose_key="base"
	prop.visible=false
	var final_at := 1.22
	match card_id:
		"last_signal":
			if action=="salvage" and time>=0.32:
				if time<1.2:
					var cell := 0 if time<0.60 else (1 if time<0.87 else 2)
					pose_key="salvage_action_"+str(cell)
					tex=composite("animation/"+pose_key+".png",Rect2i(930,160,460,630))
				else: final_at=1.2
			elif action=="truth" and time>=0.08 and time<final_at:
				var cell := 0 if time<0.54 else (1 if time<0.76 else (2 if time<1.02 else 3))
				var u := smoothstep(0.08,0.40,time)
				_prop("animation/paper_pose_"+str(cell)+".png",Vector2(600,1020).lerp(Vector2(710,720),u)+Vector2(0,-20*sin(PI*u)),Vector2(230,175))
		"gravedigger_shop":
			final_at=1.2
			if action!="leave" and time>=0.4 and time<final_at:
				var rect: Array=JSON.parse_string(FileAccess.get_file_as_string(dir+"layers/layer_contract.json")).states[["knight","ranger","mage"].find(action)].source_rect
				tex=composite("animation/"+action+"_work.png",Rect2i(rect[0],rect[1],rect[2],rect[3]))
				pose_key=action+"_work"
		"lost_purse":
			if action=="safe" and time>=0.42:
				tex=composite("layers/safe_patch.png",Rect2i(160,490,480,290))
				if time<1.2:
					var u := smoothstep(0.72,1.2,time)
					_prop("animation/safe_grip.png",Vector2(330,490)+Vector2(420*u,560*u*u),Vector2(330,451))
			elif action=="greedy" and time>=0.57:
				tex=composite("layers/greedy_patch.png",Rect2i(160,490,480,290))
			elif action=="all_in" and time>=0.44:
				tex=composite("layers/all_in_patch.png",Rect2i(160,490,480,290))
				if time<1.18:
					var u := smoothstep(0.44,1.18,time)
					_prop("animation/purse_lift_grip.png",Vector2(160,490)+Vector2(420*u,560*u*u),Vector2(640,500))
	if time>=final_at:
		tex=texture_at(dir+"outcomes/"+(action if not action.is_empty() else str(config.base))+".png")
		pose_key="final_"+action
		prop.visible=false
	if tex==null:
		available=false
		return
	for s in [body,road,front]:
		s.texture=tex
		s.scale=Vector2(1344,757)/tex.get_size()
	for mat in mats:
		mat.set_shader_parameter("elapsed",time)
		mat.set_shader_parameter("work_glint",0.12*sin(PI*(time-0.4)/0.8) if card_id=="gravedigger_shop" and action!="leave" and time>=0.4 and time<1.2 else 0.0)
func _prop(path: String, source_pos: Vector2, source_size: Vector2) -> void:
	prop.texture=texture_at(dir+path)
	prop.visible=prop.texture!=null
	if not prop.visible: return
	var projection := Vector2(1344.0/1672,757.0/941)
	prop.position=source_pos*projection
	prop.scale=source_size/prop.texture.get_size()*projection
func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, layout: Resource) -> void:
	STAGING.stage_legacy(card_id, actors, roles, contacts, ground, time, duration, planes.Road.position - Vector2(-32,-18), layout, role_frames, soles)
