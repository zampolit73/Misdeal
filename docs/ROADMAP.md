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
- [x] Recompose live battle UI/arena toward the approved gothic pixel mockup.
- [x] Replace the procedural battle arena with the authored second-reference backdrop while keeping combat/UI layers live.
- [x] Replace the core Knight/Ranger/Mage/Skeleton/Bone Archer set with pixel sprites and scale the live unit presentation accordingly.
- [x] Complete high-detail sprite pass for all nine current combat roles: heroes, base undead, support, swarm, elite and boss.
- [x] Convert main menu, table/cards/wizard, event, reward and run-end UI to the same pixel-art language.
- [x] Rebuild the wizard table around an approved authored pixel concept while keeping live Godot HUD/cards.
- [x] Physical card-table staging pass: deck/discard zones, fate spread, dealt-card motion, fan/hover lift and choose/discard animation.
- [ ] Coherent visual language for table/cards/miniatures;
- [x] First lightweight combat animation/impact pass: idle motion, role-aware attack motion/tracers, hit kick and death fall/fade.
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
