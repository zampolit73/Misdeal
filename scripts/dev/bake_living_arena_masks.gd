extends SceneTree
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute("res://assets/pixel/battle/living_masks")
	var args := OS.get_cmdline_user_args()
	var ids: Array = PROFILE.V2_ARENAS if args.has("--v2") else PROFILE.PILOTS
	if args.has("--v3"):
		ids = PROFILE.V3_ARENAS
		for batch in range(PROFILE.V3_BATCHES.size()):
			if args.has("--batch-"+str(batch+1)):
				ids = PROFILE.V3_BATCHES[batch]
	for id: String in ids:
		var image := PROFILE.build_mask(id)
		assert(image.save_png("res://assets/pixel/battle/living_masks/"+id+".png")==OK)
		print("LIVING_MASK_BAKED: ",id)
	quit()
