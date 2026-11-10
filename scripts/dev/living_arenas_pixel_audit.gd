extends SceneTree
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
func _initialize() -> void:
	var base := OS.get_cmdline_user_args()[0]
	var results: Array[Dictionary] = []
	for id in PROFILE.PILOTS:
		var original := Image.load_from_file(base.path_join(id+"_before.webp"))
		var first := Image.load_from_file(base.path_join(id+"_motion_000.webp"))
		var last := Image.load_from_file(base.path_join(id+"_motion_095.webp"))
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
				if protected and original.get_pixel(x,y)!=b: protected_changes+=1
		assert(moving>10,"Not a static mockup: "+id)
		assert(protected_changes==0,"Protected floor pixels changed: "+id+" "+str(protected_changes))
		results.append({"arena":id,"changed_sample_pixels":moving,"max_rgb_sum_delta":max_delta,"protected_floor_changes":protected_changes,"sampling_step":2})
	var file := FileAccess.open(base.path_join("pixel_audit.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(results,"\t"))
	print("LIVING_PIXEL_AUDIT_PASS: ",results)
	quit()
