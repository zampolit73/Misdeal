extends SceneTree

# Deterministic packing of NEW generated poses; no procedural pose synthesis.
const DIR := "res://assets/pixel/units/hero_c3_d412/"
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
			cell.resize(maxi(1, roundi(cell.get_width() * factor)), maxi(1, roundi(cell.get_height() * factor)), Image.INTERPOLATE_NEAREST)
			atlas.blit_rect(cell, Rect2i(Vector2i.ZERO, cell.get_size()), Vector2i(pose.col * 96 + (96 - cell.get_width()) / 2, pose.row * 96 + 90 - cell.get_height()))
		print(role, " source=", source.get_size())
		atlas.save_png(DIR + role + "_packed.png")
		var file := FileAccess.open(DIR + role + ".webp.b64", FileAccess.WRITE)
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
