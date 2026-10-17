# D217 — Oil Acolyte / Масляный служка: original 25-state animation QA staging

Date: 2026-10-17. **ORIGINAL F6 BORDER FAIL FIXED AT a8a80f1; USER-REPORTED POST-FIX F6 PASS («все ок»), 2026-10-17. ALL LIVE GAMEPLAY UNCHANGED.** Act1 **37/45**; #38 `black_lantern_road` is QA-only.

## D217 native recovery — final user report

After the source-art correction and `git pull` + F6 retest request, user replied **«все ок»** (2026-10-17). This closes the isolated SVG/border native gate: **user-reported D217 F6 PASS**, previous red error not re-raised. This isn't independent native video of every animation nor integration into live game. Next D218 original towering Guide gallery: `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`.

## D217 SVG death-cel border hotfix (history) — user-native FAIL, source fix F6 pending

**2026-10-17 user's Godot 4.7.x screenshots:** the D217 F6 gallery loads the exact user-approved D209 forest but raises red `D217 / QA FAIL: D217 проверка атласа: край ячейки 4:4 / край ячейки 4:5`. These are **zero-based row=4 (death), columns=4 and 5 (death frames 5 and 6)**, *not* a Godot parser error or an issue in D209 art. The independent Pillow raster D217 candidate's offline QC did not apply to this **different SVG asset**; do not conflate them.

**Root cause found in GitHub SVG** `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg`: two low chest/rib strokes in last two death cels extended past y=93 alpha-safe 96px tile: `M39,94L54,96` and `M40,93L55,95`, stroke width 2px. At rasterization they touched the bottom cell margin. Fixed **source art**, not QA thresholds: removed ONLY these two superfluous off-screen rib strokes, leaving skeleton, face, hook sickle, separate oil flask, belt lantern, boots and all other cels untouched. Commit **`a8a80f1ba73a148e9f52b63f776779171938a528`**. GitHub source re-fetch/geometry scan: **25 authored `<g>` cell groups**, approximate geometric max Y for affected death cels now 93 and 92.5; none of 25 groups exceed the 2px allowed frame edges by SVG geometric bounds. This **does not equal native Godot F6 PASS**; antialias/rasterizer needs user rerun. Do NOT change `_inspect()` acceptance rules to work around malformed art.

**D216 separate screenshot:** the Lantern Bearer F6 gallery shows its intended character both at 3× and 1× on the D209 forest and displays `АТАКА ЩИТОМ`; no red QA failure is visible. Record **D216 native visual load and shown attack pose confirmed**, but **do not claim all idle/walk/hit/death states individually validated** from this still image.

**HISTORICAL original retest request (completed by user):** `git pull`; F6 **`res://scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn`**. Expect the red border FAIL to disappear and 3×/1× original Oil Acolyte to animate with sickle/flask/lantern. User can then click five state buttons and report any defect or «все ок». Only after this screen result can D217 be marked native PASS. Existing QA-only SVG art does NOT register `oil_acolyte` in production animation loader, doesn't alter `battle.gd`, UnitData or live deck; Act1 still **37/45**, #38 unreleased, frozen `backups/KARAMBA73-2026-10-16` unchanged.


## Exact current gates / evidence

- **D215 Road Sentinel:** user replied «все ок продолжай дальше» after the 5-state native F6 test request; accepted as a user-reported standalone animation/gallery OK, NOT confirmation of a true #38 battle/reward route.
- **D216 Lantern Bearer:** original 25-frame shield+lantern QA atlas, local PNG/WebP producer and Godot F6 gallery are already in GitHub. **A D216 user F6 screenshot is now received**: gallery shows original shield/lantern at 3× and 1×, attack-with-shield pose, no red QA FAIL. Full five-motion feedback not yet received.
- **D217 Oil Acolyte:** third distinct enemy identity, a *light-boned nervous skeletal ritualist* with a visible **separate oil flask, open curved SICKLE (not an axe)** and small hanging belt lamp. No new oil/burning/attack buffs or new unit mechanics are authorized by this purely visual pass.

## TWO separate candidate representations — don't conflate them

1. **Local offline original raster QA illustration** (conversation attached ZIP `Misdeal_D217_Oil_Acolyte_Animation_QA.zip`): original deterministic pixel drawings, per-state pose-authored in `author_oil_acolyte_d217.py`, 576×480 RGBA PNG plus lossless WebP + Base64, 96px/cel, 25 visible **different** poses (idle4 / walk6 / attack6 / hit3 / death6), 5 transparent surplus cels; repeated local Pillow QA returned **0 source-edge contact warnings** after adjusting the sickle from a cleaver-shaped first draft to an open hook and lifting death frames. Local raster PNG SHA-256 `7157281d85c3b77a505b3b5126a990e7f24d1f0fd99f05e83fb82d5b36d7eba1`. Local preview board: `D217_oil_acolyte_animation_contact_sheet.png`. **This WebP/Base64 is NOT the asset committed to GitHub**; don't claim byte matching or native F6 based on this Pillow QC.
2. **Independent Godot-native vector-cel QA source COMMITTED to GitHub:** `res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg`. Standalone, transparent **576×480 SVG** containing precisely 25 separately constructed character-group poses positioned into the same correct *state-per-row* 6×5 96px tile grid. 5 unused cells are intentionally empty; source has no external links/scripts, headers, forest background or UI. Its original SVG geometry was authored in an isolated builder, modeling slender bones, changing two-leg strides, sickle slash, oil vessel and small amber lamp, distinct hit reactions and grounded death. **This is a second candidate/implementation, visually similar in role but NOT pixel-identical to the local Pillow/WebP candidate.** Only GitHub's SVG source structure/25 groups/valid pixel dimensions was statically checked; image decoder, renderer, alpha contacts, frame uniqueness, motion quality and 100% battle readability require Godot native QA.

These art assets are source trials, **not final production animation**. No conversion from rejected D205 sheet, no disguised existing skeleton asset, no runtime `MisdealUnitAnimationLibrary.ROLES` activation or `UnitData` stats change.

## Dedicated F6 gallery

`res://scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn` + `scripts/dev/black_lantern_oil_acolyte_animation_preview.gd` are new. The scene:

- Loads the user-approved original D209 forest background from existing `authored_backdrop.gd`, no art swap.
- Decodes the committed SVG directly with `Image.load_svg_from_buffer(source_svg.to_utf8_buffer())` into a native 576×480 `Image`, generates Godot `SpriteFrames` in **idle4, walk6, attack6, hit3, death6** layout, and runs alpha/25-unique/5-clear/border QC **on the rendered data** before showing the sprites.
- Displays interactive **3×** enlarged and **1×** battle-scale examples, with buttons `ОЖИДАНИЕ / ХОДЬБА / АТАКА / УРОН / СМЕРТЬ`.
- Is independent of real `battle.gd`, normal card routing, encounter damage stats and sprites.
- **Native Godot F6 FAIL screenshot RECEIVED**, showing edge warnings for last two death cels. SVG source corrected (see dated hotfix above); **post-fix F6 NOT RECEIVED**, so do not assert PASS.

## User test after git pull

First complete the existing D216 Bearer F6 if not done:

`res://scenes/dev/black_lantern_bearer_animation_preview.tscn`

Then test D217:

`res://scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn`

Click the five animation buttons and check actual silhouette of the **curved sickle versus a cleaver**, separate carried green oil bottle, small hanging amber lantern, left-facing motion, 2 grounded steps and final prone corpse. If anything does not render, send Godot error screenshot; inspect/fix GitHub directly. These are **two different F6 gates**—don't merge their statuses.

## Future gating

Only after user art approval: decide on the single approved frame source, export final **576×480 RGBA/WebP/Base64** to game asset path (GitHub's editable SVG is QA-only, not a production WebP yet), native F6 replay at exact 1×, then enable selected role in the animation library. Remaining **Extinguished Guide** (unique genuine 2× silhouette) and **Lantern Archer** (clear bow attack) each require 25 original frames and their own user-native gallery. After five characters are genuinely approved, wire #38 to actual scoped combat + reward→table, full-pool 54-case regressions, then release 38/45. The +22% light-rate test was reverted to candidate baseline +16% and must not be reintroduced without grounded combat evidence.

Preserve accepted D200 card art, D209 third-forest original arena, DS2/Fate Spread 12+XIII, D196 storm, released Act1 37/45, and immutable `backups/KARAMBA73-2026-10-16`.
