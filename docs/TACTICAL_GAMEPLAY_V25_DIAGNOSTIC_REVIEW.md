# Misdeal — D141 Gameplay 2.5 measured combat diagnostics

Date: 2026-10-14  
Status: **analyzed actual user-provided CSVs; no combat rebalancing implemented**  
Godot scene: `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`  
Inputs: user-provided `misdeal_tactical_v25_trace_cases.csv` and `misdeal_tactical_v25_trace_units.csv`. Historical comparison: user v24 `misdeal_tactical_v24_party_focus.csv` and `docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`.

## Validation / integrity

- **126 case rows × 21 fields**, **792 unit rows × 21 fields**, no missing/null values. `last_bell` **54** bare cases; `ossuary_gate` **36** and `firing_square` **36** Knight-led tier2_built cases.
- **66 victories / 60 defeats; 0 timeouts** in this 126-case subset. All **126** keys `encounter,variant,party_size,protagonist,party_roles,order,profile,sample` match exactly **one** row in the previous actual **270-case v24** source CSV. **Outcomes identical in all 126 cases and simulated durations identical to 0.1 s in all 126**. Instrumentation did not change the measurable game behavior in these exact cases.
- Per-unit sums equal corresponding case-level hero attacks, support attacks, hero damage, enemy damage, enemy healing, chase time, support focus time, target switches and travel **exactly within stored precision** (max discrepancy zero). Every case has full unit coverage. This verifies signal collection/writing, not actual Act 1 progression or all global combat behaviors.
- The trace counts `diagnostic_attack` on actual attack execution, `diagnostic_damage` on actual HP removed by primary/splash attack, and `diagnostic_heal` on actual restored HP. Chasing and targeting are sampled after each manually advanced 30-FPS simulation step, summed over living hero units; combined hero-seconds can exceed a battle's wall-clock seconds. Attacks are executed strikes, not misses/attempts, and equal duration comparisons do not guarantee the same survival timeline.

## Finding A — `last_bell` HUNT fails due to fewer attacks and much higher exposure, not merely longer chasing

Exactly the 54 original v24 cases: 2 layouts × 3 protagonists × 3 party sizes × 3 orders.

| Metric, mean per battle (18 per order) | ASSAULT | FORMATION | HUNT |
|---|---:|---:|---:|
| Victories | **18/18** | **18/18** | **4/18** |
| Executed hero attacks | **18.78** | 18.39 | **12.78** |
| Executed primary attacks against bellkeepers | 12.89 | 12.61 | **8.72** |
| Effective hero HP damage (all targets) | **394.69** | 387.79 | **281.14** |
| Effective enemy HP damage to heroes | **102.51** | 106.47 | **233.93** |
| Bellkeeper effective HP recovery | 25.71 | 18.80 | **41.41** |
| Summed hero chase seconds | **13.00** | 14.63 | **13.14** |
| Summed hero support-target seconds | **21.23** | 22.29 | **21.53** |
| Target switches | 5.11 | 6.61 | 3.11 |
| Fight seconds | 16.87 | 17.39 | 17.39 |

- Versus ASSAULT, HUNT executes **~32% fewer attacks** (12.78 vs 18.78) and **~29% less actual damage** (281 vs 395), while absorbing **2.28× enemy damage** (234 vs 103); effective bellkeeper healing **1.61× higher** (41 vs 26). Mean **chase time and total battle duration are almost identical**. This rules out the simplistic interpretation "HUNT loses merely because its heroes run for far longer" in the aggregate. It suggests **more exposure to dangerous enemies, interruption/early deaths, and fewer completed strikes**, not yet a unique causal root.
- Within party-size groups, HUNT wins **2/6 solo, 2/6 duo, 0/6 trio**, while each other order wins all 6 in every size. Under HUNT with trio, average enemy damage reaches **320**, bellkeepers restore **74**, and heroes execute **16.17** attacks compared to ASSAULT trio **24.67**. This is a concrete diagnostic for a counterfactual tactical experiment.
- Per-unit trend: HUNT Ranger executes **6.00** attacks on average vs ASSAULT **11.58** and survives **0/12 hero appearances** vs ASSAULT **8/12**. HUNT Mage executes **3.42** vs ASSAULT **6.83**, survives **2/12** vs **9/12**; HUNT Knight executes roughly equal **9.75** vs **9.75** but takes ~151 HP rather than ~73 HP on average. These fractions pool solo/duo/trio appearances, not match-independent survival probabilities. They indicate the ranged members are particularly compromised while HUNT is active, even though HUNT target-preview initially coordinates bellkeeper focus. A coordinated target alone does not protect vulnerable ranged characters or ensure actual DPS throughput.
- Caveat: decreased attacks can be a **consequence** of earlier hero deaths; logs summarize outcomes rather than individual death timestamp and exact retarget event timeline. Avoid claiming hard-coded target rank **alone** causes the outcome, and avoid blindly buffing HUNT attack damage.

## Finding B — late Knight solo/duo/trio is an effective-health and battle-duration mismatch, not proven targeting bug

The **72** fully matched equipped cases: `ossuary_gate` + `firing_square` × 2 layouts × protagonist Knight fixed × solo/duo/trio × 3 orders × 2 seeds. Identical v24 outcomes/durations.

| Knight-led equipped profile | Solo | Knight+Ranger | Knight+Ranger+Mage |
|---|---:|---:|---:|
| Victories | **24/24** | **0/24** | **2/24** |
| Mean heroes' executed attacks / battle | 15.50 | **14.17** | 19.54 |
| Mean effective hero HP damage / battle | **467.81** | **281.27** | 426.53 |
| Mean effective enemy HP damage / battle | 375.73 | 414.00 | 421.08 |
| Mean battle seconds | **26.02** | **18.18** | 19.50 |

- In duo, although there are **two heroes**, the pair executes slightly fewer attacks (**14.17 vs 15.50**) and **~40% less actual damage** than solo (**281.27 vs 467.81**), partly because the battle ends **~7.84 seconds sooner**. The duo's two heroes die in **every** one of the 24 cases.
- Per-unit breakdown (24 cases per affected role): solo Knight **15.50 attacks / 467.81 damage, survives 24/24**; duo Knight **8.62 / 169.77**, dies **24/24**; duo Ranger **5.54 / 111.50**, dies **24/24**. Trio Knight **6.96 / 119.39** dies **24/24**, Mage **2.04 / 126.61** dies **24/24**, Ranger **10.54 / 180.52** survives **2/24**.
- Duo Knight actual HP loss is precisely **306** and Ranger **108** in every defeated case, summed **414**; trio Knight **255**, Mage **80**, Ranger mostly **90**, reflecting their entire effective test-health pools being exhausted by enemy damage. This confirms **defeats by attrition / hero death**, not unresolved target/timeouts.
- Compare official `RunState` multipliers: solo hero HP ×2.2, damage ×1.9, attack interval ×0.8, movement ×1.1 and enemies HP ×0.82 / damage ×0.8; duo hero HP ×1.2, damage ×1.15 and enemies HP ×0.92 / damage ×0.9; trio baseline. The combined effect could make solo **far stronger** than recruiting one companion for this illustrative tier2 build. This is consistent with the measured disparity, **not proof of which particular coefficient causes it**. Other confounds: hero count and separate positions, upgrades and artifact distribution, differing enemy health/damage multipliers, attack order and survival dynamics.
- Breakdown: `firing_square` Knight solo wins 12/12, duo 0/12, trio 0/12. `ossuary_gate` Knight solo wins 12/12, duo 0/12, trio 2/12. The same two seeds often yield identical win/loss due deterministic simulation; **these are controlled test outcomes, not probabilities of real Act 1 victories**.

## Recommended next step, requires new user approval

1. **Do not rewrite HUNT blindly.** Run a narrow **counterfactual A/B** on the *same Last Bell 18 cases* with attack/exposure telemetry: (A) current HUNT, (B) retain current melee interception but temporarily use nearest-threatening-enemy target for the ranged heroes or a soft distance gate to bellkeepers, **dev-only first**. Compare hero attacks, Bellkeeper healing, damage absorbed and win/loss before altering production. Preserve HUNT's promise of targeting support and its distinct role, so if a distance-aware rule helps, apply only as a clear scoped gameplay decision.
2. **Isolate party-pressure scalers versus placement and ally survival** for Knight in the same 24 cases. Dev-only cross-check (same party, same heroic upgrades/positions/seed, adjust a *single* baseline factor per experiment) to identify which part of duo/trio difficulty matters: enemy HP/damage pressure or missing solo survivability. Alternatively compare carefully controlled formation changes. **Do not jump to a global solo nerf** or add enemies.
3. **Regular Act 1 run QA** with actual card deal, earned upgrades, Wizard Mark/Wager/Debt, reward transitions and Bone Warden XIII remains outstanding. The 126-case diagnostic is isolated and does not test the whole progression.
4. Only after experiments + live observations, propose minimum card- or tactic-specific production fixes to user. Maintain existing 7 authored two-layout card compositions and frozen DS2/Fate Spread Variant C/18 approved first-wave arts.

**No new gameplay code, stat changes, card edits or production AI tuning were performed by this analysis.** This report and handoff notes alone changed.
