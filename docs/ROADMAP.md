# Misdeal — Roadmap

This roadmap is intentionally focused on reaching a playable vertical slice quickly.

## Phase 0 — Combat proof of concept

Status: complete

- [x] Godot project boots.
- [x] Main screen transitions into battle.
- [x] Spawn 3 heroes and 3 enemies.
- [x] Automatic target acquisition.
- [x] Automatic movement.
- [x] Automatic attacks.
- [x] HP and death.
- [x] Victory / defeat detection.
- [x] Restart encounter.
- [x] Pre-battle player unit placement.
- [x] Three pre-battle tactical orders that change hero target selection/engagement behavior without adding mid-fight micromanagement.

## Phase 1 — Tactical autobattler slice

Status: complete

Goal: make preparation meaningfully affect battle outcome.

- [x] Player can reposition party before combat.
- [x] Clear preparation phase and combat phase.
- [x] Prevent illegal placement outside the deployment zone and overlapping hero drops.
- [x] Improve combat-time unit spacing/readability with separation steering.
- [x] Move unit definitions toward data-driven Resources.
- [x] Add at least one distinct enemy behavior: Bone Archer keeps distance.
- [x] Add at least one simple unit ability or combat modifier: Mage splash damage.
- [x] Improve combat feedback enough to read hits and deaths.

## Phase 2 — First complete game loop

Status: complete

Goal: prove the Misdeal concept outside the battle sandbox.

- [x] Create cursed table scene.
- [x] Present three playable combat cards.
- [x] Choose among multiple encounter cards.
- [x] Launch combat from a card encounter.
- [x] Resolve victory/defeat back into persistent prototype run state.
- [x] Present a three-option reward choice.
- [x] Return to the table with reward effects persisted.
- [x] Add multiple playable cards and complete a three-victory sequence ending in a run result.

Target loop:

`table -> card -> combat -> reward -> table`

## Phase 3 — Build identity

- [x] Add first visible wizard host/antagonist presence at the table.
- [x] Wizard reactions and short commentary.
- [x] First active Wizard interference: two rare visible card substitutions per Act 1 run, one mid and one late.
- [x] First voluntary Wizard wager: accept +25% enemy damage on the next combat in exchange for x2 next ordinary loot, or refuse without mechanical punishment.
- [x] Wizard Memory v1: narrative-only memory of wagers, companion fates, debt-clearing, defeats/retries and greed-heavy choices with contextual table reactions.
- [x] Multiple encounter types: combat cards plus a non-combat event.
- [ ] More party archetypes.
- [x] Per-run protagonist class choice with solo start.
- [x] Hard-roguelike companion recruitment/loss through existing Act 1 cards.
- [x] Variable solo/duo/trio combat composition with visible incomplete-party compensation.
- [x] Restrict upgrade/relic offers to heroes actually recruited in the current run.
- [x] First artifacts that alter hero autobattle behavior.
- [x] First hero build-progression layer: nine role-specific upgrades with one guaranteed major choice per Act 1 tier.
- [x] Replace ordinary post-combat HP/damage reward choices with tier upgrades plus simple gold loot.
- [x] Rework Death Wager reward into gold / artifact / extra hero-upgrade choices.
- [x] Rework positive event-card stat rewards around hero upgrades, relics and build identity; retain raw stats mainly as costs/penalties.
- [x] First progression-economy balance pass: cap optional hero upgrades at 3 per run and retune Bone Warden for 4–6-upgrade builds.
- [x] Squad-status/build-inspection modal with effective stats, upgrades, relics and dynamic specialization names.
- [x] First risk/reward event card: Whispering Well.
- [x] First boss encounter: Bone Warden with an enrage phase.
- [x] Bone Warden two-phase gameplay rework with cleave and phase-two reinforcements.
- [x] Dedicated Bone Warden combat sprite, boss-card art and boss-arena treatment.
- [x] Expand the prototype run into a 12-card Act 1 plus boss.
- [x] Two-card offers with rejected cards removed from the current run.
- [x] Data-driven 24-card structural pool split into early/mid/late tiers.
- [x] Replace prototype card resolvers with real mechanics for the full 24-card Act 1 pre-boss pool.
- [x] First real recovery card: Ash Rest.
- [x] First functional shop: Gravedigger Shop.
- [x] First artifact-choice card: Curse Forge with three hero-specific artifacts.
- [x] First support enemy behavior: Grave Bellkeeper healing pulse.
- [x] First swarm encounter: Bone Crush with five Bone Thralls.
- [x] First elite encounter: Crypt Guard with guaranteed artifact reward.
- [x] Real Black Altar risk/reward event.
- [x] Real Chained Prisoner choice event.
- [x] Real Debtor Bones gamble event.
- [x] Wizard Tithe temporary-debt event with harder combat and doubled normal reward.
- [x] Late Faceless Card hidden-outcome event.
- [x] Late Blood Ledger resource-conversion event.
- [x] Source-locked Broken Crown party-wide artifact card.
- [x] Last Camp pre-boss preparation event.
- [x] Ossuary Gate mixed-archetype late combat encounter.
- [x] Rattling Bridge early traversal event.
- [x] Lost Purse greed event.
- [x] Candle Seller early micro-shop event.
- [x] Bone Tax forced payment event.
- [x] Death Wager late elite combat with enhanced reward.

## Phase 4 — Vertical slice polish

Only after the loop is fun:

- [x] First procedural visual blockout for table, cards, wizard and unit silhouettes.
- [x] Integrate first authored table, wizard, card-back and unit miniature assets.
- [x] First pixel-art combat readability redesign with larger silhouettes, ground rings and compact HP UI.
- [x] Pixel battle presentation pass with atmospheric arena decor, HUD chrome and attack motion.
- [x] Multi-arena Act 1 pass with data-driven crypt, graveyard, ossuary and Bone Warden lair families.
- [x] Replace weak procedural arena overlays with four authored pixel-art battle backdrops selected by `arena_id`.
- [x] Remove nearest-neighbor 2× arena presentation.
- [x] Package true native 1280×720 authored assets for crypt/graveyard/ossuary/warden through a repository-safe binary staging path.
- [x] Recompose live battle UI/arena toward the approved gothic pixel mockup.
- [x] Replace the procedural battle arena with the authored second-reference backdrop while keeping combat/UI layers live.
- [x] Replace the core Knight/Ranger/Mage/Skeleton/Bone Archer set with pixel sprites and scale the live unit presentation accordingly.
- [x] Complete high-detail sprite pass for all nine current combat roles: heroes, base undead, support, swarm, elite and boss.
- [x] Convert main menu, table/cards/wizard, event, reward and run-end UI to the same pixel-art language.
- [x] Rebuild the wizard table around an approved authored pixel concept while keeping live Godot HUD/cards.
- [x] Physical card-table staging pass: deck/discard zones, fate spread, dealt-card motion, fan/hover lift and choose/discard animation.
- [x] Rich procedural table-art dressing experiment rejected in local visual review and superseded.
- [x] Clean wizard-table art pass: remove procedural hands/heavy frames, retain physical deal motion with restrained deck/discard/progress dressing.
- [x] Table hierarchy polish: dim baked background cards, compact the top HUD/commentary and move the fate counter to the table edge.
- [x] Add a shared runtime gothic UI kit for main menu, Class Select, Wizard table/wager, Squad Dossier, Act 1 events, Whispering Well, Reward, Battle HUD/Last Deal and Run End while preserving live text/state.
- [ ] Locally verify the shared UI-kit pass at 1280×720 for card text margins, corner chrome, hover/disabled states and modal readability.
- [ ] Coherent visual language for table/cards/miniatures;
- [x] First lightweight combat animation/impact pass: idle motion, role-aware attack motion/tracers, hit kick and death fall/fade.
- [x] Combat presentation v2 pass: arena-integrated unit lighting/rims/shadows, hit-stop/sparks, distinct death treatment, gothic tactical HUD, Wizard battle commentary, dynamic arena atmosphere and cinematic fight start.
- [x] Unify protagonist select, all Act 1 event choices, reward/upgrade screens, fallback event cards and Wizard wager modal under the approved dark-gothic ritual UI language.
- [x] Replace temporary combat-sprite UI fallbacks with the accepted authored choice/development art for approved Development, Curse Forge and Chained Prisoner cards.
- [x] Integrate the approved full pixel-art set for all 25 active Act 1 table cards, all nine hero-development paths and six reward-state cards.
- [x] Fill the remaining generic Act 1 event choice-card art slots from the active card illustration while preserving dedicated Forge/Prisoner choice art.
- [x] Replace the rejected thumbnail-resolution card-art atlases with near-display-resolution approved-art atlases.
- [x] Polish Wizard wager and Curse Forge presentation, and replace generic relic imagery with object-centric artifact art across forge/reward surfaces.
- [x] Tighten Wizard Wager after local review: larger term art, stronger risk/reward separation, contract sigil and dedicated accept-button glow.
- [x] Fix shared event/footer overflow and Squad Dossier layering after local screenshot review; rebalance dossier portrait/stats/build columns.
- [x] Polish the shared Act 1 event-window hierarchy: framed context art, compact state chips, semantic risk/role accents and upgrade-specific choice illustrations; bring Whispering Well into the same card hierarchy.
- [x] Integrate the approved Whispering Well / Chained Prisoner card mockups: exact choice-art crops, taller art bands, semantic accents, medallion dividers and explicit disabled-state ribbons.
- [x] Add the first cross-card consequence set: Lost Purse → Gravedigger Shop, Debtor Bones → Wizard Tithe, Blood Ledger → Broken Crown.
- [x] Replace anonymous blood-rescue HP taxes with named protagonist rescue scars and surface them in effective stats / Squad Dossier.
- [x] Expand Wizard Memory for rescue scars, long solo runs and deliberate abandonment of both companions.
- [x] Add the one-battle cursed tactical order **ЖЕРТВА** as an optional follow-up to an accepted Wizard wager.
- [x] Add restrained Wizard table tells: wager-history deal cadence, pre-meddling card twitch and memory-linked card/commentary pulses.
- [x] Replace free combat retry with the one-use **ПОСЛЕДНЯЯ СДЕЛКА**: sacrifice an owned relic or take a -15 max-HP brand to retry the same fight; refusal or a later defeat ends the run.
- [ ] Locally verify the Last Deal branches: relic payment, no-relic brand payment, refusal, second defeat, boss defeat and run-end summary.
- [x] Run a static post-Last-Deal balance audit of baseline solo / duo / trio output and preserve the current fixed benchmark numbers rather than making speculative global retunes.
- [x] Split battle preparation HUD into concise encounter-threat text plus a separate run-condition block so party compensation/debt no longer collide with the card counter at 1280×720.
- [x] Turn the three rescue scars into situational Act 1 keys: Chains → Bone Tax, Road → Faceless Card, Whisper → Blood Ledger.
- [x] Add one-use **УДЕРЖАТЬ** fate control to the two-card table offer, returning the reserved card after two resolved cards.
- [x] Add two visible **ПЕЧАТЬ ВОЛШЕБНИКА** offers per run: +20 gold for accepting the marked card, with +15% enemy damage until the next combat victory.
- [ ] Locally verify fate hold return timing across tier boundaries, marked-card combat/event branches, mark + debt stacking and all three scar-key event variants.
- [x] Add encounter-specific deployment geometry for Gallows Volley, Bone Crush, Ossuary Gate and Bone Warden, including disconnected legal deployment regions.
- [x] Add compact combat-threat tags directly to Wizard-table card type lines (`РОЙ`, `ЛЕЧЕНИЕ`, `AOE`, ranged threat, phases).
- [x] Add a late **КАРТА БЕЗ ЛИЦА** reckoning that reads whole-run behavior instead of only a single earlier card.
- [ ] Locally verify the new deployment regions with solo/duo/trio parties and confirm the threat tags / Faceless reckoning fit cleanly at 1280×720.
- [x] Add three visible optional combat conditions with small gold rewards: Bellkeeper-first, stay-above-25%-HP and timed Bone Crush clear.
- [x] Add one-battle **НЕПОВИНОВЕНИЕ** after two explicit refusals of Wizard wagers/marks: -20% incoming damage, -15% own damage.
- [x] Personalize Bone Warden Phase II reinforcements from the Act 1 reckoning profile while keeping the boss's base benchmark stats fixed.
- [x] Locally verify the combat-condition / Defiance / personalized Bone Warden package at normal play level; user reported the package working. Keep edge-case retry/profile checks in the later full-run balance pass.
- [x] Implement first full-run party-size pressure pass: stronger solo baseline, transparent enemy HP/damage scaling for solo/duo, proportional support healing, and no forced combat on Act 1 card 1.
- [ ] Locally verify first forced combat, one mid fight, one late elite and Bone Warden with solo Ranger/Mage, duo and trio; retune only observed outliers.
- [x] Add live first-target intent arrows during battle preparation so hero placement and tactical orders expose their immediate targeting consequences.
- [x] Put target-intent arrows behind an explicit `ЦЕЛИ: ВКЛ/ВЫКЛ` preparation toggle; default off and remember the preference for the current app session.

- [ ] Locally verify target-intent readability on 1/2/3-hero parties and the five-enemy Death Wager without excessive visual clutter.
- [ ] Run fresh solo / duo / trio balance passes with rescue scars, event echoes and **ЖЕРТВА**, then retune only the concrete outliers.
- [x] First procedural combat SFX pass: attack/hit/death/heal/order/start/result cues.
- [ ] Authored sound replacement and battle/table music.
- [x] Skippable five-frame pixel-art comic prologue establishing the old pact and replayed-life premise;
- [ ] onboarding;
- [ ] local UI verification/polish for the new squad-status modal;
- [x] initial Act 1 combat-pacing / boss / Death Wager balance pass;
- [ ] follow-up balance pass after local solo/duo/trio recruitment runs against the fixed 700-HP Bone Warden;
- [ ] basic settings;
- [ ] save/run persistence if needed for the slice.

## Explicitly deferred

Do not prioritize these before the vertical slice works:

- large content library;
- elaborate meta progression;
- online features;
- procedural architecture for every possible future system;
- complex faction/synergy systems comparable to large auto-chess games;
- final production art.

## Art-direction follow-up

- [x] Define production visual rules in `docs/ART_DIRECTION.md`.
- [x] Add shared environment/card art-grade materials.
- [x] Apply the first pass to Wizard table, battle backdrops and Whispering Well.
- [ ] Review fresh screenshots for the first production art-direction pass and identify illustrations that still need true redraw.

## True art replacements

- [x] Replace the reused Ossuary art in **КОСТЯНАЯ ДАВКА** with the approved dedicated arena.
- [x] Replace blue deployment rectangles with subdued floor/chalk presentation and add authored two-band markings to Bone Crush.
- [ ] Locally verify the approved Bone Crush arena replacement at 1280×720 before using it as the template for the remaining arena redraws.

### Second production-art pass

- [x] Review local screenshots after the first art-grade pass and identify the strongest remaining generated-art tells.
- [x] Establish **КОСТЯНАЯ ДАВКА** as the first true redraw benchmark and approve a simpler low-detail crypt direction in chat.
- [x] Add a dedicated `bone_crush` arena id and production backdrop so the redraw does not alter other Ossuary encounters.
- [ ] Replace blue deployment-zone panels with subtle in-world floor markings based on the same legal placement rectangles.
- [x] Retune environment/card grade shadows and remove post-grade from authored table/wager art so dark-mid detail stays readable.
- [ ] Review the Bone Crush redraw locally at 1280×720 before propagating the style.
- [x] Integrate the first object-first card redraw batch: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Correct the broad redraw integration after local quality review: 19 semantically matched card redraws now run at 224×137 source resolution with the existing approved 25-card atlas as fallback.
- [x] Finish the six remaining fallback cards: five matching 224×137 v5 redraws plus the exact object-centric Broken Crown artifact art for **СЛОМАННАЯ КОРОНА**.


### Full visual redraw rollout

- [x] First object-first card redraw batch is live: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ШЕПЧУЩИЙ КОЛОДЕЦ**.
- [x] Replace 19 active Act 1 card illustrations with correctly mapped near-display-resolution v4 redraws; preserve unique approved fallback art for the other six.
- [x] Finish the six remaining card redraws without unrelated substitutions; all 25 active Act 1 table cards now resolve to current redraw/object-specific art.
- [x] Replace Crypt and Gallows Volley with native 1280×720 v4 arena redraws while retaining validated HD Graveyard/Ossuary/Warden and the dedicated Bone Crush benchmark.
- [x] Wire the latest native-HD Graveyard/Ossuary/Warden/Bone Crush redraws, remove post-grade darkening and floor-align Bone Crush deployment/combat.
- [x] Align Gallows Volley movement/spawn bounds to the authored stone floor and clamp unit positions immediately when combat bounds are assigned.
- [ ] Locally verify Gallows Volley retreat/separation with solo, duo and trio so ranged units never appear to move over background architecture.
- [ ] Continue any further arena replacement from native/high-resolution sources only. Thumbnail-scale full-screen arena upscaling is rejected.
- [x] Integrate the prepared v6 Wizard/table backdrop without baked live UI and reduce Wizard-wager/table dimming.
- [x] Rebuild the high-visibility remaining surfaces: Class Select portraits, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End now use dedicated authored v7 art while mutable values stay live.
- [ ] Continue lower-priority event/shop surfaces only where fresh local screenshots still show a meaningful visual mismatch.
- [x] Locally verify the corrected v4 cards and restored high-resolution arenas at 1280×720 before another broad visual rollout.


### V7 screen-art follow-up

- [x] Replace enlarged combat-sprite portraits on Class Select with dedicated Knight / Ranger / Mage portraits.
- [x] Replace the generic reward background with a dedicated treasure-altar scene.
- [x] Replace procedural Whispering Well and Run End backgrounds with authored full-screen scenes.
- [x] Give Curse Forge, Chained Prisoner and Black Altar dedicated full-screen event environments in the shared live-UI event scene.
- [ ] Review fresh 1280×720 screenshots before replacing any lower-priority art.


- [x] Replace the rejected low-quality main splash with the approved restrained Wizard/table redraw at native 1280×720 runtime resolution.
- [x] Add a persistent scene-transition veil and route active scene changes/reloads through it so runtime texture setup cannot expose a gray viewport frame.
- [x] Preload incoming scenes while the outgoing scene remains alive and manually swap them under an already-rendered veil, eliminating the empty SceneTree frame behind the intermittent gray flash.
- [x] Remove parse-time dependence on the `SceneTransition` autoload identifier so local `project.godot` conflicts cannot break compilation after pull.
- [ ] Locally stress-test repeated table ↔ event ↔ battle ↔ reward transitions for any remaining OS/editor-level flash.
- [ ] Locally verify table → battle, event → table, battle → reward and Last Deal reload transitions after a fresh Godot restart.

### Runtime art loading hardening

- [x] Harden v7 WebP loading against Godot import/parser timing by replacing direct new-asset preloads/ext_resources with runtime FileAccess + Image decoding.
- [ ] Confirm Class Select, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End all open cleanly after a fresh `git pull` and Godot restart.


### V8 secondary event-art pass

- [x] Reuse the accepted Class Select portraits in Squad Dossier instead of combat-sprite crops.
- [x] Wire dedicated V8 environments for Candle Seller, Gravedigger Shop, Blood Ledger and Faceless Card.
- [ ] Continue the remaining lower-priority generic Act 1 event screens after fresh screenshot review.


### V9 final generic-event environment pass

- [x] Integrate the final V9 generic-event environment batch for Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp and Broken Crown.
- [x] Keep all V9 event text/state/choices live in the shared Act Choice UI and load the new WebPs through the runtime decoder.
- [ ] Stop broad art replacement and review fresh local 1280×720 screenshots for targeted polish only.


### Project continuity / source preservation

- [x] Save a durable GitHub handoff covering the current gameplay/visual state and exact next step.
- [x] Add a visual asset registry with runtime paths, version history, rejected approaches and source provenance.
- [x] Archive the final V9 generated masters at 1672×941 so future chats can recrop/re-export without recovering old chat attachments.

- [x] Replace abstract Act 1 progress with the live `РАСКЛАД СУДЬБЫ`: twelve historical card slots, sealed XIII boss, held-card area and Wizard rejected-card discard.
- [ ] Locally verify Fate Spread readability at 1280×720 after 0, 4, 8 and 12 resolved cards, including a held card and a populated rejected discard.

- [x] Bring Fate Spread closer to the approved reference with a live occult seal, fate-thread path, chapter gates, progressive XIII chains and stronger center hierarchy.
- [ ] Verify the reference-driven Fate Spread at 0/4/8/12 progress and confirm XIII chain break/reveal timing reads clearly at 1280×720.

- [x] Add physical table texture under the Fate Spread, hoverable chosen/rejected decision memory, and one-shot ritual reveals at IV/VIII/XII.
- [ ] Locally verify milestone auto-open timing after card 4/8/12 and hover-memory readability without blocking `R`/Esc close input.

- [x] Integrate the approved ornate Fate Spread reference as a dark atmospheric runtime underlay while keeping all run-state cards/counters live and data-driven.

- [x] Replace the dark full-screen Fate Spread underlay with bright top/left/right edge-art plates while keeping the center fully live.
- [ ] Locally verify that candles/metal/red cloth read clearly at 1280×720 without reducing card/title readability.

- [x] Rebuild `РАСКЛАД СУДЬБЫ` around the user-approved full reference plate, with live cards/masks aligned to its physical holders and ring.
- [ ] Local 1280×720 check: verify all I–XII live cards fully cover the baked concept cards, Hold/Discard masks hide stale concept state, and title/count masks do not expose duplicate text.

- [x] Rebuild the normal Wizard/card-selection screen around the approved Variant C oval ritual table instead of a rectangular lower UI panel.
- [x] Integrate the final approved Variant C full-table artwork as the canonical 1280×720 normal-table foundation while keeping live cards/counts/actions authoritative.
- [ ] Locally verify the exact-reference table at 1280×720: check live card coverage over the baked examples, Hold visibility, deck/discard numeric masks, hover/deal animation alignment and wager overlay readability.
