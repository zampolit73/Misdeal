extends RefCounted
## Coordinates traced from the immutable 1280x720 production paintings.
## R: local displacement; G: distant atmosphere; B: existing lights; A: dust.
const PILOTS := ["firing_square", "black_crossing", "threadbare_theatre"]
const PROFILES := {
	"firing_square": {
		"mode": 1,
		"warp": [],
		"atmosphere": [[[212,302],[280,282],[357,301],[417,337],[399,393],[340,424],[240,432],[202,408]]],
		"dust": [[[615,265],[690,275],[700,365],[605,365]], [[798,272],[848,280],[863,355],[785,355]]],
		"lights": [[652,338,44], [827,332,40], [1083,326,45], [285,244,21], [500,242,21], [1250,347,24]]
	},
	"black_crossing": {
		"mode": 2,
		# Open sea only. Pier, posts, ropes, castle and foreground floor excluded.
		"warp": [[[351,279],[552,274],[776,278],[801,303],[780,328],[700,344],[544,345],[540,324],[506,322],[502,343],[462,342],[458,313],[416,308],[416,341],[363,335]], [[894,317],[932,293],[981,305],[1008,331],[991,346],[918,345]], [[1089,316],[1130,298],[1166,308],[1198,329],[1247,313],[1279,317],[1279,348],[1112,347]]],
		"atmosphere": [[[306,0],[790,0],[838,100],[771,178],[490,200],[315,159]]],
		"dust": [], "lights": []
	},
	"threadbare_theatre": {
		"mode": 3,
		# Interior folds of the existing heavy curtains; attachment points fixed.
		"warp": [[[8,8],[224,8],[195,60],[164,101],[137,160],[113,223],[95,288],[65,342],[24,372],[6,400]], [[1189,4],[1279,4],[1279,257],[1260,221],[1246,172],[1213,139],[1198,80]], [[747,14],[796,14],[793,112],[783,163],[769,140],[759,169],[748,116]]],
		"atmosphere": [],
		"dust": [[[556,92],[632,83],[707,303],[613,321],[531,290]], [[512,278],[567,283],[586,339],[502,340]]],
		"lights": [[69,486,27], [243,395,23], [343,365,22], [537,313,19], [783,334,18], [1107,193,23], [1246,505,30]]
	}
}
static var masks: Dictionary = {}

static func supports(id: String) -> bool:
	return PROFILES.has(id)

static func mask_for(id: String) -> Texture2D:
	if masks.has(id): return masks[id]
	if not supports(id): return null
	# Image importer preserves RGBA data, including RGB under zero dust alpha,
	# and resolves its imported resource correctly in exported builds.
	var image := load("res://assets/pixel/battle/living_masks/"+id+".png") as Image
	assert(image != null and image.get_size() == Vector2i(320,180))
	var texture := ImageTexture.create_from_image(image)
	masks[id] = texture
	return texture

## Offline mask baker only; no geometry/image creation in the animation loop.
static func build_mask(id: String) -> Image:
	var profile: Dictionary = PROFILES[id]
	var regions: Array = []
	for key in ["warp", "atmosphere", "dust"]:
		var group: Array[PackedVector2Array] = []
		for points in profile[key]:
			var polygon := PackedVector2Array()
			for point in points: polygon.append(Vector2(point[0], point[1]))
			group.append(polygon)
		regions.append(group)
	var image := Image.create(320, 180, false, Image.FORMAT_RGBA8)
	for y in range(180):
		for x in range(320):
			var p := Vector2(x * 4 + 2, y * 4 + 2)
			var light := 0.0
			for entry in profile.lights:
				var distance := p.distance_to(Vector2(entry[0], entry[1])) / float(entry[2])
				light = maxf(light, pow(maxf(0.0, 1.0-distance), 2.0))
			image.set_pixel(x, y, Color(_coverage(p, regions[0]), _coverage(p, regions[1]), light, _coverage(p, regions[2])))
	return image

static func _coverage(p: Vector2, polygons: Array) -> float:
	var coverage := 0.0
	for polygon: PackedVector2Array in polygons:
		if not Geometry2D.is_point_in_polygon(p, polygon): continue
		var distance := 1000.0
		for i in range(polygon.size()):
			distance = minf(distance, p.distance_to(Geometry2D.get_closest_point_to_segment(p, polygon[i], polygon[(i+1)%polygon.size()])))
		coverage = maxf(coverage, smoothstep(0.0, 10.0, distance))
	return coverage
