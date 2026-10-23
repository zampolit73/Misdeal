# A1P3 — New-chat technical handoff (2026-10-23)

## Read this first

Source of truth: [Misdeal main](https://github.com/zampolit73/Misdeal). Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`; this A1P3 handoff supersedes A1P2 as the immediate stage when PR #13 is merged.

**A1P2 is already shipped**: [PR #12](https://github.com/zampolit73/Misdeal/pull/12), native [43 GUT/5752 asserts PASS](https://github.com/zampolit73/Misdeal/actions/runs/39960631781). Its 36 full 12+XIII routes are state-fast-forwards, not real fights.

## A1P3 technical work

[PR #13](https://github.com/zampolit73/Misdeal/pull/13) was **merged** into `main` as `f30e008`. [Final official Godot 4.7.2 CI run 39964999071](https://github.com/zampolit73/Misdeal/actions/runs/39964999071): **48/48 GUT, 5,860 assertions, eight native smoke checks PASS**. It is an A1P3 CI handoff pilot. In `tests/unit/test_act1_player_handoffs.gd`, five tests instantiate **actual** Godot 4.7.x ActChoice/Table/Battle/Reward/RunEnd scenes and the original autoload RunState:
- resolve a real opening event through its ActChoice handler, then next Table deal;
- choose a real combat card/encounter, pass its production Battle result handler with **an explicitly injected victory**, open actual Reward, verify first-tier major upgrade then regular loot / next deal;
- fast-forward 12 real Fate offers using production RunState, then Boss XIII Battle result → reward → actual RunEnd scene (injected win);
- battle loss → offered one-time Last Deal, refusal → real defeat RunEnd;
- scripted but genuine chained-prisoner event → Knight recruitment and rescue scar.

These **do not** simulate real combat results, damage, event UI clicking and route pacing. Existing CI4/CI5 are native live-battle sampled evidence; no automated suite replaces playing F5 through Act I.

The first A1P3 PR native CI caught 11 pre-existing Godot warnings each time Battle UI was instantiated: `battle_ds3_pass.gd` assigned `size` after opposite full-rect anchors on six panel reliefs + five tactic reliefs. The minimal code fix removes those redundant writes; only UI decoration geometry is touched. No encounter balance, player rules or approved artwork changed. Initial [failed CI 39964235068](https://github.com/zampolit73/Misdeal/actions/runs/39964235068) showed **45/48 tests passed** functionally, with three GUT Battle instantiation tests failed only by these captured warnings. The original red is fixed; the final code is green and merged.

## Exact next required step

1. **Shipped**: green final PR #13 CI (48/48 GUT, 5,860 assertions, eight native smoke checks), merged `f30e008`.
2. **Next user action:** `git pull`, run **normal F5**, follow [A1P3 local playtest checklist](A1P3_LOCAL_PLAYTEST.md). One Knight full run through XII + XIII is the minimum; separate loss / Last Deal and organic recruitment routes when possible. Collect outcome, rewards, screen transitions, difficulty and the top three friction points.
3. **Do not** mark experiential A1P3 COMPLETE before actual user F5 feedback. Next A1P4 is possible pacing/repetition review, NOT automatic deck reweighting.

## Locked constraints

Godot 4.7.x + GDScript, original 12 preboss slots and Bone Warden XIII, solo/duo/trio, DS3 and accepted D344R2/D345 artwork unchanged. Existing test editor plugin and QA Hub remain. Connected GitHub is available; do not ask user to reattach it. Do not propose mechanical or artwork changes as a byproduct of the test harness.
