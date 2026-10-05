# Misdeal — Project State

Last updated: 2026-10-05

## Current status

Misdeal has a working tactical autobattle slice and a first finite run structure.

Confirmed locally by the user:

- base autobattle and restart;
- pre-battle hero placement;
- combat-time unit separation;
- hit/death feedback;
- data-driven `UnitData`;
- Bone Archer keep-distance behavior;
- hard combat-arena bounds;
- first `table -> battle -> reward -> table` loop;
- cleaned-up victory/defeat result overlay.

The original three-victory finite run was implemented and confirmed working locally, then deliberately replaced by the longer Act 1 structure described below.

Phase 3 identity work is underway. The first non-combat event card and one-time event flow are confirmed working locally.

The earlier painted-art integration was locally judged too hard to read in combat. The user chose a dark-fantasy pixel-art direction.

The first pixel-art combat readability redesign is implemented and confirmed working locally.

The second battle presentation pass is implemented and confirmed visually acceptable locally.

The same pixel-art visual language is now applied across the main menu, Whispering Well event, reward screen and run-end screen.

The first two main-menu rebuilds were rejected in local visual review. A dedicated dark-fantasy pixel-art splash was then generated, explicitly selected by the user, and is now the approved production start screen. It shows the Wizard looming over a five-card cursed table, the large MISDEAL title, the line **«Проклятая партия уже разложена.»** and a painted **ВОЙТИ В ИГРУ** button. Runtime reconstructs the approved 1280×720 WebP from three repository-safe base64 chunks and renders it at native project resolution with linear filtering; the corrected Wizard card hand now has five fingers, and only a transparent native Godot button hotspot remains live over the painted CTA.

A skippable five-frame pixel-art story prologue is now implemented in GitHub and pending local verification. It establishes the old pact, the aged protagonist and the Wizard's offer to replay a life whose corrections will rewrite the fates of everyone the protagonist once saved.

The wizard table has since been rebuilt again around an approved authored pixel-art concept.

The final composition/readability polish pass has been locally verified and accepted:

- encounter hover no longer uses floating tooltips over card art;
- hovering a combat card now swaps the upper wizard-commentary line to that encounter's wizard reaction;
- the Whispering Well has its own hover commentary;
- the HUD and commentary strip are more compact;
- the four cards are slightly smaller, lower and more evenly spaced so the wizard remains visible;
- obsolete procedural skull/goblet/hourglass/books/candle overlays were removed;
- the lower runner/sigil treatment was simplified and subdued.

The original Bone Warden boss encounter, including its 50% HP enrage, was confirmed working locally. After full Act 1 playtesting the user reported that the boss was too easy and visually insufficiently distinct from ordinary combat.

A Bone Warden gameplay + visual rework is implemented in GitHub and pending local verification. The first local pull exposed a Godot 4.7.2 type-inference parser error in the new procedural boss-arena chains; that parser issue was fixed.

After comparing the live battle screenshot against the approved richer pixel mockup, the procedural battle renderer was replaced by an authored full-screen battle backdrop matching the second approved reference much more closely. The first local pull exposed two wiring faults: a truncated 8.7 KB WebP and a negative z-index that placed the backdrop behind the black fallback. Both faults were fixed, and the user has now confirmed the authored battle backdrop looks correct locally.

The full combat-unit sprite art pass is now locally confirmed working. All nine currently used combat roles have dedicated high-detail dark-fantasy pixel sprites in one 96×96 atlas; special enemies no longer reuse tinted Skeleton art. The final v3 atlas is stored as ten base64 PNG chunks under `assets/pixel/units/combat_units_v3/` and decoded by `BattleUnit`. The obsolete v2 preload/fallback was removed after it caused a Godot parser/import failure.

A first real **hero build progression** layer is implemented in GitHub and pending full-run local verification. Ordinary post-combat +HP/+damage choices are no longer the main progression path.

A follow-up **build-aware event pass** is also implemented in GitHub and pending local verification. Positive permanent event rewards now primarily use hero development, artifacts or gold; raw global HP/damage changes remain mainly as costs, penalties or legacy named artifact effects.

The longer Act 1 structure is now confirmed working locally: 12 resolved pre-boss cards followed by the Bone Warden as card 13.

The first real post-structure content batch is implemented: **ПЕПЕЛЬНЫЙ ПРИВАЛ**, **ЛАВКА МОГИЛЬЩИКА** and **КУЗНИЦА ПРОКЛЯТИЙ** have real choices instead of the generic prototype resolver.

The first new combat-content batch is also implemented in GitHub and pending local verification: **МОГИЛЬНЫЙ ЗВОН**, **КОСТЯНАЯ ДАВКА** and **СТРАЖ СКЛЕПА** are real combat cards.

A second real event batch is implemented in GitHub and pending local verification: **ЧЁРНЫЙ АЛТАРЬ**, **ЗАКОВАННЫЙ ПЛЕННИК**, **КОСТИ ДОЛЖНИКА** and **ДЕСЯТИНА ВОЛШЕБНИКА** no longer use the prototype resolver.

The late-game escalation batch is implemented and locally confirmed working: **КАРТА БЕЗ ЛИЦА**, **КРОВАВАЯ КНИГА**, **СЛОМАННАЯ КОРОНА**, **ПОСЛЕДНИЙ ПРИВАЛ** and **ВРАТА ОССУАРИЯ** are real cards.

The final five-card content batch is locally confirmed working: **ГРЕМУЧИЙ МОСТ**, **КОШЕЛЬ МЕРТВЕЦА**, **ТОРГОВЕЦ СВЕЧАМИ**, **КОСТЯНАЯ ПОШЛИНА** and **СТАВКА НА СМЕРТЬ** all have bespoke mechanics. The full 24-card pre-boss Act 1 pool is content-complete with no active prototype-card routes.

The first Act 1 balance/readability pass is implemented in GitHub and pending local verification. It focuses on combat pacing, Death Wager reward inflation and final-boss difficulty rather than broad retuning of every event.

Local hard-roguelike testing then exposed that the original solo compensation (+50% HP / +35% damage) was not enough to survive the first mandatory combat encounters. This was a real action-economy problem rather than a placement-only issue.

A solo rebalance is now implemented in GitHub and pending local verification:

- solo max HP multiplier: x2.0;
- solo damage multiplier: x1.8;
- solo attack interval multiplier: x0.80, equivalent to +25% attacks/second;
- solo move-speed multiplier: x1.10;
- duo remains +20% HP / +15% damage;
- trio remains unmodified;
- early enemy resources and encounter compositions were deliberately left unchanged;
- Bone Warden remains a fixed benchmark and still does not scale dynamically to party size.

A follow-up UI-overlap polish pass was implemented after local screenshots exposed three readability faults:

- protagonist class cards no longer use multiline `Button.text` underneath the portrait; portrait, class name, stats, role and description now occupy separate fixed regions;
- wizard-table offer cards have a taller clipped description region and a dedicated bottom hint/action region, preventing long event copy from colliding with **ВЫБРАТЬ**;
- battle result UI and command buttons now render above combat-unit Y-sorting, and the finished **БОЙ** button is hidden when **ЗАБРАТЬ НАГРАДУ / ВЕРНУТЬСЯ К СТОЛУ** appears, removing duplicated bottom text.

## Player-facing language

All player-facing UI text, card text, reward text, wizard lines and unit display names are Russian.

Technical identifiers, file names, node names, class names and code remain English.

## Engine

- Godot 4.7.x
- GDScript
- Main scene: `res://scenes/main/main.tscn`
- First-run story scene: `res://scenes/intro/intro.tscn`
- Rendering method: GL Compatibility
- Prototype resolution: 1280×720
- `RunState` is registered as an autoload singleton.

## Current playable flow

### 1. Main screen

`scenes/main/main.tscn`  
`scripts/main/approved_main_backdrop.gd`

The production main menu is now a dedicated, user-approved authored pixel-art splash rather than a live recomposition of the wizard-table scene.

Visual content baked into the approved splash:

- the Wizard looming behind the cursed table;
- large MISDEAL title;
- **«Проклятая партия уже разложена.»**;
- five cards across the table;
- player hands in the foreground;
- candles, skulls, moonlit gothic architecture and an hourglass;
- painted **ВОЙТИ В ИГРУ** CTA.

Runtime art is reconstructed from:

- `assets/pixel/main/approved_splash_hd/part_00.txt`;
- `part_01.txt`;
- `part_02.txt`.

The source image is a native 1280×720 WebP encoded across those chunks and rendered with linear filtering. A transparent native Godot `StartButton` sits over the painted CTA so hover/focus/click remain interactive without duplicating the artwork. Pressing it resets the run and opens the story intro.

The previous `main_visual.gd` / reused table-art menu composition is no longer active.

### 2. Story intro

`scenes/intro/intro.tscn`

The game now opens with a five-frame authored pixel-art comic prologue before the first wizard-table deal.

Narrative premise:

- the player character is old and looking back on a long life of rescues, losses and consequences;
- the Wizard is returning because of an old pact rather than meeting the player for the first time;
- he offers the impossible: replay the key decisions of that life;
- changing one saved life can erase or rewrite another life that existed because of the original choice;
- the final frame reveals the cursed cards and leads into protagonist-class selection before the first deal.

Runtime intro art lives under `assets/pixel/intro/frame_01.webp` … `frame_05.webp`, authored at 1280×720 in the same dark-fantasy pixel language as the battle/table presentation.

Controls:

- left click, **Space** or **Enter** advances;
- the painted **ПРОПУСТИТЬ** area in the top-right is backed by a real Godot button;
- **Esc** also skips;
- the final frame advances to `scenes/class_select/class_select.tscn`;
- short black fades separate frames.

Starting another run from the run-end screen skips the prologue but still opens class selection, because protagonist class is a per-run decision.

### 3. Protagonist class selection

`scenes/class_select/class_select.tscn`

Each run now begins with one protagonist rather than a guaranteed trio.

- choose **РЫЦАРЬ**, **СЛЕДОПЫТ** or **МАГ**;
- the chosen role becomes `RunState.protagonist_role` and the only initial member of `party_roles`;
- the other two roles begin with fate **НЕ РАЗЫГРАНА**;
- the scene uses the same production combat atlas as battle/status UI;
- consecutive new runs skip the story comic but return here before the table.

### 4. Wizard table

`scenes/table/table.tscn`

Act 1 now uses a two-card offer flow:

- the player resolves 12 pre-boss cards;
- before each card, the wizard offers two cards from the current difficulty tier;
- choosing one card removes the rejected alternative from that run;
- cards do not repeat inside the run;
- after cards 1-4 the pool moves from early to mid tier;
- after cards 5-8 it moves from mid to late tier;
- each 4-card tier now guarantees one combat selection: at run start each tier randomly chooses one of its first three slots as the mandatory combat slot, non-combat offers are protected before it, and that slot offers two combat cards;
- later slots in mid/late can still surface the tier's remaining combat card, so a run can contain more than the guaranteed minimum;
- after card 12 the only remaining progression card is **КОСТЯНОЙ НАДЗИРАТЕЛЬ**.

A selected combat card remains active after defeat. Returning to the table shows that same card as **ПОВТОРИТЬ**, rather than generating a fresh offer.

The structural Act 1 pool contains 24 unique pre-boss card definitions: 8 early, 8 mid and 8 late. This is intentionally large enough for twelve two-card offers where the rejected alternative leaves the run.

Currently fully implemented card mechanics:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers;
- **ШЕПЧУЩИЙ КОЛОДЕЦ** — risk blood for hero development, pay 25 gold for a relic/build fallback, or walk away;
- **ПЕПЕЛЬНЫЙ ПРИВАЛ** — freely prepare one specific hero by taking that role's next available upgrade, or leave;
- **ЛАВКА МОГИЛЬЩИКА** — buy the next available Knight/Ranger/Mage development for 35 gold;
- **КУЗНИЦА ПРОКЛЯТИЙ** — choose one of three hero-specific artifacts, or refuse;
- **МОГИЛЬНЫЙ ЗВОН** — two Skeletons protect a Grave Bellkeeper support enemy;
- **КОСТЯНАЯ ДАВКА** — five weak Bone Thralls pressure the party through numbers and reward splash damage;
- **СТРАЖ СКЛЕПА** — elite Crypt Guard with melee splash plus two Bone Thralls; victory uses a guaranteed-artifact reward flow;
- **ЧЁРНЫЙ АЛТАРЬ** — sacrifice party HP to unlock the next Knight/Ranger/Mage upgrade, or refuse;
- **ЗАКОВАННЫЙ ПЛЕННИК** — pay to train the least-developed hero, trade blood for a relic, loot the prisoner, or leave;
- **КОСТИ ДОЛЖНИКА** — a true 50/50 gold gamble alongside safer deterministic choices; failure still uses raw stat penalties as a curse;
- **ДЕСЯТИНА ВОЛШЕБНИКА** — pay gold, pay party HP, or refuse and take a temporary wizard debt;
- **КАРТА БЕЗ ЛИЦА** — hidden outcome now yields gold, a relic or hero development; bribing guarantees development and burning can clear wizard debt;
- **КРОВАВАЯ КНИГА** — buy development with gold, trade blood for a relic/build fallback, or erase the latest hero upgrade for 70 gold;
- **СЛОМАННАЯ КОРОНА** — source-locked party-wide artifact, 40-gold break option, or melt the crown into development for the least-developed hero;
- **ПОСЛЕДНИЙ ПРИВАЛ** — late pre-boss choice to develop Knight, Ranger or Mage directly;
- **ВРАТА ОССУАРИЯ** — heavy late combat combining Crypt Guard, Grave Bellkeeper, Bone Archer and Bone Thrall;
- **ГРЕМУЧИЙ МОСТ** — early traversal risk with a 50/50 sprint, a small guaranteed gold/HP trade, or a safe crossing;
- **КОШЕЛЬ МЕРТВЕЦА** — deterministic greed ladder: more gold costs progressively more party HP;
- **ТОРГОВЕЦ СВЕЧАМИ** — early build shop: buy the next Knight/Ranger/Mage development for 25 gold;
- **КОСТЯНАЯ ПОШЛИНА** — forced mid-run payment choice: gold, blood, or a harsher confrontation that costs HP but develops the least-developed hero;
- **СТАВКА НА СМЕРТЬ** — late five-enemy elite combat against Crypt Guard, two Bone Archers and two Bone Thralls, followed by +60 gold / relic / extra hero-upgrade reward choice.

All 24 pre-boss cards now have bespoke mechanics. `scenes/event/prototype_card.tscn` remains only as unused legacy prototype infrastructure and is no longer referenced by the active Act 1 card pool.

The table displays:

- current card progress out of 12, or **БОСС**;
- gold;
- current party size out of 3;
- current hero-development count;
- current relic count;
- **ДОЛГ ВОЛШЕБНИКУ** when active;
- an **ОТРЯД [TAB]** control that opens the squad-status modal over the current deal.

Selecting a card stores it as the active run card. Combat cards also select their `EncounterData`; event/prototype cards route to their configured scene.

The wizard table now uses a hybrid authored-art + live-UI composition based on the approved concept stored at:

- `assets/concepts/approved_table_direction.png`

The battle screen now follows its own approved pixel-art direction stored at:

- `assets/concepts/approved_battle_direction.jpg`

The battle remains live Godot UI/combat rather than a baked screenshot; the reference is used for composition, density, scale and palette.

Runtime table assets derived from that concept:

- `assets/pixel/table/table_wizard_layer.png` — wizard/room backdrop;
- `assets/pixel/table/misdeal_logo.png` — title logo;
- `assets/pixel/table/cards/bone_patrol.png`;
- `assets/pixel/table/cards/graveyard_ambush.png`;
- `assets/pixel/table/cards/gallows_volley.png`;
- `assets/pixel/table/cards/whispering_well.png`;
- `assets/pixel/table/cards/bone_warden.png` — dedicated final-boss card art.

The lower tabletop, ritual runner and sigil remain procedural so the layout can stay responsive to live UI. Earlier procedural side props and candles were removed after local visual review because they conflicted with the authored backdrop.

The table still uses real Godot `Button` controls. Two existing card slots are now populated dynamically from `RunCardData`, including title, type, description, wizard hover line and art path.

The top HUD remains dynamic and now emphasizes Act 1 progress, gold, **РАЗВИТИЕ** count and **РЕЛИКВИИ** count. If wizard debt is active, **ДОЛГ ВОЛШЕБНИКУ** is also shown.

### Squad status

`scenes/table/squad_status.tscn`  
`scripts/table/squad_status.gd`

The table now has a read-only **ДОСЬЕ ОТРЯДА** modal for inspecting the current run build.

The dossier also represents companion fate. Heroes outside the current party remain selectable as faded entries:

- **СУДЬБА НЕ РАЗЫГРАНА** — recruitment is still possible if a relevant card is actually played;
- **ПОТЕРЯН** — the player personally reached a recruitment scene and chose not to save that companion;
- joined companions immediately switch to normal stat/build presentation.

It opens on the currently chosen protagonist.

- Tab or **ОТРЯД [TAB]** opens/closes it without changing the current card offer;
- Esc closes it;
- 1 / 2 / 3 switches between Knight, Ranger and Mage;
- portraits are sliced from the same production 3×3 combat-unit atlas used in battle;
- each hero shows final HP, damage, attacks/second, range, move speed and damage/second;
- Ranger/minimum-range and Knight/Mage splash stats appear only when relevant;
- changed values are compared against the hero's base `UnitData` value;
- the right side lists the hero's acquired upgrades and every relic currently affecting that hero, including party-wide relics;
- the footer shows legacy party HP/damage effects, optional-upgrade progress and wizard debt;
- the hero subtitle becomes a lightweight dynamic build name such as **ЖЕЛЕЗНАЯ СТЕНА**, **СНАЙПЕР**, **ЗАЛПОВИК**, **ПИРОМАНТ** or **СТЕКЛЯННАЯ ПУШКА**.

`RunState.get_effective_hero_stats()` mirrors battle spawning: global party bonuses -> hero upgrades -> artifacts -> solo/duo compensation -> minimum HP/damage clamps. The status UI does not store a second copy of character stats.

The earlier painted assets under `assets/art/` remain in the repository as historical/reference material.

### 4. Whispering Well event

`scenes/event/whispering_well.tscn`

The dedicated event now has two modes.

If Mage is still an unresolved companion fate:

- pay blood (-20 party HP) and recruit Mage;
- pay 25 gold and recruit Mage safely;
- walk away and mark Mage **ПОТЕРЯН** for this run.

If Mage is already the protagonist/joined/lost, the card falls back to its build/relic event behavior.

The event remains one-time because its card leaves the run after being offered. Resolving it completes the current Act 1 card and advances card progress.

### 5. Combat

`scenes/battle/battle.tscn`

Player party is now variable:

- the run always starts with exactly one chosen protagonist;
- recruited companions are added permanently for the rest of that run;
- combat can therefore be solo, duo or trio.

Enemy composition and spawn positions still come from the selected `EncounterData` Resource.

Before combat, the player can drag every currently recruited hero within the deployment zone.

Implemented combat behavior:

- three pre-battle tactical orders: **НАТИСК**, **ОХОТА**, **СТРОЙ**;
- **НАТИСК** preserves nearest-enemy focus and gives heroes +15% movement speed for faster engagement;
- **ОХОТА** continuously prioritizes support enemies first, then ranged enemies, then the nearest remaining target;
- **СТРОЙ** continuously focuses the enemy closest to the currently most vulnerable living ally, causing the party to collapse onto immediate threats instead of scattering;
- orders can be changed freely during preparation and lock when **БОЙ** is pressed;
- automatic movement and attacks;
- melee and ranged attack ranges;
- Bone Archer keeps distance and retreats when enemies get too close;
- all combat movement is clamped to the visible arena;
- Mage attacks deal 50% splash damage to nearby secondary enemies;
- separation steering prevents units from stacking into one point;
- HP bars;
- hit flash, impact pulse and floating damage numbers;
- death shrink/fade feedback;
- victory and defeat detection;
- boss units can use data-driven visual scale and a one-time enrage threshold;
- Bone Warden uses its own dedicated high-detail `bone_warden` atlas sprite instead of an enlarged normal Skeleton;
- Bone Warden has 700 HP, 24 base damage, a 60%-damage melee cleave in a 92 px radius, and a larger boss HP/name treatment;
- at 50% HP Bone Warden still enrages, increasing damage, attack speed and movement speed, but now also triggers **Phase II** and summons one Bone Archer plus one Bone Thrall;
- the phase transition changes the boss label to **БОСС • ЯРОСТЬ**, shows a centered **ФАЗА II — ПРИЗЫВ** cue and switches the arena into its stronger phase-two ritual state;
- Grave Bellkeeper is the first support enemy: every 4.5 seconds it heals damaged allied undead within 210 px for 18 HP and shows a visible **ЗВОН!** cue;
- Bone Thrall is a smaller, faster, low-HP swarm enemy;
- Crypt Guard is a slower elite melee enemy with a larger silhouette, visible name and 35% splash damage around its primary target.

Hero stats receive persistent run bonuses from `RunState`. After upgrades and relics, incomplete parties receive visible fixed compensation: solo x2.0 HP, x1.8 damage, x0.80 attack interval and x1.10 movement speed; duo +20% HP/+15% damage; trio none. Final spawned max HP is clamped to at least 20 and damage to at least 1. Tactical-order movement is applied at runtime after these build/party modifiers. Enemy/boss stats do not dynamically scale to party size.

After victory, **ЗАБРАТЬ НАГРАДУ** opens the reward scene.

After defeat, **ВЕРНУТЬСЯ К СТОЛУ** returns to the same run without increasing the victory count.

**ПЕРЕИГРАТЬ** remains available as a prototype/testing convenience.

### 6. Reward

`scenes/reward/reward.tscn`

The first combat victory in each early/mid/late tier opens **РАЗВИТИЕ ОТРЯДА** when at least one hero upgrade remains. The player chooses one offered Knight/Ranger/Mage upgrade; this guaranteed tier choice does **not** consume the optional-upgrade cap.

After that:

- ordinary combat loot is **+25 gold**;
- if **ДОЛГ ВОЛШЕБНИКУ** is active, that normal gold loot becomes **+50 gold** and clears the debt;
- Crypt Guard keeps its unowned-artifact reward;
- Death Wager offers **+60 gold / a shown available relic / one extra hero-upgrade choice**;
- if the run has already used all 3 optional hero-upgrade slots, Death Wager's extra-upgrade option becomes **+45 gold** instead of opening an empty selection.

Choosing the final reward completes the active combat card.

Normal combat victories return to the table and advance Act 1 card progress.

After defeating Bone Warden and resolving its reward flow, `boss_defeated` becomes true and the player goes to the run-end screen.

### 7. Run end

`scenes/run_end/run_end.tscn`

After 12 resolved pre-boss cards plus the Bone Warden, the run ends and displays:

- pre-boss cards completed;
- combat victories;
- gold;
- accumulated HP bonus;
- accumulated damage bonus.

**НОВЫЙ ЗАБЕГ** resets `RunState` and returns to the wizard's table.

## Current architecture

### Unit data

Reusable combat stats are stored in `UnitData` Resources:

- `scripts/data/unit_data.gd`
- `resources/units/knight.tres`
- `resources/units/ranger.tres`
- `resources/units/mage.tres`
- `resources/units/skeleton.tres`
- `resources/units/bone_archer.tres`
- `resources/units/bone_warden.tres`
- `resources/units/grave_bellkeeper.tres`
- `resources/units/bone_thrall.tres`
- `resources/units/crypt_guard.tres`

Runtime combat state remains on `BattleUnit`.

`UnitData.visual_role` now selects dedicated 96×96 regions from the unified combat atlas:

- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — final v3 PNG atlas data, decoded at runtime by `BattleUnit`;
- `assets/pixel/units/combat_units_v3/part_00.txt` … `part_09.txt` — the sole production atlas source; `BattleUnit` validates the reconstructed 288×288 PNG before use

Atlas layout:

- row 1: Knight, Ranger, Mage;
- row 2: Skeleton, Bone Archer, Grave Bellkeeper;
- row 3: Bone Thrall, Crypt Guard, Bone Warden.

All nine roles use authored transparent pixel art. Grave Bellkeeper, Bone Thrall and Crypt Guard no longer reuse tinted Skeleton art. The older per-unit PNG files remain in the repository as historical/reference assets but are no longer loaded by combat.

Combat presentation now uses the approved second gothic mockup as an authored static backdrop while keeping all gameplay layers live:

- all current combat roles use the new unified high-detail transparent pixel atlas;
- combat sprites remain substantially larger so silhouettes read like characters rather than small board icons;
- thin blue/red team rings, HP bars, names, drag placement, combat movement and targeting remain live Godot elements;
- the cathedral/crypt architecture, throne/altar, pillars, banners, chains, braziers, skull piles, ritual floor, outer frame and command-panel art are baked into the authored backdrop;
- the authored backdrop is reconstructed at runtime by `scripts/battle/authored_backdrop.gd` from five validated base64 WebP chunks under `assets/pixel/battle/authored_backdrop/`; the decoded image is 1280×720 and uses nearest-neighbor presentation;
- `scripts/battle/battle_visual.gd` no longer draws the general arena and now only adds lightweight dynamic boss-phase overlays;
- the obsolete procedural `scripts/battle/battle_hud_visual.gd` renderer was removed;
- encounter title/status, card progress, faction labels, buttons and result text remain native Godot controls layered over the art;
- **БОЙ** and **ПЕРЕИГРАТЬ** now sit directly over the painted command frames from the backdrop instead of drawing a second competing UI frame.

The older painted unit assets under `assets/art/units/` remain in the repository for reference but are no longer used by combat.

### Encounter data

`scripts/data/encounter_data.gd`

Encounter Resources currently define:

- encounter id;
- Russian title and card text;
- wizard line;
- enemy UnitData paths;
- enemy display names;
- enemy spawn positions;
- optional phase/reinforcement unit paths, names and spawn positions.

Current encounter files:

- `resources/encounters/bone_patrol.tres`
- `resources/encounters/graveyard_ambush.tres`
- `resources/encounters/gallows_volley.tres`
- `resources/encounters/bone_warden.tres` — final-deal boss encounter;
- `resources/encounters/grave_bell.tres`;
- `resources/encounters/bone_crush.tres`;
- `resources/encounters/crypt_guard.tres` — elite encounter with guaranteed artifact reward;
- `resources/encounters/ossuary_gate.tres` — late mixed-archetype combat before the boss;
- `resources/encounters/death_wager.tres` — late five-enemy elite wager encounter.

### Run-card data

`scripts/data/run_card_data.gd`

Act cards are data-driven Resources containing:

- card id;
- Russian title/description/wizard line;
- display type;
- early/mid/late tier;
- resolution type;
- target encounter/event scene;
- art path;
- temporary prototype-result text.

Act 1 card resources live under `resources/cards/`.

### Artifacts

`scripts/data/artifact_data.gd`

The first artifact layer is data-driven and persists for the current run through `RunState.artifact_ids`.

Current artifacts:

- **ЩИТ МЕРТВЕЦА** — Knight +40 HP, -15% move speed;
- **СЛЕПОЙ КОЛЧАН** — Ranger attacks 22% faster but gains +55 minimum range;
- **РАСКОЛОТЫЙ ФОКУС** — Mage deals 15% less primary damage but gains +55 splash radius and +0.25 splash multiplier;
- **СЛОМАННАЯ КОРОНА** — special party-wide artifact: all heroes +22% damage and -10 max HP.

`ArtifactData.general_pool` separates normal shop/elite/random artifacts from source-locked special artifacts. **СЛОМАННАЯ КОРОНА** has `general_pool = false`, so it can only be acquired from its named card. Party-wide artifacts use `target_role = "*"`.

Artifacts are applied to hero runtime stats when combat units spawn. The run-end summary now lists acquired artifacts.

### Hero upgrades

`scripts/data/hero_upgrade_data.gd`

Act 1 now has nine unique persistent hero upgrades, three for each party member:

- Knight: **ЖЕЛЕЗНАЯ КЛЯТВА**, **ПАЛАЧ**, **РАЗМАШИСТЫЙ УДАР**;
- Ranger: **ДАЛЬНИЙ ВЫСТРЕЛ**, **ГРАД СТРЕЛ**, **ЗВЕРИНАЯ ТРОПА**;
- Mage: **ПОЖАР**, **СТЕКЛЯННОЕ СЕРДЦЕ**, **ПЕРЕГРУЗКА**.

Each early/mid/late tier guarantees one major hero-upgrade choice after the first combat victory in that tier. The reward screen offers one available upgrade for Knight, Ranger and Mage, so the player can spread growth across the party or specialize the same hero in all three tiers.

Optional event/Death Wager development is now capped at **3 extra upgrades per run**. These extra slots are tracked separately from the three guaranteed tier upgrades, so a normal strong run should reach roughly 4–6 total upgrades instead of exhausting all nine. If Blood Ledger erases an upgrade that came from an extra slot, that extra slot becomes available again.

Hero upgrades persist for the current run in `RunState.hero_upgrade_ids` and are applied when player units spawn, before artifacts. They can modify HP, damage, attack cadence, range, minimum range, splash and move speed.

Special combat rewards remain intact after the tier upgrade:

- Crypt Guard still grants an artifact reward;
- Death Wager now offers **+60 gold / a shown unowned artifact / one extra hero-upgrade choice**;
- normal combat loot is now gold-only instead of another permanent party-wide HP/damage choice;
- wizard debt still doubles the next normal gold loot and is not consumed by major upgrades or special rewards.

The wizard-table HUD now emphasizes **РАЗВИТИЕ** and **РЕЛИКВИИ** instead of treating global HP/damage counters as the primary build identity.

A read-only **ДОСЬЕ ОТРЯДА** modal is now implemented on the wizard table and pending local verification. It opens from the new **ОТРЯД [TAB]** button or the Tab key without regenerating the current card offer.

The shared `scenes/event/act_choice.tscn` scene handles the implemented choice-driven events. Its progression-facing cards now query the live hero build and show the actual next upgrade name on the choice button when relevant. The scene still intentionally avoids a generalized event-effect framework.

### Hard-roguelike party composition and companion fates

The two non-protagonist heroes are no longer guaranteed party members.

Recruitment routes:

- **Knight** — primary: **ЗАКОВАННЫЙ ПЛЕННИК**; fallback: **ПОСЛЕДНИЙ ПРИВАЛ**;
- **Ranger** — primary: **ГРЕМУЧИЙ МОСТ**; fallback: **ПЕПЕЛЬНЫЙ ПРИВАЛ**;
- **Mage** — primary: **ШЕПЧУЩИЙ КОЛОДЕЦ**; fallback: **ЧЁРНЫЙ АЛТАРЬ**.

Important fate rule:

- if a recruitment card is merely not offered or is rejected at the two-card table choice, that companion remains **НЕ РАЗЫГРАНА** and can still appear through the fallback route;
- if the player actually enters a recruitment scene and chooses a branch that abandons the companion, that role becomes **ПОТЕРЯН** and cannot be recruited later in the run.

Upgrade and general-pool artifact offers only target heroes currently in the party. A solo major reward can show all three remaining upgrade paths for that one hero; duo/trio offers are built only from recruited roles.

Solo compensation is now x2.0 HP, x1.8 damage, x0.80 attack interval (+25% attacks/second) and x1.10 move speed after local testing showed the first version was nearly unplayable. Duo compensation remains +20% HP/+15% damage. This keeps incomplete-party routes playable without adaptive enemy scaling.

### Run state

`scripts/core/run_state.gd`

The current prototype run state stores:

- gold;
- combat victories in `deals_survived` for backward compatibility;
- resolved pre-boss card count;
- remaining, offered, rejected and resolved card ids;
- active selected card id;
- global party HP bonus;
- global party damage bonus;
- last battle result;
- selected encounter path;
- boss completion state;
- persistent artifact ids;
- per-run protagonist role;
- current `party_roles`;
- companion fate state + fate notes for all three hero roles;
- persistent hero-upgrade ids;
- derived effective hero-stat inspection for the squad-status UI;
- claimed major-upgrade tier indices;
- stable pending major/bonus upgrade offers;
- temporary `wizard_debt_active` state;
- randomized per-tier mandatory-combat slot indices in `forced_combat_slots`.

Act 1 ends after 12 resolved pre-boss cards plus Bone Warden.

## Not implemented yet

- follow-up Act 1 balance pass after local full-run feedback on the capped progression economy and retuned boss;
- broader shop inventory/economy beyond the current Candle Seller and Gravedigger Shop implementations;
- more artifacts beyond the first three;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

- approved main-menu splash must decode cleanly, fill the 1280×720 viewport and show no duplicated live title/tagline layers;
- painted **ВОЙТИ В ИГРУ** area must remain clickable/focusable through the transparent Godot hotspot and route to the comic intro;


Locally verify the new hard-roguelike party flow end to end:

- main menu -> story intro -> class selection -> table;
- after choosing a class, battle must spawn only that protagonist;
- solo battle/status must show x2 HP, x1.8 damage, x1.25 attacks/second and x1.10 movement compensation;
- recruiting one companion must immediately switch future battles to duo and compensation to +20% HP/+15% damage;
- recruiting both must produce a normal trio with no compensation;
- major/bonus upgrade offers and general-pool relics must only target heroes currently in the party;
- **Knight** recruitment: Chained Prisoner or, if still unresolved, Last Camp;
- **Ranger** recruitment: Rattling Bridge or, if still unresolved, Ash Rest;
- **Mage** recruitment: Whispering Well or, if still unresolved, Black Altar;
- rejecting a recruitment card at the table must leave fate unresolved;
- entering a recruitment event and deliberately abandoning the companion must mark them **ПОТЕРЯН** and block the fallback recruitment later;
- **ДОСЬЕ ОТРЯДА** must show unresolved/lost companions as faded fate entries and open on the protagonist;
- class-selection cards must keep portraits and all text in separate non-overlapping regions at 1280×720;
- long wizard-table card descriptions must remain inside their clipped description area and never touch **ВЫБРАТЬ**;
- victory/defeat result panels and bottom actions must remain above all unit sprites, HP bars, names and floating combat text;
- run-end summary must list final party and companion fates;
- Bone Warden must remain a fixed benchmark and be tested solo, duo and trio before changing boss stats again;
- verify all three tactical orders in normal, elite and Bone Warden combat: **НАТИСК** should visibly engage faster, **ОХОТА** should retarget to Bellkeeper/Archers including spawned reinforcements, and **СТРОЙ** should react to the ally currently under the most pressure.

Do not add more companion classes until this three-role recruitment loop is locally validated.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
