# D208 — Road of Black Lanterns: focused lanternlight balance candidate

Date: 2026-10-17. **Baseline D207 native PASS; D208 +22% user-native F6 PASS; numeric experiment rejected and reverted to +16%.** Act1 normal pool remains **37/45**, `black_lantern_road` is QA-only.

## D208 — user-native rerun PASS, +22% experiment reverted

Date: 2026-10-17. The user ran the same deterministic F6 `res://scenes/dev/black_lantern_road_battle_matrix.tscn` again after enabling +22% illuminated-enemy attack speed. Screenshot reports **D208 FUNCTIONAL PASS, 54/54 complete, 54 wins, 0 defeats, 0 timeouts**. Per party size solo/duo/trio 18/18/18 wins, per Knight/Ranger/Mage 18/18/18; mean surviving HP **80/70/74%**, worst **52/30/44%**, hero losses **0/2/4**, durations **13.2/14.6/13.3 sec**. All of those displayed metrics were identical (to displayed precision) to the user-native D207 +16% baseline. D208 counters: **90 warnings**, **11,433 active frames** (D207 11,434), **15,510 buffed-enemy frames** (D207 15,502), peak **3 lit enemies**, **635 real enemy attacks total, 59 attacks with a lantern speed bonus (9.3%)**. D207 did not count real attacks, so do not assert an exact before/after attack-count comparison.

Interpretation: The +22% experiment made no *observed* difference to the aggregate HP/duration/wins at displayed precision. Only 59/635 enemy attacks were made while accelerated; in this short fight increased cadence is therefore unlikely to meaningfully improve engagement. **Do not continue inflating enemy stats or light attack-speed numerics without visual/real combat evidence.** Reverted **only** `BlackLanternLightController.ATTACK_SPEED_MULTIPLIER` from 1.22 back to the **previous user-native-validated 1.16** in commit `cc624e3`. The D208 diagnostic_attack instrumentation remains in `scripts/dev/black_lantern_road_battle_matrix.gd` for future balance work. The reverted exact parameter is covered by the earlier D207 Godot test, but **no new post-revert D208 instrumented Godot run has been performed**. D208 +22% variant itself is user-native PASS; **this is not full balance approval**, much less release.

Next milestone: prioritize **exact user-selected third moonlit forest arena asset** (`лунная_дорога_через_туманный_лес.png`, 1672×941; source conversation artifact), import exact source-derived 1280×720 WebP as original art **only via supported authenticated GitHub asset transfer** (the connected GitHub creator accepts UTF-8 text; approved binary not committed yet). Then native scene QA for boot-floor clearance and telegraphed moving light/readability; check moving light paths against actual early/late skeleton movement before deciding whether to retune zones/timing. Five original skeleton animation sheets are still blocked by frame-edge cropping and the Sentinel axe/spear mismatch. Do not substitute prior backgrounds, doodles or unapproved art. Continue with true Battle→Reward→Table and full-pool smoke only after original art QA. Live pool remains **37/45**, `КАРАМБА73` untouched.


## Locked observed D207 native results

User screenshot of `res://scenes/dev/black_lantern_road_battle_matrix.tscn` explicitly shows `D207 / ФУНКЦИОНАЛЬНЫЙ PASS — БАЛАНС НЕ ПРИНЯТ`. This was an actual Godot run using staged five enemy UnitData and real BattleUnit simulator (not the ordinary production Battle scene).

| Metric | Solo | Duo | Trio |
|---|---:|---:|---:|
| Wins | 18/18 | 18/18 | 18/18 |
| Average surviving HP (per hero) | 80% | 70% | 74% |
| Lowest surviving HP | 52% | 30% | 44% |
| Average duration | 13.2s | 14.6s | 13.3s |
| Fallen heroes (individuals, NOT party defeats) | 0 | 2 | 4 |

Total 54 wins, zero party defeats, zero timeouts. Per protagonist Knight/Ranger/Mage 18/18/18 wins. Light: **90 telegraph warnings**, **11,434 active frames**, **15,502 buffed-enemy frames**, at most 3 buffed enemies at once. These are actual user-observed statistics, not outputs from an assistant engine run. NOTE: `buffed-enemy frames` counts unit-frame exposures; it does NOT prove that an actual attack occurred during the buff.

Interpretation: D207 is tactically functional, moderate rather than trivial. The closest previously released D153 battle matrix had 74/67/74% average HP; D207's 80/70/74% is close, so no across-the-board HP/damage inflation. Solo safety is crucial under project's real solo compensation. Visual art, playability, tactical readability and real Battle→Reward→Table are **NOT APPROVED**.

## D208 single-variable balance experiment

The only gameplay parameter change is the **encounter-local illuminated-ENEMY attack speed multiplier**:

- D207 `BlackLanternLightController.ATTACK_SPEED_MULTIPLIER = 1.16`
- D208 candidate **1.22** (lit-enemy attack interval divides by 1.22). This increases extra risk only when skeletons are **inside two moving telegraphed light pools**. NO always-on buff, no change to five UnitData stats, wave effects or tactical orders.
- Light telegraph 1.4s, active 3.1s, rest 1.8s, zone center/radius and enemy-only checks remain identical. Previous solo/duo/trio pressure should change only locally. A clear warning grants opportunity to observe/respond in future fully visible battle.
- Changed `scripts/battle/black_lantern_light.gd` only for the candidate multiplier. Not wired to released encounters or ordinary card pool.

The existing D207 54-case test scene `res://scenes/dev/black_lantern_road_battle_matrix.tscn` is now labelled **D208** so the identical deterministic seeds and geometry provide apples-to-apples output. It additionally connects the REAL `BattleUnit.diagnostic_attack` signal for enemy attackers and records *actual attacks made while the attacker has the illumination-based reduced attack interval*. This gives `enemy_attacks` and `lit_enemy_attacks`; the test now fails if no actual lit enemy attack occurred. No hero/boss/AI code was modified. The GDScript signal connection is source-reviewed, **not native-tested**.

### Next gate / user action

1. `git pull`
2. F6 **the SAME** `res://scenes/dev/black_lantern_road_battle_matrix.tscn`.
3. Share the D208 screenshot showing all 54 outcomes, HP and new `Атаки врагов` line.
4. Compare to D207. If solo becomes untenable or duo/trio losses/spikes high, adjust ONLY this controller bonus. Otherwise retain the provisional value for the real encounter integration pass.

**Functional 54/54 does not equal balance approval.** The chosen THIRD 1672×941 full-scene forest arena `лунная_дорога_через_туманный_лес.png` still requires exact binary import, native foot/HUD QA. Five skeleton atlases remain unapproved due to frame-edge bleed and wrong Road Sentinel axe (needs spear). Do not switch in placeholders silently. Real Battle→Reward→Table and ordinary full-pool smoke still pending. Frozen `backups/KARAMBA73-2026-10-16` untouched.
