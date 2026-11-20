extends Control

const LIB := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT := preload("res://scenes/battle/unit.tscn")
const QA_SESSION := preload("res://scripts/dev/qa_hub_session.gd")
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const STATES := ["idle", "walk", "attack", "hit", "death"]
const COUNTS := [4, 6, 6, 3, 6]
const ENCOUNTER_BY_ROLE := {
	"skeleton": "bone_patrol", "bone_archer": "gallows_volley", "bone_thrall": "bone_crush",
	"grave_bellkeeper": "grave_bell", "crypt_guard": "crypt_guard", "bone_warden": "bone_warden",
	"bone_shepherd": "bone_shepherd", "ossuary_lamb": "bone_shepherd",
	"funeral_priest": "funeral_procession", "pallbearer": "funeral_procession",
	"plague_alchemist": "defiled_laboratory", "unstable_homunculus": "defiled_laboratory",
	"threadbare_puppeteer": "threadbare_theatre", "bone_marionette": "threadbare_theatre",
	"drowned_ferryman": "black_crossing", "drowned_hand": "black_crossing",
	"road_sentinel": "black_lantern_road", "lantern_bearer": "black_lantern_road",
	"extinguished_guide": "black_lantern_road", "oil_acolyte": "black_lantern_road", "lantern_archer": "black_lantern_road",
	"mute_magistrate": "court_of_the_mute", "ash_scrivener": "court_of_the_mute", "bone_bailiff": "court_of_the_mute",
}

var roles := LIB.ROLES.slice(3)
var role_index := 0
var state_index := 0
var clock := 0.0
var playing := true
var actors: Array[BattleUnit] = []
var heroes: Array[BattleUnit] = []
var stage := Node2D.new()
var backdrop: TextureRect
var picker := OptionButton.new()
var party := OptionButton.new()
var timeline := Label.new()
var playback: Button
var battle: Control
var battle_tools: CanvasLayer
var using_candidate := true
var comparison := Control.new()

func _ready() -> void:
	_build()
	_select_role(0)
	var args := OS.get_cmdline_user_args()
	if args.size() == 1:
		_capture.call_deferred(args[0])

func _build() -> void:
	comparison.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(comparison)
	backdrop = preload("res://scripts/battle/authored_backdrop.gd").new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	comparison.add_child(backdrop)
	var shade := ColorRect.new()
	shade.color = Color(0.08, 0.06, 0.06, 0.58)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	comparison.add_child(shade)
	comparison.add_child(stage)
	var title := _label("MISDEAL · ВРАГИ D420", Vector2(45,26), 30)
	title.add_theme_color_override("font_color", Color("e9ca93"))
	var selectors := _bar(Vector2(45,86))
	_button(selectors, "‹", func(): _select_role(posmod(role_index-1, roles.size())))
	for id: String in roles:
		var resource := load("res://resources/units/"+id+".tres") as UnitData
		picker.add_item(resource.unit_name)
	picker.custom_minimum_size.x = 280
	picker.item_selected.connect(_select_role)
	selectors.add_child(picker)
	_button(selectors, "›", func(): _select_role(posmod(role_index+1, roles.size())))
	_button(selectors, "Бой · Было", _open_battle.bind(false))
	_button(selectors, "Бой · Стало", _open_battle.bind(true), true)
	for size_label in ["Solo","Duo","Trio"]:
		party.add_item(size_label)
	party.select(2)
	selectors.add_child(party)
	var clips := _bar(Vector2(45,144))
	for i in range(STATES.size()):
		_button(clips, ["Покой", "Ходьба", "Атака", "Попадание", "Смерть"][i], _select_clip.bind(i))
	_label("БЫЛО", Vector2(219,283), 23)
	_label("СТАЛО", Vector2(985,283), 23)
	_label("ГЕРОИ D412",Vector2(588,283),18)
	var controls := _bar(Vector2(45,650))
	playback = _button(controls,"Пауза",_toggle_play)
	_button(controls,"Повтор",_repeat)
	_button(controls,"Кадр ‹",_step.bind(-1))
	_button(controls,"Кадр ›",_step.bind(1))
	controls.add_child(timeline)
	for i in range(3):
		heroes.append(_actor(LIB.C3_HERO_ROLES[i], 0, Vector2(514+i*126,505), false))

func _button(parent: Control, title: String, action: Callable, primary := false) -> Button:
	var button := Button.new()
	button.text = title
	button.custom_minimum_size = Vector2(46, 38)
	DS3.apply_action(button,primary)
	parent.add_child(button)
	button.pressed.connect(action)
	return button

func _bar(at: Vector2) -> HBoxContainer:
	var bar := HBoxContainer.new()
	bar.position = at
	bar.add_theme_constant_override("separation", 8)
	comparison.add_child(bar)
	return bar

func _label(value: String, at: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.add_theme_font_size_override("font_size",font_size)
	comparison.add_child(label)
	return label

func _actor(role: String, team: int, at: Vector2, polished: bool) -> BattleUnit:
	var actor := UNIT.instantiate() as BattleUnit
	actor.configure(load("res://resources/units/"+role+".tres"),team,at)
	actor.use_polished_enemy_art = polished
	stage.add_child(actor)
	actor.set_process(false)
	actor.set_physics_process(false)
	return actor

func _select_role(index: int) -> void:
	role_index = index
	picker.select(index)
	var role: String = roles[index]
	var encounter := load("res://resources/encounters/"+ENCOUNTER_BY_ROLE[role]+".tres") as EncounterData
	backdrop.set_arena_id(encounter.arena_id,encounter.encounter_id)
	backdrop.set_living_paused(true)
	for actor in actors:
		stage.remove_child(actor)
		actor.queue_free()
	var line := 473.0 if encounter.arena_id == "black_crossing" else 507.0
	for hero in heroes:
		hero.position.y = line
	actors.assign([_actor(role,1,Vector2(255,line),false),_actor(role,1,Vector2(1020,line),true)])
	_repeat()

func _select_clip(index: int) -> void:
	state_index = index
	_repeat()

func _toggle_play() -> void:
	playing = not playing
	playback.text = "Пауза" if playing else "Продолжить"

func _repeat() -> void:
	clock = 0.0
	_show_frame()

func _step(direction: int) -> void:
	if playing: _toggle_play()
	var fps := _fps()
	var index := posmod(int(clock*fps+0.00001)+direction, COUNTS[state_index])
	clock = (float(index)+0.001)/fps
	_show_frame()

func _fps() -> float:
	return actors[-1].sprite_frames.get_animation_speed(STATES[state_index])

func _process(delta: float) -> void:
	if not playing or actors.is_empty() or is_instance_valid(battle):
		return
	clock = fmod(clock+delta, float(COUNTS[state_index])/_fps() + (0.6 if state_index >= 2 else 0.0))
	_show_frame()

func _show_frame() -> void:
	var clip: String = STATES[state_index]
	var index := mini(int(clock*_fps()),COUNTS[state_index]-1)
	timeline.text = "  %s · %d/%d" % [clip.to_upper(), index+1, COUNTS[state_index]]
	for actor in actors:
		if actor.sprite_frames == null: continue
		var frame := mini(index, actor.sprite_frames.get_frame_count(clip)-1)
		actor.art_sprite.texture = actor.sprite_frames.get_frame_texture(clip,frame)
		actor._sync_rim_visual()

func _open_battle(polished: bool) -> void:
	var session := QA_SESSION.ensure(self)
	if not session.available: return
	using_candidate = polished
	if is_instance_valid(battle):
		remove_child(battle)
		battle.queue_free()
		battle_tools.queue_free()
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var companions := ["ranger","mage"]
	for i in range(party.selected):
		RunState.recruit_companion(companions[i],"D420 QA")
	var encounter_id: String = ENCOUNTER_BY_ROLE[roles[role_index]]
	RunState.active_card_id = encounter_id
	if encounter_id == "bone_warden": RunState.cards_resolved = 12
	RunState.select_encounter("res://resources/encounters/"+encounter_id+".tres")
	seed(420)
	comparison.hide()
	battle = load("res://scenes/battle/battle.tscn").instantiate()
	battle.use_polished_enemy_art = polished
	add_child(battle)
	battle_tools = CanvasLayer.new()
	battle_tools.layer = 20
	add_child(battle_tools)
	var strip := HBoxContainer.new()
	strip.position = Vector2(457,140)
	battle_tools.add_child(strip)
	_button(strip,"← К сравнению",_close_battle)
	_button(strip,"Повтор · F9",replay_qa_battle)

func _close_battle() -> void:
	remove_child(battle)
	battle.queue_free()
	battle = null
	battle_tools.queue_free()
	comparison.show()

func replay_qa_battle() -> bool:
	if not is_instance_valid(battle):
		_repeat()
	else:
		_open_battle(using_candidate)
	return true

func qa_toolbar_visible() -> bool:
	return is_instance_valid(battle) and battle.battle_finished

func _capture(output: String) -> void:
	DirAccess.make_dir_recursive_absolute(output)
	if playing: _toggle_play()
	for i in range(roles.size()):
		_select_role(i)
		_select_clip(0)
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var result := get_viewport().get_texture().get_image().save_webp(output.path_join(roles[i]+"_native.webp"), true, 0.92)
		assert(result == OK)
	print("ENEMY_REVIEW_CAPTURE_PASS: 24 side-by-side native comparisons")
	get_tree().quit()
