# Misdeal — Canonical Working Handoff
Updated: 2026-10-15 (D179 documentation cleanup).

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first. **This is the single canonical next-chat handoff**; `NEXT_CHAT_HANDOFF.md`, `SESSION_CHECKPOINT.md` and `D153_NEXT_CHAT_START.md` are compatibility pointers, not separate contradictory instructions.

## Exactly where work stopped

User reports the **post-D176 D153 balance** is presently okay and requested **repository-file organization**, not a fresh enemy buff or automatic release. The Godot 54-case post-tune matrix is **FUNCTIONAL PASS 54/54** (solo/duo/trio 18 wins each; mean HP 74/67/74%, worst 39/15/37%; 0/4/4 fallen individual heroes; thread events 123/91/54). Separate **pre-tune** real battle → reward → table was user-reported PASS. Accepted art: original crimson skeleton Puppet Master + Bone Marionettes and the dark asymmetric moonlit backstage arena, not generic sprite collages.

Code `scripts/core/run_state.gd` still has **35 live Act1 IDs**; `threadbare_theatre` has a QA-only `CARD_PATHS` lookup but is **NOT live card 36**. Other encounters, global party compensation and 12+sealed XIII remain unchanged.

## Next task on user authorization

1. User confirms revised **real battle** feels engaging/fair (the matrix alone cannot decide); if unclear, ask just one quick question, don't force repeated screenshots.
2. Activate **only D153** as card **36/45** in `RunState.ACT1_CARD_IDS`, update hardcoded QA-only assertions in D153 dev smoke/playtest scripts as appropriate, verify normal deal + real Reward/Table; maintain exact deck/Fate Spread semantics.
3. Then begin the next original card/encounter with D143 new enemy rules and D167/D168 actual multiple visual options before adoption.

## Technical references

- D153 balancing: `docs/D153_BALANCE_D176.md`; encounter design: `docs/DECK_EXPANSION_D153_THREADBARE_THEATRE.md`.
- Scene: `scenes/dev/threadbare_theatre_playtest.tscn`; 54-case: `scenes/dev/threadbare_theatre_battle_smoke.tscn`.
- Original production resources: `resources/cards/threadbare_theatre.tres`, `resources/encounters/threadbare_theatre.tres`, `resources/units/threadbare_puppeteer.tres`, `resources/units/bone_marionette.tres`, `scripts/battle/thread_tether.gd`.
- `docs/INDEX.md` explains active vs archived docs. Do not rely on older "not wired / missing art / native QA pending" statements copied into historical files.

Developer workflow: use connected GitHub directly. User normally does `git pull`, launches Godot and sends feedback. No need to re-ask for GitHub permission or archive transfers.
