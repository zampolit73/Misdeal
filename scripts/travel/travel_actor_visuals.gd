extends RefCounted
## Cinematic-only high-detail presentation. Existing 96px SpriteFrames remain the
## authoritative logical geometry; native 288px painted textures draw at 96px.
## Never replace the BattleUnit library/cache or invent new poses.
const ANIM := preload("res://scripts/battle/unit_animation_library.gd")
const ROOT := "res://assets/pixel/travel/actors_hd/"
const HD_ENABLED := true
const CELL := 96
const DETAIL := 288
const ROLES := ["knight", "ranger", "mage", "jack"]
const CLIPS := ["idle", "walk", "attack"]
const DOG_STATURE_M := 0.95
const DOG_REFERENCE_PX := 56.0
const DOG_HUMAN_RATIO := DOG_STATURE_M / 1.78
const LOGICAL := &"travel_logical_texture"
static var _atlases: Dictionary = {}
static var _frames: Dictionary = {}
static var _clean_ranger: Dictionary = {}

static func _atlas(name: String, size: Vector2i) -> Image:
	if not HD_ENABLED: return null
	if _atlases.has(name): return _atlases[name]
	var path := ROOT + name + ".webp.b64"
	if not FileAccess.file_exists(path): return null
	var image := Image.new()
	if image.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())) != OK or image.get_size() != size: return null
	image.convert(Image.FORMAT_RGBA8)
	_atlases[name] = image
	return image

static func is_hd(texture: Texture2D) -> bool:
	return texture != null and texture.has_meta(LOGICAL)

static func logical_image(texture: Texture2D) -> Image:
	var source: Texture2D = texture.get_meta(LOGICAL) if is_hd(texture) else texture
	return source.get_image()

static func filter_for(texture: Texture2D) -> CanvasItem.TextureFilter:
	return CanvasItem.TEXTURE_FILTER_LINEAR if is_hd(texture) else CanvasItem.TEXTURE_FILTER_NEAREST

static func frame_filter(frames: SpriteFrames) -> CanvasItem.TextureFilter:
	return filter_for(frames.get_frame_texture("walk", 0))

static func _texture(image: Image, logical: Texture2D) -> Texture2D:
	if image == null or image.get_size() != Vector2i(DETAIL, DETAIL) or image.get_used_rect().size == Vector2i.ZERO: return logical
	var texture := ImageTexture.create_from_image(image)
	texture.set_size_override(Vector2i(CELL, CELL))
	texture.set_meta(LOGICAL, logical)
	return texture

static func _cel(atlas: Image, col: int, row: int, logical: Texture2D) -> Texture2D:
	return _texture(atlas.get_region(Rect2i(col*DETAIL, row*DETAIL, DETAIL, DETAIL)), logical)

static func _copy_frames(base: SpriteFrames, atlas: Image, hd_rows: Dictionary) -> SpriteFrames:
	var result := SpriteFrames.new()
	result.remove_animation("default")
	for name in base.get_animation_names():
		result.add_animation(name)
		result.set_animation_speed(name, base.get_animation_speed(name))
		result.set_animation_loop(name, base.get_animation_loop(name))
		for i in base.get_frame_count(name):
			var original := base.get_frame_texture(name,i)
			var texture := _cel(atlas,i,int(hd_rows[name]),original) if hd_rows.has(name) else original
			if hd_rows.has(name) and not is_hd(texture): return base
			result.add_frame(name,texture,base.get_frame_duration(name,i))
	return result

static func side_frames(role: String) -> SpriteFrames:
	var base := ANIM.get_frames(role)
	if base == null or not HD_ENABLED or role not in ROLES: return base
	# Never bind the D412 painted poses to an archived fallback silhouette.
	if role != "jack" and not ANIM.is_approved_hero_frames(role,base): return base
	var key := "side_" + role
	if _frames.has(key): return _frames[key]
	var rows := 3 if role == "mage" else 2
	var atlas := _atlas(key, Vector2i(6*DETAIL, rows*DETAIL))
	if atlas == null: return base
	var map := {"idle":0,"walk":1}
	if role == "mage": map["attack"] = 2
	var result := _copy_frames(base,atlas,map)
	_frames[key] = result
	return result

static func rear_frames(role: String, facing: String, base: SpriteFrames) -> SpriteFrames:
	if not HD_ENABLED or role not in ROLES.slice(0,3) or facing not in ["ne","nw"]: return base
	var key := "rear_" + facing + "_" + role
	if _frames.has(key): return _frames[key]
	var atlas := _atlas("rear_"+facing,Vector2i(6*DETAIL,3*DETAIL))
	if atlas == null: return base
	var result := _copy_frames(base,atlas,{"walk":ROLES.find(role)})
	_frames[key] = result
	return result

static func living_texture(role: String, index: int, logical: Texture2D) -> Texture2D:
	var atlas := _atlas("living",Vector2i(4*DETAIL,4*DETAIL))
	if atlas == null: return logical
	return _cel(atlas,index,ROLES.find(role),logical)

# Reference geometry still follows the locally cleaned 96px floor-marker cel.
# HD source pixels already had the neutral storyboard line removed offline.
static func without_ranger_floor_marker(source: SpriteFrames) -> SpriteFrames:
	var key := source.get_instance_id()
	if _clean_ranger.has(key): return _clean_ranger[key]
	var output := SpriteFrames.new()
	output.remove_animation("default")
	for clip in ["idle","walk"]:
		output.add_animation(clip)
		output.set_animation_loop(clip, true)
		output.set_animation_speed(clip, source.get_animation_speed(clip))
		for i in source.get_frame_count(clip):
			var tex := source.get_frame_texture(clip,i)
			if clip == "walk":
				var image := logical_image(tex)
				for y in range(88,90):
					for x in range(29,68):
						var c := image.get_pixel(x,y)
						if maxf(c.r,maxf(c.g,c.b))-minf(c.r,minf(c.g,c.b)) < 0.08 and maxf(c.r,maxf(c.g,c.b)) > 0.30:
							image.set_pixel(x,y,Color.TRANSPARENT)
				var logical := ImageTexture.create_from_image(image)
				tex = _texture(tex.get_image(),logical) if is_hd(tex) else logical
			output.add_frame(clip,tex,source.get_frame_duration(clip,i))
	_clean_ranger[key] = output
	return output
