## Final Visual Audit 1.0

Визуальная оценка первого акта на `d4b94d2b` — 8,1/10. Готов к управляемой демонстрации. Зафиксированы 4 P1 и 3 P2, подтверждённых P0 в проверенных сценариях нет. В Godot сняты все 24 стартовых экрана событий и актуальные кадры Врат оссуария и XIII. [Результаты и план исправлений](FINAL_VISUAL_AUDIT_1_0_HANDOFF.md).

## Reward Cinematics 1.0 · Death Wager Visual V1.2

The real Death Wager reward uses the approved V1.2 composition and the live relic catalog. It shows the active debt warning, the current extra-development progress and the existing gold alternatives when relics run out or development is capped. [Native QA](qa/reward_death_wager_v12/README.md)

## Camp Rest Visual V2

The stops after IV and XII use the approved camp plate and three live action cards. The view reads party HP, the oath-adjusted treatment, the chosen hero’s actual training offer and the stocked rite. [Native QA](qa/camp_rest_v2/README.md)

## Intro Visual V2

Intro V2 uses six untouched plates and live dialogue. The sixth frame moves the scene from the old hero’s home into the existing selection hall. [Native QA](qa/intro_v2/README.md)

## Hero Selection Visual V2

Hero selection uses the approved retouched plate and original D413 portraits. Focus and preselection stay separate from the existing protagonist confirmation. The charter uses the existing Archive unlocks. [Native QA](qa/hero_selection_v2/README.md)

## Main Menu Visual V2

The main menu uses the approved retouched background, original logo and four native buttons. The same save, new-game and Archive handlers remain in use. [Native QA](qa/main_menu_v2/README.md)

## Merchant Visual V2

The merchant after VIII uses the approved retouched scene. Its five offer positions are driven by the saved stock, with current prices and status. Card-event merchants retain their current presentation. [Native QA](qa/merchant_v2/README.md)

## Reward Cinematics 1.0 · Hero Development approved in main

The player accepted both development modes after PR #150 merged into main. Major and bonus upgrades use the approved Hero Development plate, actual role art and data, and one to three selectable offers. The empty bonus still pays 60 gold. [Native QA](qa/reward_development_v1/README.md)

## Reward Cinematics 1.0 · Elite Artifact approved in main

The player accepted the production Guardian Trophy screen after PR #149 merged into main. Crypt Guard rewards use the approved Guardian Trophy plate. The scene shows up to three actual eligible relics or the existing empty-cache payout. [Native QA](qa/reward_elite_v1/README.md)

## Reward Cinematics 1.0 · Normal Loot approved in main

The player accepted the production Normal Loot screen after PR #148 merged into main. Normal Loot uses the approved 1280×720 plate. The live gold amount follows the existing multiplier, and the wallet refreshes after a single claim. [Native QA](qa/reward_loot_v1/README.md)

## Run End Visual V2 · approved in main

The player tested and accepted the production victory and defeat screens on 2026-11-25 after PR #147 merged into main. Victory and defeat now use the approved 1280×720 plates. The live screen displays the run results, companion fates, relics, upgrades and Last Deal. [Godot QA](qa/run_end_visual_v2/README.md)

## Event Choice Visual V3.2 · approved in main

The player accepted the production rollout on 2026-11-25 after PR #146 merged into main. All 24 Act I event choice screens are approved. The approved V3.1 palette is the default for all 24 Act I events in V3.2: 23 through ActChoice and one through WhisperingWell. Godot 4.7.2 booted all 24 production routes and verified that every visible decision used the shared finish. The 1280×720 visual review covered three and four decisions and locked choices.

## Table Interface V5.1 · approved in main

The player accepted the production result after PR #144 merged into main. This closes the Table Interface V5/V5.1 visual milestone. The live table styling pairs matte wood and muted bronze with the existing journal, Memory window and grimoire. Status and Wizard text wrap, and the compact Fate Spread and Hold controls share the palette. Archive browsing preserves the active deal. [Approved reference and native review](qa/table_interface_v51/README.md)

## Wizard Archive Visual V2 · fully approved in main

The player tested and approved Challenges Visual V2 after PR #142 merged into main. All four archive tabs are now visually approved and released: Reliquary V2.1, Bestiary V2, Run Chronicle V2 and Challenges V2. Challenges displays three hero styles, four achievements and five oaths on the supplied cabinet plate. Seals and counts use existing archive data. Available oaths and victories on those oaths are shown separately. [Reference and native screenshots](qa/challenges_visual_v2/README.md)

## Run Chronicle Visual V2 · approved in main

The player approved Run Chronicle Visual V2 after PR #141 merged into main. The Chronicle places five live run records per page on the supplied plate. Details show the reached card, party, owned relics, style, oath and Last Deal from the existing profile. Godot 1280×720 captures cover empty history, XIII victory, defeat and page two. [Art packet and native review](qa/run_chronicle_visual_v2/README.md)

## Bestiary Visual V2 · approved in main

The player approved Bestiary Visual V2 on 2026-11-24 after PR #140 merged into main. The Bestiary uses the supplied 4×3 cabinet variant. It shows the 26 existing entries over three pages with live profiles, UnitData text and approved combat portraits. The Reliquary V2.1 art is approved in main. [Reference, Godot captures and QA](qa/bestiary_visual_v2/README.md)

## Ossuary Gate · visual audit

Current Godot 4.7.2 frames on `d4b94d2b` show low haze around the rear portal during preparation and at combat start. The start frame also records an overlapping bellkeeper label. [Audit evidence and follow-up](FINAL_VISUAL_AUDIT_1_0_HANDOFF.md).

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
