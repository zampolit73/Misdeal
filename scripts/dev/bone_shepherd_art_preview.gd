extends Control

# Isolated 1280×720 production-art preview; live Fate Spread is never touched.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const CARD_ART := preload("res://scripts/ui/card_art_catalog.gd")
const STATES := ["idle", "walk", "attack", "hit", "death"]

var actors: Array[AnimatedSprite2D] = []
var state_caption: Label

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#100c0d")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var title := Label.new()
	title.text = "MISDEAL — КОСТЯНОЙ ПАСТУХ • ГАЛЕРЕЯ НОВЫХ ВРАГОВ"
	title.position = Vector2(44, 39)
	title.size = Vector2(1190, 55)
	title.add_theme_color_override("font_color", Color("#dfb77e"))
	title.add_theme_font_size_override("font_size", 24)
	add_child(title)

	var card := TextureRect.new()
	card.position = Vector2(38, 133)
	card.size = Vector2(545, 334)
	card.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	card.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	card.texture = CARD_ART.get_run_card_texture("bone_shepherd")
	add_child(card)

	var caption := Label.new()
	caption.text = "ОРИГИНАЛЬНЫЙ АРТ КАРТЫ • 448×274"
	caption.position = Vector2(42, 480)
	caption.size = Vector2(540, 28)
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_color_override("font_color", Color("#b09b7c"))
	add_child(caption)

	for index in range(2):
		var role := "bone_shepherd" if index == 0 else "ossuary_lamb"
		var actor := AnimatedSprite2D.new()
		actor.position = Vector2(763 + index * 271, 331)
		actor.scale = Vector2(2.1, 2.1)
		actor.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		actor.flip_h = true
		actor.sprite_frames = LIBRARY.get_frames(role)
		add_child(actor)
		actors.append(actor)
		if actor.sprite_frames != null:
			actor.play("idle")
		var line := ColorRect.new()
		line.color = Color("#8b6c56")
		line.position = Vector2(actor.position.x - 91, 431)
		line.size = Vector2(182, 2)
		add_child(line)
		var label := Label.new()
		label.text = "КОСТЯНОЙ ПАСТУХ" if index == 0 else "КОСТЯНОЙ АГНЕЦ"
		label.position = Vector2(actor.position.x - 139, 468)
		label.size = Vector2(278, 37)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color("#dfb77e"))
		label.add_theme_font_size_override("font_size", 17)
		add_child(label)

	state_caption = Label.new()
	state_caption.text = "Выберите анимацию — видны реальные отдельные кадры."
	state_caption.position = Vector2(65, 564)
	state_caption.size = Vector2(1150, 34)
	state_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(state_caption)
	for i in range(STATES.size()):
		var button := Button.new()
		button.text = STATES[i].to_upper()
		button.position = Vector2(105 + i * 219, 614)
		button.size = Vector2(194, 44)
		button.pressed.connect(_choose_state.bind(STATES[i]))
		add_child(button)

func _choose_state(state: String) -> void:
	state_caption.text = "РЕЖИМ: " + state.to_upper()
	for actor in actors:
		if actor.sprite_frames != null:
			actor.stop()
			actor.play(state)
