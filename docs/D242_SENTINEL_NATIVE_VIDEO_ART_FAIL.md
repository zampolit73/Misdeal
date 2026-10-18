# D242 — User's native D241 motion recording: ART FAIL, technical scene PASS

Date: **2026-10-18**, reference Loom: https://www.loom.com/share/c988401b2fff4fecb6de0017da607c0c, titled `Продолжение проверки Стража - Google Chrome - 18 October 2026`, 16.6s. User additionally uploaded a ~17s screen capture MP4; its filename refers to a different Chrome tab, but its actual content **shows Godot's D241 scene** after the first seconds. No user-private video was committed to GitHub. This report is based on inspecting the **visual frames**, not Loom's irrelevant automatic Russian transcript.

## Actually evidenced, with time ranges in the provided screen capture

- **~4–5 s:** embedded `Misdeal (DEBUG)` is visibly running `D241 / СТРАЖ ДОРОГИ · НОВЫЕ ЦЕЛЬНЫЕ ФИГУРЫ / 25 КАДРОВ / QA` on the user-selected D209 forest. ×3 on the left, ×1 on the right. Scene/assets load. A previous pose finishes.
- **~5–10.5 s, WALK:** full-body painted metal greaves are now stylistically consistent with armor (improvement over D239). Nevertheless upper body, weight and illustrated cloth scarcely counter-rotate with the steps. Leg poses pop/shift rather than express a robust support/swing and center-of-mass path. Visual acceptance **FAIL**.
- **~11–13.4 s, ATTACK:** label reads `УКОЛ КОПЬЁМ`, but long spear stays mostly upright/diagonal while body and source frames shuffle underneath. No clear anticipation → hand-driven near-horizontal spear extension/contact → planted recovery silhouette. **FAIL**, not an art-complete thrust.
- **~13.4–16.5 s, DEATH:** figure rapidly folds/rotates into an almost flat reddish ground smear. Its collapse lacks a readable wounded recoil, knees dropping, braced fall and retained skeletal/armor identity on the ground. Late poses resemble a compressed rotated illustration. **FAIL**.
- **NOT visually verified in this footage:** both facing directions, complete `HIT` animation and all four `IDLE` frames. Do not fabricate PASS or FAIL for those specific test cases. No combat Battle→Reward→Table or 3v5 fight was shown.

## Root cause confirmed against current GitHub art authoring

`tools/art/author_road_sentinel_d241_wholebody25.py`: walk uses six D235 original illustrated full bodies but mainly substitutes whole walk portraits with limited weight adjustment; ATTACK largely rotates/foreshortens a D234 spear layer on top of already-painted D235 bodies rather than painting connected leading weapon-arm poses; DEATH uses `ground_rotate()` with angle and final-frame resizes of the full picture. Those techniques can pass 25 unique-alpha-hash and border static checks while failing basic believable character acting. This does **not** warrant adjustments to FPS, Godot's `AnimatedSprite2D`, sprite import filtering or arbitrary new geometric boots.

## Binding D242 art gate / action

**Mark D241 ART REJECTED, not pending.** D239 was already explicitly user-rejected; D241 has now separately failed real motion review. Keep both historical QA source files for rollback and reproducibility. **Neither is approved for `scripts/battle/unit_animation_library.gd`, actual encounter integration or 38/45 release.**

Follow already accepted D220/D221/D234/D235 style B spear-and-free-hand-held-lantern figure but make a **new complete 25-frame *individually posed full-character* 96px atlas** using the release-proven direction seen in `threadbare_puppeteer`, `bone_marionette`, `drowned_ferryman` sheets. Do not use source-photo body rotation or arbitrary boot overlays as final motion.

Frame-level acting requirements for the next ONE complete batch:
- `idle4`: planted armor, subtle material/cape/lantern secondary motion, continuous wrist grip.
- `walk6`: physically coherent linked hips/knees/greaves/boots, alternating real support vs swing, readable grounded soles, cloth/torso weight transfer, smooth frame5→0 loop, character maintains native x1 readability.
- `attack6`: specific long-spear forward stab: guard/windup, weight transfer/plant, supported arm extension, visibly forward thrust at impact, recoil, return; shaft held and lantern attached to other wrist.
- `hit3`: distinct readable recoil, compression, brace; does not borrow still idle poses.
- `death6`: damage stagger → knees buckling → falling weight → ground impact → distinctive armor-and-cloak corpse on the floor; no shrinking, rotating a full standing portrait, or disappearing into generic cloth smear.
- `25 real poses / 5 transparent unused` layout and all existing technical Godot checks stay binding. **Static checks are necessary but not artistic QA.**

No per-state user approvals. Internal rejection/repaint iterations before one coherent new F6 review. Do not promise video-native PASS without evidence. No release until all five unique skeletal enemies and encounter route/balance QA pass.

## Preserved boundaries

Godot 4.7.x GDScript. `RunState.ACT1_CARD_IDS` **37/45** stays. #38 `black_lantern_road` QA-only. The user-approved D200 card art, D209 forest, D196 storm, DS2, Fate Spread, old successful units and frozen `backups/KARAMBA73-2026-10-16` remain unchanged.

**Latest handoff:** D242 supersedes D241's *pending art verdict* and supersedes prior requests that the user retest rejected D241. Current correct next work is **original full-figure redraw for Sentinel**, not a D241 source-matte/transform micro-patch.