## 2026-10-15 — D152 RELEASED as Act1 card 35/45 (post-release native check pending)

**Verified before release:** user Godot screenshot of the **POST-TUNE** 54-case D152 combat matrix: 54/54 FUNCTIONAL PASS, 54 wins/0 losses; average remaining HP **70% solo / 57% duo / 60% trio**; hero casualties **0/4/4**; average duration **10.8/12.2/10.9s**, longest **16.6s**; tactics ASSAULT/HUNT/FORMATION each 18 victories, remaining HP **70/49/69%**; acid warnings **73**, hits **512**, spills **108**. This is the current result, not the old 67/435/14.9 pre-tune screenshot. The measured attrition is enough to release this Tier1 candidate without further buffs; technical 100% test wins are **not balance certification**. Approved original 448×274 card illustration and both 25-frame enemy atlases are in GitHub, and user previously accepted dev-preview real win→reward→table.

**RELEASE IMPLEMENTED IN MAIN:** `scripts/core/run_state.gd` now puts `defiled_laboratory` into `ACT1_CARD_IDS` (35 unique nonboss Act1 cards total; the 12+sealed XIII run length is unchanged). D152 remains in `CARD_PATHS`; do not add it twice. Updated 35-card assertions in `bone_shepherd_smoke.gd`, `funeral_procession_smoke.gd`, `last_rite_smoke.gd`, `defiled_laboratory_smoke.gd`, `defiled_laboratory_battle_smoke.gd` and adjusted `defiled_laboratory_playtest.gd` / `defiled_laboratory_card_preview.gd` to continue functioning after release. Other enemies, global multipliers, tactics, D143 originality, DS2 and Fate Spread untouched.

**Important qualification:** New 35-card pool code was reviewed/committed but **has not been rerun in the user's native Godot after activation**. The earlier D152 54-case F6 and dev real fight confirmations occurred **before** the card was placed into the live deck. Next user action: `git pull`, launch Godot and play a normal run / verify no new errors. No ZIP, PowerShell or manual edits. If any regression appears, assistant fixes it directly via connected GitHub. Next expansion target is **36/45** (10 remaining).

---

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
