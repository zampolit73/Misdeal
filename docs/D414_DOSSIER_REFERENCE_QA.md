# D414 — dossier reference polish

User approved D413 and requested integration then interface refinement. PR81 and PR82 are merged into main; post-D413 main SHA `3c364bb4bbb108a5b2a8ce6e1cba18e782b487c2`. D414 starts from this exact base, on `codex/d414-dossier-reference-polish`.

The reference supplies visual hierarchy: blue specialization ribbon, selected-character marker, bronze stat icons, glowing completed development milestones, actual artifact art and a four-column party summary spanning the footer. Approved D413 paintings are unchanged. Seven tiny SVG symbols are authored vector assets; relic art comes from the existing artifact catalog. All text, counts, stats and availability remain native dynamic Controls using the original controller. Slots remain inspection-only.

`SquadDossierD414` is a focused presentation helper invoked after the existing visual refresh for both available/unavailable roles. It clears stale artifact textures and provides the original effect description in tooltips. Stat-label replacements match the whole colored label, so УРОН and УРОН/СЕК remain separate; nonbreaking spacing and explicit BBCode cell allocation preserve row alignment. Native body/stat minimum14px. Cell options follow [official Godot BBCode documentation](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html). No dependency added.

## Verification

- Local native Godot4.7.2 full GUT: **212/212**,48 scripts,47,121 assertions,29.221s. Existing19 GUT warnings; no test failures. Includes real dossier state-invariance, role/fate/build/relic/close regressions and new equipped→unavailable→equipped artifact transition test.
- Existing `scripts/dev/d285_squad_dossier_smoke.gd`: **D285_SQUAD_DOSSIER_NATIVE_PASS** (real dossier, solo stats, live upgrades/relics, segmented footer, close).
- Headless editor import: no script parse/load errors. Local certificate-store access warning and user-log filesystem errors are environmental, not fixed by this UI change.
- GUI/native `scripts/dev/d413_capture_dossier.gd`: **D413_DOSSIER_CAPTURE_PASS:3**. Real Table fixture and actual squad overlay at1280x720, all three roles inspected; stats fit without label/value wrapping. Knight fixture has executioner upgrade and Dead Man’s Shield. Long relic lists remain scrollable and full effect is available on hover.
- Screenshots: [Knight](qa/d414/knight.png), [Ranger](qa/d414/ranger.png), [Mage](qa/d414/mage.png). These are native rendered frames, not a mockup. No human F5 playthrough or full RELEASE matrix claimed.

## Player check and rollback

F5 → Table → TAB; select roles1/2/3, check portraits/stat rows, completed development glow and equipped/empty relic slots; hover artifact for full effect. TAB/Escape/X closes. F6 `scenes/dev/d413_squad_dossier_preview.tscn` provides the same fixture without touching an existing player run (separate process).

Rollback D414 by removing `DOSSIER_REFERENCE` declaration/apply/refresh calls from `scripts/table/squad_status.gd`; D413 controller/layout/art remain. No saves, resources, combat scripts or global theme modified. Unrelated local GUT imports/project.godot edits are excluded from the commit.
