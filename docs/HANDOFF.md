# Misdeal — current handoff

## Echo of the Siege — 5 of 5 arts selected, integration outstanding (2026-11-10)

Fifth user-approved `last_signal` = **OPTION 1**: solitary skeletal sentry on a ruined moonlit battlement holding an extinguished brazier on a pole, gold ring-cross on crimson banner; not spyglass or handheld lantern. SHA256 of 1536x1024 original `2a53828e4fec3105605502fe5a4aa05610c5af46f5f8d61e35fc79cde7854026`; persistent Library location `/Misdeal/approved_art/last_signal_echo_siege_approved_2026-11-10.png`. All five approved originals are in that Library directory; a ready-to-integrate ZIP containing all five PNGs, ten WebPs and checksums was generated and linked in the current project chat. **Only documentation has been committed to GitHub; new art is not deployed to runtime.** Important: old `manifest.json`/packer still reference old selected options; fix source-packing reproducibility during the actual asset PR. Do not claim CI/native pass until run. Exact five art identities and workflow: [ECHO_SIEGE_ART_ROLLOUT.md](ECHO_SIEGE_ART_ROLLOUT.md), [DECISIONS.md](DECISIONS.md). User only needs `git pull` AFTER image bytes have actually landed in a GitHub commit.


## Echo of the Siege — 4/5 approved scenes, 1 remaining (2026-11-10)

NEW: User approved **`false_weights` / «Неверные гири»** after fixing heraldry to the exact Misdeal worn-gold crosswheel with extended vertical shaft. This is the version with a skull-faced quartermaster **cheating helmeted scarecrow dummies (NOT living soldiers)** by adding stones to the left side of a brass balance against a small pile of grain on the right. Original 1536×1024 PNG SHA256 `6d1c166f5587a68f366f68b210e3f6cae748d8a35a77cadc2bab605d399e95d6` saved to user's Library `/Misdeal/approved_art/false_weights_echo_siege_approved_2026-11-10.png` (`libfile_65edaaee10448191860c137b40fa1234`). Full immutable visual requirements and prior 3 approvals: [DECISIONS.md](DECISIONS.md).

**Approval is not implementation.** As of this handoff, new Echo of the Siege arts have not been packed into final runtime `assets/pixel/events/final_five/<id>/{card,backdrop}.webp`; keep existing original DS3, event mechanics, other resources and rollback intact. Later, use the project's packaging code for 448×274 cards and 1280×720 backdrops and verify native F6. Four approved: `banner_seamstress`, `unsent_letters`, `borrowed_boots`, `false_weights`. The **only** remaining art selection is `last_signal` / «Погасший сигнал»; show options in chat before implementing any fifth card art.

## Echo of the Siege — 3/5 approved art (2026-11-10)

NEW: The user approved the **FIRST image** from the last four-result set for `borrowed_boots` («Чужие сапоги»). It shows an undead skeletal quartermaster/boot inspector, with an abandoned row of boots across a dark workbench, gothic window and warm lantern (not the other young-squire/scavenger options). Full-res 1535×1024 PNG exact source in user's Library `/Misdeal/approved_art/borrowed_boots_echo_siege_approved_2026-11-10.png` (`libfile_8eeb8fef6848819189a8f8a6f568ec47`), SHA256 `7cf1d2d0fa0cd813bdc0017b49d920f0fbd5692b0013f6d90cc716cb0120e88b`. The previous two approved art sources are under the same Library folder (`banner_seamstress`, `unsent_letters`). See [DECISIONS.md](DECISIONS.md) for exact art identity and locked composition. **All 3 new approvals are art-only; runtime WebP files in GitHub remain the old art.** Integrate later using the existing 448×274 and 1280×720 rules without modifying the event effects or DS3. Remaining cards for fresh art review: `false_weights` («Неверные гири»), then `last_signal` («Погасший сигнал»).

## Echo of the Siege — two art approvals; gameplay unchanged (2026-11-10)

Approved, not yet integrated: (1) `banner_seamstress` / «Знамя на бинты»; (2) `unsent_letters` / «Запертая почта». Second final image: an undead postmaster sealing a letter into an open chest, **one skeletal pigeon** on the chest lid, and the exact crimson/gold ring-and-cross castle banner; everything else as generated in user's chosen third variant. The 1535×1024 approved source PNG is stored in user's Library `/Misdeal/approved_art/unsent_letters_echo_siege_approved_2026-11-10.png`, SHA256 `3e84b66a1109af5867126e6a3d87dd480d28f6fe3641fef137ef8becfabb5e0f`. Source of truth for both visual approvals is [DECISIONS.md](DECISIONS.md), which includes exact provenance and constraints. **Runtime assets in GitHub are still the pre-existing original illustrations**; approval does not mean deployed. For integration use existing `assets/pixel/events/final_five/<card_id>/{card,backdrop}.webp` paths and `scripts/dev/pack_final_five_assets.gd` fit rules (448×274/1280×720), preserve originals, verify actual Godot F6 and tests. No changes to event mechanics, effects, DS3, choices or save contracts. Remaining review order: «Чужие сапоги», «Неверные гири», «Погасший сигнал».

## Echo of the Siege — user-approved «Знамя на бинты» scene (2026-11-10)

User approved the **exact** half-undead seamstress illustration with gold ring-cross banner sigil (not castle). 1536×1024 PNG SHA256 `be70f5375c703fc9ad4c5a1f5cfb57eea5f499ac849526348fa842ee483e39b2`; durable full-resolution source in the user's Library: `/Misdeal/approved_art/banner_seamstress_echo_siege_approved_2026-11-10.png`. Details and visual locks: [DECISIONS](DECISIONS.md#echo-of-the-siege--approved-art-direction-2026-11-10). Current GitHub card/backdrop remain **old artwork**, not yet replaced by this newly approved image. Integrate approved source (card 448×274; event backdrop 1280×720) while preserving existing 45-card mechanics, original DS3 skin and source rollback; verify actual native F6. Continue visually reviewing the other four «Эхо осады» event illustrations, with distinct options-first artworks.

## Final five Act I stories — 45 ordinary cards

Five new original noncombat events, fifteen art candidates with selected finals, existing DS3 and actual choices/ordinary tier dealing. Godot 4.7.2: 260/260 Linux GUT tests (48,919 assertions), 45 native frames on Windows and Linux. [PR #98](https://github.com/zampolit73/Misdeal/pull/98) carries the required full RELEASE checks. [Effects, sources, QA and F6](ACT1_FINAL_FIVE_CARDS.md). This task explicitly delegates art selection; PR89/90/92 remain independent.


## Memory Glass — enlarged inspection

Enlarge button opens fit/native zoom with wheel, LMB drag and bounded pan. Same original art/unlocked masks; ESC returns to the unchanged memory selection before closing Table overlay. [Controls and native QA](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## Memory viewer — approved Variant3

«Хроника осколков» integrated in production: original glass left, framed scrolling reader right, group tabs above, four fragment buttons/page below. Reuses dossier frame; all24 unlock/mask/save/reset rules retained. [Layout, native QA and F5/F6](MEMORY_VIEWER_CHRONICLE.md). RELEASE required before merge.


## New Game — clean memory (user correction)

Confirmed main «Новая игра» starts at0/24 with archived prior data. The separate dialog action «Новый забег — сохранить витраж» and RunEnd preserve collection. Cancel/load/startup never clear it. Local245 GUT tests and native confirmation→Intro→Table0/24 pass; RELEASE required before merge. [Reset contract and QA](RUN_SAVE_SYSTEM.md).

## Run save system

New Game/Continue/Exit and ESC Save/Load/Save & Exit/Main Menu; validated versioned slot plus backup,67-field audit, safe Table/Reward checkpoints and permanent-memory rewind protection. [Architecture, field inventory and QA](RUN_SAVE_SYSTEM.md). RELEASE checks required before merge; native screenshots under docs/qa/run_save. Local user settings preserved.


## A1V2 — «Витраж Памяти»

24 persistent narrative fragments, approved immutable art, real completion hooks, cap8/run, protagonist gates, modal viewer and restrained Table apertures implemented. No combat/economy/clue carryover. Local234 GUT tests and native0/7/24/ESC/pixel-preservation/restart checks pass. RELEASE CI required before merge. [Contract, trigger matrix, evidence and F6](A1V2_MEMORY_STAINED_GLASS_QA.md).


## A1V1 — «Витраж Памяти» — КОНЦЕПТ, не реализация (2026-11-10)

Пользователь одобрил направление: **24 постоянных между забегами сюжетных осколка** (12 хроника + по 4 Knight/Ranger/Mage), сбор не за один проход, разные взгляды на осаду. Полный 24-пунктный сценарный черновик и границы: [ACT1_MEMORY_STAINED_GLASS_CONCEPT.md](ACT1_MEMORY_STAINED_GLASS_CONCEPT.md). Не создавались Godot-код, сохранение, 24 арта и новая UI-сцена. Последний пользовательский запрос — сохранить весь контекст и продолжить творческий процесс, **следующий шаг: визуально оценить место витража на реальном утверждённом фоне, не переделывая его**. Идея размещения за спиной Волшебника — лишь кандидат; центр фона перекрыт его силуэтом. Сравнить с необязательным увеличенным осмотром и маленьким предметом на столе. Не считать окончательно утверждённым внешний вид, расположение, триггеры, сюжетные тексты или награды. Канон Герой/Канцлер/Комендант/XIII и отсутствие ранних спойлеров в сюжетной библии. D418/PR88 merged, 40/45 карт. Остальные активные ограничения ниже.

Delivery: [PR88](https://github.com/zampolit73/Misdeal/pull/88) · [final-head RELEASE checks](https://github.com/zampolit73/Misdeal/pull/88/checks).

## D418 — Jack event

User chose gateway art option1. Added Ranger-only Tier1 event with exactly three outcomes:25 gold → real animal companion, pass unchanged, or token → Ranger damage+10% for this run.40/45 ordinary cards; hero count/compensation,12+XIII, approved heroes and old mechanics preserved. Complete25-pose dog, actual native event/combat/choice/wave evidence and regression tests. [Behavior, assets, QA and F6](D418_JACK_EVENT.md). Final PR RELEASE CI must pass before merge; native F6 launcher `scenes/dev/jack_event_playtest.tscn`. Earlier VP1–VP7 release below remains merged at d49d51a1.

Delivery: [PR87](https://github.com/zampolit73/Misdeal/pull/87) · [final-head CI checks](https://github.com/zampolit73/Misdeal/pull/87/checks). Merge requires successful full RELEASE; current check conclusion is authoritative.

## Completed autonomous visual program

D414–D417 merged safely; native audit and conservative VP1–VP7 repairs delivered. Read [release QA](VISUAL_POLISH_RELEASE_QA.md), [audit](VISUAL_POLISH_AUDIT.md), [current state](PROJECT_STATE.md). User request is preserved at [original brief](requests/2026-11-09-visual-polish-plan.md). All approved artwork, Wizard/table/Fate backgrounds, D412 animations, combat/data/economy/silent-first audio preserved. Do not reopen old art approval gates for already accepted work.

Current checks:224/224 GUT,13 selector tests,52 production-state renders, ordinary Battle→Reward→Table, real solo/duo/trio motion and original75-pose Court audit. Eight new visual regressions cover artwork locks, all9 reward text strips, read-only focus/state, merchant picture/purchase states, resolved event labels, long event/shop tradeoffs, scroll containment and victory-button canvas ordering. Final CI runs full RELEASE, not only import.

## Next work

No confirmed in-scope P0/P1 remains in inspected fixtures. Address concrete player feedback or ranked P2 items from release QA. Older enemy art differs from accepted D412 figures, but automatic repaint/rebalance is outside scope. Existing GUT type warnings and shutdown resource diagnostics merit a separate technical cleanup; do not hide them or confuse them with a failed visual check. Original content expansion/approval backlog remains in [archived roadmap](archive/2026-11-09-pre-visual-polish/ROADMAP.md) and must be reconciled against GitHub before action.

## Local operation and safe Git

Workspace `C:/Users/irlix/GodotProjects/Misdeal`; native binary `C:/Godot/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`. Local project content already includes the delivery. Stop an old running preview, then F5. Check Reward positive/negative lines and RMB/F, merchant prices/effects/resolution, RunEnd scrolling, TAB/R/hover and bright enabled victory CTA.

Player-local project.godot/GUT import changes and untracked UIDs/imports were preserved, not staged. Do not recommend blind pull/reset/clean on this dirty checkout. A clean independent checkout can use `git pull --ff-only origin main`. Read-only hygiene tool remains available. Continue button's canonical Battle path is now `ResultOverlay/ContinueButton` (same action/coordinates); legacy route observers and DS2/DS3 styling were updated together.

## Reproduce QA

`godot --headless --path . -s addons/gut/gut_cmdln.gd -gexit`; `python scripts/ci/test_smart_qa_select.py`. Native matrix: `godot --path . --script res://scripts/dev/visual_polish_matrix.gd -- <absolute-output-dir> <tested-sha>`; optional third comma-separated fixture filter for focused captures. Matrix changes automatically select existing CI RELEASE mode. Native frame manifest records actual RunState and source SHA. CI artifacts contain full52-frame results; compact before/after evidence is tracked under docs/qa/visual_polish/.
