# Misdeal — current roadmap

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
