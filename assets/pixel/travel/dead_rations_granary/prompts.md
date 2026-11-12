# Scene05 local restoration — built-in image_gen

Edit target: exact user-approved granary PNG. Generated output ID `exec-4c040bcd-94ee-4339-8d81-1c0fdcfbc020`. Retain only166×180 source crop at(570,260); runtime mask is narrower and feathered3px. Full generated panorama is deliberately not shipped or displayed in gameplay. All people, straw figures, banners and architecture outside the grain-store polygon use original source pixels.

Prompt:

> Use case: precise-object-edit. Production restoration patch for an already approved Misdeal dark fantasy granary painting. Keep exact same 1672x941 composition, lighting, style, every figure, skeletal quartermaster face/hat/bone hands, desk, ledger, scale with rock, straw dummies, banners/heraldry, columns and aisle unchanged. CHANGE ONLY small barred grain storage area behind the quartermaster, original source coordinates approximately x550..735 y240..440: show the iron grille slightly opened/slid to the left inside its existing frame, revealing the existing burlap grain sacks more clearly. Keep sacks believable distinct, warm dim lantern behind, no new objects, no new symbols, no text. This is an occlusion underpaint derivative for a strictly local polygon composite, NOT a new scene or redesign. No characters may change. Return full original framing.

Coins and ledger edge are original-pixel cutouts, not generated objects. Source-specific packer records exact masks and restores no pixels from unrelated assets.


## Outcome readability correction — built-in image_gen

Fair generation `exec-976d0cc9-7548-4075-ad58-e69e653727e9`: exact approved original as edit target. Open the grain-store grille fully inside its existing frame, show distinct sacks and a torn front sack pouring pale dry grain; add an irregular grain trail around the desk onto exposed floor at x1015..1180/y710..940; add one unfolded accounting leaf over the existing ledger, dense old tally strokes without modern readable text. Preserve all people, hands, scale, straw queue, heraldry, architecture and aisle. No new furniture, glow or scene redesign. Strict source-space cropped masks in packer determine actual imported pixels; generated balance/NPC pixels are never used.

Silence generation `exec-7e66faa0-2c84-4528-8dd5-8c22822b45b8`: exact original as edit target. Keep grille shut and rigged scale unchanged. Add about12–16 dull aged gold hush-money coins at the lower-right ledger edge, some half hidden under paper; remove the incidental few original coins near the scoop and restore tabletop there. Preserve every other object, figure, text-free composition and heraldry, no sparkling/glow/extra bag. Retain only bribe and cleanup source crops, not generated panorama.

Five small crop inputs are preserved for repacking. Runtime plate positions/masks/feathering are in `pack_granary_assets.gd` and `layers.json`. Old small input patch retained as rollback; it is not the current fair opening.
