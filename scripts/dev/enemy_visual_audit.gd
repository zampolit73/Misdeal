extends SceneTree

const LIB := preload("res://scripts/battle/unit_animation_library.gd")
const STATES := ["idle", "walk", "attack", "hit", "death"]

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1:
		push_error("Usage: --script res://scripts/dev/enemy_visual_audit.gd -- <absolute-output-directory>")
		quit(1)
		return
	var output := args[0]
	DirAccess.make_dir_recursive_absolute(output)
	var report: Array[Dictionary] = []
	for role: String in LIB.ROLES.slice(3):
		var pair := Image.create(1152,480,false,Image.FORMAT_RGBA8)
		pair.fill(Color("242023"))
		var entry := {"role":role,"before":[],"after":[]}
		for polished in [false,true]:
			var frames := LIB.get_frames(role,true,polished)
			assert(frames != null and LIB.is_polished_enemy_frames(role,frames) == polished)
			var states: Array = entry.after if polished else entry.before
			for row in range(STATES.size()):
				var state: String = STATES[row]
				var count := frames.get_frame_count(state)
				var bounds: Array = []
				for i in range(count):
					var cel := frames.get_frame_texture(state,i).get_image()
					cel.convert(Image.FORMAT_RGBA8)
					if not polished and role in ["funeral_priest","pallbearer","road_sentinel"]:
						cel.flip_x()
					pair.blend_rect(cel,Rect2i(0,0,96,96),Vector2i(i*96+(576 if polished else 0),row*96))
					var rect := cel.get_used_rect()
					bounds.append([rect.position.x,rect.position.y,rect.size.x,rect.size.y])
				states.append({"state":state,"fps":frames.get_animation_speed(state),"bounds":bounds})
		assert(pair.save_webp(output.path_join(role+".webp"),true,0.94) == OK)
		report.append(entry)
	var file := FileAccess.open(output.path_join("inventory.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t")+"\n")
	file.close()
	print("ENEMY_AUDIT_COMPLETE: ",report.size()," roles and 600 candidate poses")
	quit()
