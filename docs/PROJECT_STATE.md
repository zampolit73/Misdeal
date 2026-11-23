## Bone Warden XIII · throne intro

XIII opens with a 1.95-second rise from the throne, then hands off to Combat Planning in front of the empty throne. Click, Enter, Space or Esc skips to preparation. The original combat Warden takes over from his normal deployment position. [Godot verification](WARDEN_INTRO.md)

## Gameplay 2.0 · Wizard Archive

The main menu opens four archival sections. Each hero unlocks a distinct starting style by winning XIII, and five Wizard oaths form an opt-in difficulty ladder. Run save schema 3 keeps active settings and the independent archive retains long-term progress. [Rules, migration and native QA](GAMEPLAY_2_0.md#package-c--wizard-archive-and-new-runs)

## Gameplay 2.0 · Builds & Rewards

Act I has 13 relics. Conditional combat effects and the existing upgrades support blood, defense, Mage splash and Wizard economy builds. Dossier, Reward, the merchant and event results expose live effects and stat changes. [Catalog and QA](GAMEPLAY_2_0.md#package-b--builds--rewards)

## Gameplay 2.0 · Core

Heroes carry their wounds between fights and recover 25% of maximum HP after each victory. Rest stops after IV and XII and the merchant after VIII run outside the Fate Spread. The victory and paid Last Deal checkpoints retain health and handle old save slots. [Rules and QA](GAMEPLAY_2_0.md)

## Combat Audio V2

Act I battles use processed CC0 foley and quiet location beds from combat start through the result fade. The approved footsteps and the UI and Travel palette keep their original cues. [Sources](audio/THIRD_PARTY_AUDIO_LICENSES.md#combat-audio-v2)

## Act I sound cues

Live scenes use additional UI, Combat and Ambience cues. Arena openings use short faded excerpts by location family. The old D374 audition loops remain opt-in. [CC0 sources](audio/THIRD_PARTY_AUDIO_LICENSES.md)

## Event Choice Visual V2

All 24 Act I events use the approved bronze and burgundy decision frame, with separate parchment for the action and its effects. ActChoice and WhisperingWell share the skin and allocate more parchment to long descriptions. Live prices, restrictions, outcomes and mouse/keyboard controls still come from the original events. [Coverage and native gallery](EVENT_CHOICE_UI_VNEXT.md)

## D420 V2 — released in campaign

The player approved D420 V2, and PR #126 shipped in `d841d089`. All 24 new enemy animation packs are active by default in all 22 Act I encounters. The F6 gallery keeps both versions for comparison. [Review and native evidence](ENEMY_VISUAL_POLISH_V2_REVIEW.md) · [Production CI](https://github.com/zampolit73/Misdeal/actions/runs/44714818399)

## Living Arenas V3 — Act I coverage

The shared BattleBackdrop resolves all 22 encounters across 16 original paintings. The Ossuary and Death Wager atmospheres use distinct masks on a shared painting. QA Hub can compare, pause and replay all 17 profiles in the real Battle. [Implementation, coverage and checks](LIVING_ARENAS_V3.md)

## Living Arenas V2 — campaign rollout

PR #124 delivers local haze, dust and source lights for Last Bell, Ossuary Gate and Bone Warden XIII. The Warden's original phase transition ramps the backdrop effect. The shared Ossuary painting keeps its original presentation in Death Wager. QA Hub has a dedicated ЖИВЫЕ АРЕНЫ tab. [Implementation and native checks](LIVING_ARENAS_V2.md)

## Act 1 gameplay audit — static risk review and F5 playtest plan (2026-11-19)

Inspected live `main` at `28050652` and current encounter/progression/planning resources. A detailed [Act 1 gameplay audit and playtest plan](ACT1_GAMEPLAY_AUDIT_2026-11-19.md) now defines three real protagonist F5 runs, targeted F6 matched comparisons, event-choice/Travel pacing review, and Bone Warden XIII variants. Historic v25 Knight solo/duo/trio and Hunt imbalance are explicitly **unconfirmed on current Combat Planning main**. **No new human full run, balance measurement, gameplay change or art revision was performed.** Next step is evidence collection, not an automatic rebalance.

## Cinematic Travel Act 1 — final player acceptance (2026-11-19)

The player explicitly confirmed that all Travel scenes are satisfactory after the final 24-event coverage audit. **24/24 unique Act 1 event scenes are accepted and complete**: earlier seven + Batch 02 seven + Batch 03 ten (72 coded Batch 03 outcomes). Do not reopen their visual production unless a new concrete problem is reported. This is distinct from completion of a full human random campaign playtest. The already-released Combat Planning 1.0/Visual V4 across 22 combat encounters is also accepted. The next proposed focus is a full Act 1 gameplay playtest and balance/UX assessment; it is **not yet completed**. [New-chat context](NEXT_CHAT_HANDOFF_2026-11-19.md)


## Cinematic Travel Batch 03 — released (2026-11-19)

The user approved production rollout. Ten Act 1 locations and 72 resolved event outcomes now use Travel V2 in `main`, with character, companion, NPC and prop scale calibrated against the environment. Open the QA Hub to preview the batch or follow the normal event route in the campaign. [Merged PR #119](https://github.com/zampolit73/Misdeal/pull/119) · [Runtime and QA contract](TRAVEL_BATCH03_REVIEW.md)

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
