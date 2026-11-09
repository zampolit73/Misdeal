extends SceneTree
func _initialize() -> void:
	var folder := "res://assets/source_archive/enemy_visual_polish/repairs/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(folder))
	var image := Image.load_from_file("res://assets/source_archive/enemy_visual_polish/generated/lantern_archer_source.png")
	var cell := Vector2i(image.get_width()/6,image.get_height()/5)
	for index in [2,3]:
		image.get_region(Rect2i(Vector2i(index*cell.x,2*cell.y),cell)).save_png(folder+"lantern_archer_attack"+str(index)+"_before.png")
	quit()
