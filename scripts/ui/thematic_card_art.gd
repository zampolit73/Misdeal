class_name ThematicCardArt
extends RefCounted

const DEDICATED_RUN_ART := {
	"bone_patrol": true,
	"bone_warden": true,
	"gallows_volley": true,
	"graveyard_ambush": true,
	"whispering_well": true,
}

static var _cache: Dictionary = {}

static func get_run_card_texture(card_id: String, type_label: String) -> Texture2D:
	if DEDICATED_RUN_ART.has(card_id):
		return null
	return _make("run:%s" % card_id, card_id, 96, 64, 0, type_label)

static func get_choice_texture(card_id: String, option_index: int) -> Texture2D:
	return _make("choice:%s:%d" % [card_id, option_index], card_id, 96, 96, option_index, "")

static func get_upgrade_texture(upgrade_id: String, role: String) -> Texture2D:
	return _make("upgrade:%s" % upgrade_id, upgrade_id, 96, 64, 0, role)

static func get_reward_background(key: String, role: String = "") -> Texture2D:
	return _make("reward:%s:%s" % [key, role], key, 96, 120, 0, role)

static func _make(cache_key: String, subject: String, width: int, height: int, variant: int, qualifier: String) -> Texture2D:
	if _cache.has(cache_key):
		return _cache[cache_key] as Texture2D
	var palette := _palette(subject, qualifier)
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(palette[0])
	_fill_rect(image, Rect2i(0, int(height * 0.58), width, height), palette[1])
	_draw_noise(image, subject, palette[2])
	_draw_motif(image, _motif(subject), palette[2], palette[3], variant)
	_fill_rect(image, Rect2i(0, int(height * 0.70), width, height), Color(0.015, 0.012, 0.018, 0.45))
	_frame(image, palette[2])
	var texture := ImageTexture.create_from_image(image)
	_cache[cache_key] = texture
	return texture

static func _palette(subject: String, qualifier: String) -> Array[Color]:
	var family := _family(subject, qualifier)
	match family:
		"blue":
			return [Color("0b111a"), Color("06090e"), Color("4e7397"), Color("91b7da")]
		"green":
			return [Color("0b150f"), Color("060906"), Color("4d7b4a"), Color("8ac57a")]
		"violet":
			return [Color("130d1b"), Color("08060b"), Color("744a96"), Color("bf84eb")]
		"teal":
			return [Color("071518"), Color("04090a"), Color("2d7b78"), Color("62d7c5")]
		"gold":
			return [Color("171109"), Color("080706"), Color("9b722c"), Color("e3b34d")]
		"red":
			return [Color("19090a"), Color("080506"), Color("9d3432"), Color("e56a55")]
		_:
			return [Color("14100f"), Color("080707"), Color("775346"), Color("bb8067")]

static func _family(subject: String, qualifier: String) -> String:
	if qualifier == "knight":
		return "blue"
	if qualifier == "ranger":
		return "green"
	if qualifier == "mage":
		return "violet"
	match subject:
		"rattling_bridge", "grave_bell":
			return "teal"
		"black_altar", "faceless_card", "mage_glass_heart", "mage_overload":
			return "violet"
		"broken_crown", "lost_purse", "candle_seller", "debtor_bones", "blood_coin", "gold", "fallback_gold", "elite_gold", "extra_cap_gold":
			return "gold"
		"ash_rest", "last_camp", "curse_forge", "blood_ledger", "wizard_tithe", "death_wager", "mage_wildfire":
			return "red"
		"ranger_longshot", "ranger_arrowstorm", "ranger_beast_trail", "blind_quiver":
			return "green"
		"knight_iron_oath", "knight_executioner", "knight_cleaver", "dead_mans_shield":
			return "blue"
		"whispering_well":
			return "teal"
		_:
			return "brown"

static func _motif(subject: String) -> String:
	match subject:
		"ash_rest", "last_camp", "curse_forge", "candle_seller", "mage_wildfire":
			return "fire"
		"rattling_bridge":
			return "bridge"
		"debtor_bones", "death_wager", "bone_crush":
			return "skull"
		"black_altar", "bonus_upgrade":
			return "sigil"
		"faceless_card":
			return "card"
		"blood_ledger":
			return "book"
		"broken_crown":
			return "crown"
		"chained_prisoner", "bone_tax", "ossuary_gate":
			return "bars"
		"gravedigger_shop", "lost_purse", "blood_coin", "gold", "fallback_gold", "elite_gold", "extra_cap_gold":
			return "coins"
		"wizard_tithe":
			return "hand"
		"whispering_well":
			return "well"
		"grave_bell":
			return "bell"
		"crypt_guard", "knight_iron_oath", "dead_mans_shield":
			return "shield"
		"knight_executioner", "knight_cleaver":
			return "sword"
		"ranger_longshot", "blind_quiver":
			return "bow"
		"ranger_arrowstorm":
			return "arrows"
		"ranger_beast_trail":
			return "tracks"
		"mage_glass_heart", "cracked_focus":
			return "crystal"
		"mage_overload":
			return "lightning"
		_:
			return "sigil"

static func _draw_motif(image: Image, motif: String, accent: Color, glow: Color, variant: int) -> void:
	var w := image.get_width()
	var h := image.get_height()
	var cx := int(w / 2)
	var cy := int(h * 0.44)
	match motif:
		"fire":
			_fill_rect(image, Rect2i(cx - 24, cy + 13, 48, 4), accent)
			_triangle(image, Vector2i(cx - 12, cy + 12), Vector2i(cx, cy - 18), Vector2i(cx + 12, cy + 12), glow)
			_triangle(image, Vector2i(cx - 5, cy + 10), Vector2i(cx + 4, cy - 8), Vector2i(cx + 9, cy + 10), accent.lightened(0.18))
		"bridge":
			for x in range(12, w - 12, 10):
				_fill_rect(image, Rect2i(x, cy + int(abs(x - cx) * 0.12), 8, 4), Color("604b37"))
			_line(image, Vector2i(8, cy + 15), Vector2i(w - 8, cy + 15), accent, 2)
		"skull":
			_circle(image, Vector2i(cx, cy), 16, glow.darkened(0.18))
			_fill_rect(image, Rect2i(cx - 12, cy + 10, 24, 11), glow.darkened(0.25))
			_fill_rect(image, Rect2i(cx - 8, cy - 3, 5, 5), Color("130909"))
			_fill_rect(image, Rect2i(cx + 3, cy - 3, 5, 5), Color("130909"))
		"sigil":
			_circle_outline(image, Vector2i(cx, cy), 19, accent)
			_line(image, Vector2i(cx, cy - 20), Vector2i(cx + 17, cy + 11), glow, 2)
			_line(image, Vector2i(cx + 17, cy + 11), Vector2i(cx - 17, cy + 11), glow, 2)
			_line(image, Vector2i(cx - 17, cy + 11), Vector2i(cx, cy - 20), glow, 2)
		"card":
			_fill_rect(image, Rect2i(cx - 18, cy - 23, 36, 48), Color("1b1721"))
			_rect_outline(image, Rect2i(cx - 18, cy - 23, 36, 48), accent)
			_circle(image, Vector2i(cx, cy - 3), 10, accent.darkened(0.55))
		"book":
			_fill_rect(image, Rect2i(cx - 28, cy - 17, 26, 35), Color("321519"))
			_fill_rect(image, Rect2i(cx + 2, cy - 17, 26, 35), Color("281216"))
			_line(image, Vector2i(cx, cy - 18), Vector2i(cx, cy + 20), glow, 2)
		"crown":
			_triangle(image, Vector2i(cx - 26, cy + 14), Vector2i(cx - 17, cy - 15), Vector2i(cx - 5, cy + 14), accent)
			_triangle(image, Vector2i(cx - 8, cy + 14), Vector2i(cx, cy - 22), Vector2i(cx + 8, cy + 14), glow)
			_triangle(image, Vector2i(cx + 5, cy + 14), Vector2i(cx + 18, cy - 15), Vector2i(cx + 26, cy + 14), accent)
			_fill_rect(image, Rect2i(cx - 28, cy + 12, 56, 7), glow.darkened(0.16))
		"bars":
			for x in range(cx - 26, cx + 27, 13):
				_fill_rect(image, Rect2i(x, cy - 25, 4, 52), accent)
			_fill_rect(image, Rect2i(cx - 30, cy - 19, 60, 5), glow.darkened(0.25))
		"coins":
			_circle(image, Vector2i(cx - 15, cy + 6), 10, glow.darkened(0.18))
			_circle(image, Vector2i(cx + 3, cy - 4), 12, glow)
			_circle(image, Vector2i(cx + 19, cy + 9), 8, accent.lightened(0.16))
		"hand":
			_fill_rect(image, Rect2i(cx - 26, cy - 4, 34, 18), accent.darkened(0.25))
			for y in range(cy - 15, cy + 5, 6):
				_fill_rect(image, Rect2i(cx + 5, y, 28, 4), glow.darkened(0.16))
		"well":
			_ellipse(image, Vector2i(cx, cy + 9), 29, 11, Color("0c3030"))
			_ellipse_outline(image, Vector2i(cx, cy + 9), 29, 11, accent)
			_ellipse(image, Vector2i(cx, cy + 6), 20, 6, glow.darkened(0.25))
		"bell":
			_triangle(image, Vector2i(cx - 20, cy + 17), Vector2i(cx, cy - 23), Vector2i(cx + 20, cy + 17), accent.lightened(0.05))
			_circle(image, Vector2i(cx, cy + 19), 4, glow)
		"shield":
			_fill_rect(image, Rect2i(cx - 19, cy - 21, 38, 28), accent.darkened(0.36))
			_triangle(image, Vector2i(cx - 19, cy + 6), Vector2i(cx, cy + 27), Vector2i(cx + 19, cy + 6), accent.darkened(0.36))
			_line(image, Vector2i(cx, cy - 18), Vector2i(cx, cy + 20), glow, 3)
		"sword":
			_line(image, Vector2i(cx + 15, cy - 26), Vector2i(cx - 10, cy + 19), glow, 5)
			_line(image, Vector2i(cx - 21, cy + 6), Vector2i(cx + 1, cy + 18), accent, 4)
		"bow":
			_arc(image, Vector2i(cx - 9, cy), 25, accent)
			_line(image, Vector2i(cx - 9, cy - 25), Vector2i(cx - 9, cy + 25), glow, 1)
			_line(image, Vector2i(cx - 9, cy), Vector2i(cx + 30, cy - 7), glow, 2)
		"arrows":
			for off in [-12, 0, 12]:
				_line(image, Vector2i(cx - 30, cy + off), Vector2i(cx + 30, cy + off - 12), glow, 2)
		"tracks":
			for off in [-22, 0, 22]:
				_ellipse(image, Vector2i(cx + off, cy + int(off * 0.25)), 7, 10, accent)
				_circle(image, Vector2i(cx + off - 5, cy - 11 + int(off * 0.25)), 3, glow)
		"crystal":
			_triangle(image, Vector2i(cx - 19, cy + 9), Vector2i(cx, cy - 28), Vector2i(cx + 19, cy + 9), accent)
			_triangle(image, Vector2i(cx - 14, cy + 8), Vector2i(cx, cy + 27), Vector2i(cx + 14, cy + 8), glow.darkened(0.2))
		"lightning":
			_line(image, Vector2i(cx + 10, cy - 27), Vector2i(cx - 7, cy), glow, 6)
			_line(image, Vector2i(cx - 7, cy), Vector2i(cx + 7, cy), glow, 6)
			_line(image, Vector2i(cx + 7, cy), Vector2i(cx - 13, cy + 28), glow, 6)
	if variant > 0:
		_fill_rect(image, Rect2i(w - 10 - variant * 5, 8, 4, 4), glow)

static func _draw_noise(image: Image, subject: String, accent: Color) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(subject)
	for _i in range(30):
		var x := rng.randi_range(3, image.get_width() - 4)
		var y := rng.randi_range(3, image.get_height() - 4)
		image.set_pixel(x, y, Color(accent.r, accent.g, accent.b, 0.18))

static func _frame(image: Image, color: Color) -> void:
	_rect_outline(image, Rect2i(2, 2, image.get_width() - 4, image.get_height() - 4), Color(color.r, color.g, color.b, 0.7))

static func _fill_rect(image: Image, rect: Rect2i, color: Color) -> void:
	for y in range(maxi(0, rect.position.y), mini(image.get_height(), rect.end.y)):
		for x in range(maxi(0, rect.position.x), mini(image.get_width(), rect.end.x)):
			_blend_pixel(image, x, y, color)

static func _rect_outline(image: Image, rect: Rect2i, color: Color) -> void:
	_line(image, rect.position, Vector2i(rect.end.x - 1, rect.position.y), color, 1)
	_line(image, Vector2i(rect.position.x, rect.end.y - 1), Vector2i(rect.end.x - 1, rect.end.y - 1), color, 1)
	_line(image, rect.position, Vector2i(rect.position.x, rect.end.y - 1), color, 1)
	_line(image, Vector2i(rect.end.x - 1, rect.position.y), Vector2i(rect.end.x - 1, rect.end.y - 1), color, 1)

static func _line(image: Image, from: Vector2i, to: Vector2i, color: Color, thickness: int) -> void:
	var delta := to - from
	var steps := maxi(abs(delta.x), abs(delta.y))
	if steps <= 0:
		_fill_rect(image, Rect2i(from.x, from.y, thickness, thickness), color)
		return
	for step in range(steps + 1):
		var t := float(step) / float(steps)
		var p := Vector2i(roundi(lerpf(from.x, to.x, t)), roundi(lerpf(from.y, to.y, t)))
		_fill_rect(image, Rect2i(p.x - int(thickness / 2), p.y - int(thickness / 2), thickness, thickness), color)

static func _circle(image: Image, center: Vector2i, radius: int, color: Color) -> void:
	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			if x * x + y * y <= radius * radius:
				_blend_pixel(image, center.x + x, center.y + y, color)

static func _circle_outline(image: Image, center: Vector2i, radius: int, color: Color) -> void:
	for angle in range(0, 360, 4):
		var p := center + Vector2i(roundi(cos(deg_to_rad(angle)) * radius), roundi(sin(deg_to_rad(angle)) * radius))
		_fill_rect(image, Rect2i(p.x - 1, p.y - 1, 3, 3), color)

static func _ellipse(image: Image, center: Vector2i, rx: int, ry: int, color: Color) -> void:
	for y in range(-ry, ry + 1):
		for x in range(-rx, rx + 1):
			if float(x * x) / float(rx * rx) + float(y * y) / float(ry * ry) <= 1.0:
				_blend_pixel(image, center.x + x, center.y + y, color)

static func _ellipse_outline(image: Image, center: Vector2i, rx: int, ry: int, color: Color) -> void:
	for angle in range(0, 360, 4):
		var p := center + Vector2i(roundi(cos(deg_to_rad(angle)) * rx), roundi(sin(deg_to_rad(angle)) * ry))
		_fill_rect(image, Rect2i(p.x - 1, p.y - 1, 3, 3), color)

static func _arc(image: Image, center: Vector2i, radius: int, color: Color) -> void:
	for angle in range(-78, 79, 3):
		var p := center + Vector2i(roundi(cos(deg_to_rad(angle + 180)) * radius), roundi(sin(deg_to_rad(angle + 180)) * radius))
		_fill_rect(image, Rect2i(p.x - 1, p.y - 1, 3, 3), color)

static func _triangle(image: Image, a: Vector2i, b: Vector2i, c: Vector2i, color: Color) -> void:
	var min_x := mini(a.x, mini(b.x, c.x))
	var max_x := maxi(a.x, maxi(b.x, c.x))
	var min_y := mini(a.y, mini(b.y, c.y))
	var max_y := maxi(a.y, maxi(b.y, c.y))
	var area := float((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x))
	if is_zero_approx(area):
		return
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var p := Vector2i(x, y)
			var s := float((b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)) / area
			var t := float((c.x - b.x) * (p.y - b.y) - (c.y - b.y) * (p.x - b.x)) / area
			var u := float((a.x - c.x) * (p.y - c.y) - (a.y - c.y) * (p.x - c.x)) / area
			if (s >= 0.0 and t >= 0.0 and u >= 0.0) or (s <= 0.0 and t <= 0.0 and u <= 0.0):
				_blend_pixel(image, x, y, color)

static func _blend_pixel(image: Image, x: int, y: int, color: Color) -> void:
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return
	if color.a >= 0.999:
		image.set_pixel(x, y, color)
		return
	var under := image.get_pixel(x, y)
	image.set_pixel(x, y, under.lerp(Color(color.r, color.g, color.b, 1.0), color.a))
