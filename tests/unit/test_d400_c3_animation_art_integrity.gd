extends GutTest

# D400 guards the ART defect missed by D398's "25 unique nonempty cells" test:
# orphan cloth fragments and disconnected bodies in attack/death. Real human
# visual QA is still mandatory; this only detects an objective failure mode.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const REPAIRS := {
	"knight": [[2, 2], [2, 3], [2, 4], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5]],
	"ranger": [[2, 3], [4, 4], [4, 5]],
	"mage": [[2, 1], [2, 2], [2, 3], [4, 0], [4, 1], [4, 2], [4, 3], [4, 4]],
}
const THRESHOLD := 0.25
const TILE := 96


func _image_from_path(path: String) -> Image:
	var encoded := FileAccess.get_file_as_string(path).strip_edges()
	var raw := Marshalls.base64_to_raw(encoded)
	var output := Image.new()
	if raw.is_empty() or output.load_webp_from_buffer(raw) != OK:
		return null
	output.convert(Image.FORMAT_RGBA8)
	return output


# 8-neighbor flood-fill on substantial alpha, not just tiny compression noise.
# Returns fraction of visible pixels outside the largest joined actor component.
static func _detached_fraction(image: Image, row: int, col: int) -> float:
	var mask := PackedByteArray()
	mask.resize(TILE * TILE)
	var total := 0
	for y in range(TILE):
		for x in range(TILE):
			if image.get_pixel(col * TILE + x, row * TILE + y).a > THRESHOLD:
				mask[y * TILE + x] = 1
				total += 1
	if total <= 0:
		return 1.0
	var visited := PackedByteArray()
	visited.resize(TILE * TILE)
	var largest := 0
	for start in range(TILE * TILE):
		if mask[start] == 0 or visited[start] != 0:
			continue
		var queue: Array[int] = [start]
		visited[start] = 1
		var head := 0
		while head < queue.size():
			var pos: int = queue[head]
			head += 1
			var cx: int = pos % TILE
			var cy: int = pos / TILE
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					var xx: int = cx + dx
					var yy: int = cy + dy
					if xx < 0 or yy < 0 or xx >= TILE or yy >= TILE:
						continue
					var neighbor: int = yy * TILE + xx
					if mask[neighbor] != 0 and visited[neighbor] == 0:
						visited[neighbor] = 1
						queue.append(neighbor)
		largest = maxi(largest, queue.size())
	return float(total - largest) / float(total)


static func _filled_pixels(image: Image, row: int, col: int) -> int:
	var total := 0
	for y in range(TILE):
		for x in range(TILE):
			if image.get_pixel(col * TILE + x, row * TILE + y).a > THRESHOLD:
				total += 1
	return total


func test_d400_repairs_detected_disconnected_cape_and_body_cells() -> void:
	assert_eq(LIBRARY.C3_HERO_PILOT_DIR, "res://assets/pixel/units/hero_c3_d400/")
	for role in REPAIRS.keys():
		var current_path: String = "%s%s.webp.b64" % [LIBRARY.C3_HERO_PILOT_DIR, role]
		var archived_path: String = "res://assets/pixel/units/hero_c3_d398/%s.webp.b64" % role
		assert_true(FileAccess.file_exists(current_path))
		assert_true(FileAccess.file_exists(archived_path), "D398 must remain for rollback")
		var image := _image_from_path(current_path)
		var old := _image_from_path(archived_path)
		assert_not_null(image)
		assert_not_null(old)
		if image == null or old == null:
			continue
		assert_eq(image.get_size(), Vector2i(576, 480))
		assert_true(LIBRARY._valid_c3_hero_atlas(image))
		for tile in REPAIRS[role]:
			var row: int = tile[0]
			var col: int = tile[1]
			var fraction := _detached_fraction(image, row, col)
			assert_lte(fraction, 0.045, "%s %d:%d has ghost pixels: %.3f" % [role, row, col, fraction])
			var previous_pixels := _filled_pixels(old, row, col)
			var preserved_pixels := _filled_pixels(image, row, col)
			assert_gt(preserved_pixels, previous_pixels * 0.65, "%s %d:%d erased too much body art" % [role, row, col])
			var a := image.get_region(Rect2i(col * TILE, row * TILE, TILE, TILE))
			var b := old.get_region(Rect2i(col * TILE, row * TILE, TILE, TILE))
			assert_ne(hash(a.get_data()), hash(b.get_data()), "%s %d:%d must be retouched" % [role, row, col])


func test_unaffected_five_state_hero_contract_still_plays_unchanged() -> void:
	for role in ["knight", "ranger", "mage"]:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(frames)
		if frames == null:
			continue
		for i in range(5):
			var state: String = ["idle", "walk", "attack", "hit", "death"][i]
			assert_eq(frames.get_frame_count(state), [4, 6, 6, 3, 6][i])
