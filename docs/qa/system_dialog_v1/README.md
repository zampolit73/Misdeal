# System Dialog V1

[Player-approved concept](../../../assets/source_archive/system_dialog_v1/approved_reference.webp) — approved 2026-11-26.

- Both production confirmations now use a shared native Control in `scripts/ui/system_dialog.gd`; no default ConfirmationDialog windows remain in production. Existing Main Menu V2 textures and serif type are reused, with nine-slice corners and a scrim over the actual scene.
- New Game asks only when a save or Memory Glass exists. «Новый забег» preserves the collection; «Начать с нуля» resets it; both retain the Archive and original backup behavior. Cancel changes neither run nor memory.
- Return to main menu retains the current checkpoint warning and existing router. Escape cancels only the confirmation before leaving pause; safe Cancel initially owns focus, navigation wraps inside the three/two buttons, focus returns to the opener. Single dispatch prevents duplicate button callbacks.
- Godot 4.7.2 targeted headless regression: **16/16 tests, 321 assertions**, including save service and live Table/Battle pause. [Log](godot_targeted.log).
- User screenshot (2026-11-26): all wrapped labels were measured at zero width, inflating the title/message/subtitle/note rectangles before the authored width took effect. Reproduced headless (14 failed layout assertions), fixed with explicit line breaks/no automatic wrapping; the authored rects and all visible lines now pass after two process frames in both dialogs. Regression: **17/17 tests, 349 assertions**. [After-fix log](godot_layout_fix.log).
- Native 1280×720 capture: **NOT RUN locally** (Xorg could not establish listening sockets). Existing release capture `scripts/dev/run_save_capture.gd` now captures `new_game_confirmation.png` and `return_to_menu_confirmation.png`, and exercises the real reset button. Native CI/player visual acceptance remains pending.

## Player check
F5 with an existing save: open New Game; confirm both descriptions, cycle focus and cancel with Esc. In a run, Esc → «В главное меню» → Esc should return to pause, a second Esc to the run. Test destructive actions only with a disposable save/backup.
