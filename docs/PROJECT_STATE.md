# Misdeal — Project State

Last updated: 2026-10-04

## Current status

Misdeal now has a playable combat slice and the first end-to-end card-loop scaffold.

Confirmed locally by the user:

- base autobattle and restart;
- pre-battle hero placement;
- combat-time unit separation;
- hit/death feedback;
- data-driven `UnitData`;
- Bone Archer keep-distance behavior;
- hard combat-arena bounds.

The first `table -> battle -> reward -> table` loop is implemented in GitHub and is pending local verification.

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

Pressing **ENTER THE GAME** resets prototype run state and opens the wizard's table.

### 2. Wizard table

`scenes/table/table.tscn`

The table currently shows three card slots:

- one playable encounter: **Graveyard Ambush**;
- two face-down placeholder cards for future encounters.

The table displays current run values:

- deals survived;
- gold;
- party HP bonus;
- party damage bonus.

Choosing **Graveyard Ambush** launches the combat scene.

### 3. Combat

`scenes/battle/battle.tscn`

Player party:

- Knight
- Ranger
- Mage

Enemy party:

- Skeleton A
- Skeleton B
- Bone Archer

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

After victory, **CLAIM REWARD** opens the reward scene.

After defeat, **RETURN TO TABLE** goes back to the table without a reward.

**RESTART** remains available as a prototype/testing convenience.

### 4. Reward

`scenes/reward/reward.tscn`

Victory offers one of three persistent rewards:

- **Blood Coin**: +25 gold;
- **Iron Ward**: +20 HP to every hero;
- **Tempered Steel**: +3 damage to every hero.

Choosing a reward increments `deals_survived` and returns to the wizard's table.

The next battle uses the accumulated party bonuses.

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

### Run state

`scripts/core/run_state.gd`

The current prototype run state stores:

- gold;
- deals survived;
- global party HP bonus;
- global party damage bonus;
- last battle result.

This is intentionally minimal and exists to prove persistence across scenes.

### Encounter data

The current Graveyard Ambush composition and spawn positions are still hard-coded in `scripts/battle/battle.gd`.

Encounter Resources are not implemented yet.

## Not implemented yet

- multiple playable table cards;
- encounter Resources;
- attack projectiles/animations;
- broader ability/status-effect system;
- meaningful gold spending;
- equipment;
- richer evil wizard presentation;
- finite run structure / run-end screen;
- deck building;
- meta progression;
- save/load.

## Immediate next milestone

Locally verify the complete first loop:

`main -> table -> Graveyard Ambush -> battle -> reward -> table`

Confirm that **Iron Ward** and **Tempered Steel** affect the next battle and that the table counters persist.

Once this works, Phase 2 should continue with multiple playable card encounters and a short finite run rather than further expanding the combat sandbox.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
