extends TextureRect

# D280: a genuinely UI-free tabletop; unlike table_exact.webp this
# image contains no HUD, old encounter cards, holds or buttons.
# ASCII transport allows the linked GitHub connector to store one real
# 640x360 WebP (11,320 bytes) as three lossless Base64 fragments.
const SOURCE_PARTS := [
	"res://assets/pixel/class_select/d280_clean_table_01.webp.b64",
	"res://assets/pixel/class_select/d280_clean_table_02.webp.b64",
	"res://assets/pixel/class_select/d280_clean_table_03.webp.b64"
]
const EXPECTED_BYTES := 11320
const EXPECTED_SIZE := Vector2i(640, 360)

static var _cached: Texture2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_SCALE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if _cached == null:
		_cached = _read_source()
	texture = _cached


static func _read_source() -> Texture2D:
	var encoded := ""
	for part_path in SOURCE_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("D280 missing clean-table image fragment: " + part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()
	var raw: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if raw.size() != EXPECTED_BYTES:
		push_error("D280 clean-table source bytes mismatch.")
		return null
	var img := Image.new()
	if img.load_webp_from_buffer(raw) != OK or img.get_size() != EXPECTED_SIZE:
		push_error("D280 cannot decode clean-table WebP.")
		return null
	return ImageTexture.create_from_image(img)
