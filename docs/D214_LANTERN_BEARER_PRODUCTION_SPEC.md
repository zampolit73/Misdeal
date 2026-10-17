# D214 — Lantern Bearer / Носильщик фонаря: 25-frame production specification

Date: 2026-10-17. Status: **DETAILED ANIMATION ART BRIEF READY; ART NOT PRODUCED, NOT APPROVED, NOT WIRED**. Applies to `lantern_bearer` in #38 `black_lantern_road` only. Act1 live pool **37/45**.

## A. Existing contract, not a new mechanic

D199 established **a normal-size thick-boned skeleton carrying a HEAVY LANTERN and a WOODEN BARRICADE/GUARD PLANK**, escorting the procession as defensive cover. Not the towering `extinguished_guide` or the armored spear `road_sentinel` (Sentinel's illustrated choice **A** is already accepted). Our proposed execution is an oversized field-made plank shield held in front, with a distinct amber lantern in the free hand. **The shield is an animated VISUAL characteristic**. Do NOT secretly implement armor, block chance, taunt, reflect, cover statuses, speed reductions or extra party modifiers: currently `resources/units/lantern_bearer.tres` has HP=69, damage=5.5, attack interval=1.75s, range=44px, speed=56px, body radius=18px and scale 1; these numbers remain unchanged. New gameplay requires a separately discussed design/QA gate.

## B. Character assembly and readability

- Proportions: one standard escort height, **broad ribcage and shoulders**, bony knees and visible planted feet. Wider and heavier than the Archer/Oil Acolyte; less metal/spear reach than Sentinel; nowhere near double-height Guide.
- Distinguishing feature 1: rough vertical **wooden guard-plank shield**, 2–3 mismatched thick boards with a crooked iron rim and sparse rivets. Simple large readable silhouette, not smooth knight heraldic kite shield, not a faceless rectangle hiding the skeleton. Shield should protect the front arm and chest but NEVER obscure knees/feet.
- Distinguishing feature 2: **heavy amber lantern** with clear iron frame, attached by a hand grip or a short loop in the free hand; its glowing core is a restrained warm focal accent. Keep separate from the shields and from ground light pools: do not paint world-space glow circles or extended light beams into any tile.
- Face: skull/mouth clearly visible beside upper plank edge; tattered shawl straps optional, never a hood that makes the unit read as the Guide. Rust metal + weathered timber + cold bone palette; subtle amber only on lamp.
- In the authored “enemy faces the hero” pose, shield should clearly be forward relative to enemy facing while lantern remains visible behind/off the side. **Double-check Godot's actual sprite flip**, do not bake double-facing or mirror text.
- 96×96 crop-safe design targets, subject to actual cel QC: keep most body pixels in local X~12–81, active shield upper edge within Y~8–80, top skull Y~12–23, boots anchored Y=87–94, at least 2px clean alpha border. These are design targets, **not** hard masks forcing chopped parts; dynamically tuck the lamp against hip in wide attack poses.
- Guide stays visibly the tallest character in the full 3-vs-5 D209 scene. Bearer has the broadest shield profile, Sentinel the spear.

## C. Authoring format — follow LIVE Godot animation loader, not erroneous old D212/D213 row-major text

**Exactly 576×480 RGBA; 6 columns × 5 rows of 96×96 cells.** State row order is fixed in `scripts/battle/unit_animation_library.gd::_create_frames`:

| Row 1-indexed | Cells 1..6 (left to right) |
| --- | --- |
| 1 | `idle_1`, `idle_2`, `idle_3`, `idle_4`, EMPTY, EMPTY |
| 2 | `walk_1`, `walk_2`, `walk_3`, `walk_4`, `walk_5`, `walk_6` |
| 3 | `attack_1`, `attack_2`, `attack_3`, `attack_4`, `attack_5`, `attack_6` |
| 4 | `hit_1`, `hit_2`, `hit_3`, EMPTY, EMPTY, EMPTY |
| 5 | `death_1`, `death_2`, `death_3`, `death_4`, `death_5`, `death_6` |

**25 original, non-repeated poses + 5 transparent unused cells.** Existing playback target idle=2.7fps looping, walk=7fps looping, attack=16fps one-shot, hit=12fps one-shot, death=10fps one-shot (values from current loader, not new desired gameplay timing). Every frame independently full-body painted; no transparent areas substituted with previous frame to hide errors. 2px transparent border for silhouettes/equipment, boots baseline around y87–94 for upright poses; death falls but ground contact persists. Do not pack serial frames row-major across state boundaries. Export authoring PNG to approved, lossless-quality WebP/Base64 `lantern_bearer_frames.webp.b64` **only after character art approval**.

## D. 25 per-frame directions, with body/equipment timing

### IDLE — row 1 / 4 frames, seamless loop

1. **Idle 1 / brace:** boots firmly apart, shield planted forward, elbow bent, heavy lantern hanging at the side; skull checks the direction of the heroes.
2. **Idle 2 / weight shift:** slight chest/hip compression and weight onto front foot; shoulder pushes against board, the lantern lags a few pixels.
3. **Idle 3 / settle:** front knee flexes, iron-rim plank briefly raises to protect chest, dangling lantern completes pendulum motion.
4. **Idle 4 / reset:** brace relaxes toward first pose, lantern swing slows so 4→1 is smooth; do not copy Idle 1 pixel-for-pixel.

### WALK — row 2 / 6 frames, seamless heavy march

1. **Walk 1 / lead-foot lift:** rear foot supports body while near/front foot lifts just above road; shield stays forward, lantern trails.
2. **Walk 2 / step placement:** leading heel meets the implied road ground contact; shield tilts slightly to counterbalance weight.
3. **Walk 3 / compression:** load transfers onto lead leg, skull dips and lantern swings opposite the planted foot.
4. **Walk 4 / other-foot release:** supporting leg pushes, opposite heel lifts; plank moves horizontally but does not teleport.
5. **Walk 5 / opposite placement:** second foot plants at baseline; shield edge and lantern follow with slight natural inertia.
6. **Walk 6 / recovery:** body returns toward Walk 1 contact silhouette, finishing two readable footfalls with no backward-foot slide.

### ATTACK — row 3 / 6 frames, short shield-check melee attack

1. **Attack 1 / sight target:** raise shoulder and brace plank, feet stable; lantern hand moves to side, clear intent but not yet contact.
2. **Attack 2 / load:** crouch a little and bring plank close to torso, elbows pull in, rear leg bears weight.
3. **Attack 3 / forward drive:** short accelerating step toward heroes, shield advances and skull trails the shoulder; begin frontal strike.
4. **Attack 4 / CONTACT silhouette:** peak close-range board bash or rim strike; shield covers opponent-facing side, elbow/upper body commits weight, striking edge unmistakable; lantern stays visible outside the collision silhouette.
5. **Attack 5 / recoil:** torso decelerates and knees flex, board remains in the strike path, lantern swings forward from inertia.
6. **Attack 6 / guard return:** restore forward plank and grounded stance, natural path to Idle 1 rather than pop/snap.

**Attack artwork does NOT change hitboxes, impact timestamps, knockback or damage.** Real animation sync vs current immediate-hit BattleUnit system is a later native QA decision, not permission to alter global battle mechanics.

### HIT — row 4 / 3 frames, controlled stagger

1. **Hit 1 / surprise:** board tilts off-axis, skull jerks, lamp dips but remains held.
2. **Hit 2 / stagger:** back heel takes a defensive step, ribcage recoils visibly, plank edge temporarily exposes torso; avoid fall/death pose.
3. **Hit 3 / recover:** bring board back between unit and heroes; boots re-anchor, lantern swing damped, return to Idle 1.

### DEATH — row 5 / 6 frames, heavy fall and quiet final

1. **Death 1 / unbalance:** blow shifts mass behind the plank, one knee buckles; lantern flickers.
2. **Death 2 / release board:** shield slips down out of the protecting position; skull follows its weight.
3. **Death 3 / collapse:** first knee and shield contact ground, ribs tilt; lantern drops near the supporting hand.
4. **Death 4 / impact:** full upper torso tumbles into/falls beside old boards, bones remain readable, shadow and contact close to baseline.
5. **Death 5 / settle:** minor final motion of loose hand, shield and lamp; glass frame intact enough to identify the role, light diminishes.
6. **Death 6 / corpse hold:** fully motionless grounded remains, distinct fallen shield silhouette beside skeleton, lantern either dim or dark; no disappearing sprite, no looping death or hovering debris.

## E. Special QC acceptance matrix

**Technical static checks**
- Atlas pixel size `576x480`, RGBA alpha, 6x5 cells, exactly 25 authored states in proper ROWS; other 5 cells wholly transparent.
- Borders: no alpha leak at edges; no amputated bone tips, shield rim, dangling lantern, heel or falling plank. Aim for >=2px transparent padding for material pixels and y87–94 boot sole for upright poses.
- Every state has clearly different meaningful silhouette/physical movement; walk legs alternate and make contact; no fake scale-jiggle or repeated frame filler. Avoid anisotropic scaling/blur on import.
- Shield remains recognizable in key frame 1 idle and attack contact; lantern independent and visible during idle/walk/attack; all 25 poses skeleton-consistent.
- At 100% game display, bearer remains approximately standard skeleton size, noticeably broader in silhouette than Sentinel, yet clearly shorter than Guide.

**Native Godot checks (NOT DONE)**
- Only after asset review, check native F6 sprite gallery idle/walk/attack/hit/death, no frame skipping, sudden jumping, mirrored hand swaps or boot-slide.
- On exact approved D209 moonlit-road arena (3 heroes vs 5 original skeletons), inspect overlap with guiding lantern-light VFX, health bars, floor line, and neighboring spear Sentinel; ensure shield/lamp don't vanish at the battle center.
- Real 5-enemy light mechanic + actual battle route + reward table are subsequent gates, NOT implied by approved concept art.

## F. Handoff / non-goals

Read D213 canonical revised row layout before ANY of five atlases. Bearer D214 is the second role in production order after Road Sentinel D211 choice A, but **this D214 document is only art specification**: neither Sentinel nor Bearer has an actual new native-approved 25-frame production atlas. No artwork or runtime code was changed by writing this document. Continue real pose-authoring, on-screen art approval and safe GitHub import; don't secretly add shield mitigation or modify `resources/units/lantern_bearer.tres` statistics. Keep Act1 **37/45**, selected D200 card image, D209 forest, D196 waves, DS2, Fate Spread 12+XIII and frozen `backups/KARAMBA73-2026-10-16` unchanged.
