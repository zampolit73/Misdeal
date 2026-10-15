# Misdeal — Canonical Working Handoff
Updated: 2026-10-15 (D180, Act1 card #36 source release).

Read `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md` first. This file is the only canonical next-chat handoff. Historical notes remain archived via `docs/INDEX.md`.

## Current milestone

**D153 / «Театр оборванных нитей» is live in source as card #36 of 45**, registered in `RunState.ACT1_CARD_IDS` for the ordinary Tier1 deal pool. The original crowned bone Puppeteer + two skeletal Marionettes, 25-frame animations, approved card image and theatre battle arena, local 32%/285px ThreadTether and revised D176 stats remain unchanged. User Godot screenshot already confirmed **54/54 D176 post-tune FUNCTIONAL PASS** (solo/duo/trio mean HP 74/67/74%, worst 39/15/37%). User previously confirmed the real battle→reward→table route and later responded `пока все ок` after stronger stats.

D180 also updated D151/D152/D153 dev QA scripts that previously rejected anything other than 35 cards.

## Immediate native verification

**User:** `git pull` and F6 `res://scenes/dev/threadbare_theatre_release_smoke.tscn`. It should display **`D153 / ACT 1 RELEASE — PASS`** for unique 36 cards, actual `RunState` Tier1 offer/choice/encounter, resolution recorded in Fate Spread and boss XIII gate. This uses a deliberately restricted two-card Tier1 fixture, **not** random multi-run offer frequency and **not** a battle simulation. Native D180 test **not yet executed**; no PASS claim.

A quick normal main-game Tier1 deal and D153 battle/reward check is useful after the smoke, and may reveal routing regressions not covered by the fixture. When confirmed, update `PROJECT_STATE`, `ROADMAP`, `CHANGELOG`/this handoff as concise new status (D179 hygiene).

## After release QA

Begin original Act1 card #37 (8 more after it) toward 45. Apply D143 **real new combat enemies**, D167 **scene-led card illustrations**, D168 **show three actually rendered different art variants before choice**, DS2 / Fate Spread 12+sealed XIII. Avoid global combat changes and reworking accepted D151–D153 visuals or mechanics. Use connected GitHub directly; user should only need `git pull` and an F6 check.
