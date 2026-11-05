extends GutTest

const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")

func test_live_c3_mage_has_six_body_attack_frames_without_old_projectile() -> void:
	var frames: SpriteFrames = LIBRARY.get_frames("mage")
	assert_not_null(frames)
	if frames == null:
		return
	assert_eq(frames.get_frame_count("attack"), 6)
	assert_eq(frames.get_animation_speed("attack"), 14.0)
	for idx in range(6):
		var texture := frames.get_frame_texture("attack", idx) as AtlasTexture
		assert_not_null(texture)
		if texture == null:
			continue
		var wanted_column := idx
		assert_eq(int(texture.region.position.x), wanted_column * 96)
		assert_eq(int(texture.region.position.y), 2 * 96)
		assert_eq(texture.region.size, Vector2(96, 96))


func test_non_mage_roles_keep_existing_animation_contract() -> void:
	for role in ["knight", "ranger", "skeleton", "bone_archer"]:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(frames, "Source role must remain loaded: %s" % role)
		if frames == null:
			continue
		assert_eq(frames.get_frame_count("attack"), 6, "No attack regression: %s" % role)
		assert_eq(frames.get_frame_count("idle"), 4)
		assert_eq(frames.get_frame_count("walk"), 6)
		assert_eq(frames.get_frame_count("hit"), 3)
		assert_eq(frames.get_frame_count("death"), 6)


func test_real_battle_mage_uses_same_six_frame_c3_library() -> void:
	var mage := UNIT_SCENE.instantiate() as BattleUnit
	mage.team = 0
	mage.visual_role = "mage"
	add_child_autofree(mage)
	assert_not_null(mage.sprite_frames)
	if mage.sprite_frames == null:
		return
	assert_eq(mage.sprite_frames.get_frame_count("attack"), 6)
	assert_not_null(mage.sprite_frames.get_frame_texture("attack", 4))
