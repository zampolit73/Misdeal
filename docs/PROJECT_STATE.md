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

Each deal presents three playable combat cards:

- **КОСТЯНОЙ ДОЗОР** — three melee Skeleton units;
- **ЗАСАДА НА КЛАДБИЩЕ** — two Skeleton units plus one Bone Archer;
- **ЗАЛП С ВИСЕЛИЦЫ** — one Skeleton plus two Bone Archers.

The table displays:

- current deal out of 3;
- gold;
- party HP bonus;
- party damage bonus.

Selecting a card stores its encounter in `RunState` and launches battle.

### 3. Combat

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

### 4. Reward

`scenes/reward/reward.tscn`

Victory offers one of three persistent rewards:

- **КРОВАВАЯ МОНЕТА**: +25 gold;
- **ЖЕЛЕЗНЫЙ ОБЕРЕГ**: +20 HP to every hero;
- **ЗАКАЛЁННАЯ СТАЛЬ**: +3 damage to every hero.

Choosing a reward increments `deals_survived`.

After victories 1 and 2, the player returns to the table.

After victory 3, the player goes to the run-end screen.

### 5. Run end

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

- non-combat event cards;
- meaningful gold spending;
- equipment;
- attack projectiles/animations;
- broader ability/status-effect system;
- richer evil wizard presentation;
- deck building / card unlocks;
- meta progression;
- save/load.

## Immediate next milestone

Phase 2 is locally verified.

Continue into Phase 3 identity work: strengthen the evil wizard as the host/antagonist and add the first non-combat card/event so the table starts feeling like an adventure rather than only a battle selector.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
