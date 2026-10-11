extends RefCounted

# Pack 2 Stage B staging only: load + inspect candidate art without affecting
# the combat SpriteFrames loader or the approved static v4 enemies.
const CELL := 96
const COLUMNS := 6
const ROWS := 5
const BASE_DIR := "res://assets/pixel/units/combat_units_anim_pack2_candidates/"
const ROLES := ["bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden"]

const STATE_NAMES := ["idle", "walk", "attack", "hit", "death"]
const STATE_COUNTS := [4, 6, 6, 3, 6]
const STATE_FPS := [2.7, 7.0, 15.0, 12.0, 10.0]
const ACCEPTED_SOLE_MIN := 87
const ACCEPTED_SOLE_MAX := 94

static var _cache: Dictionary = {}


static func inspect(role: String) -> Dictionary:
	if _cache.has(role):
		return _cache[role]
	var result := {
		"role": role,
		"ready": false,
		"frames": null,
		"errors": [],
		"warnings": [],
	}
	if not ROLES.has(role):
		result["errors"].append("Unsupported candidate role: %s" % role)
		return result

	var path := "%s%s.webp.b64" % [BASE_DIR, role]
	if not FileAccess.file_exists(path):
		result["warnings"].append("Нет кандидата: %s" % path.get_file())
		_cache[role] = result
		return result

	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	if raw.is_empty():
		result["errors"].append("Base64 не декодируется")
		_cache[role] = result
		return result
	var image := Image.new()
	if image.load_webp_from_buffer(raw) != OK:
		result["errors"].append("Некорректный WebP")
		_cache[role] = result
		return result
	if image.get_width() != CELL * COLUMNS or image.get_height() != CELL * ROWS:
		result["errors"].append("Неверная сетка: требуется 576x480 (6x5, 96px)")
		_cache[role] = result
		return result
	image.convert(Image.FORMAT_RGBA8)

	var data_errors: Array[String] = []
	var data_warnings: Array[String] = []
	for row in range(ROWS):
		var prev_frame: PackedByteArray
		var has_difference := false
		for x in range(STATE_COUNTS[row]):
			var frame := image.get_region(Rect2i(x * CELL, row * CELL, CELL, CELL))
			var extents := _alpha_extents(frame)
			var key := "%s[%d]" % [STATE_NAMES[row], x]
			if int(extents["pixels"]) < 70:
				data_errors.append("%s: пустой/почти пустой кадр" % key)
				continue
			var sole_y: int = extents["bottom"]
			if sole_y < ACCEPTED_SOLE_MIN or sole_y > ACCEPTED_SOLE_MAX:
				data_warnings.append("%s: контакт с полом y=%d, ожидается 87–94" % [key, sole_y])
			if int(extents["left"]) < 2 or int(extents["right"]) > CELL - 3:
				data_warnings.append("%s: силуэт упирается в край" % key)
			# At a minimum, attack and walk must not be copies of one image.
			var bytes: PackedByteArray = frame.get_data()
			if x > 0 and bytes != prev_frame:
				has_difference = true
			prev_frame = bytes
		if row == 1 or row == 2:
			if not has_difference:
				data_errors.append("%s: все кадры одинаковые, движения нет" % STATE_NAMES[row])

	for msg in data_errors:
		result["errors"].append(msg)
	for msg in data_warnings:
		result["warnings"].append(msg)
	if not data_errors.is_empty():
		_cache[role] = result
		return result

	var atlas := ImageTexture.create_from_image(image)
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(ROWS):
		var name: String = STATE_NAMES[row]
		frames.add_animation(name)
		frames.set_animation_speed(name, STATE_FPS[row])
		frames.set_animation_loop(name, row < 2)
		for col in range(STATE_COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = atlas
			tile.region = Rect2(float(col * CELL), float(row * CELL), float(CELL), float(CELL))
			frames.add_frame(name, tile)

	result["frames"] = frames
	result["ready"] = true
	_cache[role] = result
	return result


static func _alpha_extents(frame: Image) -> Dictionary:
	var left := CELL
	var right := -1
	var bottom := -1
	var pixels := 0
	for y in range(CELL):
		for x in range(CELL):
			if frame.get_pixel(x, y).a <= 0.20:
				continue
			pixels += 1
			left = mini(left, x)
			right = maxi(right, x)
			bottom = y
	return {"left": left, "right": right, "bottom": bottom, "pixels": pixels}
