extends GutTest

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES := ["knight", "ranger", "mage"]

func _actor(parent: Node2D, role: String, side: int, at: Vector2) -> BattleUnit:
	var actor := UNIT_SCENE.instantiate() as BattleUnit
	actor.visual_role = role
	actor.team = side
	actor.position = at
	parent.add_child(actor)
	actor.set_process(false)
	actor.set_process_input(false)
	return actor

func test_c3_acquires_left_target_before_first_movement_frame() -> void:
	for role in ROLES:
		var arena := Node2D.new()
		add_child(arena)
		var hero := _actor(arena, role, 0, Vector2(600, 350))
		var foe := _actor(arena, "skeleton", 1, Vector2(250, 350))
		hero.combat_started = true
		hero.attack_range = 30.0
		hero.minimum_range = 0.0
		assert_false(hero.art_sprite.flip_h)
		var start := hero.position
		hero._process(1.0 / 60.0)
		assert_eq(hero.target, foe)
		assert_lt(hero.position.x, start.x, role + " really moves toward the enemy on the left")
		assert_true(hero.art_sprite.flip_h, role + " must face the newly acquired target THIS frame")
		assert_eq(hero.rim_sprite.flip_h, hero.art_sprite.flip_h)
		arena.free()

func test_c3_reacquisition_faces_opponent_at_actual_damage_signal_in_both_directions() -> void:
	for role in ROLES:
		for face_left in [true, false]:
			var arena := Node2D.new()
			add_child(arena)
			var hero := _actor(arena, role, 0, Vector2(600, 350))
			var foe := _actor(arena, "skeleton", 1, Vector2(540 if face_left else 660, 350))
			var previous := _actor(arena, "skeleton", 1, Vector2(700 if face_left else 500, 350))
			previous.alive = false
			hero.target = previous
			hero.combat_started = true
			hero.minimum_range = 0.0
			hero.attack_range = 100.0
			hero.attack_cooldown = 0.0
			hero._set_facing_left(not face_left)
			var observed: Array[bool] = []
			hero.diagnostic_attack.connect(func(attacker: BattleUnit, _victim: BattleUnit) -> void:
				observed.append(attacker.art_sprite.flip_h))
			var before := foe.hp
			hero._process(1.0 / 60.0)
			assert_eq(observed.size(), 1, "No attack delay was added")
			if not observed.is_empty():
				assert_eq(observed[0], face_left, role + " must not attack with its back to the new target")
			assert_almost_eq(before - foe.hp, hero.damage, 0.001)
			assert_eq(hero.attack_cooldown, hero.attack_interval)
			assert_eq(hero.frame_state, "attack")
			assert_eq(hero.rim_sprite.texture, hero.art_sprite.texture, "No previous walk/idle silhouette behind attack")
			assert_eq(hero.rim_sprite.flip_h, hero.art_sprite.flip_h)
			assert_lt(hero.rim_sprite.position.distance_to(hero.art_sprite.position + Vector2(0, 1)), 0.001)
			arena.free()

func test_c3_external_hit_and_death_switch_rim_texture_in_same_frame() -> void:
	for role in ROLES:
		var arena := Node2D.new()
		add_child(arena)
		var hero := _actor(arena, role, 0, Vector2(600, 350))
		hero.take_damage(1.0, "skeleton", Vector2(660, 350))
		assert_eq(hero.frame_state, "hit")
		assert_eq(hero.rim_sprite.texture, hero.art_sprite.texture)
		hero.take_damage(hero.max_hp + 100.0)
		assert_false(hero.alive)
		assert_eq(hero.frame_state, "death")
		assert_eq(hero.rim_sprite.texture, hero.art_sprite.texture)
		assert_eq(hero.art_sprite.scale, hero.base_sprite_scale)
		assert_eq(hero.art_sprite.position, hero._art_rest_position())
		arena.free()

func test_c3_dead_or_vertically_aligned_target_keeps_stable_facing_and_legacy_is_unchanged() -> void:
	var arena := Node2D.new()
	add_child_autofree(arena)
	var hero := _actor(arena, "knight", 0, Vector2(600, 350))
	var foe := _actor(arena, "skeleton", 1, Vector2(605, 300))
	hero.combat_started = true
	hero.target = foe
	hero._set_facing_left(true)
	hero._update_unit_facing()
	assert_true(hero.art_sprite.flip_h, "Keep the existing 12px facing dead zone")
	foe.alive = false
	hero._update_unit_facing()
	assert_true(hero.art_sprite.flip_h)
	var legacy := _actor(arena, "skeleton", 0, Vector2(700, 350))
	var enemy := _actor(arena, "skeleton", 1, Vector2(300, 350))
	legacy.combat_started = true
	legacy._process(1.0 / 60.0)
	assert_eq(legacy.target, enemy)
	assert_false(legacy.art_sprite.flip_h, "D410 leaves old enemy/v2 update sequencing intact")
