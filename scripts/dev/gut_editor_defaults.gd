@tool
extends RefCounted

# Project-owned bootstrap for the *editor* GUT panel. GUT's CLI uses
# res://.gutconfig.json, but the editor loads a separate user:// config.
# Never replace custom configured folders; seed only a fresh/unset editor.
static func ensure_editor_test_dirs(options: Dictionary) -> Dictionary:
	var result: Dictionary = options.duplicate(true)
	var active: Array = result.get("dirs", [])
	var configured: Array = result.get("configured_dirs", [])
	if not active.is_empty() or not configured.is_empty():
		return result

	var project_config := "res://.gutconfig.json"
	if not FileAccess.file_exists(project_config):
		return result
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string(project_config))
	if not (raw is Dictionary):
		return result
	var candidates: Variant = raw.get("dirs", [])
	if not (candidates is Array):
		return result

	var valid: Array = []
	for candidate in candidates:
		var directory := str(candidate)
		if DirAccess.dir_exists_absolute(directory):
			valid.append(directory)
	if valid.is_empty():
		return result

	result["dirs"] = valid
	result["configured_dirs"] = valid.duplicate()
	result["include_subdirs"] = raw.get("include_subdirs", true)
	result["prefix"] = raw.get("prefix", "test_")
	result["suffix"] = raw.get("suffix", ".gd")
	return result
