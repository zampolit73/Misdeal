# Visual polish — delivered result and release QA

Delivery: [PR87](https://github.com/zampolit73/Misdeal/pull/87) · [final-head CI checks](https://github.com/zampolit73/Misdeal/pull/87/checks). Merge requires successful full RELEASE; current check conclusion is authoritative.

User-authorized implementation: [brief](requests/2026-11-09-visual-polish-plan.md). [Audit](VISUAL_POLISH_AUDIT.md) separates evidence from approved no-change decisions. Original D414–D417 are merged; baseline main `d9613298`. Product fixes are separate reversible commits: `5b853875` Reward/canonical reader, `ddd7625f` merchant/state, `4093217c` RunEnd, `df4d131b` passive truthful backdrop readouts, `2dca35fc` full event tradeoffs, `1edd3cf7` Battle result canvas ordering. No new runtime artwork, sound or third-party dependency.

## Visible changes

| Area | Result | Evidence |
|---|---|---|
| Reward / all5 modes, all9 upgrades | Both positive and negative shorthand lines lie within original parchment; source text unchanged. Full original effect via RMB/F, arrows/PageUp/PageDown/Home/End scroll, ESC/Close restores focus. Clicking behind reader cannot grant reward. | [after Knight](qa/visual_polish/after/upgrade_knight.png), [full reader](qa/visual_polish/after/reward_details.png) |
| Reward and merchant environment | Reuse exact D416 approved cleanup; remove obsolete painted offers and painted inactive Squad action. Passive native context/counts use true RunState; numeric matte does not intersect live cards. | [normal loot](qa/visual_polish/after/reward_normal_loot.png), [shop](qa/visual_polish/after/shop_rich.png) |
| Merchant | Actual offered-upgrade picture and full effect, genuine price/eligibility; resolved labels become ВЫБРАНО/ВИЗИТ ЗАВЕРШЁН. Existing shop names/art catalog/game handlers remain. | [purchased](qa/visual_polish/after/shop_bought.png) |
| Story choices | Measured wrapped text with zero added line spacing keeps complete penalties visible; resolved labels no longer advertise availability. | [Blood Ledger](qa/visual_polish/after/event_blood_ledger.png) |
| RunEnd | Complete original summary in bounded native scroll; New Run stays separate; no text/stat loss. | [top](qa/visual_polish/after/end_full.png), [bottom](qa/visual_polish/after/end_full_scrolled.png) |
| Battle result | Same existing CTA at(964,619),262×77 now belongs to ResultOverlay and draws above its scrim. No HUD/arena/unit layout redesign; callback/timing unchanged, observers/styles updated. | [victory](qa/visual_polish/after/battle_result.png) |

[Interactive before/after comparison](qa/visual_polish/compare.html) uses actual native images.52 final frames cover production Main/Intro/ClassSelect/Table/Dossier/Fate/Reward/Event/Shop/Well/RunEnd/Battle states, plus all original modes and source upgrades. [Final manifest](qa/visual_polish/after/manifest.json) records exact local tested code SHA and fixture data; final CI artifacts record the checkout merge SHA. Contact sheets are indexed in that manifest order. Non-frozen combat motion may vary by frame scheduling; the CTA regression asserts actual canvas order and unchanged geometry.

## Observed checks

- Native Godot4.7.2 import: no script collection/parse/load errors.
- Full GUT: **224/224**,51 scripts,47,268 assertions; existing19 type warnings. Eight new visual regressions; no skipped parse failures accepted.
- QA selector: **13/13** Python unit tests; matrix changes request full RELEASE.
- Native matrix: **52/52** actual1280×720 frames, final product code `1edd3cf7` (later scene whitespace/docs/evidence only). Same seeded fixtures as48-frame baseline; additional reader/resolved/scroll/result views. Every changed view reviewed at native resolution; no confirmed in-scope P0/P1 remains.
- D273 ordinary Court route: actual normal39-card offer→Battle Fight→win→Reward→Table **PASS**. Repeated after result-action reparent.
- Local RELEASE equivalents: CI4 solo7 native frames/movement173.5px **PASS**; CI5 Court trio4 frames/movement117.71px and Grave Bell duo4 frames/movement121.95px **PASS**;75 original Court poses/3 roles **PASS**. Windows absolute-path guards corrected with `is_absolute_path()`; Linux behavior retained.
- D412 original75-pose source/grounding/facing/weapon tests intact; decoded SHA256 protects20 critical approved sources. No runtime asset files changed in this program. Fate0/4/8/12/XIII, I–XII geometry and real39-card gallery/readiness contracts remain tested.
- Final PR CI includes import/GUT/native smokes, D413–D417 sequences,52-frame matrix and full authored RELEASE, including special-wave break/crossfire and gallery. Final verified run/merge links are in the PR and handoff completion note.

CI42610788058 passed import and all224 GUT but exposed an obsolete D315 reward bound (old y272–310). Updated it to the stricter native parchment rectangle (48,282,220,32), matching reviewed render and new regression; standalone D315/D379/D380 local PASS. This changes QA only; final-head RELEASE rerun required.

## Limits / P2

No manual human full F5 playthrough is claimed. Existing Windows certificate-store/log environment diagnostics,19 GUT type warnings and D273 shutdown10 ObjectDB/1 resource diagnostics remain; route PASS precedes shutdown diagnostics. They were not hidden or claimed fixed. Older skeleton/Court art can differ from D412 hero detail but remains readable; automatic repaint is explicitly out of scope. Large dynamic paragraphs may shrink to10pt to retain every modifier; full original tooltip/read-only reader remains where applicable. No new approved-art/design direction was needed, and no fundamental mechanism changed.

## Local launch

This workspace already contains the result; stop an old preview and F5. Check Reward two-line effects/F, merchant actual effects/purchase state, scrolling long result summaries, TAB/R/RMB and enabled victory CTA. Dirty local project.godot/import changes are preserved; do not blindly pull/reset this checkout. A clean checkout may `git pull --ff-only origin main`, open project.godot in Godot4.7.x and F5.
