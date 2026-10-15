# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — **D190 new-chat checkpoint after D189 source fix.**
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
- **Native Godot retest after D189 is NOT confirmed**. Existing D189 commits (code + docs) precede this checkpoint; see Git log. Do not invent PASS or claim the old 54/54 result covers the corrected geometry.

## NEXT TASK — start here in the new chat

1. Ask only for the shortest necessary check: the user does `git pull` and **F6 `res://scenes/dev/black_crossing_playtest.tscn`**. Inspect **actual units' soles** throughout deployment, movement and impact: on intact planks only; foam warning and surging water must look like natural ocean surf, not geometry, with no UI overlap. Capture visual feedback/screenshot. Verify **battle → reward → Fate Spread/table** if the battle ends in victory.
2. Re-run **F6 `res://scenes/dev/black_crossing_battle_smoke.tscn`** and examine new 54-case results plus no off-plank positions or lingering slows. The narrower D189 bounds may change challenge; if issues arise, **inspect current GitHub code, fix it yourself and commit**. Avoid touching D151–D153 or global party scaling.
3. Only when the user accepts fight presentation/difficulty and the real reward route is checked, release `black_crossing` into the normal `ACT1_CARD_IDS` as **#37/45**, update hardcoded 36-card smoke guards and run a separate ordinary-deal smoke. Do not release based on the old pre-fix matrix.
4. Update `PROJECT_STATE`, `ROADMAP`, `DECISIONS` for any new design rule, `CHANGELOG` and this `HANDOFF`, commit to GitHub and give user only `git pull` + an exact Godot test.

**The user's latest request was to preserve all context and continue in a new chat from this exact point. This checkpoint does not make further gameplay changes.**
