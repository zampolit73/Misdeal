# Pilot Batch01 V3 — unified native review

Actual Godot4.7.2/NVIDIA GL Compatibility1280×720 frames from real Event→Resolution→Travel→Table at2.5s. [Contact sheet](contact_sheet.png) is assembled from these eleven native frames, not package previews. Row-major order is the numbered filenames.

| Scene | Native final frames |
|---|---|
| last_signal | [truth](01_last_signal_truth.png), [salvage](02_last_signal_salvage.png), [passed](03_last_signal_passed.png) |
| gravedigger_shop | [knight](04_gravedigger_shop_knight.png), [ranger](05_gravedigger_shop_ranger.png), [mage](06_gravedigger_shop_mage.png), [leave](07_gravedigger_shop_leave.png) |
| lost_purse | [safe](08_lost_purse_safe.png), [greedy](09_lost_purse_greedy.png), [all_in](10_lost_purse_all_in.png), [untouched](11_lost_purse_untouched.png) |

All11 actual routes passed in one native batch. Shop prices35/30/45 and successful role-specific upgrades checked once; saved outcome remains bought. Signal debt/gold gating and purse15/35/55gold plus0/−10/−25HP preserved. Double choice/Continue/Skip did not repeat effects. State snapshot stays unchanged during travel; visual fields are absent from saves. Moments0.6/1.3/2.5/3.8, pause, early/middle/late skips and natural completion covered. Actual party subsets include solo/duo/trio. Four additional action frames were inspected locally.

Full GUT294/294,73,983 assertions,19 existing warnings; new pilot2/2,1,461 assertions covering11actions×7non-empty party subsets, soles, state isolation, pause, single finish and old-save/invalid-role fallback. Existing core/save tests pass. No final artistic acceptance or human random full-run claim.

Limits: all_in artwork retains the corpse hand although unchanged resolution mentions a piece of hand. Do not silently add gore/change text. Combined route fixture retains6 baseline ObjectDB instances at shutdown; final native pass has no script/shader/assertion errors. Fresh Windows import reports the pre-existing unused assets/concepts/approved_battle_direction.jpg decoder warning; protected image unchanged. New V3 PNG resources load correctly. Final required CI is authoritative.

F6 scenes/dev/travel_pilot_batch01_playtest.tscn: left/right cycles11outcomes;1/2/3party;P pause;R replay;normal skip. ONE unified final user review; do not auto-merge.
