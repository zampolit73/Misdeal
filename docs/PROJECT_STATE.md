## Cinematic Travel Batch 03 — review branch

The native review build extends Travel V2 with ten Act 1 locations and 72 committed event outcomes. The review branch now calibrates hero, companion and NPC stature against each location and adjusts oversized props. Open the QA Hub and choose Batch 03 or an individual location. Production approval is pending. [Review contract](TRAVEL_BATCH03_REVIEW.md)

## Combat Planning 1.0 — production (2026-11-18)

The shared campaign Battle uses the approved Visual V4 dock by default, with one to three independent orders per hero. All 22 authored combat encounters use it, including Iron Wall and Bone Warden XIII. The F6 comparison pilot opts out of the campaign controller. [Merged PR #117](https://github.com/zampolit73/Misdeal/pull/117)

«Классика» restores the original orders, including one-use Sacrifice and Defiance. Between fights, the running session can retain encounter-independent drafts. Enemy assignments are local to their encounter and wave. Existing slots load with a safe single Assault order.

Godot 4.7.2 passed 313 GUT tests and the 22-encounter campaign smoke. Live engine route checks covered victory through reward and table, both Last Deal choices and Continue from a prior-version save. [Release contract and CI](COMBAT_PLANNING_ROLLOUT.md) · [Native captures](qa/combat-planning-release/README.md)

# Misdeal — current project state

## Production release: 2026-11-17

The user approved the final result and explicitly authorized production merge. [PR #114](https://github.com/zampolit73/Misdeal/pull/114) and [PR #115](https://github.com/zampolit73/Misdeal/pull/115) are merged into `main` at runtime release commit `c1bba4007198e1bac14fb9e4ae20f9d65ef1181c`. All earlier review-only/pending notes for this delivery are superseded.

- **Batch02 V2:** seven new locations and31 real outcomes through existing Travel V2. Actual event choices/RNG/purchases select the presentation without repeated effects or new save fields.
- **Broken Crown:** exact approved smaller crown, armour, sword and candles in all four outcomes. Party near-height330 and the approved up-right route into the garden opening are locked. Original V2 masters remain unchanged for rollback.
- **QA Hub:** searchable cards, events, Travel, combat, animations and interface tools; separate historical archive. Solo/duo/trio, gold/recruitment/upgrade setup; F9 replay, F10 return, F11 hide toolbar. Initial F6 startup and isolated run/memory profiles are covered.
- Existing Pilot11 outcomes, earlier unique Travel scenes, D412 atlases, Wizard/table, approved card art, gameplay, balance and saves remain preserved.

## Verified release

[Final-head full RELEASE CI passed](https://github.com/zampolit73/Misdeal/actions/runs/44058109794) on `f70f2a3b`; merged runtime tree is identical. Local Godot4.7.2: **301/301 GUT,77,821 assertions**, selector18/18, original279 asset hashes plus approved crown provenance. Native31/31 Event→Travel→Table routes, Pilot11/11, crown solo/trio movement/soles, QA launch/return/profile isolation, battle/animation/UI/save/memory and Living Arenas checks passed. Native PNGs and logs are retained by Actions; [crown outcomes](qa/crown_small_props/README.md), [route](qa/crown_road/midway.jpg), [hub](qa/qa_hub/travel.jpg).

Known existing GUT type warnings and production-route shutdown ObjectDB diagnostics are not hidden or labelled as a leak-free certification. No claim of a complete manual random campaign.

## Core constraints and next work

Godot4.7.x/GDScript; 12 Fate resolutions plus Bone Warden XIII; solo/duo/trio tactical autobattler. Keep the accepted design, 24-fragment Memory Glass and save/load behavior, approved artwork/animation and timing. No new fundamental architecture or speculative redesign is authorized by this release.

Address concrete new player feedback. Further content/visual changes require a new task and the applicable approval rules. Start with [handoff](HANDOFF.md), [QA Hub](QA_HUB.md), [Travel contract](TRAVEL_BATCH02_V2.md), [design system](DESIGN_SYSTEM.md). Detailed superseded implementation notes are preserved in [the release archive](archive/2026-11-17-production-release/PROJECT_STATE.md).
