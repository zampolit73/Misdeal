# D415 — protagonist choice in the dossier style

User explicitly requested the dossier hero paintings and allowed refinement of the shown protagonist-choice window. Independent branch `codex/d415-class-select-dossier-art`, base GitHub main `3c364bb4` (approved PR81 and PR82 merged). D414 remains independent PR83; no dependency on its helper or SVGs.

Exact existing D413640x480 thumbnail WebPs supply the three portraits, with smooth display filtering and248x180 image wells. Shared approved panel bitmap supplies a NinePatchRect border with `draw_center=false`, resized once to384x256 with the same corner margins as the dossier. No image generation, new art approvals or source bitmap changes. Old v7 art/frame/shader retained for rollback.

Dark caption wells replace pale parchment; bronze borders replace the old pale inner strips. Serif class names/heading/flavor/confirmation match the dossier. A burgundy ВЫБРАН seal stays visible after mouse exit, while hover alone never displays it. Nonselected cards dim moderately; existing rim/scale feedback retained. All captions fit inside the bronze frame, all three portraits remain readable. Keyboard guidance describes existing Left/Right/Enter behavior.

Gameplay changes: none. Only one presentation-helper call added in the controller. Existing unit-derived HP/damage, copy, Wizard reactions, two-step selection, solo start, confirm guard/timing and SceneRouter unchanged. Existing272x338 choices/background/logo/header/footer placement preserved. New decoration ignores mouse input.

## Local Godot4.7.2 results

- Editor import: no script parse/load errors.
- Full GUT: **211/211**,47 scripts,47,106 assertions; existing19 warnings. This branch is based on main, so it does not include PR83's extra test.
- Expanded `scripts/dev/d279_class_select_smoke.gd`: **D282_CLASS_SELECT_PASS**. Exact source paths, native size/filter and decoded portrait pixels checked; original live stats, hover without mutation, persistent selected seal, reversible choices, keyboard arrows and explicit solo Mage confirmation checked. UI frame assertion updated from old TextureRect to actual center-transparent NinePatchRect.
- Native GUI `scripts/dev/d415_capture_class_select.gd`: **D415_CLASS_SELECT_CAPTURE_PASS**. Captures actual initial scene and all three selected roles, then actually confirms and waits for production Table with exactly `[mage]`. Five actual1280x720 frames inspected; no composited mockup or claimed human F5 playthrough.
- Existing Windows root-certificate-store error remains environmental. Capture process reports5 ObjectDB instances at shutdown after the real route; no script/runtime errors during interaction. No unrelated cleanup or combat changes attempted.

## Evidence and player check

[Initial](qa/d415/initial.png), [Knight](qa/d415/knight.png), [Ranger](qa/d415/ranger.png), [Mage](qa/d415/mage.png), [actual confirmed Table](qa/d415/confirmed_table.png).

F6 `scenes/class_select/class_select.tscn` or F5 new run: inspect three portraits; hover shows true base HP/damage, click retains selection after mouse exit, arrows switch, Enter/button confirms only once. Verify one selected hero reaches Table, other companions remain unjoined. CI runs original class-choice smoke and the new native capture/confirmation route for ClassSelect visual changes.

Rollback the D415 scene/card-skin/controller changes; preserved old v7 portraits, D278 frame and parchment shader remain available. Player local project.godot/GUT import edits are excluded.
