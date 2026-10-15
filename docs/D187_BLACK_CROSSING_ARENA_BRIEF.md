# D187 — Black Crossing combat arena (approved stormy Last Pier, native F6 accepted)

Date: 2026-10-16. Act 1 **36/45**, candidate card #37 (`black_crossing`) still QA-only; character animation gallery **user-reported PASS (D186)**.

Earlier art directions, superseded by the user-approved final stormy **Last Pier**. User repeatedly removed repetitive background objects before saying «согласовано»:
- **A — Broken timber pier**: an asymmetrically collapsed old timber landing; wide horizontal center plank floor, black tide below, single lantern on the right, moonlight upper left, ONE distant ruin, few purposeful posts.
- **B — Ruined stone sluice**: decayed stone gate and flooded masonry landing; big empty flat tactical bridge across mid-frame; heavy stone sluice relief on one side and wet steps on the other, no repetitious towers; sparse red cloth as Misdeal color connection.
- **C — Fractured causeway**: elevated mooring ramp with a broken secondary footbridge in the background and tide at its sides; wide open arena center, directional leading lines, no clutter or extraneous fight characters.

Art constraints: actual **1280×720** background, designed for units/HUD drawn later by Godot. Do not generate or integrate characters, labels, drawn hit bars, wave UI, card borders, scripted mechanic marks or action icons as part of backdrop. For readability, keep arena central band (roughly x=220–1070, y=280–565) unoccupied by foreground machinery so 3-vs-3 units have leg-contact and telegraphed hazard strip visibility. Blue-charcoal moonlit Misdeal DS2 palette, muted burgundy, minimal warm amber lantern, original pixel-art environment with plausible construction and varied silhouette, no clone castles/towers or fake infinitesimal detail. Selected card illustration option #3 remains approved and locked, **not** the actual battle arena.

Only after an explicit choice commit the approved exact arena asset and add a `black_crossing` runtime backdrop path; separately implement encounter-only telegraphed wave push/slow and original UnitData/encounter, followed by 54-case native Godot QA and real battle/reward route. No automatic live-card activation.


## D187 — Selected Black Crossing battle environment committed (native F6 pending)

The user explicitly **approved the final stormy «Последний причал»** after requesting several precise removals of distracting background structures: the left-middle tall ruined rock cluster and right-hand wooden construction were removed, while the wet empty pier, single lantern on the left, moon, sea, crashing waves and right-hand cliff ruins were preserved. The correct **last** edited 1672×941 image is `a_wide_cinematic_highly_detailed_pixel_art_digit.png` (source SHA-256 `2072cee399e32fe96f0c97e887d8821a2dc225294703389b44c8f95d0e6f7a9b`), **not earlier drafts or annotated screenshots**.

D187 production export `assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64`: 1280×720 resized with Lanczos to preserve the full approved composition, decoded WebP SHA-256 `984842e54f30db7d0efe1f9e2fc6a6e74b508cd3af111fe387ff87fe33c97e44`; source remains available in the project chat. The standalone arena is mapped to `ARENA_BLACK_CROSSING` in both `scripts/battle/authored_backdrop.gd` and `scripts/battle/battle_visual.gd`. The latter deliberately suppresses its default crypt atmosphere rather than drawing unrelated candles; future timed waves need a *separate* encounter-specific telegraph and overlay. New F6 acceptance gallery: `res://scenes/dev/black_crossing_arena_preview.tscn`, uses the **actual production arena loader** at full 1280×720 with no characters/UI if successful. Native Godot arena PASS is **not yet confirmed**.

**Release gate:** D187 changes only the background id and F6 gallery, not the encounter, UnitData, wave mechanic, deck registry, battle/reward route or D151–D153. The live Act1 pool remains **36/45**. Next: user `git pull` + F6 arena preview; if the approved art looks correct in-game, add original enemy resources/encounter and scoped visible warned wave surge (push/slow), then 54-case native matrix and real battle → reward → table before unlocking card #37.


## D188 follow-up (2026-10-16)

User replied «все ок» after F6 of the integrated arena — **native arena visual gate accepted**. New original enemy UnitData, 1+2 authored two-formation encounter and encounter-local warned waves are now in source. Details and pending 54-case/real battle QA: [D188 Black Crossing Encounter](D188_BLACK_CROSSING_ENCOUNTER.md). Keep Act1 36/45.

## D190 handoff clarification

The D187 **cleaned storm arena itself was user-approved in native F6**. Earlier 'native preview pending' text above is historic to initial integration. The later D188 full battle exposed off-plank movement (not art approval failure); D189 has already changed movement bounds and foam. Await **post-D189 full battle F6** and refreshed 54-case combat test. See `docs/HANDOFF.md`.
