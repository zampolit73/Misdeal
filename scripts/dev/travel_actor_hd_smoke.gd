extends SceneTree
## Short all-location presentation regression, no save/gameplay/AI changes.
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const REAR := preload("res://scripts/travel/campfire_walk.gd")
const NW := preload("res://scripts/travel/dressing_station_walk.gd")
const RESCUE := preload("res://scripts/travel/cinematic_v5/rescue_v5.gd")
const PARTY := ["knight","ranger","mage"]
const ACTIONS := {"candle_seller":"leave","blood_ledger":"leave","debtor_bones":"leave","wizard_tithe":"refuse","broken_crown":"leave","curse_forge":"leave","rattling_bridge":"careful","last_signal":"passed","gravedigger_shop":"leave","lost_purse":"untouched","unsent_letters":"passed","banner_seamstress":"passed","borrowed_boots":"passed","false_weights":"passed"}
var checks := 0
var errors := 0
var scenes := 0

func _initialize() -> void:
	_run.call_deferred()

func _check(ok: bool, name: String) -> void:
	checks += 1
	if not ok:
		errors += 1
		push_error(name)

func _check_texture(tex: Texture2D, label: String) -> void:
	_check(VIS.is_hd(tex),label+" native painted cell")
	_check(tex != null and tex.get_size()==Vector2(96,96),label+" unchanged logical cell")
	if tex == null: return
	_check(tex.get_image().get_size()==Vector2i(288,288),label+" 9x pixel samples")
	_check(VIS.logical_image(tex).get_size()==Vector2i(96,96),label+" unchanged logical image")

func _context(id: String) -> Dictionary:
	var p := {"jack_companion":true}
	if not CATALOG.BATCH03.scene_for(id).is_empty():
		for action in CATALOG.BATCH03.scene_for(id).states:
			if id=="jack" and action!="recruited": continue
			p.batch_03_action = action
			var ctx := CATALOG.context_for(id,"",PARTY,"",false,p)
			if not ctx.is_empty(): return ctx
		return {}
	var a: String = ACTIONS.get(id,"leave")
	if CATALOG.BATCH02.ACTIONS.has(id):
		# Exact legal preview context, intentionally exercise V4 on all 24.
		return {"resolved_card_id":id,"visual_action":a,"outcome_id":a,"party_roles":PARTY,"jack_companion":true,"narration_text":"","wizard_line":"","duration_sec":4.0}
	return CATALOG.context_for(id,a,PARTY,"",false,p)

func _run_fallback() -> void:
	for role in VIS.ROLES:
		var base := ANIM.get_frames(role)
		_check(base != null and VIS.side_frames(role) == base,role+" missing HD uses original")
		_check(VIS.filter_for(base.get_frame_texture("walk",0))==CanvasItem.TEXTURE_FILTER_NEAREST,role+" original filtering")
	var rear := REAR.new()
	var nw := NW.new()
	_check(rear.build() and nw.build(),"both original rear packs remain available")
	for role in PARTY:
		for set in [REAR.frames[role],NW.frames[role]]:
			var cel: Texture2D = set.get_frame_texture("walk",0)
			_check(not VIS.is_hd(cel) and cel.get_size()==Vector2(96,96),role+" original rear cel")
	var rescue := RESCUE.new()
	root.add_child(rescue)
	_check(rescue.configure_scene("jack",PARTY,"recruited",true),"original rescue movie remains available")
	if rescue.available:
		rescue.seek(3.55)
		_check(not VIS.is_hd(rescue.jack.texture) and rescue.dog_clip=="rise","original living poses and Jack scale retained")
	rescue.free()
	print("TRAVEL_ACTOR_HD_FALLBACK: %d checks · %d failures" % [checks,errors])
	quit(0 if errors==0 else 1)

func _run() -> void:
	if "--fallback" in OS.get_cmdline_user_args():
		_run_fallback()
		return
	# Side source snapshots; combat lookup remains exact and untouched.
	for role in VIS.ROLES:
		var base := ANIM.get_frames(role)
		var upgraded := VIS.side_frames(role)
		_check(base!=null and upgraded!=null and base!=upgraded,role+" separate travel resource")
		if base==null or upgraded==null: continue
		for clip in ["idle","walk","attack"] if role=="mage" else ["idle","walk"]:
			_check(base.get_frame_count(clip)==upgraded.get_frame_count(clip),role+" unchanged cel count")
			_check(base.get_animation_speed(clip)==upgraded.get_animation_speed(clip),role+" unchanged cadence")
			for i in base.get_frame_count(clip):
				var tex := upgraded.get_frame_texture(clip,i)
				_check_texture(tex,role+"/"+clip)
				_check(VIS.logical_image(tex).get_data()==base.get_frame_texture(clip,i).get_image().get_data(),role+" exact baseline geometry")
		_check(ANIM.get_frames(role)==base and base.get_frame_texture("idle",0).get_size()==Vector2(96,96),role+" combat asset unchanged")
	for id in V3.LOCATIONS:
		var context := _context(id)
		_check(not context.is_empty(),id+" legal context")
		if context.is_empty(): continue
		var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context = context
		root.add_child(view)
		view.set_process(false)
		_check(view.available,id+" opens")
		if not view.available:
			view.free()
			continue
		scenes += 1
		for t in [0.4,1.8,3.6]:
			view.elapsed = t
			view.update_frame()
			for actor in view.actors:
				if not actor.visible: continue
				_check_texture(actor.sprite_frames.get_frame_texture(actor.animation,actor.frame),id+" hero")
				_check(actor.texture_filter==CanvasItem.TEXTURE_FILTER_LINEAR,id+" hero smooth rendering")
			var dog := view.composition.get_node_or_null("TravelJack") as AnimatedSprite2D
			if is_instance_valid(dog) and dog.visible:
				_check_texture(dog.sprite_frames.get_frame_texture(dog.animation,dog.frame),id+" dog")
				_check(dog.texture_filter==CanvasItem.TEXTURE_FILTER_LINEAR,id+" dog smooth rendering")
		var companion := view.composition.get_node_or_null("TravelJack") as AnimatedSprite2D
		_check(is_instance_valid(companion) and companion.visible,id+" actual companion after outcome")
		view.free()
	_check(scenes==24,"all 24 original scene renderers")
	# NEW rescue scene's dedicated custom poses also use the source-detail atlas.
	var rescue := RESCUE.new()
	root.add_child(rescue)
	_check(rescue.configure_scene("jack",PARTY,"recruited",true),"Jack F6 candidate opens")
	if rescue.available:
		for t in [2.66,2.91,3.22,3.55,3.78,5.4]:
			rescue.seek(t)
			for role in rescue.visible_roles:
				_check_texture(rescue.actors[role].texture,"rescue "+role)
			if rescue.jack.visible: _check_texture(rescue.jack.texture,"Jack recovery")
		for role in VIS.ROLES:
			for tex in rescue.living_poses[role]:
				_check_texture(tex,role+" dedicated living cel")
	rescue.free()
	print("TRAVEL_ACTOR_HD_SMOKE: %d locations · %d checks · %d failures" % [scenes,checks,errors])
	quit(0 if errors==0 else 1)
