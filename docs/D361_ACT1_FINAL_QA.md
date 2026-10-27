# D361 — Act I final card-art readiness and real F5 playtest

Date: 2026-10-27. Source: `main` and PR [#28](https://github.com/zampolit73/Misdeal/pull/28).

## What actually passed

- D360 final art released from PR #27; D315 guards 29 user-approved selected images. No reinterpretation of existing art.
- The D361 GUT test `tests/unit/test_d361_act1_art_readiness.gd` loads **all 39 currently dealt Act I cards plus the sealed Bone Warden XIII** from the current `RunState` registry, checks unique IDs and the deck count, typed combat/event targets, non-empty card text, and actual decoded illustration pixels (runtime catalog before original resource fallback). Failure names the card ID. It adds no visual/gameplay changes.
- Initial PR #28 native Godot 4.7.2 CI: **49/49 GUT**, `D361_ART_READINESS_PASS` for 40/40 records, project import and native smokes successful. Evidence: [run #40507551421](https://github.com/zampolit73/Misdeal/actions/runs/40507551421). Subsequent documentation/test-caption revisions require final PR CI recheck.
- Earlier A1P2: **36/36 structural 12+XIII route simulations**; A1P3: actual scene handoffs with injected outcomes. These are NOT human wins or full played fights.

## Still not proven automatically

- Full manual F5 run; all real action/interaction clicks, genuine battles and boss's 50% transition, reward clarity, encounter pacing, combat readability, and player enjoyment.
- Visual consistency of all 39 paintings at actual card size: decoded texture does not imply a good composition.
- The manually dispatched `release` mode of `.github/workflows/godot-pr-smoke.yml` (3 live Battle scenarios and 75 original Court animation frames); do not call it PASS without an observed run. It can be started in GitHub Actions with `mode=release` if authorized workflow-dispatch access is available. PR's automatic QA is not release mode.

## One concrete human playtest, after merge

1. In project folder check `git status`; when clean, `git pull`. Godot 4.7.x (CI 4.7.2), 1280×720.
2. F6 `scenes/dev/d315_card_ds3_gallery.tscn`: check all D356–D360 approved art (round ritual table; Ossuary Gate defenders; two shield guards; two bellkeepers; four archers firing into fallen skeletons with **straight arrow shafts**). Look for cropping, readable Russian text and single DS3 frame.
3. F5 actual normal run → choose **Knight**. Keep normal rules and encounter randomness (don't cheat party composition). Record opening I and progress by tier.
4. Complete positions I–IV / V–VIII / IX–XII. Record for each tier one forced combat, chosen/rejected cards, battle preparation, tactical orders, *real* Battle → Reward → Table transition, first tier-major upgrade and reward claim. If Wizard Mark/Wager/Med­dling or Fate Hold appears, check that visible choices and resulting state agree.
5. After XII verify **only sealed XIII** is offered. Fight Bone Warden for real; observe units walking on floor, real damage/heals, telegraph and phase change at 50% HP. On win verify Reward → RunEnd (ЗАБЕГ ЗАВЕРШЁН), 12/12 summary and New Run.
6. If time allows in **separate** runs: intentional defeat and single Last Deal, and organic duo/trio recruitment via story cards. Do not claim tested if these events do not appear.

## Evidence and severity

Return **one compact report**: chosen class / final party size, position reached (XIII or exact stuck card), number of real fights, whether Battle → Reward → Table and boss → RunEnd worked, difficulty verdict (easy/fair/hard), and three worst friction points. Prefer four screenshots: preparation HUD, XIII boss phase, RunEnd, and any blocker/error. Include last visible button plus Godot Output/Debugger error if stuck.

Blockers P0: crash, cannot advance a card, absent enemies, infinite fight, cannot claim reward, no XIII, corrupt run-end. P1: text clipping, art missing/cropped, wrong sprite movement/facing, unreadable orders, repeatable double rewards. P2: subtle layout/pacing issues. Fix P0/P1 in GitHub and rerun CI before increasing mechanics or card count.

A1P3 experiential **NOT COMPLETE** until the real F5 Knight 12+XIII report arrives. Original detailed checklist: [A1P3_LOCAL_PLAYTEST.md](A1P3_LOCAL_PLAYTEST.md).
