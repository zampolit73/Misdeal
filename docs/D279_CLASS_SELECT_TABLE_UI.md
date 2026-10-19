# D279 — Select a forgotten fate on the cursed table

Scope: real ClassSelect screen UI only. Technical implementation in `3d6476ba3b7fe7bea2568d4610f80485147ea4c4`; native CI and visual review have separate gates.

## User approved UX

- Use the final restrained three-card table art direction, actual approved cursed tabletop `assets/pixel/table/approved_variant_c/table_exact.webp`, dark-red/bronze/warm parchment colors, not the old near-black 1140×622 menu plate.
- Three original Knight/Ranger/Mage v7 portraits are independent real texture controls; frame comes from the exact D278 transparent `table_offer_frame_asset.gd` and parchment shader. Never replace portraits with newly generated unsanctioned art.
- Idle shows class name, role and evocative one-liner, no full stat row; hover/selected toggles the dedicated HP and damage readout, using actual `UnitData.max_hp`/`damage` from the three `.tres` resources.
- Hover lifts and reveals the class-specific one-line Wizard comment. Left click selects and highlights a class; this must never start a run. Another card can be selected to change your mind. Separate crimson `ПРИНЯТЬ ЭТУ СУДЬБУ` confirms and only then `RunState.choose_protagonist(role)` and original `SceneRouter` to Table.
- Keyboard Left/Right changes selected class; Enter confirms only if chosen. Other two characters are NOT automatically recruited; their fates remain encounter-driven.

## Code

- `scenes/class_select/class_select.tscn`: full Variant C background, visible title and Wizard comment without giant modal, HBox of three full-size (272×338) live Buttons, disabled-until-selected confirm, companion reminder.
- `scripts/class_select/class_select_card_skin.gd`: material-only presentation; actual D278 cached transparent frame, existing paper shader, uncropped source v7 art image control, bronze/paper caption, hover stat plate and reactive selection-border/CTA.
- `scripts/class_select/class_select.gd`: scene ownership; source stats from original `.tres` objects, role/hover comments, persistent selection and explicit commit. Unused legacy unit-atlas loader remains intact for backwards compatibility.
- `scripts/dev/d279_class_select_smoke.gd` and `.github/workflows/d279-class-select.yml`: official Godot native scene import, asset decode, three-card node contract, hover/idle, source stat values, multiple selection changes, guard against early RunState mutation.

## Review gate

After `git pull`, launch a new run at 1280×720 and capture normal three-card screen and hover/selected examples. Check no overlap with wizard hands/title, screen/CTA fit, original approved images and readable long Russian text. Try each class, switch selection before confirmation, inspect actual HP/damage 150/18, 90/14, 80/24, and verify confirmation goes to Table with chosen SOLO hero only. Keyboard Left/Right/Enter should work. Godot CI technical PASS does not mean the user has approved the artistic integration.

Keep Act1 at 39/45, `RunState` alone determines hero stats/party and no story-only Act I intrigue is implemented by this pass.
