extends SceneTree
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var base := args[0]
	var v2 := args.has("--v2")
	var v3 := args.has("--v3")
	var ids: Array = PROFILE.V2_ARENAS if v2 else PROFILE.PILOTS
	if v3:
		ids = PROFILE.V3_ARENAS
		for batch in range(PROFILE.V3_BATCHES.size()):
			if args.has("--batch-"+str(batch+1)):
				ids = PROFILE.V3_BATCHES[batch]
	for arg in args.slice(1):
		if not arg.begins_with("--"):
			ids = [arg]
			break
	var results: Array[Dictionary] = []
	for id in ids:
		var original := Image.load_from_file(base.path_join(id+"_before.webp"))
		var first := Image.load_from_file(base.path_join(id+"_motion_000.webp"))
		var last := Image.load_from_file(base.path_join(id+("_motion_011.webp" if v3 else ("_motion_035.webp" if v2 else "_motion_095.webp"))))
		if v3:
			assert(original.get_size() == Vector2i(1280,720) and last.get_size() == original.get_size())
			var floor := Rect2i(0, PROFILE.V3_FLOOR_Y, 1280, 720-PROFILE.V3_FLOOR_Y)
			var protected_pixels := original.get_region(floor).get_data()
			for frame in range(12):
				var sample := Image.load_from_file(base.path_join(id+"_motion_%03d.webp"%frame))
				assert(sample.get_region(floor).get_data() == protected_pixels, id+" changed floor on frame "+str(frame))
			var resized := Image.load_from_file(base.path_join(id+"_resized.webp"))
			assert(resized.get_size() == Vector2i(960,540), id+" resize capture")
		var moving := 0
		var protected_changes := 0
		var max_delta := 0.0
		for y in range(0,720,2):
			for x in range(0,1280,2):
				var a := first.get_pixel(x,y)
				var b := last.get_pixel(x,y)
				var difference := absf(a.r-b.r)+absf(a.g-b.g)+absf(a.b-b.b)
				if difference>0.001: moving+=1
				max_delta=maxf(max_delta,difference)
				var protected := y>=356 and y<=540 if id=="black_crossing" else y>=444 and y<=560 and x>=300 and x<=1000
				if v2: protected = y >= 380
				if v3: protected = y >= PROFILE.V3_FLOOR_Y
				if protected and original.get_pixel(x,y)!=b: protected_changes+=1
		assert(moving>10,"Not a static mockup: "+id)
		assert(protected_changes==0,"Protected floor pixels changed: "+id+" "+str(protected_changes))
		results.append({"arena":id,"changed_sample_pixels":moving,"max_rgb_sum_delta":max_delta,"protected_floor_changes":protected_changes,"sampling_step":2})
	if v2:
		var phase_i := Image.load_from_file(base.path_join("warden_phase_i.webp"))
		var phase_ii := Image.load_from_file(base.path_join("warden_phase_ii.webp"))
		var changed := 0
		for y in range(0,720,2):
			for x in range(0,1280,2):
				if phase_i.get_pixel(x,y) == phase_ii.get_pixel(x,y): continue
				assert(y < 380, "Phase II must leave all walkable-floor samples intact")
				changed += 1
		assert(changed > 100, "Phase II must make a local visible difference")
		results.append({"arena":"warden","phase_two_changed_sample_pixels":changed,"protected_floor_changes":0,"sampling_step":2})
	var file := FileAccess.open(base.path_join("pixel_audit.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(results,"\t"))
	print("LIVING_PIXEL_AUDIT_PASS: ",results)
	quit()
