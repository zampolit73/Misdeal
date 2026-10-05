# Misdeal — Decisions

This file records decisions that future chats should not casually reverse.

## D001 — Project name: Misdeal

Date: 2026-10-04  
Status: accepted

The game is named **Misdeal**.

The name evokes both an invalid/unfair card deal and a bad deal or bargain, matching the cursed-game premise.

## D002 — Godot + GDScript

Date: 2026-10-04  
Status: accepted

Use Godot 4.7.x and GDScript.

Do not move to C#/.NET without an explicit discussion and decision.

## D003 — Combat is a compact tactical autobattler

Date: 2026-10-04  
Status: accepted

Misdeal does not use Hand-of-Fate-style direct action combat.

Combat encounters become short autobattles where the player's primary agency comes from preparation, party composition, positioning, equipment and limited tactical choices.

The autobattler should remain compact and support the card roguelike rather than becoming a separate giant auto-chess game.

## D004 — Evil wizard replaces the dealer archetype

Date: 2026-10-04  
Status: accepted

An evil wizard is the host, antagonist and master of the cursed table.

He deals encounters, comments on the player's choices and provides the personality tying the run together.

## D005 — Vertical slice before architecture polish

Date: 2026-10-04  
Status: accepted

The primary development goal is to prove the playable loop quickly.

Prefer simple working implementations over speculative abstractions.

Refactor toward data-driven Resources when the next playable feature benefits from it.

## D006 — GitHub is the technical source of truth

Date: 2026-10-04  
Status: accepted

Repository: `zampolit73/Misdeal`

ChatGPT Project conversations provide useful design context, but the repository defines what is actually implemented.

Every fresh development chat should read the continuity documents listed in `AGENTS.md` before proposing code or architecture changes.

Significant sessions should update the repository documentation so work can continue from a new chat without reconstructing history manually.

## D007 — Browser assistant edits, user validates locally

Date: 2026-10-04  
Status: accepted

The assistant should make implementation changes directly through the connected GitHub repository when asked.

The user pulls those commits to the local Godot project and validates behavior in the editor/runtime.

Do not require manual code copying when the repository can be updated directly.


## D008 — Unit definitions use Godot Resources

Date: 2026-10-04  
Status: accepted

Reusable combat stats for heroes and enemies are stored in `UnitData` `.tres` resources.

Battle scenes and encounter logic should reference these resources rather than duplicating unit stat blocks in GDScript.

Runtime state such as team, current HP, target and position remains on the instantiated `BattleUnit`.


## D009 — Minimal autoload RunState for vertical-slice scene flow

Date: 2026-10-04  
Status: accepted

Use a small `RunState` autoload to carry prototype run values between the table, battle and reward scenes.

For the first vertical slice it stores only the state required to prove the loop: gold, deals survived, party-wide HP/damage bonuses and the last battle result.

Do not turn it into a large global game manager. Move domain-specific data into dedicated Resources/systems when the vertical slice requires it.

Current reward values and defeat behavior are prototype tuning, not permanent game-design commitments.


## D010 — Player-facing language is Russian

Date: 2026-10-04  
Status: accepted

All player-facing Misdeal content should be written in Russian:

- menus and buttons;
- card names and descriptions;
- wizard dialogue;
- combat status text;
- reward names and descriptions;
- unit display names.

Technical identifiers remain English, including file paths, node names, class names, resource IDs and code symbols.


## D011 — Combat encounters use EncounterData Resources

Date: 2026-10-04  
Status: accepted

Combat-card content is stored in `EncounterData` Resources rather than hard-coded encounter branches in `battle.gd`.

For the vertical slice an encounter defines its player-facing card text, wizard line, enemy UnitData references, enemy names and spawn positions.

The battle scene remains generic and loads whichever encounter path was selected at the table.

## D012 — Vertical-slice run length is three victories

Date: 2026-10-04  
Status: accepted for prototype

The first finite Misdeal run ends after three rewarded victories.

This is a vertical-slice pacing value, not a commitment for the final game's run length.

Defeat currently returns the player to the table without advancing the victory count; this is also prototype behavior and may change with later run-design work.


## D013 — Non-combat events can modify the current run

Date: 2026-10-04  
Status: accepted for prototype

The table can contain non-combat event cards alongside combat encounters.

The first event, Whispering Well, is one-time-per-run and demonstrates self-authored risk: the player may trade party health for damage, spend gold for health, or refuse the offer.

Non-combat events do not currently count toward the three victories required to finish the vertical-slice run.

## D014 — Visual development starts with a stylized blockout after the core loop

Date: 2026-10-04  
Status: accepted

With the finite vertical-slice loop working, visual development can begin during Phase 3.

Start with a coherent stylized blockout for the cursed table, cards, wizard presence and combat miniatures. Use lightweight prototype visuals to establish composition and mood before committing to final production assets.

Final art polish remains a later Phase 4 task.


## D015 — Misdeal uses dark-fantasy pixel art

Date: 2026-10-04  
Status: accepted

The player-facing visual direction is dark-fantasy pixel art.

Combat readability is the first constraint:

- units should be recognizable by silhouette rather than by labels;
- unit sprites are the primary visual element;
- team color appears as a restrained ground marker instead of a thick portrait circle;
- HP and names should remain compact;
- nearest-neighbor texture presentation is preferred for pixel assets.

The earlier realistic/painted combat miniatures were judged too small and visually muddy when shown at tactical scale. Painted concept assets may remain as reference material, but new in-game visuals should converge on the pixel-art language.


## D016 — Approved pixel concepts may be sliced into live game assets

Date: 2026-10-04  
Status: accepted

Approved generated pixel-art concepts can be used as source material for production-facing prototype assets.

For the wizard table, keep run-dependent information and interaction in native Godot UI rather than using a full static mockup with baked values.

The approved table concept is archived at `assets/concepts/approved_table_direction.png`.

The active table uses extracted authored layers/illustrations from that concept plus live Godot controls for:

- deal/gold/party modifier HUD;
- wizard commentary;
- encounter titles/descriptions;
- card hover/disabled states;
- card selection and scene transitions.

Use the same approach for previous generated battle/table concepts: extract reusable art pieces when useful, but do not embed screenshots whose UI or gameplay state would become stale.

## D017 — Final vertical-slice deal is the first boss fight

Date: 2026-10-04  
Status: accepted for prototype

The third and final combat deal of the current three-victory vertical slice is a mandatory boss encounter against **Костяной надзиратель**.

Normal combat-card choices are replaced on the final deal so the run has a clear climax. If the one-time Whispering Well event has not yet been resolved, it may still be used before accepting the boss fight.

The first boss deliberately uses a small extension of `UnitData` rather than a general ability framework: optional boss scale plus a one-time HP-threshold enrage modifier. This is enough to test boss pacing and readability without introducing a broad status/ability system before the vertical slice needs one.

The boss currently reuses the Skeleton pixel sprite at a larger scale as a temporary gameplay placeholder. A unique authored boss sprite/card illustration should follow only after the fight is locally validated.

## D018 — Act 1 uses twelve resolved cards before the boss

Date: 2026-10-04  
Status: accepted for prototype; supersedes D012 pacing

The three-victory run was a vertical-slice pacing scaffold. Act 1 now targets **12 resolved cards followed by the Bone Warden boss**.

The wizard normally presents two cards. Choosing one commits the player to that card and removes the rejected alternative from the current run. A selected combat card remains active after defeat so returning to the table offers the same fight again rather than silently consuming another choice.

Because twelve two-card choices consume twenty-four unique cards when rejected alternatives leave the run, the Act 1 structural pool contains **24 unique pre-boss card definitions**, split into eight early, eight mid and eight late cards. This intentionally corrects the earlier rough idea of a 15-card pool, which was too small for twelve pairwise choices without repeats.

Only the already-existing encounters and Whispering Well are fully implemented mechanically in the first structural pass. The remaining new card definitions use a generic prototype resolver so the complete 12-card pacing, tier transitions, rejection behavior and boss handoff can be tested before building every card mechanic.

The Bone Warden remains the thirteenth/final card and completes the run only after its post-combat reward is taken.

## D019 — First artifacts are hero-specific run modifiers

Date: 2026-10-04  
Status: accepted for prototype

Artifacts are persistent for the current run and are represented by lightweight `ArtifactData` Resources rather than a full equipment/inventory system.

The first artifact set deliberately changes hero behavior or tactical role instead of providing only generic party stats:

- **ЩИТ МЕРТВЕЦА** makes the Knight tougher but slower;
- **СЛЕПОЙ КОЛЧАН** makes the Ranger attack faster while increasing the distance he tries to keep;
- **РАСКОЛОТЫЙ ФОКУС** trades Mage primary-hit damage for stronger, wider splash.

Artifacts are applied when heroes spawn into battle. For the current vertical slice there are no slots, rarity framework, equip/unequip screen or permanent unlock system. Those should only be introduced when the playable Act 1 proves they are needed.

The first functional shop may sell a random unowned artifact, while Curse Forge offers direct choice among the three current artifacts.

## D020 — New enemy behaviors stay lightweight and data-driven

Date: 2026-10-04  
Status: accepted for prototype

The first new Act 1 enemy behavior after Bone Archer is **Grave Bellkeeper** support healing.

`UnitData` now supports an optional heal interval, radius and amount. A unit with these values periodically heals damaged living allies in range and presents a visible support cue. This is intentionally a narrow mechanic, not the start of a general ability/status framework.

The same combat batch introduces:

- **Bone Thrall** as a low-HP swarm body intended to make area damage and positioning matter;
- **Crypt Guard** as an elite melee enemy that reuses the existing splash system to punish tightly clustered heroes.

Elite combat cards may override the normal post-battle reward flow when the encounter itself promises a specific reward. **Crypt Guard** currently guarantees a choice of one unowned artifact, falling back to gold only when the current artifact pool is exhausted.

## D021 — Wizard debt is the first temporary run condition

Date: 2026-10-04  
Status: accepted for prototype

**ДЕСЯТИНА ВОЛШЕБНИКА** introduces the first temporary run condition instead of another permanent stat change.

If the player refuses the tithe:

- **ДОЛГ ВОЛШЕБНИКУ** remains visible on the table;
- enemy damage is multiplied by 1.25 in subsequent combat;
- the next normal post-combat reward is doubled;
- choosing that doubled normal reward clears the debt.

The Crypt Guard's special artifact reward is intentionally not treated as a normal numeric reward, so it neither doubles nor clears the debt. This avoids inventing duplicate-artifact semantics for the prototype.

Keep temporary run conditions explicit and few. Do not build a generalized curse/status framework until multiple real cards need shared lifetime/stacking rules.

## D022 — Special artifacts can be source-locked and party-wide

Date: 2026-10-04  
Status: accepted for prototype

The late **СЛОМАННАЯ КОРОНА** card introduces the first source-locked special artifact.

`ArtifactData.general_pool` marks whether an artifact is eligible for generic random/shop/elite reward sources. Normal artifacts default to `true`; **СЛОМАННАЯ КОРОНА** uses `false` so its named event remains the only acquisition source.

`target_role = "*"` means an artifact applies to every hero. This allows a small number of party-wide build-defining relics without creating a separate global-artifact system.

Do not add rarity, slots or a generalized loot-table framework yet. Keep named special artifacts source-locked until more content demonstrates a real need for broader item-generation rules.

## D023 — Freeze Act 1 card expansion after the 24-card pool is bespoke

Date: 2026-10-04  
Status: accepted for vertical-slice development

The 24 pre-boss Act 1 cards now all have bespoke gameplay behavior. The active pool no longer routes through the generic prototype-card resolver.

Do not immediately add more cards. The next development gate is a full-run balance/readability pass covering:

- early/mid/late pacing;
- frequency of combat versus event cards;
- gold income and meaningful spend opportunities;
- permanent HP/damage growth;
- artifact power;
- elite and late-combat difficulty;
- whether Bone Warden remains a meaningful final test after twelve cards.

**СТАВКА НА СМЕРТЬ** was initially tuned to a bespoke +60 gold / +35 HP / +5 damage reward choice. This reward design is superseded by D029; the encounter itself and its high-risk/high-reward role remain unchanged. Like the Crypt Guard artifact reward, this special reward does not consume **ДОЛГ ВОЛШЕБНИКУ**; only a normal reward clears that condition.

Content expansion should resume only after the current Act 1 proves its pacing and economy in repeated local runs.

## D024 — Each Act 1 tier guarantees one selected combat

Date: 2026-10-04  
Status: accepted for first balance pass

Pure two-card random pairing allowed a four-card tier to contain no selected combat at all, which weakened the tactical-autobattler pillar even though the average number of fights was acceptable.

Each early/mid/late tier now chooses a random mandatory combat slot among its first three card positions. Before that slot, combat cards are held out of offers. At the mandatory slot, two combat cards are offered, guaranteeing that one combat is selected while preserving player choice and the rule that the rejected card leaves the run.

After the mandatory combat, remaining cards return to normal tier selection, so mid and late tiers can still produce an additional optional combat.

This is pacing control, not a new route/map system. Keep the two-card wizard-table structure intact for the vertical slice.

The same first balance pass retunes Bone Warden for twelve-card builds (580 HP, 22 base damage, faster cadence/movement and stronger enrage). Its temporary Death Wager numeric-reward tuning was later superseded by D029.

## D025 — Bone Warden final fight is a two-phase encounter, not a stat wall

Date: 2026-10-05  
Status: accepted for vertical-slice boss rework

Full Act 1 playtesting showed that a larger Skeleton with stronger numbers and a 50% enrage was not enough: twelve cards of permanent growth made the original final fight too easy, and the reused Skeleton presentation made the finale visually read like another ordinary combat.

Bone Warden now has:

- a dedicated `bone_warden` visual role, authored pixel sprite and boss-card illustration;
- a wider melee cleave that punishes clustered hero placement;
- a real Phase II at 50% HP;
- one Bone Archer and one Bone Thrall summoned when Phase II begins;
- a dedicated final-arena treatment with stronger red ritual geometry, gate bars, chains and braziers;
- a visible phase transition cue and stronger boss aura/HP presentation.

The boss should remain readable rather than mechanically overloaded. Do not add a general boss-ability framework yet. If tuning is needed, adjust the current boss stats, cleave, reinforcement composition and enrage values first.

## D026 — Battle composition follows an approved authored pixel reference

Date: 2026-10-05  
Status: accepted for vertical-slice visual direction

The earlier live combat renderer was mechanically readable but visually too sparse compared with the approved Misdeal pixel-art direction. The battle screen therefore uses `assets/concepts/approved_battle_direction.jpg` as its composition and density reference.

The reference is **not** baked directly into gameplay. Combat remains native Godot UI + procedural/live arena rendering so units, HP, placement, movement, boss phases and encounter text remain dynamic.

The visual priorities are:

- dense gothic cathedral/crypt framing rather than an empty tile board;
- a large central ritual mark and readable blue/red territorial temperature split;
- heavy dark UI frames with restrained red-bronze ornament;
- faction plates integrated into the arena edge;
- a clearly dominant red **БОЙ** action;
- character-scale combat sprites rather than tiny tactical icons.

Combat units should use detailed character-scale pixel sprites rather than small tactical icons. Do not return to the small-icon combat scale unless local readability testing proves the larger scale blocks tactical information.

## D027 — The production battle layout uses an authored backdrop with live gameplay layers

Date: 2026-10-05  
Status: accepted for vertical-slice production layout

Local comparison showed that the procedural recreation of the approved battle mockup still looked like the earlier flat prototype rather than the richer second reference.

The general battle arena is therefore no longer drawn procedurally. A full-screen authored gothic battle backdrop now provides:

- cathedral/throne architecture;
- banners, chains, braziers and candles;
- skull/bone edge dressing;
- detailed stone floor and ritual sigil;
- top HUD frames, side faction plates and bottom command frames.

Gameplay stays live on top: units, HP bars, names, team rings, drag placement, movement, attacks, encounter text, buttons, result overlays and boss phase logic are still native Godot nodes/scripts.

The production backdrop is stored as five base64 text chunks under `assets/pixel/battle/authored_backdrop/` and reconstructed once by `scripts/battle/authored_backdrop.gd`. The validated decoded WebP is 1280×720. This packaging is deliberately isolated to the presentation layer and must not leak into gameplay logic.

`scripts/battle/battle_visual.gd` is now restricted to dynamic overlays such as Bone Warden phase effects. Do not rebuild the ordinary arena procedurally unless the authored backdrop is deliberately replaced by another approved art asset.

## D028 — Current combat roles share one authored 96×96 sprite atlas

Date: 2026-10-05  
Status: accepted for vertical-slice visual direction

The authored battle backdrop is now locally accepted, and the remaining visual mismatch was the simplified unit art.

All nine combat roles currently used by the slice now come from one transparent 3×3 sprite atlas with 96×96 cells. The production v3 atlas is stored as ten base64 PNG chunks under `assets/pixel/units/combat_units_v3/` and decoded by `BattleUnit`. The obsolete v2 fallback was removed after it caused a Godot import/preload failure:

- Knight / Ranger / Mage;
- Skeleton / Bone Archer / Grave Bellkeeper;
- Bone Thrall / Crypt Guard / Bone Warden.

`BattleUnit` maps `UnitData.visual_role` directly to an atlas cell through `AtlasTexture`. The decoded v3 texture is validated as 288×288 before use; missing/corrupt v3 data now fails visibly with a presentation error instead of relying on a stale fallback asset. This keeps the roster visually coherent without putting art-loading failures into combat logic.

Presentation scale is role-driven rather than baked into source image size: Bone Thrall remains intentionally small, Crypt Guard larger, and Bone Warden largest. The source art stays transparent and uses nearest-neighbor filtering.

Do not create a generalized sprite-animation framework yet. The next visual step, if needed, should be per-role idle/attack/death animation only after this static roster is confirmed readable in the live authored arena.

## D029 — Act 1 build progression comes from hero-defining upgrades, not repeated party stat rewards

Date: 2026-10-05  
Status: accepted for vertical-slice progression pass

Repeated post-combat choices of gold / party HP / party damage made runs numerically stronger without giving them a distinct build identity.

Act 1 now guarantees one **major hero-upgrade choice per early/mid/late tier**. The first combat victory in each tier presents one available upgrade for each hero role. The player may spread the three choices across the party or repeatedly specialize one hero.

The first upgrade set contains nine unique run-persistent upgrades:

- Knight: **ЖЕЛЕЗНАЯ КЛЯТВА**, **ПАЛАЧ**, **РАЗМАШИСТЫЙ УДАР**;
- Ranger: **ДАЛЬНИЙ ВЫСТРЕЛ**, **ГРАД СТРЕЛ**, **ЗВЕРИНАЯ ТРОПА**;
- Mage: **ПОЖАР**, **СТЕКЛЯННОЕ СЕРДЦЕ**, **ПЕРЕГРУЗКА**.

Upgrades use a small data-driven `HeroUpgradeData` Resource with the same narrow runtime-stat vocabulary already proven by artifacts. They are not a skill tree, XP system, equipment-slot system or meta-progression layer.

Normal extra combat victories now give simple gold loot rather than more permanent party-wide HP/damage choices. The follow-up event pass removes positive party-wide HP/damage as the default event reward too; the legacy counters remain available mainly for explicit costs, curses and a few named artifact effects.

Special combat rewards remain distinct:

- Crypt Guard still grants an artifact choice;
- Death Wager now grants a choice between +60 gold, a shown available artifact, or one additional hero-upgrade choice;
- wizard debt doubles and clears only on normal gold loot, not on major upgrades or special rewards.

Artifacts remain a second build layer that can reinforce or distort hero upgrades. Do not merge artifacts and hero upgrades into one generic loot system yet.

The next progression task after local validation is balance: measure how often extra upgrades appear, how often a hero reaches all three upgrades, and whether Bone Warden remains a meaningful build check.

## D030 — Positive event progression should manipulate the build, while raw stats are mainly prices and curses

Date: 2026-10-05  
Status: accepted for vertical-slice progression pass

After D029, ordinary combat rewards had build identity but many event cards still granted generic permanent party HP/damage. That made events feel like an older placeholder progression system layered on top of the new hero upgrades.

The first event-progression rewrite follows this rule:

- **positive permanent progression** should primarily grant or trade for hero upgrades, relics or gold;
- **raw party HP/damage changes** may remain when they are a cost, curse, punishment, or a deliberately named artifact effect;
- event buttons should show the concrete next hero-upgrade title when the outcome is deterministic;
- events may grant extra upgrades beyond the three tier milestones, but the nine-upgrade pool remains finite;
- if events exhaust the upgrade pool, later major tier rewards must skip cleanly rather than showing an empty selection.

Build-aware event examples now include:

- Ash Rest and Last Camp directly prepare one chosen hero;
- Gravedigger Shop and Candle Seller sell role-specific development;
- Black Altar trades blood for role-specific development;
- Chained Prisoner, Broken Crown and Bone Tax can strengthen the least-developed hero;
- Faceless Card mixes gold, relic and development outcomes;
- Blood Ledger can buy development, trade blood for a relic, or erase the latest hero upgrade for gold;
- Whispering Well now trades blood/gold for development or relics rather than positive global stat buffs.

This is intentionally implemented through small helpers on the existing nine-upgrade pool. Do not add a separate XP tree, perk currency or generalized event-effect DSL for the vertical slice.

## D031 — Act 1 targets three guaranteed plus at most three optional hero upgrades

Date: 2026-10-05  
Status: accepted for vertical-slice balance pass

The first build-aware event pass made hero development much more interesting, but it also made it possible for a lucky/event-heavy route to consume most or all of the nine-upgrade pool before Bone Warden.

For the current 12-card Act 1, the target power curve is:

- **3 guaranteed major upgrades** — one from the first combat victory in each early/mid/late tier;
- **at most 3 optional upgrades** from events and Death Wager;
- therefore a normal strong boss build should contain roughly **4–6 total hero upgrades**, with unused upgrades preserving replay variation.

Optional upgrades are tracked separately in `RunState.extra_hero_upgrade_ids`. Blood Ledger may erase the latest upgrade; if that erased upgrade came from the optional pool, its optional slot is restored.

This cap is a run-structure balance rule, not a permanent progression-system contract. Revisit it only after repeated local runs show that 4–6 upgrades are too weak or too deterministic.

Bone Warden is retuned around this target without adaptive/rubber-band scaling:

- 700 HP;
- 24 base damage;
- 1.0 s base attack interval;
- 60 move speed;
- 50% enrage remains;
- enrage uses 1.45× damage, 0.68× attack interval and 1.30× movement;
- existing melee cleave and phase-II Bone Archer + Bone Thrall reinforcements remain unchanged.

Do not scale boss stats dynamically from the player's exact upgrade count. The point of a build is to become meaningfully stronger; the boss should be a fixed benchmark.

## D032 — Misdeal begins as an offer to replay an already-lived life

Date: 2026-10-05  
Status: accepted narrative premise for the vertical slice

The protagonist is not a young adventurer entering a cursed game for the first time. They are old, looking back on a long life shaped by an old pact with the Wizard.

The Wizard returns and offers to replay the decisive moments of that life. The temptation is not merely to save the protagonist; it is to correct old mistakes and the fates of people the protagonist once saved.

The central narrative rule is that **changing a past choice rewrites everything that followed from it**. Saving one person differently may erase another relationship, sacrifice, victory or life that existed only because of the original history.

This makes the card-driven run a literal replay of fate rather than a disconnected sequence of encounters. The Wizard knows more about the consequences than the protagonist and treats the replay as both a bargain and entertainment.

The opening presents this premise in a five-frame authored pixel-art comic:

1. the aged protagonist reflects on a long life;
2. the Wizard returns because of the old pact;
3. he reveals the fates of people touched by the protagonist's choices;
4. he warns that every corrected card rewrites what came after;
5. he lays out the cursed deck and begins the deal.

The intro must remain short and skippable. It appears when entering the game from the main menu; consecutive new runs from the run-end screen continue directly to the table to avoid repeated narrative friction.

## D033 — Squad status is a derived read-only build view, not a second character-state system

Date: 2026-10-05  
Status: accepted for vertical-slice UI

The hero-upgrade and artifact systems now change enough combat parameters that players need a place to understand the build they have created.

The wizard table therefore exposes a **ДОСЬЕ ОТРЯДА** modal with one hero selected at a time.

The modal shows:

- the production combat portrait;
- final combat HP, damage, attacks/second, range, movement and derived DPS;
- minimum range and splash only when relevant;
- base-value comparison for changed stats;
- acquired hero upgrades;
- relics affecting the selected hero, including party-wide relics;
- legacy party-wide stat modifiers and optional-upgrade progress;
- a presentation-only specialization name derived from recognizable upgrade/relic combinations.

The UI must not maintain its own mutable character stats. `RunState.get_effective_hero_stats(role)` derives the displayed values from the same `UnitData`, global party modifiers, hero upgrades and artifacts used by combat, in the same order and with the same minimum HP/damage clamps.

The modal lives over the wizard table and must not regenerate offers or advance the run. Tab toggles it; Esc closes it.

Do not introduce equipment slots, level numbers, attribute points or a second character-sheet progression model just to support this screen.

## D034 — A run starts solo; companions are replayed fates, not guaranteed party slots

Date: 2026-10-05  
Status: accepted core-gameplay decision

The previous structure always spawned Knight, Ranger and Mage. That contradicted the replayed-life premise because the player never learned who these people were or why they were present.

Each run now begins after the prologue with the Wizard asking:

**«Кем ты был, когда всё началось?»**

The player chooses Knight, Ranger or Mage as the protagonist. Only that hero begins in the party.

The other two are people from the protagonist's previous life. They can be encountered through existing cards:

- Knight: **ЗАКОВАННЫЙ ПЛЕННИК**, fallback **ПОСЛЕДНИЙ ПРИВАЛ**;
- Ranger: **ГРЕМУЧИЙ МОСТ**, fallback **ПЕПЕЛЬНЫЙ ПРИВАЛ**;
- Mage: **ШЕПЧУЩИЙ КОЛОДЕЦ**, fallback **ЧЁРНЫЙ АЛТАРЬ**.

A card that is never played does not resolve the companion's fate. If the player reaches the actual recruitment scene and chooses to abandon that person, the role becomes **ПОТЕРЯН** for the rest of the run.

Runs may reach Bone Warden solo, duo or trio.

Incomplete parties receive explicit fixed compensation:

- solo: +50% max HP and +35% damage for the remaining hero;
- duo: +20% max HP and +15% damage for both heroes;
- trio: no compensation.

This compensation is applied after upgrades/relics and is shown in battle preparation and the squad dossier. Enemy and boss stats remain fixed; do not rubber-band scale encounters from party size.

Upgrade offers and general-pool hero-specific relics only target roles currently in the party. A solo major reward may offer multiple paths for the same protagonist.

The protagonist cannot be lost during the current vertical slice. Recruited companions also remain in the party once joined; injury/permadeath systems are explicitly deferred.
