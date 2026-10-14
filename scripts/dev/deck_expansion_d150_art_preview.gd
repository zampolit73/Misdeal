extends Control

# D150 standalone visual QA: neither changes RunState nor the live table UI.
const CARD_ART := preload("res://scripts/ui/card_art_catalog.gd")

func _ready() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("#100c0d")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	_add_text("MISDEAL — DECK EXPANSION 02 • НОВЫЕ ИЛЛЮСТРАЦИИ", Vector2(92, 42), Vector2(1090, 48), 25, Color("#dfb77e"))
	_add_text("Самостоятельные арты 448×274 без рамки и текста. Подписи добавляет сама игра.", Vector2(94, 102), Vector2(1090, 37), 15, Color("#b8a48c"))

	_show_card("moon_seal", "ЛУННАЯ ПЕЧАТЬ", "res://assets/pixel/card_unification_v1/run/moon_seal.webp", Vector2(94, 165))
	_show_card("echo_crypt", "СКЛЕП ОТЗВУКОВ", "res://assets/pixel/card_unification_v1/run/echo_crypt.webp", Vector2(736, 165))

	_add_text("Проверьте: холодный лунный свет, бронза и свечи, читаемость предмета, никаких видимых надписей или рамок внутри иллюстраций.",
		Vector2(95, 615), Vector2(1110, 70), 15, Color("#b8a48c"))


func _show_card(card_id: String, title: String, path: String, origin: Vector2) -> void:
	var texture_rect := TextureRect.new()
	texture_rect.position = origin
	texture_rect.size = Vector2(448, 274)
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	texture_rect.texture = CARD_ART.get_run_card_texture(card_id)
	add_child(texture_rect)

	_add_text(title, origin + Vector2(0, 293), Vector2(448, 35), 21, Color("#dfb77e"))
	var installed := FileAccess.file_exists(path)
	var status := "D150 • оригинальный WebP найден" if installed else "ВРЕМЕННЫЙ АРТ: WebP ещё не установлен"
	_add_text(status, origin + Vector2(0, 336), Vector2(448, 40), 14,
		Color("#8ecbaa") if installed else Color("#dca56d"))


func _add_text(value: String, at: Vector2, dimensions: Vector2, font_size: int, color: Color) -> void:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dimensions
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	add_child(label)
