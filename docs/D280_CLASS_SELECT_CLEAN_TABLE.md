# D280 — Three forgotten fates on a clean table

Status: implemented; Godot 4.7.2 native asset/scene/interaction regression PASS: https://github.com/zampolit73/Misdeal/actions/runs/39318175090. Native user visual acceptance OPEN.

## Root cause fixed

D279 and D279R reused a fully baked finished table screenshot as ClassSelect background. Old HUD, two encounter cards, Hold and fake counters appeared beneath the new selectable hero cards. D279R only masked these. D280 removes baked screen UI entirely, using a separate clean image.

## Art asset

- Newly prepared dark-fantasy painting of the seated Wizard above an empty red sigil circle; skull, bronze table, candles, banners and moonlit castle remain. NO embedded cards, text or UI.
- Godot source: assets/pixel/class_select/d280_clean_table_01..04.webp.b64, exactly ONE 640x360 WebP reconstructed at runtime (11,320 bytes; SHA256 8005eca284768611b923cdf8b87f9a8f4db0554dd4a7e4d6277925c27a6d93fe).
- Renderer: scripts/class_select/class_select_clean_backdrop.gd, caches one ImageTexture. 640x360 source stretches to the 1280x720 logical UI. Consider higher-resolution copy after screenshot evaluation; avoid fabricated polished-quality claims.

## UI state

- Real logo top left and subdued heading around Y42-85; Wizard one-line comment around Y243-283.
- Three D278-framed 272x338 original v7 portraits Y292-630; idle shows archetype and quote, hover/selected shows HP & damage from live UnitData .tres.
- Separate confirm at Y640-682: selection can be changed before RunState.choose_protagonist is invoked. Keyboard left/right and Enter retain intended behavior.
- Removed TopHeaderPlate, TopRightCover, FateSpreadCover, FateTitle, OldOfferObscurer. Old concealing shader is no longer used by this scene.

## QA

Godot workflow reconstructs all four ordered Base64 parts, verifies exact SHA and WebP signature, imports project and checks independent clean background texture, absence of cover nodes, three real D278 hero cards, source stats, hover/exit, switching choice and confirmation with exactly one Mage in RunState. Native CI is green but the user must visually judge the result at 1280x720; particularly judge source resolution/clarity, character/title spacing, confirmation contrast and table atmosphere.

No changes to actual production table/gameplay, Fate Spread I-XII/XIII, existing Act1 39/45, run modes, balances, art catalog or approved class portraits.

## D281 — D280 blurred backdrop formally superseded

User's screenshot shows severe 2× blur plus opaque logo backing. **The 640×360 / 11,320-byte asset and four Base64 fragments documented above were removed** and must NOT be reused. Now: `assets/pixel/class_select/d281_clean_table_hd.webp` exact **1280×720** WebP (168,948 bytes; SHA256 `7464edde5990b53a6d1ec8d1646e96080c9944be0a4a79e04bdba6689d5f28e1`), made directly from the already generated 1672×941 source. New RuntimeWebpTexture on WizardBackdrop at native resolution; no D280 loader. `shaders/class_select_logo_key.gdshader` handles only legacy logo's dark matte. Original portrait cards, the Wizard text, real hover stats, solo confirmation and production Table unchanged. Official Godot 4.7.2 native image integrity and scene interaction PASS: https://github.com/zampolit73/Misdeal/actions/runs/39320810866. Still needs native user's acceptance after `git pull`.


## D282 — Final UI chrome pass (2026-10-20)

User approved the overall D281 sharp 1280×720 full-HD tabletop/three card composition and requested a LAST UI-only pass. Code commit [`8c66148f`](https://github.com/zampolit73/Misdeal/commit/8c66148f075da4fed0043c38228d25c5abe51deb) modifies only `scenes/class_select/class_select.tscn`, `scripts/class_select/class_select_card_skin.gd` and QA. No generated art, shader background, character resources or mechanics changed.

- Title: reduce opaque `TitleVeilStyle` from alpha .66 to .29, line-bronze top/bottom, faint shadow.
- Wizard line: rehome to `WizardCaption` subtle antique panel Y98–136; actual line Y103–131, away from hand/card seam. Same reactions/data.
- Cards: add passive `SelectionRim` Panel after independent `IllustratedFrame`; gilt 2px on hover vs 3px stronger gold on selected role; keep source stats and description toggle, other cards dim.
- Confirm: use small passive top/bottom edge accents and thicker lower brass bevel, subdued until a hero is selected, no change in input logic.
- Footer: fine translucent `FooterHintPlate`, caption at 13pt / Y688–711.

Official Godot 4.7.2 asset/import/scene/hover/select/deselect/confirm and solo-run regression PASS: https://github.com/zampolit73/Misdeal/actions/runs/39322918562. **Native user screenshot and final artistic sign-off pending.** Check original card image exposure, readability, header dominance, selected highlight, footer at 1280×720; then stop micro-polishing once accepted.
