# MISDEAL — Development Guide

## Product
Misdeal is a dark-fantasy card-driven roguelike with a compact autobattler.

The player sits across from an evil wizard who controls a cursed game table. Exploration is represented by cards. Combat encounters resolve as short tactical autobattles.

Core loop:
1. Reveal / choose a card.
2. Resolve an event.
3. If combat: inspect enemies and arrange the party.
4. Run a short autobattle.
5. Receive consequences and rewards.
6. Continue the run.

## MVP direction
Build the smallest playable vertical slice first:
- card/event flow;
- one combat encounter;
- 3 player units vs 3 enemies;
- pre-battle placement;
- automatic targeting, movement and attacks;
- win/lose state;
- reward screen;
- return to the table.

## Tech
- Godot 4.7.x
- GDScript only
- Prefer text-based .gd, .tscn and .tres resources.
- Avoid third-party addons unless explicitly approved.
- Keep systems data-driven with Resources where practical.

## Code rules
- Use typed GDScript where it improves clarity.
- Prefer small focused scripts over one large manager.
- Use signals for cross-system communication when appropriate.
- Avoid hard-coded content values when they belong in data resources.
- Keep file and node names in English.
- Keep code comments concise and useful.
- Do not introduce networking, ECS, dependency injection frameworks, or premature abstractions.

## Project structure
- scenes/ — Godot scenes
- scripts/ — gameplay code
- resources/ — unit/card/item/encounter data
- assets/ — art/audio/fonts
- docs/ — game and technical notes

## Art direction
Dark fantasy, cursed tabletop, theatrical evil wizard, tactile cards and miniatures. The prototype may use simple shapes and text; gameplay clarity comes first.

## Current priority
Make a playable prototype before polishing visuals.
