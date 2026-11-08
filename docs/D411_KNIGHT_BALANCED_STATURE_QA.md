# D411 — Moderate live Knight stature after F5 feedback (2026-11-09)

## Player's visual verdict

After D410 released, the player supplied a native F5 screenshot of «МОГИЛЬНЫЙ ПЕРЕКРЁСТОК» showing a Knight who was **too large** relative to the Ranger and Mage. This explicitly rejects D410's `1.38` player-Knight visual multiplier as final art direction. Do not interpret the successful D410 GUT as aesthetic approval.

## Scoped adjustment

- Actual `BattleUnit.HERO_ROLE_VISUAL_SCALES["knight"]`: `1.38 → 1.25`; the Knight's effective `ArtSprite` scale is now `1.28 × 1.25 = 1.60` (from `1.7664`). Compared to the D410 screenshot the knight is about **9.4% shorter and narrower**. Ranger stays `1.28`, Mage stays `1.60` (their unchanged role factors are `1.00` and `1.25`). Armor and shield should provide visual *mass*, rather than sheer height.
- Actual player Knight health bar `-126..-119 → -112..-105` relative to unit origin, tracking the smaller silhouette. The other two heroes and all enemies retain their bar positions.
- Preserve `_art_rest_position()` sole-to-ring y36 anchoring automatically after adjusting `base_sprite_scale`. No `Node2D.scale`, collision, HP/damage, movement, target acquisition, attack timing, visual poses, authored atlas pixels, DS3 or arena layout changes.
- Preserve D409 source WALK posture, user-accepted D404 WALK displacement cadence and D405 ATTACK presentation, D406 sword grip and cape, D407 Mage crystal, D408 HIT props.

## Verification

Existing `tests/unit/test_d410_knight_visual_stature.gd` now guards the **D411** intended hierarchy instead of insisting Knight scales larger than Mage: actual C3 opaque Knight idle art should remain taller than Ranger, comparable to Mage (90–122% of visible height), and be grounded with Knight HP at new offsets. It still checks all five real C3 animation states, unaffected Ranger/Mage art scales, real scene contact geometry and critical combat stats. Godot CI must pass before merging.

Player local F5 gate: inspect the three-hero party in «МОГИЛЬНЫЙ ПЕРЕКРЁСТОК», with focus on comfortable similar scale, broad Knight armor, HP bar not crossing the helmet and feet remaining on the floor. If it still looks too large, compare another in-game screenshot before another adjustment.

**Technical CI PASS is not human F5 visual acceptance.**
