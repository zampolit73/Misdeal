# Misdeal — current roadmap

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


## A1V1 — следующая художественная/сюжетная проверка (НЕ реализовано)

- [x] Одобрено направление «Витраж Памяти» и рабочая структура 24 (12 общих + 4×3 личных); сохранён [список 24 осколков](ACT1_MEMORY_STAINED_GLASS_CONCEPT.md).
- [ ] Показать на **реальном утверждённом фоне** визуальные варианты размещения, в том числе возможный витраж за спиной Волшебника; не менять существующий стол/лицо/карты. Отдельный полноэкранный осмотр — вероятнее для 24 читаемых фрагментов.
- [ ] Отредактировать сценарий каждого осколка под три альтернативных класса главного героя, распределить основные откровения, защитить финальный спойлер XIII.
- [ ] Согласовать триггеры открытия, anti-duplicate и сохранение между забегами независимо от A1M1/A1M2 run-facts.
- [ ] Только после арт/дизайн-одобрения — маленький обратимый Godot-прототип. Не путать этот пункт с реализацией 40→45 оставшихся пяти карт.

## Completed checkpoint

- D418 Ranger-only Jack event with three choices and complete animal combat pack; [QA and local F6](D418_JACK_EVENT.md).

- D412 approved hero animation pack and D413 dossier live; D414–D417 safely integrated.
- Autonomous visual VP1–VP7: native baseline/audit, Reward modifier/readout fixes, truthful merchant/event states and full effects, RunEnd scroll containment, result-button canvas ordering, approved-art guards and complete RELEASE QA.
- 224/224 GUT,13 selector tests,52 native states, Battle→Reward→Table and solo/duo/trio motion. [Release evidence](VISUAL_POLISH_RELEASE_QA.md), [audit](VISUAL_POLISH_AUDIT.md).

## Priorities after this delivery

1. Fix only concrete new player/native regression evidence; preserve accepted Misdeal style and mechanics.
2. Separate technical P2 cleanup for pre-existing GUT type warnings, Windows certificate/log environment and route-runner shutdown resources. These are not visual blockers or proof of a failed game route.
3. Review legacy enemy stylistic consistency as a separately approved art task. No automatic sprite repaint, balance or architecture changes.
4. Continue the existing authored content/vertical-slice backlog toward45 Act1 cards from the current40 only after validating current GitHub and release gates. New combats still require original enemies (D143); future card artwork still requires D168 options. No new three-offer mechanic or replacement of I–XII/XIII.

Detailed historical backlog/approval context is preserved in [pre-polish roadmap archive](archive/2026-11-09-pre-visual-polish/ROADMAP.md). Historical pending checkboxes are not current technical truth; reconcile them with merged code before resuming. Current constraints remain in AGENTS.md, CONCEPT.md, DECISIONS.md and DESIGN_SYSTEM.md.
