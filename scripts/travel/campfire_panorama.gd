extends Node2D
## Scene04 implements the existing Travel V2 panorama/staging contract.
const DIR := "res://assets/pixel/travel/campfire_without_master/"
const PROJECTION := Vector2(1344.0/1672.0,757.0/941.0)
const ORIGIN := Vector2(-32,-18)
static var _textures: Dictionary = {}
var available := false
var planes: Dictionary = {}
var speeds := {"Sky":0.15,"Gate":1.6,"Road":3.0,"Midground":1.6,"Foreground":1.6}
var rectangles: Dictionary = {}
var materials: Array[ShaderMaterial] = []
var camp: Sprite2D
var reactions: Node2D
var outcome := "passed"
var walk := preload("res://scripts/travel/campfire_walk.gd").new()

static func texture_at(path: String) -> Texture2D:
	if _textures.has(path): return _textures[path]
	if not FileAccess.file_exists(path): return null
	var image := Image.new()
	if image.load_png_from_buffer(FileAccess.get_file_as_bytes(path))!=OK: return null
	var texture := ImageTexture.create_from_image(image)
	_textures[path]=texture
	return texture

func build(background: String, foreground: String, underpaint: String, _sky: String) -> void:
	for file in [background,foreground,underpaint,DIR+"gate.png",DIR+"road.png",DIR+"strap.png",DIR+"camp_passed.png",DIR+"camp_repair.png",DIR+"camp_hobnails.png"]:
		if texture_at(file)==null: return
	if not FileAccess.file_exists(DIR+"layers.json"): return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR+"layers.json"))
	if not parsed is Dictionary: return
	rectangles=parsed
	for id in ["gate","road","foreground","strap","camp_passed","camp_repair","camp_hobnails"]:
		if not rectangles.get(id) is Array or rectangles[id].size()!=4: return
	for id in speeds:
		var plane := Node2D.new()
		plane.name=id
		add_child(plane)
		planes[id]=plane
	_add("Sky",texture_at(underpaint),Rect2(0,0,1672,941))
	_piece("Gate","gate",2)
	_piece("Road","road")
	camp=_piece("Midground","camp_passed",1)
	_piece("Foreground","foreground")
	reactions=preload("res://scripts/travel/campfire_reactions.gd").new()
	reactions.scale=PROJECTION
	planes.Midground.add_child(reactions)
	reactions.build(texture_at(DIR+"strap.png"))
	available=walk.build()
	update_time(0,4)

func _piece(plane: String, id: String, kind: int = 0) -> Sprite2D:
	var r: Array = rectangles[id]
	var rect := Rect2(float(r[0]),float(r[1]),float(r[2]),float(r[3]))
	var sprite := _add(plane,texture_at(DIR+id+".png"),rect)
	if kind>0:
		var material := ShaderMaterial.new()
		material.shader=preload("res://shaders/campfire_layer.gdshader")
		material.set_shader_parameter("source_rect",Vector4(rect.position.x,rect.position.y,rect.size.x,rect.size.y))
		material.set_shader_parameter("kind",kind)
		sprite.material=material
		materials.append(material)
	return sprite

func _add(plane: String, texture: Texture2D, rect: Rect2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture=texture
	sprite.centered=false
	sprite.position=rect.position*PROJECTION
	sprite.scale=PROJECTION
	sprite.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	planes[plane].add_child(sprite)
	return sprite

func configure(context: Dictionary) -> void:
	outcome=str(context.get("outcome_id","passed"))
	if outcome not in ["repair","hobnails","passed"]: outcome="passed"
	camp.texture=texture_at(DIR+"camp_"+outcome+".png")
	reactions.outcome=outcome
	for material in materials: material.set_shader_parameter("passed",outcome=="passed")

func update_time(time: float, duration: float) -> void:
	for id in planes: planes[id].position=ORIGIN-Vector2(float(speeds[id])*(time-duration*0.5),0)
	for material in materials: material.set_shader_parameter("elapsed",time)
	if reactions!=null: reactions.update_time(time)

func stage_party(actors: Array[AnimatedSprite2D], roles: Array[String], contacts: Array[Vector2], ground: Node2D, time: float, duration: float, layout: Resource) -> void:
	walk.stage(actors,roles,contacts,ground,time,duration,planes.Road.position-ORIGIN,layout)
