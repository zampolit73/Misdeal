extends RefCounted
## Separates authored event copy from the button skin. The scene supplies live prices and gates.

static func gold(button: Button, price: int) -> void:
	button.set_meta("event_cost", "−%d золота" % price)
	button.set_meta("event_kind", "МОНЕТА")
	if button.disabled and not button.has_meta("event_restriction"):
		restrict(button, "Недостаточно золота")


static func restrict(button: Button, reason: String) -> void:
	button.set_meta("event_restriction", reason)


static func prepare(button: Button) -> void:
	var sections := button.text.split("\n\n", true, 1)
	var action := sections[0]
	var detail := String(button.get_meta("event_outcome", sections[1] if sections.size() > 1 else ""))
	var reason := String(button.get_meta("event_restriction", ""))
	if button.disabled and not reason.is_empty():
		detail = detail.replace(reason, "").strip_edges()
	if button.has_meta("event_cost") and action.contains(" — "):
		var tail := action.get_slice(" — ", 1)
		if tail.is_valid_int():
			action = action.get_slice(" — ", 0)

	# Existing authored copy describes up-front HP prices in either word order.
	# Chance outcomes (e.g. «50%: −20 здоровья») stay in the consequences.
	if not button.has_meta("event_cost"):
		var price := RegEx.create_from_string("(?m)(?:^|(?<= • ))(?:[-−]\\d+ (?:макс\\. HP|здоровья)(?: отряд[ау]| каждому герою)?|Здоровье отряда [-−]\\d+)")
		var found := price.search(detail)
		if found != null:
			button.set_meta("event_cost", found.get_string().replace("-", "−"))
			button.set_meta("event_kind", "КРОВЬ")
			var remaining := detail.substr(found.get_end()).trim_prefix(".").trim_prefix(", но ").strip_edges()
			var preceding := detail.left(found.get_start()).trim_suffix(" • ").strip_edges()
			detail = (preceding + "\n" + remaining).strip_edges()

	if not button.has_meta("event_kind"):
		var kind := "ВЫБОР"
		if detail.begins_with("50%") or detail.begins_with("Исход неизвестен"):
			kind = "РИСК"
		elif action.begins_with("НЕ ") or action.begins_with("ОСТАВИТЬ") or action.begins_with("ОТОЙТИ") or action == "ОТКАЗАТЬ":
			kind = "ОТКАЗ"
		elif button.has_meta("choice_role"):
			kind = "РАЗВИТИЕ"
		button.set_meta("event_kind", kind)
	button.set_meta("event_action", action)
	button.set_meta("event_outcome", detail.replace("\n\n", "\n"))
