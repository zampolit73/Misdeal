extends GutTest

const LIB := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT := preload("res://scenes/battle/unit.tscn")

func test_every_enemy_walk_uses_distance_and_authored_hit_keeps_root_and_death_grounded() -> void:
	for role in LIB.ROLES.slice(3):
		var stage := Node2D.new()
		add_child_autofree(stage)
		var actor := UNIT.instantiate() as BattleUnit
		var data := load("res://resources/units/"+role+".tres") as UnitData
		actor.configure(data,1,Vector2.ZERO)
		stage.add_child(actor)
		actor.set_process(false)
		var top := INF
		for i in range(actor.sprite_frames.get_frame_count("idle")):
			var bounds := actor.sprite_frames.get_frame_texture("idle",i).get_image().get_used_rect()
			top=minf(top,actor.art_sprite.position.y+(bounds.position.y-48.0)*actor.base_sprite_scale.y)
		assert_lte(actor.health_bar.offset_bottom,top-5.9,role+": HP must clear the painted silhouette")
		actor.frame_state="walk"
		actor.frame_time=0
		actor.frame_one_shot_time=100
		actor._update_frame_animation(0.1)
		actor._update_frame_animation(0.1)
		assert_eq(actor.frame_time,0.0,role+": blocked feet must not cycle")
		actor.position.x += 12
		actor._update_frame_animation(0.1)
		assert_almost_eq(actor.frame_time,1.0/7.0,0.001,role)
		assert_eq(actor.damage,data.damage)
		assert_eq(actor.move_speed,data.move_speed)
		actor._play_hit_feedback(Vector2(-100,0),"knight",true)
		assert_eq(actor.scale,Vector2.ONE,role)
		actor.scale=Vector2(1.16,1.16)
		actor._die()
		assert_eq(actor.scale,Vector2.ONE,role)
		assert_eq(actor.art_sprite.position,actor._art_rest_position(),role)
		actor.death_tween.custom_step(0.45)
		assert_almost_eq(actor.modulate.a,1.0,0.001,role+": complete death poses precede fading")

func test_new_enemy_packs_are_complete_distinct_and_are_the_live_textures() -> void:
	for role in LIB.POLISHED_ENEMY_ROLES:
		var image := Image.new()
		var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(LIB.POLISHED_ENEMY_DIR+role+".webp.b64").strip_edges())
		assert_eq(image.load_webp_from_buffer(raw),OK)
		image.convert(Image.FORMAT_RGBA8)
		assert_true(LIB._all_authored_deck_frames_visible(image),role)
		assert_true(LIB._all_authored_deck_frames_padded(image),role)
		assert_true(LIB._all_authored_deck_frames_distinct(image),role)
		assert_true(LIB._unused_deck_cells_clear(image),role)
		var frames: SpriteFrames=LIB.get_frames(role)
		var tile := frames.get_frame_texture("idle",0) as AtlasTexture
		assert_eq(tile.atlas.get_image().get_data(),image.get_data(),role+": no silent legacy fallback")

func test_legacy_asset_fallback_retains_original_stature() -> void:
	var approved: SpriteFrames = LIB.get_frames("skeleton")
	var original := Image.new()
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(LIB.BASE_DIR+"skeleton.webp.b64").strip_edges())
	assert_eq(original.load_webp_from_buffer(raw),OK)
	var fallback: SpriteFrames = LIB._create_frames("skeleton",ImageTexture.create_from_image(original))
	var stage := Node2D.new()
	add_child_autofree(stage)
	var actor := UNIT.instantiate() as BattleUnit
	actor.configure(load("res://resources/units/skeleton.tres"),1,Vector2.ZERO)
	stage.add_child(actor)
	actor.set_process(false)
	assert_eq(actor.sprite_frames,fallback)
	assert_false(LIB.is_polished_enemy_frames("skeleton",fallback))
	assert_eq(actor.base_sprite_scale,Vector2.ONE*1.25)
	LIB._frames_cache["skeleton"]=approved
