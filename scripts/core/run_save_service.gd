extends RefCounted
const FIELDS := preload("res://scripts/core/run_save_fields.gd").FIELDS
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const TABLE := "res://scenes/table/table.tscn"
const REWARD := "res://scenes/reward/reward.tscn"
static var shared: RefCounted
var path := ""
var error_message := ""
var resume_phase := ""
var loading := false

static func instance() -> RefCounted:
	if shared == null:
		shared = load("res://scripts/core/run_save_service.gd").new()
		var args := " ".join(OS.get_cmdline_args())
		if not args.contains("--script") and not args.contains("-s ") and not Engine.is_editor_hint():
			shared.path = "user://current_run.json"
	return shared

func snapshot(state: Node, scene: String = TABLE, phase: String = "") -> Dictionary:
	var values := {}
	for key in FIELDS:
		values[key] = state.get(key)
	return {"version":1,"state":values.duplicate(true),"scene":scene,"phase":phase,
		"finished":state.is_run_complete(),"saved_at":Time.get_datetime_string_from_system(),
		"memory_run":MEMORY.instance().run_uid}

func validate(data: Variant, state: Node) -> bool:
	if not data is Dictionary or data.get("version") != 1 or data.get("scene") not in [TABLE,REWARD] or not data.get("state") is Dictionary:
		return false
	if not data.get("finished") is bool or not data.get("saved_at") is String or not data.get("memory_run") is String or data.get("phase") not in ["","major_upgrade","bonus_upgrade","normal_loot","death_wager","elite_artifact"]:
		return false
	var values: Dictionary = data.state
	if values.size() != FIELDS.size():
		return false
	for key in FIELDS:
		if not values.has(key) or typeof(values[key]) != typeof(state.get(key)) or not _plain(values[key]):
			return false
		if values[key] is Array:
			if values[key].get_typed_builtin() != state.get(key).get_typed_builtin():
				return false
	if values.protagonist_role not in state.HERO_ROLES or not values.party_roles.has(values.protagonist_role) or values.party_roles.size() > 3 or values.cards_resolved < 0 or values.cards_resolved > 12 or values.gold < 0:
		return false
	for key in ["party_roles","rescue_scar_roles"]:
		for id in values[key]:
			if id not in state.HERO_ROLES: return false
	for key in ["remaining_card_ids","current_offer_ids","rejected_card_ids","resolved_card_ids"]:
		for id in values[key]:
			if not state.CARD_PATHS.has(id): return false
	for key in ["active_card_id","active_rejected_card_id","held_card_id","wizard_mark_card_id","wizard_meddling_original_id","wizard_meddling_replacement_id"]:
		if not values[key].is_empty() and not state.CARD_PATHS.has(values[key]): return false
	for id in values.artifact_ids:
		if state.get_artifact(id) == null: return false
	for key in ["hero_upgrade_ids","extra_hero_upgrade_ids","current_major_upgrade_offer_ids","current_bonus_upgrade_offer_ids"]:
		for id in values[key]:
			if state.get_hero_upgrade(id) == null: return false
	for key in ["pending_wager_artifact_id","last_deal_offer_artifact_id"]:
		if not values[key].is_empty() and state.get_artifact(values[key]) == null: return false
	if not values.selected_encounter_path.begins_with("res://resources/encounters/") or not ResourceLoader.exists(values.selected_encounter_path) or not load(values.selected_encounter_path) is EncounterData: return false
	for entry in values.fate_choice_history:
		if not entry is Dictionary: return false
		for key in ["chosen","rejected"]:
			if not entry.get(key) is String or (not entry[key].is_empty() and not state.CARD_PATHS.has(entry[key])): return false
	for key in values.combat_formation_by_card:
		if not state.CARD_PATHS.has(key) or not values.combat_formation_by_card[key] is int: return false
	for key in values.hero_fates:
		if key not in state.HERO_ROLES or values.hero_fates[key] not in [state.FATE_UNKNOWN,state.FATE_PROTAGONIST,state.FATE_JOINED,state.FATE_LOST]: return false
	if data.scene == REWARD and (values.active_card_id.is_empty() or not values.last_battle_won): return false
	if data.finished != (values.boss_defeated or values.run_failed): return false
	if data.scene == TABLE and not data.finished and not values.active_card_id.is_empty(): return false
	return true

func _plain(value: Variant) -> bool:
	if value is Array:
		for item in value:
			if not _plain(item): return false
		return true
	if value is Dictionary:
		for key in value:
			if not _plain(key) or not _plain(value[key]): return false
		return true
	return typeof(value) in [TYPE_NIL,TYPE_BOOL,TYPE_INT,TYPE_FLOAT,TYPE_STRING]

func read_slot(state: Node, filename: String = "") -> Dictionary:
	error_message = ""
	var target := path if filename.is_empty() else filename
	if target.is_empty() or not FileAccess.file_exists(target): return {}
	if FileAccess.get_file_as_bytes(target).size() > 2097152:
		error_message = "Сохранение слишком велико. Файл сохранён."
		return {}
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(target)) != OK or not parser.data is Dictionary:
		error_message = "Сохранение повреждено. Файл сохранён."
		return {}
	var envelope: Dictionary = parser.data
	if not envelope.get("payload") is String or not envelope.get("sha256") is String:
		error_message = "Неверный формат сохранения."
		return {}
	var payload: String = envelope.payload
	if payload.sha256_text() != envelope.sha256:
		error_message = "Контрольная сумма сохранения не совпадает."
		return {}
	var data: Variant = bytes_to_var(Marshalls.base64_to_raw(payload))
	if not validate(data,state):
		error_message = "Сохранение несовместимо или содержит неверные данные."
		return {}
	return data

func write_slot(state: Node, scene: String = TABLE, phase: String = "") -> bool:
	if path.is_empty(): return true # explicit QA isolation
	var data := snapshot(state,scene,phase)
	if not validate(data,state):
		error_message = "Сейчас нельзя создать безопасное сохранение."
		return false
	var payload := Marshalls.raw_to_base64(var_to_bytes(data))
	var temp := path + ".tmp"
	var file := FileAccess.open(temp,FileAccess.WRITE)
	if file == null:
		error_message = "Не удалось записать сохранение."
		return false
	file.store_string(JSON.stringify({"payload":payload,"sha256":payload.sha256_text()}))
	file.flush()
	var status := file.get_error()
	file.close()
	if status != OK or read_slot(state,temp).is_empty(): return false
	if FileAccess.file_exists(path):
		# Never replace a corrupt original implicitly.
		if read_slot(state).is_empty(): return false
		if DirAccess.copy_absolute(path,path+".bak") != OK:
			error_message = "Не удалось создать резервную копию."
			return false
	if DirAccess.rename_absolute(temp,path) != OK:
		error_message = "Не удалось заменить сохранение."
		return false
	error_message = ""
	return true

func apply_slot(state: Node, data: Dictionary) -> bool:
	if not validate(data,state) or data.finished: return false
	for key in FIELDS:
		state.set(key,data.state[key].duplicate(true) if data.state[key] is Array or data.state[key] is Dictionary else data.state[key])
	MEMORY.instance().restore_run(data.memory_run)
	resume_phase = data.phase
	loading = true
	return true

