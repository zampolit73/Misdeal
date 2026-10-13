# Misdeal — Gameplay 2.5 / D141 combat diagnostic harness

Status: **source shipped to GitHub main, local Godot F6 NOT YET RUN**  
Date: 2026-10-14

## Why this exists

The user's D140 270-fight CSV (`docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`) showed HUNT **24/90 wins** versus ASSAULT and FORMATION **67/90 each**, with **no** matched HUNT-only victories; `last_bell` HUNT **4/18** versus **18/18** for each alternative. Even with exactly fixed protagonists across party sizes, late equipped Knight solo won **24/24**, Knight+Ranger duo **0/24**, Knight+Ranger+Mage trio **2/24**. The user approved a **diagnostic-first** package («Давай»). This release collects concrete target pursuit, hits and healing before changing tactical AI or party-size scalars.

## Changes (what is and isn't gameplay)

- `scripts/battle/unit.gd`: added three **optional instrumentation-only signals**: `diagnostic_attack(attacker, victim)`, `diagnostic_damage(attacker, victim, amount)`, `diagnostic_heal(healer, recipient, amount)`. The signals emit only when a listener is connected. Attack emits at actual `_attack_target` execution; damage emits actual health loss after primary/splash attacks; healing emits actual HP gained from support `_process_support`. Existing attack damage, target selection, healer ticks, formations, party-size multipliers, Wizard mechanics, card identity, graphics, rewards and progression are unchanged. No player-facing instrumentation or debug flags are added.
- `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn` and `scripts/dev/tactical_gameplay_v25_combat_diagnostics.gd`: standalone **F6** harness deriving its setup from the previously F6-passed v24 benchmark, using actual `BattleUnit._process(1/30)` combat and same hero spawn positions, upgrades, artifact, party and enemy scalers.
- Matched **126 cases**: `last_bell` 2 layouts × all 3 protagonists × solo/duo/trio × 3 baseline orders = **54 bare cases**; `ossuary_gate` and `firing_square` 2 cards × 2 layouts × Knight protagonist × solo / Knight+Ranger / Knight+Ranger+Mage × 3 orders × 2 seeds = **72 equipped cases**.
- The `case_seed` formula and case selection for those 126 cases are exactly the corresponding subset from v24: `24000 + encounter_index*10000 + layout_index*1000 + protagonist_index*100 + sample_index*47`; matches are intended for **direct comparison with the earlier v24 CSV**. No baseline/production stat or AI changes were authorized as part of D141.

## Measured outputs

**Case CSV:** `user://misdeal_tactical_v25_trace_cases.csv` — 126 rows if PASS, with original v24 match key `encounter, variant, party_size, protagonist, party_roles, order, profile, sample`; `outcome, seconds, hero_survivors, enemy_survivors` plus exact actual hero attack count, attacks on healers, effective hero damage, enemy damage, effective enemy healing, summed hero-seconds with a target beyond attack reach, summed hero-seconds aimed at healer, hero target changes and cumulative hero movement distance. **Hero-seconds are summed over living heroes, not wall-clock battle duration**; for duo/trio they can exceed the fight length.

**Unit CSV:** `user://misdeal_tactical_v25_trace_units.csv` — one row per spawned living-or-dead hero/enemy **per case**, with role/team, attacks, primary attacks on healers, damage dealt/received, healing given/received, time outside reach/targeting healer/within reach, distance traveled, target switches, survival. Primary and splash damage are counted; attack attempts only count _real_ attack executions, not theoretical cooldowns. Heal amounts reflect capped health gained, not advertised ability strength. Not an event-by-event log, but summarizes real calls and per-frame sampling.

### Interpret carefully

- The harness checks **completion, no 75-s timeout and that both CSVs can be written**, **NOT healthy win rates or a resolved diagnosis**. The user's screenshots for v24 and earlier tests already passed; v25 is new and must be tested locally.
- Target changes are counted from sampled hero target refs each completed simulation frame; brief intermediate same-frame retargets are not observable. Chase time is sampled only when a living hero has a target farther than `attack_range + target.body_radius`. Being in range does not mean a hit occurred (cooldowns and hit stops still apply).
- The damage signal records amount of HP actually removed (overkill capped), not raw nominal attack damage. The healing signal records net restored HP; no source-role attribution guesswork.
- `diagnostic_* ` signals change no combat formula. In normal game they have no connected listeners.
- This reproducible synthetic combat still omits real card selection, Wizard Debt/Mark/Wager, table/menus, earned growth over 12 slots, boss XIII, rewards and transitions. Run an actual Act 1 playthrough before changing the player-facing meta-balance.

## How to run

1. In the user's Godot 4.7.x project: `git pull`.
2. Open `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`, press **F6**, allow all 126 cases to complete. Expected headline **TACTICAL GAMEPLAY 2.5 — PASS** if no invariants fail/timeouts.
3. Open **Проект → Открыть папку пользовательских данных** and attach **both** `misdeal_tactical_v25_trace_cases.csv` and `misdeal_tactical_v25_trace_units.csv` to chat. If FAIL, send the Godot Output/error/screenshot first; the assistant should fix via connected GitHub.
4. Compare v25 outcomes **exactly by case key** against user v24 CSV. If matches differ, diagnose instrumentation rather than claiming gameplay changed; only then compare HUNT pursuit/attacks/healing with ASSAULT/FORMATION, and Knight solo/duo/trio under identical layouts/seeds.

## Next design gate

D141 commits **diagnostic instrumentation only**. **No balancing changes are to be made without reviewing the new output and discussing targeted findings with user.** In particular, do not silently randomize opponents, weaken late cards, buff heroes or change global solo/duo/trio coefficients. Accepted DS2/Fate Spread Variant C, seven two-formation cards, 18 art assets, 12+XIII progression remain unchanged.
