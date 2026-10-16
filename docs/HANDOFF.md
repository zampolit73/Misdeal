# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — **D195 organic foam and phase polish after D194 screenshot.**
Repository: `zampolit73/Misdeal`, branch `main`. **GitHub is the technical source of truth, and the assistant has connected GitHub tools; inspect and edit directly without asking the user for manual patches or access.** Godot **4.7.x / GDScript**.

## READ FIRST

`AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`. Refer to `docs/D188_BLACK_CROSSING_ENCOUNTER.md` for the current encounter; `docs/D187_BLACK_CROSSING_ARENA_BRIEF.md` for art history. **No need to read past chat transcripts.**

## Current exact milestone

**Act 1 random deck is 36/45**, with D153 Threadbare Theatre (#36) already released and tested. New candidate card #37 **`black_crossing` / «Чёрная переправа» remains QA-only**. It has a `RunState.CARD_PATHS` lookup for test choice/reward routing but is NOT in `RunState.ACT1_CARD_IDS`.

All approved visuals already exist in GitHub and must be preserved unchanged:
- Card art: option **3**, the diagonal pier illustration, user-approved native card preview (D182–D183).
- Character art: **Ferryman B / Drowned C**, original 25-frame atlases; user-approved native animation preview (D184–D186).
- Battle arena: final **stormy «Последний причал»** 1280×720, approved native arena preview (D187). The user specifically had extra left-middle rock towers and far-right timber frames removed; **do not restore them**.

D188 source has one original `drowned_ferryman` + two `drowned_hand`, two authored formations, `black_crossing_surge.gd`: 3.2s wait → **1.4s warning** → **43px leftward wave push**, both factions slowed **30% for 1.6s**, 4.5s rest, no damage. Stop resets slowdown. Entire fight is scoped to `black_crossing`, not global encounters.

## CONFIRMED QA vs unresolved problems

The user supplied a Godot screenshot of the **original D188 54/54 matrix FUNCTIONAL PASS**: 54 victories / 0 full-party defeats; solo/duo/trio 18/18/18, Knight/Ranger/Mage 18/18/18; mean remaining HP **85/78/84%**, worst **58/46/63%**; durations **10.4/11.3/10.6s**; fallen heroes **0/1/4**; waves **81 warnings, 58 strikes, 71 pushes, 71 slowdown resets**. **This was BEFORE D189 and does NOT validate its replacement movement floor or wave visuals.**

The user's *real battle screenshot* revealed two defects and explicitly requested them fixed **by the assistant via GitHub**:
1. Warning/impact was an ugly thin **rectangular debug-like band**, not a natural-looking breaking wave.
2. Hero/enemy feet appeared on **broken foreground beams / off the intact upper plank floor**.

**Important: D189 CODE FIX ALREADY EXISTS IN `main`** (verified on GitHub 2026-10-16). Do not implement it again sight unseen, and do not repeat the false claim that GitHub is inaccessible.
- `scripts/battle/black_crossing_floor.gd`: the shared UnitsLayer-local safe plank `COMBAT_BOUNDS = Rect2(110,240,1060,128)`; hero placement `Rect2(145,250,390,112)`; wave centers y284/330. (UnitsLayer offset and sprite feet must be considered when assessing visible floor.)
- `scripts/battle/battle.gd`: only Black Crossing selects the custom bounds for AI and deployment. `scripts/dev/black_crossing_battle_smoke.gd` uses the same bounds and checks position legality.
- `scripts/battle/black_crossing_surge.gd`: animated irregular blue wave polygon, foam crest, ruffled advance warning and spray instead of `draw_rect`; the push clamps to unit bounds and slowdown cleanup remains.
- **D191 smoke QA code update is in main:** 54-case matrix uses real battle's solo/duo/trio authored hero starts, floor projection and placement clamping; requires 54/54 wins in addition to no off-plank positions and proper slow cleanup. **Native Godot retest after D189/D191 is NOT confirmed**. Existing D189 commits (code + docs) precede this checkpoint; see Git log. Do not invent PASS or claim the old 54/54 result covers the corrected geometry.

## D191 native QA and D192 response (latest)
User's F6 screenshot **D191 / BLACK CROSSING — FUNCTIONAL PASS**: 54/54 battles and wins, 0 whole-party losses; solo/duo/trio 18/18/18, Knight/Ranger/Mage 18/18/18; mean survivor HP **86/74/77%**, worst **58/42/50%**, durations **10.0/11.6/10.8s**; fallen heroes **0/4/4**; waves **78 warnings, 62 impacts, 66 pushes, 66 complete slow resets**. Native functional combat QA after D189/D191 is now **confirmed**. The user supplied a real-battle screenshot and said the wave still looks lifeless / line-like; **did not approve presentation**, and did not separately confirm reward→table.

**D192 (this commit):** render-only replacement in `scripts/battle/black_crossing_surge.gd`: deep shaded water body, raised forward-moving crest, asymmetric curling foam caps, uneven wake and deterministic spray. All geometry and gameplay functions above drawing are unchanged: hit lane, 3.2s wait, 1.4s warning, 43px left push, 30% slow/1.6s and clean resets. The original accepted bitmap, combat arena, sprites, floor bounds and 36-card live pool are untouched. **Native D192 visual QA still pending**.

## D193 new screenshot and correction

User's native F6 D192 screenshot (2026-10-16) shows huge flat cyan water wall stretching from x140 to x1145 at screen y320-380, hovering over the ocean-side edge of the board and above the knight's feet: **visually rejected**. This is not evidence of correct rolling surf. D191 native functional 54/54 remains valid; route victory→reward→table still not confirmed.

D193 source-only patch to `scripts/battle/black_crossing_surge.gd`: render at the visible sole depth (`current_center_y + 36` in UnitsLayer space) rather than unit origins, draw seven staggered tapering pools of desaturated stormwater separated by gaps, with interrupted gray-white foam tongues, very few bubbles, and low opacity so plank wood grain stays visible. No floating 1000px teal band. The moving wash advances only ~26px along the floor. Gameplay controller code including wave hit test, pushes, slow duration, safe floor, encounter and original art bytes remain **unchanged**. **Native D193 visuals pending**.

## D194 native rejection and remake

User supplied real native Godot screenshot of D193: the wave was now barely visible, with thin white scratches along the wet floor; explicitly called it visually unacceptable given the massive storm behind the pier. **D192 was too much rectangular turquoise water; D193 too weak. Both visual versions rejected.** Functional native D191 **54/54 PASSED** and remains valid because no combat mechanics have changed. Real victory→reward→table navigation has not been explicitly confirmed.

**D194 committed source update:** `scripts/battle/black_crossing_surge.gd` only redraws surf using **three broad overlapping organically tapered breakers** with raised dark volume, rising broken foam crowns, two-tone shading, spray and accelerating southward/down-plank water wash (up to 38px). Warning has smaller/dimmer rising crests, impact full breaking wave. All visual curves local to UnitsLayer (boot y = origin +36). The hitbox still uses the unchanged 50px horizontal bands at y284/y330; 43px left push, 30% slowdown for 1.6 seconds, timers and cleanup are unchanged. Original user-approved pixel battle backdrop/card/unit atlases untouched. **D194 is source-committed but not tested or approved in native Godot.** Never mislabel it PASS before user checks.

## D195 — native D194 feedback and refinement

User's **native D194 screenshot** shows large raised wave body now visibly present; user said **«уже лучше, но можно сделать еще профессиональнее»**. The remaining prominent defect is repeated evenly spaced sharp icy/white **triangles** on every crest. This is feedback, **not D194 approval**.

**D195 visual-only code change:** keep 3 broad storm breakers; replace D194 seven-vertex cap triangles with smooth round irregular foam clusters and significantly denser (72 point) crest envelope, layered dark stormwater, mild asymmetric wave chop, discrete spray and visible collapse/wash phase. Retain y+36 foot anchoring. D195 touches only `_draw*` helpers/render constants in `scripts/battle/black_crossing_surge.gd`. Preserve original bitmap and sprites. No change to wave hit rectangles, safe floor, AI, 43px push, 30% slow for 1.6s, warning/rest delays. **D191 native 54/54 gameplay matrix PASS remains the latest valid functional evidence. D195 visual F6 not yet checked.** The real reward→Fate Spread/table transition has not been confirmed for #37; live deck stays 36/45.

## NEXT TASK — start here in the new chat

1. User does `git pull` and **F6 `res://scenes/dev/black_crossing_playtest.tscn`** to review only the D195 smoother crest with rounded asymmetric foam and fading runoff, avoiding D194 triangle teeth. If victory, verify **reward → Fate Spread/table**. Ask for screenshot/acceptance; user explicitly expects assistant to work directly through GitHub, never give manual patch steps.
2. **D191 54/54 native matrix is confirmed for unchanged gameplay**. D192 only draws visuals, so do not require a repeat of all 54 cases unless errors or altered mechanics demand it.
3. On user's visual acceptance and confirmation of the real reward route, release `black_crossing` into normal `ACT1_CARD_IDS` as **#37/45**, update all old 36-card guards and add/execute an ordinary-deal release smoke. Preserve D151–D153 and global scaling.
4. Update `PROJECT_STATE`, `ROADMAP`, `CHANGELOG` and this `HANDOFF`; decisions only for actual new binding design rules. Commit directly to GitHub.

**D195 session:** user showed D194 Godot screenshot and said the larger wave is better but clearly artificial. Assistant fixed repeated triangular foam, introduced rounded broken crests and progression from swell to wash-out via connected GitHub; code/docs in main. Native Godot execution unavailable here: D195 must be visually checked by user. D191 54/54 combat still valid, card #37 QA-only 36/45 until visual and route gates.
