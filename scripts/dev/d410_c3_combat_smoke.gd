extends SceneTree

# Exercises the actual F6 launcher -> production Battle route, all three solo
# choices plus trio, normal/rear spawns. Never replaces BattleUnit with mocks.
func _initialize() -> void:
	call_deferred("_check")

func _check() -> void:
	for party_index in range(4):
		for left_flank in [false, true]:
			var launcher := load("res://scenes/dev/d410_c3_combat_playtest.tscn").instantiate() as Control
			root.add_child(launcher)
			current_scene = launcher
			launcher.get("party").select(party_index)
			launcher.get("flank").button_pressed = left_flank
			launcher.call("_launch")
			await scene_changed
			var battle := current_scene
			if battle == null or battle.scene_file_path != "res://scenes/battle/battle.tscn":
				_fail("launcher did not enter production Battle")
				return
			var hero_count := 0
			for actor: BattleUnit in battle.get("units"):
				if actor.team == 0:
					hero_count += 1
					if not actor.ANIMATION_LIBRARY.is_live_c3_hero_frames(actor.visual_role, actor.sprite_frames):
						_fail("production hero did not load C3")
						return
					if (actor.position.x > 640) != left_flank:
						_fail("wrong fixture deployment side")
						return
			if hero_count != (3 if party_index == 3 else 1):
				_fail("wrong actual party size")
				return
			battle.call("_on_fight_pressed")
			var waited := 0.0
			while not battle.get("combat_live") and waited < 2.0:
				await process_frame
				waited += root.get_process_delta_time()
			if not battle.get("combat_live"):
				_fail("real fight did not start")
				return
			await create_timer(0.1).timeout
			for actor: BattleUnit in battle.get("units"):
				if actor.team == 0 and (actor.target == null or actor.art_sprite.flip_h != left_flank):
					_fail("actual hero did not turn toward target")
					return
			root.remove_child(battle)
			battle.free()
	print("D410_C3_COMBAT_SMOKE_PASS: 8 real launcher/Battle fixtures")
	quit()

func _fail(message: String) -> void:
	push_error("D410_C3_COMBAT_SMOKE_FAIL: " + message)
	quit(1)
