extends GutTest
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
func test_laboratory_has_its_own_authored_plate_and_original_roster() -> void:
	var encounter := load("res://resources/encounters/defiled_laboratory.tres") as EncounterData
	assert_eq(encounter.arena_id,"defiled_laboratory")
	assert_eq(encounter.enemy_unit_paths.size(),3)
	assert_true(encounter.enemy_unit_paths[0].ends_with("plague_alchemist.tres"))
	var backdrop := BACKDROP.new() as TextureRect
	add_child_autofree(backdrop)
	backdrop.call("set_arena_id",encounter.arena_id)
	assert_eq(backdrop.get("arena_id"),"defiled_laboratory")
	assert_not_null(backdrop.texture)
	assert_eq(backdrop.texture.get_size(),Vector2(1280,720))
	var laboratory := backdrop.texture
	backdrop.call("set_arena_id","crypt")
	assert_ne(backdrop.texture,laboratory)
