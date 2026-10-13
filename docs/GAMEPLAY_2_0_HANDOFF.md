# Misdeal — new-chat continuation checkpoint (2026-10-13)

**Source of truth:** GitHub `zampolit73/Misdeal`, branch `main`. Work with the **connected GitHub plugin directly**, never claim there is no GitHub access before checking. User runs Godot 4.7.x + GDScript locally and pulls source changes via Git. Code and resource names in English; talk to user in Russian.

**READ FIRST:** `AGENTS.md`, `docs/CONCEPT.md`, `docs/SESSION_CHECKPOINT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/HANDOFF.md`, `docs/VISUAL_ASSET_REGISTRY.md`, `docs/DESIGN_SYSTEM.md`. This document is a quick state-oriented start, not a replacement for those rules.

## The exact current handoff

User has finished visual wave 1 and said **«Все ок. Что дальше?»**. Assistant proposed **Act 1 Gameplay 2.0** across four themes: (1) varied two-card table deal choices and fewer repeat categories, (2) better variety of tactically meaningful existing combat encounter pairings while honoring existing authored content, (3) worthwhile explicit risk/reward choices, and (4) more situational evil Wizard reactions, with solo/duo/trio regression checks. User said **«да, давай»**. Immediately afterward the user asked **«так запиши весь контекст в гит. в общем как мы делаем. что бы я продолжил в новом чате с этого де места»**. This is a **handoff request**, not a request to start another gameplay feature or rework UI.

**Important repository truth, checked on 2026-10-13:** `main` ALREADY INCLUDES the **implemented first D136 Gameplay 2.0 source pass**, together with documentation and smoke-test source. The latest source+docs head checked before this handoff was `4067f18888913c47148cfde7da0b81335e734291`. Don't repeat/re-implement D136 and don't say it is only an unimplemented proposal. The next task is **local Godot validation**, then fixes for real failures (or further gameplay iteration after reviewing results). A previous assistant turn began by saying it would audit/implement; GitHub in fact advanced and the prior D136 commits exist. The source is authoritative.

## Actual shipped D136 Gameplay 2.0 source behavior

- `scripts/core/run_state.gd` selects two offered cards using soft preferences against recent repeated resolution type, including legal mixed combat/noncombat pairs only from current tier/available pool, preserving forced combat timing and existing opening safeguards. It has contextual Wizard table comments in `get_wizard_deal_line()`. It has staged `get_wizard_mark_gold_reward()` payouts +20, +30, +40 across the 3 groups of 4 Act 1 slots, with the original marked-card next-battle **+15% enemy damage** risk. The code preserves Wizard Meddling, Fate Hold, cards remaining, discarded history, boss XIII, existing Wager debt/penalty and 12 regular card resolutions. Details: decision `D136` at the end of `docs/DECISIONS.md`.
- `scripts/table/table.gd` displays the exact Mark payout/risk in the visible card, hover tooltip, confirmation, Wizard memory, and optional contextual Wizard line, preserving higher-priority Wizard messages.
- No new enemy rosters, tactical actions, combat AI/stat scalars, companion rules, art, arena, reward economics, Fate Spread geometry or DS2 UI layout. Existing 30 authored Act 1 regular cards (10/tier), various combat setups, and 12 + final XIII rules remain.
- Test-only scene `res://scenes/dev/act1_gameplay_v2_smoke.tscn` with `scripts/dev/act1_gameplay_v2_smoke.gd` simulates 48 seeded 12-card deals across solo, duo and trio, checking forced fights, no duplicate picks, boss handoff, party pressure and Mark tiers. On success text reads **ACT 1 GAMEPLAY 2.0 — PASS**. This is a deterministic logic smoke, NOT end-to-end in-game combat or event interaction.

**Not yet validated:** No local Godot 4.7.x PASS screenshot/result or completed real Gameplay 2.0 Act 1 run has been reported by the user. Previous static/type-safe source fixes were committed, but do not claim that Godot runtime ran in the assistant's environment.

## First-wave visuals — done and frozen

First-wave illustrative assets: **18/18 binary WebPs in `main`**, D131 (4 dealt run cards) + D132 (4 event scenes, user accepted event display after D133 scoped fix) + D134 (3 hero upgrades + 2 rewards) + D135 (3 more run cards + 2 event backdrops). Artwork approval, latest generation IDs, physical paths and fallbacks: `docs/VISUAL_ASSET_REGISTRY.md`, `docs/CARD_ART_UNIFICATION_WAVE1.md`, D131–D135. In latest exchange, user successfully addressed a `git pull` untracked-file conflict arising from five older, locally extracted D134 `upgrade/` and `reward/` WebPs (instructions: move to sibling `Misdeal_Old_Arts` backup, then `git pull`); user replied **«Все ок»**. Treat this as confirming local pull/art work is OK, **not** conclusive testing of every reward/event branch. There is no unresolved merge conflict reported. No manual ZIP installation necessary.

**Absolute visual locks:** user's approved favorite Fate Spread Variant C, DS2 blackwood/obsidian/bronze/blood-red look, already accepted Gravedigger Shop, Whispering Well, major Upgrade/Reward, Main/Intro, battle layout, portraits/animation and all 18 artworks. Never revive old lower-resolution card-board ZIP images; do not rewrite these UI scenes without an observed defect and consent.

## Godot verification to do next

1. User should `git pull` new D136 Gameplay 2.0 code, then open `res://scenes/dev/act1_gameplay_v2_smoke.tscn` and press **F6** in Godot 4.7.x at **1280×720**. Ask for PASS/FAIL screen or relevant Output/Debugger error lines. The assistant cannot infer test passed without that result.
2. After PASS, run a **real Act 1** as Knight/Ranger/Mage, observing mixed deals on unconstrained slots but guaranteed forced combats, avoiding accidental repeat offers, all 12 Act 1 cards and central Bone Warden XIII.
3. Inspect Wizard Mark on early/mid/late stages: **20/30/40 gold** credited on acceptance, clearly labelled **+15% enemy damage next combat**; test tooltip/confirmation/normal reward. Check Meddling, existing Wager/offer semantics, held-card return and rejected-card behavior, special lines/priority, and event/reward return navigation.
4. Check solo, duo and trio pressure as possible; unchanged balance by design: solo hero HP×2.2/damage×1.9/cadence×1.25/move×1.10, duo HP×1.2/damage×1.15, trio baseline; enemy scaling solo HP 0.82 / damage 0.80, duo 0.92/0.90, trio 1.0/1.0. See `docs/CONCEPT.md` for canonical values.
5. If FAIL or user reports bug: first inspect current GitHub files/test code and error; fix directly using connected GitHub, update docs and descriptive commit, ask user for just `git pull` and specific retest. If PASS and normal run good: mark D136 locally validated, then choose a second **small content/gameplay** iteration by reviewing actual deck/encounter variety; don't invent new core systems or re-open locked visual pass.

## Accurate end-of-session status

- **This handoff session changes documentation only**; it neither creates new mechanics nor tests Gameplay 2.0 inside Godot.
- Real first D136 gameplay code exists in GitHub and needs user pull/test.
- Approved visual wave is shipped and user has said "all OK" after resolving local pull conflict.
- The next chat should **start with GitHub state** and the D136 Godot test results, not ask user to re-explain the game or whether Git access exists.
