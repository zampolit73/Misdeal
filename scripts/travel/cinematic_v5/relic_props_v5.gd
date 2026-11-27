extends Node2D
## Continuous in-world transactions. No full-screen insert or duplicate prop.
## Every position, pose and resolved state is a deterministic function of seek.
const CELL := 192
const KEYS := {
	"debtor_bones":["die2","die5","die3","dice_broken","stake","empty_dish","box_closed","box_open"],
	"wizard_tithe":["chalice_empty","chalice_gold","chalice_blood","chalice_side","scroll","coin","scroll_open","stain"],
	"broken_crown":["crown","fragments","residue","tooth"]
}
const LIQUID := preload("res://shaders/travel_relic_liquid.gdshader")
const ROOT := "res://assets/pixel/travel/cinematic_v5/relic_polish/"
const START := 2.45
const IMPACT := 3.22
const END := 4.16
static var _cache: Dictionary = {}
var id := ""
var profile: Dictionary
var action := ""
var pieces: Dictionary = {}
var shades: Dictionary = {}
var textures: Dictionary = {}
var shadow_texture: Texture2D
var state_key := "base"
var resolved := false
var elapsed := 0.0

func build(scene_id: String, resolved_action: String, data: Dictionary, shadow: Texture2D) -> bool:
	id = scene_id
	action = resolved_action
	profile = data
	shadow_texture = shadow
	if not KEYS.has(id): return false
	if _cache.has(id):
		textures = _cache[id]
	else:
		var img := Image.new()
		if img.load_webp_from_buffer(FileAccess.get_file_as_bytes(ROOT+id+"/props.webp"))!=OK: return false
		var keys: Array = KEYS[id]
		if img.get_size()!=Vector2i(CELL*4,CELL*ceili(keys.size()/4.0)): return false
		for i in keys.size():
			var tile := img.get_region(Rect2i((i%4)*CELL,(i/4)*CELL,CELL,CELL))
			var used := tile.get_used_rect()
			if used.size.x<4 or used.size.y<4: return false
			textures[keys[i]] = ImageTexture.create_from_image(tile.get_region(used))
		if id=="debtor_bones":
			# The two transactions use the very same worn gold denomination art.
			var coins := Image.new()
			if coins.load_webp_from_buffer(FileAccess.get_file_as_bytes(ROOT+"wizard_tithe/props.webp"))!=OK: return false
			var coin := coins.get_region(Rect2i(CELL,CELL,CELL,CELL))
			if coin.get_used_rect().size==Vector2i.ZERO: return false
			textures["coin"]=ImageTexture.create_from_image(coin.get_region(coin.get_used_rect()))
		_cache[id] = textures
	seek(0.0,Vector2.ZERO)
	return true

func _point(key: String) -> Vector2:
	var p: Array = profile[key]
	return Vector2(float(p[0]),float(p[1]))

func _piece(key: String) -> Sprite2D:
	if pieces.has(key): return pieces[key]
	var node := Sprite2D.new()
	node.name = key
	node.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	node.z_index = 5
	add_child(node)
	pieces[key] = node
	var shade := Sprite2D.new()
	shade.texture = shadow_texture
	shade.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	shade.z_index = 2
	add_child(shade)
	shades[key] = shade
	return node

func _show(slot: String, key: String, at: Vector2, width: float, lift := 0.0, angle := 0.0, opacity := 1.0, shadow_strength := 0.75) -> void:
	var node := _piece(slot)
	var tex: Texture2D = textures[key]
	var sc := width/float(tex.get_width())
	node.texture = tex
	node.position = at-Vector2(0,lift)
	node.offset = Vector2(0,-tex.get_height()*0.5)
	node.scale = Vector2.ONE*sc
	node.rotation = angle
	node.visible = opacity>0.01
	node.modulate = Color(float(profile.tint[0]),float(profile.tint[1]),float(profile.tint[2]),opacity)
	node.set_meta("prop_key",key)
	var shade: Sprite2D = shades[slot]
	shade.position = at
	shade.scale = Vector2(width*0.83/64.0,maxf(2.0,width*0.14)/20.0)*(1.0+lift*0.008)
	shade.modulate.a = opacity*shadow_strength*maxf(0.20,1.0-lift/60.0)
	shade.visible = node.visible and shadow_strength>0.01

func _fly(slot: String, key: String, from: Vector2, to: Vector2, width: float, u: float, height: float, spin: float, opacity := 1.0) -> void:
	var v := clampf(u,0,1)
	_show(slot,key,from.lerp(to,v),width,sin(v*PI)*height,sin(v*PI)*spin,opacity)

func _dice(t: float, hand: Vector2) -> void:
	var anchor := _point("dice")
	var width := float(profile.die_width)
	var offsets := [Vector2(-width*1.42,-2),Vector2(0,-width*0.33),Vector2(width*1.48,1)]
	var success_offsets := [Vector2(-width*1.85,3),Vector2(width*0.20,-width*0.64),Vector2(width*1.95,-1)]
	var failure_offsets := [Vector2(-width*0.96,-width*0.64),Vector2(width*0.56,2),Vector2(width*1.71,-width*0.44)]
	var keys := ["die2","die5","die3"]
	var roll := action.begins_with("gamble") and t>=START
	var finals: Array = success_offsets if action=="gamble_success" else failure_offsets
	if action=="break" and resolved:
		var settle := smoothstep(IMPACT,IMPACT+0.33,t)
		_show("cracked","dice_broken",anchor+Vector2(1,2),width*3.8,6.0*(1.0-settle),0.13*(1.0-settle))
	else:
		for i in 3:
			var at: Vector2 = anchor+offsets[i]
			var lift := 0.0
			var rotation := 0.0
			var key: String = keys[i]
			if roll:
				var u := clampf((t-START-i*0.06)/(IMPACT-START-i*0.06),0,1)
				var land := smoothstep(0,1,u)
				at = at.lerp(anchor+finals[i],land)
				lift = absf(sin(PI*u*2.0))*13.0*(1.0-u)
				rotation = sin(TAU*u)*0.65*(1.0-u)
				key = keys[posmod(i+int(u*5),3)] if u<1.0 else (["die5","die5","die3"][i] if action=="gamble_success" else ["die2","die2","die3"][i])
			_show("die"+str(i),key,at,width,lift,rotation)
	var dish_at := _point("dish")
	var dish_key := "stake"
	if resolved and action in ["safe","gamble_success"]: dish_key = "empty_dish"
	if resolved and action=="gamble_failure":
		dish_at += Vector2(12,-6)*smoothstep(IMPACT,IMPACT+0.27,t)
	_show("dish",dish_key,dish_at,float(profile.dish_width))
	_show("box","box_open" if resolved and action=="gamble_success" else "box_closed",_point("box"),float(profile.box_width))
	# The dish is pulled away into the customer's natural reach; no payout drawn on the floor.
	if action=="safe" and t>=START and t<IMPACT:
		var u := smoothstep(START,IMPACT,t)
		var dish: Sprite2D = pieces.dish
		var shade: Sprite2D = shades.dish
		dish.position += Vector2(-4,2)*sin(PI*u)
		shade.position = dish.position
	if action in ["safe","gamble_success"]:
		# A small visible transfer into the buyer's hand, no invented ground loot.
		var onset := 2.66 if action=="safe" else IMPACT
		var origin := dish_at if action=="safe" else _point("box")
		for i in 2:
			var v := (t-onset-i*0.09)/0.36
			if v>=0.0 and v<1.0:
				_fly("payout"+str(i),"coin",origin-Vector2(0,5),hand,7.0,v,10.0,0.42,1.0-smoothstep(0.79,1.0,v))

func _tithe(t: float, hand: Vector2) -> void:
	var at := _point("bowl")
	var w := float(profile.bowl_width)
	var bowl := "chalice_empty"
	var scroll := "scroll"
	var angle := 0.0
	var u := clampf((t-START)/(IMPACT-START),0.0,1.0)
	if action=="refuse":
		if not resolved and t>=START:
			angle = smoothstep(0.4,1.0,u)*-0.80
			at += Vector2(-8,1)*smoothstep(0.4,1.0,u)
		if resolved:
			bowl = "chalice_side"
			at += Vector2(-16,4)
			w *= 1.38
			scroll = "scroll_open"
	elif resolved:
		bowl = "chalice_gold" if action=="gold" else "chalice_blood"
	if resolved and action=="blood":
		_show("blood_stain","stain",at+Vector2(0,8),w*1.25,0,0,smoothstep(IMPACT,IMPACT+0.22,t)*0.72,0.0)
	_show("bowl",bowl,at,w,0.0,angle)
	_show("scroll",scroll,_point("scroll"),float(profile.scroll_width)*(1.25 if scroll=="scroll_open" else 1.0))
	if action=="gold" and t>=START:
		for i in 3:
			var v := (t-2.62-i*0.09)/0.37
			if v>=0.0 and v<1.0:
				_fly("coin"+str(i),"coin",hand,at-Vector2(0,28),w*0.16,v,12.0,0.7)
	if action=="blood":
		var v := (t-2.76)/0.28
		if v>=0.0 and v<1.0:
			_fly("drop","stain",hand,at-Vector2(0,31),5.0,v,4.0,0.0)
		var vessel: Sprite2D=pieces.bowl
		if vessel.material==null:
			var mat := ShaderMaterial.new()
			mat.shader=LIQUID
			vessel.material=mat
		(vessel.material as ShaderMaterial).set_shader_parameter("elapsed",t)
		(vessel.material as ShaderMaterial).set_shader_parameter("ripple",(1.0-smoothstep(IMPACT,IMPACT+0.55,t)) if resolved else 0.0)

func _crown(t: float, hand: Vector2) -> void:
	var at := _point("crown")
	var w := float(profile.crown_width)
	if action=="wear" and t>=START:
		if not resolved:
			var u := smoothstep(2.62,IMPACT,t)
			_show("crown","crown",at.lerp(hand,u*0.76),w,21.0*sin(PI*u),-0.12*u,1.0-smoothstep(0.78,1.0,u))
		return
	if action=="break" and resolved:
		var settle := smoothstep(IMPACT,IMPACT+0.38,t)
		_show("fragments","fragments",at,w*1.18)
		_show("tooth","tooth",at+Vector2(w*0.53,2),w*0.22,11.0*(1.0-settle),0.40*(1.0-settle))
		return
	if action=="melt" and resolved:
		_show("residue","residue",at+Vector2(0,2),w*1.21,0.0,0.0,1.0,0.18)
		return
	var wobble := sin(PI*smoothstep(START,IMPACT,t))*0.09 if action in ["break","melt"] else 0.0
	_show("crown","crown",at,w,0.0,wobble)
	if action=="melt" and t>IMPACT-0.24:
		var collapse := smoothstep(IMPACT-0.24,IMPACT,t)
		var metal: Sprite2D=pieces.crown
		metal.scale.y*=1.0-0.72*collapse
		metal.modulate=metal.modulate.darkened(0.16*collapse)

func seek(t: float, hand: Vector2) -> void:
	elapsed = t
	resolved = action!="leave" and t>=IMPACT
	state_key = action if resolved else "base"
	for piece in pieces.values(): piece.visible = false
	for shade in shades.values(): shade.visible = false
	match id:
		"debtor_bones": _dice(t,hand)
		"wizard_tithe": _tithe(t,hand)
		"broken_crown": _crown(t,hand)
