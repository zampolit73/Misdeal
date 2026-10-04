# Misdeal — Project State

Last updated: 2026-10-04

## Current status

Misdeal is in the first playable prototype stage.

The current build has been run locally by the user and the first autobattle plus restart flow are confirmed working.

## Engine

- Godot 4.7.x
- GDScript
- Main scene: `res://scenes/main/main.tscn`
- Rendering method: GL Compatibility
- Prototype resolution: 1280×720

## Implemented flow

### Main screen

`scenes/main/main.tscn`

The project boots into a simple Misdeal title screen.

Pressing **ENTER THE GAME** transitions to:

`res://scenes/battle/battle.tscn`

### Test autobattle

The current encounter is hard-coded in `scripts/battle/battle.gd`.

Player party:

- Knight
- Ranger
- Mage

Enemy party:

- Skeleton A
- Skeleton B
- Skeleton C

Pressing **FIGHT** starts combat.

Implemented combat behavior:

- units automatically find the nearest living enemy;
- melee and ranged units use different attack ranges;
- units move toward targets when out of range;
- units attack automatically on individual cooldowns;
- units have HP and visible health bars;
- dead units become inactive and visually faded;
- battle detects victory and defeat;
- result text is displayed;
- **RESTART** reloads the encounter.

Core unit logic lives in:

`scripts/battle/unit.gd`

## Current architecture

The prototype intentionally uses a minimal architecture.

Unit stats and the test encounter are currently hard-coded in `battle.gd`. This is acceptable for the first combat proof of concept, but content should move toward Godot Resources as the vertical slice grows.

Current relevant files:

- `project.godot`
- `scenes/main/main.tscn`
- `scripts/main.gd`
- `scenes/battle/battle.tscn`
- `scenes/battle/unit.tscn`
- `scripts/battle/battle.gd`
- `scripts/battle/unit.gd`

## Not implemented yet

- pre-battle unit placement;
- unit collision/separation;
- attack animations and projectiles;
- abilities and status effects;
- data-driven `UnitData` resources;
- encounter resources;
- card/table gameplay;
- evil wizard presentation;
- rewards;
- equipment;
- run state;
- deck building;
- meta progression;
- save/load.

## Immediate next milestone

Add meaningful pre-battle tactical preparation, beginning with player unit placement before **FIGHT**.

After that, connect the combat prototype to the first minimal card/table → combat → reward → table loop.

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
