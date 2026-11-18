# Combat Planning — campaign rollout contract

Combat Planning 1.0 shipped to `main` on 2026-11-18. The approved Visual V4 dock is the default in campaign battles. [PR #117](https://github.com/zampolit73/Misdeal/pull/117) · [Merge commit `8fbadd9404c2a52341f551f93010b3ed48303d74`](https://github.com/zampolit73/Misdeal/commit/8fbadd9404c2a52341f551f93010b3ed48303d74)

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

## Release verification

- The final PR head `52d107f8` passed full RELEASE CI and the merge kept its runtime tree byte-identical. [PR checks](https://github.com/zampolit73/Misdeal/actions/runs/44303696977) · [Merge commit checks](https://github.com/zampolit73/Misdeal/actions/runs/44307630026)
- Local Godot 4.7.2 passed all 313 GUT tests and 77,895 assertions. The native campaign smoke opened all 22 encounter resources and exercised solo Knight/Ranger/Mage, duo, trio, Classic/Planning switching and the Iron Wall wave handoff for survivors.
- A separate automated native route entered through New Game, picked Knight and a normal combat card, edited two orders, won the fight, chose a reward and returned to the table. Natural defeats exercised both Last Deal choices, including a later defeat after accepting the one-use deal.
- Continue opened a version 1 slot written by the previous production serializer. Gold and run progress were restored, and the new fight opened with a single safe Assault order. Enemy assignments remain local to their current encounter and wave.
- Native checks exercised both rare-order controls, a live Defiled Laboratory hazard and Bone Warden XIII reinforcements after crossing the phase HP threshold. The wave and boss tests exercise the original transitions with controlled HP. The 22-encounter check is an automated smoke, while the end-to-end route covers selected fights. [Native captures](qa/combat-planning-release/README.md)

Five older Court of the Mute workflows on the merge commit still require a 39-card Act I pool. The actual pool had 45 cards and included Court in both the previous and current releases. The archived tests and card are identical across the merge. [Example legacy failure](https://github.com/zampolit73/Misdeal/actions/runs/44307629920)

## Local testing

On `main`, run `git pull --ff-only origin main`. Start Godot with F5, open «Новая игра» or «Продолжить», then choose a combat card. Drag a hero, edit an order, then use «Начать бой». Try «Классика» and «Боевой план» before starting if you want to compare the two modes. The F6 scene `scenes/dev/combat_planning_pilot.tscn` remains available as a focused comparison.
