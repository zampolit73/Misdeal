extends CanvasLayer
signal finished
const VIS := preload("res://scripts/travel/travel_actor_visuals.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const PANORAMA := preload("res://scripts/travel/travel_panorama.gd")
const GROUND_FX := preload("res://scripts/travel/travel_ground_fx.gd")
const STAGING := preload("res://scripts/travel/travel_staging_v4.gd")
const V3 := preload("res://scripts/travel/travel_v3_motion.gd")
const FORGE_V5 := preload("res://scripts/travel/cinematic_v5/forge_v5.gd")
const MERCHANT_V5 := preload("res://scripts/travel/cinematic_v5/merchant_v5.gd")
const ROAD_V5 := preload("res://scripts/travel/cinematic_v5/road_v5.gd")
# Explicit production allowlist; future F6 candidates are not auto-activated.
const LIVE_MERCHANT_IDS := ["candle_seller", "blood_ledger", "gravedigger_shop"]
const LIVE_ROAD_IDS := ["rattling_bridge", "whispering_well", "lost_purse"]
const WALK_FPS := 6.5
const BODY_SPEED := 20.0
static var _soles: Dictionary = {}
var context: Dictionary = {}
# Only the production router opts approved cinematics in. Direct V4 QA
# drivers continue to inspect their original baseline, including rollback.
var use_cinematic_v5 := false
var forge_v5: Node2D
var merchant_v5: Node2D
var road_v5: Node2D
var _cinematic_step := -1
var data_path := ""
var data: Resource
var elapsed := 0.0
var done := false
var available := false
var stage: Control
var composition: CanvasGroup
var matte: ColorRect
var panorama: Node2D
var actors: Array[AnimatedSprite2D] = []
var role_ids: Array[String] = []
var contacts: Array[Vector2] = []
var ground_fx: Node2D
var caption: Label
var wizard: Label
var title: Label
var fog: ColorRect
var exit_shade: ColorRect
var skip_button: Button
var _next_audible_step := 0.48
var _pilot_last_support := 0
var _v3_jack: AnimatedSprite2D
var _v3_jack_soles: Array[int] = []
var _v3_jack_height := 1.0
var _v3_hero_height := 1.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if data_path.is_empty(): data_path = preload("res://scripts/travel/travel_catalog.gd").resource_for(context)
	data = load(data_path) as Resource if ResourceLoader.exists(data_path) else null
	if data == null: return
	matte = ColorRect.new()
	matte.color = Color.BLACK
	matte.modulate.a = 0.0
	add_child(matte)
	stage = Control.new()
	stage.name = "TravelStage"
	stage.mouse_filter = Control.MOUSE_FILTER_STOP
	stage.size = Vector2(1280,720)
	add_child(stage)
	# Fade the flattened painting ONCE. Per-child inherited alpha exposes
	# overlapping cutout boundaries during a cross-dissolve over Event/Reward.
	composition = CanvasGroup.new()
	composition.self_modulate.a = 0.0
	composition.fit_margin = 2.0
	composition.clear_margin = 2.0
	stage.add_child(composition)
	if use_cinematic_v5:
		if _build_cinematic_v5():
			_build_exit_ui(str(data.title))
			available = true
			update_frame()
			return
	if data.panorama_script == null: return
	panorama = data.panorama_script.new()
	composition.add_child(panorama)
	panorama.build(data.background_path,data.foreground_path,data.underpaint_path,data.sky_path)
	if not panorama.available: return
	if panorama.has_method("configure"): panorama.call("configure",context)
	if not panorama.available: return
	fog = ColorRect.new()
	fog.position = data.fog_rect.position
	fog.size = data.fog_rect.size
	fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mist := ShaderMaterial.new()
	mist.shader = preload("res://shaders/travel_fog.gdshader")
	fog.material = mist
	panorama.add_child(fog)
	panorama.move_child(fog,panorama.planes.Midground.get_index())
	ground_fx = GROUND_FX.new()
	composition.add_child(ground_fx)
	for role in context.get("party_roles",[]):
		if role not in ["knight","ranger","mage"]: continue
		var frames: SpriteFrames = VIS.side_frames(role)
		if frames == null or not frames.has_animation("walk"): return
		var sprite := AnimatedSprite2D.new()
		sprite.sprite_frames = frames
		sprite.animation = "walk"
		sprite.texture_filter = VIS.frame_filter(frames)
		sprite.scale = Vector2.ONE * (1.80 if role == "knight" else 1.72) * float(data.party_scale)
		sprite.modulate = data.party_tint
		composition.add_child(sprite)
		actors.append(sprite)
		role_ids.append(role)
		contacts.append(Vector2.ZERO)
		_measure_soles(role,frames)
	if actors.is_empty(): return
	var scene_id := String(context.get("resolved_card_id", ""))
	# Batch 02/03 have scene-owned companion choreography. The seven earlier
	# panoramas use the shared follower, with the actual post-resolution flag.
	if V3.enabled(scene_id) and panorama.get("pilot_active") != true and bool(context.get("jack_companion", false)) and "ranger" in role_ids:
		var frames: SpriteFrames = VIS.side_frames("jack")
		if frames != null and frames.has_animation("walk"):
			_v3_jack = AnimatedSprite2D.new()
			_v3_jack.name = "TravelJack"
			_v3_jack.sprite_frames = frames
			_v3_jack.animation = "walk"
			_v3_jack.texture_filter = VIS.frame_filter(frames)
			_v3_jack_height = VIS.DOG_REFERENCE_PX
			for n in frames.get_frame_count("walk"):
				_v3_jack_soles.append(VIS.logical_image(frames.get_frame_texture("walk", n)).get_used_rect().end.y - 1)
			composition.add_child(_v3_jack)
	var foreground: Node2D = panorama.planes.Foreground
	foreground.reparent(composition,false)
	foreground.visible = true
	_build_exit_ui(str(data.title))
	available = true
	update_frame()

func _build_cinematic_v5() -> bool:
	var id := str(context.get("resolved_card_id", ""))
	# Only explicitly accepted scene IDs may replace their V4 presentation.
	if id != "curse_forge" and id not in LIVE_MERCHANT_IDS and id not in LIVE_ROAD_IDS: return false
	# Render the authored z-order into one texture. The existing CanvasGroup
	# can then cross-dissolve it once, keeping captions/skip above the movie.
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1280,720)
	viewport.world_2d = World2D.new()
	viewport.disable_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	stage.add_child(viewport)
	var film: Node2D
	if id == "curse_forge":
		film = FORGE_V5.new()
	elif id in LIVE_MERCHANT_IDS:
		film = MERCHANT_V5.new()
	else:
		film = ROAD_V5.new()
	viewport.add_child(film)
	var roles: Array = context.get("party_roles", [])
	var action := str(context.get("visual_action", ""))
	var jack := bool(context.get("jack_companion", false))
	var configured: bool
	if id == "curse_forge":
		configured = film.configure(roles, action, jack)
	else:
		configured = film.configure_scene(id, roles, action, jack)
	if not configured:
		# Nothing from a failed movie survives into the legacy overlay.
		viewport.free()
		return false
	if id == "curse_forge":
		forge_v5 = film
	elif id in LIVE_MERCHANT_IDS:
		merchant_v5 = film
	else:
		road_v5 = film
	var picture := TextureRect.new()
	picture.name = "ForgeV5Picture" if id == "curse_forge" else ("MerchantV5Picture" if id in LIVE_MERCHANT_IDS else "RoadV5Picture")
	picture.texture = viewport.get_texture()
	picture.size = stage.size
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	composition.add_child(picture)
	return true

func _build_exit_ui(scene_title: String) -> void:
	exit_shade = ColorRect.new()
	exit_shade.color = UI.VOID
	exit_shade.size = stage.size
	exit_shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	composition.add_child(exit_shade)
	_build_ui(scene_title)

func _build_ui(scene_title: String) -> void:
	var gradient := Gradient.new()
	gradient.set_color(0,Color(0.016,0.018,0.025,0))
	gradient.set_color(1,Color(0.016,0.018,0.025,0.88))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 2
	texture.height = 128
	texture.fill_from = Vector2(0,0)
	texture.fill_to = Vector2(0,1)
	var scrim := TextureRect.new()
	scrim.name = "NarrativeGradient"
	scrim.texture = texture
	scrim.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scrim.position = Vector2(0,584)
	scrim.size = Vector2(1280,136)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	composition.add_child(scrim)
	caption = text(str(context.get("narration_text","")),Vector2(160,622),Vector2(960,52),UI.TYPE_SECTION)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Liberation Serif","DejaVu Serif","Times New Roman"])
	caption.add_theme_font_override("font",serif)
	wizard = text(str(context.get("wizard_line","")),Vector2(180,682),Vector2(920,24),UI.TYPE_META)
	wizard.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wizard.add_theme_color_override("font_color",UI.TEXT_SECONDARY)
	title = text(scene_title,Vector2(52,34),Vector2(920,28),UI.TYPE_BODY)
	title.add_theme_color_override("font_color",UI.TEXT_SECONDARY)
	skip_button = Button.new()
	skip_button.text = "ПРОПУСТИТЬ · ESC"
	skip_button.position = Vector2(1072,30)
	skip_button.size = Vector2(164,34)
	UI.apply_action_button(skip_button,UI.AGED_BRONZE,false)
	skip_button.modulate.a = 0.78
	skip_button.add_theme_font_size_override("font_size",UI.TYPE_CAPTION)
	composition.add_child(skip_button)
	skip_button.pressed.connect(finish)

func text(value: String, pos: Vector2, dimensions: Vector2, points: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size",points)
	label.add_theme_color_override("font_color",UI.TEXT)
	label.add_theme_color_override("font_shadow_color",Color(0.01,0.01,0.02,0.95))
	label.add_theme_constant_override("shadow_offset_y",2)
	label.add_theme_constant_override("shadow_outline_size",2)
	composition.add_child(label)
	return label

static func _measure_soles(role: String, frames: SpriteFrames) -> void:
	if _soles.has(role): return
	var heights: Array[int] = []
	for frame in range(frames.get_frame_count("walk")):
		var image := VIS.logical_image(frames.get_frame_texture("walk",frame))
		var bottom := 80
		for y in range(image.get_height()-1,55,-1):
			var found := false
			for x in range(30,65):
				if image.get_pixel(x,y).a > 0.5:
					found = true
					break
			if found:
				bottom = y
				break
		heights.append(bottom)
	_soles[role] = heights

func _process(delta: float) -> void:
	if done or not available or get_tree().paused: return
	var previous := elapsed
	elapsed += delta
	update_frame()
	if elapsed >= duration():
		finish()
		return
	_play_travel_cues(previous)


func _play_travel_cues(previous: float) -> void:
	var film := _active_cinematic()
	if is_instance_valid(film):
		if film == forge_v5:
			for beat in forge_v5.strikes:
				if previous < beat and elapsed >= beat:
					SoundDirector.play_scene_cue(self, "metal", -10.0)
			if forge_v5.action != "leave" and previous < FORGE_V5.HANDOFF and elapsed >= FORGE_V5.HANDOFF:
				SoundDirector.play_scene_cue(self, "coins", -12.0)
		elif film == road_v5:
			# Match the accepted F6 road cues, including the silent detail shot.
			if previous < ROAD_V5.HANDOFF and elapsed >= ROAD_V5.HANDOFF:
				if road_v5.scene_id == "rattling_bridge" and road_v5.action in ["rush_failure", "recruit"]:
					SoundDirector.play_scene_cue(self, "creak", -15.0)
				elif road_v5.action in ["rush_success", "scavenge", "loot_recruitment", "rescue_gold", "pay_refund", "pay_upgrade", "pay_relic", "safe", "greedy", "all_in"]:
					SoundDirector.play_scene_cue(self, "coins", -12.0)
		elif previous < MERCHANT_V5.HANDOFF and elapsed >= MERCHANT_V5.HANDOFF:
			# Exact approved F6 cues, now using the common in-game Ambient bus.
			# Ledger refusal closes its book; other refusals have no purchase cue.
			if merchant_v5.scene_id == "blood_ledger" and merchant_v5.action != "gold":
				SoundDirector.play_scene_cue(self, "paper", -15.0)
			elif merchant_v5.action != "leave":
				SoundDirector.play_scene_cue(self, "coins", -12.0)
		var lead: Dictionary = film.current_frame[film.order[0]]
		var contact := int(float(lead.phase) / 3.0)
		if lead.clip == "walk" and contact != _cinematic_step and (film != road_v5 or road_v5.shot != "detail"):
			_cinematic_step = contact
			SoundDirector.play_scene_cue(self, "stone-step", -19.0)
		return
	var id := String(context.get("resolved_card_id", ""))
	if V3.enabled(id):
		_play_pilot_cues(previous, id)
		return
	if elapsed >= _next_audible_step and elapsed < duration() - 0.65:
		_next_audible_step = elapsed + 0.61
		SoundDirector.play_scene_cue(self, "wood-step" if id == "rattling_bridge" else "stone-step",
			-26.0, 1.03 if int(elapsed * 2) % 2 == 0 else 0.94)
	if previous < 0.92 and elapsed >= 0.92:
		var cue := _outcome_cue(id, String(context.get("visual_action", context.get("outcome_id", ""))))
		if not cue.is_empty():
			SoundDirector.play_scene_cue(self, cue, -23.0, 0.92)


func _play_pilot_cues(previous: float, id: String) -> void:
	# Read the same lead gait clock used by the visible actor and contact FX.
	# No accumulated timer drift, no queued steps after skip/pause.
	var lead := 0.0
	if panorama.get("pilot_active") == true:
		lead = float(panorama.pilot_lead_phase)
	elif not ground_fx.gait_phases.is_empty():
		lead = float(ground_fx.gait_phases[0])
	var support := V3.support_index(lead)
	if support > _pilot_last_support and elapsed > 0.36 and elapsed < duration() - 0.20:
		SoundDirector.play_scene_cue(self, "wood-step" if id == "rattling_bridge" else "stone-step",
			-26.0, 1.03 if support % 2 == 0 else 0.94)
	_pilot_last_support = support
	var action := String(context.get("visual_action", context.get("outcome_id", "")))
	var beat := V3.action_time(id, action)
	if previous < beat and elapsed >= beat:
		var cue := V3.action_cue(id, action)
		if not cue.is_empty():
			SoundDirector.play_scene_cue(self, cue, -23.0, 0.92)


func _outcome_cue(id: String, action: String) -> String:
	if action in ["passed", "leave", "untouched", "abandon", "careful", "leave_lost"] or action.is_empty():
		return ""
	match id:
		"unsent_letters", "blood_ledger", "banner_seamstress", "faceless_card": return "paper"
		"lost_purse", "gravedigger_shop", "candle_seller": return "coins"
		"wizard_tithe": return "coins" if action == "gold" else ""
		"debtor_bones": return "dice" if action.begins_with("gamble") else "bones"
		"chained_prisoner", "broken_crown", "curse_forge", "last_signal": return "metal"
		"rattling_bridge": return "creak"
		"false_weights": return "stone-door" if action == "fair" else "coins"
		"echo_crypt", "bone_tax": return "stone-door"
	return ""

func _active_cinematic() -> Node2D:
	if is_instance_valid(forge_v5): return forge_v5
	if is_instance_valid(merchant_v5): return merchant_v5
	return road_v5 if is_instance_valid(road_v5) else null

func duration() -> float:
	if is_instance_valid(_active_cinematic()):
		return FORGE_V5.DURATION
	return clampf(float(context.get("duration_sec",4.0)),3.0,5.0)

func update_frame() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var fit := minf(viewport_size.x / 1280.0,viewport_size.y / 720.0)
	stage.scale = Vector2.ONE * fit
	stage.position = (viewport_size - Vector2(1280,720)*fit) * 0.5
	matte.size = viewport_size
	var time := minf(elapsed,duration())
	var film := _active_cinematic()
	if is_instance_valid(film):
		film.seek(time)
		_update_exit_ui(time)
		return
	panorama.update_time(time,duration())
	if panorama.has_method("stage_party"):
		# Scene-local presentation, using the existing clock/actors/contact FX.
		panorama.stage_party(actors,role_ids,contacts,ground_fx,time,duration(),data)
	elif str(context.get("resolved_card_id", "")) == "unsent_letters":
		var frames := {}
		for role in role_ids:
			frames[role] = VIS.side_frames(role)
		STAGING.stage_legacy("unsent_letters", actors, role_ids, contacts, ground_fx, time, duration(), panorama.planes.Road.position - Vector2(-32,-18), data, frames, _soles)
	else:
		var v3 := V3.enabled(str(context.get("resolved_card_id", "")))
		if v3:
			ground_fx.gait_phases.resize(actors.size())
			ground_fx.contact_scales.resize(actors.size())
		for i in range(actors.size()):
			var sprite := actors[i]
			var phase := time * WALK_FPS + i * 1.1
			if v3:
				var height := V3.walk_height(sprite.sprite_frames) * sprite.scale.y if not ground_fx.gait_tracks.has(i) else 1.0
				var road_speed: float = float(panorama.speeds.Road)
				var path := func(t: float) -> Vector2: return Vector2(t * (BODY_SPEED + road_speed), 0)
				var stature := func(_p: Vector2) -> float: return height
				phase = V3.actor_phase(ground_fx, i, time, duration(), path, stature)
				ground_fx.contact_scales[i] = sprite.scale.y * 0.62
			sprite.frame = int(phase) % sprite.sprite_frames.get_frame_count("walk")
			# Held support poses follow the road; advance on the next authored pose.
			var plant := 0.0 if v3 else (BODY_SPEED + float(panorama.speeds.Road)) * fposmod(phase,1.0) / WALK_FPS
			var foot := Vector2(data.party_origin.x + time * BODY_SPEED - i * data.party_spacing - plant,data.party_origin.y + i * data.party_depth_step)
			if actors.size() == 1: foot.x += data.party_solo_offset
			sprite.position = foot - Vector2(0,(_soles[role_ids[i]][sprite.frame]-48)*sprite.scale.y)
			contacts[i] = foot
	if is_instance_valid(_v3_jack):
		_stage_legacy_companion()
	ground_fx.update_contacts(contacts,time)
	(fog.material as ShaderMaterial).set_shader_parameter("elapsed",time)
	_update_exit_ui(time)

func _update_exit_ui(time: float) -> void:
	composition.self_modulate.a = smoothstep(0.0,0.36,time)
	matte.modulate.a = composition.self_modulate.a
	var leave := smoothstep(duration()-0.60,duration()-0.15,time)
	exit_shade.modulate.a = leave * 0.36
	var text_alpha := smoothstep(0.52,0.92,time) * (1.0-smoothstep(duration()-0.65,duration()-0.18,time))
	caption.modulate.a = text_alpha
	wizard.modulate.a = text_alpha * 0.85
	title.modulate.a = 1.0 - smoothstep(2.1,3.2,time) * 0.5

func _stage_legacy_companion() -> void:
	var i := role_ids.find("ranger")
	var ranger := actors[i]
	_v3_jack.visible = ranger.visible
	if _v3_hero_height <= 1.0:
		_v3_hero_height = V3.walk_height(ranger.sprite_frames)
	var projected := _v3_hero_height * ranger.scale.y
	var direction: Vector2 = ground_fx.dust_direction.normalized()
	var foot := contacts[i] + (direction * 0.29 + Vector2(0, 0.10)) * projected
	var phase: float = ground_fx.gait_phases[i] * 1.30
	_v3_jack.frame = int(phase) % _v3_jack_soles.size()
	_v3_jack.scale = Vector2.ONE * projected * VIS.DOG_HUMAN_RATIO / _v3_jack_height
	_v3_jack.flip_h = direction.x > 0.0
	_v3_jack.position = foot - Vector2(0, (_v3_jack_soles[_v3_jack.frame] - 48.0) * _v3_jack.scale.y)
	_v3_jack.modulate = ranger.modulate
	_v3_jack.set_meta("sole_y", foot.y)
	var order: Array[Node2D] = []
	for j in actors.size():
		actors[j].set_meta("sole_y", contacts[j].y)
		order.append(actors[j])
	order.append(_v3_jack)
	order.sort_custom(func(a: Node2D, b: Node2D) -> bool: return float(a.get_meta("sole_y")) < float(b.get_meta("sole_y")))
	for j in order.size():
		composition.move_child(order[j], ground_fx.get_index() + 1 + j)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_SPACE,KEY_ENTER,KEY_KP_ENTER,KEY_ESCAPE]:
		get_viewport().set_input_as_handled()
		finish()

func finish() -> void:
	if done: return
	done = true
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
	finished.emit()
