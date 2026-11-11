extends Node2D
## Scene03 implements the existing V2 panorama contract; no gameplay state.
const DIR := "res://assets/pixel/travel/last_dressing_station/"
const PROJECTION := Vector2(1344.0/1672.0,757.0/941.0)
const ORIGIN := Vector2(-32,-18)
const REACTIONS := preload("res://scripts/travel/dressing_station_reactions.gd")
static var _textures: Dictionary = {}
var available := false
var planes: Dictionary = {}
var speeds := {"Sky":0.2,"DistantBattlefield":0.8,"Midground":4.0,"Road":10.0,"Foreground":14.0}
var rectangles: Dictionary = {}
var materials: Array[ShaderMaterial] = []
var station: Sprite2D
var reactions: Node2D
var outcome := "passed"
var walk := preload("res://scripts/travel/dressing_station_walk.gd").new()

static func texture_at(path: String) -> Texture2D:
	if _textures.has(path): return _textures[path]
	if not FileAccess.file_exists(path): return null
	var image := Image.new()
	if image.load_png_from_buffer(FileAccess.get_file_as_bytes(path))!=OK: return null
	var texture := ImageTexture.create_from_image(image)
	_textures[path] = texture
	return texture

func build(background: String, foreground: String, underpaint: String, sky: String) -> void:
	var required := [background,foreground,underpaint,sky,DIR+"distant_battlefield.png",DIR+"road.png",DIR+"scissors.png",DIR+"scrap.png",DIR+"bandage_rolls.png"]
	for variant in ["passed","standard","bandages"]:
		required.append(DIR+"station_"+variant+".png")
	for path in required:
		if texture_at(path)==null: return
	if not FileAccess.file_exists(DIR+"layers.json"): return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR+"layers.json"))
	if not parsed is Dictionary: return
	rectangles = parsed
	for id in ["sky","distant_battlefield","road","foreground","scissors","scrap","bandage_rolls","station_passed","station_standard","station_bandages"]:
		if not rectangles.get(id) is Array or rectangles[id].size()!=4: return
	for id in speeds:
		var plane := Node2D.new()
		plane.name = id
		add_child(plane)
		planes[id] = plane
	_add("Sky",texture_at(underpaint),Rect2(0,0,1672,941))
	_piece("Sky","sky")
	_piece("DistantBattlefield","distant_battlefield")
	# The road is behind the connected station/arches, not painted over the beds.
	_piece("Road","road")
	move_child(planes.Road,planes.Midground.get_index())
	# Cloth, stone, openings and the dressing station share one texture and
	# transform. Keep the former cutouts on disk only as rollback inputs.
	station = _piece("Midground","station_passed",3)
	_piece("Foreground","foreground")
	reactions = REACTIONS.new()
	reactions.scale = PROJECTION
	planes.Midground.add_child(reactions)
	reactions.build(texture_at(DIR+"scrap.png"),texture_at(DIR+"scissors.png"),texture_at(DIR+"bandage_rolls.png"))
	available = walk.build()
	update_time(0,4)

func _rect(id: String) -> Rect2:
	var r: Array = rectangles[id]
	return Rect2(float(r[0]),float(r[1]),float(r[2]),float(r[3]))

func _piece(plane: String, id: String, kind: int = 0) -> Sprite2D:
	var rect := _rect(id)
	var sprite := _add(plane,texture_at(DIR+id+".png"),rect)
	if kind>0:
		var material := ShaderMaterial.new()
		material.shader = preload("res://shaders/dressing_station_layer.gdshader")
		material.set_shader_parameter("source_rect",Vector4(rect.position.x,rect.position.y,rect.size.x,rect.size.y))
		material.set_shader_parameter("kind",kind)
		sprite.material = material
		materials.append(material)
	return sprite

func _add(plane: String, texture: Texture2D, rect: Rect2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.position = rect.position*PROJECTION
	sprite.scale = PROJECTION
	planes[plane].add_child(sprite)
	return sprite

func configure(context: Dictionary) -> void:
	outcome = str(context.get("outcome_id","passed"))
	if outcome not in ["bandages","standard","passed"]: outcome = "passed"
	station.texture = texture_at(DIR+"station_"+outcome+".png")
	reactions.outcome = outcome
	for material in materials:
		material.set_shader_parameter("outcome",["passed","standard","bandages"].find(outcome))

func update_time(time: float, duration: float) -> void:
	for id in planes: planes[id].position = ORIGIN-Vector2(float(speeds[id])*(time-duration*0.5),0)
	for material in materials: material.set_shader_parameter("elapsed",time)
	if reactions!=null: reactions.update_time(time)

func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, layout: Resource) -> void:
	walk.stage(actors,roles,contacts,ground,time,duration,planes.Road.position-ORIGIN,layout)
