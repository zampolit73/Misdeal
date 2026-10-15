# Misdeal — Canonical Working Handoff
Updated: 2026-10-15 (D181, Act1 #36 native release smoke PASS).

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first. This file is the only canonical next-chat handoff. Historical notes remain archived via `docs/INDEX.md`.

## Current milestone

**D153 / «Театр оборванных нитей» is live in source as card #36 of 45**, registered in `RunState.ACT1_CARD_IDS` for the ordinary Tier1 deal pool. The original crowned bone Puppeteer + two skeletal Marionettes, 25-frame animations, approved card image and theatre battle arena, local 32%/285px ThreadTether and revised D176 stats remain unchanged. User Godot screenshot already confirmed **54/54 D176 post-tune FUNCTIONAL PASS** (solo/duo/trio mean HP 74/67/74%, worst 39/15/37%). User previously confirmed the real battle→reward→table route and later responded `пока все ок` after stronger stats.

D180 also updated D151/D152/D153 dev QA scripts that previously rejected anything other than 35 cards.

## Release verification — complete

User's in-engine screenshot shows **`D153 / ACT 1 RELEASE — PASS`** from F6 `res://scenes/dev/threadbare_theatre_release_smoke.tscn`. It checks 36 unique cards, D153's controlled Tier1 offer/selection/encounter routing, Fate Spread completion, and boss XIII after 12 resolutions. It does **not** simulate a new battle or claim statistical random-deal coverage. Earlier D178 native 54/54 combat PASS and real battle→reward→table report are preserved. **No reason to request the same F6 again without a regression.**

## Current next step — D182 card #37: selected concept and image option 3

**User chose** gameplay idea #1 `Чёрная переправа` (dead boatman + two unique drowned enemies, telegraphed wave strip that pushes/slows), and then the **third rendered** card illustration (diagonal pier, ferryman high/right, drowned low/left, one moonlit ruin). User replied «ок». This fulfills D168 concept selection; **don't re-run art concept choices**. Artwork is prepared as local WebP but **not yet in GitHub**: recover `лунная_переправа_мертвецов.png` (conversation file ID `file_00000000ffb081f5a8c40af34fc03493`) and export art to GitHub safely. **Previous assistant mistakenly wrote the filename of option 1** while answering selection "3"; the visual user selected remains option 3. See `docs/DECK_EXPANSION_D182_BLACK_CROSSING.md` for source detail and export hash.

Candidate `resources/cards/black_crossing.tres` exists but is deliberately **not in `RunState.CARD_PATHS` nor `ACT1_CARD_IDS`**; its future encounter does not yet exist. Don't activate #37. Build image/preview, then genuinely original unit sprites, separate combat arena and scoped telegraphed water-surge mechanics; native art QA, 54 cases and real reward/table before release. **Live pool remains 36/45.**

## After release QA

Begin original Act1 card #37 (8 more after it) toward 45. Apply D143 **real new combat enemies**, D167 **scene-led card illustrations**, D168 **show three actually rendered different art variants before choice**, DS2 / Fate Spread 12+sealed XIII. Avoid global combat changes and reworking accepted D151–D153 visuals or mechanics. Use connected GitHub directly; user should only need `git pull` and an F6 check.
