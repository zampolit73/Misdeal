extends SceneTree

# D283 validates the actual AuthoredBattleBackdrop loader, not a screenshot mockup.
# CI PASS is structural only; user native art acceptance is still required.
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const TESTS := [
	{"id": "bone_ritual", "path": "res://assets/pixel/battle/arenas/approved_d283/bone_ritual.webp", "sha": "48e3606c4677456a39f4e8b67ee3c861e1eb0a0c571d1d47dad9af05e78aae9a"},
	{"id": "firing_square", "path": "res://assets/pixel/battle/arenas/approved_d283/firing_square.webp", "sha": "ed06c800484f41b249559622a373c7b543573967fd630cd1af913661b7ddbccd"},
]

func _initialize() -> void:
	call_deferred("_verify")

func _verify() -> void:
	var backdrop := BACKDROP.new() as TextureRect
	root.add_child(backdrop)
	for case in TESTS:
		var source_bytes := FileAccess.get_file_as_bytes(case["path"])
		var hasher := HashingContext.new()
		hasher.start(HashingContext.HASH_SHA256)
		hasher.update(source_bytes)
		if hasher.finish().hex_encode() != case["sha"]:
			_fail("source SHA mismatch " + case["id"])
			return
		var decoded := Image.new()
		if decoded.load_webp_from_buffer(source_bytes) != OK or decoded.get_size() != Vector2i(1280, 720):
			_fail("source WebP decode/size " + case["id"])
			return
		backdrop.set_arena_id(case["id"])
		if backdrop.arena_id != case["id"] or backdrop.texture == null or backdrop.texture.get_size() != Vector2(1280, 720):
			_fail("backdrop did not load selected arena " + case["id"])
			return
		var pixels := backdrop.texture.get_image()
		if pixels == null or pixels.get_pixel(640, 650).a < 0.99:
			_fail("arena battle floor is not opaque " + case["id"])
			return
		print("D283_NATIVE_ARENA_OK: " + case["id"])
	print("D283_APPROVED_ARENAS_NATIVE_PASS")
	quit(0)

func _fail(problem: String) -> void:
	push_error("D283_APPROVED_ARENAS_FAIL: " + problem)
	quit(1)
