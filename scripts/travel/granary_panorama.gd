extends Node2D
## Scene05 keeps the connected granary rigid; floor alone supplies mild depth.
const DIR := "res://assets/pixel/travel/dead_rations_granary/"
const SOURCE_SIZE := Vector2(1672,941)
const PROJECTION := Vector2(1344.0/1672.0,757.0/941.0)
const ORIGIN := Vector2(-32,-18)
const TEXTURES := preload("res://scripts/travel/campfire_panorama.gd")
var available := false
var planes: Dictionary = {}
var speeds := {"Sky":1.4,"Midground":1.4,"Road":2.8,"Storage":1.4,"Foreground":1.4}
var rectangles: Dictionary = {}
var hall_material: ShaderMaterial
var storage: Sprite2D
var spilled_grain: Sprite2D
var ledger: Sprite2D
var reactions: Node2D
var outcome := "passed"
var walk := preload("res://scripts/travel/granary_walk.gd").new()
func build(background: String, foreground: String, _underpaint: String, _sky: String) -> void:
	for file in [background,foreground,DIR+"floor.png",DIR+"storage_fair.png",DIR+"bribe_silence.png",DIR+"floor_fair.png",DIR+"ledger_fair.png",DIR+"clean_coins.png"]:
		if TEXTURES.texture_at(file)==null: return
	if not FileAccess.file_exists(DIR+"layers.json"): return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR+"layers.json"))
	if not parsed is Dictionary: return
	rectangles=parsed
	for id in ["floor","storage_fair","bribe_silence","ledger_fair","floor_fair","clean_coins","foreground"]:
		if not rectangles.get(id) is Array or rectangles[id].size()!=4: return
	for id in speeds:
		var plane := Node2D.new()
		plane.name=id
		add_child(plane)
		planes[id]=plane
	var hall := _add("Midground",TEXTURES.texture_at(background),Vector2.ZERO)
	hall_material=ShaderMaterial.new()
	hall_material.shader=preload("res://shaders/granary_layer.gdshader")
	hall.material=hall_material
	_piece("Road","floor")
	spilled_grain=_piece("Road","floor_fair")
	storage=_piece("Storage","storage_fair")
	_piece("Foreground","foreground")
	_piece("Foreground","clean_coins")
	ledger=_piece("Foreground","ledger_fair")
	reactions=preload("res://scripts/travel/granary_reactions.gd").new()
	reactions.scale=PROJECTION
	planes.Foreground.add_child(reactions)
	reactions.build(TEXTURES.texture_at(DIR+"bribe_silence.png"),rectangles.bribe_silence)
	available=walk.build()
	update_time(0,4)
func _add(plane: String, texture: Texture2D, source_pos: Vector2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture=texture
	sprite.centered=false
	sprite.position=source_pos*PROJECTION
	sprite.scale=PROJECTION
	sprite.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	planes[plane].add_child(sprite)
	return sprite
func _piece(plane: String, id: String) -> Sprite2D:
	return _add(plane,TEXTURES.texture_at(DIR+id+".png"),Vector2(rectangles[id][0],rectangles[id][1]))
func configure(context: Dictionary) -> void:
	outcome=str(context.get("outcome_id","passed"))
	if outcome not in ["fair","silence","passed"]: outcome="passed"
	storage.visible=outcome=="fair"
	spilled_grain.visible=storage.visible
	ledger.visible=storage.visible
	reactions.outcome=outcome
	hall_material.set_shader_parameter("passed",outcome=="passed")
	hall_material.set_shader_parameter("fair",outcome=="fair")
func update_time(time: float, duration: float) -> void:
	for id in planes: planes[id].position=ORIGIN-Vector2(float(speeds[id])*(time-duration*0.5),0)
	if hall_material!=null: hall_material.set_shader_parameter("elapsed",time)
	if reactions!=null: reactions.update_time(time)
func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, layout: Resource) -> void:
	walk.stage(actors,roles,contacts,ground,time,duration,planes.Road.position-ORIGIN,layout)
