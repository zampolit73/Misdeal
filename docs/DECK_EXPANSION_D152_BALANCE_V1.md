# D152 — Defiled Laboratory: encounter-local challenge pass v1

Date: 2026-10-15
State: **implemented in GitHub main; native Godot F6 recheck pending; NOT live in Act1**.

## Why this pass exists

The user's prior F6 screenshot on the baseline D152 technical smoke showed 54/54 fights completed with **54 wins, 0 losses**, across solo / duo / trio (18 wins per party size). It recorded 67 telegraphs, 435 poison hits, 108 death spills and 14.9s maximum duration. This is valid technical evidence, but does not prove meaningful tactics, difficulty, or a representative campaign outcome.

The user also accepted the original D152 448×274 card picture and reported that the visual preview → real battle → reward selection → return to table worked. This flow was user-reported, not separately instrumented.

## D152-only tuning (candidate, not native approved)

| Parameter | Previous | Candidate v1 |
| --- | ---: | ---: |
| Plague Alchemist max_hp | 92 | **108** |
| Plague Alchemist damage | 6 | **7.5** |
| Unstable Homunculus max_hp (each) | 72 | **84** |
| Unstable Homunculus damage (each) | 8 | **9** |
| Toxic zone cooldown | 5.0s | **4.5s** |
| Toxic pulse damage (per hero in area) | 5.0 | **6.0** |
| Toxic warning duration | 1.2s | **unchanged** |
| Toxic zone duration | 2.2s | **unchanged** |
| Toxic zone radius | 66 | **unchanged** |

The telegraph now selects the **densest cluster of living heroes** within the same 66px radius, breaking ties toward the hero closest to the Alchemist. This is a deliberately bounded tactical change: party spacing and deployment should matter, without changing AI, global damage multipliers, player abilities, tactics or any other encounter. If only one hero lives, the same hero is targeted as before. Poison zones remain visible before their pulses.

Touched only:
- `resources/units/plague_alchemist.tres`
- `resources/units/unstable_homunculus.tres`
- `scripts/battle/laboratory_hazards.gd`
- `scripts/dev/defiled_laboratory_smoke.gd` (cluster regression)
- `scripts/dev/defiled_laboratory_battle_smoke.gd` (cluster regression + metrics)

## Diagnostic instrumentation

F6 `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` runs **2 formations × 3 starting heroes × 3 party sizes × 3 tactics = 54** deterministic cases. Alongside win/loss totals it now displays:
- Avg remaining party HP (%) by solo/duo/trio, including fallen heroes as 0.
- Avg battle duration by solo/duo/trio and longest fight.
- Number of fallen heroes across cases by party size.
- Wins and average remaining HP by ASSAULT / HUNT / FORMATION.
- Chemical telegraphs, damaging hits and on-death spills.
- A deterministic test that clustered heroes are marked instead of an isolated, closer Knight.

The separate `scenes/dev/defiled_laboratory_smoke.tscn` also contains the cluster-target assertion.

**Pass semantics:** 54 cases completed with nonzero warnings and valid unique art = technical functional PASS only. High HP retention despite 54 wins indicates a harmless encounter; high solo losses or consistently lethal toxin indicate overtuning. Neither can be interpreted from baseline win-rate alone. Final difficulty judgment requires reading new HP/time/party/tactic measurements, normal solo play, and user acceptance.

## Release gates

1. User `git pull`, F6 `res://scenes/dev/defiled_laboratory_battle_smoke.tscn` and send screenshot (or failure).
2. Compare results to baseline, inspect solo class disparity, HP loss and tactic differentiation; adjust **D152 data only** if warranted.
3. Keep original approved D152 448×274 card art and 25-frame character atlases.
4. D152 remains lookup-only in `RunState.CARD_PATHS` and **absent from `RunState.ACT1_CARD_IDS`** (34/45), until measured tuning approved and any fixed deck-count tests are updated. Run length is **12+sealed XIII**.
5. D151 real win→reward→table QA is separate and should not be inferred from D152.

No manual ZIP extraction, copying source code, changing scripts locally, or additional PowerShell needed.
