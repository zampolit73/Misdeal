# Misdeal — current handoff

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
