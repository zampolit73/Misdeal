# A1M1 — Castle Memory implementation and playtest

**2026-11-02. Scope:** implementation in `feature/a1m1-castle-memory-pilot`, [PR #45](https://github.com/zampolit73/Misdeal/pull/45); **technical release and player's visual approval require native CI and F5 review**. This document describes the implemented behavior on the PR branch; do not mistake the plan for a user-tested release.

## Concrete card triggers and existing mechanics

- `moon_seal` Tier 0: `keep`, `sell`, `burn` record `promise_heard` once. `leave` does not. Existing +10/+30/HP↔damage unchanged, and retained `keep` bonus in `echo_crypt` still applies independent of clue collection. Brief class-based detail is visible in the event's DS2 footer/description.
- `echo_crypt` Tier 1: `relic` with `moon_seal=kept` OR `listen` with or without that outcome records `orders_conflict`; `relic` without seal, `gold` and `leave` do not. Found contradiction is stated in the actual event result. Existing HP, gold and artifact values unchanged.
- `court_of_the_mute` Tier 1: successful real combat completion (with `last_battle_won=true`) records `orders_conflict` once, even when Echo Crypt was never offered. Failed combat never earns evidence; no combat mechanics or reward changes.
- `blood_ledger` Tier 2: if `orders_conflict` recorded, existing **gold** purchase of a next-extra hero upgrade costs 35 instead of 40. One shared `RunState.get_blood_ledger_gold_price()` determines caption, enabled state, payment and completion summary. No clue = standard 40. Blood, erase, scarce artifacts, capped upgrades and Mage rescue scar are untouched.
- Run-local `castle_memory_facts` stores the first real card source of a fact; `reset_run()` clears them and queued Wizard lines. A second source does not issue a duplicate reward or comment. No save file or cross-run metaprogression.
- The Wizard uses at most one line per new fact, delivered only after existing Wager/Meddling/party-memory lines, with existing rejected-card milestones 3/7/11 and debt/boss narration respected. No forced cards or future-info spoilers.

## First-class implementation paths

`scripts/core/run_state.gd` (state, first source, price, Court victory), `scripts/event/act_choice.gd` (choice resolution and presentation), `scripts/story/act1_castle_memory_text.gd` (Knight/Ranger/Mage + Wizard copy), `scripts/table/table.gd` (nonintrusive Table feedback), `tests/unit/test_a1m1_castle_memory.gd` (native regression).

Existing DS2 event skin `scripts/event/act_choice_ds2.gd` intentionally transfers full `Button.text` into `Button.tooltip_text` plus generated parchment labels. UI tests assert the displayed source in `tooltip_text`, not the cleared raw Button text.

## Native QA gates

1. Godot 4.7.x import/parse, full GUT (`tests/unit/`) with A1M1 tests and existing suites; CI relevant Table, Battle and event flow; recorded Godot 1280×720 screenshots for unchanged DS3 UI where applicable.
2. `moon_seal` keep/sell/burn/leave outcomes and original `echo_crypt` resources: no double artifacts, no doubled choices.
3. `echo_crypt` with and without kept seal: independently listening grants conflict; sealed relic grants it; ordinary unsealed relic and gold do not.
4. `court_of_the_mute` victory vs failed battle; proof source only on success. Same proof from both sources is idempotent.
5. With proof: ledger gold button 35, exact 35 affordability, actual 35 deduction and same upgrade. Without proof: 40, 39 disabled. Other ledger options and Mage scar remain unchanged.
6. Wizard pending memory does not overwrite other Wizard events or milestone commentary. Evidence is not disclosed before a player-resolved card and source remains run-local.
7. Knight/Ranger/Mage text remains coherent; solo/duo/trio, battle rewards, Fate Hold/forced fight, 12+XIII and restart remain unchanged.

## Local F5 check after verified merge

Run `git pull`, F5:
- Start with Knight, choose `moon_seal` if offered, save the seal (compare with selling it on another run). Check short memory on screen, original +10 versus +30 gold and wizard response on Table.
- If `echo_crypt` appears, choose sealed relic or listen; the result should mention two conflicting orders. Without seal, listening still works at the old HP cost. Other choices yield no proof.
- Alternatively, win `court_of_the_mute` and look for evidence echoed by the Wizard on return.
- At `blood_ledger`, if proof was found, gold upgrade shows 35 (same actual deduction); without proof it shows 40. Inspect in the *real DS2 physical choice card* without tooltips or text overflow.
- Restart: the previous run's clue and discount must disappear. Check no visual/audio clutter, no spoilers and 12+XIII as usual.

**Not included:** full Act I rewrite, third ending, clue archive across runs, forced reveals, any art change, new audio or combat balance.
