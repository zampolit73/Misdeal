extends Node2D
const FORGE := preload("res://scripts/travel/cinematic_v5/relic_v5.gd")
const SCENES := ["Стол невыплаченных долгов","Чаша под открытым небом","Пустое место последнего властителя"]
var scene_index := 0
const PARTIES := [["knight"],["ranger"],["mage"],["knight","ranger"],["knight","mage"],["ranger","mage"],["knight","ranger","mage"]]
const TITLES := {
	"gamble_success":"Игра в кости — удача","gamble_failure":"Игра в кости — проигрыш",
	"safe":"Безопасная сделка","break":"Разбить","leave":"Пройти мимо",
	"gold":"Отдать золото","blood":"Отдать кровь","refuse":"Отказаться",
	"wear":"Надеть корону","melt":"Расплавить корону"
}
var stage: Node2D
var party_index := 6
var action := "gamble_success"
var companion := false
var paused := false
var muted := false
var clock := 0.0
var readout: Label
var controls: CanvasLayer
var fade: ColorRect
var metal: AudioStreamPlayer
var coins: AudioStreamPlayer
var step: AudioStreamPlayer
var cloth: AudioStreamPlayer
var dice: AudioStreamPlayer
var bones: AudioStreamPlayer
var ambience: AudioStreamPlayer
var last_step := -1
var finished := false

func _ready() -> void:
	var session := get_node_or_null("/root/QAHubSession")
	if session != null:
		var saved: Array = session.last_options.get("roles",PARTIES[6])
		var index := PARTIES.find(saved)
		if index >= 0: party_index = index
	controls = CanvasLayer.new()
	controls.layer = 210
	add_child(controls)
	var panel := ColorRect.new()
	panel.color = Color(0.025,0.019,0.015,0.88)
	panel.position = Vector2(12,12)
	panel.size = Vector2(1256,64)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.add_child(panel)
	readout = Label.new()
	readout.position = Vector2(24,18)
	readout.add_theme_color_override("font_color",Color("#ead5b5"))
	readout.add_theme_font_size_override("font_size",14)
	controls.add_child(readout)
	var movie_overlay := CanvasLayer.new()
	movie_overlay.layer = 100
	add_child(movie_overlay)
	fade = ColorRect.new()
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.color = Color.BLACK
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	movie_overlay.add_child(fade)
	metal = _audio("metal.ogg",-15.0)
	coins = _audio("coins.ogg",-12.0)
	step = _audio("stone-step.ogg",-19.0)
	cloth = _audio("cloth-hit.ogg",-22.0)
	dice = _audio("dice.ogg",-13.0)
	bones = _audio("bones.ogg",-15.0)
	ambience = _audio("dungeon.ogg",-26.0)
	_replay()

func _audio(file: String, volume: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = AudioStreamOggVorbis.load_from_file("res://assets/audio/act1/"+file)
	player.volume_db = volume
	add_child(player)
	return player

func _replay() -> void:
	if is_instance_valid(stage):
		remove_child(stage)
		stage.free()
	stage = FORGE.new()
	add_child(stage)
	var valid := FORGE.relic_actions(FORGE.RELIC_IDS[scene_index],PARTIES[party_index])
	if valid.is_empty():
		party_index = 6
		valid = FORGE.relic_actions(FORGE.RELIC_IDS[scene_index],PARTIES[party_index])
	if action not in valid: action = valid[0]
	paused = false
	finished = false
	clock = 0.0
	last_step = -1
	for p in [metal,coins,step,cloth,dice,bones,ambience]:
		p.stop()
		p.stream_paused = false
	if not stage.configure_scene(FORGE.RELIC_IDS[scene_index],PARTIES[party_index],action,companion):
		readout.text = "Не удалось загрузить пилот. Проверьте импорт ресурсов."
		finished = true
		fade.color.a = 0.0
		return
	ambience.stream=AudioStreamOggVorbis.load_from_file("res://assets/audio/act1/"+("dungeon.ogg" if scene_index==0 else "wind.ogg"))
	if ambience.stream!=null:
		ambience.stream.loop=true
		_start_ambience()
	_sample(0.0)
	_update_label()

func _start_ambience() -> void:
	# Headless preview controls are tested without starting decoder threads.
	if DisplayServer.get_name()=="headless" or paused or muted or finished or ambience.stream==null or ambience.playing: return
	ambience.play()

func _update_label() -> void:
	readout.text = "TRAVEL V5 · %s · %s · %s · %.1f/%.1f%s\nZ/X сцена  ·  ←/→ исход  ·  1/2/3 отряд  ·  Q/E состав  ·  P пауза  ·  R повтор  ·  J спутник  ·  H интерфейс  ·  M звук" % [SCENES[scene_index],TITLES[action]," / ".join(PARTIES[party_index]),clock,FORGE.DURATION," · ПАУЗА" if paused else ""]

func _sample(t: float) -> void:
	clock = clampf(t,0.0,FORGE.DURATION)
	stage.seek(clock)
	fade.color.a = 1.0-smoothstep(0.0,0.32,clock)

func _process(delta: float) -> void:
	if not is_instance_valid(stage) or not stage.available or paused or finished: return
	var before := clock
	_sample(clock+delta)
	if not muted:
		if before<FORGE.DETAIL_IN and clock>=FORGE.DETAIL_IN and action.begins_with("gamble") and dice.stream!=null: dice.play()
		if before<FORGE.HANDOFF and clock>=FORGE.HANDOFF:
			if action in ["gold","safe","gamble_success"] and coins.stream!=null: coins.play()
			elif action=="break" and scene_index==0 and bones.stream!=null: bones.play()
			elif action in ["break","melt","wear","refuse"] and metal.stream!=null: metal.play()
			elif action in ["blood","gamble_failure"] and cloth.stream!=null: cloth.play()
		var lead: Dictionary = stage.current_frame[stage.order[0]]
		var contact := int(float(lead.phase)/3.0)
		if stage.world.visible and lead.clip=="walk" and contact!=last_step:
			last_step=contact
			if step.stream!=null: step.play()
	if clock >= FORGE.DURATION:
		# Hold the final state for inspection instead of forcing a loop.
		finished = true
		ambience.stop()
		fade.color.a = 0.0
	_update_label()

func _cycle_action(delta: int) -> void:
	var valid := FORGE.relic_actions(FORGE.RELIC_IDS[scene_index],PARTIES[party_index])
	action = valid[posmod(valid.find(action)+delta,valid.size())]
	_replay()

func _select_count(count: int) -> void:
	var indices: Array[int] = []
	for i in PARTIES.size():
		if PARTIES[i].size()==count and not FORGE.relic_actions(FORGE.RELIC_IDS[scene_index],PARTIES[i]).is_empty(): indices.append(i)
	var old := indices.find(party_index)
	party_index = indices[posmod(old+1,indices.size())]
	_replay()

func _cycle_party(delta: int) -> void:
	for _n in PARTIES.size():
		party_index = posmod(party_index+delta,PARTIES.size())
		if not FORGE.relic_actions(FORGE.RELIC_IDS[scene_index],PARTIES[party_index]).is_empty():
			_replay()
			return

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	match event.keycode:
		KEY_Z: scene_index=posmod(scene_index-1,FORGE.RELIC_IDS.size()); _replay()
		KEY_X: scene_index=posmod(scene_index+1,FORGE.RELIC_IDS.size()); _replay()
		KEY_LEFT: _cycle_action(-1)
		KEY_RIGHT: _cycle_action(1)
		KEY_1: _select_count(1)
		KEY_2: _select_count(2)
		KEY_3: _select_count(3)
		KEY_Q: _cycle_party(-1)
		KEY_E: _cycle_party(1)
		KEY_R: _replay()
		KEY_P:
			paused=not paused
			for player in [metal,coins,step,cloth,dice,bones,ambience]: player.stream_paused=paused
			_start_ambience()
			_update_label()
		KEY_J:
			companion=not companion; _replay()
		KEY_H: controls.visible=not controls.visible
		KEY_M:
			muted=not muted
			if muted:
				for player in [metal,coins,step,cloth,dice,bones,ambience]: player.stop()
			else: _start_ambience()
		KEY_SPACE: _replay()

func qa_toolbar_visible() -> bool:
	return controls.visible

func _exit_tree() -> void:
	for player in [metal,coins,step,cloth,dice,bones,ambience]:
		if is_instance_valid(player):
			player.stop()
			player.stream = null
