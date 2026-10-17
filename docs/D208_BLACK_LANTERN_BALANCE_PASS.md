# D208 — Road of Black Lanterns: focused lanternlight balance candidate

Date: 2026-10-17. **Baseline D207 native PASS; D208 source staged for native re-test.** Act1 normal pool remains **37/45**, `black_lantern_road` is QA-only.

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
