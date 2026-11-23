extends RefCounted
## Coordinates traced from the immutable 1280x720 production paintings.
## R: local displacement; G: distant atmosphere; B: existing lights; A: dust.
const PILOTS := ["firing_square", "black_crossing", "threadbare_theatre"]
const BATTLE_REACTIONS := {
	"graveyard": {"cue": &"start", "area": Vector4(53, 337, 60, 52), "gain": Vector2(0.25, 0.0)},
	"iron_wall": {"cue": &"wave", "area": Vector4(178, 284, 120, 66), "gain": Vector2(0.27, 0.0)},
	"bone_ritual": {"cue": &"start", "area": Vector4(958, 288, 110, 75), "gain": Vector2(0.25, 0.0)},
	"court_of_the_mute": {"cue": &"victory", "area": Vector4(635, 100, 115, 130), "gain": Vector2(-0.23, 0.0)},
	"ossuary_gate": {"cue": &"start", "area": Vector4(684, 151, 220, 160), "gain": Vector2(0.0, 0.12)},
	"warden": {"cue": &"start", "area": Vector4(640, 213, 345, 145), "gain": Vector2(0.24, 0.0)},
}

# Source center, horizontal/vertical reach and motion kind in authored pixels.
# Fire anchors stay at the painted flame base. Air uses the existing fog mask.
const VISIBLE_MOTION := {
	"bone_ritual": [Vector4(962, 315, 45, 57), 1],
	"iron_wall": [Vector4(126, 308, 40, 54), 2],
	"ossuary_gate": [Vector4(685, 172, 215, 141), 3],
	"graveyard": [Vector4(53, 347, 25, 38), 1],
	"court_of_the_mute": [Vector4(635, 110, 110, 120), 4],
	"warden": [Vector4(261, 289, 31, 43), 2],
}

const V2_ARENAS := ["last_bell", "ossuary_gate", "warden"]
const V3_BATCHES := [
	["crypt", "graveyard", "gallows", "ossuary"],
	["bone_crush", "bone_swarm", "grave_crossfire", "iron_wall"],
	["bone_ritual", "black_lantern_road", "court_of_the_mute"],
]
const V3_ARENAS := V3_BATCHES[0] + V3_BATCHES[1] + V3_BATCHES[2]
const ALL_PROFILES := PILOTS + V2_ARENAS + V3_ARENAS
const V3_FLOOR_Y := 360
const PREVIEW_ENCOUNTERS := {
	"crypt": "bone_patrol",
	"graveyard": "grave_bell",
	"gallows": "gallows_volley",
	"ossuary": "death_wager",
	"warden": "bone_warden",
}
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
	},
	"last_bell": {
		"mode": 4,
		"warp": [],
		# Far valley between the bell tower and the right columns.
		"atmosphere": [[[642,159],[751,146],[934,149],[1078,156],[1195,166],[1195,235],[1122,285],[981,297],[777,318],[649,282]]],
		"dust": [[[279,185],[467,177],[488,256],[548,254],[542,317],[289,319]]],
		"lights": [[87,349,24], [287,338,24], [362,247,31], [529,276,26], [1084,348,24]],
		"haze": Color(0.49,0.57,0.65,0.13),
		"motes": Vector4(298,195,222,103),
		"dust_strength": 0.23
	},
	"ossuary_gate": {
		"mode": 4,
		"warp": [],
		# Rear gate and alcoves, above the entrance step.
		"atmosphere": [[[512,18],[661,6],[789,11],[847,70],[837,241],[793,290],[633,287],[542,259],[521,182]], [[235,99],[284,89],[321,132],[318,236],[301,286],[236,281]]],
		"dust": [[[302,112],[882,95],[953,160],[975,296],[891,306],[698,282],[390,306],[304,273]]],
		"lights": [[64,145,31], [357,149,29], [605,261,24], [862,260,24], [1080,124,27], [1140,292,23], [1208,249,29]],
		"haze": Color(0.32,0.42,0.54,0.13),
		"motes": Vector4(311,137,634,145),
		"dust_strength": 0.28
	},
	"warden": {
		"mode": 4,
		"warp": [],
		# Existing wall recesses only. The painted floor seal is static.
		"atmosphere": [[[384,41],[463,26],[525,72],[506,240],[477,307],[357,323],[340,262],[376,191]], [[755,62],[829,30],[895,75],[916,207],[948,306],[843,324],[783,296],[754,235]]],
		"dust": [[[217,149],[334,123],[466,170],[502,307],[397,318],[226,319]], [[773,139],[927,126],[1050,150],[1071,308],[920,319],[783,294]]],
		"lights": [[261,282,44], [443,175,61], [496,273,24], [784,272,24], [836,178,63], [1018,283,44]],
		"haze": Color(0.44,0.35,0.37,0.085),
		"motes": Vector4(242,163,790,130),
		"dust_strength": 0.20,
		"phase_response": true
	},
	"crypt": {
		"mode": 5, "cycle_seconds": 24.0,
		"warp": [],
		"atmosphere": [[[119, 109], [167, 92], [268, 151], [358, 209], [346, 278], [288, 296], [177, 267], [134, 209]], [[982, 139], [1075, 104], [1149, 141], [1157, 266], [1106, 309], [1049, 274]]],
		"dust": [[[266, 90], [908, 108], [973, 248], [927, 298], [359, 298], [271, 250]]],
		"lights": [[88, 280, 63], [489, 235, 31], [930, 228, 32], [1211, 287, 61]],
		"haze": Color(0.33, 0.31, 0.3, 0.14),
		"motes": Vector4(274, 64, 693, 227), "dust_strength": 0.34,
		"motion": Vector4(0.72, 0.7, 1.3, 0)
	},
	"graveyard": {
		"mode": 5, "cycle_seconds": 32.0,
		"warp": [],
		"atmosphere": [[[290, 174], [409, 150], [507, 169], [575, 204], [755, 208], [850, 193], [935, 211], [978, 266], [863, 287], [720, 262], [596, 258], [458, 279], [329, 246]]],
		"dust": [[[344, 156], [837, 157], [902, 245], [835, 295], [376, 291]]],
		"lights": [[53, 337, 20], [256, 245, 32], [1234, 333, 24]],
		"haze": Color(0.43, 0.5, 0.62, 0.2),
		"motes": Vector4(367, 156, 490, 133), "dust_strength": 0.26,
		"motion": Vector4(0.62, 0.98, 0.89, 0)
	},
	"gallows": {
		"mode": 5, "cycle_seconds": 22.0,
		"warp": [[[235, 125], [248, 126], [258, 152], [258, 183], [246, 188], [222, 180], [221, 154]], [[1086, 132], [1101, 131], [1112, 166], [1108, 200], [1088, 205], [1072, 195], [1074, 160]]],
		"atmosphere": [[[186, 172], [337, 143], [497, 173], [740, 191], [892, 145], [989, 166], [969, 222], [830, 267], [740, 316], [588, 330], [431, 295], [297, 260], [184, 237]]],
		"dust": [],
		"lights": [[74, 355, 32], [303, 316, 29], [975, 313, 28], [1204, 357, 38]],
		"haze": Color(0.4, 0.45, 0.53, 0.14),
		"motes": Vector4(180, 145, 798, 167), "dust_strength": 0.0,
		"motion": Vector4(0.92, 0.84, 1.12, 1.35)
	},
	"ossuary": {
		"mode": 5, "cycle_seconds": 26.0,
		"warp": [],
		"atmosphere": [[[29, 95], [118, 70], [170, 91], [165, 202], [138, 253], [67, 249], [28, 207]], [[1009, 93], [1097, 74], [1147, 116], [1121, 199], [1055, 232], [1012, 191]]],
		"dust": [[[58, 89], [1220, 99], [1204, 273], [934, 279], [669, 259], [130, 273]]],
		"lights": [[67, 176, 42], [360, 164, 33], [1082, 124, 35], [1206, 259, 41], [603, 268, 28], [862, 267, 26]],
		"haze": Color(0.45, 0.32, 0.28, 0.16),
		"motes": Vector4(68, 97, 1124, 178), "dust_strength": 0.37,
		"motion": Vector4(-0.66, 0.94, 1.02, 0)
	},
	"bone_crush": {
		"mode": 5, "cycle_seconds": 19.0,
		"warp": [],
		"atmosphere": [[[277, 124], [389, 104], [430, 179], [407, 270], [357, 305], [282, 291]], [[870, 157], [951, 139], [1032, 153], [1116, 206], [1090, 282], [994, 309], [914, 275]]],
		"dust": [[[352, 137], [875, 101], [971, 137], [1010, 234], [994, 317], [881, 309], [480, 286], [379, 271]]],
		"lights": [[216, 276, 43], [493, 231, 34], [1179, 299, 44]],
		"haze": Color(0.56, 0.48, 0.39, 0.18),
		"motes": Vector4(456, 105, 574, 186), "dust_strength": 0.54,
		"motion": Vector4(0.43, 1.05, 1.22, 0)
	},
	"bone_swarm": {
		"mode": 5, "cycle_seconds": 36.0,
		"warp": [],
		"atmosphere": [[[601, 21], [849, 13], [933, 44], [947, 106], [906, 210], [848, 268], [718, 305], [635, 268], [610, 182]]],
		"dust": [[[552, 52], [861, 56], [956, 126], [991, 264], [940, 316], [751, 298], [550, 269]]],
		"lights": [[65, 340, 30], [1231, 323, 38]],
		"haze": Color(0.41, 0.48, 0.6, 0.15),
		"motes": Vector4(548, 64, 440, 228), "dust_strength": 0.33,
		"motion": Vector4(-0.45, 0.63, 0.86, 0)
	},
	"grave_crossfire": {
		"mode": 5, "cycle_seconds": 34.0,
		"warp": [],
		"atmosphere": [[[328, 95], [514, 119], [718, 99], [910, 90], [1089, 105], [1098, 173], [1002, 191], [863, 221], [718, 251], [553, 278], [377, 262], [327, 209]]],
		"dust": [],
		"lights": [[265, 304, 38], [1067, 320, 43], [171, 72, 32]],
		"haze": Color(0.4, 0.48, 0.6, 0.17),
		"motes": Vector4(360, 143, 588, 165), "dust_strength": 0.0,
		"motion": Vector4(0.96, 0.58, 1.04, 0)
	},
	"iron_wall": {
		"mode": 5, "cycle_seconds": 25.0,
		"warp": [],
		"atmosphere": [[[91, 93], [207, 83], [281, 140], [297, 223], [256, 289], [175, 263], [128, 230]], [[445, 83], [518, 48], [578, 86], [615, 156], [604, 216], [521, 232], [453, 213]]],
		"dust": [[[78, 88], [383, 37], [675, 77], [747, 177], [672, 280], [540, 296], [123, 271]]],
		"lights": [[124, 290, 36], [203, 284, 42], [568, 270, 40], [989, 271, 38]],
		"haze": Color(0.42, 0.39, 0.39, 0.19),
		"motes": Vector4(123, 87, 634, 184), "dust_strength": 0.36,
		"motion": Vector4(0.56, 0.92, 1.21, 0), "wave_response": true
	},
	"bone_ritual": {
		"mode": 5, "cycle_seconds": 18.0,
		"warp": [],
		"atmosphere": [[[171, 209], [273, 181], [364, 202], [441, 208], [432, 285], [384, 327], [276, 346], [203, 329]], [[719, 113], [837, 93], [925, 111], [1004, 138], [1022, 210], [943, 265], [847, 270], [739, 241]]],
		"dust": [[[720, 98], [1045, 95], [1091, 170], [1073, 293], [762, 297], [706, 258]]],
		"lights": [[32, 281, 34], [497, 327, 32], [767, 329, 28], [958, 288, 73], [1248, 297, 39]],
		"haze": Color(0.44, 0.43, 0.51, 0.16),
		"motes": Vector4(744, 110, 332, 185), "dust_strength": 0.42,
		"motion": Vector4(-0.6, 0.75, 1.6, 0)
	},
	"black_lantern_road": {
		"mode": 5, "cycle_seconds": 38.0,
		"warp": [],
		"atmosphere": [[[101, 248], [243, 230], [369, 238], [556, 215], [750, 213], [932, 233], [1178, 228], [1186, 260], [948, 279], [797, 262], [660, 278], [396, 298], [194, 290], [100, 277]]],
		"dust": [],
		"lights": [[126, 276, 36], [1177, 283, 38]],
		"haze": Color(0.37, 0.45, 0.5, 0.14),
		"motes": Vector4(245, 243, 800, 52), "dust_strength": 0.0,
		"motion": Vector4(1, 0.64, 1.57, 0)
	},
	"court_of_the_mute": {
		"mode": 5, "cycle_seconds": 40.0,
		"warp": [],
		"atmosphere": [[[537, 33], [640, 11], [727, 36], [709, 103], [690, 169], [661, 207], [596, 211], [557, 158]], [[1018, 100], [1096, 83], [1142, 143], [1112, 213], [1073, 277], [1019, 268]]],
		"dust": [[[408, 58], [726, 36], [793, 85], [875, 109], [910, 214], [825, 299], [448, 292]]],
		"lights": [[456, 312, 40], [757, 316, 42], [148, 356, 25], [1067, 355, 24]],
		"haze": Color(0.43, 0.49, 0.6, 0.11),
		"motes": Vector4(429, 66, 454, 221), "dust_strength": 0.28,
		"motion": Vector4(-0.3, 0.51, 0.74, 0)
	}
}
static var masks: Dictionary = {}

static func supports(id: String) -> bool:
	return PROFILES.has(id)

static func for_encounter(arena_id: String, encounter_id: String = "") -> String:
	# A single source painting, with independently authored lighting and haze.
	if arena_id == "ossuary" and encounter_id == "ossuary_gate":
		return "ossuary_gate"
	return arena_id if supports(arena_id) else ""

static func encounter_for(id: String) -> String:
	return PREVIEW_ENCOUNTERS.get(id, id)

static func arena_for(id: String) -> String:
	return "ossuary" if id == "ossuary_gate" else id

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
	# Leave an extra mask row clear for linear sampling at the protected band.
	var mask_rows := V3_FLOOR_Y / 4 - 1 if id in V3_ARENAS else 180
	for y in range(mask_rows):
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
