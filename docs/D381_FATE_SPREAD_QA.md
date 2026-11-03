# D381 — Fate Spread dynamic/reference layering fix

**Trigger:** User's actual Godot F5 capture at **4/12 resolved / 4 discarded / 0 held**, 1280×720, exposed a doubled upper readout, a too-tight phase/first Roman line, overlapping old painted card edges around V/VI, and an incorrect baked **V** over the **sixth** future slot. The bitmap `assets/pixel/table/fate_spread/fate_spread_exact.webp` is the locked/approved art and must NOT be replaced or touched as a wallpaper.

## Root cause

The approved painting already contains example counters, scene-specific card artwork and Roman numerals, including a **wrong V instead of VI** over the future sixth placeholder. Runtime `fate_spread_overlay.tscn` overlays real RunState cards, numbers and summaries on that reference. The existing `HeaderMask` was 96%-opaque, so old example numbers remained visible; per-card masks were smaller than painted cards; dynamic slot coordinates, masks and ritual thread math were derived from **three separate coordinate sets**, risking obvious misregistration.

## Changes (no gameplay or art change)

- `scripts/table/fate_spread_geometry.gd`: one 1280×720 scene-local reference layout for **I–XII**. Card geometry matched to physical painted slots, including sixth card alignment. Keep XIII seal in its approved center.
- `scripts/table/fate_spread_overlay.gd` uses geometry for live cards/Roman labels; the correction label **VI** is visible ONLY until the sixth card becomes a live card, then the dynamic Roman VI takes over. The **V** numeral is placed left of its card rather than on IV's physical title plate. Long tiny titles are fitted to a single ink line.
- `scripts/table/fate_spread_reference_cleanup.gd`: wider matching rotated masks fully replace baked example cards/numerals; a small explicit mask hides only the wrong painted sixth V for future slots.
- `scripts/ui/card_ds3_skin.gd`: for **miniature Fate slots only**, the one-line title rectangle now sits entirely inside the original parchment stripe (instead of spilling into the black footer); size 8→7→6 is selected based on measured text width, ellipsis as last resort, and the full title remains available on hover. XIII retains its existing two-line boss title. The approved frame image is unchanged.
- `scripts/table/fate_spread_seal_visual.gd`: ritual lines connect the same real physical slot anchors rather than a separate approximated ellipse.
- `scenes/table/fate_spread_overlay.tscn`: header mask is fully opaque (not 0.96); phase moves above the I tab; added small Roman VI on sixth reference placeholder.
- CI: production `ci3_capture_rendered_scene.gd` renders real overlay with the real `RunState` at **four** and **eight** resolved cards; smart QA selects both screenshots automatically for changes to `scripts/table/` and `scenes/table/`, as well as release mode; GUT regression `test_d381_fate_spread_layout.gd` covers the shared twelve-slot layout, opaque header and VI handoff.

## Review after `git pull` and F5

1. At exactly **4 resolved / 4 discarded**, press `R` to open the detailed Fate Spread. The heading should contain only one readable `ДО КОСТЯНОГО НАДЗИРАТЕЛЯ: 8 КАРТ`, one live `ПРОЙДЕНО/ОТВЕРГНУТО/УДЕРЖАНО` line and one quiet `V–VIII` phase caption; no ghost example stats or collision with Roman I.
2. Check the **fifth active card V**, underlying **future VI** and adjacent IV, VII. No visible doubled old gilt frame around the live card; Roman **V** must NOT sit on IV's title plate; tiny titles must stay inside the parchment stripe rather than overflow as a second dark line. The sixth future placeholder now reads **VI** (the approved bitmap itself incorrectly reads V). No new future card identities appear.
3. Continue to step VI, VIII and eventually XII/XIII: only a single Roman VI per card, hover history still works, R/ESC closes, XII and the central chained XIII remain exactly in their original progression and position.
4. Verify Held/Discard remain on their original panels; no change to hero cards, combat, economy, memory facts, audio or actual route order.

**Acceptance:** Native CI verifies parse, tests, live screenshot capture; it is NOT a replacement for user's F5 visual signoff. All DS3 card paints remain approved.
