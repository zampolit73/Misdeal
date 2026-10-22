# Misdeal — D337 new-chat handoff (2026-10-22)

**Source of truth**: GitHub `zampolit73/Misdeal` branch `main`. On new chat read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` and this handoff.

## Latest user approval

User previously selected **FIRST** image from actual Gallows Volley triptych (top wide panel «Крепостная виселица»), then ordered `заливай в гит` and reiterated `у тебя есть доступ к гиту` and `Можешь проверь и сделай`. GitHub access VERIFIED. Do NOT recreate new concepts, ask for permissions, or rely on old messages claiming GitHub unavailable. Exact choice is chat file `gallows_volley_option_1.png` 1535×473, attachment ID `file_00000000e9388246b9c97ecfcda8ec39`. It shows wooden gallows atop ruins, center shield-and-sword skeleton, left and right skeletal bowmen, mist, red wall pennant, minimal firelight, castle at far right. The active **448×274** image `assets/pixel/card_unification_v1/run/gallows_volley_d337_approved_option1.webp` derives from the original crop `(320,0)-(1093,473)` (not new painting), Lanczos Q85, SHA256 `b273fce130e5ed7425bafff525972e1959f65387765f7fa26da4a6822b48550e`. Focus crop omits most far-left banner and far-right castle but preserves ALL 3 characters and the central gallows.

`scripts/ui/card_unification_v1.gd` binds `RUN_CARDS["gallows_volley"]` to the new WebP. Prior `run/gallows_volley.webp` is retained as rollback. `scripts/dev/d315_card_ds3_smoke.gd` checks exact SHA, WebP size and live catalog image equality. Game encounter `resources/cards/gallows_volley.tres` unchanged (one skeleton front, two archers). No UI/DS3/card text/combat balance change.

## Frozen prior decisions

D336 `graveyard_ambush` user-attached first approved scene (two fighters + archer), D335 `bone_ritual` third approved pixelated priest, D333 `bone_patrol` sparse watchtower/valley, D331 `blood_ledger` skeletal scribe and `bone_crush` second breach gate, D319 `black_altar` third selected painting. D328 one-frame Card DS3 + approved centered optically aligned card text and true illustration colors stays frozen. Other assets may still use older legacy art. Avoid artificial clutter, redundant candles and overly busy designs. Gameplay: 12 Fate resolutions plus sealed XIII, two-offer table, tactical autobattler Godot 4.7.x GDScript.

## Next validation and next art

After D337 commit verify GitHub files and actual Godot native D315/D316 CI where available. User only needs `git pull`, F6 `scenes/dev/d315_card_ds3_gallery.tscn`, visually check «ЗАЛП С ВИСЕЛИЦЫ» at real size. If the crop is aesthetically unsatisfactory, adjust only framing of same approved art after user feedback, not new concept. For the next as-yet-unapproved card, follow D168: present **three actual image previews in chat**, wait for selection, then export the exact selected art directly to GitHub and update docs. Preserve clean checkpoint.
