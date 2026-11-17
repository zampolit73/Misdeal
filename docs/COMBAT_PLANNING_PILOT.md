# Combat Planning 1.0 — isolated playable pilot

## Scope and launch

**Not production-enabled; do not merge without user gameplay review.** Open `scenes/dev/combat_planning_pilot.tscn`, F6, or QA Hub → Бой → «Боевой план 1.0 — Могильный звон». Choose one of seven solo/duo/trio compositions, old autobattle or planning, seed and optional starting preset. Open the arena; use ordinary hero dragging. Old mode uses the existing Fight/tactics; planning uses the compact live editor and its Start button.

Every experiment uses the exact existing Grave Bell roster/stats and party multipliers. It resets only isolated QA run/memory services. Rewards, progression, campaign saves and ordinary encounter routing are not replaced. F5 still starts the existing game with no executor attached. Jack has no editor and no driver; his original behavior is untouched.

## Editing and observation

Select a hero, choose1/2/3 orders, select I/II/III and edit tactic, priority, condition and2–12 second limit. All three slots are available immediately. Target button → click a real enemy; a brief tint confirms it. Right click/× cancels or clears. Switching heroes preserves all their orders. Plans for all living heroes are summarized below. The last order has no active transition condition or limit.

During combat the editor disappears. The small HUD shows hero/stage/tactic/time; notifications announce stage changes. The player only observes. After the actual result, a scrollable journal shows stage starts, actual transition times/reasons, assigned and selected enemy (local spawn index distinguishes equal names), personal kills, deaths and result. There is no generated explanation of defeat. Replay, edit again and compare mode restore the experiment's initial deployment and seed. Concrete enemy instance references are cleared when a new battle is created: select them again, or use the priority fallback. They never enter save files.

A real intermission on a two-wave resource allows new plans for survivors without healing or restoring spent special orders. The shipped player launcher remains Grave Bell; native QA additionally exercises the existing Iron Wall wave lifecycle.

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

GUT covers independent timers,1/2/3 slots, every condition/fallback, pause/preparation, no penalties, exact source/AoE kills, target lock/fallback/freed references, defense bounds/no teleport, hunt steering and legacy behavior. Native runner covers real enemy click, tab persistence, real intro/pause/editor lock,15 controlled Grave Bell battles and actual survivor replanning on Iron Wall. Existing full production GUT and normal Battle→Reward→Table smoke remain required. No static review is claimed as runtime PASS.

Run full GUT normally; focused tests: `--script addons/gut/gut_cmdln.gd -gselect=test_combat_planning -gexit`. Native: `--windowed --resolution 1280x720 --rendering-method gl_compatibility --script res://scripts/dev/combat_planning_capture.gd -- <absolute-output-dir>`. Runner writes `comparison.json`, `wave_check.json` and actual setup/editor/live/report PNGs. CI retains them in the standard evidence artifact.

Limits: this is an opt-in QA pilot, not campaign rollout or persistence of plans. It uses the existing compact2D steering rather than guaranteed pathfinding. Enemy references reset across battles. The seed examples demonstrate tactical consequences, not a universal strategy or a full balance study. Further rollout requires the player's review of the actual experience.
