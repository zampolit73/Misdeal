# Misdeal — D138 Gameplay 2.2 baseline combat results

Date: 2026-10-13  
Status: **measured / user-provided CSV; review recommendations only, no gameplay retuning yet**  
Data: the user uploaded `misdeal_tactical_v22_battles.csv` produced by Godot 4.7.x F6 `res://scenes/dev/tactical_gameplay_v22_battle_benchmark.tscn`. Source CSV has **72 unique entries**, no timeouts. Do not confuse this with the script `.gd` or with the earlier screenshot-only aggregate.

## Test contract / limits

This is controlled, isolated baseline `BattleUnit` simulation: four existing EncounterData cards, both fixed positional variants, solo/duo/trio and ASSAULT/HUNT/FORMATION = 72 runs. Each set of three orders has identical hero roster, initial positioning, card layout and seeded RNG; across different variants and party sizes the protagonist rotates. No items, hero upgrades, Wizard Debt/Mark/Wager, full battle scene/intro/reward flow, boss XIII, or Act 1 build progression. Each scenario/order combination is represented **once**. Treat the 31/72 ratio as a description of this test matrix, **not a statistical probability of winning regular runs**. Stage-2 fights are especially underpowered in this naked baseline; do not make global enemy nerfs based solely on these numbers.

All 72 battles ended normally in F6: **31 win, 41 loss, 0 timeout**.

## Outcomes by original card

| Encounter ID (display) | Actual card tier (0-based) | Wins | Original layout | Alternate layout | Avg simulated battle seconds, all |
|---|---:|---:|---:|---:|---:|
| `gallows_volley` (ЗАЛП С ВИСЕЛИЦЫ) | 1 | 16 / 18 | 9 / 9 | 7 / 9 | 14.9 |
| `last_bell` (ПОСЛЕДНИЙ ЗВОН) | 1 | 12 / 18 | 6 / 9 | 6 / 9 | 14.9 |
| `ossuary_gate` (ВРАТА ОССУАРИЯ) | 2 | 2 / 18 | 0 / 9 | 2 / 9 | 16.6 |
| `firing_square` (РАССТРЕЛЬНАЯ ПЛОЩАДЬ) | 2 | 1 / 18 | 1 / 9 | 0 / 9 | 12.2 |
| **All** | — | **31 / 72** | **16 / 36** | **15 / 36** | **14.7** |

Tier 1 subtotal **28/36 wins (77.8%)**, tier 2 **3/36 (8.3%)** without build progression. The stage difference is a warning for the next *stage-aware* test, not proof that late cards are overtuned in real runs. Across all cards layout 1 vs 2 is very similar in aggregate (16 vs 15 wins), while `ossuary_gate` differs (0 vs 2) and `firing_square` remains almost unbeatable in either configuration at baseline.

## Tactical order comparison

| Encounter | ASSAULT | HUNT | FORMATION |
|---|---:|---:|---:|
| `gallows_volley` | 6 / 6 | 4 / 6 | 6 / 6 |
| `last_bell` | 6 / 6 | **0 / 6** | 6 / 6 |
| `ossuary_gate` | 1 / 6 | 0 / 6 | 1 / 6 |
| `firing_square` | 0 / 6 | 1 / 6 | 0 / 6 |
| **Total** | **13 / 24** | **5 / 24** | **13 / 24** |

The strongest controlled head-to-head evidence is `last_bell`: all **6/6** matched situations win with ASSAULT, all **6/6** win with FORMATION, all **6/6** lose with HUNT, regardless of the two formations and three party sizes. Across all cards HUNT loses in **9 matched conditions where both other orders win**. This is more informative than comparing unrelated rows. In the current `scripts/battle/unit.gd` `_find_hunt_enemy()`, target ranks trump distance: any support healer (rank 0), then any unit with minimum_range (rank 1), then melee (rank 2), with distance considered only *within the same rank*. This is a concrete candidate to investigate: melee heroes may pursue deep support at excessive distance instead of surviving the immediate frontline. It is **a hypothesis about mechanism**, not proven root cause from outcome CSV alone. Do not remove the intentional support-target priority entirely: HUNT should still have an intelligible use.

## Party-size comparison (not controlled for hero class across rows)

| Party | Wins | ASSAULT | HUNT | FORMATION |
|---|---:|---:|---:|---:|
| Solo | 13 / 24 | 5 / 8 | 3 / 8 | 5 / 8 |
| Duo | 9 / 24 | 4 / 8 | 1 / 8 | 4 / 8 |
| Trio | 9 / 24 | 4 / 8 | 1 / 8 | 4 / 8 |

Solo appears stronger under the current naked baseline, consistent with existing solo compensation, **but confounded by the selected protagonists and no Act 1 items**. Do not conclude that duo/trio are globally weaker or change solo scaling on this evidence.

## Recommendations — require user agreement before production tuning

1. **Investigate HUNT targeting behavior first** because `last_bell` has perfectly matched 6-vs-0 order divergence. Design a small, inspectable accessibility/near-threat priority for *melee* units when a support target is far behind the frontline, keeping ranged Ranger/Mage and explicit HUNT role meaningful. Compare old/new under the same case seeds and prevent HUNT from universally dominating ASSAULT/FORMATION. No random enemy roster changes, new orders or visuals.
2. **Make the benchmark stage-aware** before nerfing `ossuary_gate` or `firing_square`: simulate plausible tier-2 hero upgrades/artifacts (using actual `RunState` data / existing resource stats) and check sensitivity with representative heroes, several seeds, order and formation. Without real build progression their 2/18 and 1/18 baseline results are not enough to justify stat cuts.
3. Then validate four fights in normal Act 1 with preparation hints, initial target preview, actual heal/retreat behavior, reward, return, and solo/duo/trio where feasible.
4. Only after stage-aware F6 + hands-on evidence: make targeted encounter-local adjustments (not global enemy classes) if needed, retaining each original card enemy composition and DS2 art.

**Current source:** `zampolit73/Misdeal` `main`, D138 scripts and encounter resources. D136 48-run deal smoke, D137 54-preparation smoke, and D138 72-combat smoke already user-confirmed PASS. No implementation is authorized by this analysis-only report.
