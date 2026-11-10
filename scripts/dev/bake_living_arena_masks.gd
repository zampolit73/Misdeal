extends SceneTree
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute("res://assets/pixel/battle/living_masks")
	for id in PROFILE.PILOTS:
		var image := PROFILE.build_mask(id)
		assert(image.save_png("res://assets/pixel/battle/living_masks/"+id+".png")==OK)
		print("LIVING_MASK_BAKED: ",id)
	quit()
