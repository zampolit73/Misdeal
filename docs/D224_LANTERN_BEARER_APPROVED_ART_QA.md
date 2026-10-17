# D224 — Approved Style-B Lantern Bearer: original art preserved + 25-cel Godot QA gallery

Date: 2026-10-17. **User approved the new 25-pose image with «подходит».** This accepts the artistic design/poses shown, not engine-native feet/animation QA or release of #38. Live Act1 remains **37/45**; #38 `black_lantern_road` is QA-only.

## User-approved source and strict provenance

User had already approved D223 Lantern Bearer design (broad wooden shield in one hand, separate short-handled heavy lantern in the OTHER; no pole), and now replied **«подходит»** to the new 5-row illustrated animation sheet `спрайт_лист_скелета_рыцаря_с_фонарём.png`.

- **Exact user-selected PNG source:** **1374×1145 RGBA**, source SHA-256 **`4fb9e0ce2ebfcb608b35d948c084cb6cc5c41d43afe8310597bdc23959ad325f`**.
- **Persistent GitHub source image:** `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d224_approved_original_lossless.webp.b64` — same original 1374×1145 RGBA *visible pixels + alpha*, stored as **lossless WebP/Base64**, decoded WebP SHA-256 **`53da04d58b10c87a9229dfa1235b11aa64b5ccd9376302cc6341fb5866f82e0d`**. Decoded WebP has **identical alpha and identical RGB for all pixels with nonzero alpha** compared with original PNG; only hidden RGB values in fully transparent pixels are normalized by WebP encoding. Keep PNG source SHA for provenance; do not claim PNG binary bytes are identical to the WebP file.
- A separate, **derived engine QA export** `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d224_approved_repacked_candidate.webp.b64` is a **576×480, 6×5×96px** cropped/nearest-neighbor repack with 25 visible/different cels, five clear unused cells and no 2px-border violations. Its decoded WebP SHA-256 is **`816efbc6416a65408b5f3aa121b8a3985a3ce67dcd26a5ce17af992a98c15b87`**; actual WebP length **266,934 bytes**. Its Base64 text was fetched back from GitHub and byte-for-byte matched the file validated locally.
- Deterministic author/repack source `tools/art/inspect_and_repack_lantern_bearer_d224.py` reads **the preserved original lossless WebP/Base64 from GitHub**, produces 576×480 transparent PNG, WebP, Base64, a checkerboard contact sheet and JSON report. Reproduced locally from the same lossless source and got the EXACT SAME output WebP SHA as above; no external Godot Python runtime dependency.
- Full machine-readable per-frame cut coordinates, crop bounds and quality flags: `docs/qa/D224_LANTERN_BEARER_ART_QC.json`. Source animation state layout is **idle4 / walk6 / attack6 / hit3 / death6**, five empty cells in 6×5 Godot row packing, consistent with D213 and `unit_animation_library.gd`.

## Important source issue — technical PASS is NOT final art QA

The original generated RGBA canvas **was not a valid 96px engine atlas** and portions of some neighboring sprites overlap nominal 229px canvas-cell cuts. We selected row/column boundaries by minimizing occupied alpha, fit each recovered pose to a 96px cel with nearest-neighbor resampling, and aligned the lowest pixels near sole y≈92. A few source seams **still crossed actual artwork** (e.g. third animation row between frames 3/4 had at least 20 opaque pixels at the best global vertical split). This segmentation necessarily risks truncating stray parts of cloak/lantern/shield even though the newly repacked atlas has zero *external* margin violations. Nearest-neighbor scaling from ~229px source positions also changes apparent pixel density. Neither 25 unique image hashes nor absence of edge contact establishes that animation is visually faithful or free of foot slide.

The checked **contact sheet** `D224_approved_sprite_grid_qa.png` (conversation artifact), all source/QA files and the original PNG are also bundled in `Misdeal_D224_Lantern_Bearer_Approved_Art_QA.zip` for visual/offline review. This ZIP is available in the ongoing conversation, while the **two exact game-reference WebP/B64 files and reproducible source are in GitHub** for new chats.

## Native Godot F6 stage — source committed / Godot PASS PENDING

New isolated scene:

`res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`

Uses `scripts/dev/black_lantern_bearer_d224_art_preview.gd` adapted from the user-tested D216 animation QA scene, and reuses the **EXACT approved D209 forest** via `authored_backdrop.gd`. It loads **only D224's repacked candidate**, checks all 30 cels using existing strict alpha-edge/uniqueness checks and displays animated `idle / walk / attack / hit / death` at **3× inspection scale** and **1× game display scale**.

**NEXT USER ACTION:** `git pull`; F6 the scene above. Test all five buttons, especially left-facing shield bash, separate handheld lantern staying visible, feet actually planting vs sliding in walk, and six-stage corpse fall not clipping or abruptly changing shape. Verify the character remains visually comparable to the approved style-B drawing at 1×; if image separation introduced damage, fix source/repack boundaries or redraw individual frames, NOT the F6 validator tolerances. Send screenshot/error or «всё ок» together with any observed defect.

**Do NOT register as live `MisdealUnitAnimationLibrary` sprite yet**: D224 user's «подходит» approves the illustrated source style/poses only; the repacked 96px result needs native/visual QA and may need manual pixel correction. Do not make D216 QA sprite automatically become production or replace active battles prematurely. No UnitData stats, `battle.gd`, ordinary `RunState.ACT1_CARD_IDS`, other 4 original roles or game mechanics were changed.

After the Bearer F6 result: polish the approved D221 Road Sentinel art into actual 25-frame pixels (current D215 simpler QA sprite remains temporary), then remaining Acolyte, Guide and Archer final B-style art, review all five together on D209, and only then wire #38 real five-unit Battle/light → Reward → Table and perform release smoke to reach 38/45.

Preserve D196 storm/accepted D200 third card image/D209 exact forest/DS2/Fate Spread 12+sealed XIII/unchanged checkpoint `backups/KARAMBA73-2026-10-16`.
