extends SceneTree
# Actual production controls, controlled RunState, native framebuffer evidence.
const ROOT := "res://scenes/"
const COMPLETED: Array[String] = ["moon_seal", "whispering_well", "bone_patrol", "bone_tax", "ash_rest", "grave_crossfire", "gravedigger_shop", "crypt_guard", "lost_purse", "echo_crypt", "black_altar", "curse_forge"]
const UPGRADES: Array[String] = ["knight_iron_oath", "knight_executioner", "knight_cleaver", "ranger_arrowstorm", "ranger_longshot", "ranger_beast_trail", "mage_glass_heart", "mage_overload", "mage_wildfire"]
var destination := ""
var revision := ""
var manifest: Array[Dictionary] = []
var scene: Control
var state: Node

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 or not args[0].is_absolute_path():
		quit(1)
		return
	destination = args[0]
	revision = args[1]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280,720)
	state = root.get_node("RunState")
	for kind in ["main", "intro_open", "intro_end", "class_idle", "class_knight", "class_ranger", "class_mage", "table_two", "table_hover", "table_one", "table_held", "dossier_knight", "dossier_ranger", "dossier_mage", "dossier_lost", "fate_0", "fate_4", "fate_8", "fate_12", "fate_final", "reward_major_upgrade", "reward_bonus_upgrade", "reward_normal_loot", "reward_death_wager", "reward_elite_artifact", "reward_details", "upgrade_knight", "upgrade_ranger", "upgrade_mage", "event_moon_seal", "event_resolved", "event_blood_ledger", "event_chained_prisoner", "shop_poor", "shop_rich", "shop_bought", "well_poor", "well_rich", "end_victory", "end_defeat", "end_full", "battle_solo", "battle_duo", "battle_trio", "battle_orders4", "battle_orders5", "battle_wave"]:
		await _fixture(kind)
	if manifest.size() != 51:
		push_error("Visual matrix incomplete: " + str(manifest.size()))
		quit(1)
		return
	await _sheets()
	var output := FileAccess.open(destination.path_join("manifest.json"), FileAccess.WRITE)
	output.store_string(JSON.stringify({"revision":revision, "viewport":[1280,720], "frames":manifest}, "  "))
	output.close()
	print("VISUAL_MATRIX_PASS: ", manifest.size(), " real frames at ", revision)
	quit()

func _fixture(kind: String) -> void:
	seed(418)
	state.call("reset_run")
	state.call("choose_protagonist", "knight")
	if kind.begins_with("reward_") or kind.begins_with("upgrade_") or kind.begins_with("dossier_") or kind == "end_full" or kind == "battle_trio" or kind.begins_with("battle_orders") or kind == "battle_wave":
		state.call("recruit_companion", "ranger", "native visual QA")
		if kind != "dossier_lost": state.call("recruit_companion", "mage", "native visual QA")
	if kind == "battle_duo":
		state.call("recruit_companion", "ranger", "native visual QA")
	var path := "table/table.tscn"
	if kind == "main": path = "main/main.tscn"
	elif kind.begins_with("intro_"): path = "intro/intro.tscn"
	elif kind.begins_with("class_"): path = "class_select/class_select.tscn"
	elif kind.begins_with("dossier_"):
		path = "table/squad_status.tscn"
		state.call("add_hero_upgrade", "knight_executioner")
		state.call("add_artifact", "dead_mans_shield")
		if kind == "dossier_lost": state.call("lose_companion", "mage", "native visual QA")
	elif kind.begins_with("fate_"):
		path = "table/fate_spread_overlay.tscn"
		var count := 12 if kind == "fate_final" else int(kind.trim_prefix("fate_"))
		var history: Array[String] = COMPLETED.slice(0,count)
		var rejects: Array[String] = []
		if count > 0: rejects.assign(["graveyard_ambush", "gallows_volley", "last_camp", "rattling_bridge"])
		state.set("cards_resolved", count)
		state.set("resolved_card_ids", history)
		state.set("rejected_card_ids", rejects)
		if count == 4:
			state.set("held_card_id", "grave_bell")
			state.set("held_card_return_at", 6)
		if kind == "fate_final": state.set("boss_defeated", true)
	elif kind.begins_with("reward_") or kind.begins_with("upgrade_"):
		path = "reward/reward.tscn"
		state.set("active_card_id", "death_wager" if kind == "reward_death_wager" else ("crypt_guard" if kind == "reward_elite_artifact" else "bone_patrol"))
		if kind not in ["reward_major_upgrade", "reward_details"] and not kind.begins_with("upgrade_"):
			var claimed: Array[int] = [0,1,2]
			state.set("claimed_upgrade_tiers", claimed)
	elif kind.begins_with("event_") or kind.begins_with("shop_"):
		path = "event/act_choice.tscn"
		state.set("active_card_id", "gravedigger_shop" if kind.begins_with("shop_") else ("moon_seal" if kind == "event_resolved" else kind.trim_prefix("event_")))
		state.set("gold", 0 if kind == "shop_poor" else 100)
	elif kind.begins_with("well_"):
		path = "event/whispering_well.tscn"
		state.set("active_card_id", "whispering_well")
		state.set("gold", 0 if kind == "well_poor" else 100)
	elif kind.begins_with("end_"):
		path = "run_end/run_end.tscn"
		state.set("run_failed", kind == "end_defeat")
		state.set("cards_resolved", 12)
		state.set("run_end_reason", "Отряд пал в бою.")
		if kind == "end_full":
			for upgrade in UPGRADES: state.call("add_hero_upgrade", upgrade)
			for artifact in ["dead_mans_shield", "cracked_focus", "broken_crown", "blind_quiver"]: state.call("add_artifact", artifact)
	elif kind.begins_with("battle_"):
		path = "battle/battle.tscn"
		var encounter := "firing_square" if kind == "battle_wave" else ("grave_bell" if kind == "battle_duo" else "bone_patrol")
		state.set("active_card_id", encounter)
		state.call("select_encounter", "res://resources/encounters/%s.tres" % encounter)
		state.set("sacrifice_order_ready", kind == "battle_orders4" or kind == "battle_orders5")
		state.set("defiance_order_ready", kind == "battle_orders5")
	if kind.begins_with("table_"):
		var offers: Array[String] = ["lost_purse", "whispering_well"]
		state.set("current_offer_ids", offers)
		if kind == "table_one": state.call("choose_card", "lost_purse")
	scene = (load(ROOT + path) as PackedScene).instantiate() as Control
	if scene.get_script() == null:
		push_error("Matrix production script failed to load: " + path)
		quit(1)
		return
	root.add_child(scene)
	current_scene = scene
	await create_timer(0.8).timeout
	if kind == "intro_end":
		scene.call("_show_frame", 4)
	elif kind.begins_with("class_") and kind != "class_idle":
		scene.call("_select_role", kind.trim_prefix("class_"))
	elif kind.begins_with("dossier_"):
		scene.call("_select_role", "mage" if kind == "dossier_lost" else kind.trim_prefix("dossier_"), false)
	elif kind == "table_hover": scene.get_node("Cards/BonePatrolCard").mouse_entered.emit()
	elif kind == "table_held": scene.get_node("Cards/HoldAButton").pressed.emit()
	elif kind == "event_resolved": scene.get_node("Panel/Choices/ChoiceA").pressed.emit()
	elif kind == "reward_details":
		var input := InputEventMouseButton.new()
		input.pressed = true
		input.button_index = MOUSE_BUTTON_RIGHT
		scene.get_node("Rewards/BloodCoin").grab_focus()
		scene.get_node("Rewards/BloodCoin").gui_input.emit(input)
	elif kind == "shop_bought": scene.get_node("Panel/Choices/ChoiceA").pressed.emit()
	elif kind == "reward_bonus_upgrade": scene.call("_setup_bonus_upgrade_reward")
	elif kind.begins_with("upgrade_"):
		var role := kind.trim_prefix("upgrade_")
		var ids: Array[String] = []
		for id in UPGRADES:
			if id.begins_with(role): ids.append(id)
		scene.call("_setup_upgrade_buttons", ids)
	await create_timer(0.35).timeout
	await _save(kind, path)
	if kind == "end_full":
		scene.get_node("SummaryScroll").scroll_vertical = 100000
		await process_frame
		await _save("end_full_scrolled", path)
	if kind == "battle_trio":
		scene.get_node("FightButton").pressed.emit()
		await create_timer(1.0).timeout
		await _save("battle_live", path)
		var units: Array = scene.get("units")
		for actor in units:
			if actor.team == 0 and actor.visual_role == "mage" and actor.alive:
				actor.take_damage(1.0)
				await create_timer(0.03).timeout
				await _save("battle_hit", path)
				actor.take_damage(actor.max_hp + 10000.0)
				await create_timer(0.3).timeout
				await _save("battle_death", path)
				break
	scene.queue_free()
	await process_frame
	await process_frame

func _save(label: String, path: String) -> void:
	await RenderingServer.frame_post_draw
	var screenshot := root.get_texture().get_image()
	if screenshot.save_png(destination.path_join(label + ".png")) != OK:
		push_error("Matrix frame save failed: " + label)
		quit(1)
	var text: Array[Dictionary] = []
	_collect(scene,text)
	manifest.append({"name":label,"scene":path,"party":state.get("party_roles").duplicate(),"active_card":state.get("active_card_id"),"gold":state.get("gold"),"controls":text})
	print("MATRIX_FRAME: ",label)

func _collect(node: Node, labels: Array[Dictionary]) -> void:
	if node is Control and node.is_visible_in_tree() and (node is Label or node is Button):
		labels.append({"path":str(scene.get_path_to(node)),"text":node.text,"rect":[node.global_position.x,node.global_position.y,node.size.x,node.size.y],"font":node.get_theme_font_size("font_size"),"disabled":node.disabled if node is Button else false})
	for child in node.get_children(): _collect(child,labels)

func _sheets() -> void:
	for first in range(0,manifest.size(),12):
		var sheet := Image.create(1280,648,false,Image.FORMAT_RGB8)
		sheet.fill(Color("151015"))
		for i in range(first,mini(first+12,manifest.size())):
			var picture := Image.load_from_file(destination.path_join(manifest[i].name + ".png"))
			picture.resize(320,180,Image.INTERPOLATE_LANCZOS)
			picture.convert(Image.FORMAT_RGB8)
			var local_index := i-first
			sheet.blit_rect(picture,Rect2i(0,0,320,180),Vector2i((local_index%4)*320,(local_index/4)*216))
		sheet.save_png(destination.path_join("sheet_%02d.png" % (first/12)))
