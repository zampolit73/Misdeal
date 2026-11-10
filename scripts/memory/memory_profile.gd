extends RefCounted

const CATALOG_PATH := "res://resources/memory/fragments.json"
const SAVE_PATH := "user://memory_glass.json"
static var shared: RefCounted
var unlocked: Array[String] = []
var earned := 0
var seen: Dictionary = {}
var path := ""
var error_message := ""
var pending := 0
var run_uid := ""
var run_ledger: Dictionary = {}

static func instance() -> RefCounted:
	if shared == null:
		shared = load("res://scripts/memory/memory_profile.gd").new()
		# Development scripts and GUT must never touch a player's profile.
		var args := " ".join(OS.get_cmdline_args())
		if not args.contains("--script") and not args.contains("-s ") and not Engine.is_editor_hint():
			shared.open_profile(SAVE_PATH)
	return shared

static func catalog() -> Array:
	return JSON.parse_string(FileAccess.get_file_as_string(CATALOG_PATH)) as Array

func begin_run() -> void:
	run_uid = Crypto.new().generate_random_bytes(16).hex_encode()
	earned = 0
	seen.clear()

func open_profile(save_path: String) -> void:
	path = save_path
	unlocked.clear()
	if not FileAccess.file_exists(path):
		return
	var parser := JSON.new()
	var parsed := parser.parse(FileAccess.get_file_as_string(path))
	var data: Variant = parser.data if parsed == OK else null
	if not data is Dictionary or not data.get("unlocked", null) is Array or int(data.get("schema_version", 1)) > 1:
		error_message = "Профиль памяти повреждён или создан более новой версией. Исходный файл сохранён."
		path = ""
		return
	if data.get("run_ledger") is Dictionary:
		run_ledger = data.run_ledger
	for id in data.unlocked:
		if valid_id(str(id)) and not unlocked.has(str(id)):
			unlocked.append(str(id))

static func valid_id(id: String) -> bool:
	for item in catalog():
		if item.id == id:
			return true
	return false

func save_profile() -> bool:
	if path.is_empty():
		return error_message.is_empty()
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		error_message = "Не удалось сохранить память."
		return false
	file.store_string(JSON.stringify({"schema_version":1,"unlocked":unlocked,"run_ledger":run_ledger}))
	file.flush()
	file.close()
	# Keep the previous valid generation until the replacement succeeds.
	if FileAccess.file_exists(path):
		if DirAccess.copy_absolute(path,path + ".bak") != OK:
			return false
	var result := DirAccess.rename_absolute(temp,path)
	if result != OK:
		error_message = "Не удалось заменить профиль памяти."
	return result == OK

func resolved(role: String, stage: int, facts: Dictionary, boss: bool, key: String) -> Array[String]:
	var added: Array[String] = []
	if seen.has(key) or role not in ["knight","ranger","mage"]:
		return added
	seen[key] = true
	var entries := catalog()
	# Reserve two slots for the final personal memory and the ash dawn.
	var limit := 8 if boss else 6
	var candidates: Array = []
	for item in entries:
		if unlocked.has(item.id) or (item.group != "chronicle" and item.group != role):
			continue
		if item.spoiler_gate == "boss_victory" and not boss:
			continue
		if stage >= int(item.unlock_rules.stage) or facts.has(item.unlock_rules.clue):
			candidates.append(item)
	candidates.sort_custom(func(a,b):
		var pa: int = (100 if a.spoiler_gate == "boss_victory" else 0) + (50 if a.group == role else 0) + (25 if facts.has(a.unlock_rules.clue) else 0)
		var pb: int = (100 if b.spoiler_gate == "boss_victory" else 0) + (50 if b.group == role else 0) + (25 if facts.has(b.unlock_rules.clue) else 0)
		return pa > pb if pa != pb else a.id < b.id)
	for item in candidates:
		if earned >= limit or added.size() >= (2 if boss else 1):
			break
		unlocked.append(item.id)
		added.append(item.id)
		earned += 1
	if not added.is_empty():
		run_ledger[run_uid] = {"earned":earned,"seen":seen.duplicate()}
		pending += added.size()
		save_profile()
	return added

func restore_run(uid: String) -> void:
	run_uid = uid
	var record: Dictionary = run_ledger.get(uid,{})
	earned = int(record.get("earned",0))
	seen = record.get("seen",{}).duplicate()
