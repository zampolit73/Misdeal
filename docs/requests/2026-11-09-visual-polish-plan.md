# TASK FOR CODEX — MISDEAL VISUAL POLISH: AUTONOMOUS END-TO-END DELIVERY

## 0. Mission and autonomy

You are the lead visual-polish engineer / technical artist / UI-UX integrator for **Misdeal**, the dark-fantasy card-driven roguelike with a compact tactical autobattler, built with **Godot 4.7.x + GDScript**. Repository: **https://github.com/zampolit73/Misdeal**, production branch `main`.

**This is an implementation request, NOT a request for suggestions or further planning.** Independently inspect, implement, test, document and deliver the visual-polish program below. Do not ask the user for intermediate approvals, screenshots, local fixes, routine decisions or manual code copying. Decide small stylistic and technical questions conservatively using existing approved game art, screenshots and design-system constraints. Make meaningful Git commits and PRs, run genuine CI / Godot native checks, fix regressions, and merge completed in-scope, green changes where permissions and branch protection allow. Do not stop after a report, mockup, or prototype.

**Scope limitation is absolute:** this is a polish of the EXISTING game, NOT a redesign. Do not redraw or replace the main cursed table, the Evil Wizard, accepted combat arenas, approved card illustrations/DS3 frames, approved hero figures/75-pose D412 animation pack, or the Fate Spread background. Do not alter card inventory/selection mechanics, solo/duo/trio rules, 12 resolution positions I–XII or sealed XIII, combat stats, wave rules, economy, narrative canon, or reward probabilities. No new 3-card table deal, no new combat UI/skill system, no speculative mechanics.

User's visual direction: **less ornamental clutter, greater clarity, cohesion, material consistency, physicality and restrained feedback**. No extra candles, arbitrary runes, gold everywhere, strong glow, cluttered popups, particle showers, bright arrows or persistent target indications. Avoid AI-looking details. Use dark stone, blackened metal, aged bronze, muted burgundy, warm bone/parchment; gold and strong red only for meaning. Maintain live Godot labels/numbers/buttons; NEVER bake dynamic interface text into source art.

If blocked by absent Godot binary, permissions or unavailable visual evidence, use available repo CI/screenshot workflows and continue all other independent tasks. Never declare a check PASS unless it actually ran and passed. If a change would contradict a locked art approval or require a new art direction, do not silently implement it; log the limitation and take the safest in-scope alternative **without waiting for the user**. Do not force-merge failing or unchecked code.

## 1. Read source of truth and reconcile current work

Before editing, check latest `main`, open PRs, CI and read in order:

1. `AGENTS.md`
2. `docs/CONCEPT.md`
3. `docs/PROJECT_STATE.md` (newest entries)
4. `docs/ROADMAP.md` (newest entries)
5. `docs/DECISIONS.md`
6. `docs/HANDOFF.md`
7. `docs/DESIGN_SYSTEM.md`, `docs/DS3_FOUNDATION.md`
8. `docs/ART_DIRECTION.md`, `docs/VISUAL_ASSET_REGISTRY.md`
9. `docs/D314_NEXT_VISUAL_PASS.md`, `docs/D315_CARD_DS3_AUDIT.md`, `docs/D361_ACT1_FINAL_QA.md`, `docs/D381_FATE_SPREAD_QA.md`
10. Current phase-specific QA docs and executable code before changes.

GitHub is the technical truth. Documentation may have stale historical "PR pending" paragraphs: validate live PR API / merge commits, not only text.

**Snapshot verified 2026-11-09 (recheck live first):**

- `main` = `3c364bb4` (D412/PR #81 and D413/PR #82 merged).
- PR **#83 / D414**: dossier relic illustrations, specialization/footers; branch `codex/d414-dossier-reference-polish` → `main`; CI passed.
- PR **#84 / D415**: choose protagonist using dossier art/UI; branch `codex/d415-class-select-dossier-art` → `main`; CI passed.
- PR **#85 / D416**: remove obsolete baked offers from existing tabletop background, preserving everything outside a localized middle area; branch `codex/d416-clean-table-backdrop` → **D415 branch**; CI passed.
- PR **#86 / D417**: restrained hover / entrance / press visual feedback; branch `codex/d417-ui-motion-polish` → **D416 branch**; CI passed.

**First perform an integration/review pass**: merge #83 and #84 safely (order chosen to minimize conflicts), then rebase/retarget or otherwise safely restack #85 onto updated `main`, validate and merge it; then restack #86 onto updated `main`, validate and merge it. Maintain minimal diffs and correct PR history. The #85/#86 PRs are stacked and MUST NOT be merged blindly as if independent; confirm final diffs contain no duplicated prior phases. Preserve the D413 dossier and accepted D412 assets. If merge strategy requires a different order, explain it in the PR log and proceed safely. For each PR verify actual final CI status on the final head SHA, not just older successful checks.

Do not duplicate already-written D414–D417 implementations as new work. Do not overwrite concurrent user changes, delete untracked assets, reset the worktree, force push, blanket ignore `*.import` / `*.gd.uid`, or change `project.godot` as unrelated hygiene.

## 2. Establish one visual baseline and QA matrix

Create a reproducible **actual Godot 1280×720 screenshot matrix** covering production scenes and actual data (not generated fictional UI):

- Main menu and Intro (at least opening and ending frame).
- ClassSelect: idle, selected Knight/Ranger/Mage, confirmation.
- Table: two choices; selected/hover/held; one choice; rejected/discard; hover/RMB inspection; normal and cleaned background.
- Dossier: Knight/Ranger/Mage; upgrade purchased; relic empty/equipped; lost or unavailable hero; TAB focus/close.
- Fate Spread: early 0/12, mid 4/12 and 8/12, 12/12, XIII, held/rejected cards and correct Roman numerals.
- Battle: at least one solo, duo and trio state; representative skeleton encounter and special wave encounter; mage/ranger/knight vs enemies at actual battle scale; normal, attack, hit/death; tactic options 3/4/5 and combat result.
- Reward: **all real modes** (`major_upgrade`, `bonus_upgrade`, `normal_loot`, `death_wager`, `elite_artifact`), mixed hero classes, long effects and costs.
- Events: regular story decision, Gravedigger Shop, an event with complex conditions/costs, a special presentation such as Whispering Well.
- RunEnd: victory and defeat if supported by scene state.

Reuse `scenes/dev/qa_hub.tscn` and existing smoke/preview infrastructure, including `scenes/dev/d315_card_ds3_gallery.tscn`, `scenes/dev/d413_squad_dossier_preview.tscn`, Table/Reward/Event/Battle actual scenes and existing native screenshot scripts. Add only focused fixtures for missing variants. Do not create screenshots by faking game state into a static poster. Save compact evidence to `docs/qa/visual_polish/` or CI artifacts, including before/after screenshots and a manifest of exact branch SHA and fixture data. Avoid hundreds of unchecked or redundant tracked images. If direct screenshot access is unavailable, report precisely which views were structurally verified vs actually rendered.

Create a brief `docs/VISUAL_POLISH_AUDIT.md` with a matrix: screen, verified issue, severity P0/P1/P2, existing approval lock, fix or deliberate no-change, evidence path, regression test. Prioritize problems **seen in native screenshots or proved by layout assertions**, not a theoretical redesign wish list.

## 3. Polish work packages (execute, not just propose)

### VP1 — Shared legibility / UI quality (highest cross-screen priority)

Audit and correct *only concrete failures* in headings, copy, status counters, keyboard hints, disabled/selected/hover/focus states, scroll and tooltips. Inspect clipping, incorrect visual centering, long Cyrillic words, 2-line bounded descriptions, overlaps with frame ornaments, and contrast against actual rendered backgrounds. Use locally scoped DS2/DS3 helpers and reuse approved textures; **do not globally reskin every Control**. Preserve the D328 exact DS3 single outer card frame, original approved artwork colours, physical sizes, optical centering. Improve UI consistency across Table, Dossier, ClassSelect, Reward, Event and RunEnd without changing layouts wholesale.

Key files to inspect: `scripts/ui/misdeal_ui_kit.gd`, `scripts/ui/misdeal_ds3.gd`, `scripts/ui/card_ds3_skin.gd`, `scripts/table/table_offer_skin.gd`, `scripts/table/card_lore_inspect.gd`, `scripts/reward/reward.gd`, `scripts/event/act_choice_ds2.gd`, `scripts/event/gravedigger_shop_ds2.gd`. The old UI kit may be used by other scenes: guard unrelated consumers.

Acceptance: all critical labels visible at 1280×720; no clipped or overlapping live text; chosen/disabled actions distinguishable; all player-visible changes are tested on actual controls; narrative text and numerical effects are truthful.

### VP2 — Reward / relic / upgrade (first focused artistic priority)

Preserve the existing Reward environment and approved DS3 card materials. Audit real Reward layouts and all modes. Check that every reward has obvious identity, benefit, cost, class eligibility and click target; uncommon/elite rewards may receive restrained existing-art highlight, NOT fake invented rarity or new items. For 9 existing upgrades / reward/artifact catalogs, ensure image mapping is correct and source portraits correspond to actual roles. Respect the D379/D380 solution: card quick-effect has at most two truthful lines; no hidden negative trade-off or made-up summary; full details remain accessible. Avoid excessive glow and extra borders.

Relevant: `scenes/reward/reward.tscn`, `scripts/reward/reward.gd`, `scripts/reward/reward_visual.gd`, `scripts/ui/card_art_catalog.gd`, `scripts/ui/artifact_art_catalog.gd` (check actual path), `scripts/ui/card_ds3_skin.gd`, `resources/artifacts/`, `resources/upgrades/`, `assets/pixel/ui/artifact_polish/`. Reuse D414 relic art and already approved assets. Do not invent new physical artifacts or new illustrations if the approved artwork is available.

Acceptance: 3-card choices readable, no lost modifier or inaccessible CTA, equipped relic art/effect valid, empty and unavailable states accurate, no change to stats, gold, upgrade or loot logic. Compare snapshots of game state before/after opening/closing UI.

### VP3 — Events, merchants, story choices

Inspect `scenes/event/` and `scripts/event/act_choice.gd`, `act_choice_ds2.gd`, `gravedigger_shop_ds2.gd`, `whispering_well.gd`, approved choice art. Standardize the visual semantics of **cost, risk, locked/unaffordable, available, resolved, leave/continue** across existing event types without turning all events into the same generic window. Preserve each event's atmospheric background and wording. Ensure long prose is legible, buttons do not overlap the art, condition labels and prices agree with actual RunState and narrative choices.

Acceptance: at least normal event + merchant + special event screenshot/interaction tests. No newly introduced costs, choices, companions, story facts or path shortcuts. Keep the player's Act I Castle Memory canon unchanged.

### VP4 — Combat readibility, not battle redesign

Battle DS3 was explicitly artistically accepted (D314). **Do not redesign the HUD or approved arenas.** With D412 hero pack now live, audit at game scale whether all three heroes and legacy enemies have readable silhouette, relative size, floor-contact shadow/sole, facing and HP-bar placement, including movement and hit/death transitions. Verify combat effects do not hide actor identities. Inspect contrast of weapons and effects against representative arenas, and special wave briefing/tactic order text for clipping (D385). No permanent aim arrows, colored debug rectangles, busy screens, auto-select highlights or camera-shake barrage.

Relevant: `scenes/battle/battle.tscn`, `scripts/battle/battle.gd`, `unit.gd`, `unit_animation_library.gd`, `battle_ds3_pass.gd`, `battle_visual.gd`, `battle_motion_fx.gd`, `unit_attack_visuals.gd`, `deployment_floor_markers.gd`, active arena art and approved D412 atlas files.

**Fix only evidenced visual defects** and scope to affected unit/scene. Preserve accepted D404 walk, D405 attack timing, D412 art/frame order/scale approval, AI, hit rules and encounter parameters. New sprite redrawing is OUT of scope. If older enemy assets are too different stylistically, record a ranked follow-up rather than auto-repaint a unit library.

Acceptance: all hero silhouettes and weapon identity recognizable, planted feet, health bars clear, no gameplay state change; Battle→Reward→Table route still works.

### VP5 — Fate Spread, Table and card-inspection integrity

**Do not alter table art/Wizard/repaint `fate_spread_exact.webp`.** D416 may remove old baked card depictions in its precise region; ensure no unrelated pixels changed, and that it works under real card selection animation. Audit real Table overlays/hold buttons, text and card hover. Preserve **two** normal offer cards.

For Fate Spread, inspect D381 geometry/cleanup: resolved I–XII, hidden future cards, fixed VI label, masks over baked example cards, XIII, held/rejected piles and dynamic counts. Stop old baked example text from bleeding into live states; fix by local overlay masks/geometry only where proven. Avoid touching approved Fate background.

Relevant: `scripts/table/table.gd`, `table_visual.gd`, `table_offer_skin.gd`, `fate_spread_overlay.gd`, `fate_spread_geometry.gd`, `fate_spread_reference_cleanup.gd`, `card_lore_inspect.gd` and scene counterparts. Regression must cover keyboard R/TAB, RMB inspector, hold/reject, one/two card states and exact RunState invariants.

### VP6 — Main menu / Intro / RunEnd visual consistency

Their source backgrounds are already strong and should remain unchanged. Check actual button readout/hotspots, fade and progression, text lengths, victory/defeat summaries, and Return/New Run. `scripts/intro/intro.gd`, `scripts/main/approved_main_backdrop.gd`, `scripts/run_end/run_end.gd`, `run_end_visual.gd`. Fix real clipping/poor contrast, simplify distracting generated procedural chrome if clearly overlapping or visually inconsistent; never replace the approved paintings with generated alternatives.

### VP7 — Motion and feedback, finish D417

Validate and refine already-written D417 limited fades and rises (dossier/Fate/inspector), restrained table/card hover, ClassSelect choice and Reward entrance/hover/commit, button click press/reset, rapid hover and modal close during opening. Avoid duplicate tweens, delayed gameplay callbacks or input dead zones. Maintain instant or original timing of gameplay actions. Test rapid repeated input, keyboard and mouse, disabled state and event transitions. Do not add another animation library or complicated VFX system.

## 4. QA and release requirements

For EVERY new scoped PR / change:

1. Run editor import with the repository-supported Godot 4.7.x (CI uses 4.7.2), GDScript parse and applicable existing GUT tests. Fail on test collection/parse errors; do not mistake skipped tests for PASS.
2. Run relevant F6 scene smokes plus **actual** 1280×720 image captures (or CI's native GPU captures) for the changed states. Review the screenshot itself: not just file existence. Check for occluded text, dark unreadable wells, lost borders, doubled backgrounds, wrong aspect/crop, gray placeholder boxes, overflow, title mis-centering, unreachable controls.
3. Capture before/after on identical actual RunState fixtures, with annotated differences in the QA doc. Avoid unintended full-screen visual drift.
4. Add focused regression tests for every fixed root cause; check no RunState mutation by purely visual UI operations.
5. Execute at least one real automated Battle→Reward→Table progression path after shared UI changes. Include actual Act I 39-card gallery/art readiness tests, 12 Fate states and XIII structural contract. Run full existing GUT / smoke workflows as appropriate; trigger RELEASE-mode matrix if available and feasible. Do not claim manual full F5 playthrough unless performed.
6. Never mark 'visual acceptance' purely from code or success status: actual captured image inspection required. The user delegates **routine in-scope** aesthetic judgment to you; accept only if clearly better than baseline and faithful to locked art. Roll back a visually worse polish even if technically green.
7. Preserve prior work, backups, Git metadata. Prefer small, independently revertible PRs over one giant UI change. Do not merge on CI failure. Make precise, explanatory commit messages, avoid meaningless Dxxx spam.

**Hard no-regression checks:** existing cards and text, approved image paths/hashes where locked, three hero identities, all 75 D412 source frames, active player/enemy stats, wave rules, Fate I–XII + XIII, real reward modes, party recruitment/loss and save state, 1280×720 navigation, no fake UI or invisible interaction zones. No new sounds/ambient loops; production sound baseline is intentional silent-first.

## 5. Recommended execution order, completion and handoff

Execute to completion in this sequence:

1. **Integrate existing PRs #83–86** correctly (including stacked dependencies), review final CI/head SHAs and screenshots; merge only when safe.
2. Build native visual baseline/matrix and a concise severity-ranked audit. Distinguish actual proven bugs from subjective preferences.
3. Implement **VP1** typography / state polish; **VP2** reward & relics; **VP3** events and merchant; each in focused PR(s) with evidence and QA. These are the highest ROI.
4. Implement **VP4** targeted combat legibility fixes; **VP5** Fate/Table overlays; **VP6** menu/intro/end as needed. Do not change approved art just to create work.
5. Verify **VP7** existing D417 animation behavior in every affected screen, repair any failures.
6. Final cross-screen 1280×720 QA, game navigation, CI, regression capture, and release readiness status. Fix all P0/P1 issues within scope; mark a genuine out-of-scope/new-art problem as a follow-up rather than modifying canon.
7. Update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` **only for new binding decisions**, `docs/HANDOFF.md`, `docs/VISUAL_ASSET_REGISTRY.md` **only if assets changed**, `docs/INDEX.md` if adding indexable files, and `CHANGELOG.md`. Keep latest summaries short and accurate; don't reproduce historical logs. Leave a handoff sufficient for another clean Codex session to continue from GitHub alone.

**Definition of done:** all existing PRs are safely reconciled; new confirmed P0/P1 visual errors addressed; unchanged accepted artwork protected; Godot import + full relevant GUT + native screenshots + key game routes pass; no unhandled overlaps, hidden costs, wrong visual states or persistent UI duplicates; documentation, PRs and commits are coherent and discoverable.

**Final response to user (one concise report, in Russian):**
- merged PRs/commits and final `main` SHA;
- exactly which screens visibly improved (and which were left unchanged on purpose);
- screenshot comparison links and actual Godot/CI run URLs;
- the exact tests run and observed PASS/FAIL, any genuine blockers or remaining P2 items;
- only essential user action: normally `git pull` **if the user's local Git state is clean**, then F5 and a short concrete checklist. If local checkout has unresolved conflicts, do **not** suggest blind pull/reset; provide safe read-only diagnostics first.

Start implementing immediately. Do not request approval between phases. Keep work strictly within existing Misdeal visual direction.
