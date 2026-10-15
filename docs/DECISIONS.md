# Misdeal — Active Design & Technical Decisions
Updated: 2026-10-15.

This file is an **active index**, not a replacement for the full decision history. The complete D001–D178 records (including intermediate and superseded numeric versions) are preserved unchanged at [DECISIONS archive](archive/2026-10-15-pre-cleanup/docs/DECISIONS.md). **Older accepted rules remain binding unless a newer decision supersedes them.** Never treat outdated "pending" text as latest project status; `docs/PROJECT_STATE.md` and code win.

## D183 — D182 selected card art accepted in native Godot

Date: 2026-10-15. Status: **native visual F6 approved; original enemy art pending**.

User supplied a screenshot from `black_crossing_card_preview.tscn` and wrote **«утверждено»**. This confirms the already selected **third** diagonal pier scene at the intended 448×274 display. Preserve this exact image. Do not conflate this with approving original combat sprites; next produce distinct Ferryman and Drowned silhouette options consistent with 96px Misdeal pixel-art units. After user chooses, package authentic 25-pose transparent atlases per role with padded frames before native gallery QA. Original arena, scoped water-wave battle and reward tests still pending. Live pool **36/45**.

## D182 — Black Crossing (#37) art option 3 and encounter direction selected

Date: 2026-10-15. **User chose the encounter and third rendered card illustration. Implementation staged, not live.**

The 37th Act1 candidate is `black_crossing` / `ЧЁРНАЯ ПЕРЕПРАВА` (Tier1): one new drowned skeletal ferryman with long boat pole plus two original drowned corpse enemies. The encounter-only mechanic is a visible timed wave surge across the broken pier lane with wind-up and modest movement push/slow (not poison, revive or puppet strings). Two authored placements, original scene art and independent 1280×720 combat arena are required. The user selected **the third of three actually rendered artwork options**: diagonal pier, master at top right, two drowned low left. Assistant incorrectly returned the first image filename on the next turn; D182 canonically binds to the **third generated variant** `лунная_переправа_мертвецов.png`. Candidate `.tres`, exact approved 448×274 option-3 WebP/base64, strict image loader and isolated F6 preview are now in GitHub; native art QA is pending and card #37 remains unregistered. Keep D143/D167/D168 visual gates and 36-card live pool. See `docs/DECK_EXPANSION_D182_BLACK_CROSSING.md`.

## D181 — D153 release smoke passed in native Godot

Date: 2026-10-15. **Confirmed by user's Godot screenshot; no further code changes needed for this gate.**

The D180 `threadbare_theatre_release_smoke.tscn` shows **`D153 / ACT 1 RELEASE — PASS`** with 36 distinct registered cards, D153 in a controlled Tier1 offer, its choice routing to the correct encounter, Fate Spread completion record and sealed boss XIII alone after 12 resolutions. D153 is released as #36/45. This deterministic fixture is not a measurement of random offer frequency nor a fresh battle simulation; D178 separately provided a 54/54 functional combat PASS. The next card (#37) has **not** been designed/approved yet. Continue to honor D143/D167/D168, showing the user gameplay concepts first and three genuinely distinct rendered image options before approving card art.

## D180 — Release Threadbare Theatre as Act 1 card 36/45
Date: 2026-10-15. **Source released; native release smoke subsequently passed (D181).**

After the user accepted the D176/D177 revised D153 encounter in principle (`пока все ок`) and asked to continue development, D153 becomes the 36th live nonboss Act1 card. Add only `threadbare_theatre` to `ACT1_CARD_IDS`; its `CARD_PATHS`, original scene art, genuinely new skeletal enemies, arena and local 32%/285px tether mechanic were already complete. Preserve existing D176 stats, the 12 + XIII run structure, approved DS2 visuals and all other encounters. Remove obsolete 35-card QA guards; introduce an F6 release smoke through the actual `RunState.get_offer_cards` / `choose_card` / `complete_active_card` path.

The native 54/54 combat matrix PASS remains valid for unchanged mechanics; it is **not** proof that the newly live card has completed post-release normal-deal QA. Never invent a Godot PASS until user checks the new `threadbare_theatre_release_smoke.tscn`.

## Foundation

- **D001–D006:** Name Misdeal; Godot 4.7.x with GDScript; card-driven cursed tabletop + compact tactical autobattler; evil wizard as host; playable vertical slice first; GitHub is technical source of truth.
- **Fate Spread:** exactly 12 resolved cards (I–XII) and a sealed XIII boss. A run can reach the boss with solo/duo/trio; current compensation parameters reside in `scripts/core/run_state.gd` (superseding old numeric balancing discussions).
- **Data/architecture:** scene/resource-driven `.gd/.tscn/.tres`; avoid speculative over-engineering and changes to unrelated encounter behavior.

## Content and visual rules

- **D143:** any added card involving combat requires genuinely new original opponents, their art and identity/mechanic; reuse of old skeletons renamed or merely recolored is not enough.
- **D167:** card illustration depicts a believable scene inside Misdeal's world, not detached unit cutouts against a blurred background.
- **D168:** show 2–3 meaningful actually rendered **art variants** (prefer 3) *before* choosing a new/replacement card illustration. Integrate only the user-approved exact image. No fake/noisy repeating AI architectural detail; Godot UI/text stays outside the bitmap.
- **D169/D172/D173:** D153 specifically uses **skeletal** marionettes, a crowned skeletal puppeteer and the user-approved crimson/moonlit ruined puppet theatre. Accepted combat sprites and arena are not to be redesigned casually. `ThreadTether` is encounter-local: 32% minion mitigation within 285px, breaks on distance or master death; no changes to global enemy damage handling.

## Current D153 gating decisions

- **D174/D175:** scripted matrix alone is functional QA, not a balance/fun or complete navigation certificate. The real D153 Reward→Table route was user-confirmed prior to D176 tuning.
- **D176:** only D153 `UnitData` received targeted stronger stats. Puppeteer 142 HP / 7.5 damage / 1.65s attack, Marionette 88 HP / 10.5 damage / 1.22s attack.
- **D177:** resource-format regression diagnosed and loadable `.tres` restored; matrix now reports exact missing resources.
- **D178:** **post-tune** native matrix 54/54 functional PASS; surviving HP mean 74/67/74%, worst 39/15/37%. No blind global buffs and no automatic D153 card #36 release from a matrix result.
- **D179 (documentation hygiene, 2026-10-15):** keep working docs concise with a single canonical handoff, archive snapshots of full prior files, avoid repeatedly prepending entire session reports. Do not delete historical decisions, approved art or potentially referenced runtime files as part of documentation cleanup.

**Release state:** 36/45 in main; D180 native release-routing smoke PASS, normal randomized-run frequency untested. See `docs/HANDOFF.md`.
