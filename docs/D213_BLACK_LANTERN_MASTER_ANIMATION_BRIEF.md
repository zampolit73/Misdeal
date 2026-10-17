# D213 — Black Lantern Road / master animation production brief (canonical corrected edition)

Date: 2026-10-17. Status: **ART DIRECTION / ENGINE CONTRACT LOCKED, PRODUCTION ATLASES NOT YET MADE**. Live Act1 remains **37/45**. #38 stays QA-only.

## Context

Misdeal (Godot 4.7.x / GDScript) is a dark-fantasy card-led roguelike; #38 `black_lantern_road` is a five-skeleton encounter with two shifting pools of amber light. User-approved D200 card artwork and the exact **D209 third forest arena** (user-native F6 composition PASS) are LOCKED, not to be reimagined.

D211 Road Sentinel **illustrated silhouette OPTION A** (armored, spear, small lantern) has been expressly chosen by the user («а»). **Choice A is silhouette approval, NOT a 25-frame atlas or Godot animation approval.**

## Important D213 correction — actual animation packing in GitHub

**The previous assistant chat D212/D213 narrative described a sequential row-major animation pack. That is INVALID for the actual Godot loader. DO NOT USE IT.** The implemented `scripts/battle/unit_animation_library.gd::_create_frames` calls `_add_row` once per state with these fixed rows, matching `scripts/dev/unit_animation_candidate_validator.gd`:

| Zero-based atlas row | State | Nonempty 96px cells, columns 0... | Remaining transparent cells |
|---|---|---|---|
| 0 | `idle` | 0,1,2,3 | 4,5 |
| 1 | `walk` | 0,1,2,3,4,5 | none |
| 2 | `attack` | 0,1,2,3,4,5 | none |
| 3 | `hit` | 0,1,2 | 3,4,5 |
| 4 | `death` | 0,1,2,3,4,5 | none |

**Each distinct frame is placed at (x = column×96, y = row×96), in its OWN ANIMATION ROW.** Dimensions **576×480**, exactly 30 cells, **25 meaningful authored RGBA poses / 5 fully clear cells**. No across-rows sequential placement, duplication as filler or synth-swapping animation state. Source/exports: transparent art to WebP/Base64 `*_frames.webp.b64` when a *real* original atlas has passed asset approval. Existing loader speed values are idle 2.7 fps (loop), walk 7 (loop), attack 16 (one shot for these new enemies), hit 12 (one shot), death 10 (one shot). Do not alter these globally to fit bad art.

For standing/walk/hit/attack cels, boots physically contact local cell y≈87–94, consistent with `unit.gd` sole offset assumptions. Death moves torso downward while corpse's lowest pixels remain near that baseline; no levitation. **No visible pixels/cropped silhouettes at tile boundaries**: preserve at least a 2px transparent safety margin, including equipment swing and light halo. At full 96px pixel presentation, retain consistent pixel density, stance, head-to-torso proportions and enemy-facing orientation (verify real in-engine flip), no blur/soft brush, no baked UI/forest/background/ground ellipse.

## Five locked enemy roles / 125 authentic poses total

| Resource / presentation | Unmistakable identity | Key motions / limitations |
|---|---|---|
| `extinguished_guide` — Погасший проводник | Towering procession leader, large metal lantern frame, multiple chained lights, hunching mantle | Entirely original heavyweight slow step / chain inertia / commanding attack / collapse. **~2× actual battle height**, not simply giant body collider; 96px cel may require a separately reviewed runtime scale strategy to avoid clipping while preserving drawn unique leader silhouette |
| `lantern_bearer` — Носильщик фонаря | Thick-boned defensive escort, heavy lantern AND rough plank/barricade reinforced with metal | Stable weighted shield-bearing gait; **short shield-check/contact melee attack**, never spear thrust; defensive identity VISUAL only unless a separately approved mechanic is implemented. Detailed per-pose contract: `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md` |
| `road_sentinel` — Страж дороги | Armored skeletal guardsman (user-chosen **D211 A**), upright/compact LONG SPEAR and small lantern | Clear spear THRUST, armored sentinel gait; absolutely no axe/halberd; spear must fit 96px without shrinking body to irrelevance. D212 chat spec's frame layout is superseded by this corrected row-per-state matrix |
| `oil_acolyte` — Масляный служка | Thin nervous oil servant with oil flask and small sickle, flickering lamp | Quick unsettled stride; short sickle/ritual strike; retain oil vessel through poses; no unapproved burning/buff gameplay mechanic |
| `lantern_archer` — Стрелок фонарей | Thin skeleton ranged archer with bow, visible quiver and rig-hung lantern | Authentic draw → nock → loose, stable boots and visible bow; attack damage/projectile remains existing scoped battle logic until separate approval |

All share cold gray bone, near-black worn metal, dark parchment-tan wood, restrained amber practical light with no oversaturated effects. Silhouettes must remain distinct in a single full-scene frame on the **exact approved D209 background** with 3 heroes, 5 skeletons and travelling light underfoot. No five identical cowled skeletons with recolored accents.

## Production gates, non-negotiable

1. Confirm standalone identity art at real game display scale; maintain chosen Sentinel A, D209 arena and D200 card art exactly.
2. Paint authentic pose-by-pose original 25-frame RGBA for each role in correct rows, with no source 5×5 crop bleed. The D205 converted sheets and D211 concept presentation/crops are explicitly **NOT production**.
3. Offline QC: dimensions/cell count/state order, 5 transparent unused cells, all 25 distinct/meaningful, 2px alpha safety, baseline, source alpha, pixel density, visually plausible 6-frame walk, role-specific attack and death rest.
4. User art review. Then import ONLY approved original WebP/Base64 assets to `assets/pixel/units/deck_expansion_v1/`, via proper GitHub commit, register selected role(s) in `MisdealUnitAnimationLibrary` without fallback to pre-existing enemy art; native Godot F6 animation gallery at 100% and in combat-scale on D209.
5. After all 5 native gallery PASS, integrate #38 encounter-local animation/light and run real Battle→Reward→Table and 54-case matrix/full-pool release smoke. ONLY then put #38 in live `RunState.ACT1_CARD_IDS` to reach 38/45.

Production order: `road_sentinel` (A), `lantern_bearer`, `oil_acolyte`, `extinguished_guide`, `lantern_archer`. D214 documenting Bearer is NOT a claim Sentinel artwork or atlas has been completed.

Leave accepted released fights (#34–#37), D196 storm, DS2, Fate Spread 12+XIII, +16% baseline encounter-only lantern controller, `backups/KARAMBA73-2026-10-16` and the 37-card pool untouched.
