# D270 — Editable actor-free Court battle stage (QA art, native Godot PASS)

**2026-10-19 · Godot 4.7.2 · [successful Actions run](https://github.com/zampolit73/Misdeal/actions/runs/39255650012)**

## New art QA candidate

- `assets/pixel/battle/arenas/court_of_the_mute_d270_empty_qa.svg` is an **authored, editable** 640×360 source illustration, rendered by Godot `Image.load_svg_from_buffer()` and scaled NEAREST to 1280×720 at runtime. It contains only architecture: distant cold arch windows, ruined buttresses, stone masonry, empty carved throne/cushion, hanging iron scales of justice, crimson cloth standards, empty stone lecterns, tiered dais, elevated braziers and a continuous cracked lower floor. It does not contain baked judges, clerks, heroes, skeletons, text labels, UI, HUD or imported bitmap sprites. D270 is an **artistic QA candidate, not user-approved painterly final art**. Editable SVG fits repository's text-only existing art transport but may still need a richer final bitmap/render-quality pass.
- `scripts/battle/authored_backdrop.gd` maps **Court only** from legacy D265 provisional `.webp.b64` to new D270 SVG for actual unreleased QA Battle. All other encounter paths and scales unchanged. The old D265 asset remains tracked for rollback and F6 comparison.
- `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn`: **B** cycles the two battle backgrounds in the *same genuine Battle*; **L** compares D269 upper architecture light, **G** shows exactly the D264 battle floor in translucent green. No debug UI additions to the released game's normal Battle. Background swaps re-rasterize the selected Court texture, do not modify unit data or bounds.
- **D264 LOCKED:** screen combat bounds `Rect2(40,532,1228,178)` unchanged. The authoring source's uninterrupted flat stone terrace occupies source image y≈266–360; stairs and fire bowls are above it, never below or over units' feet. Court unit offset/battle placement tactics unchanged.
- D267 all three rich original approved character sheets and 75 frames unchanged, no re-import; Godot 4.7.x/GDScript only. Exact accepted D261 #39 card illustration unchanged; no design-system rewrite.

## Native tests

[GitHub Actions run 39255650012 — complete SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/39255650012):

- `D270_COURT_EMPTY_SVG_NATIVE_PASS`: real Court Battle has nonempty authored SVG, runtime texture **1280×720** and opaque readable floor/backdrop.
- `D270_COURT_BACKGROUND_AB_NATIVE_PASS`: **B** switches D270↔D265 in genuine F6 Battle; art reload and dimensions intact; no sprite/geometry mutation.
- `D269_COURT_NATIVE_VISUAL_QA_PASS`: **L** and **G** toggles work, 7 original actors, red verdict, locked floor; 38/45 live pool retained.
- `D262_COURT_REAL_BATTLE_PASS`: six genuine Battle start configurations.
- `D268_COURT_54_CASE_FUNCTIONAL_PASS`: **54/54 functional BattleUnit scenarios won**, 0 timeouts. Mean hero HP solo/duo/trio **83.84% / 75.54% / 80.16%**, 2 individual hero losses in trio cases. All 7,697 currently sampled living Bailiff active-focus target steps match the marked hero.
- `D268_COURT_QA_ROUTE_PASS`: QA-only direct unreleased Court → genuine Battle → Reward → Table passes. Does **not** represent the normal dealing of the still-unreleased card.

## Gates remaining, do not claim full art approval

1. **Visual user review at native Godot 1280×720**: is D270 actually painterly/rich enough versus D265 and exact selected D261 card image? Machine/parser/render success cannot judge visual quality. An SVG authored from 640×360 vector shapes might still read as schematic; don't call it a final painting without seeing it in the real Battle with moving sprites.
2. **D267 animation art review**: inspect original rich Judge/Scribe/Bailiff all five states at ×1 with 27 source boundary warnings (5/0/22) and especially Bailiff death3–5/halberd grip. Flags are *review pointers*, not automatic corruption proof.
3. Once the actual background and motion are artistically accepted, consider rasterized final WebP backed by editable source for safe exports; run native F6 plus complete D268/D270 QA; then **separate release** card #39 into `ACT1_CARD_IDS`, set encounter target, and add an **ordinary dealt-card** smoke. Until these gates: live 38/45, `resources/cards/court_of_the_mute.tres` `target_path = ""`, #39 QA-only. Preserve #38, D264, D261, DS2, Fate Spread, KARAMBA73.

**User test:** `git pull` → F6 `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` → pick trio and start Battle. Press **B** repeatedly for old/new environment and **L/G** for light/floor. Observe red seal and foot contact. For rich sprites, separate F6 `res://scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn` has pause/frame and 27 marked-source review controls.
