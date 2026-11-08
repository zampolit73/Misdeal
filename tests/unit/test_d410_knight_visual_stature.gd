extends GutTest

# D410: use actual shipped C3 BattleUnit scenes and runtime SpriteFrames.
# The Knight must dominate the three-hero formation without changing physics,
# accepted D404 walk cadence, D405 attack staging, or the other hero art.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const KNIGHT: UnitData = preload("res://resources/units/knight.tres")
const RANGER: UnitData = preload("res://resources/units/ranger.tres")
const MAGE: UnitData = preload("res://resources/units/mage.tres")


func _create_hero(data: UnitData) -> BattleUnit:
	var arena := Node2D.new()
	add_child_autofree(arena)
	var hero := UNIT_SCENE.instantiate() as BattleUnit
	hero.configure(data, 0, Vector2(300.0, 380.0))
	arena.add_child(hero)
	hero.set_process(false)
	hero.set_process_input(false)
	return hero


func _visible_idle_height(hero: BattleUnit) -> float:
	var texture: Texture2D = hero.sprite_frames.get_frame_texture("idle", 0)
	var image: Image = texture.get_image()
	if image == null:
		return 0.0
	var first_y := image.get_height()
	var last_y := -1
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.22:
				first_y = mini(first_y, y)
				last_y = maxi(last_y, y)
	if last_y < first_y:
		return 0.0
	return float(last_y - first_y + 1) * hero.base_sprite_scale.y


func test_knight_is_visually_largest_live_c3_hero_with_original_five_states() -> void:
	var knight := _create_hero(KNIGHT)
	var ranger := _create_hero(RANGER)
	var mage := _create_hero(MAGE)
	for hero in [knight, ranger, mage]:
		assert_true(LIBRARY.is_live_c3_hero_frames(hero.visual_role, hero.sprite_frames))
		for state in ["idle", "walk", "attack", "hit", "death"]:
			assert_gt(hero.sprite_frames.get_frame_count(state), 0)
			assert_not_null(hero.sprite_frames.get_frame_texture(state, 0))
	assert_almost_eq(knight.base_sprite_scale.x, 1.28 * 1.38, 0.001)
	assert_almost_eq(ranger.base_sprite_scale.x, 1.28, 0.001)
	assert_almost_eq(mage.base_sprite_scale.x, 1.28 * 1.25, 0.001)
	assert_gt(knight.base_sprite_scale.x, mage.base_sprite_scale.x * 1.09)
	assert_gt(knight.base_sprite_scale.x, ranger.base_sprite_scale.x * 1.35)
	assert_gt(_visible_idle_height(knight), _visible_idle_height(mage),
		"Actual opaque C3 Knight IDLE should be taller on screen than Mage, not just use a bigger scalar")
	assert_gt(_visible_idle_height(knight), _visible_idle_height(ranger),
		"Actual opaque C3 Knight IDLE should be taller on screen than Ranger")


func test_taller_knight_stays_grounded_with_clear_hp_bar_and_unchanged_mechanics() -> void:
	var knight := _create_hero(KNIGHT)
	var ranger := _create_hero(RANGER)
	var mage := _create_hero(MAGE)
	for hero in [knight, ranger, mage]:
		var foot_y: float = hero.art_sprite.position.y + (hero.ANIM_SOLE_Y - hero.ANIM_CELL_HEIGHT * 0.5) * hero.base_sprite_scale.y
		assert_almost_eq(foot_y, hero.FLOOR_CONTACT_Y, 0.55,
			hero.visual_role + " boots must still land on the original combat floor ring")
		assert_eq(hero.scale, Vector2.ONE, "No whole-unit scaling or collision change")
		assert_eq(hero.art_sprite.scale, hero.base_sprite_scale)
		assert_eq(hero.position, Vector2(300.0, 380.0))
		assert_eq(hero.body_radius, 22.0)
	assert_eq(knight.health_bar.offset_top, -126.0)
	assert_eq(knight.health_bar.offset_bottom, -119.0)
	assert_eq(ranger.health_bar.offset_top, -90.0)
	assert_eq(mage.health_bar.offset_top, -90.0)
	assert_eq(knight.name_label.offset_top, ranger.name_label.offset_top)
	assert_eq(knight.max_hp, 150.0)
	assert_eq(knight.damage, 18.0)
	assert_eq(knight.attack_range, 56.0)
	assert_eq(knight.C3_WALK_PIXELS_PER_FRAME, 12.0)
	assert_eq(LIBRARY.C3_ATTACK_POSE_WEIGHTS["knight"].size(), 6)
