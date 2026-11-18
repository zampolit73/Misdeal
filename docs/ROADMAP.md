## Combat Planning campaign rollout (2026-11-18)

- [x] Player approved the isolated UX V4 pilot and requested campaign-wide deployment.
- [x] Shared Battle now attaches the real per-hero planning UI and executors across all authored encounters; QA pilot retains an explicit opt-out.
- [x] Legacy-command path remains available for Sacrifice/Defiance and old order behavior.
- [x] Add native all-encounter/solo-duo-trio/wave test in CI.
- [ ] Verify latest CI, full real random-run, save/load and Last Deal/regression acceptance before merging PR #117.
- [ ] Player F5 confirmation of actual deck → combat → reward → table loop.
- [Rollout contract](COMBAT_PLANNING_ROLLOUT.md).

## Experimental Combat Planning 1.0

- [x] Independent per-hero plans, real engine execution, editable preparation and journal.
- [x] Solo/duo/trio old/new controlled comparison and native wave intermission replanning.
- [x] UX V2 squad overview, direct order editing, scoped target replay and readable battle summary.
- [x] UX V3 single lower panel for overview, order editing and the transient target prompt.
- [ ] User gameplay review; no campaign rollout or main merge yet.
- [Contract and launch](COMBAT_PLANNING_PILOT.md).

# Misdeal — current roadmap

## Released checkpoint

- [x] Existing vertical slice, solo/duo/trio and twelve resolutions plus Bone Warden XIII.
- [x] Save/load and Memory Glass viewer; approved visual program and D412 hero packs.
- [x] Existing Travel V2 / Pilot Batch01 and preserved original unique scenes.
- [x] Batch02 V2: seven new locations,31 actual outcome presentations.
- [x] Approved smaller crown/equipment, all four crown aftermaths and marked garden route.
- [x] Unified QA Hub, direct F6 regression, search, live cards and isolated QA progress.
- [x] Final artistic approval, green full RELEASE CI, production merge of PR #114/#115.

## Next work

- Handle concrete player feedback or separately agreed content tasks.
- Preserve approved art/staging, current mechanics, balance, saves and existing architecture.
- Keep known type/shutdown diagnostics visible; a broader technical cleanup is a separate task.
- Reconcile any historical content backlog against live GitHub before implementation; do not treat archived candidates or old PRs as current release approval.

[Current state](PROJECT_STATE.md) · [Handoff](HANDOFF.md) · [QA Hub](QA_HUB.md) · [Travel contract](TRAVEL_BATCH02_V2.md). Superseded milestone/session entries are preserved in [the release archive](archive/2026-11-17-production-release/ROADMAP.md).
