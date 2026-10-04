# Misdeal — Roadmap

This roadmap is intentionally focused on reaching a playable vertical slice quickly.

## Phase 0 — Combat proof of concept

Status: complete

- [x] Godot project boots.
- [x] Main screen transitions into battle.
- [x] Spawn 3 heroes and 3 enemies.
- [x] Automatic target acquisition.
- [x] Automatic movement.
- [x] Automatic attacks.
- [x] HP and death.
- [x] Victory / defeat detection.
- [x] Restart encounter.
- [x] Pre-battle player unit placement.

## Phase 1 — Tactical autobattler slice

Goal: make preparation meaningfully affect battle outcome.

- [x] Player can reposition party before combat.
- [x] Clear preparation phase and combat phase.
- [x] Prevent illegal placement outside the deployment zone and overlapping hero drops.
- [x] Improve combat-time unit spacing/readability with separation steering.
- [ ] Move unit definitions toward data-driven Resources.
- [ ] Add at least one distinct enemy behavior.
- [ ] Add at least one simple unit ability or combat modifier.
- [x] Improve combat feedback enough to read hits and deaths.

## Phase 2 — First complete game loop

Goal: prove the Misdeal concept outside the battle sandbox.

- [ ] Create cursed table scene.
- [ ] Present a small set of cards.
- [ ] Reveal/choose an encounter card.
- [ ] Launch combat from a card encounter.
- [ ] Resolve victory/defeat back into run state.
- [ ] Present one reward choice.
- [ ] Return to the table.
- [ ] Complete a short sequence ending in a run result.

Target loop:

`table -> card -> combat -> reward -> table`

## Phase 3 — Build identity

- [ ] Evil wizard host/antagonist presentation.
- [ ] Wizard reactions and short commentary.
- [ ] Multiple encounter types.
- [ ] More party archetypes.
- [ ] Equipment or artifacts that alter autobattle behavior.
- [ ] Curses and risk/reward cards.
- [ ] First boss encounter.

## Phase 4 — Vertical slice polish

Only after the loop is fun:

- [ ] coherent visual language for table/cards/miniatures;
- [ ] animations and impact feedback;
- [ ] sound and music;
- [ ] onboarding;
- [ ] balance pass;
- [ ] basic settings;
- [ ] save/run persistence if needed for the slice.

## Explicitly deferred

Do not prioritize these before the vertical slice works:

- large content library;
- elaborate meta progression;
- online features;
- procedural architecture for every possible future system;
- complex faction/synergy systems comparable to large auto-chess games;
- final production art.
