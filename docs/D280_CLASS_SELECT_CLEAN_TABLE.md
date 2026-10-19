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