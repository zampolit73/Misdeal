extends Node2D
## One bird, one carried envelope, no progression/state writes and no timers.
var outcome := "passed"
var available := false
var bird: Sprite2D
var letter: Sprite2D
var paper: Sprite2D
var beaks: Array = []
var launch_count := 0
var _launched := false
const PERCH := Vector2(770,218)
const REST := Vector2(770,172)

func build(bird_texture: Texture2D, paper_texture: Texture2D, original: Texture2D) -> void:
	if bird_texture == null or paper_texture == null or original == null: return
	var path := "res://assets/pixel/travel/last_dawn_posthouse/beaks.json"
	if not FileAccess.file_exists(path): return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not parsed is Array: return
	beaks = parsed
	if beaks.size()!=20: return
	for point in beaks:
		if not point is Array or point.size()!=2: return
	bird = Sprite2D.new()
	bird.name = "BonePigeon"
	bird.texture = bird_texture
	bird.hframes = 5
	bird.vframes = 4
	bird.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(bird)
	letter = Sprite2D.new()
	letter.name = "SingleEnvelope"
	letter.texture = original
	letter.region_enabled = true
	letter.region_rect = Rect2(506,528,76,32)
	letter.scale = Vector2.ONE * 0.40
	bird.add_child(letter)
	paper = Sprite2D.new()
	paper.name = "OpenedLetter"
	paper.texture = paper_texture
	paper.hframes = 4
	paper.scale = Vector2(0.64,0.48)
	paper.rotation = 0.11
	paper.position = Vector2(541,546)
	add_child(paper)
	available = true

func update_time(time: float) -> void:
	if not available: return
	paper.visible = outcome=="read"
	var flutter := [0,1,2,3,2,1]
	paper.frame = flutter[int(time*4.0)%flutter.size()]
	paper.rotation = 0.11 + sin(time*1.6)*0.015
	bird.visible = true
	bird.modulate.a = 1.0
	bird.scale = Vector2.ONE * 0.62
	bird.position = REST
	letter.visible = outcome=="release"
	bird.frame = int(time*1.7)%4
	if outcome != "release": return
	if time < 0.65:
		bird.frame = mini(int(time*5.0),3)
	elif time < 1.4:
		bird.frame = 4 + mini(int((time-0.65)*8.0),5)
		var lift := smoothstep(0.85,1.4,time)
		bird.position = REST + Vector2(35,-44)*lift
	else:
		if not _launched:
			_launched = true
			launch_count += 1
		bird.frame = 10 + int((time-1.4)*24.0)%10
		var u := clampf((time-1.4)/1.9,0,1)
		bird.position = (REST+Vector2(35,-44)).bezier_interpolate(Vector2(880,75),Vector2(980,225),Vector2(1110,349),u)
		bird.scale = Vector2.ONE * lerpf(0.62,0.15,u)
		bird.modulate.a = 1.0-smoothstep(2.95,3.50,time)
		bird.visible = time < 3.50
	var beak: Array = beaks[bird.frame]
	var target := Vector2(float(beak[0])+2,float(beak[1])+5)
	var on_perch := (PERCH+Vector2(22,4)-bird.position)/bird.scale
	letter.position = on_perch.lerp(target,smoothstep(0.64,1.02,time))
	letter.rotation = sin(time*2.1)*0.10
