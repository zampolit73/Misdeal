> **D369 FINAL RELEASE 2026-10-28:** [PR #34](https://github.com/zampolit73/Misdeal/pull/34) merged `44f2e0b75df9861d820e36589c8cdc66d5a79596`, [native CI 72/72 PASS](https://github.com/zampolit73/Misdeal/actions/runs/40711701797), 3 verified correctly encoded source WAVs and native Godot scene checks. This file describes the earlier D368 checkpoint and D369 candidate stage. New source of truth: [D370_NEW_CHAT_HANDOFF.md](D370_NEW_CHAT_HANDOFF.md). **Auditory quality still needs local F6/F5 review.**

> **D369 IMPLEMENTATION STARTED 2026-10-28:** This prior handoff captures the D368 release baseline. Newer ambient-audio candidate and validation gates: [D369_AMBIENCE_PILOT.md](D369_AMBIENCE_PILOT.md) on `feature/d369-subtle-ambient-spaces`. Once released, check the latest top-level PROJECT_STATE.md for final commit and CI. Do not infer player auditory approval.

# Misdeal — CURRENT NEW CHAT HANDOFF (2026-10-28 / D368 release)

## Source of truth

Repo `zampolit73/Misdeal`, `main`. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, then `docs/D368_COMBAT_FOLEY.md`. Historical D368_NEW_CHAT_HANDOFF describes the pre-implementation baseline; this file is newer.

**Live D368:** [PR #33](https://github.com/zampolit73/Misdeal/pull/33) merged as `20368dd822a06e234c9a5c23235c36744f01bba2`, [Godot 4.7.2 CI SUCCESS 65/65](https://github.com/zampolit73/Misdeal/actions/runs/40705404555); import/parse, GUT, native smoke, screenshots passed. Eight original **synthesized** 24kHz mono WAV combat cues (melee steel, 2 archery strings, magic, bone hit/death, low healing bell, boss) in `assets/audio/combat/`. `scripts/battle/combat_audio.gd` uses 6 priority-aware voices, shared 155ms bow throttle, alternates bow takes and maintains complete legacy procedural fallback. `scenes/dev/d368_combat_audio_audition.tscn` is a genuine F6 auditory QA room. New `tests/unit/test_d368_combat_foley.gd` has 5 tests.

**Not yet accepted by a human ear:** actual sound quality, volume and texture for Firing Square four archers, Iron Wall metal/bone, Last Bell healing and boss enrage. Godot CI uses automated checks; do not call subjective mix PASS. User next: `git pull`, F6 `scenes/dev/d368_combat_audio_audition.tscn` eight buttons plus 4-archer and mixed test, F5 Firing Square / Iron Wall / Last Bell. Collect feedback, refine in GitHub if needed. Avoid micro approvals; adjust as a cohesive pass.

**Locked:** user-selected **B — Oak** already shipped via PR #32; Oak table sounds untouched by D368, F5 Oak listening also pending. D365 rollback of hovering target beams and arena-crossing archer traces is mandatory. DS3 dark-fantasy cards/approved art, 12 Fate resolutions + sealed XIII, Knight/Ranger/Mage solo/duo/trio, AI/balance/encounters unchanged. Use Godot 4.7.x GDScript; no C#.

**Next after ear QA:** D369 subtle location-specific castle/courtyard/ossuary ambience using existing SoundDirector fades; no intrusive soundtrack. A1P3 complete human 12+XIII and independently dispatched full RELEASE combat/animation matrix are still open (PR smoke does not count as either).

**Workflow:** connected GitHub available. Edit via it when implementation requested; meaningful commits, native CI and clear updated `PROJECT_STATE`/`ROADMAP`/`HANDOFF`/`CHANGELOG`/`DECISIONS`. User local duties normally only `git pull` and focused Godot playtest.
