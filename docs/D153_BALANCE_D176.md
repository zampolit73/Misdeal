## 2026-10-15 — D177 D153 MATRIX RESOURCE-LOAD REGRESSION FIX; RETEST PENDING

**User-provided real Godot screenshots:** after D176 local stat tuning, F6 `threadbare_theatre_battle_smoke.tscn` displays **`D153 / THEATRE BATTLE — FAIL`**, `Missing BattleUnit data in D153 matrix`. The diagnostic stopped during setup with a null `UnitData` — **this is not a combat loss or a balance conclusion**. It gave no filename, so the exact null source was not proven by screenshots.

**Probable D176 regression found in GitHub:** D176 inserted `# ...` comment lines **inside the `[resource]` block immediately before `script = ExtResource("1")`** in the two edited D153 enemy `.tres` files. Prior working versions had `script` as the first property. D177 removes these newly inserted lines while preserving all D176 tuned combat stats: Puppeteer HP 142/damage 7.5/interval 1.65/speed 55; Marionette HP 88/damage 10.5/interval 1.22/speed 78. Do not assert resource parsing was conclusively the cause until Godot is rerun.

**Regression detection improved:** `scripts/dev/threadbare_theatre_battle_smoke.gd` now preloads and validates all three hero `UnitData` resources and the two original enemy `.tres` files **before** the 54 cases, reporting exactly which resource fails. The later fixture also identifies hero role/enemy resource rather than only `Missing BattleUnit data`. 54-seed coverage, real BattleUnit/tether, win/loss/HP metrics and balancing warnings remain unchanged.

**NEXT:** `git pull`; F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn` and send the updated output. If still failing, the new output should name the specific missing hero/enemy resource. If 54 cases complete, inspect win rates/HP for safe solo, duo, trio balance, then briefly repeat real `res://scenes/dev/threadbare_theatre_playtest.tscn` to verify combat feel. **D153 is still QA-only, Act1 35/45; do not enable #36 on the failed test.** Native D176/D177 post-tune matrix PASS is not claimed.

---

# D153 / D176 — Local challenge tuning & release readiness

Status: **source-integrated to main, post-tune native Godot matrix pending**.

## Why

The original scene and Reward→Table flow work in Godot, but the user confirmed the fight feels too easy. The **pre-tune** 54-case matrix returned **54/54 player victories**, mean surviving HP **85 / 82–83 / 86%** (solo/duo/trio), **11.2 / 12.2 / 11.5s** fight durations, two hero deaths in trio cases, and **123 / 92 / 54** tether joins/separations/master death breaks.

This establishes a safe previous functional baseline, **not** the result of the tuned matrix.

## D176 source changes

| D153-only stat | Master before → after | Marionette before → after |
| --- | --- | --- |
| HP | 108 → **142** | 71 → **88** |
| Damage/hit | 5.5 → **7.5** | 8.5 → **10.5** |
| Attack interval (s) | 1.80 → **1.65** | 1.33 → **1.22** |
| Movement speed | 51 → **55** | 73 → **78** |

This raises damage cadence and time-to-kill without changing the encounter's cast (1 master + 2 skeletal minions), two formations, source art or attack identities. The thread effect remains **32% damage mitigation within 285px, immediately removed at master death and on distance break**. No changes to global scaling, hero stats or other fights.

Simple *theoretical* stationary raw DPS of this 3-unit enemy group rises from `(5.5 / 1.80) + 2 × (8.5 / 1.33) ≈ 15.84` to `(7.5 / 1.65) + 2 × (10.5 / 1.22) ≈ 21.75`, about **+37%**; real combat pressure depends on movement, target choice, tether links, deaths and party mix. It is **not** a prediction of win rates.

## Actual required QA before activating card #36

1. `git pull`, F6 `res://scenes/dev/threadbare_theatre_battle_smoke.tscn`. The matrix still runs **2 formations × 3 protagonists × 3 party sizes × 3 tactics = 54 cases**, records real win/loss, average and worst HP per party size, all three class win counts, runtime and link/break counters. No timeouts, no missing sprites or arena, no tether state leakage; at least one victory with solo, duo and trio. A new warning flags old too-easy pattern (54 wins and HP ≥80%) or potential over-tuning (fewer than 40 wins). Warnings require interpretation, not immediate mechanical rollback.
2. F6 `res://scenes/dev/threadbare_theatre_playtest.tscn` — real 1280×720 D153 fight. Did targeted focus on the crowned Puppeteer matter? Did marionettes feel threatening but fair, especially to solo? Any clipping or reward/table regression? Ask for a brief qualitative verdict; user previously confirmed the real route working before stat changes.
3. If the new result is comfortable and user accepts difficulty, assistant enables ONLY `threadbare_theatre` in `RunState.ACT1_CARD_IDS` (36/45), updates the Dev matrix's pool-guard to the new expected status if necessary, and checks normal random deal/Reward/Fate Spread without changing 12-slot + XIII semantics.
4. Keep source parameters and results in handoff; if issues arise, tune ONLY D153 `.tres` resources and rerun the 54-case suite. Do not buff the rest of Act 1.

**No Godot engine is present in this assistant environment**, so these Godot tests cannot honestly be marked PASS from source edits; require actual run. The *pre-tune* 54/54 PASS remains preserved as historical evidence.

