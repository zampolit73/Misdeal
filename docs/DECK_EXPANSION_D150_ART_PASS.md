## D150 — 2026-10-14 — BOTH ORIGINAL EVENT WEBPs IN MAIN; LOCAL F6 VISUAL PREVIEW VERIFIED

**User supplied real Godot F6 screenshot** of `res://scenes/dev/deck_expansion_d150_art_preview.tscn`: two distinct 448×274 full-bleed card illustrations display under «ЛУННАЯ ПЕЧАТЬ» and «СКЛЕП ОТЗВУКОВ», both with green `D150 • оригинальный WebP найден`. Both images visually display with no baked title/buttons/card frame and fit the gallery. The assistant reviewed consistent painterly cold blue moonlit / warm candle DS2 imagery with accepted Bone Shepherd reference; **user has not yet explicitly written a separate artistic approval**. Source of truth checked in GitHub `main`: actual binaries `assets/pixel/card_unification_v1/run/moon_seal.webp` and `echo_crypt.webp` EXIST, and both `resources/cards/{moon_seal,echo_crypt}.tres` `art_path` fields point to them. This **supersedes D150 earlier installer/binaries-pending passages below**. D149 event flows were separately reported by user to run correctly; all other campaign/12+XIII/balance behavior was not exhaustively checked. **No further image installation or git push required.** Remaining backlog: first normal win→reward→table end-to-end screenshot for Bone Shepherd and eventual new cards (33/45), with novel enemies/AI/art for every new fight per D143. D142 HUNT/duo balance still unresolved.

---

# D150 — Two original card illustrations for D149 event pair

**Date:** 2026-10-14
**Status:** two actual full-bleed raster card images prepared, image loaders/QA scene committed to GitHub, **binary images not yet pushed**; local Godot F6/user visual QA pending.

## Confirmed starting state

The user reported D149's isolated F6 pair-of-event flows «все отработало» after running `deck_expansion_d149_event_preview.tscn`. Record as user-confirmed runtime success; do not claim exhaustive 12+XIII campaign test or screenshot evidence for each effect. Previous D148 native Shepherd 54/54 smoke and accepted preview art stay unchanged.

D149 added `moon_seal` (Tier0) and `echo_crypt` (Tier1); deck is 33/45 planned nonboss cards (12 + sealed XIII per run). The original D149 artworks were **temporary approved-art aliases**, not new art.

## D150 distinct scene images (not UI mockups)

Created two individual cinematic dark-fantasy images from scene-only regions of a freshly generated two-card moodboard, cropped and verified to **448×274**, original WebP:

- `assets/pixel/card_unification_v1/run/moon_seal.webp` — giant weathered, silver-crescent funerary seal chained in a dark moonlit cemetery; restrained candles, warm bronze against cold blue; SHA256 `9a252626a428e6bb428cdee8d6de3b41bc7c52c7e468987f0793c0cbd325ab7c`, 54,216 bytes.
- `assets/pixel/card_unification_v1/run/echo_crypt.webp` — ancient gothic chapel/reliquary and funerary offerings with antique bronze/candlelight; SHA256 `0f49f3849b99dc0bbe770127140d29632cf1d455c4ade0d738fa3ea17dc9a6a9`, 53,920 bytes.

These are standalone image textures without captions, controls or frames, unlike the generated composite sheets. Source comparison to D147-approved card still requires local user acceptance. Neither image is claimed to be artist/user-approved before that visual QA.

## GitHub integration — code already committed

- `scripts/ui/card_unification_v1.gd`: D150 card IDs now map to new independent WebP filenames. If files are absent/invalid, **safe fallback** loads old `whispering_well.webp` for Moon Seal and `gravedigger_shop.webp` for Echo Crypt. No old approved asset is modified.
- `scripts/dev/deck_expansion_d150_art_preview.gd`, `scenes/dev/deck_expansion_d150_art_preview.tscn`: isolated 1280×720 gallery for both event cards. Displays explicit `D150 original WebP found` vs temporary art status, no `RunState` modification.
- Game card Resource `art_path` keys remain on known-good D149 fallback WebPs **until** the two binary images are installed. The installer switches these two card Resource paths only after verifying/copying the actual WebPs.

## Binary installer packaged in conversation, not yet in main

Created conversation download **`Misdeal_D150_Event_Art.zip`** (includes two WebPs, SHA manifest, installer, README). It is the same one-click Windows PowerShell/Git pattern as D147, updated to avoid overwriting existing divergent files, reject dirty target paths, pull `main` ff-only, validate SHA256, set local Git identity only if missing, patch exactly two matching `.tres art_path` lines, commit and push two binary files plus their two Resource path references. The local user has their Git identity configured after D147.

**IMPORTANT:** Until the user runs this installer and Git push succeeds, do not claim the D150 textures are in `main`, do not confuse code commit with binary delivery. In normal gameplay, the fallback art will display safely in the meantime.

## Next user action

1. Download `Misdeal_D150_Event_Art.zip`, unpack, double-click `install.cmd` (defaults to `%USERPROFILE%\\GodotProjects\\Misdeal`). Script performs `git pull`/copy/path-switch/commit/`git push`.
2. Open `res://scenes/dev/deck_expansion_d150_art_preview.tscn` and press F6. Both cards should report `D150 • оригинальный WebP найден`. Compare to the accepted Bone Shepherd art, check subjects/lighting, no baked text and fit.
3. If approved, confirm visual quality. If not, redraw source **art only**, preserve D149 gameplay mechanics.
4. Once the binary commit is confirmed, update project docs to mark imported/QA result and use GitHub to continue. Do not request repeated technical steps.

## Invariants and future work

Never touch approved DS2/Fate Spread C layouts, old Wave1 files, Bone Shepherd/Whistle animations/AI, combat numbers, 12-card run count, Wizard meddling, or HUNT/duo tuning in the D150 art pass. Remaining expansion goal: **12 more** cards to 45; combat-containing cards **must have entirely new enemy roles and original art/mechanics** per D143. D148 real battle→reward→table remains separate outstanding QA.
