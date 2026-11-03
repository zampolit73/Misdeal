extends RefCounted

# D381: one physical layout for the approved Fate Spread reference and
# the live overlay/masks. Coordinates are local to the 780x540 SpreadArea,
# whose origin on the 1280x720 reference is (250, 140).
# Never move the printed background cards independently of the live cards.
const CENTER := Vector2(390.0, 260.0)
const SLOT_SIZE := Vector2(100.0, 138.0)
const CARD_MASK_SIZE := Vector2(112.0, 150.0)
const NUMERAL_MASK_SIZE := Vector2(58.0, 30.0)

const SLOT_CENTERS := [
	Vector2(390.0, 56.0),  # I
	Vector2(514.0, 82.0),  # II
	Vector2(618.0, 142.0), # III
	Vector2(690.0, 241.0), # IV
	Vector2(638.0, 356.0), # V
	Vector2(540.0, 445.0), # VI — the reference misprints V here
	Vector2(392.0, 474.0), # VII
	Vector2(240.0, 450.0), # VIII
	Vector2(143.0, 347.0), # IX
	Vector2(90.0, 236.0),  # X
	Vector2(160.0, 130.0), # XI
	Vector2(275.0, 84.0),  # XII
]
const SLOT_ROTATIONS_DEG := [
	0.0, 7.0, 10.0, 11.0, 9.0, 6.0,
	0.0, -7.0, -10.0, -11.0, -9.0, -6.0,
]

# The approved bitmap itself has an incorrect V above the SIXTH position.
# For that one future card, cover only the printed glyph and draw VI in Godot.
# At the point VI becomes active, the regular per-card Roman takes over.
const PRINTED_SIXTH_ROMAN_MASK := Rect2(532.0, 361.0, 53.0, 29.0)
const PRINTED_SIXTH_ROMAN_LABEL := Rect2(536.0, 363.0, 45.0, 25.0)
