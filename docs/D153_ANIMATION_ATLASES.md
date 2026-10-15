# D153 — Original Bone Puppeteer and Bone Marionette animation atlases

Date: 2026-10-15  
Status: **files in GitHub `main`, raster QA passed; user Godot 4.7.x F6 animation QA PENDING**.

## Deliverables

| Role | Path | Encoded chars | Decoded WebP bytes | SHA-256 (binary WebP) |
| --- | --- | ---: | ---: | --- |
| Bone Puppeteer | `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` | 4672 | 3504 | `b3d13f1eea6f84eb43d6a3d14308b49f7cf0394beebe29bda72dfa4a4c8d0989` |
| Bone Marionette | `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` | 4240 | 3178 | `dcd1c3079917d1171b7026a9fa08aefd71e7121852d47fc136d42e0bef50e7eb` |

These are **actual unique, transparent, hand-built pixel-art raster frames**, not upscaled card art, placeholders, other enemy portraits or mood boards. Poses are drawn independently from movable bone/cloth/thread parts at 48×48 pixel-art resolution, nearest-neighbor doubled per cell to 96×96, assembled in a six-column five-row grid, saved as WebP **lossless with preserved alpha**, encoded as plain Base64. Source looks right; `BattleUnit` will handle combat-side opponent flip as already implemented.

**Rows:** idle (4; moving heads, cloth and strings), walk (6; articulated legs, counter-swinging arms and hem), attack (6; master thrust/thread-whip versus puppet claw slash), hit (3; recoil and impact), death (6; leaning/collapse into disconnected bone, fabric and broken rig). Only 25 populated cells; unused grid cells are transparent.

**Art silhouettes:** crowned necromantic skeletal puppeteer with dark steel/ink drapery, pale ribcage, brass crossbar and green glowing cursed strings; separate smaller skeletal marionette with visible leg bones/feet, hanging shoulder cords, iron joints and ragged wine-red theatre garment. All original to D153, no wooden dolls. Avoid muddy backgrounds or modern neon.

## Independent decoded-file checks — PASSED

- Decoded WebP pixel dimensions **576×480** and alpha-bearing RGBA for both roles.
- Exactly **25 nonempty, hash-distinct** populated 96×96 cells per role (idle4/walk6/attack6/hit3/death6); no adjacent copied frames.
- All other cells completely transparent; the **outer 2px of all 25 populated cells transparent** (no cut-off feet, arms, crowns or effects); visible silhouettes well inside cells.
- Pixel bounds and final frame content reviewed as raster sheets; both have source-right facing.
- The files were refetched from `main`; a fresh local binary SHA-256 of the original WebP source matches a separately computed SHA-256 of the remotely refetched decoded GitHub content for **both** files exactly.
- `MisdealUnitAnimationLibrary` already enforces size, per-cell alpha, padding and uniqueness and has **no fallback** to another skeleton for these D153 roles.
- **Native Godot scene F6 not yet run; art polish/animation flow not yet approved by user.** These source checks cannot certify Godot presentation.

## Only next native test

1. `git pull`.
2. Open `res://scenes/dev/threadbare_theatre_art_preview.tscn` and run current scene **F6**.
3. Gallery switches idle → walk → attack → hit → death every two seconds. Inspect both independently for full feet, distinct animated poses, source-right orientation, readable silhouettes, visible master thread whip, puppet claws, and lack of blank-frame flicker. Send screenshot or feedback.

**After approval only:** new theatre arena, D153-scoped actual battle tether lifecycle, fight/reward/table QA, 54-case balance matrix and candidate live 36/45. The crypt arena is temporary; no D153 production combat routing or pool activation was added as part of this asset pass.

