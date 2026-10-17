# D228 — Road Sentinel ornament/forge art pass: native-pixel QA, F6 pending

Date: 2026-10-17. Status: **NEW 25-POSE QA ATLAS AND GODOT SCENE COMMITTED; NOT USER-NATIVE APPROVED AND NOT FINAL STYLE-B ART**. Live Act1 **37/45**, card #38 still QA-only.

## Intent

User explicitly asked to follow the original planned art-production sequence («давай идти как ты задумывал»), then asked to **continue D228** rather than starting other roles. The goal is improved Road Sentinel art (user-approved D211 armored long **SPEAR** A silhouette, D220 shared Style B, D221 rich plated-and-hooded illustration), with no regression to animation/real battle. D227 had correct 25 poses/96px technical layout but still appeared overly flat at x1 compared with accepted D221 image.

## Actual changes

Painted new *native* 96px artwork in a standalone versioned reproducible Python/Pillow artist, retaining D227's user-established 4/6/6/3/6 original idle/walk/thrust/hit/death poses and grounded soles. This is **not** a crop from a concept image, old texture upscale, fake 25-frame infographic or shader-style recolor.

- Entire torso/armor geometry redrawn: uneven dark forged chest planes, overlapping shoulder guards, brass-rimmed medallion and split faulds, restrained rust scratches.
- Mantle is now a multilayer jagged burgundy silhouette with real negative-space tips and dark underlining rather than simple filled wedge.
- Spear shaft given wrapped grip/ferrules and narrow genuine metal **SPEAR** blade with a short frayed ribbon below the point; **not** axe or halberd.
- Suspended lantern redrawn with triangular Gothic crown, separate cage uprights, small warm flame clusters and tapered base (not an orange flat rectangle). Its movement follows the real spear pose.
- Existing skull, forearm and boots remain true pose geometry, avoiding disconnected decorative layers. Stance and genuine thrust/fall animation motions remain from D227.
- The new atlas differs from D227 in **29,154 RGBA pixels** in a lossless decoded 576×480 comparison; **25 distinct painted frames**, exactly **five unused alpha-empty cells**, **no transparent margin warnings**. These metrics establish actual altered art and technical packing only, **not guaranteed artistic beauty, seamless gait, or final concept match**.

## Committed files

- `tools/art/author_road_sentinel_d228.py` — versioned self-contained deterministic Pillow artist for 25 cels.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d228_art_candidate.webp.b64` — lossless transparent 576×480 6×5 96px engine candidate. Decoded WebP SHA-256: **`7ef8f0833a17d06812f7f472b8946f2bdcadc49dd3c0caf28f91adc750663322`**.
- `docs/qa/D228_ROAD_SENTINEL_ART_QC.json` — per-state alpha bounds, 25 unique, 5 clear, 0 border failures; source/asset byte transport verified by GitHub re-fetch.
- `scripts/dev/black_lantern_sentinel_d228_art_preview.gd` and `scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` — original D209 approved moonlit forest, x3 enlarged + x1 combat-size animated sprites, `← ВЛЕВО` / `ВПРАВО →` flipping both views, five state buttons, 25-cel strict alpha/duplicate verification.
- Optional conversation-only views `D228_D227_zoom_comparison.png` and `D228_sentinel_animation_contact_sheet.png`; bundled `Misdeal_D228_Sentinel_Art_QA.zip`. Do not claim image files are native production assets; GitHub contains the real alpha atlas and reproducible painter.

## Review status & QA

**Native Godot F6 of new D228 scene NOT RUN YET by user.** Need user to `git pull`, F6 **`res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn`** and inspect attack (spear tip and ribbon), walk sole contact, chest/pauldron clarity at x1, lantern hanging continuity and grounded death in both directions. If a parser/validator warning occurs, inspect the actual new GitHub code/asset and fix directly. **Godot runtime is unavailable here**, so do not claim actual engine verification.

**Important art boundary:** D228 is more shaped/detailed than D227, but remains a 96px pixel art **QA candidate**, still not a 1:1 rendition of the richly rendered D221 approved illustration. Do not lower the user's agreed visual bar or call it "final" just because it has passed offline QC. If full fidelity remains inadequate at x1, consider a separately approved richer pixel asset pipeline rather than repeating tiny incremental noise passes. D227 and all older preview candidates kept intact for comparison. #38 production sprite library / Battle / UnitData / RunState / moving-light mechanics **unchanged**.

Retain D200 chosen card illustration, D209 accepted forest, D196 approved storm, DS2, 12 Fate Spread + sealed XIII, and frozen `backups/KARAMBA73-2026-10-16` branch unchanged.
