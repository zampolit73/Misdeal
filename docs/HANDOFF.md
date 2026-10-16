# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — **D192 wave volume and curling foam after D191 native matrix.**
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

## NEXT TASK — start here in the new chat

1. User does `git pull` and **F6 `res://scenes/dev/black_crossing_playtest.tscn`** to review only the newly implemented D192 advancing breaker, foamy crest and sprite foot contact. If victory, verify **reward → Fate Spread/table**. Ask for screenshot/acceptance; user explicitly expects assistant to work directly through GitHub, never give manual patch steps.
2. **D191 54/54 native matrix is confirmed for unchanged gameplay**. D192 only draws visuals, so do not require a repeat of all 54 cases unless errors or altered mechanics demand it.
3. On user's visual acceptance and confirmation of the real reward route, release `black_crossing` into normal `ACT1_CARD_IDS` as **#37/45**, update all old 36-card guards and add/execute an ordinary-deal release smoke. Preserve D151–D153 and global scaling.
4. Update `PROJECT_STATE`, `ROADMAP`, `CHANGELOG` and this `HANDOFF`; decisions only for actual new binding design rules. Commit directly to GitHub.

**D192 session:** user supplied native D191 54/54 PASS and still disliked thin-line surf. Assistant directly edited source and docs via connected GitHub. No Godot runtime in assistant execution environment, so D192 rendering must be judged in the user's Godot F6. Live pool still 36/45; release #37 awaits D192 visual approval and reward→table confirmation.
