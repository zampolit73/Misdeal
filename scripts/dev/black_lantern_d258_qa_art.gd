extends RefCounted

# D258: Test-only original illustrated D257 atlas loader.
# Never populate MisdealUnitAnimationLibrary or unlock card #38.
const D249_VALIDATOR := preload("res://scripts/dev/black_lantern_d249_five_enemy_combat_qa.gd")
const ART_PATHS := {
	"extinguished_guide": "res://assets/pixel/units/black_lantern_road_qa/extinguished_guide_d257_seam_recovery_qa.webp.b64",
	"oil_acolyte": "res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d257_seam_recovery_qa.webp.b64",
	"lantern_archer": "res://assets/pixel/units/black_lantern_road_qa/lantern_archer_d257_seam_recovery_qa.webp.b64"
}
# The illustrated source artwork for these two roles faces LEFT. BattleUnit's
# default combat sprites face RIGHT, so mirror full 96px cells in QA memory.
# This preserves normal target-facing without modifying core BattleUnit code.
const SOURCE_FACES_LEFT := ["extinguished_guide", "lantern_archer"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const FRAME_COUNTS := [4, 6, 6, 3, 6]
const CELL := 96


static func get_frames(role: String) -> SpriteFrames:
	if not ART_PATHS.has(role):
		push_error("D258: unknown original Black Lantern QA role: " + role)
		return null
	var validator: Control = D249_VALIDATOR.new()
	var original := validator.call("_read_temporary_original", str(ART_PATHS[role])) as SpriteFrames
	validator.free()
	if original == null:
		push_error("D258: 25-pose art validation failed: " + role)
		return null
	if not SOURCE_FACES_LEFT.has(role):
		return original
	# Keep state timing intact; mirror *each pose's pixels*, not the combat
	# sprite's runtime flip, because BattleUnit already handles target facing.
	var image := Image.create_empty(CELL * 6, CELL * 5, false, Image.FORMAT_RGBA8)
	for row in range(STATES.size()):
		var state: String = STATES[row]
		if original.get_frame_count(state) != FRAME_COUNTS[row]:
			return null
		for col in range(FRAME_COUNTS[row]):
			var source: Texture2D = original.get_frame_texture(state, col)
			if source == null:
				return null
			var pixels: Image = source.get_image()
			if pixels == null or pixels.get_size() != Vector2i(CELL, CELL):
				push_error("D258: original frame does not decode at 96x96: " + role)
				return null
			pixels.convert(Image.FORMAT_RGBA8)
			pixels.flip_x()
			image.blit_rect(pixels, Rect2i(0, 0, CELL, CELL), Vector2i(col * CELL, row * CELL))
	var atlas := ImageTexture.create_from_image(image)
	if atlas == null:
		return null
	var output := SpriteFrames.new()
	if output.has_animation("default"):
		output.remove_animation("default")
	for row in range(STATES.size()):
		var state: String = STATES[row]
		output.add_animation(state)
		output.set_animation_speed(state, original.get_animation_speed(state))
		output.set_animation_loop(state, original.get_animation_loop(state))
		for col in range(FRAME_COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = atlas
			tile.region = Rect2(float(col * CELL), float(row * CELL), float(CELL), float(CELL))
			output.add_frame(state, tile)
	return output
