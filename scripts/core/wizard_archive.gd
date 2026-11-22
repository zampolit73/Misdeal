extends RefCounted
## Independent collection. The run and stained glass retain their own slots.

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


func _read(filename: String) -> Dictionary:
	var file := FileAccess.open(filename, FileAccess.READ)
	if file == null or file.get_length() > 4194304:
		return {}
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return {}
	var parsed: Variant = parser.data
	if not parsed is Dictionary or parsed.get("version") != 1:
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
	return parsed


func _commit() -> void:
	if not _dirty or path.is_empty():
		return
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		error_message = "Архив не сохранился. Изменения пока в памяти."
		return
	file.store_string(JSON.stringify({"version":1, "relics":relics, "enemies":enemies, "history":history}))
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


func record_enemies(ids: Array) -> void:
	if path.is_empty(): return
	for id in ids:
		if id in ENEMY_IDS and not enemies.has(id):
			enemies[id] = true
			_dirty = true
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
	_commit()


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
