extends Control

const LIB := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT := preload("res://scenes/battle/unit.tscn")
const STATES := ["idle", "walk", "attack", "hit", "death"]
var page := 0
var state := "idle"
var actors: Array[BattleUnit] = []
var body := Node2D.new()
var caption := Label.new()

func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color("17191c")
	background.size = Vector2(1280,720)
	add_child(background)
	add_child(body)
	caption.position = Vector2(25,15)
	caption.add_theme_font_size_override("font_size",24)
	add_child(caption)
	for i in range(STATES.size()):
		var button := Button.new()
		button.text = STATES[i].to_upper()
		button.position = Vector2(25 + i*160,55)
		button.size = Vector2(150,35)
		button.pressed.connect(_change_state.bind(STATES[i]))
		add_child(button)
	var next := Button.new()
	next.text = "Следующие 6 врагов →"
	next.position = Vector2(870,55)
	next.size = Vector2(300,35)
	next.pressed.connect(func(): page = (page+1)%4; _rebuild())
	add_child(next)
	_rebuild()
	if OS.get_cmdline_user_args().size() == 1:
		_capture(OS.get_cmdline_user_args()[0])

func _rebuild() -> void:
	for actor in actors:
		body.remove_child(actor)
		actor.queue_free()
	actors.clear()
	caption.text = "MISDEAL / ВРАГИ %d–%d / %s / реальный масштаб BattleUnit" % [page*6+1,page*6+6,state]
	var roles: Array = LIB.ROLES.slice(3)
	for i in range(6):
		_add_actor(roles[page*6+i],1,Vector2(130+i*200,340))
	for i in range(3):
		_add_actor(["knight","ranger","mage"][i],0,Vector2(440+i*200,590))
	_change_state(state)

func _add_actor(role: String, team: int, at: Vector2) -> void:
	var actor := UNIT.instantiate() as BattleUnit
	var data := load("res://resources/units/"+role+".tres") as UnitData
	actor.configure(data,team,at)
	actor.set_meta("review_origin",at)
	body.add_child(actor)
	actor.set_process(false)
	actor.set_physics_process(false)
	actor.show_enemy_name = true
	actor.name_label.show()
	actor.name_label.text = role
	actors.append(actor)

func _change_state(value: String) -> void:
	state=value
	for actor in actors:
		actor.position=actor.get_meta("review_origin")
		actor.c3_walk_has_sample=false
		actor.frame_state=state
		actor.frame_time=0
		actor.frame_one_shot_time=10000
	caption.text = "MISDEAL / ВРАГИ %d–%d / %s / реальный масштаб BattleUnit" % [page*6+1,page*6+6,state]

func _process(delta: float) -> void:
	for actor in actors:
		if state == "walk":
			actor.position.x += (-40.0 if actor.team == 1 else 40.0) * delta
			var origin: Vector2 = actor.get_meta("review_origin")
			if absf(actor.position.x-origin.x)>36.0:
				actor.position.x=origin.x+(36.0 if actor.team == 1 else -36.0)
				actor.c3_walk_last_position=actor.position
		actor._update_frame_animation(delta)
		if actor.frame_time > 1.8:
			actor.frame_time=0
		actor._sync_rim_visual()

func _capture(output: String) -> void:
	DirAccess.make_dir_recursive_absolute(output)
	for p in range(4):
		page=p
		_rebuild()
		for clip in STATES:
			_change_state(clip)
			var delay: float = {"death":0.56,"walk":0.85,"attack":0.24,"hit":0.12,"idle":0.26}[clip]
			await get_tree().create_timer(delay).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(output.path_join("page_%d_%s.png" % [p,clip]))
	print("ENEMY_REVIEW_CAPTURE_PASS: 24 real enemy roles, five states, hero scale references")
	get_tree().quit()
