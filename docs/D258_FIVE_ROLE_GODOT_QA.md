# D258 — Five original Black Lantern characters in real Godot battle QA

Date: 2026-10-19. Branch: `main`. **TECHNICAL GODOT 4.7.2 PASS; native artistic/full Fight→Reward→Table QA pending.** [GitHub Actions evidence](https://github.com/zampolit73/Misdeal/actions/runs/39203396451).

## What is in GitHub

- **D258 rich five-character isolated combat:** `res://scenes/dev/black_lantern_d258_five_enemy_combat_qa.tscn`. Real 3 heroes vs 5 distinctly authored enemies (Guide, Lantern Bearer, Road Sentinel, Oil Acolyte, Lantern Archer); both enemy layouts, scoped D206 lanternlight, restart and readability controls.
- **D258 full genuine Battle-route F6:** `res://scenes/dev/black_lantern_d258_real_battle_route_qa.tscn`. Select solo/duo/trio and March/Crossroads, then play normal Battle with preparations/tactics and continue through Reward to Table.
- `scripts/dev/black_lantern_d258_qa_art.gd` validates all three `*_d257_seam_recovery_qa.webp.b64` original 25-cel rich SpriteFrames. The Guide and Archer source images face LEFT, so the QA loader flips their individual cells into RIGHT-authored format in memory for the unchanged `BattleUnit` facing logic. Acolyte is already right-authored.
- Pre-existing D244 Sentinel/D224 Bearer are unchanged. Historical D249/D254 isolated QA remains available for comparison. **No shared animation library registration of three unfinished roles.**

## Real official Godot 4.7.2 CI evidence

[GitHub Actions run #39203396451](https://github.com/zampolit73/Misdeal/actions/runs/39203396451) passed engine source import/GDScript parser, isolated 3v5 runtime, genuine Battle-launcher scene load, and a new **real Battle preflight**. The preflight starts the actual Battle scene through the QA launcher with **trio + formation 1**, verifies 8 real BattleUnits, five exact distinct original enemy roles, injected D257 25-frame animation states, configured D253 light controller and 37-card released pool. Preflight **does not click Fight or finish Reward/Table**.

The existing Godot BattleUnit balance matrix ran with the same original five enemy UnitData, localized light, party-size normalization, 3 protagonist choices, 2 formations, and 3 tactics: **54/54 cases, 54 wins, zero party defeats/timeouts, zero contract failures**. Wins: 18 solo, 18 duo, 18 trio; 18 Knight, 18 Ranger, 18 Mage. Hero deaths as individuals: 0/2/4 (solo/duo/trio). Latest CI sample: 635 enemy attacks, 52 under light, 89 warnings, 11,494 active steps. Earlier passing run had 53 accelerated attacks; **do not assert exact light attack counts are deterministic**. 54/54 wins are functional QA only, **not approved difficulty**.

CI import also reports a separate pre-existing issue with `res://assets/concepts/approved_battle_direction.jpg`; not changed by D258, did not block these test scenes, but full project import is not warning/error-free.

## Single next Godot user test

1. `git pull`; open `res://scenes/dev/black_lantern_d258_real_battle_route_qa.tscn`, press **F6**.
2. Select **3 heroes / Перекрёсток**, click `ЗАПУСТИТЬ НАСТОЯЩИЙ БОЙ`. Inspect five original sprites at true battle scale, prop attachment (3 Guide lanterns, Acolyte burner, Archer bow), facing, floor contact, HP labels and lit enemies. Complete **Fight → Reward → Table**.
3. Restart F6 for **solo or duo / Марш** and verify a different party/formation, reward route if won, and whether battle is too easy. Send one combined observation/video rather than 75 individual approvals.

Remaining gates: user-native visual motion check (D257's 11 original lower-source seam warnings still merit attention), full real route, crowding and difficulty pass, then potential shared registration and card #38 release. **Act1 LIVE 37/45; card #38 NOT in ACT1_CARD_IDS.** DS2, D209/D253, accepted D244/D224 and frozen KARAMBA73 unchanged.

## Supporting files

`scripts/dev/black_lantern_d258_battle_preflight.gd`; `scripts/dev/black_lantern_d258_native_balance_matrix.gd`; `docs/qa/D258_GODOT_54_CASE_RESULT.json`; `.github/workflows/d258-black-lantern-native-smoke.yml`; D257 original art and QA `docs/D257_THREE_ATLAS_SEAM_RECOVERY_QA.md`.
