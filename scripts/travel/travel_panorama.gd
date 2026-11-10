extends Node2D
## Original-pixel cutouts over a reconstructed occlusion plate. No atlas edits.
const DIRECTORY := "res://assets/pixel/travel/ruined_castle_road/"
const SOURCE_SIZE := Vector2(1671, 941)
const PROJECTION := Vector2(1408, 793) / SOURCE_SIZE
const ORIGIN := Vector2(-64, -15)
const ROAD_SPEED := 24.0
static var _textures: Dictionary = {}
var available := false
var planes: Dictionary = {}
var speeds := {"Sky": 0.3, "Mountains": 1.2, "Castle": 3.0, "Midground": 7.0, "Road": ROAD_SPEED, "Foreground": 38.0}
var cloth: ShaderMaterial

static func texture_at(path: String) -> Texture2D:
	if _textures.has(path): return _textures[path]
	if not FileAccess.file_exists(path): return null
	var image := Image.new()
	if image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) != OK: return null
	var texture := ImageTexture.create_from_image(image)
	_textures[path] = texture
	return texture

func build(background: String, foreground: String, underpaint: String, sky_path: String) -> void:
	var original := texture_at(background)
	var fill := texture_at(underpaint)
	var close := texture_at(foreground)
	var sky_texture := texture_at(sky_path)
	if original == null or fill == null or close == null or sky_texture == null: return
	# All polygons use source-pixel UVs. Exact original castle/wall/road texture.
	_rectangle("Sky", sky_texture)
	var mountains := _cutout("Mountains", fill, PackedVector2Array([
		Vector2(0,306),Vector2(45,294),Vector2(65,302),Vector2(93,287),Vector2(130,302),Vector2(170,316),Vector2(217,302),Vector2(266,314),Vector2(309,306),Vector2(343,286),Vector2(365,285),Vector2(393,258),Vector2(411,266),Vector2(447,239),Vector2(464,239),Vector2(486,259),Vector2(505,257),Vector2(540,276),Vector2(567,262),Vector2(590,275),Vector2(620,268),Vector2(666,300),Vector2(699,280),Vector2(723,283),Vector2(745,268),Vector2(773,271),Vector2(800,255),Vector2(823,265),Vector2(844,269),Vector2(891,255),Vector2(910,240),Vector2(942,257),Vector2(980,248),Vector2(1035,232),Vector2(1080,226),Vector2(1140,218),Vector2(1200,220),Vector2(1260,214),Vector2(1300,191),Vector2(1340,185),Vector2(1380,172),Vector2(1410,181),Vector2(1450,168),Vector2(1485,180),Vector2(1520,164),Vector2(1560,139),Vector2(1600,155),Vector2(1640,147),Vector2(1671,137),Vector2(1671,941),Vector2(0,941)]))
	# Preserve PR104's visible valley pixels; generated fill is exposed only
	# behind moving architecture / a narrow horizon overscan.
	var valley := _cutout("ValleyOriginal", original, PackedVector2Array([
		Vector2(0,308),Vector2(250,325),Vector2(350,293),Vector2(450,237),Vector2(530,276),Vector2(590,261),Vector2(675,306),Vector2(802,254),Vector2(840,276),Vector2(914,240),Vector2(935,264),Vector2(920,318),Vector2(850,375),Vector2(800,400),Vector2(760,440),Vector2(640,530),Vector2(610,610),Vector2(430,660),Vector2(305,676),Vector2(0,610)]))
	remove_child(valley)
	mountains.add_child(valley)
	valley.scale = Vector2.ONE
	valley.position = Vector2.ZERO
	planes.erase("ValleyOriginal")
	var valley_edge := ShaderMaterial.new()
	valley_edge.shader = preload("res://shaders/travel_cutout.gdshader")
	valley_edge.set_shader_parameter("valley",true)
	valley.material = valley_edge
	var castle := _cutout("Castle", original, PackedVector2Array([
		Vector2(641,549),Vector2(773,433),Vector2(853,367),Vector2(910,317),Vector2(948,298),Vector2(953,251),Vector2(972,250),Vector2(972,227),Vector2(995,221),Vector2(1000,189),Vector2(1018,188),Vector2(1020,219),Vector2(1061,213),Vector2(1065,151),Vector2(1080,145),Vector2(1091,155),Vector2(1092,180),Vector2(1114,179),Vector2(1114,153),Vector2(1130,151),Vector2(1131,41),Vector2(1142,35),Vector2(1154,44),Vector2(1164,39),Vector2(1167,58),Vector2(1190,63),Vector2(1191,52),Vector2(1208,55),Vector2(1212,72),Vector2(1254,79),Vector2(1254,140),Vector2(1270,140),Vector2(1272,167),Vector2(1300,167),Vector2(1301,153),Vector2(1321,156),Vector2(1323,177),Vector2(1360,186),Vector2(1450,300),Vector2(1450,700),Vector2(641,700)]))
	castle.name = "Castle"
	var castle_edge := ShaderMaterial.new()
	castle_edge.shader = preload("res://shaders/travel_cutout.gdshader")
	castle.material = castle_edge
	var wall := _cutout("Midground", original, PackedVector2Array([
		Vector2(0,683),Vector2(65,675),Vector2(65,655),Vector2(108,646),Vector2(118,619),Vector2(154,615),Vector2(158,651),Vector2(199,658),Vector2(210,680),Vector2(247,681),Vector2(267,657),Vector2(294,655),Vector2(303,680),Vector2(425,682),Vector2(467,668),Vector2(493,657),Vector2(545,659),Vector2(594,623),Vector2(644,618),Vector2(645,563),Vector2(674,553),Vector2(687,560),Vector2(690,600),Vector2(738,598),Vector2(760,577),Vector2(789,575),Vector2(790,552),Vector2(823,551),Vector2(826,532),Vector2(857,527),Vector2(857,516),Vector2(894,511),Vector2(895,488),Vector2(936,471),Vector2(970,466),Vector2(970,451),Vector2(999,446),Vector2(1000,405),Vector2(1024,394),Vector2(1054,397),Vector2(1055,432),Vector2(1090,428),Vector2(1094,418),Vector2(1127,416),Vector2(1126,428),Vector2(1168,423),Vector2(1168,414),Vector2(1197,419),Vector2(1197,279),Vector2(1229,271),Vector2(1231,261),Vector2(1251,264),Vector2(1253,278),Vector2(1292,269),Vector2(1294,257),Vector2(1307,251),Vector2(1310,230),Vector2(1330,226),Vector2(1330,216),Vector2(1350,216),Vector2(1354,180),Vector2(1360,180),Vector2(1360,147),Vector2(1375,143),Vector2(1375,90),Vector2(1405,76),Vector2(1424,80),Vector2(1428,140),Vector2(1468,129),Vector2(1471,31),Vector2(1500,25),Vector2(1511,43),Vector2(1530,41),Vector2(1534,27),Vector2(1552,27),Vector2(1552,12),Vector2(1577,15),Vector2(1577,55),Vector2(1600,58),Vector2(1600,51),Vector2(1625,48),Vector2(1625,20),Vector2(1650,12),Vector2(1650,0),Vector2(1671,0),Vector2(1671,941),Vector2(0,941)]))
	cloth = ShaderMaterial.new()
	cloth.shader = preload("res://shaders/travel_cloth.gdshader")
	wall.material = cloth
	var road := _rectangle("Road", original)
	var road_material := ShaderMaterial.new()
	road_material.shader = preload("res://shaders/travel_road.gdshader")
	road.material = road_material
	var foreground_plane := _rectangle("Foreground", close)
	foreground_plane.visible = false # Attached above the actors by the caller.
	available = true
	update_time(0.0, 4.0)

func _rectangle(id: String, texture: Texture2D) -> Polygon2D:
	return _cutout(id, texture, PackedVector2Array([Vector2.ZERO,Vector2(SOURCE_SIZE.x,0),SOURCE_SIZE,Vector2(0,SOURCE_SIZE.y)]))

func _cutout(id: String, texture: Texture2D, points: PackedVector2Array) -> Polygon2D:
	var piece := Polygon2D.new()
	piece.name = id
	piece.texture = texture
	piece.polygon = points
	piece.uv = points
	piece.scale = PROJECTION
	piece.antialiased = true
	add_child(piece)
	planes[id] = piece
	return piece

func update_time(time: float, duration: float) -> void:
	for id in planes:
		# Centre the finite camera move within the painted overscan. No tiling.
		planes[id].position = ORIGIN - Vector2(float(speeds[id]) * (time - duration * 0.5), 0)
	if cloth != null: cloth.set_shader_parameter("elapsed",time)
