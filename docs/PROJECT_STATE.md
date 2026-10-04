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
- first `table -> battle -> reward -> table` loop.

The three-card encounter selection and three-victory finite run are implemented and confirmed working locally.

Phase 3 identity work is underway. The first non-combat event card and one-time event flow are confirmed working locally.

The earlier painted-art integration was locally judged too hard to read in combat. The user chose a dark-fantasy pixel-art direction.

The first pixel-art combat readability redesign is implemented and confirmed working locally.

The second battle presentation pass is implemented and confirmed visually acceptable locally.

The same pixel-art visual language is now applied across the main menu, Whispering Well event, reward screen and run-end screen.

The wizard table has since been rebuilt again around an approved authored pixel-art concept. The implementation is in GitHub and pending local verification.

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

Each deal presents three playable combat cards plus one one-time event card:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers;
- **ШЕПЧУЩИЙ КОЛОДЕЦ** — a non-combat risk/reward event, available once per run.

The table displays:

- current deal out of 3;
- gold;
- party HP bonus;
- party damage bonus.

Selecting a combat card stores its encounter in `RunState` and launches battle.

The wizard table now uses a hybrid authored-art + live-UI composition based on the approved concept stored at:

- `assets/concepts/approved_table_direction.png`

Runtime table assets derived from that concept:

- `assets/pixel/table/table_wizard_layer.png` — wizard/room backdrop;
- `assets/pixel/table/misdeal_logo.png` — title logo;
- `assets/pixel/table/cards/bone_patrol.png`;
- `assets/pixel/table/cards/graveyard_ambush.png`;
- `assets/pixel/table/cards/gallows_volley.png`;
- `assets/pixel/table/cards/whispering_well.png`.

The lower tabletop, ritual runner, sigil, candles and props remain procedural so the layout can stay responsive to live UI.

The four encounter/event cards are still real Godot `Button` controls with live titles/descriptions/states. The approved art is used inside those interactive cards instead of baking run state into a static screenshot.

The top HUD remains dynamic and shows the actual deal count, gold, party HP modifier and damage modifier.

The earlier painted assets under `assets/art/` remain in the repository as historical/reference material.

### 3. Whispering Well event

`scenes/event/whispering_well.tscn`

The first non-combat event offers three choices:

- accept the well's gift: +4 party damage and -15 party HP;
- spend 25 gold: +25 party HP;
- walk away with no stat change.

The event is resolved only once per run and does not advance the three-victory run counter.

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
- victory and defeat detection.

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

Choosing a reward increments `deals_survived`.

After victories 1 and 2, the player returns to the table.

After victory 3, the player goes to the run-end screen.

### 6. Run end

`scenes/run_end/run_end.tscn`

After three successful deals, the run ends and displays:

- deals survived;
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

### Run state

`scripts/core/run_state.gd`

The current prototype run state stores:

- gold;
- deals survived;
- global party HP bonus;
- global party damage bonus;
- last battle result;
- selected encounter path.

The current vertical-slice run ends after 3 rewarded victories.

## Not implemented yet

- additional non-combat event cards;
- broader gold economy / shop;
- equipment;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

Locally verify the rebuilt wizard table:

- the authored wizard/room backdrop renders cleanly at 1280×720;
- the Misdeal logo and dynamic run HUD remain readable;
- all four illustrated cards are clickable;
- combat-card titles/descriptions still come from `EncounterData`;
- Whispering Well correctly switches to its exhausted/dimmed state after use;
- hover borders and event/combat card color treatments read clearly;
- selecting a combat/event card still transitions to the correct scene.

After table verification, reuse the approved/generated pixel-art references selectively for richer authored assets rather than embedding whole mockup screenshots with baked UI.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
