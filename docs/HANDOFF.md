## Immediate continuation: Combat Planning rollout PR #117

User approved Visual V4 and requested scaling to every combat. Branch `codex/combat-planning-pilot` now connects `scripts/battle/planning/battle_plan_campaign.gd` to the actual `scripts/battle/battle.gd`, while QA pilot explicitly disables it. Review [rollout contract](COMBAT_PLANNING_ROLLOUT.md) before changing architecture. Latest CI status and full native evidence must be verified; **do not claim production merged until it is**.

Local F5: play a normal combat card (not the QA fixture), check compact V4 plan dock, drag hero, edit/assign orders, start combat, confirm live stage HUD, normal victory → Reward → Table, defeat → Last Deal, optional `РАЗБОР ПРИКАЗОВ`; test a two-wave arena and Bone Warden. The `Классика` button switches to the original command controls for rare Sacrifice/Defiance; `Боевой план` returns before starting. Existing F6 `scenes/dev/combat_planning_pilot.tscn` still compares legacy/pilot behavior.

## Next review: Combat Planning Visual V4

Open `scenes/dev/combat_planning_pilot.tscn` with F6 (also QA Hub → Бой). Use the default trio, compare the lower panel with the [approved reference](qa/combat-planning-visual-v4/approved_reference.png), open and edit any order, then return and choose a target. After visual review, use the [eight-battle playtest](COMBAT_PLANNING_PLAYTEST.md). User review is the merge gate for [PR #117](https://github.com/zampolit73/Misdeal/pull/117).

# Misdeal — current handoff

## Released and approved

The user approved the final crown route and authorized production. PR #114 and #115 are merged into `main`; runtime commit `c1bba4007198e1bac14fb9e4ae20f9d65ef1181c`, [green full RELEASE CI](https://github.com/zampolit73/Misdeal/actions/runs/44058109794). The seven Batch02 locations /31 outcomes, final crown artwork/staging and QA Hub are production. Old pending-art/approval/no-auto-merge notes for this delivery are superseded and archived.

## Local review

Primary project: `C:/Users/irlix/GodotProjects/Misdeal`. Stop an old running preview before starting again.

- F5 starts the real game.
- Open `scenes/dev/qa_hub.tscn`, F6 for the unified navigator. Search by title/Card ID; select party/gold and launch. F9 replay, F10 hub, F11 clean capture.
- Travel → «Пустое место последнего властителя»: ←/→ cycles wear/break/melt/leave; approved small props and up-right garden route apply to every outcome.
- General Batch02 F6: `scenes/dev/travel_batch02_playtest.tscn`,31 actions,1/2/3 party,P pause,R replay. Real choices continue through Event→Travel→Table.

## Safeguards

QA run and Memory Glass services are isolated under `user://qa_hub/`; normal player progress is preserved. Existing D412 frames, old Travel, Wizard/table, combat, balance and saves stay locked. Local `project.godot`, imports and player-authored files must not be reset/cleaned. Protected files were backed up and hash-checked before the production checkout update; the local worktree intentionally retains player settings.

## Validation and next task

Godot4.7.2 local GUT301/301 (77,821 assertions), selector18/18, original279 asset hashes and revised crown hashes. Full RELEASE verifies native QA hub startup/return, actual31 new /11 Pilot routes, party subsets, effects once, skip/pause/finish, save/load, UI/memory/combat/animations and Living Arenas. Native crown solo/trio route checks verify increasing X/decreasing Y, perspective and soles. Existing shutdown/type warnings are documented, not suppressed.

No unfulfilled task remains in this approved delivery. Continue with concrete user feedback; do not reopen accepted art, scales or routes without a new request. Old session notes remain in [the release archive](archive/2026-11-17-production-release/HANDOFF.md); [QA instructions](QA_HUB.md), [Travel contract](TRAVEL_BATCH02_V2.md), [evidence](qa/crown_small_props/README.md).
