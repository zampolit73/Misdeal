extends RefCounted

const OATHS := [
	["Без клятвы", "Обычные правила первого акта."],
	["I · Жадность", "Товары и услуги торговцев дороже на 25%."],
	["II · Шрамы", "Отдых на привале лечит до 30% макс. HP вместо 40%."],
	["III · Чёрная колода", "Враги наносят на 10% больше урона на пяти особых аренах. Предупреждение видно перед боем."],
	["IV · Долг", "Золотая десятина дороже на 25%. Клеймо Последней сделки отнимает 22 макс. HP, если нет реликвии для платы."],
	["V · Последняя ставка", "Действуют все четыре предыдущие клятвы."]
]
const STYLES := {
	"knight": ["blood_oath", "Кровавый обет", "При HP ≤ 50% в Обороне рыцарь получает на 12% меньше урона от ударов. Скорость −8%."],
	"ranger": ["shadow_hunter", "Теневой охотник", "В Охоте следопыт наносит на 12% больше урона целям с HP ≤ 50%. Дальность −10."],
	"mage": ["ash_seer", "Пепельный провидец", "Маг получает +18 к радиусу взрыва. Урон −8%."]
}
const BLACK_DECK := ["grave_bell", "defiled_laboratory", "iron_wall", "firing_square", "court_of_the_mute"]
const GREED_MULTIPLIER := 1.25
const SCARS_REST := 0.30
const BLACK_DECK_BONUS := 0.10
const DEBT_HP_COST := 22.0


static func oath_applies(rank: int, rule: int) -> bool:
	return rank == rule or rank == OATHS.size() - 1


static func is_style_for_role(style: String, role: String) -> bool:
	return style.is_empty() or (STYLES.has(role) and STYLES[role][0] == style)
