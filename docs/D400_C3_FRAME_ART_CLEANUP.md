# D400 — Video-led C3 frame-art cleanup, not a new costume pass

**Evidence:** Player's `23-58-12.mp4` recorded 2026-11-05, Windows desktop 1920×1080 with a 1280×720 Godot D398 F6 scene visible. About 11.5s long. Unlike the earlier cropped video, **all three hero pairs and controls are visible**; viewport fitting D399 is working. Clip cycles IDLE, WALK, HIT and DEATH, but it is **not a full F5 combat test** and the full attack sequence is not well documented.

**Art verdict:** Current live D398 figures do have genuinely different C3 artwork. Still, the generated multi-pose board segmentation left obvious duplicate **disconnected cloth/prop fragments** in individual 96×96 frames. The test of 25 distinct non-empty tiles passed, despite ghosts occupying 8–38% of the visible pixels on some tiles. This is not a scene crop or a Godot renderer issue; it is bad input alpha art.

## Scope of targeted D400 retouch

Versioned new alpha/WebP atlases `assets/pixel/units/hero_c3_d400/{knight,ranger,mage}.webp.b64` replace the D398 asset directory in the existing role-limited `MisdealUnitAnimationLibrary`. D398 atlases and their original illustrated composition remain versioned and untouched. The C3 pilot remains enabled with the old v2 automatic fallback if a D400 atlas cannot decode or validate.

Only known broken cells were edited; other poses are bitwise unchanged before re-encoding. The full 576×480, 6 columns × 5 rows, idle4/walk6/attack6/hit3/death6 contract remains. Mask and repaint logic:

- **Knight:** attack row2 cols2–4; death row4 cols1–5. Removed floating secondary disconnected burgundy cape fragments and edge specks. The Knight still wears his ONE approved torn cape; his body and weapon pose remain unchanged.
- **Ranger:** attack row2 col3; death row4 cols4–5. Removed isolated extraneous quiver/cloth pieces; moved the detached hood/head in his final death pose nearer to the illustrated body to avoid a head floating away from the fallen figure. **Olive cloak remains intact**, as accepted in C3.
- **Mage:** attack row2 cols1–3; death row4 cols0–4. Removed disjoint ghost violet fabric/cape pieces and fallen-prop crumbs. Preserved Mage's staff and legitimately detached spell glow in attack cols0/5; **robe/cape remain intact**.

Only substantial detached alpha bodies are removed/relocated; the main full-body C3 illustrated pose stays intact. No fake interpolated new animation poses, no old-v2 recolor restoration, no changes to combat timings, attack damage, AI, DS3, waves or XIII.

## Harder QA

`tests/unit/test_d400_c3_animation_art_integrity.gd` flood-fills the 8-connected actor mask in **each known defective cell** and requires at least 95.5% of visible alpha pixels to remain with the largest full-body component. It also verifies each image differs from archived D398, remains at least 65% body-visible vs source, and maintains all five playable animation state counts. Detached Mage attack spell glows are exempt because they are intentional independent VFX. Existing D398 tests still check 25 distinct nonempty cels / five alpha-clear spare slots and real BattleUnit role selection.

This is an **objective alpha/silhouette hygiene pass**, not evidence that all 75 image-derived poses are artistically excellent. Later true illustrated motion revision is still needed for footfall/perspective, bow hand/staff grip, dynamic cloak pose continuity. Player should inspect at F6 and actual F5 fighting before calling C3 final.

## Local review after green CI

1. `git -c gc.auto=0 pull --ff-only origin main`
2. F6 `res://scenes/dev/d398_c3_hero_animation_preview.tscn`, click all five states and AUTO.
3. Inspect Knight attack/cape and death, Ranger final death connected to body, Mage attack fabric and grounded death. Right column now shows D400 pilot; left stays archived v2.
4. Run actual F5 game with at least one playable hero; only a live fight proves combat animation hookup.

**Rollback:** `C3_HERO_PILOT_DIR` may point back to `res://assets/pixel/units/hero_c3_d398/` to compare previous C3, or `C3_HERO_PILOT_ENABLED := false` to fall back to unchanged v2 animation art. This must be done in a GitHub commit, never by asking the player to edit source locally.
