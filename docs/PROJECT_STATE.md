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

The first authored-art integration is implemented in GitHub and pending local verification: the wizard table now uses a painted dark-fantasy background, the UI has authored wizard/card-back art, and battle units use cropped authored miniature textures.

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

The table keeps the styled dark-fantasy card UI but now uses authored art assets:

- `assets/art/table_background.webp` — painted cursed-table background with the evil wizard;
- `assets/art/wizard_portrait.webp` — wizard portrait used by the table UI;
- `assets/art/card_back.webp` — authored cursed card-back design.

The procedural table/wizard blockout scripts remain in the repository as fallback/reference material but are no longer the primary table visuals.

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

`UnitData.visual_role` selects authored combat miniature textures:

- `assets/art/units/knight.webp`
- `assets/art/units/ranger.webp`
- `assets/art/units/mage.webp`
- `assets/art/units/skeleton.webp`
- `assets/art/units/bone_archer.webp`

The procedural miniature drawing remains as a fallback if a texture is unavailable. Team-colored bases, health bars, placement rings and combat feedback remain procedural for gameplay readability.

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

Locally verify the first authored-art integration:

- the painted table background imports and renders correctly;
- the wizard portrait and decorative card back appear correctly;
- card text remains readable over the new background;
- Knight, Ranger, Mage, Skeleton and Bone Archer textures render at a useful size;
- drag placement, hit feedback, death feedback and combat still work unchanged.

After verification, tune composition/scale/readability and then expand authored art into encounter-card faces, event scenes and the battle arena.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
