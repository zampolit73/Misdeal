extends GutTest

const DEFAULTS := preload("res://scripts/dev/gut_editor_defaults.gd")

func test_fresh_editor_configuration_finds_our_real_unit_tests() -> void:
	var original := {"dirs": [], "configured_dirs": [], "include_subdirs": false,
		"prefix": "", "suffix": ".gd", "should_exit": false}
	var settings: Dictionary = DEFAULTS.ensure_editor_test_dirs(original)
	assert_eq(settings["dirs"], ["res://tests/unit/"])
	assert_eq(settings["configured_dirs"], ["res://tests/unit/"])
	assert_true(settings["include_subdirs"])
	assert_eq(settings["prefix"], "test_")
	assert_eq(settings["suffix"], ".gd")
	assert_false(settings["should_exit"])
	assert_eq(original["dirs"].size(), 0, "Bootstrap should not mutate caller options")

func test_existing_editor_directories_are_never_overwritten() -> void:
	var custom := {"dirs": ["res://my_tests/"],
		"configured_dirs": ["res://my_tests/"], "include_subdirs": false}
	var settings: Dictionary = DEFAULTS.ensure_editor_test_dirs(custom)
	assert_eq(settings, custom)

func test_disabled_custom_directories_are_preserved() -> void:
	var custom := {"dirs": [], "configured_dirs": ["res://disabled_tests/"]}
	var settings: Dictionary = DEFAULTS.ensure_editor_test_dirs(custom)
	assert_eq(settings, custom)
