extends SceneTree

# CI5: audit the ORIGINAL D267 Court of the Mute SpriteFrames used by Godot.
# Output atlas PNGs are exported from loaded frames, never AI-painted poses.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES := ["mute_magistrate", "ash_scrivener", "bone_bailiff"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const COUNTS := [4, 6, 6, 3, 6]
const CELL := 96

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].begins_with("/"):
		_fail("expected -- /absolute/output/directory")
		return
	var output: String = args[0]
	DirAccess.make_dir_recursive_absolute(output)
	var rows: Array[String] = ["role,state,frame,opaque_pixels,lowest_opaque_y,edge_pixels"]
	var total := 0
	for role in ROLES:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		if frames == null:
			_fail("approved Court runtime animation missing: " + role)
			return
		var first := frames.get_frame_texture("idle", 0) as AtlasTexture
		if first == null or first.atlas == null:
			_fail("court atlas source not accessible: " + role)
			return
		var image: Image = first.atlas.get_image()
		if image == null or image.get_size() != Vector2i(576, 480):
			_fail("wrong source atlas dimensions: " + role)
			return
		image.convert(Image.FORMAT_RGBA8)
		var fingerprints := {}
		for row in range(STATES.size()):
			var name: String = STATES[row]
			if not frames.has_animation(name) or frames.get_frame_count(name) != COUNTS[row]:
				_fail("missing authentic 4/6/6/3/6 frame contract: " + role + " " + name)
				return
			for column in range(COUNTS[row]):
				var tile := frames.get_frame_texture(name, column) as AtlasTexture
				if tile == null or tile.atlas == null or tile.region.size != Vector2(CELL, CELL):
					_fail("invalid original frame region: " + role + " " + name)
					return
				var px := image.get_region(Rect2i(
					Vector2i(tile.region.position), Vector2i(tile.region.size)))
				var digest := hash(px.get_data())
				if fingerprints.has(digest):
					_fail("duplicate original Court pose in " + role + ": " + name + " " + str(column))
					return
				fingerprints[digest] = true
				var opaque := 0
				var lowest := -1
				var edge := 0
				for y in range(CELL):
					for x in range(CELL):
						if px.get_pixel(x, y).a <= 0.20:
							continue
						opaque += 1
						lowest = y
						if x < 2 or x > 93 or y < 2 or y > 93:
							edge += 1
				if opaque < 70 or edge > 8:
					_fail("missing or clipped approved pose: " + role + " " + name +
						" " + str(column) + " alpha=" + str(opaque) + " edge=" + str(edge))
					return
				rows.append("%s,%s,%d,%d,%d,%d" % [role, name, column, opaque, lowest, edge])
				total += 1
		# Preserve the 5 genuinely alpha-clear unused grid cells.
		for row in range(STATES.size()):
			for column in range(COUNTS[row], 6):
				for y in range(CELL):
					for x in range(CELL):
						if image.get_pixel(column * CELL + x, row * CELL + y).a > 0.12:
							_fail("unused cell not transparent: " + role)
							return
		if fingerprints.size() != 25 or image.save_png(
			output.path_join(role + "-original-25-poses.png")) != OK:
			_fail("could not export exact original pose atlas: " + role)
			return
		print("CI5_ATLAS_PASS: ", role, " 25 unique loaded authored cells")

	var csv := FileAccess.open(output.path_join("pose-foot-and-edge-audit.csv"), FileAccess.WRITE)
	if csv == null:
		_fail("cannot write per-pose original pixel audit")
		return
	for line in rows:
		csv.store_line(line)
	csv.close()
	print("CI5_ANIMATION_PASS: 3 original Court roles, ", total,
		" unique readable 96x96 poses, five transparent cells per atlas")
	quit(0)

func _fail(message: String) -> void:
	push_error("CI5_ANIMATION_FAIL: " + message)
	quit(1)
