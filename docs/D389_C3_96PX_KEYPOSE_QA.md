# D389 — C3 96px hero key-pose QA

Date: 2026-11-04
Status: three 96×96 RGBA **concept-derived, pixel-processed static candidates** staged for isolated F6 review. Not a 25-frame animation pack and not enabled in live Battle.

## What is staged

- `assets/pixel/units/hero_c3_keyposes_qa/knight_96.webp.b64` — Knight: worn iron, burgundy cloth, sword and shield.
- `assets/pixel/units/hero_c3_keyposes_qa/ranger_96.webp.b64` — Ranger: muted olive hood/cloak, quiver and bow.
- `assets/pixel/units/hero_c3_keyposes_qa/mage_96.webp.b64` — male Mage: ash-violet robe, silver hair/beard and cold-blue staff flame.

The candidates were derived from the approved C3 full-body concept illustration, isolated from its dark background, cropped to 96×96 cells, converted to hard alpha, palette-reduced without dithering, and given small prop/contact cleanup. They are **not fully hand-pixel-authored**; this is a controlled key-pose lookdev stage to test whether the chosen concept survives actual game scale. The previous rejected 48px cutouts remain untouched and are not used here.

## Preview

- Scene: `res://scenes/dev/d389_hero_c3_96px_preview.tscn`
- Script: `scripts/dev/d389_hero_c3_96px_preview.gd`
- Test: `tests/unit/test_d389_hero_c3_96px_keyposes.gd`

The scene shows each current BattleUnit on the left and its new 96px static C3 candidate on the right over the approved authored Firing Square backdrop. The current unit and candidate are grounded to the same floor-contact line; candidates use nearest-neighbor sampling. No production BattleUnit, animation library, stats, hitboxes, wave behavior, or live sprite path is changed.

## QA gate

1. `git pull` and open `res://scenes/dev/d389_hero_c3_96px_preview.tscn` with F6 at 1280×720.
2. Compare each current/C3 pair at native display scale. Check Knight shield and sword separation, both boots; Ranger bow/string, quiver, both boots; male Mage face, staff grip/flame, and visible footwear under the robe.
3. Reject any role whose anatomy or prop is not immediately readable at normal arena distance. Do not compensate with glow, a pedestal, a larger character, or UI overlays.
4. Native Godot GUT/CI checks file decode, exact 96×96 dimensions, transparent background, silhouette occupancy, per-role uniqueness, same-floor alignment and preview-only isolation. These checks do not certify artistic quality.
5. Only after the key-pose direction is acceptable should the full 25 distinct poses per role be authored: idle4 / walk6 / attack6 / hit3 / death6, packed 6×5 at 96px (576×480). No frame duplication, rotations of a static sprite, or storyboard slicing.

## Scope / rollback

All three files live under the QA-only `hero_c3_keyposes_qa` directory. Removing that directory, the D389 preview scene/script/test and this document fully reverts the stage. Existing Knight/Ranger/Mage art and the D388 preview are preserved.