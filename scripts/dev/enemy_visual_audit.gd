extends SceneTree

const LIB := preload("res://scripts/battle/unit_animation_library.gd")
const STATES := ["idle", "walk", "attack", "hit", "death"]

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	var output := args[0] if args.size() == 1 else "res://docs/qa/enemy_visual_polish/current_atlases/"
	if not output.ends_with("/"):
		output += "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	var report: Array[Dictionary] = []
	for role in LIB.ROLES:
		if LIB.C3_HERO_ROLES.has(role):
			continue
		var frames: SpriteFrames = LIB.get_frames(role)
		var entry := {"role": role, "animated": frames != null, "states": {}}
		if frames != null:
			var atlas := Image.create(576, 480, false, Image.FORMAT_RGBA8)
			for row in range(STATES.size()):
				var state: String = STATES[row]
				var count := frames.get_frame_count(state)
				var bounds: Array[Rect2i] = []
				for i in range(count):
					var texture := frames.get_frame_texture(state, i)
					var image := texture.get_image()
					if row == 0 and i == 0:
						entry["idle_height"] = image.get_used_rect().size.y
					bounds.append(image.get_used_rect())
					atlas.blit_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i(i * 96, row * 96))
				entry.states[state] = {"count": count, "fps": frames.get_animation_speed(state), "bounds": str(bounds)}
			atlas.save_png(output + role + ".png")
			print("ENEMY_AUDIT ", role, " ", entry.states)
		report.append(entry)
	var file := FileAccess.open(output + "inventory.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	print("ENEMY_AUDIT_COMPLETE roles=", report.size())
	quit()
