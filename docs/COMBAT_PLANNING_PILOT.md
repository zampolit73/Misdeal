> **2026-11-18 update:** The user approved Visual V4 and requested campaign-wide rollout. The QA-only restrictions below describe the historical pilot; the current PR branch additionally enables a production Battle adapter across all encounter resources. The new contract, rare-order fallback and validation gate are in [Combat Planning Rollout](COMBAT_PLANNING_ROLLOUT.md). The F6 pilot remains independently usable with the production adapter disabled. Merge/production claims remain subject to latest CI and live F5 verification.

# Combat Planning 1.0 — Visual V4 pilot

## Scope and launch

**Not production-enabled; do not merge without user gameplay review.** Open `scenes/dev/combat_planning_pilot.tscn`, F6, or QA Hub → Бой → «Боевой план 1.0 — Могильный звон». Choose one of seven solo/duo/trio compositions, old autobattle or planning, seed and optional starting preset. Open the arena; use ordinary hero dragging. Old mode uses the existing Fight/tactics; planning uses the compact live editor and its Start button.

Every experiment uses the exact existing Grave Bell roster/stats and party multipliers. It resets only isolated QA run/memory services. Rewards, progression, campaign saves and ordinary encounter routing are not replaced. F5 still starts the existing game with no executor attached. Jack has no editor and no driver; his original behavior is untouched.

## Editing and observation

Visual V4 follows the approved gothic command board. Orders use parchment, etched bronze and live text. Edit fields use the same materials in the existing bottom dock. [Approved reference and native comparison](qa/combat-planning-visual-v4/README.md).

The bottom board shows one row per available hero, with tactic, assigned enemy or priority and a short transition label. Hover the hero's name or an order with an explicit enemy to mark that unit's feet in the overview. Click an order to edit it in the same bottom panel. «К плану» returns with changes applied, including a typed limit. «Длительность» is the time before a timed order advances. «Если не выполнено» is the fallback for an event. Use «+ Приказ» to add the next slot and the trash symbol by the hero's name to remove the last one. Its tooltip names the stage. The final order reads «До конца боя» and omits transition controls. Start the battle from the overview.

«Выбрать цель» collapses the bottom panel to a single hint line and shows numbered enemies. Hover shows the name. Click the enemy or its badge, or cancel with Escape, right-click or «Отмена». Either path reopens the same order. «Снять» removes the assignment. During combat the HUD shows each living hero's stage, tactic and remaining time, with a brief notice giving the actual transition trigger. After combat, the summary shows HP, kills, stage completions, timeouts and deaths from the existing journal. «Подробная хронология» reveals its full chronology.

Replay, F9, «Изменить план» and mode comparison retain the first-wave draft, seed and initial deployment. An explicit enemy is rebound to a fresh weak reference by index in the original spawn list, provided the encounter path, formation, enemy resources and ordered spawn signatures match. A mismatch clears the assignment with a message and uses the chosen priority. These bindings exist in the QA session only. At a wave break, survivor plans can be changed and first-wave assignments are cleared. Next-wave enemies appear after confirmation, so that wave uses the selected priority. A full retry starts again with the first-wave draft.

The default preset is the editable «Прикрытие → охота» example. The setup screen describes each preset and explains that composition and placement affect the outcome. The example loses the reference trio fight at seed 31017. The shipped launcher uses Grave Bell. Native QA also exercises a real Iron Wall intermission.

## Rules implemented

- Each hero owns an immutable runtime copy of1–3 orders. Strict order, no loop, final order persists; death stops the executor.
- Time begins after actual unit combat start, after the original intro. Preparation, intermission and pause do not run plan timers. Ordinary local hit-stop still counts as game time.
- Conditions: time, first positive personal damage dealt, positive actual damage taken, personal kill, HP≤50%. Every event condition has a mandatory2–12s fallback; timeout adds no stat penalty.
- HP is latched at stage entry and when actually crossed. At most one transition per hero per engine frame prevents a damage/kill/timer cascade; an already-satisfied HP entry predicate can apply on the next eligible frame without requiring another hit.
- Existing diagnostic damage signals attribute actual HP loss and AoE kills to the attacking unit. Zero damage and other heroes' kills cannot satisfy a personal condition. A final winning hit is logged without starting fictitious post-combat orders.
- Explicit eligible living enemy first, then chosen priority. Nearest/farthest use distance; weakest uses **absolute current HP**; support ranks healer, ranged, nearest. Target lock persists until invalid, outside the defense hold region, or a new order.
- Assault retains the existing×1.15 movement multiplier and direct approach. Hunt uses normal speed, the requested target and small local body-detour steering in existing bounds. No new navigation graph, damage or armor bonus.
- Defense anchors the hero's current world position at activation. Hold radius90px, constrained by existing floor bounds; target must be reachable within hold radius + attack reach. It never teleports or chases across the arena. No reachable enemy can mean no attack. Return uses the ordinary movement/separation pipeline.
- Sacrifice/defiance are rejected by plan canonicalization and absent from the editor. Their existing code and one-use consumption remain unchanged.

## Architecture

`hero_battle_plan.gd`: transient Resource data, validation, local WeakRef targets. `battle_plan_executor.gd`: per-hero clock, conditions, locked targeting, optional velocity constraint and factual journal. `battle_plan_ui.gd`: real Godot controls and read-only combat/result views. `battle_plan_presets.gd`: editable example plans, not guaranteed solutions.

The existing Battle/Unit still spawn, move, collide/separate, attack, heal, run arena abilities/waves and decide the result. Changes to shared code are limited to a null-by-default unit policy hook, a positive-actual-damage signal and a pre-start Battle signal. Only this QA fixture attaches executors. The pre-start signal reseeds opening cooldowns only in this fixture, preventing ambient render cadence from affecting comparison; ordinary battle RNG is unchanged. No second router/autoload/save schema or battle engine.

## Recorded controlled comparison

Native Godot4.7.2, fixed1/60 simulation step through the real BattleUnit/Battle code, same seed31017, actual deployment/stats, no forced result. Renderer is suspended only during accelerated QA stepping and resumed for native PNGs. Separate real engine-driven checks cover intro, pause/resume, editor lock and actual mouse selection.

For Knight+Ranger+Mage at the original deployment:

| Plan | Result | Actual combat time | Surviving hero HP |
|---|---|---:|---|
| Legacy assault | Win |15.75s|Knight134, Ranger90, Mage0|
| Pilot one-order assault | Win |15.75s|Knight134, Ranger90, Mage0|
| Defense | Loss |46.12s|0 /0 /0|
| Hunt support | Loss |17.40s|0 /0 /0|
| Staged cover→hunt example | Loss |15.55s|0 /0 /0|

These are observations, not desired outcomes or universal balance claims. The same comparison runs solo, duo and trio (15 Grave Bell battles), asserts identical initial stats/deployments and exact legacy-vs-one-order-assault results, and exports movement/HP/target samples and actual journals. Other plans demonstrably change movement, kills and results. All-hunt is intentionally risky, especially in the shallow body-congested floor; the local detour does not guarantee access to a rear target. The mixed example is an editable **losing example**, not advice to win.

## Verification and limits

GUT covers the original combat contract. The native runner checks that the overview, editor and target prompt use the same lower panel and are mutually exclusive. It exercises order editing, typed limit commit, target picking, cross-encounter reset, the Start button, report editing and wave-break preparation. Actual intro and pause checks and 15 controlled Grave Bell fights remain in the runner. [UX V3 and comparison with V2](qa/combat-planning-ux-v3/README.md).

V3.1 native checks also exercise the two timer captions, hero and enemy hover markers, marker removal on exit and combat start, target clearing, and stage removal down to one order. [V3.1 native screenshots](qa/combat-planning-ux-v31/README.md). [Eight-battle gameplay playtest](COMBAT_PLANNING_PLAYTEST.md).

Run full GUT normally; focused tests: `--script addons/gut/gut_cmdln.gd -gselect=test_combat_planning -gexit`. Native: `--windowed --resolution 1280x720 --rendering-method gl_compatibility --script res://scripts/dev/combat_planning_capture.gd -- <absolute-output-dir>`. Runner writes `comparison.json`, `wave_check.json` and actual setup/editor/live/report PNGs. CI retains them in the standard evidence artifact.

Plans and spawn bindings live only in this launcher session. Hunt still uses the existing local detour. The next gate is player review of the UX on PR #117.
