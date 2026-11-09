# D416 — clean tabletop behind real offers

Player screenshot exposed obsolete painted cards under the moving current card. Root cause confirmed in live GitHub `scenes/table/table.tscn`: WizardBackdrop loaded `approved_variant_c/table_exact.webp`, a legacy composite with two static face-up cards and Hold/+ labels. This is not a third offer or RunState bug.

Production change is one scene property: backdrop path → `res://assets/pixel/table/d416_clean_center/table_clean.webp`. No gameplay, card art, controller or timing changed. This branch follows D415/PR84; PR should target `codex/d415-class-select-dossier-art` until PR84 merges. D414 remains separate PR83.

## Asset production and rollback

Built-in `image_gen` mode, precise-object-edit; no CLI/API key. Generated full-source PNG retained at `assets/pixel/table/d416_clean_center/source.png`. Recipe `scripts/dev/d416_pack_clean_table.gd` downsamples the source to1280x720, composites only Rect2i(380,316,520,340), feathers8px at its boundary and saves lossless WebP. Entire original surroundings (Wizard/hands/candles/logo/side piles/HUD) are decoded-pixel identical, protected by four SHA256-region comparisons. Initial export incorrectly used lossy mode; the regression detected it, export was corrected before commit. Original image remains untouched; rollback is the original scene path. Existing peripheral baked labels/masks are outside this focused repair.

Final prompt supplied to built-in imagegen:

> Edit this exact1280x720 game background. Surgical object removal only: erase the TWO illustrated face-up encounter cards painted in the middle lower table (roughly x390..890 y360..640), and erase both small cyan-outlined УДЕРЖАТЬ buttons and the two small red plus-diamond markers immediately above them (x455..840 y325..365). Inpaint those objects completely with the same aged dark wooden/black leather tabletop and coherent thin red occult ritual circle continuing the existing perspective, crescents and scratched sigil lines. The entire center table must be EMPTY of cards and interface, showing only the convincing continuous table and subdued red ritual markings. Preserve EVERYTHING ELSE EXACTLY: wizard, hands/fingers, background castle, curtains, candle groups, skull, cups, untouched left and right deck piles, logo and existing top UI, deck labels. Do not add text, new cards, symbols, buttons, props or decorative clutter. Preserve original composition, pixel/paint texture and contrast, native1280x72016:9 layout. This is removing accidentally baked gameplay cards from a runtime background, not redesigning the artwork. Output just the edited background.

## Native verification

- Godot4.7.2 import: no script parse/load errors.
- Full native GUT: **212/212**,48 scripts,47,116 assertions,36.191s; existing19 warnings.
- New regression: live backdrop path, native dimensions, four untouched-region SHA256 equality checks and changed central pixels. Focused1/1,10 assertions.
- D289 actual Table smoke PASS: exactly two live offers, true counters, Hold/Squad/Fate/Wager controls preserved. Existing shutdown2 ObjectDB/1 resource diagnostics remain; Windows certificate-store diagnostic also unchanged.
- Native GUI `scripts/dev/d416_capture_clean_table.gd`: **D416_CLEAN_TABLE_CAPTURE_PASS**. Actual Table with deterministic lost_purse/whispering_well offers, live cards temporarily hidden solely for QA to expose the restored background, hover, choice-animation frame and actual selected event route. Runtime capture has no script errors. No human F5 playthrough/full RELEASE matrix claimed.
- [Exposed table](qa/d416/exposed_table.png), [two offers](qa/d416/two_offers.png), [hover](qa/d416/hover.png), [choice motion](qa/d416/choice_motion.png), [actual event](qa/d416/selected_event.png). Existing brief fade/movement of the rejected LIVE card is intentional and unchanged; static painted duplicates are removed.

Player check: F5 new run → choose/hover either offer and watch it move to center. Behind it should be only the restored ritual table. Actual rejected-card motion, side deck/discard piles and real counters remain.
