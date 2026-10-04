# Misdeal — Project State

Last updated: 2026-10-04

## Current status

Misdeal is in the first playable prototype stage.

The base autobattle plus restart flow have been run locally by the user and are confirmed working.

Pre-battle drag placement is implemented and confirmed working locally.

Combat-time unit separation is implemented and confirmed working locally.

Hit/death feedback is implemented and confirmed working locally.

Unit combat stats are data-driven through `UnitData` Resources and the refactor is confirmed working locally.

Mage splash damage is implemented and pending local verification.

Bone Archer keep-distance behavior is implemented. Local testing exposed that combat movement had no arena bounds; hard combat bounds are now added for all units and the fix is pending local verification.

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

The current encounter composition and spawn positions are defined in `scripts/battle/battle.gd`, while unit combat stats are stored in reusable `UnitData` Resources.

Player party:

- Knight
- Ranger
- Mage

Enemy party:

- Skeleton A
- Skeleton B
- Bone Archer

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
- ranged units can define a minimum range and retreat when enemies get too close;
- all combat movement is clamped to the visible arena;
- a ranged unit that reaches the arena edge stops trying to retreat through the boundary and continues attacking;
- units attack automatically on individual cooldowns;
- Mage attacks deal 50% splash damage to nearby secondary enemies;
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

Unit definitions are data-driven through `scripts/data/unit_data.gd` and `.tres` files under `resources/units/`.

Current unit resources:

- `resources/units/knight.tres`
- `resources/units/ranger.tres`
- `resources/units/mage.tres`
- `resources/units/skeleton.tres`
- `resources/units/bone_archer.tres`

`battle.gd` still defines the temporary test encounter composition and spawn positions.

Current relevant files:

- `project.godot`
- `scenes/main/main.tscn`
- `scripts/main.gd`
- `scenes/battle/battle.tscn`
- `scenes/battle/unit.tscn`
- `scripts/battle/battle.gd`
- `scripts/battle/unit.gd`
- `scripts/data/unit_data.gd`
- `resources/units/*.tres`

## Not implemented yet
- attack animations and projectiles;
- broader ability/status-effect system;
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

Locally verify that Bone Archer retreats at close range without leaving the arena or dragging the rest of the fight off-screen, and that Mage splash damage can hit clustered enemies.

If both read clearly in play, Phase 1 has enough combat variety for the first vertical slice and development should move into the minimal card/table → combat → reward → table loop.

The long-term target remains:

`table -> card -> combat -> reward -> table`

## Local workflow

The browser-side assistant edits the GitHub repository.

The user keeps a local clone and normally updates with:

`git pull`

`UPDATE_MISDEAL.bat` is also present as a one-click pull helper.
