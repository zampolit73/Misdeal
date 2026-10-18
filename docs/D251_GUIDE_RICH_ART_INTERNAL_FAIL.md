# D251 — Rich Guide candidate and D249 presentation follow-up (INTERNAL ART FAIL)

Date: 2026-10-19. The last user-facing native evidence is D250 (D249 real MARШ 3v5 first run PASS only). Card #38 stays unreleased.

## New artwork — substantial silhouette progress, NOT production acceptance

A newly illustrated wide 1536×1024 RGBA concept restores the unique tall **Extinguished Guide** identity: skeletal face and worn maroon cape, **rigid horizontal shoulder-borne iron yoke with exactly three separately chained amber lanterns** in primary idle/walk poses. This is not another shield-bearing Bearer. It contains labeled positions and opaque brown background, not Godot art.

Saved the compressed reproducible source in `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d251_rich_source.webp.b64` (source WEBP SHA256 `a5f015294645774cd34872ceb5f97fa74964741083d313c39c7426183e7c2b17`, NOT byte-identical to original generated PNG).

Offline author `tools/art/author_extinguished_guide_d251.py` manually identifies and matts 25 original illustrated poses from labeled concept rows (original generator incorrectly drew seven instead of six in some rows). Uses offline Pillow/NumPy/OpenCV, never required in Godot. Exports `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d251_rich25_qa.webp.b64` as lossless 576×480 6×5 sprite atlas, 25 distinct populated cells (4/6/6/3/6), five completely alpha-clear cells, 2px margins; QC report `docs/qa/D251_GUIDE_RICH25_EXTRACTION_QC.json`. Verified actual decoded WebP alpha and all *visible* RGB pixels. Latest candidate WebP SHA256 `eb092167b27eabea347b1080b361482819fe52c1a703261dbb50d593c3ed450a`.

**Structural extraction PASS; internal art review FAIL**. At x2 inspection, cutout fringes/halo and ragged cloth edges remain from background removal. Long iron chains were compressed in the x dimension in ATTACK while torso is kept near idle scale; moving lamps become cramped and apparent weapon motion loses convincing weight. Some wide death/hit poses are physically much smaller than idle due 96px constraint. Generated source had extra illustrated positions; a chosen subset of 25 is technically unique, but playback consistency and prop linkage are NOT established from stills. Do not misrepresent these as 25 separately approved production-quality hand-painted frames.

**Never** register D251 in `MisdealUnitAnimationLibrary` or change D249 battle's D218 Guide sprite by default. Do not request F6 of this internally rejected candidate. Next full-quality art pass should preserve this silhouette as *reference* but repaint 25 individual clean transparent poses at game scale, body/chain proportions consistent, no labels/background, followed by one consolidated native F6. D238 one-full-batch rule remains intact.

## D249 isolated QA readability improvements

User D250 video showed name and health overlay collision with the massive Guide. QA scene `res://scenes/dev/black_lantern_d249_five_enemy_combat_qa.tscn` now defaults enemy **name labels off** (does NOT hide actor models or HP bars; hero name labels untouched), with explicit `ИМЕНА ВЫКЛ / ВКЛ` button to restore them. The authored formation switch is now labeled `ПЕРЕКРЁСТОК →` or `← МАРШ` and restarts exactly the alternative encounter positions. Full `BattleUnit`, light controller, enemy stats and combat AI remain unchanged. This is QA-only UI, NOT a production HUD redesign and NOT evidence the second formation ran in Godot; native retest remains pending.

Frozen KARAMBA73 untouched. 37/45 released, #38 pending three art roles, true balance and normal Battle→Reward→Table.

## Later D252 video (2026-10-19)

New video of D249 with D251's UI controls **passes both native authored 3v5 deployments**; it does not run or approve the D251 Guide art (D218 still displayed). See `docs/D252_D251_NATIVE_BOTH_FORMATIONS_QA.md`.
