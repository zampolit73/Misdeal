# D402 — Knight shield stays visible during C3 attack

Date: 2026-11-06.

## Evidence

Player uploaded `01-07-47.mp4`, an 18.63-second 1920×1080 desktop recording showing the native 1280×720 D401 Godot F6 comparison. The player cycles idle, walk, attack, hit, death, auto. All three hero pairs fit; the D401 sword silhouette and Ranger bow repair remain visible. This is **NOT an F5 in-game battle capture**, and a desktop recording cannot establish final art-quality PASS.

Examining the actual source `hero_c3_d401/knight.webp.b64` revealed the next objective continuity defect: in Knight **attack row 2 columns 2–5 (four of six attacks)**, the shield disappears completely, although the Knight's approved core identity is **sword + shield + heavy worn steel + torn burgundy cape**. This was not caught by alpha-cell counts, connected mask or sword identity checks.

## Actual D402 work

- Versioned **one new RGBA Knight source atlas** `assets/pixel/units/hero_c3_d402/knight.webp.b64`, 576×480, 6×5, 25 original image-derived Knight action poses preserved. Copy the shield from the Knight's **OWN D401 walk image**, mask the original red/gold profile, and place rotated/scaled shield cutouts at the supporting arm in attack row2 columns2–5. Shield and main body are connected; original sword and cape pixels are never erased. Only these four cels differ from D401, all other 26 grid cells are pixel-identical.
- **No new Ranger or Mage atlas** in D402. Keep their D401 look and animation source unchanged. Do not make gratuitous copies. In `scripts/battle/unit_animation_library.gd`, add `C3_KNIGHT_D402_PATH` as a **Knight-only** first-choice source; if missing/invalid, automatically fall back to verified D401 Knight before old v2. Ranger/Mage still use `C3_HERO_PILOT_DIR` D401.
- `tests/unit/test_d402_c3_knight_shield_continuity.gd` verifies that only the intended 4 attack frames change, the shield gains substantial alpha surface without deleting source swords/body, 25 unique full-body frames and 5 empty spare cells remain, live Knight `SpriteFrames` read the D402 atlas, and Ranger/Mage clip contracts remain intact. Existing D398–D401 QA should remain green.
- `res://scenes/dev/d398_c3_hero_animation_preview.tscn` retains the same scene name, but its captions now show D402 for clear visible verification.

**Provenance:** This is a focused atlas-based pose retouch using an existing approved Knight shield, **NOT** four brand-new independently hand-pixel-painted illustrations and certainly not a claim that the complete C3 motion set is final. The shield looks appropriately smaller/side-on while swinging; this improves readability but may still require a fully hand-illustrated re-authoring later.

## Local check once PR CI is green

1. `git -c gc.auto=0 pull --ff-only origin main`.
2. Open `res://scenes/dev/d398_c3_hero_animation_preview.tscn` → F6 → ATTACK. Check the **right-hand** C3 Knight across all six cels; the shield must not vanish in the middle of the swing. Use AUTO for state transitions.
3. If convenient, do one actual F5 Knight fight to check sword, shield and feet at battle scale. The video is not an F5 acceptance.
4. Remaining motion-art work: Knight off-hand/body articulation and natural shield swing, Mage staff/glow timing, footfall and grounded death for all. Retain original C3 visual direction; never replace with old blue-v2 recolor.

No changes to actual damage, AI, movement speed, weapon stats, enemy sprites, party rules, Fate Spread, DS3, waves or sounds.
