# D308 — Wizard objective art preview scene (Godot F6)

## Open

1. Pull current `main` using `git -c gc.auto=0 pull --ff-only`.
2. Open the **existing Misdeal project** in Godot 4.7.x.
3. In **FileSystem**, double-click `res://scenes/dev/d308_wizard_panel_preview.tscn`.
4. Press **F6** (Run Current Scene), not F5 (normal whole game).

At the real 1280×720 viewport, the scene reuses the current Graveyard arena painting, imports the **actual** `wizard_condition_game.webp`, and invokes exactly the D307 Battle production skin helpers `_style_side_objective()`, `_install_wizard_plaque()`, `sync_side_objective()` and `position_side_objective()`. No duplicate/fake baked text is used: the original hidden `ObjectiveLabel` remains canonical and the two visible labels mirror it.

## Test controls

- **Подготовка** — check the illustrated module at bottom left, with all other elements unobstructed.
- **Бой** — move the same module to the production D306 combat position (98,165), without simulating actual combat.
- **Вариант условия** — cycle the same Russian rule samples used by the real `grave_bell`, `gallows_volley`, and `bone_crush` encounters: +15 gold, above 25% HP, finish in 16 seconds.
- **Активно / Успех / Провал** — visually inspect original and success/failure text across the artwork's distinct header and body wells, including dynamic warning color.
- **Открыть настоящий бой** — reset only this standalone test process's RunState, choose Knight + Ranger and the real Grave Bell encounter, and load `res://scenes/battle/battle.tscn`. Actual AI, movement, targeting, 3–5 tactical buttons, Wizard challenge payout and Fight are unchanged.

This tool/test scene is **not** the main scene and is not reachable from normal Fate Spread progression. `project.godot` remains untouched; existing saved project data is not modified by the isolated preview. Starting a *real test fight* resets the in-process test state, not your regular game progress. Close the F6 window and reopen it to return to the visual preview.

## QA

- `res://scripts/dev/d308_wizard_preview_smoke.gd` is included in the existing D291 Godot Actions workflow. It instantiates the exact F6 scene and checks genuine WebP import, header/body rendering, three rule variants, prep/battle positions, success/fail and real Battle-launch button connection.
- Human visual acceptance requires a local 1280×720 screenshot of this scene and (optionally) a separate actual Grave Bell combat screenshot.
- **Preview art and runtime scene have not been visually approved by the user yet.** Headless CI evidence must be read before claiming a native PASS.

Related: `docs/D303_BATTLE_MODULES_APPROVED.md`, `docs/PROJECT_STATE.md` and `docs/HANDOFF.md`.
