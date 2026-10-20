extends RefCounted

# D300: Original-resolution D299 source-art fragments, cropped with softer
# hand-directed alpha and less destructive compression. Text-packed for GitHub.
# The prior D299 pack is preserved verbatim for rollback.
# No text, values, button surfaces, units or combat background are baked here.
const PACK_PATH := "res://assets/pixel/ui/battle_ds3_d300/reference_fragments_hq.webp.pack.b64"
const TOTAL_BYTES := 23510
const FRAGMENTS := {
	"banner": Vector2i(0, 7454),
	"medallion": Vector2i(7454, 5408),
	"candles": Vector2i(12862, 4704),
	"wax_ribbon": Vector2i(17566, 5944),
}
const SOURCE_SIZES := {
	"banner": Vector2i(111, 189),
	"medallion": Vector2i(88, 113),
	"candles": Vector2i(57, 172),
	"wax_ribbon": Vector2i(84, 178),
}

static var _source_bytes: PackedByteArray = PackedByteArray()
static var _textures: Dictionary = {}


static func get_fragment(id: String) -> Texture2D:
	if _textures.has(id):
		return _textures[id] as Texture2D
	if not FRAGMENTS.has(id):
		push_error("D300: Unknown approved Battle fragment: " + id)
		return null
	if _source_bytes.is_empty():
		var encoded := FileAccess.get_file_as_string(PACK_PATH).strip_edges()
		if encoded.is_empty():
			push_error("D300: Approved Battle material pack missing: " + PACK_PATH)
			return null
		_source_bytes = Marshalls.base64_to_raw(encoded)
		if _source_bytes.size() != TOTAL_BYTES:
			push_error("D300: Invalid Battle art pack size: %d" % _source_bytes.size())
			_source_bytes.clear()
			return null
	var offset: Vector2i = FRAGMENTS[id]
	var image := Image.new()
	var err := image.load_webp_from_buffer(_source_bytes.slice(offset.x, offset.x + offset.y))
	if err != OK:
		push_error("D300: Failed to decode Battle fragment %s: %s" % [id, error_string(err)])
		return null
	if image.get_size() != SOURCE_SIZES[id]:
		push_error("D300: Unexpected fragment dimensions for " + id)
		return null
	var texture := ImageTexture.create_from_image(image)
	_textures[id] = texture
	return texture
