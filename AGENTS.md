# MISDEAL — Development Guide

## New-chat bootstrap

**D152 ACTIVE 2026-10-15:** new Defiled Laboratory local hazards have a user-confirmed isolated Godot F6 PASS. D152 original role atlases have been repacked as 576×480/25-frame local QA PNGs, but binaries are available ONLY via the conversation ZIP and are NOT tracked in GitHub; two new F6 art/real-battle scenes and encounter-scoped hazard wiring are committed, native validation pending. Test-only card registered in `CARD_PATHS`, NOT in `ACT1_CARD_IDS`; live pool remains **34/45**. Download/extract the ZIP under ignored `assets/local_previews/d152/` for F6 QA (Git pull alone does not deliver artwork). Do not ship the card without approved card art, tracked production atlases, and 54-case real fight+reward QA. Read [`docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md`](docs/DECK_EXPANSION_D152_DEFILED_LABORATORY.md) and [`docs/NEXT_CHAT_HANDOFF.md`](docs/NEXT_CHAT_HANDOFF.md) for current details. D151 54/54 isolated PASS remains valid; its normal reward/table navigation is still unverified. This paragraph supersedes older instructions implying D152 is only data or that its art was already committed. GitHub write access is connected; do not ask again.\n
**Latest canonical restart snapshot:** [`docs/NEXT_CHAT_HANDOFF.md`](docs/NEXT_CHAT_HANDOFF.md), with long-form context in [`docs/SESSION_HANDOFF_2026_10_15.md`](docs/SESSION_HANDOFF_2026_10_15.md) and verified native QA in [`docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md`](docs/DECK_EXPANSION_D151_FINAL_SMOKE_QA.md). **LATEST 2026-10-15: D151 Funeral Procession is live card 34/45, user screenshot in Godot shows FINAL 54/54 PASS (54 wins/0 losses; 58 Last Rite warnings, 38 revivals, 14 buffs). Previously-freed target crash is no longer reproduced in latest F6 run; old crash/pending notes are historical.** Original D151 art/facing accepted. Smoke is **not** balance certification (100% wins) and **not** full fight→reward→table confirmation; those remain separate later QA. Preserve 12+XIII, D143 original enemy/art requirement for remaining 11 cards, DS2/Variant C, unresolved D142 tactics. GitHub access is connected: implement and commit yourself, do not ask again. This latest statement overrides older pending instructions in prior documents.

GitHub is the source of truth for the current technical state of Misdeal.

At the start of a new chat, before proposing architecture or code changes, read:

1. `AGENTS.md`
2. `docs/CONCEPT.md`
3. `docs/SESSION_CHECKPOINT.md` (short, current restart brief)
4. `docs/PROJECT_STATE.md`
5. `docs/ROADMAP.md`
6. `docs/DECISIONS.md`
7. `docs/HANDOFF.md`
8. `docs/VISUAL_ASSET_REGISTRY.md`
9. `docs/DESIGN_SYSTEM.md` (when working on UI or visual presentation)
10. `docs/UNIT_ANIMATION_PACK1.md` and `docs/UNIT_ANIMATION_PACK2.md` (when working on unit art or animation)

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
- when connected GitHub tools are available in the session, use them directly;
- do not claim GitHub write access is unavailable without first checking the connected repository/tool state;
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

For UI work, extend the existing `scripts/ui/misdeal_ui_kit.gd` and follow `docs/DESIGN_SYSTEM.md`. Do not restyle approved game screens solely to unify components; validate against actual 1280×720 Godot screenshots.

The prototype may still use simple shapes and text where needed, but new player-facing art should move toward one coherent pixel-art language.

## Current priority

Make a playable vertical slice before polishing visuals.

Do not change the fundamental game design without discussing it with the user first.
