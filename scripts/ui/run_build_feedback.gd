extends RefCounted

const STATS := {"current_hp": "HP", "hp": "макс. HP", "damage": "урон",
	"attack_rate": "атак/с", "attack_range": "дальность", "move_speed": "скорость",
	"splash_radius": "радиус"}


static func capture(state: Node) -> Dictionary:
	var party := {}
	for role in state.party_roles:
		var stats: Dictionary = state.get_effective_hero_stats(role)
		stats.current_hp = state.get_hero_current_hp(role)
		party[role] = stats
	return party


static func changes(before: Dictionary, after: Dictionary, limit := 0) -> String:
	var lines := PackedStringArray()
	for role in after:
		if not before.has(role):
			lines.append("%s · %s/%s HP" % [after[role].unit_name, _value(after[role].current_hp), _value(after[role].hp)])
			continue
		var changes_for_role := PackedStringArray()
		for key in STATS:
			if not is_equal_approx(before[role][key], after[role][key]):
				changes_for_role.append("%s %s → %s" % [STATS[key], _value(before[role][key]), _value(after[role][key])])
		if not changes_for_role.is_empty():
			lines.append("%s · %s" % [after[role].unit_name, ", ".join(changes_for_role)])
	return "\n".join(lines.slice(0, limit) if limit > 0 else lines)


static func _value(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return str(roundi(value))
	return String.num(value, 2).replace(".", ",")
