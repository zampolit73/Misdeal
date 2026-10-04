# MISDEAL — Development Guide

## New-chat bootstrap

GitHub is the source of truth for the current technical state of Misdeal.

At the start of a new chat, before proposing architecture or code changes, read:

1. `AGENTS.md`
2. `docs/CONCEPT.md`
3. `docs/PROJECT_STATE.md`
4. `docs/ROADMAP.md`
5. `docs/DECISIONS.md`

For implemented code and current project state, prefer GitHub over remembered chat context.

Do not ask the user to repeat information that is already captured in these files.

At the end of a meaningful development session, leave the repository in a state from which another fresh chat can continue without reading the full conversation history.

## Product

Misdeal is a dark-fantasy card-driven roguelike with a compact tactical autobattler.

The player sits across from an evil wizard who controls a cursed game table. Exploration is represented by cards. Combat encounters resolve as short tactical autobattles.

Core loop:

1. Reveal or choose a card.
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
- Prefer text-based `.gd`, `.tscn` and `.tres` resources.
- Avoid third-party addons unless explicitly approved.
- Keep systems data-driven with Godot Resources where practical.

Do not migrate to C#/.NET without an explicit project decision.

## Code rules

- Use typed GDScript where it improves clarity.
- Prefer small focused scripts over one large manager.
- Use signals for cross-system communication when appropriate.
- Avoid hard-coded content values when they belong in data resources.
- Keep file names, node names, class names, resources and code in English.
- Keep code comments concise and useful.
- Do not introduce networking, ECS, dependency injection frameworks, or premature abstractions.
- Optimize for a playable vertical slice, not hypothetical future scale.

## Working with the user

The user runs Godot locally and pulls changes through Git.

When the user explicitly asks to implement or fix something:

- inspect the current GitHub code first;
- make the changes directly in the repository when possible;
- do not make the user manually copy code that can be committed;
- use meaningful commit messages;
- after the change, tell the user only what they need to do locally, normally `git pull`, run the project, and what to verify.

When an error is reported, inspect the current repository before suggesting manual edits.

## Documentation maintenance

After a substantial implementation:

- update `docs/PROJECT_STATE.md`;
- update `docs/ROADMAP.md` when priorities or completed milestones change;
- record important technical or game-design decisions in `docs/DECISIONS.md`;
- update `CHANGELOG.md`.

`docs/PROJECT_STATE.md` must describe what actually exists in the repository, not intended future behavior.

## Project structure

- `scenes/` — Godot scenes
- `scripts/` — gameplay code
- `resources/` — unit/card/item/encounter data
- `assets/` — art/audio/fonts
- `docs/` — game and technical notes

## Art direction

Dark-fantasy pixel art, cursed tabletop, theatrical evil wizard, tactile cards and readable tactical miniatures.

Combat readability comes before detail: units must be recognizable by silhouette, team color is secondary, and UI should not overpower sprites.

Use nearest-neighbor presentation for pixel assets. Avoid mixing realistic painted unit portraits into the combat field.

The prototype may still use simple shapes and text where needed, but new player-facing art should move toward one coherent pixel-art language.

## Current priority

Make a playable vertical slice before polishing visuals.

Do not change the fundamental game design without discussing it with the user first.
