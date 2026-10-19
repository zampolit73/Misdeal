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

## Verified official Godot CI

[Native Godot 4.7.2 complete D279 smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39312723690), after `dd72b1c`: parses/imports real ClassSelect, instantiates the actual 3 UI Buttons with existing textures and transparency, validates all three `.tres` HP/damage readouts, hover/exit, multiple role selections **without starting a run**, then presses the actual confirmation button and validates the exact selected SOLO Mage in RunState. This is real native interaction QA, not an artistic screenshot. User acceptance at 1280×720 remains pending.


## D279R visual correction prompted by user's screenshots — NOT a final background replacement

**Observed visual FAIL after D279:** wizard had HUD at the top from the background art plus custom title at center, with an old visible Fate Spread button and two ghost encounter cards between the three protagonist cards. User sent actual screenshots before/after clicking. Root cause: `approved_variant_c/table_exact.webp` is a finished table UI concept **with old UI baked in**, not an empty scene; a former `table_wizard_layer.png` preview also has old combat UI baked in. Godot node tests did not reveal this.

Implemented immediate ClassSelect-only concealment:
- `TopHeaderPlate`: x334..947 y19..111 hides old HUD/WizardLine, now hosts "Кем ты был..." and dynamic Wizard commentary without covering the face at y160..260.
- `TopRightCover`: x1091..1247 y19..71 covers baked "ОТРЯД TAB"; a noninteractive small emblem replaces the false gameplay button.
- `FateSpreadCover`: x496..784 y241..287 hides stale Fate Spread button behind class-choice-specific label.
- `OldOfferObscurer` (`shaders/class_select_brocade_cover.gdshader`): x345..936 y313..676, near-opaque dark red textured occult brocade and soft edge; it hides old illustrated offer-card/hold UI behind our three live cards, no flat huge window.
- `scripts/dev/d279_class_select_smoke.gd` asserts all concealment nodes and layering dimensions in addition to all prior source stat/RunState interaction checks.

Official native 4.7.2 Godot CI: https://github.com/zampolit73/Misdeal/actions/runs/39315102093 and https://github.com/zampolit73/Misdeal/actions/runs/39315252479 PASS. A real **new** Godot screenshot is still necessary to verify no leak through card gaps, no oversize top title, and no accidental hard-edged brocade rectangle. In the long term author/approve a true clean-tableplate illustration with no baked UI, as mandated by DS2. **No newly generated candidate background has been committed as the game's approved art.** No impacts to Table screen, Fate Spread I–XIII, Act1 39/45, protagonist mechanics or approved D278 cards.


## D280 supersedes D279R stopgap

Production screen now uses a separate 640×360 clean ritual table illustration with no baked old gameplay. The masks introduced in D279R have been removed. Source-backed hero stats, click/select/confirm and art kept. Read docs/D280_CLASS_SELECT_CLEAN_TABLE.md. Godot 4.7.2 passed CI; native user artistic signoff still pending.
