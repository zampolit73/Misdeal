# Misdeal — Active Design & Technical Decisions
Updated: 2026-10-15.

This file is an **active index**, not a replacement for the full decision history. The complete D001–D178 records (including intermediate and superseded numeric versions) are preserved unchanged at [DECISIONS archive](archive/2026-10-15-pre-cleanup/docs/DECISIONS.md). **Older accepted rules remain binding unless a newer decision supersedes them.** Never treat outdated "pending" text as latest project status; `docs/PROJECT_STATE.md` and code win.

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

**Release state:** 35/45 until a user-approved live difficulty check and normal-deal test; see `docs/HANDOFF.md`.
