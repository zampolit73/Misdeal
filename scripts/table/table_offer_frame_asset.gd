extends RefCounted

# D278: one 272x338 transparent hand-authored frame resource.
# Four losslessly sliced Base64 *text* parts carry one WebP safely across
# the repository's UTF-8 GitHub connector. Never split the decoded binary.
const FRAGMENTS := [
	"res://assets/pixel/table/offer_frame_d278_1.webp.b64",
	"res://assets/pixel/table/offer_frame_d278_2.webp.b64",
	"res://assets/pixel/table/offer_frame_d278_3.webp.b64",
	"res://assets/pixel/table/offer_frame_d278_4.webp.b64",
]
const BYTE_COUNT := 5088
const SIZE := Vector2i(272, 338)

static var _frame: Texture2D

static func get_texture() -> Texture2D:
	if _frame != null:
		return _frame
	var encoded := ""
	for path in FRAGMENTS:
		if not FileAccess.file_exists(path):
			push_error("D278 missing frame art fragment: " + path)
			return null
		encoded += FileAccess.get_file_as_string(path).strip_edges()
	var raw: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if raw.size() != BYTE_COUNT:
		push_error("D278 frame art bytes differ from approved source.")
		return null
	var image := Image.new()
	var status := image.load_webp_from_buffer(raw)
	if status != OK or image.get_size() != SIZE:
		push_error("D278 frame art WebP failed to decode at 272x338.")
		return null
	# Frame must be a separate transparent overlay; a composite card is invalid.
	if image.get_pixel(136, 169).a > 0.05:
		push_error("D278 art has opaque card center, rejecting noninteractive composite.")
		return null
	_frame = ImageTexture.create_from_image(image)
	return _frame
