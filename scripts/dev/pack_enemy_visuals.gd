extends SceneTree

# Deterministic packing of NEW generated poses; no procedural pose synthesis.
const DIR := "res://assets/source_archive/enemy_visual_polish/generated/"
const OUTPUT := "res://assets/pixel/units/enemy_visual_polish/"
func _initialize() -> void:
	var roles: Array[String] = []
	var manifest: Array[Dictionary] = []
	for source_file in DirAccess.get_files_at(DIR):
		if source_file.ends_with("_source.png"):
			roles.append(source_file.trim_suffix("_source.png"))
	roles.sort()
	for role in roles:
		var source := Image.load_from_file(DIR + role + "_source.png")
		var atlas := Image.create(576, 480, false, Image.FORMAT_RGBA8)
		var factor := 1.0
		var poses: Array[Dictionary] = []
		for row in range(5):
			var count: int = [4, 6, 6, 3, 6][row]
			for col in range(count):
				var cell := source.get_region(Rect2i(col * source.get_width() / 6, row * source.get_height() / 5, source.get_width() / 6, source.get_height() / 5))
				if role == "lantern_archer" and row == 2 and col == 3:
					var cell_size := cell.get_size()
					cell = Image.load_from_file("res://assets/source_archive/enemy_visual_polish/repairs/lantern_archer_attack3.png")
					cell.resize(cell_size.x,cell_size.y,Image.INTERPOLATE_LANCZOS)
				# Discard low-alpha extraction haze, not painted anatomy.
				for y in range(cell.get_height()):
					for x in range(cell.get_width()):
						if cell.get_pixel(x, y).a < 0.65:
							cell.set_pixel(x, y, Color.TRANSPARENT)
				_keep_character(cell)
				var bounds := cell.get_used_rect()
				cell = cell.get_region(bounds)
				# These three reference sheets retain their original LEFT view.
				# Normalize their cels to RIGHT before the shared runtime flip.
				if role in ["funeral_priest", "pallbearer", "road_sentinel"]:
					cell.flip_x()
				factor = minf(factor, minf(90.0 / cell.get_width(), 86.0 / cell.get_height()))
				poses.append({"image": cell, "row": row, "col": col})
		# ONE source-to-runtime scale for all 25 poses; never fit each pose
		# independently and cause visible height pumping during a stride.
		for pose in poses:
			var cell: Image = pose.image
			var target := Vector2i(maxi(1, roundi(cell.get_width() * factor)), maxi(1, roundi(cell.get_height() * factor)))
			var silhouette := cell.duplicate() as Image
			silhouette.resize(target.x, target.y, Image.INTERPOLATE_NEAREST)
			# Recover source material detail lost by nearest downsampling. Use
			# premultiplied colour to avoid light transparent-RGB edge halos;
			# retain the EXACT already accepted nearest silhouette and pose.
			cell.premultiply_alpha()
			cell.resize(target.x, target.y, Image.INTERPOLATE_LANCZOS)
			for y in range(target.y):
				for x in range(target.x):
					var color := cell.get_pixel(x, y)
					var alpha := silhouette.get_pixel(x, y).a
					if alpha > 0.0 and color.a > 0.001:
						color = Color(clampf(color.r / color.a, 0, 1), clampf(color.g / color.a, 0, 1), clampf(color.b / color.a, 0, 1), alpha)
					else:
						color = Color.TRANSPARENT
					cell.set_pixel(x, y, color)
			atlas.blit_rect(cell, Rect2i(Vector2i.ZERO, cell.get_size()), Vector2i(pose.col * 96 + (96 - cell.get_width()) / 2, pose.row * 96 + 93 - cell.get_height()))
		print(role, " source=", source.get_size())
		atlas.save_png(OUTPUT + role + "_packed.png")
		var file := FileAccess.open(OUTPUT + role + ".webp.b64", FileAccess.WRITE)
		file.store_string(Marshalls.raw_to_base64(atlas.save_webp_to_buffer(false)))
		file.close()
		manifest.append({"role":role,"source_sha256":FileAccess.get_sha256(DIR+role+"_source.png"),"runtime_sha256":FileAccess.get_sha256(OUTPUT+role+".webp.b64"),"uniform_scale":factor,"count":25,"sole_y":92,"repair_sha256":FileAccess.get_sha256("res://assets/source_archive/enemy_visual_polish/repairs/lantern_archer_attack3.png") if role == "lantern_archer" else ""})
	var metadata := FileAccess.open(OUTPUT+"manifest.json",FileAccess.WRITE)
	metadata.store_string(JSON.stringify(manifest,"\t"))
	quit()

func _keep_character(img: Image) -> void:
	var seen := {}
	var largest: Array[Vector2i] = []
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var start := Vector2i(x, y)
			if seen.has(start) or img.get_pixelv(start).a < 0.65:
				continue
			var component: Array[Vector2i] = [start]
			seen[start] = true
			var index := 0
			while index < component.size():
				var p := component[index]
				index += 1
				for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
					var q: Vector2i = p + offset
					if q.x >= 0 and q.y >= 0 and q.x < img.get_width() and q.y < img.get_height() and not seen.has(q) and img.get_pixelv(q).a >= 0.65:
						seen[q] = true
						component.append(q)
			if component.size() > largest.size():
				largest = component
	var keep := {}
	for p in largest:
		keep[p] = true
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			if not keep.has(Vector2i(x, y)):
				img.set_pixel(x, y, Color.TRANSPARENT)
