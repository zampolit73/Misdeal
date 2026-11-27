extends Node2D
## Source-space, foreground-local character animation. Each cel replaces only
## registered pixels of the original seated Squire; the original legs, seat,
## heraldry and every equipment/outcome layer stay in the shared camp painting.
const DIR := "res://assets/pixel/travel/cinematic_v5/boots_wide/"
const RECT := Rect2i(230,145,470,515)
const CEL_SIZE := Vector2i(235,258)
const POSES := ["pull","thread","glance","press"]
const ORIGINAL := -1
static var _textures: Array[Texture2D] = []
var sprite: Sprite2D
var pose := ORIGINAL

func build() -> bool:
	if _textures.is_empty():
		var loaded: Array[Texture2D] = []
		for name in POSES:
			var img := Image.new()
			var bytes := FileAccess.get_file_as_bytes(DIR+name+".webp")
			if bytes.is_empty() or img.load_webp_from_buffer(bytes)!=OK or img.get_size()!=CEL_SIZE:
				return false
			loaded.append(ImageTexture.create_from_image(img))
		_textures.assign(loaded)
	sprite = Sprite2D.new()
	sprite.name = "SquireWorkCel"
	sprite.centered = false
	sprite.position = Vector2(RECT.position)
	sprite.scale = Vector2(RECT.size)/Vector2(CEL_SIZE)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(sprite)
	seek(0.0,"passed")
	return true

static func work_pose(t: float) -> int:
	# Distinct strap manipulation phases, including the original source pose
	# between cycles, so the character never snaps to an unrelated silhouette.
	var phase := fposmod(t,1.55)
	if phase < 0.28: return ORIGINAL
	if phase < 0.59: return 0 # pull
	if phase < 0.94: return 1 # thread
	if phase < 1.26: return 3 # press
	return ORIGINAL

static func pose_for(t: float, outcome: String) -> int:
	# Passed travellers never commit a shoe transaction. A brief glance is
	# simply the seated craftsman's response, not an outcome or state change.
	if outcome=="passed":
		return 2 if t>=2.15 and t<2.62 else work_pose(t)
	if t<2.30: return work_pose(t)
	if t<2.46: return ORIGINAL
	if t<3.15: return 2
	if t<3.33: return ORIGINAL
	if t<3.65: return 0 if outcome=="repair" else 3
	if t<4.05: return 1 if outcome=="repair" else 2
	if t<4.38: return 3
	return work_pose(t-4.38)

func seek(t: float, outcome: String) -> void:
	pose = pose_for(t,outcome)
	sprite.visible = pose!=ORIGINAL
	if sprite.visible: sprite.texture = _textures[pose]
