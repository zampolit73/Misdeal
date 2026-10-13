# Misdeal — D139 Gameplay 2.3 measured balance review

Date: 2026-10-13  
Status: **measured from user-provided 180-row v2.3 CSV and original 72-row v2.2 CSV; analysis only, no further combat changes**  
Test: `res://scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn` / `user://misdeal_tactical_v23_balance.csv`

## What was validated

- Local Godot screenshot showed **TACTICAL GAMEPLAY 2.3 — PASS**, **180/180** completed, **79 wins / 101 losses**, no timeouts, and the explicit Knight HUNT distant-support / near-threat / reachable-support preview regression PASS.
- The actual v2.3 CSV uploaded by the user contains **180 rows, 11 columns, no null values or timeouts**.
- Matrix: `gallows_volley` and `last_bell` (36 bare total); `ossuary_gate` and `firing_square` (144 total with **2 seeds × bare/tier2_built**).
- Each late `tier2_built` case uses **one actual authored hero upgrade per active hero + one class-bound artifact on the protagonist**, an illustrative build **not guaranteed** in a regular Act 1. No Wizard penalties, real sequential progression or reward return; fixed simulated delta.
- 180 experimental combinations are not 180 independent samples of player victory chance. Avoid presenting a matrix ratio as a normal win rate.

## Card results (v2.3 only)

| Encounter | `bare` wins | `tier2_built` wins |
|---|---:|---:|
| `gallows_volley` — Залп с виселицы | 18 / 18 | not tested |
| `last_bell` — Последний звон | 13 / 18 | not tested |
| `ossuary_gate` — Врата оссуария | **6 / 36** | **22 / 36** |
| `firing_square` — Расстрельная площадь | **0 / 36** | **20 / 36** |
| **Total** | **37 / 108** | **42 / 72** |

Stage-2 bare fights: **6/72**; equipped: **42/72**. On the **72 exact matched bare/built late cases**, 36 losses became wins, 30 stayed losses, 6 stayed wins, and 0 wins became losses. This is strong evidence **the existing items/upgrades materially matter**, not evidence that the late enemies should be globally nerfed.

### Late games by party size (both advanced cards combined)

| Party size | Bare | Equipped |
|---|---:|---:|
| Solo | 6 / 24 | **22 / 24** |
| Duo | 0 / 24 | **10 / 24** |
| Trio | 0 / 24 | **10 / 24** |

**CAUTION**: protagonist identity rotates with party size; these are not matched isolated changes in party size. The solo-compensation multipliers and number of upgrades also differ. Still, the very large solo-vs-duo/trio gap under the illustrative build warrants a future strictly controlled test and actual run observation before touching the global solo/duo/trio scalers.

### Tactical orders within equipped late scenarios

| Encounter | ASSAULT | HUNT | FORMATION |
|---|---:|---:|---:|
| `ossuary_gate` | 8 / 12 | **4 / 12** | **10 / 12** |
| `firing_square` | 8 / 12 | **4 / 12** | **8 / 12** |
| **Combined** | **16 / 24** | **8 / 24** | **18 / 24** |

The previous HUNT targeting fix helped baseline, but HUNT remains relatively weak **even with authored upgrades and an artifact**. Most serious repeated case: `last_bell` HUNT still **1 / 6** versus ASSAULT and FORMATION **6 / 6** each, in exactly matched same-seed/same-roster comparisons.

## Strict matched v2.2 vs v2.3 bare regression (72 identical scenario keys)

Historical source: `docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`; original user v2.2 72-row CSV was also available for exact join. Match keys `encounter, variant, party_size, protagonist, order`; take only v2.3 `profile=bare, sample=0`. **All 72 matched**. The unchanged commands ASSAULT and FORMATION have **identical results and mean durations** in these two outputs, a useful regression check.

| Order | v2.2 wins | v2.3 same cases wins |
|---|---:|---:|
| ASSAULT | 13 / 24 | 13 / 24 |
| FORMATION | 13 / 24 | 13 / 24 |
| **HUNT** | **5 / 24** | **8 / 24** |

HUNT has **4 newly won** cases and **1 win→loss** regression, net +3:
- Gains: `gallows_volley` variant 2 duo Mage, `gallows_volley` variant 2 trio Knight, `last_bell` variant 1 duo Mage, `ossuary_gate` variant 2 solo Knight.
- Regression: `firing_square` variant 1 solo Knight (formerly one win, now a loss).
- `last_bell` HUNT **0/6 → 1/6**; still much weaker than the other commands.

The cause is consistent with the fixed `scripts/battle/unit.gd` melee HUNT near-threat interception, but data only proves **effect of the code change on controlled outcomes**, not full tactical optimality in actual Act 1.

## Additional caveats from raw v2.3 rows

- Both stage-2 seeds gave the **same win/loss** for every one of the **72 corresponding pairwise configurations** (though durations may differ); additional repetitions/formation/hero positioning are necessary before statistical balance claims.
- Different encounter layout variants use different protagonist selection in the benchmark, so the observed `ossuary_gate` equipped contrast **6/18 variant 1 vs 16/18 variant 2** is **confounded by protagonist**, and should **not** be blamed on enemy positions alone.
- The same protagonist rotation across party sizes means the large solo-vs-duo/trio result is a warning, not clean causal evidence of a faulty scaler. Changing hero counts inherently changes tactics, but class composition should be independently controlled.

## Recommendations / next approval boundary

1. **Keep D139 melee HUNT interception as implemented** pending live feedback; it yields a net +3 HUNT wins without altering ASSAULT/FORMATION in the directly matched original 72-scenario comparison.
2. **Do not nerf late-stage enemies yet.** Equipped test cases improved from 6/72 bare to 42/72 equipped, so progression matters as designed.
3. **Address remaining HUNT weakness with a focused experiment**: inspect support-healing interplay and whether heroes split targets between the two bellkeepers or repeatedly pursue distant protected support. Design a shared priority/focus or reachable-target selection for HUNT that preserves hero autonomy and distinguishable orders, and compare against all 72 original outcomes before shipping a new production tweak. Note this is proposed, not implemented.
4. **Make a better stage/party balance benchmark before global scaler tuning:** keep identical protagonist and teammate choices when comparing variants; test each protagonist's solo, duo, trio permutations with controlled seeds and representative tier-2 builds. Ideally add actual run progression conditions/Wizard risks or play real Act 1. Focus on the equipped solo 22/24 vs duo/trio 10/24 warning.
5. **Test real Act 1 live**: `last_bell`, `ossuary_gate`, `firing_square`, rewards and return, Fate Spread XIII. Only adjust original-card/local enemy parameters if the measured player journey actually shows an outlier.

### Project invariants

Keep the **exact authored card enemy composition**, 7 existing two-layout cards, DS2 / Fate Spread Variant C and 18 already approved card artworks. Do not add new cards or change enemy lineups implicitly. Current GitHub `main` is source of truth; this document records **analysis, not a new combat-code change**.
