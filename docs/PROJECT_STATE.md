# Misdeal — Project State

Last updated: 2026-10-04

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

The wizard table has since been rebuilt again around an approved authored pixel-art concept.

The final composition/readability polish pass has been locally verified and accepted:

- encounter hover no longer uses floating tooltips over card art;
- hovering a combat card now swaps the upper wizard-commentary line to that encounter's wizard reaction;
- the Whispering Well has its own hover commentary;
- the HUD and commentary strip are more compact;
- the four cards are slightly smaller, lower and more evenly spaced so the wizard remains visible;
- obsolete procedural skull/goblet/hourglass/books/candle overlays were removed;
- the lower runner/sigil treatment was simplified and subdued.

The first Bone Warden boss encounter, including its 50% HP enrage, was confirmed working locally.

The next run-structure pass is now implemented in GitHub and pending local verification: Act 1 contains 12 resolved pre-boss cards followed by the Bone Warden as card 13.

## Player-facing language

All player-facing UI text, card text, reward text, wizard lines and unit display names are Russian.

Technical identifiers, file names, node names, class names and code remain English.

## Engine

- Godot 4.7.x
- GDScript
- Main scene: `res://scenes/main/main.tscn`
- Rendering method: GL Compatibility
- Prototype resolution: 1280×720
- `RunState` is registered as an autoload singleton.

## Current playable flow

### 1. Main screen

`scenes/main/main.tscn`

Pressing **ВОЙТИ В ИГРУ** resets the prototype run and opens the wizard's table.

### 2. Wizard table

`scenes/table/table.tscn`

Act 1 now uses a two-card offer flow:

- the player resolves 12 pre-boss cards;
- before each card, the wizard offers two cards from the current difficulty tier;
- choosing one card removes the rejected alternative from that run;
- cards do not repeat inside the run;
- after cards 1-4 the pool moves from early to mid tier;
- after cards 5-8 it moves from mid to late tier;
- after card 12 the only remaining progression card is **КОСТЯНОЙ НАДЗИРАТЕЛЬ**.

A selected combat card remains active after defeat. Returning to the table shows that same card as **ПОВТОРИТЬ**, rather than generating a fresh offer.

The structural Act 1 pool contains 24 unique pre-boss card definitions: 8 early, 8 mid and 8 late. This is intentionally large enough for twelve two-card offers where the rejected alternative leaves the run.

Currently fully implemented card mechanics:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers;
- **ШЕПЧУЩИЙ КОЛОДЕЦ** — the existing three-choice risk/reward event.

The remaining new card definitions already participate in the real Act 1 deck/tier/rejection flow, but temporarily resolve through `scenes/event/prototype_card.tscn` until their individual mechanics are implemented.

The table displays:

- current card progress out of 12, or **БОСС**;
- gold;
- party HP bonus;
- party damage bonus.

Selecting a card stores it as the active run card. Combat cards also select their `EncounterData`; event/prototype cards route to their configured scene.

The wizard table now uses a hybrid authored-art + live-UI composition based on the approved concept stored at:

- `assets/concepts/approved_table_direction.png`

Runtime table assets derived from that concept:

- `assets/pixel/table/table_wizard_layer.png` — wizard/room backdrop;
- `assets/pixel/table/misdeal_logo.png` — title logo;
- `assets/pixel/table/cards/bone_patrol.png`;
- `assets/pixel/table/cards/graveyard_ambush.png`;
- `assets/pixel/table/cards/gallows_volley.png`;
- `assets/pixel/table/cards/whispering_well.png`.

The lower tabletop, ritual runner and sigil remain procedural so the layout can stay responsive to live UI. Earlier procedural side props and candles were removed after local visual review because they conflicted with the authored backdrop.

The table still uses real Godot `Button` controls. Two existing card slots are now populated dynamically from `RunCardData`, including title, type, description, wizard hover line and art path.

The top HUD remains dynamic and shows actual Act 1 card progress, gold, party HP modifier and damage modifier.

The earlier painted assets under `assets/art/` remain in the repository as historical/reference material.

### 3. Whispering Well event

`scenes/event/whispering_well.tscn`

The first non-combat event offers three choices:

- accept the well's gift: +4 party damage and -15 party HP;
- spend 25 gold: +25 party HP;
- walk away with no stat change.

The event remains one-time because its card leaves the run after being offered. Resolving it now completes the current Act 1 card and advances card progress.

### 4. Combat

`scenes/battle/battle.tscn`

Player party:

- Рыцарь;
- Следопыт;
- Маг.

Enemy composition and spawn positions come from the selected `EncounterData` Resource.

Before combat, the player can drag the three heroes within the deployment zone.

Implemented combat behavior:

- automatic nearest-enemy targeting;
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
- Bone Warden enlarges its silhouette, keeps a visible boss name/HP treatment, and at 50% HP increases damage, attack speed and movement speed with a visible **ЯРОСТЬ!** cue.

Hero stats receive persistent run bonuses from `RunState`.

After victory, **ЗАБРАТЬ НАГРАДУ** opens the reward scene.

After defeat, **ВЕРНУТЬСЯ К СТОЛУ** returns to the same run without increasing the victory count.

**ПЕРЕИГРАТЬ** remains available as a prototype/testing convenience.

### 5. Reward

`scenes/reward/reward.tscn`

Victory offers one of three persistent rewards:

- **КРОВАВАЯ МОНЕТА**: +25 gold;
- **ЖЕЛЕЗНЫЙ ОБЕРЕГ**: +20 HP to every hero;
- **ЗАКАЛЁННАЯ СТАЛЬ**: +3 damage to every hero.

Choosing a reward applies the reward and completes the active combat card.

Normal combat victories return to the table and advance Act 1 card progress.

After defeating Bone Warden and taking its reward, `boss_defeated` becomes true and the player goes to the run-end screen.

### 6. Run end

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

Runtime combat state remains on `BattleUnit`.

`UnitData.visual_role` now selects 48×48 pixel-art combat sprites:

- `assets/pixel/units/knight.png`
- `assets/pixel/units/ranger.png`
- `assets/pixel/units/mage.png`
- `assets/pixel/units/skeleton.png`
- `assets/pixel/units/bone_archer.png`

Combat presentation now prioritizes the sprite silhouette:

- unit art is significantly larger;
- thick portrait circles were removed;
- thin team rings sit under the unit's feet;
- HP bars are compact pixel-style bars above the sprite;
- hero names remain small;
- enemy instance suffixes such as A/B/C were removed and enemy labels are hidden during combat;
- the arena uses a restrained pixel-stone renderer instead of a flat empty field.

The second presentation pass adds:

- a masonry back wall, ruined pillars and dark-fantasy banners;
- animated pixel torchlight;
- skulls, bones, rubble and blood stains around the arena edges;
- a stronger central ritual sigil and vignette treatment;
- framed pixel HUD chrome around the encounter header and command area;
- a real `РАЗДАЧА X/3` indicator driven by `RunState`;
- a framed victory/defeat result panel;
- a short sprite lunge on every attack for extra combat motion.

The older painted unit assets under `assets/art/units/` remain in the repository for reference but are no longer used by combat.

### Encounter data

`scripts/data/encounter_data.gd`

Encounter Resources currently define:

- encounter id;
- Russian title and card text;
- wizard line;
- enemy UnitData paths;
- enemy display names;
- enemy spawn positions.

Current encounter files:

- `resources/encounters/bone_patrol.tres`
- `resources/encounters/graveyard_ambush.tres`
- `resources/encounters/gallows_volley.tres`
- `resources/encounters/bone_warden.tres` — final-deal boss encounter.

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
- boss completion state.

Act 1 ends after 12 resolved pre-boss cards plus Bone Warden.

## Not implemented yet

- individual mechanics for most of the newly defined Act 1 cards;
- broader gold economy / functional shop;
- equipment/artifacts;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

Locally verify the new Act 1 run structure:

- a fresh run should show two card offers and **КАРТА 1/12**;
- choosing one offer should permanently reject the other for that run;
- cards 1-4 should draw only from the early pool, cards 5-8 from mid, and cards 9-12 from late;
- the three existing combat encounters should still launch real battles and advance only after a reward is taken;
- Whispering Well should still resolve normally and now advance one Act 1 card;
- prototype cards should open the generic prototype resolver and advance cleanly back to the table;
- losing a combat should return to the same selected card as **ПОВТОРИТЬ**;
- after card 12, the table should show only **КОСТЯНОЙ НАДЗИРАТЕЛЬ**;
- boss victory -> reward -> run end should still work.

After this structure is accepted, stop adding run-framework code and replace prototype cards with real mechanics in small batches, starting with recovery/shop/artifact cards and the missing combat archetypes.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
