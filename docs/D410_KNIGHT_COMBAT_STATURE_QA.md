# D410 — Knight combat silhouette stature (2026-11-08)

## Player evidence
The native F5 screenshot of Bone Patrol shows the approved C3 Knight notably shorter and less imposing than his Ranger and Mage companions. This is a live BattleUnit rendering issue, not a missing animation: `scripts/battle/unit.gd` applies `HERO_DISPLAY_SCALE = 1.28` then multiplies Knight by `0.90`, Ranger by `1.00`, Mage by `1.25`. All three shipped UnitData resources use `visual_scale = 1.0`.

## Scoped fix
- Only the **player Knight art** receives `HERO_ROLE_VISUAL_SCALES["knight"] = 1.38` (net Sprite2D scaling `1.7664`). Ranger remains `1.28`, Mage remains `1.60`. This restores the broad armored Knight's leading silhouette without replacing the approved C3 art.
- Lift the Knight's health bar to `-126..-119` relative to BattleUnit. Ranger and Mage bars remain at `-90..-83`; name labels remain unchanged.
- `_art_rest_position()` still uses the existing sole-based foot contact: as the Sprite2D grows, its origin automatically shifts upward to keep the same floor ring. Do not change unit Node2D position, collision radius, movement, targeting, damage, per-frame animations, gait timing, or approved Knight sword/shield/torn cape.
- This is an art-presentation correction **for the actual F5 battle**, not a redesign of the F6 side-by-side atlas comparison.

## Test gate
`tests/unit/test_d410_knight_visual_stature.gd` instantiates the real three player BattleUnit scenes using shipped UnitData resources. It checks C3 SpriteFrames across all five states, literal display scales, actual opaque idle art stature, all three soles meeting the floor ring, the lifted Knight health bar, unchanged Ranger/Mage bar offsets and critical Knight mechanics. Existing D403, D404, D405 and D409 tests remain regression gates.

## Player native acceptance
After CI/merge: `git -c gc.auto=0 pull --ff-only origin main`, F5 real encounter `КОСТЯНОЙ ДОЗОР`. Confirm Knight is visibly the heaviest/largest hero, head and shield are not hidden behind HP, boots touch the blue contact ring during walking and attack, and Mage/Ranger remain unchanged. If the painted C3 art still feels too slight despite greater display scale, discuss an art-only armor/silhouette pass separately; do not alter approved walk/attack timing or mechanics blindly.

Human F5 aesthetic acceptance is distinct from automated GUT/scene CI.
