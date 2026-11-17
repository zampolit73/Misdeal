extends RefCounted
## Presentation mapping only. Never infer a dice result or purchase from final stats.
const ROOT := "res://assets/pixel/travel/batch_02/"
const ACTIONS := {
	"candle_seller":["knight","ranger","mage","leave"],
	"blood_ledger":["gold","blood","erase","leave"],
	"debtor_bones":["gamble_success","gamble_failure","safe","break","leave"],
	"wizard_tithe":["gold","blood","refuse"],
	"broken_crown":["wear","break","melt","leave"],
	"curse_forge":["dead_mans_shield","blind_quiver","cracked_focus","leave"],
	"rattling_bridge":["rush_success","rush_failure","scavenge","careful","recruit","loot_recruitment","abandon"]}
static var entries: Dictionary = {}

static func action_for(id: String, outcome: String, roles: Array, presentation: Dictionary) -> String:
	var action := str(presentation.get("visual_action",outcome))
	if action.is_empty(): action=outcome
	match id:
		"candle_seller":
			action=str(presentation.get("choice_role",""))
			if action!="leave" and action not in roles: return ""
		"curse_forge":
			action=str(presentation.get("visual_action",""))
		"debtor_bones":
			if action=="gamble":
				if not presentation.get("roll_success") is bool: return ""
				action="gamble_success" if presentation.roll_success else "gamble_failure"
		"rattling_bridge":
			action=str(presentation.get("visual_action",""))
			if action=="rush":
				if not presentation.get("roll_success") is bool: return ""
				action="rush_success" if presentation.roll_success else "rush_failure"
			if action in ["recruit","loot_recruitment","abandon"]:
				if not bool(presentation.get("recruitment",false)): return ""
				if (action=="recruit")!=roles.has("ranger"): return ""
	return action if action in ACTIONS.get(id,[]) else ""

static func narration(id: String, action: String) -> String:
	if entries.is_empty():
		var parsed: Variant=JSON.parse_string(FileAccess.get_file_as_string(ROOT+"staging.json"))
		if not parsed is Dictionary: return ""
		for scene in parsed.scenes: entries[scene.id]=scene
	if not entries.has(id): return ""
	var scene: Dictionary=entries[id]
	for i in range(scene.states.size()):
		if scene.states[i].key==action: return str(scene.source_outcomes[i][-1])
	return ""
