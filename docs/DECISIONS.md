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

## D035 — Solo compensation must address action economy, not only raw HP/damage

Date: 2026-10-05  
Status: accepted balance rule for current vertical slice

Local testing of D034 showed that +50% HP / +35% damage was insufficient: a solo protagonist could reach an early mandatory three-enemy encounter before finding any companion, and the fight was close to mathematically unwinnable for some classes.

The encounter itself is not weakened and enemies do not scale from party size. Instead, the solo hero receives a stronger explicit compensation package after upgrades and relics:

- max HP x2.0;
- damage x1.8;
- attack interval x0.80 (+25% attacks per second);
- movement speed x1.10.

Duo remains +20% HP / +15% damage and trio remains unmodified for now.

This supersedes the numeric solo values recorded in D034, but not D034's structural rule: runs may still reach the boss solo, duo or trio and Bone Warden remains a fixed benchmark.

Reasoning: losing two bodies removes far more than two pools of HP. It also removes simultaneous attacks, aggro splitting, role coverage and time-to-contact advantages. Solo compensation therefore has to restore part of that action economy, not just inflate one health bar.

## D036 — Main menu uses the approved authored splash with only a live CTA hotspot

Date: 2026-10-05  
Status: accepted visual-production decision

The earlier centered prototype menu and the subsequent attempt to recompose the playable wizard-table art as a title screen were both rejected in local visual review.

The approved production main menu is the dedicated authored dark-fantasy pixel-art composition selected by the user: the Wizard behind a five-card cursed table, large MISDEAL title, **«Проклятая партия уже разложена.»**, player hands in the foreground and a painted **ВОЙТИ В ИГРУ** control.

The splash itself is intentionally baked as one coherent illustration. Godot should not place separate live logo, tagline, wizard, cards or decorative frames on top of it, because that recreates the visual duplication that caused the rejected menu versions.

Only the interaction remains native: a transparent/focusable `StartButton` is aligned over the painted CTA and routes into the comic intro.

For repository reliability, the approved 640×360 WebP is reconstructed at runtime from five base64 text chunks under `assets/pixel/main/approved_splash/` and rendered with nearest filtering.

Do not replace this screen with the wizard-table gameplay composition without explicit new visual approval.


## D037 — Combat gets one tactical order before the autobattle, not mid-fight micromanagement

Date: 2026-10-06  
Status: accepted for vertical-slice combat depth

The preparation phase now includes one party-wide tactical order selected before pressing **БОЙ**.

The three current orders deliberately reuse existing movement/targeting behavior rather than introducing an ability framework:

- **НАТИСК** — heroes keep nearest-enemy targeting and gain +15% movement speed so the party commits faster;
- **ОХОТА** — heroes dynamically prioritize support enemies, then ranged enemies, then the nearest remaining enemy;
- **СТРОЙ** — heroes dynamically focus the enemy closest to the most vulnerable living ally, creating a protective focus without direct unit control.

The selected order applies only to the current battle and locks when combat starts. It is not stored in `RunState` and is not a run-progression reward.

This keeps Misdeal's combat identity intact: the player makes a meaningful preparation decision, then watches the autobattle resolve. Do not add real-time per-unit commands, ability hotbars or continuous retargeting controls unless playtesting shows the compact preparation-first model is insufficient.


## D038 — First combat-feel pass stays lightweight, role-aware and replaceable

Date: 2026-10-06  
Status: accepted for vertical-slice polish

The static nine-role combat atlas is locally readable, so the next presentation pass adds motion and sound without introducing a sprite-animation state machine or a production audio pipeline.

Combat motion remains presentation-only:

- living units get subtle sprite-only idle/breathing;
- melee attacks lunge forward;
- Ranger/Bone Archer attacks recoil and draw a short tracer;
- Mage/Grave Bellkeeper attacks pulse and draw a colored magical tracer;
- hit feedback uses sprite kick/flash without changing the unit's actual combat position;
- death removes unit UI immediately and tilts/drops/fades the miniature.

Prototype SFX are synthesized at runtime into deterministic 16-bit PCM streams and played through a small voice pool. They cover melee/ranged/magic attacks, hit, death, heal, Bone Warden phase change, tactical-order selection, combat start and result stingers.

These sounds are explicitly placeholders for feel/readability testing. Authored SFX and music may replace them later without changing combat rules or `UnitData`. Do not build a generalized animation graph, audio middleware layer or per-role frame library until the current combat-feel pass has been locally evaluated.


## D039 — The Wizard's first active cheat is visible card substitution

Date: 2026-10-06  
Status: accepted for vertical-slice antagonist identity

The Wizard should sometimes change the game state himself rather than only comment on player decisions.

Act 1 now schedules two visible interference moments per run: one in the mid tier and one in the late tier. When one triggers, the normal two-card offer appears first, input locks briefly, and the Wizard flips one offered card edge-on and substitutes another card.

Rules:

- the replacement is from the same Act 1 tier;
- it preserves the same resolution family: combat replaces combat, event replaces event;
- this keeps guaranteed-combat pacing intact;
- a normal combat may still become an elite combat because both are combat-resolution cards;
- the card removed by the Wizard is returned to the future pool rather than treated as rejected;
- the replacement becomes a real offer and follows normal choose/reject consumption rules;
- retrying an already-active combat and the Bone Warden boss offer are never modified;
- only two substitutions happen in a normal Act 1 run so the trick remains memorable rather than routine.

This is deliberately a theatrical, legible cheat. Do not make the Wizard silently alter combat stats or secretly invalidate player choices. Future wagers/curses can add opt-in risk, but the host should feel unfair in personality without making the rules unreadable.


## D040 — Wizard wagers are explicit opt-in risk, not hidden punishment

Date: 2026-10-06  
Status: accepted for vertical-slice antagonist identity

The Wizard now has a second active interaction besides unilateral card substitution: a voluntary wager.

Up to two wager prompts are scheduled per Act 1 run. A wager pauses the table before card selection and clearly states both terms:

- next combat: enemies deal +25% damage;
- next ordinary loot reward: x2.

Accepting reuses the existing `wizard_debt_active` mechanic rather than creating a second combat modifier. The debt persists through events and special rewards until ordinary loot pays it out, matching the existing Wizard Tithe debt behavior. Faceless Card can still clear the debt.

Refusing the wager has no mechanical punishment. The Wizard may mock the refusal, but the player must be able to distinguish an unfair personality from unreadable rules.

Scheduled wager prompts are suppressed while a debt is already active and never stack. Accepted/refused counts are retained in `RunState` so later Wizard-memory dialogue can react to the player's appetite for risk.


## D041 — Wizard Memory v1 is narrative state, not hidden gameplay state

Date: 2026-10-06  
Status: accepted for vertical-slice antagonist identity

The Wizard now remembers selected player behaviors across the current run and can reference them later at the table.

Version 1 tracks eight event families:

- wager accepted;
- wager refused;
- companion recruited;
- companion abandoned/lost;
- Wizard debt cleared through a special escape;
- battle defeat;
- retrying the same active battle;
- greed-heavy gold choices.

The memory system stores compact event counts plus one pending remembered event/detail. It does not modify encounter selection, combat stats, reward values, card odds or hidden difficulty.

Table dialogue priority is:

1. mandatory table states and boss presentation;
2. active Wizard meddling / wager modals;
3. one pending memory reaction;
4. generic progress commentary.

This keeps the Wizard feeling observant without making the rules opaque. Repeated behavior may use different lines, and companion memories may reference the specific role.

Do not turn this into a large branching-dialogue graph yet. Future hero-story chains may reuse the same lightweight event/count state, but gameplay consequences must remain explicit and separately modeled.


## D042 — The cursed table should read as a physical deal, not a menu

Date: 2026-10-06  
Status: accepted for vertical-slice presentation

The wizard table is the core stage of Misdeal. The live two-card choice therefore needs to feel physically dealt onto a cursed tabletop rather than presented as two flat UI panels.

The production table now uses lightweight staging around the existing card buttons:

- a visible deck pile at the left and discard pile at the right;
- a 12-card Act 1 fate track with a separate XIII boss marker;
- two offer cards resting in a shallow fan with small opposing rotations;
- staggered deal-from-deck animation when a new offer appears;
- hover lift/straightening;
- selected card pulled toward the center while the rejected card moves to discard;
- single-card retry and boss states use one centered slot;
- Wizard substitution is timed after the deal so it reads as a deliberate physical intervention.

This is presentation-only. Card choice, rejection, tiers and encounter rules remain unchanged.

Do not introduce freeform card dragging, physics simulation, a 3D tabletop or long shuffle animations for the vertical slice. The table should feel tactile while keeping selection fast and readable.


## D043 — Dealer presence should be visible on the table without becoming a control layer

Date: 2026-10-06  
Status: rejected after local visual review; superseded by D044

After the physical-deal pass was locally accepted, the table needed stronger visual evidence that the Wizard is actually dealing the cursed spread rather than merely appearing behind a UI.

The production table now adds a lightweight dealer-presence layer:

- stylized Wizard sleeves and two clearly five-fingered hands occupy the dealer side of the tabletop;
- hands sit below live cards and ignore mouse input;
- the deck-side hand reacts to new deals;
- the hand nearest a substituted card reaches inward during Wizard meddling and receives a short red occult glow;
- the surrounding table gains more wood/material detail, inlaid deck/discard zones, props and ritual marks.

These elements are presentation-only. They must not become draggable hand controls, collision objects or a second interaction model.

The current hands are intentionally stylized Godot-drawn production dressing for the vertical slice. If later replaced with authored pixel art, preserve the same spatial role and input hierarchy rather than rebuilding the table flow.


## D044 — Wizard-table polish must preserve the authored art instead of drawing a second visual language over it

Date: 2026-10-06  
Status: accepted for vertical-slice presentation

Local review of the D043 implementation showed that procedural dealer hands, large inlaid side zones, dense orange geometry and extra tabletop props made the production table substantially worse. The existing authored Wizard/table image already provides the character, atmosphere and material language; procedural dressing should not compete with it.

The table therefore returns to a restrained composition:

- remove the procedural Wizard hands entirely;
- remove large deck/discard frames, heavy runner borders, dense rune geometry and decorative props;
- keep only subtle wood/cloth grounding beneath the live cards;
- keep small physical deck/discard stacks and understated counts;
- keep a low-contrast 12-card progress track and boss marker;
- retain the successful physical interaction layer from D042: deal animation, shallow fan, hover lift, choose/discard motion, Wizard substitution timing and centered single-card states.

Visual hierarchy is now explicit:

1. authored Wizard/table background;
2. live encounter cards;
3. minimal supporting HUD and table-state indicators.

Future table polish should prefer authored pixel assets or quiet native UI. Do not add prominent procedural character anatomy or decorative wireframe-style overlays without a visual mockup and explicit approval first.


## D045 — Act 1 uses reusable arena families, selected by encounter data

Date: 2026-10-06  
Status: accepted for vertical-slice battle variety

Repeated use of one battle arena made distinct cards feel like the same encounter. Act 1 now assigns each combat encounter an explicit `arena_id` through `EncounterData`.

The vertical slice uses four reusable presentation families:

- `crypt` — underground stone, arches and braziers;
- `graveyard` — cold moonlight, tombstones, dead trees and fog;
- `ossuary` — bone arches/piles with warmer sepulchral lighting;
- `warden` — Bone Warden lair with chains, sealed gate and phase-rune treatment.

The family layer is presentation-only and draws underneath live units. It does not change combat bounds, navigation, spawn positions, stats or encounter rules.

For the vertical slice, all families reuse the validated authored 1280×720 battle backdrop as a common art foundation and add restrained family-specific staging. This is deliberate: visual variety without multiplying fragile binary backdrop assets before local evaluation.

Do not create one bespoke arena implementation per card. New combat encounters should normally select an existing arena family; add a new family only when it represents a materially different location/identity.


## D046 — Arena identity comes from authored backdrops; procedural drawing is limited to dynamic effects

Date: 2026-10-06  
Status: accepted after local screenshot review

The D045 data-driven `arena_id` architecture is retained, but its first procedural visual implementation is superseded.

Local screenshots showed that small procedural silhouettes, fog, bone piles and tint overlays did not materially change the location because the shared authored throne-room image remained visually dominant. Continuing to add procedural decoration would repeat the table-art mistake documented in D043/D044.

Act 1 therefore uses four authored pixel-art backdrops selected by `EncounterData.arena_id`: crypt, graveyard, ossuary and warden.

The backdrops share the same combat-floor composition so unit positions and tactical readability remain stable, but each location has a clearly different silhouette, palette and environmental identity.

Arena textures are presented at the 1280×720 battle resolution rather than doubled from 640×360. After the first direct binary replacement attempt produced truncated repository blobs, the preserved 1672×941 authored source renders were rebuilt into high-quality native 1280×720 WebP assets and committed through a repository-safe staged base64 path. `authored_backdrop.gd` deliberately continues to decode those WebPs from raw bytes at runtime with `Image.load_webp_from_buffer()`, avoiding compile-time importer/preload fragility. Linear filtering is used only for fractional window scaling; native 1280×720 presentation performs no normal-path upscale. Procedural `battle_visual.gd` drawing remains reserved for genuinely dynamic effects such as the Bone Warden phase rune, not for painting static environments over another background.


## D047 — Combat polish may deepen feedback, but must not become a second combat-control system

Date: 2026-10-06  
Status: accepted for vertical-slice combat polish

After the authored multi-arena pass, the remaining battle-quality gap was presentation rather than missing tactical rules. The second combat-polish pass therefore improves how the existing autobattle reads and feels without changing its decision model.

Accepted presentation additions:

- arena-aware ambient tint, contact shadow and low-alpha team rim for miniature integration;
- short simulation hit-stop, directional visual kick and lightweight impact sparks;
- different death treatment for undead and heroes;
- one coherent preparation HUD with clearer tactical-order selection;
- short Wizard commentary reactions during battle;
- lightweight dynamic atmosphere over authored arena art;
- a brief fight-start title transition before units begin moving.

These effects must remain non-authoritative. Visual knockback does not move combat positions, hit-stop does not change cooldown values, arena atmosphere does not alter visibility/range, and Wizard commentary does not secretly modify stats or targeting.

Do not add per-unit ability buttons, mid-fight command spam, manual dodge controls or other real-time micro under the banner of combat polish. If more tactical depth is needed, preserve the preparation-first model established by D037.


## D048 — Non-combat choice screens share one ritual UI language; event identity comes from accents, not bespoke mechanics

Date: 2026-10-06  
Status: accepted after visual mockup approval

Local review showed that reward, event, forge/prisoner choices and the Wizard wager still looked like separate prototype screens even though the table and battle presentation had converged.

For the vertical slice, protagonist selection, reward/development, generic Act 1 events, Whispering Well, prototype/fallback events and the Wizard wager therefore share one presentation grammar:

- authored Wizard/table or event-specific dark backdrop;
- Misdeal logo / compact run-information hierarchy where appropriate;
- dark near-black panels with restrained copper/orange ritual framing;
- large card-like choices with explicit hover and disabled states;
- a single dominant title, smaller type/kicker line and quieter Wizard commentary;
- subtle entrance/hover motion rather than large UI transitions.

Individual events keep identity through accent color and restrained atmosphere (forge sparks, chains, altar rings, bridge fog, candles, bones, Whispering Well teal), not through a different interaction model or a bespoke scene architecture for each card.

This pass is strictly presentational. Costs, rewards, recruitment, hero-development logic, wager terms and event resolution remain data/state driven and unchanged.

Do not solve future visual inconsistency by creating one unique UI implementation per event. Prefer the shared choice shell and add only lightweight visual variants unless the event genuinely needs a different interaction.


## D049 — Accepted screen illustrations are canonical; combat sprites are not UI-art fallbacks

Date: 2026-10-06  
Status: accepted after local visual review

The first hero-development polish pass incorrectly filled the new illustration slots with portraits cropped from the production combat-unit atlas. Local review rejected that substitution because approved screen mockups already established a different authored illustration language for development and event cards.

For non-combat choice screens:

- use the illustrations from explicitly accepted screen mockups when an approved illustration exists;
- store those approved illustrations in a small runtime-decoded UI atlas so the source art remains stable and repository-safe;
- do not substitute combat-unit sprites, battle portraits or unrelated encounter art merely to avoid an empty illustration slot;
- if a future path has no approved illustration yet, keep the presentation text-led until matching art is authored or explicitly approved.

This decision affects presentation only. Upgrade stats, event branches, costs, rewards and recruitment logic remain unchanged.


## D050 — Approved screen mockups are layout references, not loose mood boards

Date: 2026-10-07  
Status: accepted after screenshot correction

When the user provides an approved full-screen mockup for a Misdeal UI state, implementation should preserve the mockup's composition and hierarchy rather than adding new informational chrome that merely fits the general theme.

For **РАЗВИТИЕ ОТРЯДА**, this means the dominant illustrated path cards, in-card choose bars and bottom stage sentence are canonical; the extra progress-diamond rail and duplicate quick-stat strip added in an intermediate implementation are not.

For **КУЗНИЦА ПРОКЛЯТИЙ**, **ЗАКОВАННЫЙ ПЛЕННИК** and **СТАВКА ВОЛШЕБНИКА**, use their approved character/environment art and match the reference placement of header, choices and primary/secondary actions while keeping gameplay data live and data-driven.

Do not bake changing run values or option text into screenshot backgrounds. Approved screenshots guide composition and authored art selection; live Godot controls remain authoritative for dynamic text, disabled states and input.


## D051 — The approved full card-art set is canonical

Date: 2026-10-07  
Status: accepted after user art review

The dedicated pixel-art sheets generated and approved in the 2026-10-07 card-art pass are the canonical visual source for the active vertical-slice card set:

- 24 Act 1 pre-boss cards plus Bone Warden;
- all nine Knight/Ranger/Mage hero-development paths;
- Blood Coin, Relic Wager, Bonus Upgrade, Empty Cache, Gold Windfall and Elite Relic reward states.

The production UI must use these exact illustrations rather than procedural icon blobs, unrelated card reuse or combat-sprite placeholders. Runtime fallback art may remain only as a technical failure-safe.

For repository robustness, the approved images are packed into small WebP atlases, split into base64 text chunks and decoded at runtime. Live titles, descriptions, costs, disabled states and run values remain Godot controls and are not baked into the art.


## D052 — Generic event choices inherit the active card illustration

Date: 2026-10-07  
Status: accepted for the approved full-card art pass

The shared Act 1 choice scene must not fall back to flat black choice cards when the active event already has approved card art.

For generic choice-driven events, the upper illustration band of each visible option therefore reuses the active run card's canonical illustration from `card_art_catalog.gd`. This is a presentation reuse of the exact approved art, not procedural generation and not a new gameplay state.

`Curse Forge` and `Chained Prisoner` keep their dedicated per-option approved illustrations because those screens already have more specific authored choice art.

Live button text, costs, disabled states, reward logic and companion-fate mechanics remain authoritative Godot controls.


## D053 — Canonical card art must be stored near its display resolution

Date: 2026-10-07  
Status: accepted after local quality rejection

The first D051 integration preserved the correct illustrations but packed them at only 88×54 px for table cards and 80×48 px for development/reward cards. Godot then enlarged those thumbnail cells across much larger UI art windows, making the approved art visibly soft and blocky.

Canonical player-facing card art must not be pre-shrunk to thumbnail resolution merely to reduce repository size. The current vertical slice therefore stores the same approved illustrations at 224×137 px per table-card cell and 304×194 px per development/reward cell.

The atlases are WebP-compressed but committed as raw `.bin` byte blobs and decoded with `Image.load_webp_from_buffer()`. This keeps repository/import behavior predictable while retaining enough source detail for the actual card windows.

Do not solve future repository-size concerns by aggressively downsampling approved art below its normal display size.


## D054 — Artifact art is object-centric; special decisions show their stakes visually

Date: 2026-10-07  
Status: accepted for vertical-slice presentation polish

Artifact/relic art should identify the actual object at card scale rather than rely on a generic relic scene or on the surrounding event illustration. The current four artifacts therefore have a dedicated item-centric atlas: Dead Man's Shield, Blind Quiver, Cracked Focus and Broken Crown.

Special high-stakes decisions may also use richer composition than ordinary event cards when the underlying interaction remains the same. The Wizard wager now separates **price** and **reward** into two illustrated terms, while Curse Forge uses a dedicated forge scene layer plus the object-centric artifact cards.

This is presentation only. Do not bake mutable costs, stats, disabled states or run values into the imagery; live Godot controls remain authoritative.


## D055 — Shared event windows use context art and semantic choice art

Date: 2026-10-07  
Status: accepted for vertical-slice presentation polish

The shared Act 1 event shell should not read as a large black text panel. Generic event windows now reserve a compact framed context-art region for the active card, keep run-state information in small chips, and let the choice cards carry the decision itself.

When an event choice grants the next development for a specific role, the choice card should show that actual upgrade illustration rather than repeating the event illustration. This applies to merchant/preparation events such as Candle Seller, Gravedigger Shop, Ash Rest, Last Camp and Black Altar. Missing-party choices may use a role-specific development fallback while remaining visibly disabled.

Risk-oriented choices may use restrained semantic border accents to differentiate safe, costly and dangerous options, but color is supportive only; text remains authoritative.

Whispering Well follows the same rule with choice-specific well/development/relic art. No gameplay values, prices or outcomes are baked into images.


## D056 — Approved event-choice mockups define the card hierarchy

Date: 2026-10-07  
Status: accepted after user approval of the Whispering Well / Chained Prisoner mockups

The approved full-screen mockups for **Whispering Well** and **Chained Prisoner** establish a stronger choice-card hierarchy than the earlier generic event cards:

- the illustration occupies a substantial upper band and must remain the visual anchor;
- the card border color communicates the decision family (e.g. rescue / danger / greed) but text remains authoritative;
- a small divider/medallion separates illustration and live choice text;
- disabled branches should communicate the reason explicitly (for example **НЕДОСТАТОЧНО ЗОЛОТА**) instead of relying on dimming alone;
- card art may be cropped directly from an approved mockup, but changing costs, rewards, role names, run values and disabled state must remain live Godot UI.

The exact approved Whispering Well and Chained Prisoner illustration crops are stored in one runtime-decoded WebP atlas at 384×160 per card. This replaces the older lower-detail choice art for those two screens without changing their event mechanics.


## D057 — Act 1 choices can echo into later cards

Date: 2026-10-07  
Status: accepted for vertical-slice consequence pass

Act 1 cards are allowed to store a small explicit outcome in `RunState.event_outcomes`, and later cards may read that outcome to change price, text or reward. These links must be consequences of a choice the player actually made, not penalties for a card the run never offered.

The first three canonical links are:

- **Lost Purse → Gravedigger Shop**: respectful handling lowers the shop price to 30; greedy handling raises it to 45.
- **Debtor Bones → Wizard Tithe**: cautious handling lowers the gold tithe to 25; gambling or breaking the bones raises it to 40.
- **Blood Ledger → Broken Crown**: if the ledger was actually used before the crown, the melt route gains +15 gold from knowledge carried forward.

These links should stay sparse and legible. The goal is to make the table feel connected, not to create an opaque dependency web.

## D058 — Blood rescues leave named scars on the protagonist

Date: 2026-10-07  
Status: accepted for companion-fate pass

Saving a companion through the sacrificial/blood route should leave a persistent named mark instead of only applying an anonymous party-wide HP modifier. The current scars are:

- Knight: **ШРАМ ЦЕПЕЙ**, -10 protagonist max HP;
- Ranger: **ШРАМ ДОРОГИ**, -8 protagonist max HP;
- Mage: **ШЁПОТ ПОД КОЖЕЙ**, -12 protagonist max HP.

A scar is keyed by the rescued companion role, can occur at either the primary or reserve rescue event, and can only be acquired once per role. Gold-based rescue routes avoid the scar where such a route exists. Scar penalties are applied after solo/duo party multipliers so the listed value is the actual max-HP loss.

Squad Dossier must show the scars and their descriptions on the protagonist. Wizard Memory may comment on the scar immediately afterward.

## D059 — Wizard Memory distinguishes solitude from deliberate abandonment

Date: 2026-10-07  
Status: accepted for host-personality pass

The Wizard should not treat every one-person party as the same story state. A run that remains solo through at least six resolved cards can trigger a `solo_endurance` remark, while explicitly losing both non-protagonist companions triggers the stronger `deliberate_loner` memory.

This is narrative state only; it does not add another solo combat multiplier. The existing solo stat compensation remains the sole baseline solo-balance rule.


## D060 — Accepted Wizard wagers unlock one cursed tactical order

Date: 2026-10-07  
Status: accepted for vertical-slice tactical-depth pass

Accepting a voluntary Wizard wager grants a one-battle tactical option named **ЖЕРТВА**. It is not a permanent fourth baseline order.

For the next combat only, **ЖЕРТВА** gives every player hero:

- +40% damage;
- +20% attack speed;
- continuous self-attrition equal to 2% of that hero's max HP per second.

The option is consumed when the next combat starts, even if the player ultimately locks a different tactical order. This keeps it as a temptation attached to the wager rather than a stockpiled resource. A defeat/retry therefore does not restore it.

The order keeps the ordinary nearest-target behavior; its identity is the destructive stat trade, not a fourth targeting AI. Do not add more cursed orders until this one is balance-tested across solo, duo and trio runs.

## D061 — Wizard tells reuse the live table instead of adding visual clutter

Date: 2026-10-07  
Status: accepted for host-presence polish

Wizard mood/state should be readable through small changes to existing cards and commentary rather than by returning to heavy procedural dressing on the table.

The first tells are:

- accepted-wager history biases deal animation toward a slower, smoother hand;
- refusal-heavy history makes dealing shorter and sharper;
- a card briefly twitches before an already-scheduled Wizard meddling replacement;
- companion-loss / deliberate-loner memory temporarily dims the live card layer;
- rescue-scar memory gives the commentary line a brief warm-red pulse.

These tells may reveal mood or foreshadow an intervention, but must not change offer probabilities, card contents or combat values by themselves.


## D062 — Defeat is terminal unless the one-use Last Deal is accepted

Date: 2026-10-07  
Status: accepted for vertical-slice defeat redesign

Combat defeat is no longer a free return-to-table retry. The active encounter remains the same only when the player accepts the Wizard's one-use **ПОСЛЕДНЯЯ СДЕЛКА**.

Rules:

- the first defeat in a run offers the Last Deal;
- the deal can be accepted at most once per run;
- if the player owns one or more relics, one owned relic is chosen as the explicit price before the player commits; accepting permanently removes that relic;
- if the player owns no relics, the price is **КЛЕЙМО ПОСЛЕДНЕЙ СДЕЛКИ**, a persistent -15 protagonist max-HP penalty for the rest of the run;
- accepting reloads the same combat encounter immediately;
- refusing ends the run;
- any later defeat after the Last Deal has been used ends the run without another rescue offer;
- the cursed **ЖЕРТВА** tactical-order opportunity is not restored by a Last Deal retry if it was already consumed by the failed attempt.

The purpose is to make defeat carry actual roguelike stakes while preserving one dramatic Wizard-mediated recovery. Do not add additional lives, revive currencies or repeatable paid retries before this rule is balance-tested.


## D063 — Rescue scars may unlock later advantages without erasing their original cost

Date: 2026-10-07  
Status: accepted for Act 1 consequence-depth pass

Named rescue scars are persistent costs first, but they may also act as recognizable keys in later Act 1 events. The advantage must be situational rather than a general stat refund, so saving a companion still carries a meaningful price.

Current scar-key links:

- **ШРАМ ЦЕПЕЙ**: at **КОСТЯНАЯ ПОШЛИНА**, the blood-payment branch becomes free passage because the guard recognizes the mark;
- **ШРАМ ДОРОГИ**: at **КАРТА БЕЗ ЛИЦА**, the deterministic development route costs 15 gold instead of 30;
- **ШЁПОТ ПОД КОЖЕЙ**: at **КРОВАВАЯ КНИГА**, the blood-signing route costs 10 party HP instead of 25.

Do not make every later card react to every scar. Scar-key moments should stay rare enough to feel like consequences returning, not a parallel perk tree.

## D064 — Act 1 allows one held fate card

Date: 2026-10-07  
Status: accepted for table-strategy pass

Once per Act 1, while a normal two-card offer is on the table, the player may use **УДЕРЖАТЬ** on one card. The held card cannot be chosen in that offer; the player must take the other card now.

Rules:

- one hold use per run;
- the held card is not counted as rejected;
- it leaves the normal deck flow and returns as a guaranteed offer after two more resolved cards;
- when it returns, rejecting it is permanent like any normal offer;
- holding is disabled after 10 pre-boss cards have already been resolved so the reserved card cannot be stranded behind the Bone Warden handoff;
- boss and already-active cards cannot be held.

This mechanic is intentionally not a general deckbuilding hand. It is a single dramatic way to postpone fate.

## D065 — Wizard-marked cards are visible self-authored risk

Date: 2026-10-07  
Status: accepted for table-risk pass

Act 1 schedules up to two visible **ПЕЧАТЬ ВОЛШЕБНИКА** offers. One of the two current cards is visibly marked before the player chooses.

Choosing the marked card:

- immediately grants +20 gold;
- activates +15% enemy damage until the next combat is won;
- applies to the marked card itself if that card is a combat encounter;
- persists through a Last Deal retry of that combat.

Choosing the unmarked card has no mechanical punishment. Holding the marked card counts as refusing the mark; the card may return later, but without that mark.

A second mark is not offered while mark danger is already active. Wizard mark danger stacks additively with the existing +25% Wizard debt because both conditions are explicitly shown to the player.


## D066 — Selected combats can alter legal deployment geometry

Date: 2026-10-07  
Status: accepted for Act 1 tactical-depth pass

Pre-battle placement should matter differently in a few authored encounters instead of every fight exposing the same rectangle. This remains a preparation mechanic; it does not add mid-fight micromanagement.

Current authored deployment rules:

- **ЗАЛП С ВИСЕЛИЦЫ** — one deep vertical deployment line, encouraging vertical spread against two archers;
- **КОСТЯНАЯ ДАВКА** — two separated horizontal bands, forcing the party to decide how to split or concentrate;
- **ВРАТА ОССУАРИЯ** — two separated deployment pockets with the center unavailable;
- **КОСТЯНОЙ НАДЗИРАТЕЛЬ** — a tighter deployment area that makes boss AOE spacing more deliberate.

Legal deployment regions are shown with restrained live UI panels and the unit drag code supports disconnected rectangles. Other encounters keep the ordinary deployment bounds.

Do not make every combat use a bespoke geometry. The special layouts should identify encounters with a distinct tactical problem.

## D067 — Combat cards expose concise threat tags before commitment

Date: 2026-10-07  
Status: accepted for table-decision readability

The Wizard-table choice should communicate the important combat problem before the player commits to a card. Combat-card type lines may therefore include one or two concise, authored tags such as **РОЙ**, **ЛЕЧЕНИЕ**, **AOE**, **2 ЛУЧНИКА**, **ДАЛЬНИЙ** or **ФАЗЫ**.

These tags summarize known encounter composition only. They do not reveal hidden outcomes, change stats, or replace the card illustration / description.

## D068 — Faceless Card may judge the whole Act 1 run

Date: 2026-10-07  
Status: accepted for late-act consequence pass

**КАРТА БЕЗ ЛИЦА** is the first late card allowed to read an aggregate run profile rather than one explicit earlier event. This is not a hidden morality score: the profile is derived from concrete visible facts already created by player choices.

Current precedence and outcomes:

- **БЕЗ СВИДЕТЕЛЕЙ** — both possible companions were deliberately lost; the special resolution grants +50 gold;
- **ИСПИСАН ШРАМАМИ** — at least two rescue scars are present; the special resolution grants a random available relic, or +35 gold if none remain;
- **ЛЮБИМЕЦ СТАВОК** — at least two Wizard-authored risks were accepted across voluntary wagers and marked cards; the special resolution grants extra hero development, or +35 gold if development is exhausted.

The special branch reuses the existing fourth/leave action rather than adding another modal or a generalized morality subsystem. If multiple profiles are true, deliberate companion loss takes precedence, then multiple rescue scars, then repeated risk-taking.


## D069 — Selected combats may carry visible optional Wizard conditions

Date: 2026-10-07  
Status: accepted for Act 1 combat-depth pass

A small subset of combat cards may include one optional, fully visible condition from the Wizard. The condition never blocks victory and never replaces normal combat rewards; satisfying it grants a small **+15 gold** bonus only after the fight is actually won.

Current conditions:

- **МОГИЛЬНЫЙ ЗВОН** — the Grave Bellkeeper must be the first enemy to die;
- **ЗАЛП С ВИСЕЛИЦЫ** — no player hero may fall to 25% HP or lower;
- **КОСТЯНАЯ ДАВКА** — win within 16 seconds.

Conditions are authored per encounter rather than generated randomly. Their purpose is to make placement, tactical orders and current builds matter beyond binary survival without turning combat into an objective checklist.

## D070 — Two refusals can unlock one-battle Defiance

Date: 2026-10-07  
Status: accepted for Wizard-resistance path

Explicitly refusing Wizard-authored risk should have a mechanical identity rather than being purely the absence of a wager. Refusing a voluntary Wizard wager or declining a visibly marked card contributes one refusal. After two such refusals, the next combat exposes the temporary tactical order **НЕПОВИНОВЕНИЕ**.

For that combat, **НЕПОВИНОВЕНИЕ** gives all player heroes:

- -20% incoming enemy damage;
- -15% outgoing damage.

The option is consumed when the next combat begins whether selected or not, matching the timing rule used by **ЖЕРТВА**. Refusals are counted across the run; accepting a different Wizard offer does not erase prior refusals. If both temporary orders happen to be ready at once, both may be shown, but only one tactical order can be selected for the fight.

This creates a defensive resistance counterpart to the aggressive cooperation path of **ЖЕРТВА** without adding a permanent fourth baseline order.

## D071 — Bone Warden Phase II reflects the run but base boss stats stay fixed

Date: 2026-10-07  
Status: accepted for Act 1 finale personalization

Bone Warden remains a fixed benchmark in base HP, damage, attack cadence and Phase II threshold. The run-history response is limited to the already-existing reinforcement moment at 50% HP.

Phase II reinforcement plans:

- **БЕЗ СВИДЕТЕЛЕЙ** — two Bone Thralls;
- **ИСПИСАН ШРАМАМИ** — one Grave Bellkeeper, able to heal the boss;
- **ЛЮБИМЕЦ СТАВОК** — two Bone Archers;
- no aggregate profile — the existing Bone Archer + Bone Thrall pair.

The active verdict is shown to the player in the boss preparation/Phase II presentation. This is authored consequence, not hidden adaptive difficulty: the boss's core benchmark does not scale to party size or player power.

## D072 — Generated illustrations are source material, not automatically final production art

Date: 2026-10-07  
Status: accepted

Misdeal's production target is authored low-resolution dark-fantasy pixel art. Existing generated illustrations may be used as composition reference/source material, but final player-facing art must follow `docs/ART_DIRECTION.md`: limited recurring palette roles, readable silhouettes, restrained motivated lighting, negative space, meaningful repeated symbols and nearest-neighbor presentation.

A shared grading material may reduce smoothness and unify palette, but it does not excuse malformed hands, impossible architecture, meaningless ornament or unclear composition. Those assets require redraw/replacement. The first reference surfaces are the Wizard table, battle arenas and Whispering Well; do not propagate the treatment blindly before local review.

## D073 — Bone Crush is the first true source-art replacement

Date: 2026-10-08  
Status: accepted

The approved **КОСТЯНАЯ ДАВКА** concept is the first arena that replaces its source composition rather than relying on the shared corrective art-grade shader.

The arena gets a dedicated backdrop with simpler architecture, fewer light sources, large quiet floor areas and much lower decorative density. Because the source is already targeted at the production language, the heavy environment correction grade is not applied to this arena.

Its two legal deployment bands are communicated as physical chalk/etched floor markings. Generic blue debug-looking deployment rectangles are no longer part of the intended production presentation.

Use the local 1280×720 result as the reference before replacing the remaining arena sources.

## D073 — Second art pass replaces high-AI-smell source art instead of increasing the grade

Date: 2026-10-08  
Status: accepted after local screenshot review

The first production grade remains useful as a final consistency layer, but it must not be strengthened to hide problematic source art. The next visual pass will redraw/replace the worst offenders.

**КОСТЯНАЯ ДАВКА** is the first benchmark redraw because the current ossuary/cathedral background has the highest density of repeated candles, bones and ornamental structures. The new direction favors simpler readable architecture, large negative-space masses, fewer motivated lights and a broad quiet combat floor.

Deployment zones should move from translucent blue UI rectangles toward world-space floor marks (scratches, inlays, faded ritual geometry) while the actual legal placement geometry remains data-driven and unchanged.

The Bone Crush replacement should receive a dedicated arena id rather than overwriting the shared Ossuary backdrop. This keeps the pass authored per encounter and prevents an art experiment from unintentionally changing other fights.

After one arena is locally approved, object-first card redraws may follow. **ГРЕМУЧИЙ МОСТ** and **КОШЕЛЬ МЕРТВЕЦА** are the first candidates.


## D074 — Full visual redraw proceeds in reviewed batches

Date: 2026-10-08  
Status: accepted

The user approved the new dark-fantasy low-resolution concept language as the target for the whole player-facing game. The conversion should be broad, but integration remains incremental so each runtime surface can be checked for readability and layout regressions.

The first card batch uses an **object-first** rule: one dominant readable subject, large negative-space masses, restrained motivated light and no baked mutable gameplay text. **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА** and **ШЕПЧУЩИЙ КОЛОДЕЦ** are the first runtime replacements.

New authored images may bypass the corrective card grade when necessary, or use a reduced grade strength. The grade is a consistency layer, not a way to crush already-authored art into the old generated look.

Gameplay rules and mutable UI stay live in Godot while the visual library is replaced.


## D075 — Reject thumbnail-scale redraw atlases and require semantic asset mapping

Date: 2026-10-08  
Status: accepted after local screenshot review

The broad v3 integration using 112×69 table-card cells and 320×180 full-screen arena cells is rejected. Enlarging those thumbnail-scale sources created visible blockiness and mud that read as compression/downscaling damage rather than intentional pixel art.

For the current table layout, new redraw cards must be stored at the existing 224×137 near-display source size or better. Battle backdrops must use native/high-resolution authored sources appropriate to the 1280×720 viewport; a 320×180 arena source must not be enlarged fourfold as the production background.

Generated sources are mapped by their actual subject, not by generation order. If no trustworthy source matches a card, that card keeps its already-approved unique atlas art until a real redraw exists. Reusing an unrelated image is worse than retaining a coherent fallback.

The corrected v4 pass therefore uses 19 semantically matched 224×137 redraws and falls back to the approved 25-card atlas for Ash Rest, Bone Crush, Broken Crown, Candle Seller, Bone Tax and Death Wager. Arena runtime uses native/high-resolution sources: new 1280×720 v4 redraws for Crypt and Gallows Volley, validated HD sources for Graveyard/Ossuary/Warden, and the dedicated Bone Crush benchmark backdrop.


## D076 — Complete card coverage with a supplementary HD batch, not another monolithic atlas

Date: 2026-10-08  
Status: accepted after local verification of the corrected v4 pass

The accepted 224×137 v4 card redraws remain untouched. The last five scene-based redraws are added as a small v5 atlas at the same 224×137 source size rather than rebuilding or recompressing the accepted v4 sheet.

**СЛОМАННАЯ КОРОНА** is a deliberate exception: its table card uses the exact approved object-centric Broken Crown artifact illustration. The card represents acquiring that source-locked artifact, so sharing the visual strengthens recognition and avoids inventing a weaker unrelated scene.

The active-card lookup order is exact Broken Crown artifact art where applicable, matching v5 redraw, matching v4 redraw, then the legacy approved atlas only as a decode/failure fallback. No active Act 1 card intentionally depends on unrelated art.

Supplementary art may be stored as split base64 WebP text when that keeps repository transport reliable. Source resolution must stay at near-display size or better.


## D077 — Latest authored battle redraws are authoritative and are not post-darkened

Date: 2026-10-08  
Status: accepted

The latest reviewed redraws in the current visual pass are the authoritative runtime art for Graveyard, Ossuary, Bone Warden and Bone Crush. The latest dedicated Bone Warden character redraw is also authoritative for the boss table card.

These authored images already contain their intended contrast, palette and lighting. Battle backdrops therefore must not receive the legacy environment-grade material on top. That extra pass crushed shadow detail and caused the visibly over-dark Grave Bell and Ossuary screenshots.

Battlefield art must expose a broad, continuous floor plane that matches live unit coordinates. Bone Crush now uses encounter-specific floor-safe combat bounds and deployment bands instead of allowing units to occupy the architectural upper portion of the backdrop.

Crypt and Gallows remain on their accepted v4 native-HD art. No combat mechanics, stats or targeting rules are changed by this decision.


## D078 — Authored table art is not double-graded

Date: 2026-10-08  
Status: accepted after local screenshot review

The Wizard table and current card redraws already contain their intended low-key lighting. Applying the legacy environment/card grade on top crushes their dark mids and makes the table, card illustrations and Wizard wager read as nearly black.

The authored Wizard backdrop and table/wager card art therefore bypass the shared grade materials. The shared environment/card materials remain available for older surfaces, but their strengths are reduced to 0.30 and 0.14 respectively.

Modal focus should come from framing and a moderate scrim, not from hiding the entire table. The Wizard wager scrim target is 0.52 alpha.

The prepared v6 table/wizard crop is allowed as production art because it contains no baked mutable gameplay text, prices or buttons; those remain native Godot controls.


## D079 — High-visibility screens use dedicated environment/portrait art while gameplay UI stays live

Date: 2026-10-08  
Status: accepted for the current production-art pass

Class Select, Reward, Whispering Well, Curse Forge, Chained Prisoner, Black Altar and Run End are high-visibility screens and should no longer rely on enlarged combat sprites, generic table backgrounds or procedural environment blockouts when approved dedicated art exists.

Dedicated character portraits may be larger than combat sprites because they serve identity rather than tactical readability. Dedicated event/reward/end backdrops use native 1280×720 authored sources.

Generated full-screen art is used only as environment/character imagery. Titles, costs, choice labels, run state, buttons, reward values and consequences remain native Godot controls/scripts.

The shared decorative overlay should support authored art, not obscure it. Its table-shade contribution is therefore reduced while semantic glows/marks remain.


## D080 — New authored WebP screen art uses runtime decoding

Date: 2026-10-08  
Status: accepted after Godot 4.7.2 parser failure

New production WebP assets that are delivered through Git must not be referenced directly with GDScript `preload()` or new `Texture2D` scene ext_resources when that can make script/scene parsing depend on editor import timing.

Use the shared `runtime_webp_texture.gd` loader instead:

- open the source via `FileAccess`;
- decode with `Image.load_webp_from_buffer()`;
- optionally normalize to the expected display size;
- cache the resulting `ImageTexture`;
- keep the node, layout and gameplay state in normal Godot scenes/scripts.

This matches the robust loading approach already used by authored battle backdrops and prevents new art from breaking project parsing after a Git pull.


## D081 — Shared hero identity art and dedicated secondary event environments

Date: 2026-10-08  
Status: accepted

Large non-combat hero presentations should reuse the dedicated Class Select portraits rather than scaling combat sprites. Squad Dossier therefore shares the same Knight / Ranger / Mage identity art as Class Select.

Secondary Act 1 events that have a strong place/ritual identity may receive their own 1280×720 authored environment while continuing to use the shared live Act Choice UI. The first four are Candle Seller, Gravedigger Shop, Blood Ledger and Faceless Card.

These WebPs follow D080 and use runtime decoding instead of direct preload/import-time texture dependencies.


## D082 — Broad Act 1 environment replacement stops after V9

Date: 2026-10-08  
Status: accepted

The V9 batch completes the planned broad environment-art replacement for generic Act 1 non-combat events.

Rattling Bridge, Lost Purse, Debtor Bones, Bone Tax, Wizard Tithe, Ash Rest, Last Camp and Broken Crown now receive dedicated 1280×720 authored environments through the shared live Act Choice UI.

The environment is allowed to establish place, mood and a clear focal prop, but gameplay labels, prices, outcomes, companion fate state and buttons remain native Godot UI. Broken Crown keeps the same recognizable crown object used by its artifact/card presentation.

All V9 WebPs follow the D080 runtime-decoding rule. After this batch, further art changes should be driven by local screenshots and concrete readability/composition problems rather than another blanket regeneration pass.


## D082 — GitHub stores a durable handoff and recoverable visual source registry

Date: 2026-10-08  
Status: accepted

Project continuity must not depend on the previous ChatGPT transcript.

`docs/HANDOFF.md` is the compact continuation point for a fresh chat, and `docs/VISUAL_ASSET_REGISTRY.md` records the active visual version/path mapping plus rejected visual approaches.

Approved production runtime art remains under `assets/pixel/`. Where a larger generated source is worth preserving for future recropping, it may also be stored under `assets/source_archive/` as a non-runtime master.

The final V9 event sources are archived at their generated 1672×941 composition size as Q95 WebP masters. This keeps them recoverable without adding the much larger raw PNGs to normal runtime asset folders.

New chats should read both handoff/registry files before proposing another visual replacement pass.

## D083 — Shared live UI chrome replaces screen-by-screen StyleBox drift

Date: 2026-10-08  
Status: accepted, pending local visual verification

Misdeal keeps mutable gameplay text, prices, state and buttons as native Godot controls, but their presentation should no longer be independently restyled on every screen.

`scripts/ui/misdeal_ui_kit.gd` is the shared runtime chrome layer for the vertical slice. It modifies existing StyleBoxFlat resources in place so scene layout/content margins survive, then adds restrained pixel-gothic corner marks and semantic accent roles (bronze/gold/ember/steel plus hero colors). Existing approved choice illustrations, artifact art and authored backdrops remain the content layer underneath this chrome.

The kit is intentionally lightweight rather than a new theme framework: no baked UI screenshots, no addon dependency and no replacement of live scene logic. Screen-specific semantic styling may still refine the shared base (for example event risk colors, table card types and temporary tactical-order colors), but new screens should start from the shared kit instead of inventing unrelated panel/button treatments.

## D084 — Incomplete parties scale encounter pressure, not encounter composition

Date: 2026-10-08  
Status: accepted, pending local full-run verification

The earlier solo rule restored hero HP/damage/action cadence but kept every enemy at the full trio-authored baseline. Static review and prior local feedback show that this still leaves one-body runs too sensitive to focus fire and to opening combat timing, especially for Ranger and Mage.

Act 1 now preserves authored enemy compositions and mechanics while scaling **pressure** by current party size:
- solo heroes: HP ×2.2, damage ×1.9, attack interval ×0.80, movement ×1.10;
- solo enemies: HP ×0.82, damage ×0.80;
- duo heroes: HP ×1.20, damage ×1.15;
- duo enemies: HP ×0.92, damage ×0.90;
- trio: authored 100% baseline.

Support-heal amount follows enemy HP scaling. Wizard Debt and Wizard Mark remain percentage danger modifiers on top of the party-size enemy-damage baseline. Boss phase logic, target AI, enemy count, ranges and attack cadence do not change.

This is preferred over hand-tuning separate solo versions of every encounter: one rule keeps all existing and future Act 1 fights coherent and avoids duplicating encounter Resources.

The opening pacing also guarantees one non-combat decision before the first forced tier-0 fight. This is not a guaranteed recruitment; it simply prevents a fresh one-hero run from being forced into combat before the player has made any table decision.

This supersedes D035 only where D035 states that enemies never scale by party size. D035's core reasoning — solo must compensate for lost action economy — remains valid.

## D085 — Scene changes are covered by a persistent autoload veil

Date: 2026-10-08  
Status: accepted, pending local verification

Heavy authored screens decode some WebP art at runtime. A direct `SceneTree.change_scene_to_file()` can therefore expose the viewport clear color for a frame while the outgoing scene is already gone and the incoming screen is still assigning its textures.

Misdeal routes active scene changes through the `SceneTransition` autoload. After local testing showed that a persistent veil alone could still expose an intermittent gray frame, the helper now **preloads the incoming PackedScene while the outgoing scene remains alive**, renders a fully opaque veil frame, manually adds the incoming scene before freeing the outgoing scene, switches `SceneTree.current_scene`, waits for incoming runtime-art/layout frames to render, and only then fades the veil away. Battle reloads use the same path. The rendering default clear color and runtime RenderingServer clear color match the veil as fallbacks.

Do not fix future transition flashes with per-scene gray/black panels or arbitrary delays. Keep transition ownership centralized in the persistent autoload and only adjust its timing if local evidence requires it.


## D086 — The restrained Wizard/table redraw is the canonical main splash

Date: 2026-10-08  
Status: accepted by user

The previous start screen was rejected locally for visibly poor image quality, and an initial replacement was rejected for an over-rendered / obviously generated look and an off-model Wizard.

The accepted main splash is the calmer dark-gothic Wizard/table composition now stored at `assets/pixel/main/approved_splash_hd/main_splash.webp`. It uses a restrained prop count, a clearer focal hierarchy, the established red-black-gold / moonlit-blue palette, and a Wizard closer to the recurring host identity used elsewhere in Misdeal.

The runtime copy is native 1280×720 WebP and is decoded with FileAccess/Image at runtime rather than referenced through a new imported Texture2D resource. Keep the live start hotspot/UI separate from the illustration.



## D087 — Battle preparation exposes first-target intent

Date: 2026-10-08  
Status: accepted, pending local readability verification

Misdeal's combat agency should come from preparation rather than hidden AI guesswork. During the preparation phase, the game now visualizes the **actual current first-target choice** produced by the existing unit targeting functions:

- blue arrows: each hero's expected first target under the selected tactical order;
- red arrows: each enemy's expected first target under current placement.

The arrows update while heroes are dragged and while tactical orders change, then disappear as soon as combat begins. This is a readability/agency improvement, not a new targeting rule: the preview calls the same target-selection logic used by the combat units.

Keep the preview restrained and preparation-only. Do not turn combat into a permanent network of target lines or add a second prediction model that can disagree with live AI.

## D088 — Act 1 progression is a physical Fate Spread, not a node map

Date: 2026-10-08  
Status: accepted by user, implemented pending local visual verification

Misdeal should not adopt a conventional branching world-map screen for Act 1 progression. The cursed table itself is the journey.

Act 1 is represented as **РАСКЛАД СУДЬБЫ**:
- twelve chronological positions I–XII correspond to the twelve resolved pre-boss cards;
- resolved cards remain visible with their real card art, turning the spread into a physical history of the run;
- XIII is the central sealed Bone Warden card and is revealed when the boss becomes due;
- rejected cards belong to a separate Wizard discard;
- the one held card has its own physical holder;
- the normal dealing screen retains a compact occult ring, while a dedicated inspection overlay exposes the complete history via `R` / `РАСКЛАД СУДЬБЫ`.

The implementation must stay live/data-driven. Do not replace the table with a static screenshot containing baked card names, counters or fake run history.

Future slots remain unknown under the current random-offer model. If the game later exposes future card-type symbols, those hints must be backed by an actual scheduling/foresight mechanic rather than decorative misinformation.

The initial spread also divides pacing visually into three four-card chapters — **ПЕРВАЯ РАЗДАЧА**, **СТОЛ ПОМНИТ**, **ПОСЛЕДНЯЯ РАЗДАЧА** — without yet changing mechanical tier rules.

## D089 — Fate Spread is both progress map and run memory

Date: 2026-10-08  
Status: accepted, implemented pending local verification

The Fate Spread should not behave like a passive 12/12 counter. It is the physical record of the current cursed game.

Each resolved pre-boss card now stores the pair that created it: the chosen card and the alternative rejected at that deal. Hovering a completed slot may reveal that pair, but should not replace the visible chronological card history or introduce a separate journal screen.

The three four-card chapter boundaries are also presentation beats:
- **IV** — first ritual acknowledgement;
- **VIII** — second chapter transition and visible weakening of XIII's seal;
- **XII** — final ritual reveal before XIII/Bone Warden.

These beats trigger once per run when the player returns to an unlocked table state. The spread may auto-open briefly as a chapter punctuation, but normal card choice remains untouched and no additional reward/cost is attached to the milestone.

The inspection screen keeps a restrained physical table surface beneath live cards/seals. Do not replace this with a generic map background or a baked screenshot.

## D090 — Approved Fate Spread art is atmosphere, not baked run state

Date: 2026-10-08  
Status: accepted by user, implemented

The ornate Fate Spread reference with candles, gothic metalwork, red ritual cloth and physical table props is the approved visual target for this screen.

Run-specific text, cards, counters and current-path state must not be baked into the runtime illustration. The approved art is therefore used only as a dark atmospheric underlay. Live Godot UI remains authoritative for I–XII history, XIII state, hold/discard contents, chapter text, counts and hover decision memory.

Keep future visual work close to this physical occult-table reference: dense edge props, warm candle/brass highlights, red-black cloth/leather center, and a strong chained XIII focal point. Avoid returning to flat black modal UI or generic map styling.

## D091 — Fate Spread follows the final approved reference almost one-for-one

Date: 2026-10-09  
Status: accepted by user, implemented pending local screenshot verification

The final approved Fate Spread composition is now the authoritative visual target, superseding the intermediate dark-underlay and edge-art-only experiments.

Use the approved full physical table plate as the scene foundation. Match its composition closely: large red-black ritual circle, I–XII physical cards around the ring, chained XIII in the center, ornate Hold holder on the left, Wizard Discard stack on the right, candle/brass/skull/book props at the edges, and the visible player hand in the lower-right.

Run-specific state must remain live:
- mask and replace the baked header counts/title values;
- overlay all I–XII slots with live card/back panels aligned to the reference positions;
- mask and replace only the card/count contents inside Hold and Wizard Discard;
- preserve live XIII/boss state, hover decision memory and milestone behavior.

Do not return to a flat black modal, generic radial-menu composition or separate edge-art collage unless the user explicitly reverses this decision.

## D092 — The normal card-selection screen uses the Variant C oval ritual table

Date: 2026-10-09  
Status: accepted by user, implemented pending local screenshot verification

The detailed Fate Spread screen is frozen as its own physical progression view. The **normal Wizard/card-selection table** now follows the separately approved Variant C composition.

The key visual rule is that the play surface must read as one large **oval physical ritual table**, not a rectangular lower HUD panel. The Wizard remains the host/focal figure behind the table; two live offer cards occupy the near-center; Hold controls sit immediately above those cards; deck and rejected-card stacks live in physical holders at the left and right edges; one broad red ritual sigil owns the cloth.

Keep the composition restrained. Do not solve the table with dozens of tiny decorative props, repeated runes or ornamental noise. Large deliberate shapes, candlelit red-black-gold hierarchy and tactile card placement are preferred.

Mutable card art/text, counts, Wizard lines, Hold state, deck/discard counts and buttons remain native Godot UI. The approved concept is a composition target, not permission to bake a particular run's values into background art.

Detailed Act progress remains in `РАСКЛАД СУДЬБЫ`; do not duplicate another twelve-node progress map on the normal deal table.

## D093 — Final Variant C artwork is the canonical normal table

Date: 2026-10-09  
Status: accepted by user, implemented pending local screenshot verification

The final cleaned-up Variant C image is now the authoritative visual target for the **normal Wizard/card-selection table**, not merely a loose layout reference.

Use the approved full 16:9 physical-table plate as the runtime foundation:
- Wizard centered behind a broad oval red-black ritual table;
- restrained candle/brass/skull props around the edges;
- physical deck at left and rejected-card stack at right;
- two live offer cards near the player;
- Hold controls immediately above them;
- `РАСКЛАД СУДЬБЫ [R]` centered between Wizard and cards;
- compact live HUD and Wizard line at the top.

Mutable run state must remain live. Baked example offer cards, counts and Hold text may be covered by aligned live controls/masks, but should not become authoritative data. The static physical composition, logo, Wizard, table, props and holder frames may come directly from the approved plate.

Keep this screen visually restrained. Do not reintroduce the old rectangular lower HUD/table, the duplicate compact progress ring, or dense generated ornamental clutter.

## D094 — Freeze Fate Spread and treat exact Variant C as the canonical normal table

Date: 2026-10-09  
Status: accepted by user, implemented; normal-table local screenshot verification pending

The user explicitly froze the current Fate Spread after screenshot iteration and separately approved the final cleaned-up Variant C artwork for the normal Wizard/card-selection table almost one-for-one.

Therefore:
- Fate Spread is considered visually complete except for concrete rendering bugs.
- The normal table's canonical visual foundation is `assets/pixel/table/approved_variant_c/table_exact.webp`.
- Dynamic run state remains native/live Godot UI over that plate.
- Future normal-table work should be alignment/masking/readability polish, not a new art direction.
- Avoid dense AI-like prop noise and micro-detail; keep large readable physical forms.
- After local acceptance of the exact table, development priority returns to vertical-slice validation and balance rather than broad visual replacement.


## D095 — Neutral physical card backs replace dark cleanup masks

Date: 2026-10-09  
Status: accepted by user, implemented pending local screenshot verification

Baked face-up sample cards in the approved Wizard-table plate must never be exposed as fake live state. Dark rectangular/oval cleanup masks were locally rejected because they read as holes in the table.

The canonical runtime solution is physical:
- a shared neutral black-leather/brass card back lives at `assets/pixel/table/card_back_runtime.svg`;
- two backs permanently cover the baked offer-card faces beneath the live offer layer;
- when both live offers are present they cover the backs; single-card/retry states may reveal the backs naturally;
- an empty Fate Spread Hold slot shows the same back rather than a dark void;
- Wizard Discard is absent when empty, and when populated its live top card sits on the shared back/frame aligned to the painted stack.

These backs are presentation-only. They do not reveal future card identity or change Hold/discard rules. Do not return to opaque dark cleanup slabs for these card zones.

## D096 — Event context art and choice art have different jobs

Date: 2026-10-09  
Status: accepted by user, implementation started

For Act 1 event screens, the large event illustration communicates **where/what is happening**. Lower choice-card illustrations communicate **what the player is choosing to do**.

Choice cards should not default to three copies/crops of the event image when the options have distinct meanings. The preferred mini-art language is:
- one dominant object, gesture or action per choice;
- large readable silhouettes at card scale;
- restrained recurring palette and low decorative density;
- semantic accent colors support risk/greed/rescue/refusal, but text remains authoritative;
- mutable costs, consequences and disabled states stay live in Godot.

`rattling_bridge` is the benchmark implementation, with separate art for both its ranger-recruitment and already-resolved choice sets.

This rule is a presentation-system decision, not a request for bespoke scene architecture per event. Reuse the shared Act Choice layout and add semantic art mappings data-first.

## D097 — The approved five-event choice sheet is the mini-art production benchmark

Date: 2026-10-09  
Status: accepted by user, implemented

The selected five-event mockup is now the visual benchmark for event choice cards. Production uses cropped action-first illustrations from that approved sheet rather than duplicating the large event scene or using schematic vector placeholders.

The approved sheet established the composition benchmark: large silhouettes, one dominant action and restrained detail are preferred over high-frequency generated ornament. The original 192×80/nearest presentation detail was later superseded by D098, which prefers native 384×160 approved cells whenever available and uses the compact sheet only where necessary.

The approved sheet is mapped only where its imagery remains truthful to live mechanics:
- Rattling Bridge recruitment;
- Whispering Well;
- Chained Prisoner recruitment;
- Black Altar recruitment.

Black Altar remaps the approved coin-hand and altar-offering images to the current 35-gold ritual payment and take-offering choices. Chained Prisoner's later branch keeps its older dedicated semantic art. Curse Forge keeps the actual artifact illustrations because its live choices are specific relics and those images are more mechanically accurate than the generic forge options shown in the concept mockup.

Dynamic labels, costs, disabled states and outcomes remain authoritative Godot UI. Visual consistency must never override mechanical clarity.

## D098 — Reuse semantic action art across events and prefer native-resolution approved cells

Date: 2026-10-09  
Status: accepted implementation rule

D096/D097 established that event context art and choice art have different jobs. The next production step makes that rule reusable rather than authoring a bespoke three-image atlas for every single event branch.

A small set of already-approved action images may be reused across different events when the **action meaning is the same**: payment, blood cost, rescue, looting, breaking chains, walking away, occult gamble, and so on. This is preferable to repeating the large event thumbnail and also reduces high-frequency generated-art noise.

The mapping must stay truthful to the live choice. Do not reuse an image merely because its colors match.

Technical preference:
- use existing native 384×160 approved cells whenever available;
- use the compact 192×80 approved sheet only for actions that have no native approved counterpart;
- role-development choices show the actual offered upgrade art;
- concrete relic choices show the actual relic art;
- mutable text, costs, disabled states and outcomes remain live Godot UI.

This is a presentation rule only. Reusing semantic action art must not change event mechanics or imply a different reward than the live text.

## D099 — Misdeal motion should sell physical cause-and-effect, not constant UI activity

Date: 2026-10-09  
Status: accepted implementation rule

Misdeal's animation language should make cards, rewards and the cursed table feel like physical objects with weight. Motion is used to explain state transitions and commitment, not to keep every screen permanently moving.

Accepted rules:
- use short anticipation / travel / settle beats, usually ~0.07–0.30 s;
- when possible, synchronize visible state changes with the object motion that caused them (for example, the discard pile changes when the rejected card reaches it, not before);
- selected choices become the focal object while alternatives recede;
- valuable rewards get a short confirmation beat before navigation/state replacement;
- preserve the existing fast roguelike cadence; animation must not become a wait tax.

Avoid:
- permanent floating/bobbing cards or panels;
- screen shake for ordinary clicks;
- particle spam;
- unrelated decorative motion;
- hiding core information during long transitions.

Pass 1 applies this rule to Table, generic Events, Whispering Well and Rewards. A later pass should apply the same logic to battle anticipation/death feedback, Fate Spread ritual reveals and restrained Wizard reactions.

## D100 — Combat anticipation is presentation, not a hidden balance nerf

Date: 2026-10-10  
Status: accepted implementation rule

Attack windup may improve readability, but it must not silently retune Act 1 DPS.

Implementation rule:
- set `attack_cooldown = attack_interval` before the anticipation beat;
- keep anticipation shorter than the supported attack intervals;
- apply the hit after the anticipation;
- repeated attack cadence therefore remains driven by the existing data-driven `attack_interval`, with only first-contact/target-switch impact shifted by a few frames.

Current presentation timings are deliberately small:
- melee ~0.08 s;
- ranged ~0.11 s;
- magic/support ~0.14 s.

If local playtesting says combat feels sluggish, shorten/remove these visual timings before touching unit stats. Motion tuning and combat balance should remain separate concerns.

## D101 — Result motion confirms state once, then gets out of the way

Date: 2026-10-10  
Status: accepted implementation rule

Battle result, reward-entry and Last Deal presentation should use a single short hierarchy reveal rather than a permanently animated modal.

Rules:
- result headline/subtitle establish the state first;
- actionable buttons may appear a fraction later, but the total reveal should remain well under one second;
- Last Deal gets one deliberate emphasis beat because it is a rare run-defining offer;
- navigation actions may use a tiny commit animation before scene change;
- do not add looping pulses, repeated shakes or other attention traps.

This keeps rare states dramatic without slowing repeated roguelike play.

## D102 — Ambient motion may animate authored light, not redraw the approved scene

Date: 2026-10-10  
Status: accepted implementation rule

For approved full-screen art such as Variant C, ambient animation should preserve the authored plate.

Allowed:
- low-alpha halos aligned to existing candle flames;
- short color/light reactions aligned to existing ritual markings;
- event-driven pulses tied to real game state;
- very small one-shot entrance/commit motion on UI above the art.

Avoid:
- replacing painted candles with procedural flame sprites;
- moving/scaling the full approved background continuously;
- permanent rotating ritual circles;
- high-opacity glow blobs that change the composition;
- ambient motion that competes with live cards or gameplay text.

The authored still image remains the composition source of truth; runtime motion should behave like light passing over it.
