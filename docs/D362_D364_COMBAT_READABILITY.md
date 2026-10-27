> **Release status:** [PR #29](https://github.com/zampolit73/Misdeal/pull/29) merged as `002948799d4662053701c85b8e217f4e13924c79`. [Godot 4.7.2 CI](https://github.com/zampolit73/Misdeal/actions/runs/40516027761) **SUCCESS**, 51/51 GUT, native Battle D291 smoke PASS. Manual F5 subjective quality acceptance, 12+XIII and separate RELEASE matrix **not completed**.

# D362–D364 — combat readability pilot (2026-10-27)

**Scope:** targeted presentation pass on the existing `Battle` / `BattleUnit` world; tactics, battle timings, encounters, enemy target AI, arena paintings, DS3 layout, 12+XIII and Fate Spread all remain unchanged. This pack is not a new combat system.

## Code changes

- **D362** `scripts/battle/target_preview.gd`: original `ЦЕЛИ: ВКЛ/ВЫКЛ` still reveals every *precombat* opening intent exactly as before; **hovering a miniature** now shows just that unit's target, even after Fight. Precombat focus uses actual `get_preview_target()`; during a battle focus reads `unit.target` without retargeting AI. A restrained thin intent arrow and 2 boot-level oval markers are visual-only. Redraw capped at ~20 Hz; no input interception.
- **D363** `scripts/battle/unit.gd`: real HP loss still occurs immediately at the original attack; damage **received by heroes** is now crimson and damage received by enemies warm bronze. Existing green healing numbers stay unchanged. Ranged traces show a straight headed shaft with ~0.21s fade, not a fake independently simulated projectile.
- **D364** `scripts/battle/unit.gd`: on **actual positive support-heal amount**, the caster sends a short faded bronze-green link to the healed ally, and a shallow floor ring briefly marks the ally; existing healer status `ЗВОН!` and +HP number still run. No floating heal lines if no HP was recovered.
- `tests/unit/test_d362_combat_target_focus.gd`: 2 GUT cases for bulk off/hover mode and live target selection/dead filtering.

## Godot local manual acceptance (pending)

Run `git pull`, normal F5, visit three real Act I fights as offered (no debug forcing). Keep 1280×720:

1. **Железная стена** (`iron_wall`): hover an ally during preparation; see its real target and subtle foot marks; switch to ОХОТА and inspect again. Start Battle, hover same ally; focus should follow *live* current target. Existing 3–5 tacticals and Fight must remain clickable.
2. **Последний звон** (`last_bell`): two bellkeepers cast *genuine heals* between real allies. Link must connect correct source and recipient, +HP only when it healed; combat should remain fast. Avoid constant neon and excess particles.
3. **Расстрельная площадь** (`firing_square`): four archers produce straight directed shooting accents, not crooked arrows. Player received damage appears red and enemies received damage bronze; counts/HP unchanged.

For each, check real Battle → Reward → Table, occasional zero-damage/kill transition, sound, leg contact, FPS and no warnings in Output. Capture one battle screenshot/video of each. **Godot CI validates scripts but cannot certify subjective readability**.

## Release gates

Godot 4.7.x import and GUT / native smoke on PR, then merge with docs updated. The separate manually dispatched `release` authored battle/animation matrix and the full human A1P3 F5 12+XIII run remain open. No factual claim that either is complete.
