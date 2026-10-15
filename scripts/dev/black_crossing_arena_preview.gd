extends Control

# D187 visual integration check only. The approved empty storm arena is not
# automatically a live encounter; this scene must never spawn gameplay units.
const ARENA_ID := "black_crossing"
const EXPECTED_SIZE := Vector2(1280.0, 720.0)

@onready var battle_backdrop: TextureRect = $BattleBackdrop


func _ready() -> void:
	if not battle_backdrop.has_method("set_arena_id"):
		_show_error("D187 / Нет загрузчика боевых арен.")
		return
	battle_backdrop.call("set_arena_id", ARENA_ID)
	var art: Texture2D = battle_backdrop.texture
	if art == null or art.get_size() != EXPECTED_SIZE:
		_show_error("D187 / Утверждённый фон не загрузился (ожидается 1280×720).")
		return
	if RunState.ACT1_CARD_IDS.has(ARENA_ID):
		_show_error("D187 / Карта №37 не должна попадать в колоду до проверки боя.")
		return
	print("D187 / BLACK CROSSING STORM PIER — ART LOADED 1280x720")


func _show_error(message: String) -> void:
	var error_label := Label.new()
	error_label.text = message
	error_label.position = Vector2(90.0, 300.0)
	error_label.size = Vector2(1100.0, 100.0)
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	error_label.add_theme_font_size_override("font_size", 24)
	error_label.add_theme_color_override("font_color", Color(0.99, 0.33, 0.29))
	add_child(error_label)
	push_error(message)
