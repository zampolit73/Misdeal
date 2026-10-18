# D255 — Three complete original-style character sheet candidates for card #38

Date: 2026-10-19. User message **«отлично»** followed three newly generated Style B transparent sprite sheets (Guide, Oil Acolyte, Lantern Archer), in response to request to finish their art as a batch. Interpret as **visual direction accepted-to-proceed**, not demonstrated in-game animation approval.

## Locked character identities

1. `extinguished_guide`: distinctly tall skeletal hooded leader with torn oxblood mantle, **rigid shoulder yoke with THREE separate hanging amber lamps**. Do not turn into shield-bearer.
2. `oil_acolyte`: skeletal oil-carrier with heavy backpack fluid tank, separate carried chain burner and brown cloak. No stolen Guide 3-lamp silhouette.
3. `lantern_archer`: skeletal bowman with quiver, cloth-wrapped bow/banner and carried amber hip lantern. Actual drawn ranged release posture; no generic skeleton archery replacement.

Existing user-tested `road_sentinel` (D244) and `lantern_bearer` (D224) are preserved unchanged, with rich art already staged in the animation library.

## Source, deterministic packaging and QA outputs

Three original 1374×1145 **transparent** (not matte-to-be-removed) illustration sheets are stored in Git as lossless WebP/Base64 `assets/pixel/units/black_lantern_road_qa/{role}_d255_approved_original.webp.b64`; visible content is preserved in the lossless originals. Each shows all 25 poses: `idle4/walk6/attack6/hit3/death6`. `tools/art/author_black_lantern_d255.py` packs each *original illustrated pose*, without interpolating synthetic poses, body rotation or per-frame whole-figure rescale: fixed pixel transform from nominal **229×229** source cells to 92×92 content inside 96×96 (2px margins), six columns × five rows. Finished QA-only candidates: `{role}_d255_rich25_qa.webp.b64`.

Offline QC `docs/qa/D255_THREE_RICH25_QC.json`: all three **576×480** RGBA lossless WebP decode; **75/75 distinct authored frames**, 15 alpha-clear spare cells, occupied frames not empty, guaranteed 2px inset; visible pixel round-trip verified (WebP may canonicalize fully transparent RGB). Structural frame contract **PASS**.

## Internal art issue — MUST repair before releasing

Generated sheet layout is six columns × five rows, but some illustrated effects/swinging chain props extend across nominal 229px panel boundaries, causing **visible tips/lamps/cape edges to clip** when 229px columns are separated. Source-edge (>48 alpha) heuristic reports **12 Guide**, **13 Acolyte** and **9 Archer** frame warnings, mostly during walk/attack/death. Internal nearest-neighbor contact previews confirm clipped lanterns on Guide ATTACK and Acolyte flame/carry chains, and smaller Archer bow/cape edge cutoff. **Do not misrepresent the exact 96px technical/padding/hash PASS as final beautiful production art**. Individual props may need localized source composition/hand-corrected redraws; keep body size fixed, three-lamp yoke linkage correct, avoid separated hanging objects.

Godot native preview has not run: `res://scenes/dev/black_lantern_d255_three_character_art_preview.tscn` shows all 3 original roles on approved D209 forest at ×2.1 and actual ×1, all five animations and both facings. This is an *internal diagnostic*, not a player micro-approval request until cuts repaired. Uses existing D249 strict 25-cel image loading contract and does NOT activate unfinished roles globally.

## Production boundary

No changes to `MisdealUnitAnimationLibrary`, real Battle, `RunState.ACT1_CARD_IDS`, `UnitData`, D249/D254 existing QA, D206/D253 light, full balance, Reward/Table or approved visuals. Remain **37/45**; #38 is still in QA. Next:
- internally correct at least 34 source-boundary failures and look at each action at true ×1; one complete three-character F6 when actually repaired;
- then stage the 3 corrected rich original atlases as **five** distinct canonical roles and inspect real 3v5, party-size/balance matrix and Battle→Reward→Table;
- release #38 only after real native and art acceptance. No return to per-state user approval, and no generic substitute frames.

Frozen KARAMBA73 unchanged; detailed source files + QA contact previews produced in authoring session, with animation sources tracked in Git.
