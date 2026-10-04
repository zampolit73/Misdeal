# Misdeal — Project State

Last updated: 2026-10-04

## Current status

Misdeal is in the first playable prototype stage.

The base autobattle plus restart flow have been run locally by the user and are confirmed working.

Pre-battle drag placement is implemented and confirmed working locally.

Combat-time unit separation is implemented and confirmed working locally.

Hit/death feedback has now been implemented in GitHub and is pending local verification.

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

Before combat, the player can drag Knight, Ranger and Mage within the blue deployment zone.

Placement rules currently implemented:

- only player units are draggable;
- units are clamped to the allowed deployment area;
- heroes cannot be dropped on top of another hero;
- placement is disabled when combat begins.

Pressing **FIGHT** starts combat.

Implemented combat behavior:

- units automatically find the nearest living enemy;
- melee and ranged units use different attack ranges;
- units move toward targets when out of range;
- units attack automatically on individual cooldowns;
- nearby living units apply separation steering so they do not occupy the same point;
- taking damage produces a brief hit flash, scale pulse and floating damage number;
- death produces a short shrink/fade animation;
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

Locally verify hit flashes, floating damage numbers and death feedback.

After combat readability is confirmed, move unit definitions toward data-driven Resources and then start connecting the battle prototype to the first minimal card/table → combat → reward → table loop.

The long-term target remains:

`table -> card -> combat -> reward -> table`

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
