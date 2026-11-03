# D387 — C3 Dark Order hero key-pose QA (preview-only)

Date: 2026-11-04
Status: three isolated concept-derived STATIC art candidates staged in GitHub. Not final animation assets; no production combat image replacement; Godot F6/CI pending.

## Scope

- Art input: previously generated C3 sheet illustrating Knight / Ranger / male Mage with a nearly black art-well background.
- Segmented one representative full-body pose per role, removed the near-black matte using a foreground color-distance alpha mask and cropped away interface labels, borders, display podiums. Because source pixels are tiny, these key poses still have image-extraction artifacts and must NOT be treated as finalized animation art.
- Packed three 48x48 RGBA cells into a 144x48 lossy WebP; repository text storage: assets/pixel/units/hero_c3_keyposes_qa/c3_keyposes_48.webp.b64.
- Dedicated scene: res://scenes/dev/d387_hero_c3_keypose_preview.tscn; script scripts/dev/d387_hero_c3_keypose_preview.gd. This uses the EXISTING approved Firing Square authored backdrop and creates regular live BattleUnit hero visuals along with the opt-in 2x C3 still sprites. It does not modify RunState or real combat resource loading.
- The 48px key-pose cells displayed at 2x are a legibility trial only; the actual new 25-frame production atlas must remain 576x480 with 6x5 96px cells per role.
- Source QA GUT test tests/unit/test_d387_hero_c3_keyposes.gd checks file decode, dimensions, visible hero content, transparent background and preview scene isolation.

## Test in Godot 4.7.x

1. git -c gc.auto=0 pull --ff-only origin main
2. Open res://scenes/dev/d387_hero_c3_keypose_preview.tscn in Godot, press F6, set 1280x720.
3. Compare existing CURRENT row and C3 concept row. Pay special attention to separate Knight boots, shield and sword; Ranger bow, feet and hood; Mage staff grip, feet and robes. Check all three against the same real Firing Square backdrop.
4. Confirm there are no black rectangular backgrounds under candidate poses and that they do not require changes to character hitboxes, UI health bars, game balance, unit ordering or waves.
5. The scene has no idle/walk/attack/hit/death playback intentionally. It is a *still-image lookdev*; no false animation readiness or actual F6 pass claimed.

## Next actual asset production gate

Independently author three clean 96x96 alpha hero key poses with consistent feet and prop grips (not cutouts from labeled storyboards). Then complete all 25 distinct authored cells per hero in one uninterrupted production batch: idle 4, walk 6, attack 6, hit 3, death 6. The 6x5 576x480 RGBA WebP pack for each hero must have 5 unused clear slots and no detached row fragments, close-up ghost limbs, incomplete attacks or missing feet. Stage behind an opt-in preview; run real native Godot screenshots and 1x motion/QA before enabling any live replacement.

Current BattleUnit script attempts a Knight animation via the library and retains v4 fallback; older historical text saying Knight always uses static art is not the current implementation. All three existing live hero sprites stay unchanged in D387.

Rollback: remove only assets/pixel/units/hero_c3_keyposes_qa, the dedicated dev script/scene, and its GUT if reverting the pilot; no production script needs modification.
