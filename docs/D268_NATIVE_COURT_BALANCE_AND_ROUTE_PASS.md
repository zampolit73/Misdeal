# D268 — Native Court QA and limited balance pass: PASS (still unreleased)

**2026-10-19 · `main` · Official Godot 4.7.2.** [Successful full workflow #9](https://github.com/zampolit73/Misdeal/actions/runs/39249979969), commit `f7c428917c7bd60955d132c4bf5d0dedfbee195a`. All steps PASS: editor import/parse, real Battle QA F6 launcher headless load, original D267 full animation gallery scene load, six actual Court Battle setups, 54 original Court `BattleUnit` functional scenarios, direct-QA Fight→Reward→Table. Godot editor logs still include the **pre-existing unrelated** `assets/concepts/approved_battle_direction.jpg` import error; it does not invalidate these specific native tests or imply all project assets are clean.

## Original vs narrow Court-only tuning

| Metric (by party size: solo/duo/trio) | D268 initial 54-case run #6 | Court-only final run #9 |
|---|---|---|
| Victories | 54/54 (18/18/18) | **54/54 (18/18/18)** |
| Defeats / timeouts | 0 / 0 | **0 / 0** |
| Mean hero remaining HP | 86.29% / 78.42% / 82.77% | **83.84% / 75.54% / 80.16%** |
| Lowest hero party-mean HP | 69.05% / 62.42% / 68.08% | 60.95% / 55.52% / 66.67% |
| Average combat seconds | 11.68 / 12.78 / 11.34 | 11.43 / 12.76 / 11.32 |
| Individual fallen heroes across all cases | 0 / 0 / 0 | **0 / 0 / 2** |

Local `UnitData` change only:
- Magistrate: damage `8.0 → 9.0`, movement `49 → 55`.
- Scrivener: damage `5.0 → 5.5`.
- Bailiffs: damage `6.8 → 7.8`, movement `63 → 68`.
- No HP, attack cadence, party compensation, target selection, other encounter data or global `BattleUnit` AI changes.

Baseline #38 Road of Black Lanterns remains unchanged, as do hero balance, Fate Spread and DS2. Tuning is an initial **QA baseline**, not final difficulty certification: all 54 fixed authored cases winning is not a guarantee of live player experience.

## Marked-target mechanic: separate actual target-hold vs redirection

D268 originally asserted `bailiff_redirects > 0` and incorrectly failed. This is **not a correct matrix-wide criterion** when Bailiffs' ordinary nearest-hero targets already coincide with the Scribe's marked nearest hero. Instrumented diagnostics proved:
- Final run: 88 warning phases, 79 active verdicts; all **54 first activation cases had TWO living Bailiffs**.
- During active phase: **7,694 live Bailiff evaluation steps, 7,694 actually targeting the marked hero**, 0 observed target changes; 3,162 dead-Bailiff steps during later active phases. Thus marked-target *hold* works with living Bailiffs; no artificial retarget was needed.
- D262 native separate six-Battle boot and forced controller contracts verify the **retargeting path** where targets do differ. This matrix confirms functional targeting in normal formation, *not* high frequency of meaningful redirection; future combat design should keep the telegraph visible and the counterplay (kill Scribe).
- After Scribe death, controller stops; final run recorded 54 interrupts, no residual targets / controller leaks.

## Verified real route (QA-only)

`res://scenes/dev/court_of_the_mute_d268_qa_route_runner.tscn` obtained `D268_COURT_QA_ROUTE_READY` and `D268_COURT_QA_ROUTE_PASS` in workflow #9: direct unreleased QA Court encounter setup → real Battle with 4 D267 rich original enemies, original warning seal and D264 lower-floor bounds → Fight → victory → actual Reward claim → Table, resolved QA card. It **does not** claim normal Act1 dealing because `court_of_the_mute` remains absent from `ACT1_CARD_IDS` and `target_path = ""`, so it cannot be offered until a deliberate future release. Test-only headless observer emits `frame_post_draw` without changing production routing.

## Visual / release gates STILL OPEN

- All 3 original user-approved D267 character sheets and their 75 rich poses already in GitHub. Original 27 source-edge flags (5 Magistrate/0 Scrivener/22 Bailiff) remain **visual QA suggestions**, especially 3 merged Bailiff death cels. Native gallery scene load is not visual x1 approval. Use `res://scenes/dev/court_of_the_mute_d267_rich_animation_preview.tscn`, controls pause, prev/next frame and `27 МЕТОК`.
- D265 **provisional actor-free Court battlefield** is correctly shown instead of Crypt in real Battle, but is still simplified schematic QA art. A finished richly illustrated separate actor-free tribunal compatible with locked user-approved **bottom stone floor screen x40–1268/y532–710** remains to author and view. Use `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` for real 1/2/3 heroes + 2 formations.
- Original selected D261 second card illustration unchanged; **#39 NOT RELEASED** (38/45 live), `target_path` still empty; no normal dealt-card CI expected until an explicitly gated final art release. Frozen KARAMBA73 untouched.

**Next step:** one combined F6 x1 animation/battle-floor visual review, targeted sprite seam corrections if actual defects, finish genuine richly illustrated character-free tribunal, rerun real full route and balance with final art, then separately release #39 to 39/45. No re-approval of already selected card image or enemy visual identities, and no frame-by-frame user approval gates.
