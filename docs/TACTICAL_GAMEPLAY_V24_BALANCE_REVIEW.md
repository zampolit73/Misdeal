# Misdeal — D140 Gameplay 2.4 actual 270-fight outcome review

Date: 2026-10-13  
Status: **measured from user-supplied actual `misdeal_tactical_v24_party_focus.csv`; documentation/analysis only — no new balance changes authorized or implemented**  
Context: `docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`, `docs/DECISIONS.md` D139–D140, `scripts/dev/tactical_gameplay_v24_focus_party_benchmark.gd`.

## Validation of source CSV

- **270 rows, 12 columns**, all populated; **158 wins, 112 losses, 0 timeouts**, unique complete match keys.
- Three encounters: `last_bell` 54 **bare** cases, `ossuary_gate` and `firing_square` 108 cases each with illustrative **tier2_built** (one existing upgrade per active hero, class-specific artifact for protagonist). Unlike D139, later cards have **no bare profile** in D140.
- Every authored layout (1/2), protagonist (Knight/Ranger/Mage), party size (1/2/3) and order (ASSAULT/HUNT/FORMATION) included. Two seeds per late-stage case. Same protagonist is preserved across party sizes; duo/trio add companions in fixed cyclic class order. `party_roles` field makes compositions explicit.
- Durations **8.8–29.9 simulated seconds**, mean **16.7 seconds**. All wins had 0 enemy survivors and all losses 0 hero survivors. No duplicate scenario/order keys.
- Godot F6 screenshot independently confirmed **TACTICAL GAMEPLAY 2.4 — PASS**, including two bellkeepers' shared initial target, wounded-healer priority, and Knight close-threat interception.
- **Not** a normal player-run win rate: the test uses deterministic fixed positions, limited two seed variations, fixed illustrative upgrades/artifacts, no Wizard stakes, reward flow, party history or XIII boss; 270 entries are *not* independent samples of real progression.

## 1. Outcomes by existing encounter and tactical order

| Existing encounter | ASSAULT | FORMATION | HUNT | Total |
|---|---:|---:|---:|---:|
| `last_bell` (Последний звон; bare) | **18/18** | **18/18** | **4/18** | **40/54** |
| `ossuary_gate` (Врата оссуария; equipped) | **21/36** | **22/36** | **8/36** | **51/108** |
| `firing_square` (Расстрельная площадь; equipped) | **28/36** | **27/36** | **12/36** | **67/108** |
| **All** | **67/90** | **67/90** | **24/90** | **158/270** |

**Strictly paired order comparison:** across all **90** otherwise identical encounter/layout/hero/party/profile/seed cases, HUNT never wins when ASSAULT loses (**0**), whereas ASSAULT wins and HUNT loses in **43**. In **41** identical cases both ASSAULT and FORMATION win but HUNT loses. Thus HUNT is strictly **outcome-dominated by ASSAULT in this controlled test matrix**, even though its targeting fixture passed; a shared priority focus is mechanically functional but does not automatically improve tactical outcome. In `last_bell`, HUNT **4/18** while ASSAULT and FORMATION both **18/18**. Test code makes HUNT select healer then ranged first, preferring wounded members and a common party centroid; this is a plausible culprit when the party runs toward defended/distant supports, not definitive proof of the loss mechanism.

HUNT by party size: solo **22/30**, duo **2/30**, trio **0/30**. ASSAULT: solo **30/30**, duo **15/30**, trio **22/30**. FORMATION: solo **30/30**, duo **13/30**, trio **24/30**.

**Do not directly compare win count 4/18 with D139 `last_bell` 1/6** as causal improvement: D139 rotated protagonist across layouts/party counts and used different seeds; D140 systematically tests all three protagonists for each size. Existing D139 analysis had originally shown strict v22-v23 same-case improvement 5/24→8/24 for melee interception. D140's new sample matrix is **not matched with D139**, so source screenshots/aggregates cannot prove the effect of shared focus versus the old selector. If needed, add same-seed old/new selector A/B harness before further production retuning.

## 2. Same-protagonist party-size comparisons

| Party size | All cases | Late equipped only |
|---|---:|---:|
| Solo | **82/90** | **68/72** |
| Duo | **30/90** | **16/72** |
| Trio | **46/90** | **34/72** |

The protagonist is fixed for each card/layout/seed/order when comparing 1→2→3 heroes; partners are deterministic. Among **90 paired scenarios**, solo wins but duo loses **54** times; duo loses but trio wins **18** times. Thus the stage-2 *build and party setup used by this benchmark* show a severe, repeated non-monotonicity. Do not interpret as a pure causal isolated defect in one multiplier: adding heroes changes attack targeting, unit positions, upgrades/artifacts, survivor mechanics, enemy party-size pressure and synergy. Solo has strong explicit compensations (and weaker enemies), duo/trio do not. Need follow-up targeted diagnostic and real Act 1 observation before changing global coefficients.

| Protagonist | Solo wins | Duo wins | Trio wins |
|---|---:|---:|---:|
| Knight | **30/30** | **4/30** | **6/30** |
| Ranger | **28/30** | **12/30** | **20/30** |
| Mage | **24/30** | **14/30** | **20/30** |

Within **late equipped only** (24 samples per size and protagonist):

| Protagonist | Solo | Duo | Trio |
|---|---:|---:|---:|
| Knight | **24/24** | **0/24** | **2/24** |
| Ranger | **24/24** | **8/24** | **16/24** |
| Mage | **20/24** | **8/24** | **16/24** |

The **Knight-plus-Ranger duo** is 0/24 wins under these two late encounter cards and built loadout, a particularly useful reproduction target. Knight trio is 2/24. This is much more specific than assuming every duo or trio is underpowered in regular play.

Late per-card / party: `ossuary_gate` solo 32/36, duo **1/36**, trio 18/36; `firing_square` solo **36/36**, duo 15/36, trio 16/36. These are **descriptive benchmark totals**, not live Act 1 difficulty.

## 3. Placement and seed checks

| Encounter | Original formation | Alternate formation |
|---|---:|---:|
| `last_bell` | 20/27 | 20/27 |
| `ossuary_gate` | 24/54 | 27/54 |
| `firing_square` | 34/54 | 33/54 |
| **All** | **78/135** | **80/135** |

No apparent aggregate regression from alternate layouts. Both late seeds give equal win/loss in **106 of 108** matched cases (two differences); elapsed simulated times differ in 86/108 pairs. This is a compact deterministic harness, not a strong probabilistic win-rate survey.

## 4. Interpretation & next project step

**Confirmed:** D140 code compiles and HUNT target-selection preview checks PASS in Godot, and all 270 controlled combats complete.  
**Also confirmed:** within this test matrix, HUNT is strictly outcome-dominated by ASSAULT; class-fixed late-stage duo/trio performance is much worse than solo and **Knight duos in the tested loadout are 0/24**. Neither issue should be declared 'fixed' by the PASS screen.

**Recommended next milestone, only with explicit user authorization:**
1. Before another HUNT heuristic change, instrument the `last_bell` tactical fights for **real-time target changes, distance-to-priority, attacks attempted/landed, support healing and hero damage**. Use an optional dev-only trace or paired old/new selection comparator with identical seeds and party rosters. Distinguish over-pursuit/split focus from a damage/position issue, and ensure any HUNT tweak makes it situationally useful rather than globally dominant.
2. In the **same controlled tier2 loadout**, repro Knight (solo, Knight+Ranger, Knight+Ranger+Mage) against `ossuary_gate` / `firing_square` using identical encounter/layout/seed; inspect underlying hero/enemy scaling, safe melee/ranged spacing and attack/target cohesion. Only after evidence consider changes in tactical selection, prepared layouts, hero loadout incentives or transparent scalars.
3. **Prioritize an actual full Act 1 run** with Wizard risks, earned upgrades/rewards, and the boss XIII. These isolated deterministic benchmarks cannot alone certify actual run balance. Preserve original card-based enemy compositions, all 7 two-layout cards, DS2/Fate Spread Variant C, 18 approved arts and established card identity.
4. Do **not** randomly swap card opponents, globally nerf late enemies, or alter combat coefficients on this dataset alone.

No source code or art changed in this report.
