# Misdeal — Active Roadmap
Updated: 2026-10-15. **Live Act 1: 35/45.** Current technical status: `docs/PROJECT_STATE.md`.

## Completed / established

- [x] Playable table → event/combat → reward → table loop and boss/Fate Spread structure (12 + sealed XIII).
- [x] Solo, duo and trio protagonists/companions, tactical autobattle and party-size compensation.
- [x] DS2 / Fate Spread Variant C visual baseline, multiple approved battle arenas and character-animation production passes.
- [x] Act 1 pool expanded to **35** cards; D151 and D152 released with original enemies, encounter-specific mechanics and card art.
- [x] D153 original **skeletal** puppeteer / bone marionettes, approved sprites/card/ruined-theatre backdrop; local `ThreadTether` and real battle→reward→table QA.
- [x] D153 D176 localized challenge pass and D177 fix. D178 **54/54 in native Godot**, 74/67/74% average remaining HP (solo/duo/trio).

## Next steps (in order)

1. [ ] Obtain brief **updated D153 real-battle feel signoff** (revised stats); focus especially on duo's 15% worst case. Do not rebalance globally just to optimize a metric.
2. [ ] If accepted, add `threadbare_theatre` to `RunState.ACT1_CARD_IDS` **as card #36/45** and update any testing code that assumes QA-only 35. Verify it appears in the normal randomized offering and that Reward → Table and 12+XIII progress remain stable.
3. [ ] Continue original Act 1 expansion from **36 toward 45**, delivering new combat enemies, artwork, arenas and F6 QA in small vertical increments.
4. [ ] Continue real-run solo/duo/trio and boss progression regression tests, preserving no-regression gates for D151/D152.

## Rules for all subsequent phases

D143 (new enemies for every new fight-bearing card), D167 (world-scene card art), D168 (three user-selectable image variants first), accepted DS2, game-specific Godot 4.7.x/GDScript. Keep details of completed phases in `docs/archive/2026-10-15-pre-cleanup/docs/ROADMAP.md`; don't repaste historical milestones onto this active roadmap.
