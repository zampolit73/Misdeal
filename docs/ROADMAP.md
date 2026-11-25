## Gameplay 2.0

- A · Wounds, rest stops and one reliable merchant checkpoint. [Rules and QA](GAMEPLAY_2_0.md)
- B · 13 relics, build synergies and live stat changes in rewards, the merchant and events.
- C · Wizard Archive, three unlockable starting styles and five difficulty oaths.
- Table presentation · V5/V5.1 approved in main (PRs #143–144). V5.1 polishes the status plates, Fate Spread and Hold around the interactive journal, window and grimoire. [Native evidence](qa/table_interface_v51/README.md)
- Archive presentation · All four tabs (Reliquary V2.1, Bestiary V2, Chronicle V2 and Challenges V2) are approved and merged into main. [Godot evidence](qa/challenges_visual_v2/README.md)
- Event presentation · Event Choice V3.2 approved in main (PR #146), covering all 24 Act I events.
- Next investor visual milestone · Run End Visual V2 (victory and defeat presentation), subject to concept approval.
- Gameplay audit (deferred) · Human campaign runs across party sizes and builds, with focused Last Bell and XIII comparisons.

## D420 V2

- [x] Rebase the enemy art candidate against the current battle runtime and deliver the 24-role comparison.
- [x] User artistic approval and production merge through PR #126. [Review packet](ENEMY_VISUAL_POLISH_V2_REVIEW.md)

## Living Arenas V3

- [x] Author the remaining 11 profiles for 10 paintings and the Death Wager variant. [Coverage and QA](LIVING_ARENAS_V3.md)

## Living Arenas V2

- [x] Add three focused environment profiles and a backdrop reaction to the Warden's second phase. [V2 contract](LIVING_ARENAS_V2.md)
- [ ] Review motion on the three new arenas in Godot before expanding further.

## Act 1 gameplay audit — execution plan ready (2026-11-19)

- [x] Inspect current `main`, real RunState/Battle/planning, historical diagnostics and boss phase variants; record known-versus-untested boundaries.
- [x] Publish [auditable F5/F6 playtest matrix](ACT1_GAMEPLAY_AUDIT_2026-11-19.md) with recording fields, QA cases, triage and safeguards.
- [ ] Execute at least three **real** F5 runs (Knight/Ranger/Mage), targeted fixed-condition comparisons and boss XIII route; collect empirical findings.
- [ ] Review evidence, prioritize reproducible P0/P1/P2 observations and agree on smallest corrections before touching gameplay.

## Next focus — full Act 1 playability audit (2026-11-19)

- [x] Player accepted **all 24 Act 1 Cinematic Travel event scenes** after the full coverage check; seven earlier, seven Batch 02 and ten Batch 03 are finished.
- [x] Approved Combat Planning 1.0 / Visual V4 is already in `main` via PR #117, with 22 authored combat encounters.
- [ ] **Next proposed milestone:** run a genuine full-playthrough gameplay/balance/UX audit: new game → 12 Fate Spread resolutions → Bone Warden XIII. Test solo/duo/trio, plan usefulness, wave breaks, recovery/saves, rewards, Last Deal, and pacing. Do not count prior automation as a full human playthrough or change balance without evidence.
- [Next-chat handoff](NEXT_CHAT_HANDOFF_2026-11-19.md).


## Combat Planning 1.0 — released (2026-11-18)

- [x] Player approved the isolated UX V4 pilot and requested campaign-wide deployment.
- [x] Shared Battle now attaches the real per-hero planning UI and executors across all authored encounters; QA pilot retains an explicit opt-out.
- [x] Legacy-command path remains available for Sacrifice/Defiance and old order behavior.
- [x] Native campaign smoke covers all 22 encounters, solo Knight/Ranger/Mage, duo, trio and Iron Wall replanning.
- [x] Verified prior-save Continue, victory/reward/table, both Last Deal choices and full RELEASE CI. Merged PR #117 into `main`.
- [Rollout contract](COMBAT_PLANNING_ROLLOUT.md).

## Combat Planning pilot milestones

- [x] Independent per-hero plans, real engine execution, editable preparation and journal.
- [x] Solo/duo/trio old/new controlled comparison and native wave intermission replanning.
- [x] UX V2 squad overview, direct order editing, scoped target replay and readable battle summary.
- [x] UX V3 single lower panel for overview, order editing and the transient target prompt.
- [x] User approved the V4 interface and the campaign release.
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

- [x] Release all ten Batch 03 locations after the scale corrections, native playback checks and the user's approval. [Merged PR #119](https://github.com/zampolit73/Misdeal/pull/119) [Review contract](TRAVEL_BATCH03_REVIEW.md)

- Handle concrete player feedback or separately agreed content tasks.
- Preserve approved art/staging, current mechanics, balance, saves and existing architecture.
- Keep known type/shutdown diagnostics visible; a broader technical cleanup is a separate task.
- Reconcile any historical content backlog against live GitHub before implementation; do not treat archived candidates or old PRs as current release approval.

[Current state](PROJECT_STATE.md) · [Handoff](HANDOFF.md) · [QA Hub](QA_HUB.md) · [Travel contract](TRAVEL_BATCH02_V2.md). Superseded milestone/session entries are preserved in [the release archive](archive/2026-11-17-production-release/ROADMAP.md).
