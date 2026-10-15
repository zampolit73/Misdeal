# Misdeal — Canonical Working Handoff
Updated: 2026-10-15 (D184, approved combat art, loader staged; #37 not live).

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first. This file is the only canonical next-chat handoff. Historical notes remain archived via `docs/INDEX.md`.

## Current milestone

**D153 / «Театр оборванных нитей» is live in source as card #36 of 45**, registered in `RunState.ACT1_CARD_IDS` for the ordinary Tier1 deal pool. The original crowned bone Puppeteer + two skeletal Marionettes, 25-frame animations, approved card image and theatre battle arena, local 32%/285px ThreadTether and revised D176 stats remain unchanged. User Godot screenshot already confirmed **54/54 D176 post-tune FUNCTIONAL PASS** (solo/duo/trio mean HP 74/67/74%, worst 39/15/37%). User previously confirmed the real battle→reward→table route and later responded `пока все ок` after stronger stats.

D180 also updated D151/D152/D153 dev QA scripts that previously rejected anything other than 35 cards.

## Release verification — complete

User's in-engine screenshot shows **`D153 / ACT 1 RELEASE — PASS`** from F6 `res://scenes/dev/threadbare_theatre_release_smoke.tscn`. It checks 36 unique cards, D153's controlled Tier1 offer/selection/encounter routing, Fate Spread completion, and boss XIII after 12 resolutions. It does **not** simulate a new battle or claim statistical random-deal coverage. Earlier D178 native 54/54 combat PASS and real battle→reward→table report are preserved. **No reason to request the same F6 again without a regression.**

## Current next step — D182 card #37: selected concept and image option 3

**User chose** gameplay idea #1 `Чёрная переправа` (dead boatman + two unique drowned enemies, telegraphed wave strip that pushes/slows), and then the **third rendered** card illustration (diagonal pier, ferryman high/right, drowned low/left, one moonlit ruin). User replied «ок». This fulfills D168 concept selection; **don't re-run art concept choices**. Exact approved image variant 3 is installed in GitHub as `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64`. Isolated card-art F6 `res://scenes/dev/black_crossing_card_preview.tscn` **PASS**: user sent screenshot and replied «утверждено». The original 1604×981 image is `лунная_переправа_мертвецов.png` (conversation file ID `file_00000000ffb081f5a8c40af34fc03493`). **Previous assistant mistakenly wrote the filename of option 1** while answering selection "3"; the visual user selected remains option 3. See `docs/DECK_EXPANSION_D182_BLACK_CROSSING.md` for source detail and export hash.

Candidate `resources/cards/black_crossing.tres` exists but is deliberately **not in `RunState.CARD_PATHS` nor `ACT1_CARD_IDS`**; its future encounter does not yet exist. Don't activate #37. User has now **approved Ferryman B (ragged cloak) and Drowned C (torn clothes)** and then twice approved the resulting independent animation source sheets. D184 source-derived 96px cell assets exist locally with decoded-WebP structure QA, but the **actual WebP/base64 files are NOT YET COMMITTED** due to local-container→GitHub upload limitations. New D183-only strict loader and gallery `scenes/dev/black_crossing_animation_preview.tscn` are committed and intentionally fail without these files. **Do not request gallery F6 yet.** First finish stray-pixel cleanup, transfer exact new assets into GitHub, verify 25/25 and 5 blank cells remotely, then native F6. See `docs/D184_BLACK_CROSSING_ATLASES.md`. After that, separate arena, waves, 54 cases and real reward/table. **Live pool remains 36/45.**

## After release QA

Begin original Act1 card #37 (8 more after it) toward 45. Apply D143 **real new combat enemies**, D167 **scene-led card illustrations**, D168 **show three actually rendered different art variants before choice**, DS2 / Fate Spread 12+sealed XIII. Avoid global combat changes and reworking accepted D151–D153 visuals or mechanics. Use connected GitHub directly; user should only need `git pull` and an F6 check.
