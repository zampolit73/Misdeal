extends GutTest

func test_original_shepherd_smoke_loads_and_validates_current_deck_and_default_arrays() -> void:
	# Dynamic loading reports parse failures as test failures, not skipped tests.
	var packed := load("res://scenes/dev/bone_shepherd_smoke.tscn") as PackedScene
	assert_not_null(packed)
	if packed == null:
		return
	var scene := packed.instantiate()
	assert_true(scene.has_method("_validate_resources"), "The actual attached script must compile")
	if scene.has_method("_validate_resources"):
		scene.call("_validate_resources")
		assert_eq(scene.get("errors"), [], "Unchanged authored roster, default empty reinforcements and current 39-card deck")
		var encounter := scene.get("encounter") as EncounterData
		assert_not_null(encounter)
		assert_eq(encounter.reinforcement_unit_paths, PackedStringArray())
	scene.free()
