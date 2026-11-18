# Combat Planning — campaign rollout contract

**Status:** user approved pilot V4 and authorized expansion to all battles on 2026-11-18. This document describes the branch implementation, not a verified production release.

## Scope and ownership

- The production route remains `res://scenes/battle/battle.tscn`, with one ordinary `Battle` and the original `BattleUnit` movement, attacks, targeting and result logic.
- `scripts/battle/planning/battle_plan_campaign.gd` adapts the existing live V4 `battle_plan_ui.gd`, `hero_battle_plan.gd`, and `battle_plan_executor.gd` to that Battle. There is no second battle engine or router.
- The Battle's `combat_planning_disabled` property exists for the **isolated F6 comparison pilot**; the default ordinary scene enables planning.
- All authored battle `EncounterData` files use the same scene path. The native smoke enumerates **22** actual combat resources, including `bone_warden`, `iron_wall`, `black_crossing`, `defiled_laboratory`, `threadbare_theatre`, `court_of_the_mute`, `bone_crush` and `grave_bell`; helper data-only `last_rite.tres` and `bone_shepherd_whistle.tres` are not standalone encounters.

## Interaction

- Before the first wave, the **approved V4 bottom dock** shows 1–3 independent commands per living Knight/Ranger/Mage. Dragging deployment and optional explicit enemy assignment remain available. Last stage persists; events have mandatory2–12-second fallbacks.
- If the full dock would cover the existing deployment rings or nameplates, preparation opens in a compact field view. «Открыть боевой план» opens V4 and «Поле боя» brings the floor back without discarding orders. This keeps the Court of the Mute floor and all actor positions intact.
- `Начать бой` attaches per-hero executors **before** the original battle start/intro. No policy clock begins until each living unit actually enters combat.
- The one-time `Классика` link in the planning dock restores the original five-tactic preparation UI. `Боевой план` switches back. Rare `Жертва` / `Неповиновение` are **never** script steps, and the original unlock/consumption conditions remain authoritative.
- After wave I, freeze and detach each executor; the normal `Battle` controls HP persistence, wave break and enemy spawn. Rebuild the dock for survivors only. New wave assignments to unseen concrete enemies are not offered; priorities still work. Starting wave II attaches fresh executors, does not grant special orders a second time and does not create another reward.
- During combat the V4 editor disappears and a compact HUD tracks actual stages. At victory or defeat, the original reward / Last Deal screens remain intact. An **optional** `РАЗБОР ПРИКАЗОВ` button opens a factual review based on recorded events.
- Safe tactic/condition/time drafts are reused during the current running session; encounter-local WeakRefs and spawn slots are never carried to a different encounter. `RunState.reset_run()` clears drafts. No save serialization keys have been added; after app restart older runs use one safe `Натиск` per hero until edited.

## Risks and acceptance

1. **CI hard gate:** current Godot4.7.x import/parsing, full GUT, original scene/route smokes and the new `scripts/dev/combat_planning_campaign_smoke.gd` pass on the final PR SHA.
2. **F5 user check:** normal card selection → combat plan → actual battle → reward → table. No QA-only fixture, no free retry of a loss.
3. **All encounters:** use the native smoke for all22 authored `EncounterData`; inspect living arena mechanics, Wizard challenge, hazards and boss reinforcement without modifying source resources.
4. **Party states:** solo Knight/Ranger/Mage, duo and trio. No plan assigned to Jack; existing animal behavior persists.
5. **Multi-wave:** `iron_wall` survivors can replan with carried HP, without duplicated special commands or rewards.
6. **Rare orders:** the original Sacrifice/Defiance controls can still be selected, and their existing price and memory consumption cannot be bypassed via a script step.
7. **Defeat:** Last Deal remains functional; the factual plan-review overlay is optional and cannot replace accept/refuse actions.
8. **Save/load:** old slots load unchanged. Plans are transient, not persistent, until a dedicated save contract is approved.
9. **Rollback:** PR#117 is the integration review gate; existing main remains the original combat system until merged.

## Local testing

Pull the reviewed branch when approved or use the PR review branch. F5, then play any combat card normally. Choose orders and start. For a focused native comparison, open `scenes/dev/combat_planning_pilot.tscn` with F6; it disables the campaign adapter and retains the old-vs-new fixture. Logs and CI evidence are attached to [PR#117](https://github.com/zampolit73/Misdeal/pull/117).

**Do not infer native pass from static code review** or claim a released main before the branch is merged and the user's main-project Godot check is complete.
