# A1P2 — New chat handoff / Misdeal (2026-10-23)

> **START HERE in a new chat.** This handoff was deliberately committed after checking the real `main` branch on GitHub. Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, then this file and `docs/A1P2_ACT1_ROUTE_AUDIT.md`. For implemented game code GitHub is the source of truth. Do not ask again whether GitHub is connected: the connected GitHub tools have been used for all implementation, review and merges.

## Where we stopped — exact state

- Repository: [zampolit73/Misdeal](https://github.com/zampolit73/Misdeal), branch **main**.
- Current main **at handoff creation**: `c39e5af8051b2395925b7bc925009d5feec159cc` (PR #12 merge `c4501ee4797d4f220f50b3d7e468d09f7cf31933`, then docs commit `c39e5af8051b2395925b7bc925009d5feec159cc`). THIS handoff commit will become newer than that SHA. Check latest branch head in new chat.
- Latest **A1P2 is shipped**, not an open bug! [PR #12](https://github.com/zampolit73/Misdeal/pull/12) is **merged / closed**, despite the earlier chat stopping just before a code-fix call. The red run preceded the fix.
- [First reproducing red GUT Actions run](https://github.com/zampolit73/Misdeal/actions/runs/39960263665) showed Fate Hold noncombat could bypass a required battle. Latest [native green run](https://github.com/zampolit73/Misdeal/actions/runs/39960631781): **43/43 GUT cases, 5,752 assertions**, original **8 native smoke suites** and **3 real scene screenshots PASS**.
- Fixed in `scripts/core/run_state.gd::_ensure_current_offers()`: when a *noncombat held card* is due back during a forced-combat slot, postpone that held card **one additional deal**. The held card remains intact and returns immediately on the next possible offer; ordinary return after two deals and held-combat behavior are preserved. Table Hold tooltip now documents the exception. Test `tests/unit/test_act1_fate_hold_gate.gd`.
- Added `tests/unit/test_act1_full_route_audit.gd`: 36 seeded **structural** `RunState` 12+XIII routes (12 solo, 12 duo, 12 trio, rotating Knight/Ranger/Mage), real card and encounter resources, correct offer tiers and selected targets. Boss XIII offered after XII and structurally resolved. **NOT** 36 actually won Battle scenes or complete event/reward interactions.

## A1P2 real numbers and meaning

- 432 nonboss card selections; **177 combat (41.0%)** and **255 events (59.0%)**.
- 201/432 offers (46.5%) contained different types; 177/396 adjacent selected pairs (44.7%) had the same type.
- 108/108 mandatory combat windows were preserved (three per route); final boss was structurally available in 36/36 simulated routes.
- Mean chosen combat cards per run: solo 5.00, duo 4.58, trio 5.17.
- Observed repeated same-type rhythm is a **hypothesis** for subjective pacing review, not permission to redesign card weights. Simulated card completion used `complete_active_card()`, not combat wins, clicked event branches or actual rewards. Full methods, limitations and reproduction: [A1P2 route audit report](A1P2_ACT1_ROUTE_AUDIT.md).

## Prior directly relevant milestones

1. **A1P1** [PR #11](https://github.com/zampolit73/Misdeal/pull/11): Wizard reacts to the *actual rejected card* at Act I 3/7/11 milestones; [40/40 GUT PASS](https://github.com/zampolit73/Misdeal/actions/runs/39957116934). No mechanic/balance/deck change.
2. **GUT1–GUT3** [PRs #8](https://github.com/zampolit73/Misdeal/pull/8), [#9](https://github.com/zampolit73/Misdeal/pull/9), [#10](https://github.com/zampolit73/Misdeal/pull/10): vendored MIT **GUT 9.7.1**, Godot editor Run All automatically discovers unit suite; user's actual Windows Godot 4.7.2 screen earlier confirmed **16/16 tests / 60 asserts**, now **43 GUT tests** green in GitHub. Combat target priorities, Bone Warden enrage, Last Rite resurrection covered. GUT bottom dock and QA Hub must remain usable.
3. **OPT1 + OPT4** [PR #7](https://github.com/zampolit73/Misdeal/pull/7): single impact-aware PR gate: docs-only, FAST, VISUAL, manual RELEASE; existing F6 `scenes/dev/qa_hub.tscn` DS3-style navigation (game, card gallery, battles, animation, UI). User approved and tested it locally. CI3–CI5 remain manual/specialist; CI4/CI5 capture *original* native Godot Battle frames and Court authored 25-frame animation atlases.
4. **Visual/art rules**: user approved D344R2 Candle Seller and D345 **final living human prisoner «Старый знакомый» option #2** (already SHIPPED; do **not** mistakenly claim it is pending). DS3 approved cards and original painted assets locked. New card art: show 2–3 actually rendered *distinct* choices and wait for selection; approved sprite/animation packs are made in a single 25-frame work batch without repeated micro-approvals.
5. **Game**: dark-fantasy card-driven roguelike, evil Wizard at cursed table, compact tactical autobattler; Godot **4.7.x** + GDScript, no C#. Fate Spread exactly **12 cards I–XII + sealed Bone Warden XIII**; player can finish solo/duo/trio. Do not alter fundamental game design without user discussion. New *fight-bearing* Act I card requires an authentically new enemy cast/art/mechanic. GitHub is authoritative for actual implemented features.

## NEXT WORK (not done yet)

- Main next focus after A1P2 is **actual player experience**, not more infrastructure: sample 1–3 **real F5 Act I runs**, especially solo/duo/trio, checking (a) combat pacing, (b) meaningful choices and event/reward clarity, (c) genuine Battle→Reward→Table transitions, (d) last 3 positions, Bone Warden XIII real fight and run-end. Use existing QA Hub, GUT, GitHub Actions as tools, do not present state-level simulations as full playtests.
- Identify *concrete evidence* before adjusting card distribution, encounter balance or fundamental mechanics; ask approval before changing core design, art or story.
- An earlier CI import log noted nonfatal `assets/concepts/approved_battle_direction.jpg` warning. This is unrelated technical debt; investigate separately without repainting/shipping images.
- When user says "продолжай" in new chat, inspect latest GitHub `main`, use `docs/A1P2_ACT1_ROUTE_AUDIT.md` and current tests, and choose a small relevant improvement with direct GitHub PR/CI. Update handoff and project docs at end of meaningful implementation.

## User local notes and safety

- Typical instruction after code merges: `git pull`, launch through F5; `scenes/dev/qa_hub.tscn` with F6 for targeted QA; GUT → **Run All** to verify. A1P2 43/43 is **cloud verified**, not yet personally confirmed in Windows.
- Earlier user's local `project.godot` was placed into **git stash** due to a merge conflict; prior user had untracked Godot import/UID files and potentially `scenes/dev/grave_toll_smoke.tscn`. Do **not** recommend `git stash pop` or `git clean -fd` blindly. These local-file details are historical observations, not a claim about the user's current working tree.
- Do not require paid Codex, C# or extra plugins. User expects assistant to publish and fix through **connected GitHub** without asking for the repo to be uploaded.
- Maintain Russian chat; file names/code in English. Only ask for user feedback where essential for artistic approval, material game design, or actual subjective human play quality.
