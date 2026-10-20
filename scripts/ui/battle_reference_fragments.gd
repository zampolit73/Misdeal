extends RefCounted

# D299: Four alpha-matted painted fragments, isolated from the chosen
# second Gothic Battle art. The repository stores the packed WebP binary as
# readable base64 to support GitHub text-only file updates.
# No text, values, button surfaces, units or combat background are baked here.
const PACK_PATH := "res://assets/pixel/ui/battle_ds3_d299/reference_fragments.webp.pack.b64"
const TOTAL_BYTES := 10084
const FRAGMENTS := {
	"banner": Vector2i(0, 2378),
	"medallion": Vector2i(2378, 2970),
	"candles": Vector2i(5348, 2052),
	"wax_ribbon": Vector2i(7400, 2684),
}
const SOURCE_SIZES := {
	"banner": Vector2i(74, 127),
	"medallion": Vector2i(74, 96),
	"candles": Vector2i(44, 135),
	"wax_ribbon": Vector2i(64, 135),
}

static var _source_bytes: PackedByteArray = PackedByteArray()
static var _textures: Dictionary = {}


static func get_fragment(id: String) -> Texture2D:
	if _textures.has(id):
		return _textures[id] as Texture2D
	if not FRAGMENTS.has(id):
		push_error("D299: Unknown approved Battle fragment: " + id)
		return null
	if _source_bytes.is_empty():
		var encoded := FileAccess.get_file_as_string(PACK_PATH).strip_edges()
		if encoded.is_empty():
			push_error("D299: Approved Battle material pack missing: " + PACK_PATH)
			return null
		_source_bytes = Marshalls.base64_to_raw(encoded)
		if _source_bytes.size() != TOTAL_BYTES:
			push_error("D299: Invalid Battle art pack size: %d" % _source_bytes.size())
			_source_bytes.clear()
			return null
	var offset: Vector2i = FRAGMENTS[id]
	var image := Image.new()
	var err := image.load_webp_from_buffer(_source_bytes.slice(offset.x, offset.x + offset.y))
	if err != OK:
		push_error("D299: Failed to decode Battle fragment %s: %s" % [id, error_string(err)])
		return null
	if image.get_size() != SOURCE_SIZES[id]:
		push_error("D299: Unexpected fragment dimensions for " + id)
		return null
	var texture := ImageTexture.create_from_image(image)
	_textures[id] = texture
	return texture
