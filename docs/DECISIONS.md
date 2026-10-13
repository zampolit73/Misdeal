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

## D103 — Battle polish must be isolated from battle ownership and spawn flow

Date: 2026-10-11  
Status: accepted implementation rule

After the empty-arena regression, battle presentation work must not casually alter the controller lifecycle.

Rules:
- keep `battle.gd` responsible for encounter setup, spawning, tactical mechanics, combat lifecycle and results;
- presentation-only tactical tells belong in an isolated non-interactive overlay that observes existing button signals/state;
- combat-unit feedback may modify existing non-blocking sprite/tween feedback functions, but must not insert `await` into attack/damage/spawn paths;
- visual "strong hit" classification may change feedback intensity only; it must not change damage or crit mechanics;
- authored battle backdrops remain composition truth; state FX should be low-alpha overlays rather than replacement environment art.

This preserves the restored stable battle core while still allowing combat readability and personality to improve incrementally.

## D104 — Validate combat variety before commissioning another art batch

Date: 2026-10-11  
Status: accepted implementation rule

The immediate boredom problem is encounter repetition, so Combat Expansion v1 prioritizes different tactical compositions over another broad visual-production pass.

Rules:
- new combat cards may temporarily reuse a semantically close approved combat-card illustration;
- new enemy stat archetypes may temporarily reuse an existing combat family silhouette when the mechanical role is still being tested;
- this reuse must be explicit and temporary, not presented as final unique art;
- dedicated card/enemy art should be produced only for encounters/archetypes that survive local run testing;
- the twelve-card Act 1 structure stays fixed; variety comes from a larger random pool, not a longer mandatory run.

This keeps iteration cheap while testing whether the new fights actually solve run repetition.

## D105 — Combat Expansion encounters own dedicated arena/card art; unit prototypes may still share silhouettes

Date: 2026-10-11  
Status: accepted

The six Combat Expansion v1 fights are now visually distinct enough to remain in the live Act 1 pool.

Rules:
- each expansion encounter owns a unique `arena_id` and a dedicated 1280×720 authored backdrop;
- each expansion run card owns a dedicated 448×274 illustration and no longer aliases an older card;
- unique arena IDs may reuse the nearest existing low-alpha atmosphere and unit-tint family; the authored backdrop is the composition truth;
- the experimental `bone_raider` and `crypt_sentinel` UnitData may continue to reuse `bone_thrall` / `crypt_guard` silhouettes until their mechanical roles survive more run testing;
- dedicated unit sprites are a later targeted pass, not a prerequisite for keeping the six encounter compositions.

This supersedes the temporary card/arena reuse portion of D104 while preserving its gameplay-first rule for unproven enemy archetypes.


## D105 — Battle HUD reserves explicit space for five tactical orders

Date: 2026-10-11  
Status: accepted

The battle preparation screen must not compress unlocked tactical orders into tiny or abbreviated controls.

The bottom command footer reserves five readable tactical slots, keeps the order explanation separate from the primary Fight action, and keeps side objectives out of the playable combat floor. Pixel-art battle backdrops must use nearest-neighbor fallback scaling rather than smooth resampling.

This is a presentation contract, not a combat-rule change.


## D106 — Battle HUD uses modular islands, not full-width slabs

Date: 2026-10-11  
Status: accepted

Battle preparation should preserve the authored arena as the dominant visual surface. Encounter/run information and preparation controls therefore use compact modular plates rather than full-width opaque bars.

The tactical plate dynamically distributes the currently available 3–5 orders across its width. Temporary orders must stay fully named and readable, but empty reserved slots should not create dead visual space.

This supersedes the literal fixed-slot/full-footer interpretation of D105 while preserving its readability requirement.


## D107 — Active battle arenas share one readability-first production set

Date: 2026-10-11  
Status: accepted

All twelve active battle arena IDs use the unified `assets/pixel/battle/arenas/arena_redraw_v1/` visual set.

Arena art must reserve a broad readable combat floor and push high-frequency detail toward the perimeter/background. Distinct encounter silhouettes should come from large landmarks and lighting rather than filling the walkable area with decoration.

The arena plate contains environment only. Units, health bars, deployment regions, tactical UI, objectives and other run-specific state remain live Godot elements.

This decision changes presentation only. Encounter geometry or combat balance should be adjusted separately and only from local playtest evidence.


## D108 — Distinct arena geography and approved visual redraw v2

Date: 2026-10-11  
Status: accepted; supersedes D107's requirement that all arena IDs use the same v1 art directory

The user approved the reworked Arena Redraw v2 package 1 for ten combat arenas. The approved visual language keeps the dark detailed Misdeal Gothic mood and readable flat combat floor, but every arena must have **one clear landmark and believable geography**, not repeated AI-like castles or arbitrary towers covering the horizon. Atmosphere and encounter identity come from varied locations rather than endless decorative architecture.

Native `.webp` assets may be read through `FileAccess.get_file_as_bytes()` and decoded into `ImageTexture`; existing `.webp.b64` assets remain supported for older arenas. The ten approved v2 WebPs are the canonical battle backgrounds; `firing_square` and `bone_ritual` still use v1 until separately approved. All previous arena assets remain recoverable.

This is an art/asset-loading decision only. It does not authorize alterations to combat rules, spawns, deployment bounds, or tactics.


## D109 — Arena-floor geometry is authoritative; tactical guides are live

Date: 2026-10-11  
Status: accepted implementation correction after local screenshots

The v2 backdrops revealed a mismatch with earlier encounter-coordinate assumptions: heroes and enemies spawned over visually distant architecture rather than on the walkable floor. The battlefield is now constrained to an intentional floor band in UnitsLayer coordinates; legacy encounter Y positions are projected into that band on spawning, preserving horizontal tactical ordering.

Deployment-region `Rect2` values are the single source of truth for both hero drag legality and rendered on-floor marker circles/region outlines. The markers deliberately do not create fixed slots or change the combat game design, and they are hidden as combat begins. Avoid permanently painting supposedly legal placement cells into environment WebPs: they become incorrect whenever encounter-specific regions change.

Contact shadows belong to each live unit at its sprite's feet. Revisit the perspective profile only when concrete 1280×720 gameplay screenshots show misplaced figures; do not independently adjust background art, drag boundaries and unit visuals.


## D110 — Deployment zones must be quiet at rest

Date: 2026-10-11  
Status: accepted; refines D109's rendered guide requirement

The user rejected always-visible rectangles and decorative 3×2 circles over the arena floor. The playable battle screen should show the environment and units without a persistent tactical grid. Draw a restrained low-opacity glow from the **existing legal deployment regions only while a hero is being dragged**; hide the overlay immediately on release and when combat starts. The extra hero placement ring is likewise drag-only; a small contact shadow and team identity ring may remain.

This does not change legal drag geometry or add fixed gameplay slots. Do not bake tactical markers into arena WebP plates. Avoid an always-on debug-looking overlay in future art/arena passes.


## D111 — Combat miniature readability comes from local sprite presentation

Date: 2026-10-11  
Status: accepted prototype implementation after user screenshot review

Retain approved detailed Gothic arena backdrops. To prevent miniatures blending into complex stone and firelight, tune `BattleUnit` presentation first: a moderate 8–10% visual-size lift, restrained tinted silhouette contour, soft low-alpha local value separation, aligned contact shadow, and uncluttered initial hero formations inside real legal deployment regions. A boss retains separate sizing. Do not solve this by adding a large glow, redrawing the arena, enlarging collision radii, or placing persistent grid markers on the floor.

Initial hero arrangement is presentation-relevant but also affects tactics, so retain the encounter's deep-line / split-lane / two-pocket positioning contracts and locally test solo, duo and trio before further balance changes. Keep arena art, combat AI, enemy positions, stats and rewards independent of this pass.


## D112 — Approved v4 nine-role unit atlas is the combat art source

Date: 2026-10-11  
Status: accepted; supersedes the earlier v3 active-unit-art asset version

The user approved the new full nine-character Gothic/pixel-art character direction, with Variant A Knight, Ranger and Mage and the associated six undead figures. The live 3×3 `288×288` atlased WebP asset (96×96 per role) is stored as Base64 text for compatibility with the existing Godot text-based resource/export workflow.

`BattleUnit` should prefer v4, cache its texture across units and retain v3 as a tested code-level fallback; future art changes should preserve the tile order or intentionally update role indexes in tandem. No change to combat balance, hit radii, tactical systems or encounter composition is implied by the sprite replacement.

Because the new sheet comes from cut-outs of approved large concept images rather than original sprite-by-sprite painting, inspect 96px edges and silhouettes during local Godot validation, and perform targeted cleanup if defects appear.


## D112 — Runtime facing and role-specific approved artwork overrides

Date: 2026-10-12  
Status: accepted

All v4 combat sprites should face their opponent. The authored atlas nominally looks screen-right, so enemies appearing on the right start horizontally mirrored, and active combat art updates to the current target's horizontal direction. The `RimSprite` must match the `ArtSprite` mirror orientation. Do not change AI movement/targeting, physical body radii or tactical placement just to correct visual facing.

Approved character art can be refined role-by-role without regenerating or replacing the entire shared 3×3 atlas. The male Mage uses a separate 96×96 transparent WebP override with a fallback to its existing atlas cell; the other eight roles stay on the approved production v4 atlas. Preserve original and lossless source art for rollback, and keep Godot sprites nearest-filtered.


## D113 — One incremental UI Foundation, no redesign of approved game screens

Date: 2026-10-12  
Status: accepted for Design System 1.0 Package 1

The canonical runtime color/spacing/typographic foundation remains **`scripts/ui/misdeal_ui_kit.gd`** because the live card table and battle screen already depend on it. Extend this file with neutral semantic tokens and opt-in methods; do not introduce a parallel styling framework, new font dependency or global singleton merely to make a design-system abstraction.

Use a 1280×720 reference canvas, compact 4px-based spacing, readable Russian copy, subdued squared Gothic controls, and visually quiet battle overlays. Gold communicates hierarchy and choice; glowing embellishments do not substitute for legibility. Advisory UI layer bands must **not** override unit world-depth sorting or the active combat floor contract.

The accepted Variant C tabletop, Arena Redraw v2, Fate Spread and Unit Art v4 are **visual constraints, not targets for wholesale restyling**. Package 1 creates tokens, documented rules and an isolated live preview; Package 2 may unify component styles, and Package 3 may migrate production scenes only after visual inspection. Protect quick-to-play vertical-slice progress.


## D114 — Component helpers extend the existing UI kit; gameplay scene layouts remain authoritative

Date: 2026-10-12  
Status: accepted for Design System 1.0 Package 2

The existing `MisdealUIKit` is also the runtime source of reusable panel, battle, card, selectable-button and tooltip styles. The identical existing modular battle panel/button `StyleBoxFlat` values were migrated from `battle.gd` into the kit to remove duplication without redesigning approved HUD.

Component APIs are **opt-in**. An explicitly selected state changes appearance only, not gameplay `button_pressed` or tactical orders. A native hover tooltip uses a separate optional Button script instead of automatically replacing all old hints. Hand-painted card art is not embedded into `StyleBoxFlat`, and the preview scene never participates in the live run.

Do not introduce a separate framework or globally restyle the table and battle as part of component-library work. Package 3 may selectively migrate screens only after inspecting a real 1280×720 Godot preview; maintain the game's vertical-slice and tactile Gothic visual direction.


## D115 — Production screen migration preserves authored composition

Date: 2026-10-12  
Status: accepted for Design System 1.0 Package 3

A useful game-wide design system **does not require** replacing approved art or overwriting existing `.tscn` layout values. The first core Screen Pass applies reusable text contrast/shadows without automatically changing sizes, migrates tabletop card border states with exact existing colors, and makes the selected tactical order visible using the same battle style family. Splash/intro hotspots remain transparent interactive areas over painted illustrations.

Gameplay continues to determine class choice, tactical order, availability, Boss/Wizard mark/held-card semantics and outcomes. `MisdealUIKit` receives only semantic inputs, never `RunState` or the battle controller itself. The user's explicit request authorized code integration before the Package 2 F6 visual acceptance, **not** a sweeping visual redesign. Local Godot review remains the gate before further polish.


## D116 — Frame-authored unit animation with safe v4 fallback

Date: 2026-10-12  
Status: accepted for Unit Animation Pack 1

Use actual authored animation cells for visible `idle`, `walk`, `attack`, `hit` and `death` states rather than repeatedly scaling/stretching static character art. Keep the existing `BattleUnit` `Sprite2D` (and `RimSprite`) in gameplay because the current battle model, attack/hit tweens, team-facing and z-ordering depend on it; a cached `SpriteFrames` Resource can drive its displayed texture frame. Native `AnimatedSprite2D` can consume the same Resource for isolated preview/testing without changing live node paths.

Pack 1 only animates approved/generated Knight, Ranger, male Mage, Skeleton and Bone Archer sheets. Other visual roles and missing/corrupt atlas files preserve the static v4 fallback. The male Mage character attack sequence skips a projectile-only frame, with gameplay projectile FX separate. Do not silently delay/rebalance hit application or alter combat movement to match art; contact-frame timing may be a separately tested follow-up. No Godot runtime smoke has yet been reported.



## D117 — Ground Pack 1 pixel frames by the shared contact sole; preserve originals

Date: 2026-10-12  
Status: accepted after user gameplay screenshots

Generated 6×5 spritesheets may bleed disconnected limbs into adjacent frame rows; these **must be cleaned as artwork**, not disguised by shrinking all units or raising the entire arena. For Pack 1 each new asset is versioned `combat_units_anim_v2`, retains the authored posing, strips only detached upper-row fragments, and aligns the lowest solid nontransparent contact pixel of each frame to y=92 (out of 96).

The real combat shadow ring is at local y=36 in `BattleUnit._draw()`. Derive animated art origin from that floor height and the actual pixel-art scale, including visual_scale, so that the current animated sole meets its shadow. Preserve the older static v4 presentation baseline for any unsupported role or broken atlas. Attack tween return must use the same calculated rest position. A slower non-synchronized idle plus small walk-state hysteresis improves readability without gameplay changes.

Never rebalance speed, change collision/deployment bounds or repaint approved arena art to compensate for a flawed frame atlas. Keep the original v1 source assets for rollback and verify new animation poses on real Godot screenshots. The runtime still needs local smoke verification.


## D118 — Per-role optical floor contact offsets do not move logical units

Date: 2026-10-12  
Status: accepted from in-game screenshot feedback

Normalize animated source-frame foot contact in asset space first (D117), **then** allow a small role-specific visual-only signed Y offset in `BattleUnit` to align optical ground contact with the battle arena. Do not move the `BattleUnit` position, retune drag/placement bounds, AI speed, hitboxes, depth sorting or the background image to fake correct foot contact. Static v4 enemies also receive explicit role offsets when visually buried.

A single `_art_rest_position()` applies scale-aware animated positioning plus `ROLE_FLOOR_OFFSETS`, or base position plus role offset for static miniatures. All idle/attack/rest/death visual paths should rely on it consistently. The initial values are deliberately modest (-4 to -7px) and **require a Godot screenshot check**; subsequent corrections should be per role, not a game-wide visual overhaul.


## D119 — Prefer readable static Knight v4 until animation art has actual legs

Date: 2026-10-12  
Status: approved immediate visual hotfix

Following repeated gameplay screenshots, the Pack 1 animated Knight's leg/boot silhouette is intrinsically unreadable. Small optical offsets (up to -16px) cannot reveal geometry hidden by the shield/cloak or malformed spritesheet. Keep the existing **v4 static Knight** as the live combat visual until a redesigned animated Knight sheet preserves clearly separated shin armor/boots in every state and is verified in the real Godot battle UI.

`BattleUnit` opts the Knight out of the animated loader via `STATIC_COMBAT_ART_ROLES`; it retains existing v4 fallback, attack/hit/death feedback, team facing, scale/HP/name/collision and game balance. Use the **static Knight** floor correction -8px, not the old animated -16px value. Other four Unit Animation Pack 1 roles continue to use frame animations. Keep archived Knight animated source in GitHub and the F6 gallery for an eventual comparison. Do not alter tactical mechanics, the arena or approved tabletop art for this fix.


## D120 — Stage undead visual motion independently from unready authored animation art

Date: 2026-10-12  
Status: accepted for Unit Animation Pack 2 Stage A

Four remaining enemy roles (Bone Thrall, Grave Bellkeeper, Crypt Guard, Bone Warden) do not have suitable independently authored animation cells. The game should never turn static portraits, a screenshot-like illustration or 6×5 repeated crop into fake character animation, given the Knight leg/grounding regressions. Keep the approved static-v4 figure visible and add only restrained, very short, distinct **attack-contact FX** via a separate stateless `unit_attack_visuals.gd` helper until frame artwork actually exists.

Visual effect lifetime is <0.4s; effects self-delete. Spawn only when an existing real attack fires, while current immediate damage timing and FX remain intact. Actual Idle/Walk/Attack/Hit/Death frame animation is **Stage B**, gated on per-frame readable legs/weapons/ground contact and local Godot review. This is a visual quality policy, not a fundamental change to the battle system.


## D121 — Stage and visually validate new enemy animation sheets before live activation

Date: 2026-10-12  
Status: accepted as Pack 2 Stage B quality gate

The Pack 1 Knight regressions demonstrated that frame count and normalized bounding-box placement alone do not guarantee readable limbs/boots. New Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden animation assets must first be delivered as **real transparent 6×5 atlases with 96px distinct character poses**. Automated checks reject missing frames, opaque/background-filled sprites and fake identical walk/attack rows; they warn about unstable sole y and cell-edge bleed. They cannot *certify* two readable boots, weapon anatomy, death pose quality or stylistic fit; require real Godot visual comparison.

The candidate import tool, validator and F6 side-by-side review scene must remain **separate from production `BattleUnit`**. The four live enemy types continue using static v4 art and brief Stage A contact VFX until their staged frame artwork passes inspection and is explicitly approved. Do not use image-generation outputs of full arena scenes as character sprites or automate 25 cells by scaling/rotating one still.

## D122 — Approve blue Knight redraw before restoring live frame animation

Date: 2026-10-12  
Status: accepted

After the unreadable legs on Pack 1's original animated Knight, the user approved a new blue-armored pixel-art Knight with independently visible shin armor and boots. Preserve the original malformed v2 sheet for rollback and re-enable animation using the existing SpriteFrames infrastructure with static-v4 fallback. Do not replace silhouette problems with arbitrary Y-offset shifts. In-engine F6 and actual arena combat must verify boots/grounding and shield separation before the visual result is considered accepted. This replaces the *temporary* static-Knight requirement of D119 once the new atlas passes runtime QA; it does not change combat mechanics.

## D123 — Fate Spread Variant C defines Misdeal Design System 2.0 visual identity

Date: 2026-10-12  
Status: **user approved; binding visual-art direction**

The user declared the approved **«MISDEAL — РАСКЛАД СУДЬБЫ»** tabletop their favorite art and explicitly asked that future UI/design be based on its palette and graphics. Adopt the original Fate Spread Variant C as the canonical style reference: obsidian/blackened timber, occult blood-red engraving, aged brass/bronze, warm card parchment, cool nocturnal highlights, practical candlelight and tactile physical tarot cards. The original composition, illustrations, XIII central boss, I–XII order, held/discard/deck places, colors and art are **frozen**, not targets of redesign. Style evolution must respect readable Cyrillic and usable controls.

Design System 2.0 starts with documentation and **opt-in** `MisdealUIKit` material tokens; existing 1.0 tokens and production styles must not change automatically. Preview one isolated component/screen, ask user to approve its screenshot, then migrate individual interfaces. Battle arenas and miniature art retain their own scene logic. No full-scene re-rendering or wholesale design replacement without explicit permission.

## D124 — Approve live Reward major-upgrade presentation as DS2 reference

Date: 2026-10-12
Status: **user-approved visual baseline; freeze without explicit request**

The user supplied a real Godot 4.7.x screenshot at 1280×720 of the **production** Reward screen, mode **«РАЗВИТИЕ ОТРЯДА»** for a **two-hero party**, showing three dynamic upgrade cards: **«ЖЕЛЕЗНАЯ КЛЯТВА»**, **«ГРАД СТРЕЛ»**, **«ПАЛАЧ»**. User responded **«Все отлично! Фиксируй»**. Accept and preserve the existing dark blackwood / antique bronze / warm parchment palette, Variant C tabletop background, header, three card positions, illustrations, compact stat-effect rows, text wrapping and footer hierarchy. This approved real-game screenshot supersedes earlier preview-only approval for the major-upgrade state. **No redesign, recolor, size changes or card layout overhaul without discussion.**

This is visual approval of the shown live **major_upgrade** state; it does **not** by itself certify gameplay award/return navigation or the distinct **normal_loot, bonus_upgrade, death_wager, elite_artifact** layouts. Continue testing those modes and resolve concrete bugs without undoing the approved visual language. Main implementation is `scripts/reward/reward.gd`, `scenes/reward/reward.tscn`; canonical style contract is D123 and `docs/DESIGN_SYSTEM.md`.

## D125 — Approve DS2 Whispering Well visual treatment and scoped live migration

Date: 2026-10-12
Status: **preview approved by user; live engine acceptance pending**

The user approved the isolated `design_system_v2_event_preview.tscn` featuring Whispering Well's three physically framed event-choice cards, then explicitly requested live implementation. Follow the canonical Fate Spread Variant C material language (D123) and the approved Reward DS2 treatment (D124) for this particular event. Keep blood / coin / departure as real choices, including disabled warnings and exact consequences, and render both recruitment and later revisit options using **actual dynamic** descriptions. The original Fate Spread remains unchanged. Live `whispering_well.gd` and `whispering_well.tscn` were migrated; no new mechanics. **User approval of the preview is not proof that the live event has passed a Godot run.** Do not mark runtime acceptance or apply the style to other events automatically.

## D126 — Approve final live Whispering Well DS2 visual layout

Date: 2026-10-12
Status: **user accepted after local Godot check, no new screenshot required**

Following the concrete `HBoxContainer` row-centering fix in commit `1adc634` (928px-wide centered 3-card row and complete two-line rescue copy), the user explicitly stated **«без скрина все хорошо»** and asked what comes next. Treat this as acceptance of the **production Whispering Well visual layout** under Design System 2.0, not an invitation for another speculative pixel polish pass. Preserve the original approved Fate Spread colors, bronze/parchment cards, event illustrations, header/footer centerline, Russian copy readability and warning positions unless the user reports a specific defect.

This visual sign-off does NOT independently certify every live gameplay branch (blood scar, coin purchase, abandoning Mage, later return/upgrades/artifacts), or other events. Future work should focus on a scoped new DS2 UI preview for **Gravedigger Shop** (the `gravedigger_shop` case in shared `scripts/event/act_choice.gd`) and must not restyle unrelated event cases in bulk.

## D127 — Accept Gravedigger Shop DS2 preview and approve shop-only live migration

Date: 2026-10-12  
Status: **isolated visual preview user-approved; production integration committed, engine QA pending**

After the corrected isolated `design_system_v2_shop_preview.tscn` was checked in Godot, the user stated «все ок. внедряй». Accept the preview's physical bronze/parchment role-card visuals as the baseline for the **Gravedigger Shop**. The preview's fixed 25 gold was illustrative; it must not replace real `RunState.get_gravedigger_shop_price()` or Lost Purse history effects. Actual purchases, party restrictions, upgrades, gold deduction and routing must continue using existing handlers. The production presentation is scoped **exclusively** to `gravedigger_shop` in the shared `ActChoice` screen, not applied to unrelated events. User approval of F6 does not equal approval of the production gameplay until local Godot smoke. Preserve D123 Fate Spread, D124 Reward and D126 live Whispering Well.

## D128 — Bulk DS2 adoption approved, without replacing gameplay or frozen art

Date: 2026-10-12  
Status: **user authorized bulk migration; committed, runtime QA pending**

User requested implementing remaining Design System 2.0 UI as one large batch instead of isolated previews for each screen. Allow consistent opt-in aged-bronze, blackwood and parchment chrome for remaining shared event choices, Class Select, Squad Status, Run End, Battle HUD and table HUD/Wizard Wager without changing their underlying mechanics or approved full-screen art. The existing original Fate Spread Variant C (D123), Reward major-upgrade (D124), Whispering Well (D126), and approved shop visual (D127) remain protected. Startup splash and illustrated intro are not targets for replacement.

Each shared ActChoice event must keep its original button, disabled state, dynamic text/role eligibility and handler; no data/rules rewrites. Batch approval is permission to integrate, **not proof of visual acceptance in Godot**. Fix actual observed screenshot issues in the new scope-specific presenters after one consolidated local test.

## D129 — Accept the full Design System 2.0 bulk presentation

Date: 2026-10-13  
Status: **user-approved after local review**

After the large DS2 visual integration authorized by D128, the user confirmed «все хорошо» following their local Godot review. This is acceptance of the **visible, current** presentation of shared event choices, Class Select, Squad Dossier, Run End, Battle HUD and table HUD/Wizard Wager; avoid speculative repeat revisions. Original Fate Spread Variant C (D123), accepted Reward major-upgrade (D124), Whispering Well (D126) and Gravedigger Shop (D127) continue to be protected. Main/intro authored artwork is unchanged.

This approval concerns the presented UI and does not imply every conditional shop/event/reward state or combat branch was exhaustively functionally tested. A concrete future regression may still warrant a focused fix. Prioritize new Act 1 content and gameplay/replayability rather than reopening the completed DS2 rollout.

## D130 — Final Misdeal card-art concept board approved

Date: 2026-10-13  
Status: **approved concept; production assets not yet integrated**

The user approved the *latest*, iteratively corrected Misdeal concept sheet («отлично утверждаем последний визуал»), generation `6c7d5d41-24a1-47f9-8f54-e689bbe265a5`, chat image `мрачный_концепт_арт_misdeal_награда_с_рубином.png`. The accepted sheet depicts 13 examples: 4 table/deal cards (`bone_patrol`, `graveyard_ambush`, `gallows_volley`, `whispering_well`), 4 event illustrations (`curse_forge`, `black_altar`, `chained_prisoner`, `rattling_bridge`), 3 upgrades (`knight_iron_oath`, `ranger_arrowstorm`, `mage_glass_heart`), 2 rewards (`gold_windfall`, `relic_wager`). **Binding visual corrections:** `gallows_volley` has few medieval bowmen using bows and arrows, no firearms or crowd; `mage_glass_heart` shows an adult male wizard with a gray/white beard; `relic_wager` shows a skeletal hand *holding* a red faceted gemstone. All remaining illustrated compositions in that sheet are accepted without further changes. Keep original DS2 layout and D123-D129 protected art.

This is approval of the **concept board**, not evidence that standalone full-resolution textures exist, are committed to GitHub, or are displayed in Godot. The reference is a chat attachment and is **not yet persisted as an image blob in the repo**; `docs/CARD_ART_UNIFICATION_WAVE1.md` records the identifiers and precise art mapping. Existing game atlases/assets remain active until independently authored assets are checked against the reference and safely wired. Five of the original 18 first-wave candidates were not pictured and need later matching art/review. Do not re-open the approved art direction without a concrete issue or user request.

## D131 — Approve the four redesigned high-resolution Act 1 deal-card illustrations

Date: 2026-10-13  
Status: **approved and four runtime WebP binaries committed to main; in-engine validation pending**

The user examined two successive sets of newly generated standalone dark-fantasy images in response to excessive AI-looking replicated units in the old drafts, then stated «Отлично. Эти утверждаем». This approval refers **specifically to the FOUR MOST RECENT illustrations**, not an earlier alternative sheet:

| Live RunCard ID | Approved latest artwork and generation ID |
|---|---|
| `bone_patrol` | `марш_скелетов_под_полной_луной.png`; `8a477bfd-e779-468a-996c-19537c19c527` — four visibly different combat-role skeletons, central shield-bearer, distinct archer/mage/spearman, moonlit cemetery |
| `graveyard_ambush` | `лунная_засада_на_кладбище.png`; `63ff9a81-cec8-4e97-a1b0-f12748f95f28` — one dominant hooded dagger-wielding ambusher emerging from gravestones, sparse subordinate silhouettes, no cloned ranks |
| `gallows_volley` | `лучники_у_виселицы_на_закате.png`; `013c0ce3-983c-4480-86bc-15d7a751edd6` — three clearly distinct medieval archers wielding **bows and arrows only**, gallows at red dusk, no guns, no cloned crowds |
| `whispering_well` | `призрачный_колодец_в_лунном_кладбище.png`; `a13b068f-6bda-42da-b00d-e9fa4e10052d` — three distinct spectral entities rising from an ancient stone well, restrained blue moonlight and cemetery |

These four individual latest illustrations **supersede only the four corresponding small crops** from the previously accepted D130 concept board / 13-crop ZIP, because the user specifically rejected blur, cloned units and AI-looking duplication and approved the resulting unique compositions. The other nine D130 pictured compositions (four event, three hero upgrade, two reward) retain their existing acceptance, including the **gray-bearded male Mage** and **skeletal hand holding a crimson faceted gem**. D123-D129 UI remains protected; the approved Whispering Well *screen* is not to be replaced, only its `whispering_well` card illustration.

**Delivery state (updated 2026-10-13):** Four 448×274 WebP runtime textures exported directly from the latest approved 1604×981 PNGs and **committed as binary files to GitHub `main`** in commit `9d864113d66236111b8a3f048afaac35416cedf1` under `assets/pixel/card_unification_v1/run/{bone_patrol,graveyard_ambush,gallows_volley,whispering_well}.webp`. Existing conditional resolver in `scripts/ui/card_unification_v1.gd` makes these the first-choice live RunCard artwork with the old atlas as fallback. Each binary blob SHA was verified on the updated `main`. The earlier chat ZIP of blurry D130 crops is obsolete for these four. **Godot runtime/visual QA remains pending**; do not state this has been engine-tested. Preserve these exact approved subjects/characters and avoid regenerating them without a concrete request.

## D132 — Approve and deploy four clean high-resolution event backgrounds

Date: 2026-10-13  
Status: **latest standalone event illustrations user-approved and committed to main; Godot in-engine QA pending**

User approved the latest four *individual* illustrations for `curse_forge`, `black_altar`, `chained_prisoner`, and `rattling_bridge` («Отлично, давай заливать»). They replace only the four corresponding small-background extractions from the D130 concept board; preserve the other D130 compositions and the four D131 run-card images.

| Event ID | Exact approved PNG / generation | Visual scene |
|---|---|---|
| `curse_forge` | `кузнец_в_руинах_пламя_и_сталь.png`, `4127d0b4-9f70-41e5-ba45-faf61cdd19e9` | solitary muscular blacksmith forging red-hot blade at anvil, orange forge fire, dark ruined stone |
| `black_altar` | `мрачный_ритуал_в_готической_крипте.png`, `f5fb4aee-f2d8-48da-b537-336254f3df20` | single hooded occult celebrant behind black stone altar, restrained red sigil and candles |
| `chained_prisoner` | `узник_в_цепях_под_лунным_светом.png`, `a9a4da3c-df13-4439-892e-e3957c4526fc` | one chained kneeling adult prisoner in damp blue-gray stone cell |
| `rattling_bridge` | `путь_через_лунную_бездну.png`, `5a477944-07f6-452f-b317-0fcb61c93090` | solitary hooded traveler with lantern crossing fragile rope bridge over moonlit chasm |

All source PNGs were **1672×941** (nearly exact 16:9) and exported directly to **1280×720 WebP quality 91** with no source-board crop enlargement. Exact binary paths: `assets/pixel/card_unification_v1/event/{curse_forge,black_altar,chained_prisoner,rattling_bridge}.webp`. These four raw binaries were committed to GitHub `main` in `1722d070cfe5a5690596953a1465b198177a57b3`; each blob and the four-file-only commit diff were independently verified. The previously prepared `scripts/ui/card_unification_v1.gd` resolver and `scripts/event/act_choice.gd` hook now automatically select these images when the appropriate event is opened, falling back to the existing legacy background if invalid or missing. No UI, RunState, purchase, event handler, Fate Spread or other game functionality was modified in this art commit.

**Acceptance boundary:** art as drawn is approved, GitHub integration is verified statically, but Godot live display and correct visual overlays have not been tested by the assistant. Have the user `git pull`, visit four real events in Godot 4.7.x at 1280×720 and inspect art visibility/contrast/size behind DS2 UI. Earlier chat ZIP `misdeal_card_art_wave1_import.zip` contains obsolete low-resolution versions of these four and should NOT be unpacked over tracked binaries. D123-D129 frozen interfaces and D131 table art stay accepted. Five still-unshipped D130 hero-upgrade/reward concepts remain next.

## D133 — D132 event art display accepted after scoped card mapping/tint fix

Date: 2026-10-13  
Status: **user locally accepted rendered four-event art integration**

After D132 four approved event backgrounds were committed, the user reported the art did not appear in the game. The source fix made the same four event scenes visible both on live deal-card thumbnails and within `ActChoice` backgrounds (event-card crop in `card_unification_v1.gd`, reduced DS2 background shade only for those four scenes), without changing accepted card geometry or any gameplay. The user then replied **«все ок. погнали дальше»**. Treat this as local acceptance of the reported display issue's resolution; no need to re-open these four screens/RunCard illustrations without a new concrete defect. Other D123–D132 art/design decisions remain binding.

Next production target: the **five remaining approved D130 upgrade/reward concepts** (three hero upgrades + two reward art). Exact standalone prompts/paths and current image-generation limitation are in `docs/CARD_ART_WAVE1_FINAL5_BRIEF.md`. An attempted image-generation step erroneously repeated the previous 4 event scenes twice; those duplicate collages are **rejected**, not approved, and no new image binaries were shipped. This decision does not approve unseen new five images.

## D134 — Approve and ship final five Wave 1 upgrade/reward illustrations

Date: 2026-10-13  
Status: **five user-approved illustrated textures uploaded as WebP binaries to GitHub main; in-engine visual QA pending**

After viewing the latest five individual Misdeal paintings the user explicitly requested: «да, давай внедрим их. Заливай сразу в гит», then reiterated that the assistant has direct GitHub access. These **five last generated illustrations** are authoritative (not previous lower-resolution D130 contact sheet crops or the prior individually generated Knight). Their ids and original chat image filenames/generation IDs:

| Art key | Original user-accepted image and generation | Runtime file |
|---|---|---|
| `knight_iron_oath` | `рыцарь_в_лунных_руинах_собора.png` — `99064d63-d2ca-4e91-8f30-509afa693455` | `assets/pixel/card_unification_v1/upgrade/knight_iron_oath.webp` |
| `ranger_arrowstorm` | `лунный_залп_над_руинами.png` — `568fcdba-01b3-44f2-8333-2504f97adaa9` | `assets/pixel/card_unification_v1/upgrade/ranger_arrowstorm.webp` |
| `mage_glass_heart` | `осколочное_сердце_древнего_мага.png` — `b0c9d788-0066-4f7e-bd33-6631c7dfe5f2` | `assets/pixel/card_unification_v1/upgrade/mage_glass_heart.webp` |
| `gold_windfall` | `сундук_сокровищ_в_лунных_руинах.png` — `503c0d93-b07f-495c-9fdf-68250a88c46c` | `assets/pixel/card_unification_v1/reward/gold_windfall.webp` |
| `relic_wager` | `скелетная_рука_с_кровавым_кристаллом.png` — `1951ab80-d0fd-4a09-9f11-f6ef067df57d` | `assets/pixel/card_unification_v1/reward/relic_wager.webp` |

All five original PNGs were 1570×1002, nearly exactly the production 608×388 aspect, allowing high-quality direct Lanczos downsampling without cropping, quality 90 WebP. **Actual files are now in main**, commit `e3729a4a86a9cce006ec8803fa6e7e0aa1f00de5`; checked all five remote GitHub blob SHAs, valid WebP headers and a diff comprising exactly these five files. Existing `scripts/ui/card_unification_v1.gd` `UPGRADES`/`REWARDS` maps and `scripts/ui/card_art_catalog.gd` preferentially load new art, preserving old atlas fallbacks. No production code, mechanics, layout, Fate Spread, Well, shop or combat screens changed in that commit.

**Binding art details** remain: Knight in worn black armor kneeling over upright sword; one hooded bow ranger and coherent arrows; **older male Mage with long gray beard** and luminous blue crystal heart; old chest of antique gold; **skeletal hand grasping a faceted red ruby**. Don't substitute other interpretations or the obsolete D130 low-resolution crops. The original D130 pictured 13/13 illustrations now have true binary files committed (D131 four run cards, D132 four event backgrounds, D134 five upgrade/reward images). The additional five candidate items from the earlier 18-art inventory remain separate, unapproved and unimplemented.

**QA boundary:** upload and lookup verified in repo; the assistant has not executed Godot. User should `git pull`, inspect `res://scenes/dev/card_unification_v1_preview.tscn` via F6, then check hero upgrades and reward cards in the real UI at 1280×720. If older ZIP extractions have left the five exact `upgrade/` or `reward/` paths as untracked files, Git may require moving only those old files aside before pulling. No additional ZIP is required.

## D135 — Approve and ship the final five first-wave card illustrations (18/18 assets)

Date: 2026-10-13  
Status: **visually approved; binary files and optional runtime lookup committed to `main`; local Godot QA pending**

The user reviewed five new, *separate* Misdeal paintings and explicitly approved them («Утверждаю. Давай заливай сразу в гит»). These five are the previously unpictured additions to the D130 13-item collection, completing the **18-image first-wave inventory** without changing the thirteen earlier approved arts. The assistant has real GitHub connector access and **used it**; a previous claim of no GitHub access is obsolete.

| Runtime ID | Approved source image / gen ID | New game art |
|---|---|---|
| `gravedigger_shop` | `торговец_склепа_при_лунном_свете.png`, `2675f7e5-f080-4369-b705-9b102a70809e` | `assets/pixel/card_unification_v1/run/gravedigger_shop.webp`, 448×274 |
| `bone_swarm` | `костяной_колосс_на_кладбище.png`, `69e31ef8-f24e-4761-a32a-1fab26f47385` | `assets/pixel/card_unification_v1/run/bone_swarm.webp`, 448×274 |
| `grave_crossfire` | `мрачная_дуэль_лучников_на_кладбище.png`, `470fddf6-444d-4059-85da-81cf71f4f00c` | `assets/pixel/card_unification_v1/run/grave_crossfire.webp`, 448×274 |
| `candle_seller` | `старьевщик_свечей_среди_руин.png`, `e7f6d158-a061-4936-866e-74f42bb06cf5` | `assets/pixel/card_unification_v1/event/candle_seller.webp`, 1280×720 |
| `last_camp` | `одинокий_костёр_среди_лунных_руин.png`, `1c18a737-3358-4ad0-994a-1a138376afe8` | `assets/pixel/card_unification_v1/event/last_camp.webp`, 1280×720 |

**Actual assets shipped**, GitHub `main` commit `ac860ad2cacf17e7ab4e64c54f2ddfb70debd146`. All five independently fetched and verified as remote Git blob SHAs and WebP magic; local originals were resized to the dimensions shown (no old collage crops). `scripts/ui/card_unification_v1.gd` adds these three `RUN_CARDS` and two `EVENTS` keys, making `CardArtCatalog.get_run_card_texture` and the existing `ActChoice` event background loader use them automatically. `candle_seller` and `last_camp` also display on their deal cards through the pre-existing event-to-card fallback crop. All original fallback atlases and old event backgrounds remain available if missing/invalid images are encountered. New no-gameplay F6 gallery: `scenes/dev/card_unification_final5_preview.tscn`.

**Shop must remain untouched:** `gravedigger_shop` new art affects ONLY the run/deal card illustration; its independently approved DS2 live shop layout/price/transactions and `gravedigger_shop` live event backdrop stay exactly as before. No RunState, combat logic, purchase handlers, reward logic or D123–D134 approved layout/paintings were edited.

**Test boundary:** Source paths, binary validity and lookup hooks verified in GitHub; the assistant did NOT run Godot. The user should `git pull`, F6 `scenes/dev/card_unification_final5_preview.tscn` at 1280×720, then check three offered cards and both in-game event backgrounds plus active choices/return navigation. Previous manually extracted `misdeal_remaining5_assets.zip` copies might make Git report untracked-file overwrites; move only those five locally before `git pull` if needed. The 18/18 statement means **binary assets committed and mapped**, not runtime visual QA certified.

## D136 — Act 1 Gameplay 2.0: varied deal pairs, contextual Wizard tells and staged Mark payouts

Date: 2026-10-13  
Status: **implemented in GitHub `main` (source audit), local Godot F6 / real-run QA pending**

The user explicitly approved proceeding with Act 1 Gameplay 2.0 after confirming the first wave of visual work was OK. Implemented as a **small, scoped replayability pass** rather than rewriting core rules.

**Deal variety:** `scripts/core/run_state.gd` now ranks candidates *only inside the exact existing allowed pool*. Two-card offers prefer a combat + non-combat pair on unconstrained slots and soft-penalize resolution type / event type labels from the last two completed cards; tie breaks still shuffle between runs. A due Fate Hold remains the first offered card. Mandatory combat slots in all three four-card tiers, 12 regular cards + boss XIII, spent/discard/remaining pools, existing no-replacement resolution history, Wizard Meddling same-tier/same-resolution replacement and retry behavior are **not changed**. Two combat cards are still legitimately offered in forced combat windows or if the available pool has only combat choices. No new encounter/arena enemy data is invented; authored `bone_swarm`, `grave_crossfire`, `iron_wall`, `last_bell`, `firing_square`, `bone_ritual`, etc. continue to supply existing tactical fight variety.

**Mark risk/reward:** earlier Wizard Mark remains +20 gold for the same +15% enemy damage on the next battle. Mid-tier Mark now pays +30, late-tier +40, calculated from current `cards_resolved / 4` and exposed by `RunState.get_wizard_mark_gold_reward()`. `scripts/table/table.gd` shows the exact amount and +15% condition on the marked card and tooltip; selection confirmation and Wizard memory also state the actual payout. The Wizard's standard Wager still separately offers its existing doubled reward, +25% enemy damage / Sacrifice order; unchanged. Neither the enemy party-size scaling nor solo/duo/trio hero bonuses are modified.

**Wizard voice:** `RunState.get_wizard_deal_line()` supplies optional comments following repeated fights vs repeated non-combat events, active Mark danger, and later-game solo / trio party composition. `table.gd` only uses that contextual line when not in debt, not on the boss and not inside an active card; existing queued Wizard memory, meddling, wager overlays and authored card hover comments take precedence. No new UI frames/assets, new combat mechanics, hidden encounter penalties or foundational changes.

**QA aid:** `res://scenes/dev/act1_gameplay_v2_smoke.tscn` can be run with F6. Its source executes 48 deterministic simulated full 12-card runs across solo/duo/trio states, checks correct tiers, unique offers/chosen IDs, three forced combat windows per run, boss XIII availability, stable per-party enemy pressure and Mark payout 20/30/40. It does NOT run actual combat or event actions and has **not been executed by the assistant** (Godot 4.7.x unavailable in this environment). Player should `git pull`, F6 scene at 1280×720, then complete one real Act 1 run paying particular attention to both proposed card types, Wizard meddling/held cards, Mark tooltip/payment, wagers, late boss access and reward navigation. Do not claim gameplay acceptance until local test feedback.

Freeze D123–D135 previously approved DS2 graphics, Fate Spread Variant C, Shop, Well, splash/intro and all 18 first-wave illustrations. Changes limited to `scripts/core/run_state.gd`, `scripts/table/table.gd`, and new dev-only smoke files (apart from documentation).


## D137 — Tactical variety is authored inside each card, not random enemy roster swapping

Date: 2026-10-13
Status: accepted by user; first three encounters implemented on GitHub main, local D137 Godot QA pending

The player explicitly preferred a narrower second gameplay package: (1) distinct combat situations where formation matters, (2) meaningful orders and differences between Knight/Ranger/Mage, and (3) viable solo/duo/trio. The user also explicitly objected to random enemy combinations that do not match card text/art. **Binding design rule:** a dealt combat card promises its original named encounter, enemy identities and tactical threat. Do not silently replace rosters or reward outcomes when seeking replayability. Significantly new compositions require an independently authored card, art and description, not random substitution under an existing card.

First scope is the three **existing** cards `bone_swarm`, `iron_wall`, `grave_bell`. `EncounterData` exposes an **optional** second `PackedVector2Array` of enemy positions plus two short formation tells; invalid-size alternates fall back to the original position array. Both layouts use the same `enemy_unit_paths` and `enemy_names`, no additional enemies/AI abilities, and the same authored arena. `Battle` selects one formation and uses the established placement hint and target-preview controls. `RunState` memoizes the variant by encounter/card ID for the current run, so a defeat, Last Deal or retry does not change that already-chosen fight. `reset_run()` clears this memory; no persistence system added.

The three base orders stay `ASSAULT` (nearest target / +15% movement), `HUNT` (ranged/support first), `FORMATION` (threat near the vulnerable ally). Existing support healing, attack ranges, armor and AoE are reused. The one narrow balance correction is that **solo FORMATION additionally gives -10% incoming damage**: without another ally its current target priority equals nearest, so it had been a strictly weaker ASSAULT. This compensates through defensive vs movement tradeoff without changing solo/duo/trio base health/damage scaling or inventing a fourth basic order; labels and tooltip disclose it. Duo/trio FORMATION still uses original targeting.

Local QA boundary: the preceding D136 48 simulated deals F6 test was explicitly reported **PASS** by user on 2026-10-13, but the new D137 smoke `res://scenes/dev/tactical_gameplay_v21_smoke.tscn` is only source-committed. It validates 54 setup combinations (3 encounters × 2 formations × 3 protagonist roles × 3 party sizes), normal order preview targets and authored rosters. It does **not** execute complete real-time combat or establish win rates. Retain all original visual assets/DS2/Fate Spread and 12 regular cards + Bone Warden XIII. After local smoke, require actual solo/duo/trio combat observation before any broader balance tuning.

## D138 — Gameplay 2.2: authored late-Act tactical layouts and real-BattleUnit baseline outcomes

Date: 2026-10-13
Status: **user approved; committed to GitHub main; local Godot F6 benchmark pending**

User explicitly said «утверждаем» to the Gameplay 2.2 package: deepen existing **card-faithful** encounters and measure combat rather than guessing balance. The design contract from D137 remains absolute: enemy rosters, identities, titles and visual card promises must NOT change between positional variants. An entirely new composition must receive a separate card/art/description after approval, not silently appear under an existing card.

First D138 content: `gallows_volley`, `ossuary_gate`, `last_bell` and `firing_square` gain one alternate enemy-coordinate list plus two formation hints in their existing `.tres` resources. These are positional arrangements **within the same authored enemy set**, never random type substitutions or additional enemies. D137's existing optional alternate-position system and RunState caching of chosen formation by encounter per run (retry-safe) are reused unchanged. Thus **7 existing cards total** support exactly two formations after D138 (D137 earlier: `bone_swarm`, `iron_wall`, `grave_bell`). No new cards, unit behavior, balance stats, hero roles, tactic buttons, rewards, UI redesign, DS2 or art.

Testing decision: D137's 54-setup PASS confirms *preparation and first-target selection only*. D138 adds separate dev-only `res://scenes/dev/tactical_gameplay_v22_battle_benchmark.tscn` which instantiates real `BattleUnit` nodes and manually advances their production `_process` logic in an isolated hidden arena with fixed `1/30`-second ticks, collecting outcomes for **72 scenarios** (4 cards × 2 positions × 3 party sizes × 3 base tactics). Order comparisons hold the protagonist, team roster, layout and RNG seed fixed; test applies existing solo/duo/trio hero/enemy baselines including solo FORMATION -10% incoming damage. It records win/loss/timeout, simulated seconds, and living heroes/enemies in `user://misdeal_tactical_v22_battles.csv`, flags invalid formation/roster/pressure and unresolved 75-s fights. This is a *controlled baseline benchmark*, not a proof that each solo party is balanced or a complete production battle/reward/act-run simulation. Excludes artifacts/upgrades, Wizard risk, battle intro/cinematic/menus, reinforcement bosses and UI. Any balance changes must follow review of actual engine results and hands-on observations; no arbitrary global buffs from synthetic PASS statistics.

Assistant has no Godot 4.7 executable. **Next mandatory gate:** user `git pull`, run new F6 scene, report PASS/FAIL; if FAIL share Output and CSV for direct GitHub correction. After baseline, play the four cards in normal Act 1; verify real placement, target previews, tactics, rewards and return to table. D136 deal F6 and D137 target-selection F6 already user-confirmed PASS, but the new D138 benchmark remains pending.

## D139 — Hunt interception and stage-aware full autobattle benchmark

Date: 2026-10-13
Status: **explicitly approved by user («утверждаю»); source committed; Godot F6 result pending**

After reviewing the actual D138 72-fight CSV (`docs/TACTICAL_GAMEPLAY_V22_BALANCE_REVIEW.md`), user approved the narrow balance investigation and implementation: make `HUNT` less prone to pursuing distant support while nearby frontline enemies attack, and add late-game tests using actual hero upgrades and artifacts **before** considering changes to enemy stats. Do not use this approval to alter card enemy rosters, art, encounter level/rewards or global solo/duo/trio scalers.

**Production tweak:** `scripts/battle/unit.gd` now defines `HUNT_MELEE_THREAT_RADIUS=165.0` and `HUNT_MELEE_RANGE_CUTOFF=100.0`. A player melee hunter (`attack_range < 100`) still prioritizes support (healers then ranged) when distant; **only when a different closest enemy is within 165 Godot units and the priority support remains farther than 165** does the hero temporarily engage the nearby threat. At reachable support distance, normal `HUNT` rank again wins. Refresh logic uses existing real-time HUNT retargeting, and `get_preview_target()` shares this behavior. Ranged heroes (Ranger and Mage) are unchanged. No separate attack/AI skill, damage bonus, extra button or new enemy composition. This is a purposeful tactical tradeoff, not a claim that `HUNT` will be superior in every matchup.

**New isolated F6:** `res://scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn` with `scripts/dev/tactical_gameplay_v23_balance_benchmark.gd`, derived from the Godot-successful v2.2 full-BattleUnit simulator. Preflight uses actual `BattleUnit.get_preview_target()` for the Knight with distant support, immediate frontline and then reachable support. Outcome matrix **180 controlled autobattles**: tier-1 `gallows_volley` and `last_bell`: 36 original bare matches; tier-2 `ossuary_gate` and `firing_square`: 2 seeds × 2 layouts × 3 party sizes × 3 orders × **bare and equipped profiles** = 144 matches. Same matching seed, protagonist, roster and layout are reused across three orders and equipment profiles. New profile `tier2_built` is an **illustrative** advanced party, not guaranteed in a real run: exactly one **actual authored** upgrade per available hero (Knight `knight_iron_oath`, Ranger `ranger_longshot`, Mage `mage_wildfire`) and one actual class-linked artifact on the chosen protagonist (Knight `dead_mans_shield`, Ranger `blind_quiver`, Mage `cracked_focus`). The benchmark obtains these using `RunState.add_hero_upgrade` and `RunState.add_artifact` and applies the same bonus field sequence as production `Battle._spawn_unit`, then original party-size multipliers and special solo FORMATION mitigation. Two seed replicates for tier 2 only. Writes `user://misdeal_tactical_v23_balance.csv` with `encounter,variant,party_size,protagonist,order,profile,sample,outcome,seconds,hero_survivors,enemy_survivors`.

**Interpretation:** `PASS` means preflight targeting matched and all 180 core BattleUnit fights completed without the 75-second timeout and exported results. `PASS` does NOT establish fair win rates; benchmark still excludes real Act 1 progression timing, Wizard risks, enemy scaling from stakes, full Battle scene HUD/transitions, reward return or boss XIII. Use the new CSV alongside the previously reviewed v22 bare CSV to assess HUNT change and whether intended tier-2 upgrades improve viability, then test actual play. Only with this evidence should any further card-local enemy balance be proposed.

**Next player action:** `git pull`; F6 `res://scenes/dev/tactical_gameplay_v23_balance_benchmark.tscn`; send PASS/FAIL screenshot and `misdeal_tactical_v23_balance.csv` from Godot Project > Open User Data Folder. Assistant cannot run Godot 4.7.x in this session; source and static validations are not a runtime PASS.

## D140 — Gameplay 2.4: coordinated HUNT focus + matched-protagonist solo/duo/trio test

Date: 2026-10-13
Status: **user approved («давай»); source committed in GitHub main; local Godot QA not yet run**

Previous D139 F6 180/180 PASS and real CSV analysis (`docs/TACTICAL_GAMEPLAY_V23_BALANCE_REVIEW.md`) showed HUNT improved in strict matched baseline from 5/24 to 8/24, but `last_bell` remained HUNT 1/6 while ASSAULT/FORMATION 6/6. Later equipped solo was 22/24 versus duo/trio 10/24, but that v2.3 benchmark *rotated the protagonist with party size*, so the result was confounded. The user approved a narrow follow-up: improve HUNT coordination against two bellkeepers and compare precisely controlled protagonist + companion rosters across party sizes. No blanket stat/balance tweaks or card composition changes authorized.

**Production HUNT rule:** only in `scripts/battle/unit.gd` `_find_hunt_enemy()`, select a shared HUNT priority target among enemy healers first and then ranged enemies; if none remain, each hero still picks its own nearest frontline target. Hunters use the center of all alive friendly combat units (same reference for the party) to break ties and prioritize the lowest HP **fraction** within the healer/ranged category. This encourages allied HUNT heroes to attack a single wounded bellkeeper rather than split damage between two healthy healers. When no support or ranged enemy remains, preserve the old nearest-enemy fallback per hero. At equal health, both use shared party-center distance for stable first targeting. **Keep previous D139 melee safety rule unchanged**: a melee hunter still intercepts the nearest immediate frontline enemy within 165 units while shared support is beyond 165. Ranged heroes still favor support. No new buttons, targeting stats, enemy units, encounters or art.

**New isolated F6:** `res://scenes/dev/tactical_gameplay_v24_focus_party_benchmark.tscn`, script `scripts/dev/tactical_gameplay_v24_focus_party_benchmark.gd` (adapted from Godot-vetted v23 BattleUnit benchmark). Begins with a 3-hero unit fixture against two bellkeepers, tests same first target with full HP, same wounded healer for all, melee Knight frontline interception and Ranger/Mage retaining wounded healer, and restored Knight focus when healer moves within danger radius. Then simulates **270 core-BattleUnit fights**:
- `last_bell` authored tier1: 2 formations × 3 protagonists × 3 party sizes × 3 orders = **54 bare** fights, one fixed seed per card/layout/protagonist.
- `ossuary_gate` and `firing_square` tier2: 2 cards × 2 formations × 3 protagonists × 3 party sizes × 3 orders × 2 seeds = **216 upgraded** fights.
- **Same protagonist persists** while party grows from solo to duo to trio; companion acquisition follows fixed cyclic order Knight→Ranger→Mage→Knight (so Knight+Ranger, Ranger+Mage, Mage+Knight in duos). All three orders for same case share the same seed, position and party. Party size changes number of hero units and production scalers by design; no claim it is a pure causal test of a single scaler.
- Late illustrative build uses the **same authored** `knight_iron_oath`, `ranger_longshot`, `mage_wildfire` upgrades (one per present hero) and one protagonist-linked artifact (`dead_mans_shield`, `blind_quiver`, `cracked_focus`). Production modifier sequence/RunState base party-size multipliers reused.
- Results include explicit `party_roles` string to remove earlier ambiguity, and 12-column CSV `user://misdeal_tactical_v24_party_focus.csv` with encounter/layout/size/protagonist/composition/order/profile/sample/outcome/simulated seconds/survivor counts.
- PASS requires targeting-fixture expectations, 270 completed fights/no timeouts and CSV write, **not balanced real-world win rates**. Fixed simulated 30 FPS and 75 s limit; no full Act 1 card-deal flow, Wizard risk or reward transitions. No global solo/duo/trio scalars touched.

**Next Godot handoff:** user `git pull`, F6 v2.4 scene, return PASS/FAIL screenshot and `misdeal_tactical_v24_party_focus.csv` from Project > Open User Data Folder; GitHub changes are committed without engine runtime validation in assistant container. Then compare v2.4 HUNT vs other tactics in `last_bell`, and solo→duo→trio trajectories by *same protagonist* for late encounters. Only consider further tuning based on these controlled results plus actual Act 1 play. Original 7 two-layout encounter cards, 18 artworks, DS2 / Fate Spread Variant C, 12+XIII progression stay unchanged.


## D141 — Gameplay 2.5 must diagnose, not speculate or rebalance

Date: 2026-10-14
Status: **user approved («Давай»); code committed in GitHub main, local F6 QA pending**

Following the measured v24 results (report `docs/TACTICAL_GAMEPLAY_V24_BALANCE_REVIEW.md`), user agreed to **diagnostic-first** work. HUNT was outcome-dominated by ASSAULT on the v24 matrix despite sharing healer focus mechanically; Knight+Ranger late equipped duo had 0/24 wins compared with Knight solo 24/24 and trio 2/24. Neither result alone identifies its root cause; particularly party size changes the number of heroes, composition, placements, reward allocation and enemy pressure scalers together.

Approved scope is **observability only**, not balance retuning. Add opt-in `BattleUnit` signals for actual executed attacks, effective HP damage (primary+splash) and healer support recovery. Signals emit only if connected, and **do not change** target selection, hit damage, timing or healing. Build a standalone dev-only real BattleUnit F6 diagnostic scene `res://scenes/dev/tactical_gameplay_v25_combat_diagnostics.tscn`. Its 126 scenarios are an exact-matched **subset** of previously Godot-validated v24 cases: all 54 `last_bell` layout/protagonist/party/order combinations plus 72 `ossuary_gate`/`firing_square` late equipped Knight / Knight+Ranger / Knight+Ranger+Mage scenarios, two layouts, three orders, two seeds. Use v24 seeds and authored upgrade/artifact/party-scaling logic, not new synthetic enemies or arbitrary stats. Record attack counts, attack-to-healer counts, true damage dealt/received, effective healing, chase seconds, support-target seconds, movement distance and target switches, alongside normal outcome metrics in **two** separate CSV outputs:
- `user://misdeal_tactical_v25_trace_cases.csv` — per matched combat.
- `user://misdeal_tactical_v25_trace_units.csv` — per spawned unit for each combat.

**Interpretation boundary:** CSV metric totals such as chase seconds represent summed hero time; not a full in-game telemetry system nor an Act 1 win-rate sample. F6 PASS would mean 126 battles complete and both files are written, **not that HUNT or solo/duo/trio are fixed**. Assistant cannot run Godot in its container; user must `git pull`, run F6 and share both CSVs for actual diagnosis. Only after review and a normal Act 1 run with Wizard risk/rewards and boss XIII should any HUNT targeting or party-size scalers be tuned. Preserve card-specific opponent rosters, existing two-layout formations, DS2 / Fate Spread Variant C, 18 approved assets and 12+XIII structure.
