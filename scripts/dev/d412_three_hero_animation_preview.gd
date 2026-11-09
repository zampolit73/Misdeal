extends "res://scripts/dev/d398_c3_hero_animation_preview.gd"

func _ready() -> void:
	super._ready()
	for child in stage.get_children():
		if child is Label:
			if child.text.begins_with("MISDEAL"):
				child.text = "MISDEAL / D412 — ПОЛНЫЙ ПАКЕТ ТРЁХ ГЕРОЕВ"
			elif child.text.contains("D409:"):
				child.text = "Справа: новые 25 поз на героя. Это QA-кандидаты; рабочие атласы сохранены для отката."
			elif child.text.contains("Нажмите WALK"):
				child.text = "AUTO: ожидание → ходьба → атака → удар → смерть."
			elif child.text == "C3 / В БОЮ":
				child.text = "D412 / QA"
	for i in range(3):
		var frames := SpriteFrames.new()
		frames.remove_animation("default")
		var img := Image.new()
		img.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string("res://assets/pixel/units/hero_c3_d412_polish/%s.webp.b64" % ROLES[i])))
		var tex := ImageTexture.create_from_image(img)
		for row in range(5):
			var state: String = STATES[row]
			frames.add_animation(state)
			frames.set_animation_speed(state, FPS[row])
			frames.set_animation_loop(state, row < 2)
			for col in range([4, 6, 6, 3, 6][row]):
				var tile := AtlasTexture.new()
				tile.atlas = tex
				tile.region = Rect2(col * 96, row * 96, 96, 96)
				frames.add_frame(state, tile)
		c3_actors[i].sprite_frames = frames
		var factor := 1.47 if i == 0 or i == 2 else 1.40
		c3_actors[i].scale = Vector2.ONE * factor
		c3_actors[i].position.y = SOLE_Y - (90.0 - 48.0) * factor
	_play("walk")
	status_label.text = "D412 — НОВЫЕ 75 ПОЗ · справа новый пакет, слева архив · AUTO: пять состояний"
	var facing := Button.new()
	facing.text = "← / →"
	facing.position = Vector2(1110, 640)
	facing.size = Vector2(100, 36)
	facing.pressed.connect(func() -> void:
		for actor in c3_actors + original_actors:
			actor.flip_h = not actor.flip_h)
	stage.add_child(facing)

func _play(state: String) -> void:
	super._play(state)
	status_label.text = "D412 / %s — новые 25 поз на героя · художественная проверка" % state.to_upper()
