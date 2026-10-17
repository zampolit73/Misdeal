class_name MisdealUnitAnimationLibrary
extends RefCounted

# Grounded Animation Pack 1 v2: transparent 576x480 WebP, 6x5 cells of
# 96x96. They are stored as Base64 text for Godot export compatibility.
# Existing v4 still provides all fallback static units.
const CELL_SIZE := 96
const COLUMNS := 6
const ROWS := 5
const BASE_DIR := "res://assets/pixel/units/combat_units_anim_v2/"
const PACK2_DIR := "res://assets/pixel/units/combat_units_anim_pack2_candidates/"
const DECK_EXPANSION_DIR := "res://assets/pixel/units/deck_expansion_v1/"
const NEW_ENEMY_ROLES := ["bone_shepherd", "ossuary_lamb", "funeral_priest", "pallbearer", "plague_alchemist", "unstable_homunculus"]
const D152_ROLES := ["plague_alchemist", "unstable_homunculus"]
# D153 original undead stage actors. No legacy enemy/pose substitution permitted.
const D153_ROLES := ["threadbare_puppeteer", "bone_marionette"]
# D183 Black Crossing: the two accepted original drowned combat identities.
# QA-only until the corresponding approved image bytes are committed.
const D183_ROLES := ["drowned_ferryman", "drowned_hand"]
# D231: D229 was chosen over D228 as a TECHNICAL candidate, but the user
# flagged loss of the original rich art. This role is STAGED for UNRELEASED #38;
# do not regard source art as final quality or enable the regular card pool yet.
# The other four Black Lantern Road characters remain QA-only; no generic fallback.
const D230_APPROVED_ROLES := ["road_sentinel"]
const D151_ROLES := ["funeral_priest", "pallbearer"]
const ROLES := ["knight", "ranger", "mage", "skeleton", "bone_archer", "bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden", "bone_shepherd", "ossuary_lamb", "funeral_priest", "pallbearer", "plague_alchemist", "unstable_homunculus", "threadbare_puppeteer", "bone_marionette", "drowned_ferryman", "drowned_hand", "road_sentinel"]

static var _frames_cache: Dictionary = {}
static var _unavailable: Dictionary = {}


static func get_frames(role: String) -> SpriteFrames:
	if not ROLES.has(role):
		return null
	if _frames_cache.has(role):
		return _frames_cache[role] as SpriteFrames
	if _unavailable.has(role):
		return null


	if D230_APPROVED_ROLES.has(role):
		# One role only: user-selected D229 becomes the production 25-pose atlas.
		# Never synthesize, borrow or repeat missing frames. Card #38 is still QA-only.
		var approved_path: String = "%s%s_frames.webp.b64" % [DECK_EXPANSION_DIR, role]
		if not FileAccess.file_exists(approved_path):
			push_warning("D230 approved original Sentinel atlas missing: " + approved_path)
			return null
		var bytes_d230: PackedByteArray = Marshalls.base64_to_raw(FileAccess.get_file_as_string(approved_path).strip_edges())
		var img_d230 := Image.new()
		if bytes_d230.is_empty() or img_d230.load_webp_from_buffer(bytes_d230) != OK:
			push_warning("D230 approved Sentinel atlas cannot decode: " + approved_path)
			return null
		if img_d230.get_size() != Vector2i(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_warning("D230 approved Sentinel atlas must be 576x480: " + approved_path)
			return null
		img_d230.convert(Image.FORMAT_RGBA8)
		if not _all_authored_deck_frames_visible(img_d230) or not _all_authored_deck_frames_padded(img_d230) or not _all_authored_deck_frames_distinct(img_d230) or not _unused_deck_cells_clear(img_d230):
			push_warning("D230 rejected non-original/cropped Sentinel cells: " + approved_path)
			return null
		var texture_d230: Texture2D = ImageTexture.create_from_image(img_d230)
		if texture_d230 == null:
			return null
		return _create_frames(role, texture_d230)

	if D183_ROLES.has(role):
		# D183 uses original 96px cel atlases, never another enemy as fallback.
		# Do not add synthetic "last frame" repair or accept edge-cropped art.
		var source_path: String = "%s%s_frames.webp.b64" % [DECK_EXPANSION_DIR, role]
		if not FileAccess.file_exists(source_path):
			push_warning("D183 approved animation file not in repository yet: " + source_path)
			return null
		var raw: PackedByteArray = Marshalls.base64_to_raw(FileAccess.get_file_as_string(source_path).strip_edges())
		var img := Image.new()
		if raw.is_empty() or img.load_webp_from_buffer(raw) != OK:
			push_warning("D183 animation WebP decode failed: " + source_path)
			return null
		if img.get_size() != Vector2i(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_warning("D183 animation must be 576x480: " + source_path)
			return null
		if not _all_authored_deck_frames_visible(img) or not _all_authored_deck_frames_padded(img) or not _all_authored_deck_frames_distinct(img) or not _unused_deck_cells_clear(img):
			push_warning("D183 requires 25 unique padded poses and five empty cells: " + source_path)
			return null
		var texture: Texture2D = ImageTexture.create_from_image(img)
		if texture == null:
			return null
		return _create_frames(role, texture)

	if D153_ROLES.has(role):
		# D153 must ship two NEW 25-frame full-body atlases, never a legacy
		# skeleton fallback, never synthetic/repeated/edge-cropped poses.
		var d153_path: String = "%s%s_frames.webp.b64" % [DECK_EXPANSION_DIR, role]
		if not FileAccess.file_exists(d153_path):
			push_warning("D153 original animation atlas not yet installed: " + d153_path)
			return null
		var encoded_d153: String = FileAccess.get_file_as_string(d153_path).strip_edges()
		var d153_bytes: PackedByteArray = Marshalls.base64_to_raw(encoded_d153)
		var d153_image := Image.new()
		if d153_bytes.is_empty() or d153_image.load_webp_from_buffer(d153_bytes) != OK:
			push_warning("D153 animation cannot decode: " + d153_path)
			return null
		if d153_image.get_size() != Vector2i(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_warning("D153 atlas is not 576x480: " + d153_path)
			return null
		if not _all_authored_deck_frames_visible(d153_image) or not _all_authored_deck_frames_padded(d153_image) or not _all_authored_deck_frames_distinct(d153_image):
			push_warning("D153 atlas has empty, repeated or cropped poses: " + d153_path)
			return null
		var d153_texture: Texture2D = ImageTexture.create_from_image(d153_image)
		if d153_texture == null:
			return null
		return _create_frames(role, d153_texture)

	if D152_ROLES.has(role):
		# Original D152 candidate sheets are separate 576x480 PNGs. Missing or
		# clipped art must never silently reuse an older enemy's sprite.
		# Production atlas will use the established export-safe .webp.b64 format.
		# Until native visual approval, an ignored local PNG candidate can be
		# unpacked from the separately provided art preview pack.
		var d152_raster_path := "%s%s_frames.webp.b64" % [DECK_EXPANSION_DIR, role]
		var d152_preview_path := "res://assets/local_previews/d152/%s_frames.png" % role
		var d152_image := Image.new()
		if FileAccess.file_exists(d152_raster_path):
			var d152_bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(d152_raster_path).strip_edges())
			if d152_bytes.is_empty() or d152_image.load_webp_from_buffer(d152_bytes) != OK:
				push_warning("D152 production animation atlas corrupt: %s" % d152_raster_path)
				return null
		else:
			if not FileAccess.file_exists(d152_preview_path):
				push_warning("D152 original animation atlas not installed: %s" % d152_preview_path)
				return null
			if d152_image.load(d152_preview_path) != OK:
				push_warning("D152 original preview atlas cannot load: %s" % d152_preview_path)
				return null
		if d152_image.get_size() != Vector2i(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_warning("D152 original animation atlas size invalid: %s" % role)
			return null
		if not _all_authored_deck_frames_visible(d152_image) or not _all_authored_deck_frames_padded(d152_image) or not _all_authored_deck_frames_distinct(d152_image):
			push_warning("D152 original animation cells missing or cropped: %s" % role)
			return null
		var d152_texture := ImageTexture.create_from_image(d152_image)
		if d152_texture == null:
			return null
		return _create_frames(role, d152_texture)

	if NEW_ENEMY_ROLES.has(role):
		# D147: approved raster animation atlas has precedence over legacy SVG.
		# Text-packed WebP mirrors the existing animation packs and is Godot export-safe.
		var raster_path := "%s%s_frames.webp.b64" % [DECK_EXPANSION_DIR, role]
		if FileAccess.file_exists(raster_path):
			var encoded_raster := FileAccess.get_file_as_string(raster_path).strip_edges()
			var raster_bytes := Marshalls.base64_to_raw(encoded_raster)
			var raster_image := Image.new()
			if not raster_bytes.is_empty() and raster_image.load_webp_from_buffer(raster_bytes) == OK:
				if raster_image.get_size() == Vector2i(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
					# D148: a source atlas may have empty alpha in an otherwise valid cell.
					# Fill only missing frames before turning the image into a texture;
					# never let an empty idle/walk/attack frame flicker on screen.
					var frames_valid := false
					if D151_ROLES.has(role):
						# D151 must have all 25 independently authored nontransparent frames.
						# Unlike the already-shipped D147 atlas, never synthesize missing poses.
						# Reject edge-cropped actor poses even when every cell has alpha.
						frames_valid = _all_authored_deck_frames_visible(raster_image) and _all_authored_deck_frames_padded(raster_image)
					else:
						frames_valid = _repair_empty_deck_frames(raster_image, role)
					if frames_valid:
						var raster_texture := ImageTexture.create_from_image(raster_image)
						if raster_texture != null:
							return _create_frames(role, raster_texture)
			push_warning("Deck Expansion animation atlas absent, invalid or has empty frames: %s" % raster_path)
		if D151_ROLES.has(role):
			# The new enemy does not borrow old SVG or enemy art on failure.
			_unavailable[role] = true
			return null
		var svg_path := "%s%s_frames.svg" % [DECK_EXPANSION_DIR, role]
		var svg_texture := load(svg_path) as Texture2D
		if svg_texture == null or svg_texture.get_size() != Vector2(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_error("Original Deck Expansion SVG animation atlas missing/invalid: %s" % svg_path)
			_unavailable[role] = true
			return null
		return _create_frames(role, svg_texture)

	var directory := PACK2_DIR if role in ["bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden"] else BASE_DIR
	var path := "%s%s.webp.b64" % [directory, role]
	if not FileAccess.file_exists(path):
		_unavailable[role] = true
		push_warning("Animation atlas missing: %s (using static v4 art)" % path)
		return null

	var encoded := FileAccess.get_file_as_string(path).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		_unavailable[role] = true
		push_warning("Cannot decode animation atlas: %s" % path)
		return null

	var img := Image.new()
	if img.load_webp_from_buffer(bytes) != OK or img.get_width() != CELL_SIZE * COLUMNS or img.get_height() != CELL_SIZE * ROWS:
		_unavailable[role] = true
		push_warning("Animation atlas format or dimensions invalid: %s" % path)
		return null

	var atlas := ImageTexture.create_from_image(img)
	if atlas == null:
		_unavailable[role] = true
		return null

	return _create_frames(role, atlas)


# Only the explicitly authored (4/6/6/3/6) cells should be checked.
# WebP can leave alpha=1 compression noise in otherwise transparent cells;
# sample against a real visibility threshold, not alpha != 0.
static func _deck_frame_visible(image: Image, column: int, row: int) -> bool:
	var left := column * CELL_SIZE
	var top := row * CELL_SIZE
	for y in range(2, CELL_SIZE, 4):
		for x in range(2, CELL_SIZE, 4):
			if image.get_pixel(left + x, top + y).a > 0.12:
				return true
	return false


# Only 25 used cells are expected to contain original artwork. Empty cells
# are a hard failure for these new roles instead of repeating neighbouring poses.
static func _all_authored_deck_frames_visible(image: Image) -> bool:
	var state_counts := [4, 6, 6, 3, 6]
	for row in range(state_counts.size()):
		for col in range(state_counts[row]):
			if not _deck_frame_visible(image, col, row):
				return false
	return true


# D152 quality gate: avoid visually frozen frames being disguised as authored motion.
# Compare raw 96px cells exactly; a repeated pose is a failed preview, not filler.
static func _all_authored_deck_frames_distinct(image: Image) -> bool:
	var state_counts := [4, 6, 6, 3, 6]
	var fingerprints: Dictionary = {}
	for row in range(state_counts.size()):
		for col in range(state_counts[row]):
			var tile := image.get_region(Rect2i(col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE))
			var fingerprint := hash(tile.get_data())
			if fingerprints.has(fingerprint):
				push_warning("Original Deck Expansion art has duplicated animation cells: %d:%d" % [row, col])
				return false
			fingerprints[fingerprint] = true
	return true


# D151 quality gate: native 96px cells must contain the *whole* actor.
# A frame with opaque pixels crowding the first/last two columns or rows
# has probably lost hands, boots, cloak or coffin at the cell boundary.
# This rule is intentionally opt-in for new unpublished D151 enemy roles.
static func _all_authored_deck_frames_padded(image: Image) -> bool:
	var state_counts := [4, 6, 6, 3, 6]
	for row in range(state_counts.size()):
		for col in range(state_counts[row]):
			var left := col * CELL_SIZE
			var top := row * CELL_SIZE
			var border_pixels := 0
			for pixel in range(CELL_SIZE):
				for margin in range(2):
					if image.get_pixel(left + pixel, top + margin).a > 0.25:
						border_pixels += 1
					if image.get_pixel(left + pixel, top + CELL_SIZE - 1 - margin).a > 0.25:
						border_pixels += 1
					if image.get_pixel(left + margin, top + pixel).a > 0.25:
						border_pixels += 1
					if image.get_pixel(left + CELL_SIZE - 1 - margin, top + pixel).a > 0.25:
						border_pixels += 1
			if border_pixels > 8:
				push_warning("Original Deck Expansion art needs full-size frames: cropped at %d:%d" % [row, col])
				return false
	return true


static func _repair_empty_deck_frames(image: Image, role: String) -> bool:
	var state_names := ["idle", "walk", "attack", "hit", "death"]
	var state_counts := [4, 6, 6, 3, 6]
	for row in range(state_names.size()):
		var previous_valid := -1
		for column in range(state_counts[row]):
			if _deck_frame_visible(image, column, row):
				previous_valid = column
				continue
			if previous_valid < 0:
				return false
			var source := image.get_region(Rect2i(previous_valid * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE))
			image.blit_rect(source, Rect2i(0, 0, CELL_SIZE, CELL_SIZE), Vector2i(column * CELL_SIZE, row * CELL_SIZE))
			push_warning("Repaired transparent %s %s frame %d with previous visible pose." % [role, state_names[row], column])
	return true


# A 6x5 atlas has 30 slots but just 25 authored poses.
# Compression noise near zero-alpha can occur; only material alpha counts.
static func _unused_deck_cells_clear(image: Image) -> bool:
	var state_counts := [4, 6, 6, 3, 6]
	for row in range(state_counts.size()):
		for col in range(state_counts[row], COLUMNS):
			for y in range(CELL_SIZE):
				for x in range(CELL_SIZE):
					if image.get_pixel(col * CELL_SIZE + x, row * CELL_SIZE + y).a > 0.12:
						push_warning("D183 atlas must have no neighboring sprite leakage: row %d column %d" % [row, col])
						return false
	return true


static func get_static_texture(role: String) -> Texture2D:
	var frames := get_frames(role)
	if frames == null or frames.get_frame_count("idle") == 0:
		return null
	return frames.get_frame_texture("idle", 0)

static func _create_frames(role: String, atlas: Texture2D) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	_add_row(frames, atlas, "idle", 0, 4, 2.7, true)
	_add_row(frames, atlas, "walk", 1, 6, 7.0, true)
	_add_row(frames, atlas, "attack", 2, 6, 14.0 if role == "mage" else 16.0, false, role)
	_add_row(frames, atlas, "hit", 3, 3, 12.0, false)
	_add_row(frames, atlas, "death", 4, 6, 10.0, false)
	_frames_cache[role] = frames
	return frames


static func _add_row(frames: SpriteFrames, atlas: Texture2D, name: String, row: int, count: int, fps: float, looping: bool, role: String = "") -> void:
	frames.add_animation(name)
	frames.set_animation_speed(name, fps)
	frames.set_animation_loop(name, looping)
	for x in range(count):
		var frame_column := x
		var tile := AtlasTexture.new()
		tile.atlas = atlas
		tile.region = Rect2(float(frame_column * CELL_SIZE), float(row * CELL_SIZE), float(CELL_SIZE), float(CELL_SIZE))
		frames.add_frame(name, tile)
