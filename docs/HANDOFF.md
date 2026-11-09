# Misdeal — current handoff

## D420 — enemy art and animation delivery

Current branch `codex/enemy-visual-polish`: all24 enemy roles/600 new poses, calibrated art stature, grounded WALK/HIT/DEATH and head-clear HP. Original atlases retained. [Source/prompts, local evidence and F6](ENEMY_VISUAL_POLISH.md). Local233/233 GUT,15 selector tests,20 roster captures, real solo/duo/trio combat motion and ordinary Black Lantern Battle→Reward→Table pass. Finish final RELEASE CI before integration. Player-local project.godot/import changes preserved. D419 card-frame PR89 is separate.

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
