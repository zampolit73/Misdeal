# D234 — Road Sentinel: connect lantern to FREE hand, preserve rich-art character

Date: 2026-10-18. **QA version in GitHub main; native Godot F6 and user's art acceptance PENDING**. The playable pool is still **37/45** and card #38 remains QA-only.

## User-reported defect: D233 lantern is not held

After viewing D233 four idle variants, the user said **«тут как будто бы он не держит фонарь»**. This is an explicit **D233 visual FAIL / not accepted**. The analysis revealed a geometric cause in the D232 original illustrated 115×129 source: the warm lantern was painted near **x≈54, y≈100 at the OTHER knee** while the free/right-hand gauntlet is near **x≈82, y≈79**. D233 moved lantern and cloak cutouts slightly but did not create a continuous, readable wrist-to-lantern attachment. It looked like a separate floating prop.

User then said **«продолжай»** to authorize this specific fix, not wholesale art/animation approval.

## What D234 actually changes

This is a **reproducible 4-idle-frame cutout experiment** using the exact original D232 rich illustration cutout, not the D229 simplistic geometric sprite:

- `tools/art/author_road_sentinel_d234_hand_lantern.py` reads checked-in `road_sentinel_d232_reference_cutout.webp.b64` (115×129). The source truly belongs to the right approved spear-bearing Sentinel character.
- Old lantern is removed from knee-level x≈54, and its former image area is filled using **real textured burgundy cloth from the same illustrated cloak**, mirrored and alpha-composited with irregular contours (not a large flat dark polygon).
- The *same* lantern is moved to the **right free hand** at x≈82. Each frame draws a metal ring and short iron hanger from **fixed glove anchor (82,82)** to varying lantern cap (82–83,91–92). The original gauntlet is re-composited **on top** so fingers visibly overlap the handle.
- Lantern idle sway is deliberately minimal (≤1 source pixel per axis), and the hanger is recalculated for each frame: one anchoring point instead of independently bobbing "floating" lantern.
- Preserves the distinct long pointed **SPEAR**, armored skull, dark textured pauldrons and cape, as opposed to generating a new flattened figure. Frame cells nearest-scaled to true **96×96 RGBA**. All 4 have alpha bboxes (12,6,86,90), no 2px crop collisions.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d234_handheld_idle4.webp.b64` lossless transparent WebP, **576×480** familiar Godot 6×5 format, ONLY **4 distinct idle cels** in the first row, **26 completely empty unused** cells. Reproducible from versioned source: decoded WebP byte SHA-256 **`14e3714ef16ca061431a7bc42585568dcafce96dc969da7da113612fc6cd0a1b`**. Machine QC: `docs/qa/D234_SENTINEL_HAND_LANTERN_QC.json`.
- Preview comparison `D234_D233_before_after_idles.png` and zoom `D234_hand_lantern_96px_x6.png` show D233 knee lantern vs D234 new free-hand lantern. Note: the source still came from **one illustrated pose**, not four uniquely repainted full bodies, and alpha/anchor geometry QC is NOT artistic acceptance at x1. The image generator produced another mislabeled 25-frame poster while exploring the fix: **rejected, not imported**.

## Godot comparison and QA gate

`res://scenes/dev/black_lantern_sentinel_d234_hand_lantern_compare.tscn` with `scripts/dev/black_lantern_sentinel_d234_hand_lantern_compare.gd` shows **D233 on LEFT / D234 on RIGHT**, each x3 and game-real x1, on the exact D209 user-approved moonlit forest. Both have genuine *idle-only* 4-frame animated sprites, synchronized start, pause/resume and LEFT/RIGHT facing controls. Validator requires each atlas 576×480, 4 distinct non-empty frames and all **26** other cells alpha-clear with safe 2px borders. The statuses in-game explicitly say only `idle` exists.

**Godot 4.7 native F6 NOT tested** in this environment, which has no Godot binary. Do not claim F6 PASS until user reports it. Exact action:
1. `git pull`
2. F6 `res://scenes/dev/black_lantern_sentinel_d234_hand_lantern_compare.tscn`
3. At native ×1, check whether the right free-hand fingers/metal short handle remain connected while lantern gently moves, **not** detached, and whether the left skirt has no flat-hole rectangle. Try both facing buttons and pause. If any visual detachment remains, fix **the actual source pixel geometry**, not by announcing "QA passed".

## Release and source-of-truth limits

D234 does **not** supply an original 25-frame final sprite, walk6/attack6/hit3/death6 are absent; D232 rich single-character x1 style has not been independently formally approved by the user. The D229 technical sprite currently registered in `MisdealUnitAnimationLibrary.get_frames("road_sentinel")` has NOT been replaced. No `BattleUnit`, `resources/units`, encounter mechanics, `RunState.ACT1_CARD_IDS`, approved D200 card illustration, D209 arena or KARAMBA73 checkpoint changed. Still **37/45 live**.

Next only after D234 visual check: rebuild authentic moving *full-body* walk/thrust/hit/death in approved rich style. Do not procedurally mirror one idle pose 21 times or treat multi-panel imagegen posters as real animation assets. Stop if source quality degrades rather than silently switching to D229 quality again.
