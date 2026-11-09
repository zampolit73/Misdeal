extends SceneTree

# Deterministic packing of NEW generated poses; no procedural pose synthesis.
const DIR := "res://assets/pixel/units/hero_c3_d412/"
const OUTPUT := "res://assets/pixel/units/hero_c3_d412_polish/"
func _initialize() -> void:
	for role in ["knight", "ranger", "mage"]:
		var source := Image.load_from_file(DIR + role + "_source.png")
		var atlas := Image.create(576, 480, false, Image.FORMAT_RGBA8)
		var factor := 0.38
		if role == "mage":
			factor = 0.41
		var poses: Array[Dictionary] = []
		for row in range(5):
			var count: int = [4, 6, 6, 3, 6][row]
			for col in range(count):
				var cell := source.get_region(Rect2i(col * source.get_width() / 6, row * source.get_height() / 5, source.get_width() / 6, source.get_height() / 5))
				# Discard low-alpha extraction haze, not painted anatomy.
				for y in range(cell.get_height()):
					for x in range(cell.get_width()):
						if cell.get_pixel(x, y).a < 0.65:
							cell.set_pixel(x, y, Color.TRANSPARENT)
				_keep_character(cell)
				var bounds := cell.get_used_rect()
				cell = cell.get_region(bounds)
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
			atlas.blit_rect(cell, Rect2i(Vector2i.ZERO, cell.get_size()), Vector2i(pose.col * 96 + (96 - cell.get_width()) / 2, pose.row * 96 + 90 - cell.get_height()))
		print(role, " source=", source.get_size())
		atlas.save_png(OUTPUT + role + "_packed.png")
		var file := FileAccess.open(OUTPUT + role + ".webp.b64", FileAccess.WRITE)
		file.store_string(Marshalls.raw_to_base64(atlas.save_webp_to_buffer(false)))
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
