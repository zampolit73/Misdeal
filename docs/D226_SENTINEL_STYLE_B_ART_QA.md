# D226 — Road Sentinel: B-palette native 25-cel art revision, isolated Godot QA

Date: 2026-10-17. **New 25-cel native-size pixel-art QA candidate committed, needs user F6/art review. NOT final painted production art.** Act1 live remains **37/45**, card #38 QA-only; no current-production fight altered.

## Evidence and what changed

User replied **«все ок. давай дальше»** after D225 direction-toggle Godot F6 request. Treat as **user-reported D225 dual-facing gallery OK**, not proof of complete 5-state final-art QC or production unit integration.

Next work selected the already approved **D211 armored Sentinel A silhouette** + **D220 collective art style B** + **D221 user-approved detailed spear Sentinel appearance**, which are STILL only final-look art references; existing D215 hand-authored frame set is simplified QA media, not approved production art. A new image generator attempt mistakenly depicted **Oil Acolyte** (not Sentinel) with rendered HUD, so was **rejected**; that generated artwork is not imported or declared a production sprite.

Instead D226 retains D215's genuinely authored per-pose bone joint/movement design but reconstructs new art **at native 96×96 pixels**, adding **weathered oxblood/russet torn mantle, deeper hood, copper-rust iron edges, more armor rivets and layered iron/plated details** across each real moving pose. **Real long pointed SPEAR + short-hung amber lantern** preserved, never staff/axe. **No fake frame interpolation or duplicated cels**, no external bitmap overlay from background-composited D221 reference, no blur-resize. This is a **bounded intermediate style fidelity step**, *not* falsely described as fully matched to the much more detailed approved D221 illustration.

## GitHub assets and sources actually committed

- `tools/art/author_road_sentinel_d226.py`: reproducible standalone native 96px Pillow artist, no external fonts/PNGs downloaded, keeps D215 hand-authored skeleton movement and strengthens per-frame art;
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d226_art_candidate.webp.b64`: original candidate transparent lossless WebP/Base64, **576×480 RGBA, 6×5 cells** with correct Godot row state packing (idle4, walk6, attack6, hit3, death6; 5 empty);
- `docs/qa/D226_ROAD_SENTINEL_ART_QC.json`: 25 distinct frame hashes, 25 frames with alpha, 5 unused alpha-clear cells, **ZERO 2px-edge border warnings**. WebP SHA-256: `3df19032d40d2aff0c8873f7d5857ca4aa916bffa670a09e28dfb1f681d8600e`, original PNG SHA-256 `109a448c1c3645af75c07f8a53df76302c606720f128e10772487733c380e069`. Generated local contact sheet `D226_sentinel_animation_contact_sheet.png` and `Misdeal_D226_Sentinel_Art_QA.zip` are conversation downloads.
- `scripts/dev/black_lantern_sentinel_d226_art_preview.gd` / `scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`: separate QA-only F6 gallery on original **D209 approved moonlit forest**, enlarged 3× and exact 1× sprite views, five animation buttons, two `← ВЛЕВО`/`ВПРАВО →` controls that flip BOTH views. New art was drawn enemy-left, so default `← ВЛЕВО` has **NO flip**, `ВПРАВО →` uses `flip_h=true`. Unaltered nearest-neighbor display, pixel art authored at exactly 96px so no D224 adaptive source-grid resampling. Strict in-engine cell/duplicate/border validator remains unchanged.

## What is still NOT approved

New user-native D226 F6 has **NOT** run. Even a successful F6 is a **functional/motion QA result**, not sufficient to claim final painted art matches D221's very detailed spear Sentinel illustration. Particular things to check: top spear tip never clips, weapon clearly THRUSTS during attack, cloak is legible and does not float, feet contact floor during walk/turnaround, chest armor and amber lantern distinct at 1×, grounded 6-phase death, proper left/right flip.

**User next:** `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`; compare to D215 old QA/approved D221 illustration. Send screenshot and indicate whether fidelity is sufficiently close or more art detailing is required. Do not silently change user's already approved character appearance or swap in previous raster simply because it passes static QA.

No `MisdealUnitAnimationLibrary`, `BattleUnit`, `battle.gd`, UnitData, global light controller, D209 forest, original D200 card picture or live `RunState` changed. Production 5-skeleton cohesive art and actual #38 Battle→Reward→Table + full-pool release QA remain. Preserve frozen `backups/KARAMBA73-2026-10-16`.

## D226 screenshot review (2026-10-17) — native gallery loads, final-art quality NOT accepted

User supplied a **native Godot screenshot** of `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`, showing the exact selected D209 moonlit forest, enlarged x3 and normal x1 Road Sentinel views, both with readable spear/lantern, state caption **`ХОДЬБА · ← ВЛЕВО`**, and visible left/right + five-state buttons. **No red QA error is on screen.** This is concrete native **gallery loading and sampled leftward walk-frame display**, not a full native suite PASS: screenshot cannot establish six-frame walking quality, full spear thrust, death, or click result for right-facing. The user has **not** explicitly said «утверждаю» or «всё ок» for artistic polish of D226.

**Visible art fidelity gap vs already-approved D221 detailed Style-B illustration:** exaggerated/simple pale rib/skull geometry, sparse flat metal armor plates, overly square amber lantern, little rich corroded layering, little detail at x1; cloak appears simplified, so overall silhouette still closer to a technical test sprite than a fully finished illustrated undead guard. Spear remains correctly a **long pointed spear** rather than an axe. The accepted D221 appearance **must not be silently lowered** to the D226 QA appearance. Explicit assistant visual assessment: **D226 load PASS; final-art review BLOCKED pending better native-pixel art**. Don't claim that screenshot alone verified all movement states or game integration.

**Next concrete implementation direction D227:** inspect the source-painted D226 joint/pose rig and enhance it at the real 96px cel level, prioritizing skeleton/shoulder armor volume, physically layered rusted iron pauldron/chest texture, richer burgundy fabric clusters, more detailed spear head, small suspended lantern with iron cage and convincing flame clusters, and foot grounding/readability in x1. Avoid adding meaningless pixel noise or shrinking skeleton to fit the weapon. Preserve all 25 per-state genuine poses, 6×5 alpha contract, and the chosen **A spear silhouette + B rich style**. Native preview before replacing any production role; maintain current D226 staging assets for side-by-side comparison. The user has not yet explicitly requested a further change or approved final art on this screenshot; do not claim D227 art creation happened. Current Act1 **37/45**; #38 QA-only; KARAMBA73 preserved.

