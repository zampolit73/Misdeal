extends Node2D
const DIR := "res://assets/pixel/travel/last_dawn_posthouse/"
const PROJECTION := Vector2(1344.0/1672.0,757.0/941.0)
const ORIGIN := Vector2(-32,-18)
const FX := preload("res://scripts/travel/posthouse_reactions.gd")
static var _textures: Dictionary = {}
var available := false
var planes: Dictionary = {}
var speeds := {"Sky":0.2,"Mountains":0.8,"Castle":1.4,"VillageBackground":3.0,"Midground":5.5,"Road":14.0,"Foreground":15.0}
var materials: Array[ShaderMaterial] = []
var reactions: Node2D
var outcome := "passed"

static func texture_at(path: String) -> Texture2D:
	if _textures.has(path): return _textures[path]
	if not FileAccess.file_exists(path): return null
	var image := Image.new()
	if image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) != OK: return null
	var texture := ImageTexture.create_from_image(image)
	_textures[path] = texture
	return texture

func build(background: String, foreground: String, underpaint: String, sky: String) -> void:
	var required := [background,foreground,underpaint,sky,DIR+"posthouse.png",DIR+"road.png",DIR+"village.png",DIR+"castle.png",DIR+"mountain_original.png",DIR+"bone_pigeon.png",DIR+"open_paper.png"]
	for path in required:
		if texture_at(path) == null: return
	if not FileAccess.file_exists(DIR+"layers.json"): return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR+"layers.json"))
	if not parsed is Dictionary: return
	var rectangles: Dictionary = parsed
	for id in ["castle","village","posthouse","road","foreground","mountain_original"]:
		if not rectangles.get(id) is Array or rectangles[id].size()!=4: return
	for id in speeds:
		var plane := Node2D.new()
		plane.name = id
		add_child(plane)
		planes[id] = plane
	_add_piece("Sky",texture_at(sky),Rect2(0,0,1672,941))
	var mountains := _add_piece("Mountains",texture_at(underpaint),Rect2(0,0,1672,941))
	var mountain_mask := ShaderMaterial.new()
	mountain_mask.shader = preload("res://shaders/posthouse_mountains.gdshader")
	mountains.material = mountain_mask
	_piece("Mountains","mountain_original",rectangles)
	_piece("Castle","castle",rectangles,1)
	_piece("VillageBackground","village",rectangles,4)
	_piece("Road","road",rectangles)
	_piece("Midground","posthouse",rectangles,2)
	_piece("Foreground","foreground",rectangles,3)
	# Road is behind the close posthouse; near fences are reparented above heroes.
	move_child(planes.Road,planes.Midground.get_index())
	reactions = FX.new()
	reactions.scale = PROJECTION
	planes.Midground.add_child(reactions)
	reactions.build(texture_at(DIR+"bone_pigeon.png"),texture_at(DIR+"open_paper.png"),texture_at(background))
	available = reactions.available
	update_time(0.0,4.0)

func _piece(plane: String, id: String, rectangles: Dictionary, kind: int = 0) -> Sprite2D:
	var r: Array = rectangles[id]
	var rect := Rect2(float(r[0]),float(r[1]),float(r[2]),float(r[3]))
	var sprite := _add_piece(plane,texture_at(DIR+id+".png"),rect)
	if kind > 0:
		var material := ShaderMaterial.new()
		material.shader = preload("res://shaders/posthouse_layer.gdshader")
		material.set_shader_parameter("source_rect",Vector4(rect.position.x,rect.position.y,rect.size.x,rect.size.y))
		material.set_shader_parameter("kind",kind)
		sprite.material = material
		materials.append(material)
	return sprite

func _add_piece(plane: String, texture: Texture2D, rect: Rect2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = rect.position * PROJECTION
	sprite.scale = PROJECTION
	planes[plane].add_child(sprite)
	return sprite

func configure(context: Dictionary) -> void:
	outcome = str(context.get("outcome_id","passed"))
	if outcome not in ["release","read","passed"]: outcome = "passed"
	reactions.outcome = outcome
	for material in materials: material.set_shader_parameter("passed",outcome=="passed")

func update_time(time: float, duration: float) -> void:
	for id in planes: planes[id].position = ORIGIN - Vector2(float(speeds[id])*(time-duration*0.5),0)
	for material in materials: material.set_shader_parameter("elapsed",time)
	if reactions != null: reactions.update_time(time)
