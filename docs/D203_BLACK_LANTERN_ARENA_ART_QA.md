# D203 — Black Lantern Road: arena art-direction and battle-staging QA

Date: 2026-10-16. STATUS: **ART QA / BLOCKOUT COMPLETED, ARENA NOT SELECTED, NOT IN GAME.**
Technical source: `zampolit73/Misdeal/main`; frozen safety backup `backups/KARAMBA73-2026-10-16` is not touched.

## Working method

The user supplied three personal specialist skill archives in this conversation:
- `dark-fantasy-roguelike-designer (1).zip` — check that visual signals support a meaningful, readable temporary lanternlight choice.
- `dark-fantasy-game-artist.zip` — scene hierarchy, first readable masses, restrained palette, asset-vs-concept distinction, game-scale visual QA.
- `dark-forge-game-developer.zip` — preserve Godot 4.7.x conventions, real scene coordinates, static-vs-native evidence.

Their `SKILL.md` instructions and the visual references `STYLE_BIBLE`, `2D_PIXEL_PIPELINE`, `QA_AND_DELIVERY`, `CONSISTENCY_AND_EDITS` were consulted. **These ZIP archives are conversation uploads and are not themselves new source-code or runtime dependencies.** Project `AGENTS.md`, design rules and locked #38 concept remain primary.

## Actual findings

1. Multiple freshly generated wide backgrounds from the D201 stage **repeated the exact same castle-on-a-hill + viaduct + many orange lamps composition**, despite a targeted request for a distinctive dead forest; do **not** relabel them as three meaningfully different choices. These are exploratory concepts, not approved game art. Many small lamps also compete with the intended two mechanically meaningful moving light pools.
2. The existing **D201 option #2** image, `d201_arena_option_2.png` (user conversation attachment), is an acceptable **temporary layout audit reference**, NOT a selected production background. Its 1280×720 file size was verified using Pillow. It has no baked combatants or tactical-grid lines, but still exhibits too many background lanterns and a distracting distant fortress.
3. A **temporary technical overlay** was generated from that image: `d201_arena_gameplay_clearance_test.png` (conversation artifact only, not GitHub-committed). It shows a translucent region derived from production `battle.gd` `UnitsLayer` screen offset `(20,96)` and default `COMBAT_BOUNDS Rect2(90,284,1080,158)` → screen rectangle `(110,380)` to `(1190,538)`. Three hero placeholders fit on the left; **five enemy silhouettes** on the right (four normal-height + a **2×-tall** distinctive Lantern Guide) share a floor contact line around screen Y=505. These are **bounding proxies**, not actual sprites, approved combat placements, or a native engine screenshot.
4. The two amber circles in the overlay are **illustrative** of the new mechanic, not agreed gameplay radii/positions/timings. They show that too many baked lanterns could conceal the signal of enemy buff light pools. The advantage/telegraph still needs scoped Godot implementation and user-visible visual QA.
5. Native Godot arena **F6 not run**, and no Godot arena file or enemy atlas was created in this D203 audit.

## Next art acceptance contract

Create **two or three genuinely distinct 1280×720 actor-free scene backdrops** that keep the card #38 theme but differ in actual geography, not lamp counts:
- **A. Black forest bend:** two towering dead tree walls and a gently curving mud/stone road disappearing into a dark fog corridor. NO distant castle, viaduct, or decorative arch. Two primary lantern posts on outer margins only.
- **B. Drowned lantern ford:** broad raised dry causeway surrounded by dark peat water and broken low stone walls, distant forest only. Avoid looking like #37's storm pier, no large surf and no waves. Lanterns mark safe path edges.
- **C. Abandoned toll gate:** collapsed black-iron toll barrier, crooked carriage wheel and a single ruined guardhouse far behind the fight, with the central road open. No castle or giant architecture above units.

Each alternative needs a **clear middle battle strip** corresponding approximately to screen X=110–1190 and Y=380–538, without chest-high foreground props or baked characters. Dark midtone flooring behind skeletons and heroes must stay calmer than the edges, with clear boot contact; stage the 2× Guide (projected about 180px high) to check HUD occlusion at real pixel size. Reserve mechanically meaningful amber emphasis for Godot-drawn moving light pools; permanent lamps should be sparse and dimmer. No tactical grids or labels baked into images. Distill repetitive micro-texture.

**Gate:** user chooses one genuinely different environment, then the exact source is resized/encoded and added to a **QA-only** Godot arena preview, F6 verified, and only later used for #38 combat. No premature `RunState.ACT1_CARD_IDS` addition; live Act 1 stays **37/45**. Keep existing D200 third card illustration and D196 wave VFX unchanged.

## Reproducibility / limitations

Source image and annotated overlay are in the current conversation artifacts, not uploaded into GitHub. The `KARAMBA73` GitHub checkpoint was saved **before** these exploratory images and must not be modified. Do not claim the final scene has been generated, accepted, imported or tested. Godot native F6 pending.
