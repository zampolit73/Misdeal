extends RefCounted
## Independent collection. The run and stained glass retain their own slots.

signal achievements_unlocked(ids: Array[String])

const ACHIEVEMENTS := preload("res://scripts/core/achievement_catalog.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const SAVE_PATH := "user://wizard_archive.json"
const ENEMY_IDS := ["ash_scrivener", "bone_archer", "bone_bailiff", "bone_marionette",
	"bone_raider", "bone_shepherd", "bone_thrall", "bone_warden", "crypt_guard", "crypt_sentinel",
	"drowned_ferryman", "drowned_hand", "extinguished_guide", "funeral_priest", "grave_bellkeeper",
	"lantern_archer", "lantern_bearer", "mute_magistrate", "oil_acolyte", "ossuary_lamb", "pallbearer",
	"plague_alchemist", "road_sentinel", "skeleton", "threadbare_puppeteer", "unstable_homunculus"]
const ROLES := ["knight", "ranger", "mage"]

static var shared: RefCounted
var path := ""
var error_message := ""
var relics: Dictionary = {}
var enemies: Dictionary = {}
var history: Dictionary = {}
var achievements: Dictionary = {}
var _pending_achievements: Array[String] = []
var _dirty := false
var _recovered := false


static func instance() -> RefCounted:
	if shared == null:
		shared = load("res://scripts/core/wizard_archive.gd").new()
		var args := " ".join(OS.get_cmdline_args()).replace("\\", "/")
		if not args.contains("--script") and not args.contains("-s ") and not args.contains("/dev/") and not args.contains("/addons/gut/") and not Engine.is_editor_hint():
			shared.open_profile(SAVE_PATH)
	return shared


func open_profile(filename: String) -> void:
	path = filename
	_recovered = false
	_dirty = false
	error_message = ""
	relics.clear()
	enemies.clear()
	history.clear()
	achievements.clear()
	_pending_achievements.clear()
	if not FileAccess.file_exists(filename) and not FileAccess.file_exists(filename + ".bak"):
		return
	var data := _read(filename)
	if data.is_empty():
		data = _read(filename + ".bak")
		if data.is_empty():
			path = ""
			error_message = "Архив недоступен. Исходный файл сохранён."
			return
		_recovered = true
		error_message = "Архив открыт из резервной копии."
	relics = data.relics
	enemies = data.enemies
	history = data.history
	achievements = data.get("achievements", {})
	# Old profiles grant only independently proven milestones, silently.
	# The migration is written on the next real checkpoint.
	if int(data.version) == 1:
		_dirty = true
		_evaluate_achievements({}, "", "", false)


func _read(filename: String) -> Dictionary:
	var file := FileAccess.open(filename, FileAccess.READ)
	if file == null or file.get_length() > 4194304:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {}
	var parsed: Variant = parser.data
	if not parsed is Dictionary or (parsed.get("version") != 1 and parsed.get("version") != 2):
		return {}
	for key in ["relics", "enemies", "history"]:
		if not parsed.get(key) is Dictionary:
			return {}
	for group in [parsed.relics, parsed.enemies]:
		for id in group:
			if not id is String or group[id] != true:
				return {}
	for id in parsed.history:
		var entry: Variant = parsed.history[id]
		if not entry is Dictionary or not entry.get("won") is bool or entry.get("role") not in ROLES:
			return {}
		if not entry.get("party") is Array or not entry.get("relics") is Array or not entry.get("date") is String:
			return {}
		for role in entry.party:
			if role not in ROLES: return {}
		for relic in entry.relics:
			if not relic is String: return {}
		if typeof(entry.get("card")) not in [TYPE_INT, TYPE_FLOAT] or typeof(entry.get("oath")) not in [TYPE_INT, TYPE_FLOAT]: return {}
		if int(entry.card) < 0 or int(entry.card) > 13 or int(entry.oath) < 0 or int(entry.oath) >= CHARTER.OATHS.size(): return {}
		if not entry.get("style") is String or not CHARTER.is_style_for_role(entry.style, entry.role) or not entry.get("last_deal") is bool: return {}
	if int(parsed.version) == 2:
		if not parsed.get("achievements") is Dictionary: return {}
		for id in parsed.achievements:
			var award: Variant = parsed.achievements[id]
			if not id is String or id.is_empty() or not award is Dictionary: return {}
			if not award.get("run_uid") is String or not award.get("earned_at") is String: return {}
	return parsed


func _commit() -> void:
	if not _dirty or path.is_empty():
		return
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		error_message = "Архив не сохранился. Изменения пока в памяти."
		return
	file.store_string(JSON.stringify({"version":2, "relics":relics, "enemies":enemies, "history":history, "achievements":achievements}))
	file.flush()
	var status := file.get_error()
	file.close()
	if status != OK or _read(temp).is_empty():
		error_message = "Не удалось проверить запись архива."
		return
	if FileAccess.file_exists(path):
		var backup := path + ".corrupt_" + Crypto.new().generate_random_bytes(8).hex_encode() if _recovered else path + ".bak"
		if DirAccess.copy_absolute(path, backup) != OK:
			error_message = "Не удалось сохранить прежнюю версию архива."
			return
	if DirAccess.rename_absolute(temp, path) != OK:
		error_message = "Не удалось заменить файл архива."
		return
	_dirty = false
	_recovered = false
	error_message = ""
	if not _pending_achievements.is_empty():
		var granted: Array[String] = _pending_achievements.duplicate()
		_pending_achievements.clear()
		achievements_unlocked.emit(granted)


func record_enemies(ids: Array, run_uid: String = "") -> void:
	if path.is_empty(): return
	for id in ids:
		if id in ENEMY_IDS and not enemies.has(id):
			enemies[id] = true
			_dirty = true
	_evaluate_achievements({}, run_uid, Time.get_datetime_string_from_system())
	_commit()


func observe_checkpoint(state: Dictionary, run_uid: String, saved_at: String) -> void:
	if path.is_empty(): return
	for id in state.artifact_ids:
		if not relics.has(id):
			relics[id] = true
			_dirty = true
	var won: bool = state.boss_defeated and state.last_battle_won
	if not run_uid.is_empty() and not history.has(run_uid) and (won or state.run_failed):
		var card: int = 13 if won else mini(13, state.cards_resolved + 1)
		history[run_uid] = {"won":won, "role":state.protagonist_role, "party":state.party_roles.duplicate(),
			"card":card, "relics":state.artifact_ids.duplicate(), "style":state.starting_style, "oath":state.oath_rank,
			"last_deal":state.last_deal_used, "date":saved_at}
		_dirty = true
	_evaluate_achievements(state, run_uid, saved_at)
	_commit()


func _evaluate_achievements(state: Dictionary, run_uid: String, earned_at: String, notify: bool = true) -> void:
	var relic_count := 0
	for id in RunState.ARTIFACT_PATHS:
		if relics.has(id): relic_count += 1
	var enemy_count := 0
	for id in ENEMY_IDS:
		if enemies.has(id): enemy_count += 1
	for id in ACHIEVEMENTS.eligible(state, relic_count, enemy_count, history):
		if achievements.has(id): continue
		achievements[id] = {"run_uid": run_uid, "earned_at": earned_at}
		_dirty = true
		if notify: _pending_achievements.append(id)


func has_achievement(id: String) -> bool:
	return achievements.has(id) and id not in _pending_achievements


func achievements_for_run(run_uid: String) -> Array[String]:
	var result: Array[String] = []
	if run_uid.is_empty(): return result
	for entry in ACHIEVEMENTS.ENTRIES:
		var id: String = entry[0]
		if has_achievement(id) and achievements[id].run_uid == run_uid:
			result.append(id)
	return result


func style_unlocked(role: String) -> bool:
	for entry in history.values():
		if entry.won and entry.role == role:
			return true
	return false


func highest_oath() -> int:
	var highest := 0
	for entry in history.values():
		if entry.won:
			highest = maxi(highest, int(entry.oath) + 1)
	return mini(highest, CHARTER.OATHS.size() - 1)
