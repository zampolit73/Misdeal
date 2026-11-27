## Cinematic Travel V5 · relic wall-side staging correction

Player requested the Debtor Bones worksite against a wall and a smaller Broken Crown. Repainted the integrated debtor plate with a right-wall alcove, re-registered the local hand gesture, tabletop props, lights and hero routes. Crown width 67→43 px (−36%), all derived states and cloth trace reduced. Wizard Tithe unchanged. Godot 4.7.2 isolated 132 contexts / 26,589 checks / zero failures. Native F6 acceptance pending; 10/24 live, six staged, eight unstaged. [Correction QA](qa/travel_relic_v5/alcove_revision.md).

## Cinematic Travel V5 · relic transactions continuous-scene polish

After the player rejected insert-style animation, rebuilt all three staged candidates as a single cohesive human-scale scene: integrated scenery/NPCs, 20 local animated prop cels, 9 standing hero gestures, 2 registered NPC gestures, scene-matched contact shadows/reflections/lighting and continuous camera, distinct committed outcomes and synced existing sounds. F6 uses the same scene path. Godot 4.7.2 isolated 132 contexts / 26,215 checks / zero failures; sampled frames reviewed, native visual/audio acceptance pending. **10/24 live, six staged, eight unstaged**. No campaign selection, gameplay, saves or original card art changed. [Polish QA](qa/travel_relic_v5/polish.md).

## Cinematic Travel V5 · relic transactions staged

Three Batch02 candidates: Debtor Bones, Wizard Tithe, Broken Crown. New human-scale wide compositions and exact original action inserts; shared HD heroes/Jack, scene-specific routes, local worksite motion, 12 distinct resolved outcomes. 132 isolated Godot 4.7.2 contexts / 26,531 checks / zero failures. F6 native acceptance pending. **10/24 live, six staged, eight unstaged**. No campaign routing, rules, saves or original art changed. [QA](qa/travel_relic_v5/README.md).

## Cinematic Travel V5 · Borrowed Boots approved and live

Player approved the human-scale wide Borrowed Boots movie on 2026-11-28. Production explicitly adds only borrowed_boots to the Camp allowlist, yielding **10/24 V5 live**, three staged rescue previews, eleven unstaged. TravelCatalog passes the committed Final Five outcome (repair/hobnails/passed) unchanged, actual party and actual Ranger/Jack flag; exact F6 6.6s staging, action cues, caption, pause/skip and single Table navigation. Missing wide plate/profile returns to V4, direct legacy QA stays V4. Isolated Godot 4.7.2: 91 production contexts / 2,107 checks plus 9 missing-plate and 9 missing-profile checks, zero failures. Player accepted F6; integrated F5 visual playback pending. No rules, save or artwork changes. [QA](qa/travel_camp_v5/README.md).

## Cinematic Travel V5 · Borrowed Boots human-scale wide composition

Player rejected the giant foreground Squire relative to the party. New character-free wide establishing plate from the same project art, source-cutout worksite (same Squire/bench/shoes/shield/fire and all three exact footwear states), and all four existing authored work poses registered to one 0.21 source projection at (157,350). Seated height ~131px; standing customer ~150–155px at the same ground depth (soles y~513/518). Relocated customer and waiting slots, onward paths through the new gate, appropriate local lamp/cloth/ember motion. HD heroes, Jack, 6.6s timing, exact committed outcome and sounds retained. No card art, V4 sources, production router, rules or save changes. Isolated Godot 4.7.2: 122 contexts / 20,151 checks, 58 live / 1,284 and 12 missing-cel fallback checks, zero failures; offline composite reviewed, native F6 approval pending. 9/24 V5 live; four staged, eleven unstaged. [QA](qa/travel_camp_v5/README.md).

## Cinematic Travel V5 · animated Borrowed Boots Squire

At player request, animate the cobbler like the accepted smith, directly in the existing detailed foreground painting: four authored work cels plus original pose (pull strap, thread buckle, inspect travellers, press leather). Native 470×515 lossless WebP alpha patches registered to the original 1672×941 source, with the original twin-bone forearm, fixed legs/seat/heraldry and source-detail face. Deterministic local phases vary for repair, hobnails and passing; existing outcome switch, midground heroes, adult Jack, camera, props and sounds unchanged. Missing animation falls back to the original seated painting. Isolated Godot 4.7.2: 122 contexts / 19,975 checks, 58 live contexts / 1,284 checks and 12 missing-cel fallback checks; zero failures. Native F6 acceptance pending. Production remains 9/24 live, four staged (Boots and three rescue), eleven unstaged. [QA/provenance](qa/travel_camp_v5/README.md).

## Cinematic Travel V5 · camp accepted in part, Boots scale corrected

Player accepted Last Camp and Ash Rest; native screenshot of Borrowed Boots showed oversized, visibly magnified heroes in front of the high-detail painted environment. Boots-only ground projection reduced from 0.56 to 0.34 px/m per depth-pixel, moved the interaction and waiting slots onto the midground road, reduced peak camera zoom from 1.122 to 1.047. At the reported 2.5 s beat (trio) nominal projected body heights are now ~152/173/181px instead of ~313/400/409px; no changed cels, combat art, props or rule data. Jack retains shared adult stature. Offline sampled Godot composites inspected; native Boots acceptance remains pending. Last Camp/Ash Rest explicitly enabled in production using the committed batch03 action/party/Jack, accepted F6 cues and V4 fallback. Godot 4.7.2 isolated: 122 preview contexts / 19,138 checks, 58 production contexts / 1,284 checks, six missing-profile fallback checks, previous seven V5 regression 200 contexts / 3,902 checks; zero failures. Production **9/24 V5**, four staged (Boots and three rescue), eleven unstaged. [QA](qa/travel_camp_v5/README.md).

## Cinematic Travel V5 · camp and equipment review ready

Three additional 6.6 s F6 candidates: Last Camp, Ash Rest and Borrowed Boots (Костёр без хозяина). Existing exact outcome paintings and source-detail heroes/Jack, actual trainee gestures and single living recruit handoffs; scene-owned ground routes, adult dog scale, distinct equipment states and coherent gate exit. Reuses existing campfire projection, animated strap, canopy/lamp and audio. Godot 4.7.2 isolated: 122 contexts / 18,418 checks / zero failures; offline frame review, native visual acceptance pending. No gameplay/save/asset or live-routing changes. Production 7/24 V5, six staged including rescue, eleven not yet staged. [QA](qa/travel_camp_v5/README.md).

## Travel actor detail · all 24 locations upgraded

Player requested improved main-unit quality throughout Travel. Recovered painted source detail before the original 96px downsample for Knight/Ranger/Mage/Jack: 98 current Travel cels at 288px native resolution (logical 96px), side and both rear directions, Mage cast and the newer recovery/kneel cels. All 24 V4 renderers, seven live V5 films and three rescue F6 candidates consume the same presentation library; exact hero logical geometry, poses/timing, paths, paintings, outcomes and combat resources retained. Jack uses the same adult standing-size reference across all Travel scenes, with route spacing independent of scale. Missing HD assets fall back to existing sprites. Godot 4.7.2 isolated: 24 locations / 1,887 checks, fallback 17/17, four V5 preview suites (322 contexts / 46,727 checks) and three production-router suites (200 contexts / 3,902 checks), zero failures. Native player visual review pending. License inventory 35/35 registered, zero errors, legacy release audit pending. No change to 7/24 V5 live allowlist or saves. [QA, source hashes and rollback](qa/travel_actor_hd/README.md).

## Cinematic Travel V5 · ritual/prisoner/companion living-pose correction ready for F6

Player rejected reused death poses and miniature Jack. Three review-only films (Black Altar, Chained Prisoner, Jack) now use newly generated, individually authored living kneel/recovery cels on original character references: Knight on one knee, Ranger reaches gently, Mage supported rise, Jack alert rest→sit→stand. Original Mage staff-cast, paintings, outcomes, gait and actual routes preserved. Jack’s projected stature uses standing 56 px reference and 0.95 m head-to-ground height, matching the painted shelter animal (~115 vs 114 px), constant through walking and perspective. Godot 4.7.2 isolated: 128 contexts / 20,861 checks / zero failures; offline sampled frames reviewed, native visual acceptance pending. Registered new 384×384 atlas; license inventory 28/28 registered, zero errors, legacy release review open. Production remains 7/24 V5, 3 staged; no live rules or save changes. [QA and provenance](qa/travel_rescue_v5/README.md).

## Cinematic Travel V5 · approved road and danger batch live

Three independently staged 6.6 s films: Rattling Bridge, Whispering Well and Lost Purse. Preserve accepted bridge/well art and local motion, use single-file grounded paths, real rescue handoff, continuous careful crossing and explicit slip on failure. New wide purse plate normalizes corpse/prop proportions; intentional close-up uses the original four outcomes and authored glove grip; departure shot excludes the pre-pickup purse. Existing D412/Jack identity, explicit action keys and all gameplay/save rules retained. Isolated Godot 4.7.2 preview: 109 contexts / 9,525 checks / zero failures; F6 fixture launch and offline frame review complete. Player accepted the batch on 2026-11-27; production now opts in all three approved IDs, bringing V5 to 7/24 (17 remain V4). Exact committed action/party/Jack and accepted F6 cue timing, existing travel UI/skip/pause and one-shot navigation preserved; missing V5 profile or configuration failure falls back to V4. Isolated Godot 4.7.2: 112 road contexts / 2,077 checks and 9 missing-profile fallback checks, Forge 19 / 229 and Merchant 69 / 1,596, zero assertion failures. Native integrated F5 review pending; no asset, save or rule changes. [Preview, QA, provenance](qa/travel_road_v5/README.md).

## Cinematic Travel V5 · approved merchant batch live

Player accepted proportions/routes in the three 6.6 s Candle Seller, Blood Ledger and Gravedigger Shop previews; flagged old hands on ledger and inconsistent candle styling. All 17 props now independently repainted in the current environment light, clean alpha and same registered aspect/scale; grounded tabletop contacts, restrained shadows and candle-local light. Existing actor poses, camera, routes, outcomes, hero/Jack and approved Forge V5 unchanged. Godot 4.7.2 isolated: 66 contexts / 11,870 checks / zero failures. Player approved polished visuals on 2026-11-27. Production now selects these three approved 6.6 s cinematics after event resolution, bringing V5 coverage to 4/24 (including Forge); other 20 retain V4. Explicit ID allowlist, actual committed action/buyer/party/Jack context, existing travel UI, cue mixer, pause/skip and one-shot navigation retained; V4 fallback on missing assets. Isolated Godot 4.7.2 production routing: 69 merchant contexts / 1,596 checks, Forge regression 19 / 229, missing-prop/atlas fallback 9 + 2 checks, zero assertion failures. Native integrated F5 playback remains pending; no new art or gameplay/save changes. [F6 and provenance](qa/travel_merchant_v5/README.md).

## License Compliance 1.0 · cross-cutting release gate

Repository policy, registry, notices and local preflight now exist. 50 existing recorded external audio outputs indexed; GUT/fonts/Godot documented separately. Seven isolated Git/Python fixture tests passed; strict publication gate intentionally fails until historical source rights, font/dependency and package/engine credits review is resolved. No changes to runtime, approved art or gameplay; the current Travel V5/V4 review stays the next development task. [Policy](LICENSE_POLICY.md).

## Cinematic Travel V5 · Curse Forge approved and live

On 2026-11-27 player authorized one mini-cinematic pilot with realistic scene-relative hero/NPC/object proportion. New pulled-back forge plate, six original smith hammer poses, real D412 heroes, centered ground-plane metre projection, bounded camera, anvil foreground/depth, distinct four outcomes (actual buyer only), local cues and no gameplay state access. Originally a 6.6 s isolated preview, retaining all card art and V4 rollback. Godot 4.7.2 isolated headless: 19 contexts / 3,008 checks / zero failures. Player then requested the original non-pixelated smith: all six authored source poses now use lossless 576×576 cels, linear filtering and identical physical scale/sole anchors; heroes remain unchanged. Follow-up isolated Godot 4.7.2: 19 contexts / 4,471 checks / zero failures. Player approved the HD forge on 2026-11-27. Production Event→Travel→Table now selects the exact approved 6.6 s forge movie for its four committed outcomes, keeping the existing caption, skip, pause, audio mixer and navigation; unavailable V5 falls back to V4. At that activation the remaining 23 event locations retained their four-second V4 presentation (now 20 after merchant activation above). Isolated headless production routing: 19 contexts / 229 checks plus 2 missing-atlas fallback checks, zero failures. Native integrated F5 playback still to be checked; bespoke grasp remains optional. [QA and preview](qa/travel_forge_v5/README.md).

## Travel Staging V4 · calibrated routes and perspective

On 2026-11-27 the player accepted V3 and requested believable routes and scene-relative unit scale. Audited all 24 locations using actual Godot actor poses/contacts and offline plate composites; added 22 location-owned ground-plane profiles and calibrated the other two existing curves. Coherent size across outcomes, narrower formations in constrained space, existing directional frames on appropriate routes, corrected altar/well elevated stature and prisoner exit. Preserve V3 effects, approved plates, companion state, 126 outcomes, four-second clock, gameplay and saves. Godot 4.7.2 headless: 39/39 targeted tests, 20,660 assertions. Native visual review of V4 pending. [Staging contract and QA](qa/travel_staging_v4/README.md).

## Cinematic Travel V3 · all 24 Act I event locations implemented

On 2026-11-27 the player confirmed the three-location pilot was OK and authorized continuation. V3 now covers all 24 existing event scenes and all 126 catalog/presentation outcomes. Batch 02 (7) and Batch 03 (10) share distance-driven gait, grounded poses, coherent local overscan, authored action beats and location-specific subtle light/cloth masks where appropriate. Preserve pilot effects and the exact existing aftermaths, NPC handoffs and Jack scale. The seven earlier scenes retain their approved parallax, masks, moving props, bird/scissors/grain/recruit-free choreography and rear/side poses; gait and footstep timing now use their actual projected routes. Jack follows the real Ranger companion state in all 24, never occupies a hero slot. Generic combat travel, 4-second event clock, choice logic, progression, save schema, skip and pause remain unchanged. Godot 4.7.2 headless: 40/40 targeted tests, 15,603 assertions. Player accepted full rollout on 2026-11-27; requested V4 staging refinement. [Pilot and rollout contract](CINEMATIC_TRAVEL_V3_PILOT.md).

## Archive — Achievements UI V3 · approved and implemented

The player approved the two-mode layout on 2026-11-27 after inspecting native Achievement V2 pages with tiny clipped labels. Challenges retains three hero styles, the original four seals as an unlabelled preview, and five oaths. The live “Все достижения x/24” button opens a dedicated 4×3 cabinet reusing the current Bestiary plate and geometry, with two pages and the same Challenge detail controls aligned to the right. Stable titles are presented at 16 px with up to two complete lines (three short display aliases); the full title is 24 px, condition 19 px. Separate totals, original four motifs, locked/earned art, keyboard navigation and Esc back to overview; tab switching and leaving Archive preserve prior gameplay and save data. No new runtime art or mechanics. Godot 4.7.2: 13/13 targeted archive and achievement tests, 542 assertions; native player visual acceptance pending. [QA](qa/achievement_system_v2/README.md#achievements-ui-v3).

## Achievement System V2 · implemented

On 2026-11-27 the player authorized expanding the original four endgame achievements to 24 permanent achievements, in-run unlock feedback and a RunEnd summary. Catalog-driven stable IDs preserve the four original win predicates. Twenty additions cover card milestones, victory/defeat, relic and enemy collections, companions, gold, development, Wizard Wager, Fate Hold and accepting Last Deal. Archive schema 2 stores first earned date/run ID; schema 1 silently backfills only facts supported by saved history and collections (no fabricated gold/upgrades/actions). Unlocks occur after successful archive writes at real run checkpoints or enemy observations; failed writes retry without false or duplicate feedback. Achievement collection UI superseded by the dedicated two-page V3 view below; separate x/24 and aggregate x/32 counters; existing three styles/five oaths and their effects unchanged. Non-interactive toast queue and scrollable current-run summary use shared dark bronze UI, without gameplay rewards. Godot 4.7.2: 24/24 targeted tests, 518 assertions. Native visual acceptance pending. [Contract and QA](qa/achievement_system_v2/README.md).

## Wizard Archive Visual V3 · approved and implemented

On 2026-11-27 the player reported that the archive's vivid orange gilding, red velvet and bright parchment no longer fit the updated Main Menu and Cursed Deck. Player approved the V3 Reliquary concept and expansion to all four tabs. The actual four V2 cabinet plates remain the source; an archive-local canvas material grades the bronze/wood/velvet and covers the old header chrome. Native Menu V2 stone/bronze plaques replace the parchment detail surfaces and tab/header controls; bone/gold copy, selected burgundy, readable defeat color and subdued focus states. Preserve 13 relics/26 enemies, records, seals, original live art, hit areas, pages and profile semantics. Godot 4.7.2: 8/8 targeted tests, 153 assertions. Native framebuffer/player acceptance pending. [Reference and QA](qa/wizard_archive_v3/README.md).

## HUD Visual V2 · approved and implemented

On 2026-11-27 the player approved both archived Table and Battle header concepts. The shared native Menu V2 stone/bronze material now presents five live Table counters, a dedicated Wizard plaque, actual encounter/guidance, battle progress and real run modifiers. Existing baked Table contours are covered; conditional Table statistics extend upward, not into the Wizard dialogue. Long copy fits within the approved bounds with full tooltips; extra battle conditions remain accessible and modifier visibility follows the existing fight lifecycle. Preserve the D300 banner/medallion, card artwork, arena, V4 planner, input, progression, saves and gameplay. Godot 4.7.2: 13/13 targeted tests, 344 assertions; D289 and D291 headless smoke PASS. Native player visual acceptance pending. [Approved references](../assets/source_archive/hud_visual_v2/README.md) · [QA](qa/hud_visual_v2/README.md).

## Combat Intro Visual V1 · implemented

The existing battle-start / second-wave caption now shares the Main Menu V2 bronze/stone material and warm serif type with Battle Result V2. A non-interactive 520×130 title plate, actual encounter and a quiet divider replace unframed text; original arena scrim, entrance/hold/exit timing, combat signals and the Bone Warden throne intro remain unchanged. Godot 4.7.2: 9/9 targeted HUD/result tests, 244 assertions (live first fight, second-wave caption lifecycle and no stale overlay). Existing native campaign capture now includes the intro; native visual acceptance pending. [QA](qa/combat_hud_v1/README.md#combat-intro-visual-v1).

## Battle Result Visual V2 · approved in production

Player approved all three states on 2026-11-27: victory, Last Deal offer and final defeat. The same native Main Menu V2 bronze/stone and burgundy plates now frame the live result, actual encounter, payout, exact price and existing actions. The planned-mode report is inside the result; Classic has no invented report. Existing rules, save/rollback, journal, reward routing and RunEnd remain unchanged. Godot 4.7.2: 25/25 targeted tests, 469 assertions. The headless gameplay-core attempt stopped at the existing renderer-dependent scene transition; native CI capture now includes three actual result states, not yet executed. On 2026-11-27 the player confirmed the integrated production result is OK and implemented; the player acceptance gate is closed, without claiming a separate native CI result. [QA](qa/battle_result_v2/README.md) and [approved direction](../assets/source_archive/battle_result_v2/README.md).

## System Dialog V1 · approved Main Menu V2 family

The player approved the main-menu-based confirmation concept on 2026-11-26. Both production confirmations (New Game and Return to Main Menu from pause) now use the same native dark stone and aged bronze menu plates, muted burgundy decisive action and live serif text. The two new-run options, backup, Archive, Memory Glass and checkpoint semantics are unchanged. Cancel is initially focused, Esc closes only the current modal, focus returns to the opener and duplicate actions are guarded. Godot 4.7.2: 16/16 targeted tests, 321 assertions. Native capture is wired into existing release run-save CI; visual acceptance pending. [QA](qa/system_dialog_v1/README.md).

Native player screenshot exposed a zero-width automatic-wrap sizing defect in every dialog Label. Reproduced in Godot 4.7.2 and corrected using explicit line breaks within the approved text regions. Added deferred-layout geometry and visible-line regression for both dialogs: 17/17 targeted tests, 349 assertions. Player's next native screenshot confirms the New Game title, both descriptions and backup note now fit. A localized follow-up removes the opaque corner matte from dialog-only texture derivatives and highlights the existing bevel for focus; original Main Menu assets are unchanged. Isolated Godot 4.7.2 component test: 49 checks across both real dialog layouts (PASS), including preserved source pixels, safe focus, cancel and single dispatch. Final native visual recheck remains pending.

## Cursed Deck V3 · Camp Rest cards

Player requested the same Black & Gold appearance on «Первый привал» (IV) and «Последняя подготовка» (XII) after seeing the old ornate V2 cards. Both stops now use the shared native card front, title/copy/action colors, focus states and disabled restrictions. The three original illustrations are extracted at runtime with AtlasTexture from the unchanged V2 plate; an opaque mask covers the old baked frames. Training retains the live per-hero selector, and only overflow copy requires a tooltip. Existing rules, save and confirmation semantics remain unchanged. Godot 4.7.2: 29/29 targeted tests, 572 assertions (including real CampStop panel and disk save); native IV/XII capture added to CI, player acceptance pending. [QA](qa/camp_rest_v2/README.md#black--gold-v3).

## Cursed Deck V3 · Black & Gold — concept approved, implemented

Player reported poor readability on actual V2 Table/Fate screenshots and approved Black & Gold on 2026-11-26. The shared front is now a dark matte #211C19 surface with thin bronze rules, #E8CB95 headings/actions and #E5DBC4 descriptions. Larger fitted Table copy, gold revealed Fate titles, light event costs/restrictions and reward modifiers share the palette. Keep the original illustrations, hit areas, V2 backs/unknowns and approved non-card cinematic plates. Godot 4.7.2: 26/26 targeted tests (2605 assertions), D315/D316/D274 smoke PASS. Native framebuffer blocked locally; player visual acceptance pending. [QA](qa/cursed_deck_v3/README.md).

## Cursed Deck V2 · historical baseline, front superseded by V3

The player rejected the gold-edged V1 runtime appearance as visually mediocre and approved the replacement [Cursed Deck V2 board](../assets/source_archive/cursed_deck_v2/approved_reference.webp) on 2026-11-26. The shared native skin now renders weathered gray-beige physical paper with thin printed ink borders; original illustrations and localized live text remain separate. The matching dark moon-seal back and unmarked unknown texture replace the old live backs. Cards use quiet ink-action rules and subdued hover/keyboard-focus/selected outlines instead of heavy buttons. Table, inspection, known/unknown live Fate cards, 24 event routes, normal/bonus development, elite trophies and death wager use the same family. The original printed generic future slots and sealed XIII remain in the established Fate background; empty discard uses the neutral back to cover the painted example in the live layer, hidden art wells are no longer visible, and small titles can use two lines. Merchant cabinet and Wizard Wager retain approved non-card surfaces. Existing hit areas, artwork, data, gameplay and confirmation semantics are unchanged. Godot 4.7.2: 25/25 targeted tests, 2061 assertions; D315/D316/D274 headless PASS. Native framebuffer/player acceptance pending. [QA](qa/cursed_deck_v2/README.md). Combat Report V1 visual acceptance remains separate.

## Combat Report Visual V1 · production implementation

The player approved the exact archived concept on 2026-11-26. The campaign «РАЗБОР ПРИКАЗОВ» now mounts a centered, text-free leather/bronze/vellum journal over the actual battle result, with live class emblems, encounter title and per-hero wave/time events. Mouse/keyboard scrolling, single dismissal and focus return retain existing victory/reward and defeat/Last Deal routes; Classic remains unchanged. Executor journals are finalized once at combat end rather than on inspection. Godot 4.7.2 targeted validation: 19/19 tests, 208 assertions; native render in CI/user acceptance remain to be verified. [QA](qa/combat_report_v1/README.md).

## Interface Polish 2.0 · accepted in main

All three player-approved concepts (Pause Menu #159, Card Inspection #160 and Combat HUD #161) are merged into main. Combined Godot 4.7.2 tests: 32/32, 483 assertions; D274/D316 smoke PASS. The implementation-only integration follow-up also removes subpixel rounding fragility in the reader geometry test. No mechanics changed. CI #161 passed; on 2026-11-26 the player expressly accepted all three integrated interfaces in local Godot. [Regression route and next visual approval gate: Combat Report Visual V1](HANDOFF.md).

## Pause Menu Visual V1 · Interface Polish 2.0

The user approved the V1 concept and the production RunMenu now uses its isolated pause plate over the current scene. Five live actions, checkpoint restrictions, save/load behavior and confirmation remain intact. Godot 4.7.2: 14/14 targeted and save regression tests. [Reference and QA](qa/pause_menu_v1/README.md). Player accepted the integrated result on 2026-11-26.

## Wizard Wager Visual V1 · approved in main

The optional «Ставка Волшебника» offer now has its own approved isolated two-sided contract plate over the existing Table. Live text explains +25% enemy damage while debt is active, double normal loot and the «Жертва» order. Accept/refuse retain original RunState handlers; the modal owns keyboard focus. [Reference, layout and QA](../assets/source_archive/wizard_wager_v1/README.md). Merged [PR #158](https://github.com/zampolit73/Misdeal/pull/158) at `e9129d26`; player explicitly accepted the result on 2026-11-26. Preserve this presentation. The separate full Act I control run remains outstanding.

## Card Inspection Visual V1 · Interface Polish 2.0

The player approved the two-column reader concept. The shared Table/Reward modal now uses the isolated leather/bronze and vellum plate, enlarged original DS3 front, live title/type/copy and optional scrollable notes. Escape, close, outside click, keyboard/mouse scroll and focus return remain intact; no changes to mechanics or hidden outcomes. Godot 4.7.2: 3/3 targeted tests (44 assertions), D274/D316 smoke pass. [Reference and QA](qa/card_inspection_v1/README.md). Player accepted the integrated result on 2026-11-26.

## Final Visual Audit 1.0 · пакет исправлений P1

Четыре P1 реализованы и слиты в main через PR #157; P2-06/07 исправлены, P2-05 оставлен на нативную приёмку. 26/26 целевых и регрессионных тестов Godot 4.7.2. Сохраняются утверждённый арт, правила, цены, сохранения и текущий UI. Нативные кадры после правок, контрольный F5 и финальная оценка ещё не подтверждены. [Реализация, доказательства и остаток](FINAL_VISUAL_AUDIT_1_0_FIXES.md).

## Combat HUD Visual V1 · Interface Polish 2.0

The player-approved live active-orders panel is implemented with the existing V4 role emblems and DS3 materials, compact living-hero rows, real stage/tactic/timer and a separate real transition strip. Preparation, arena, units, objectives, combat logic and Classic mode remain unchanged. Godot 4.7.2: 15/15 targeted and planning regression tests, 166 assertions. [Concept and QA](qa/combat_hud_v1/README.md). Player accepted the integrated result on 2026-11-26.

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

## Living Arenas V4.1

Six arenas add readable flame, ember, smoke and stained-glass motion during preparation and combat through the existing shader. [Native sequences](LIVING_ARENAS_V4_1.md)

## Living Arenas V4 Lite

Six arenas reuse the existing backdrop masks for local reactions to combat start, wave II or victory. [Coverage and native frames](LIVING_ARENAS_V4_LITE.md)

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
