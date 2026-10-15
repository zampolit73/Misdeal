# Misdeal

**Dark-fantasy card-driven roguelike + compact tactical autobattler**, played across a cursed game table hosted by an antagonistic wizard.

Each run resolves **12 cards** in the Fate Spread, with the Bone Warden as sealed central card **XIII**. You choose a protagonist (Knight / Ranger / Mage), may recruit or permanently lose the other two, face events and bargains, deploy a small party, pick tactical orders, survive short automatic combats, take rewards and return to the table.

## Current state (2026-10-15)

- **Playable Godot 4.7.x / GDScript prototype**, not just a starting combat demo.
- **35 live Act 1 cards** in the ordinary pool (target **45**); the boss is separate.
- Original battle arenas, unit animations, interface design system 2.0 / Fate Spread Variant C, special encounters and event flows.
- **D153 / Театр оборванных нитей:** user-approved theatre art + bone puppeteer/marionettes, encounter-only tether mechanic, real battle/reward route already tested; post-tune matrix **54/54 functional PASS**. **Not yet a live #36 card** until final release check.
- Current implementation and next action: [Project State](docs/PROJECT_STATE.md) · [Active Roadmap](docs/ROADMAP.md) · [Handoff](docs/HANDOFF.md).

## Run locally

1. `git clone https://github.com/zampolit73/Misdeal.git` (or update existing checkout with `git pull`).
2. Open `project.godot` in **Godot 4.7.x** and run the main scene.
3. For the isolated D153 challenge test, run current scene (F6): `scenes/dev/threadbare_theatre_playtest.tscn`. For seeded 54-case technical combat QA: `scenes/dev/threadbare_theatre_battle_smoke.tscn`.

## Developer entry points

Read [AGENTS.md](AGENTS.md) before changing the project. [Documentation index](docs/INDEX.md) lists active docs, historic archives, unit-art references and design rules. Existing `assets/*.webp.b64` art packages are intentional Godot runtime data; don't delete them as apparent build artifacts.
