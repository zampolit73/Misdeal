# Misdeal — Canonical Working Handoff

Updated: 2026-10-16 — D198 Black Crossing released in code as Act 1 card #37.
Source of truth: zampolit73/Misdeal main. GitHub is available to the assistant for direct reading and commits. Do not ask the user to paste code or re-explain project state. Godot 4.7.x / GDScript.
At the start of a new chat read AGENTS.md, docs/CONCEPT.md, docs/PROJECT_STATE.md, docs/ROADMAP.md and docs/DECISIONS.md.

## Current technical state

**Act 1 regular random-deal pool = 37/45.** RunState.ACT1_CARD_IDS includes:
- #34 funeral_procession — original Funeral Priest and Pallbearers; Last Rite
- #35 defiled_laboratory — original Alchemist and Homunculus; chemistry
- #36 threadbare_theatre — original skeletal Puppeteer and Marionettes; tether
- **#37 black_crossing / «Чёрная переправа» (D198 live)** — 1 Drowned Ferryman + 2 Drowned Hands, two formations and timed neutral sea surge.

The sealed Bone Warden XIII remains separate from regular deals, after 12 Fate Spread resolutions. Eight cards remain to reach 45.

**Approved Black Crossing visuals, preserve the original files:**
- Card illustration option 3: assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64 (448×274).
- Ferryman B and Drowned C original 25-pose atlases, native animation preview approved D186.
- Storm arena «Последний причал»: assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64 (1280×720), accepted D187. Do not restore deleted left rock towers/right timber frames.
- D196 storm-wave VFX is the current provisional visual baseline: user said «давай пока оставим этот. продолжай». 94px rolling breaker and runoff remain unchanged; do not restart refinements without user request.

**Combat:** D191 Godot-native 54/54 PASS after D189 floor fix, zero full-party defeats, solo/duo/trio and Knight/Ranger/Mage each 18/18/18 wins, mean HP 86/74/77%. Events: 78 warnings, 62 strikes, 66 pushes, 66 slow resets. Mechanics remain initial wait 3.2s, warning 1.4s, 43px left push, 30% slow for 1.6s, rest 4.5s. Intact pier safe bounds live in scripts/battle/black_crossing_floor.gd and apply only to this encounter.

**D197 native route confirmation:** After being instructed to run the native preflight and play real Battle → Reward → Table, user replied «Все ок». This is the explicit user confirmation. No D198 gameplay balance change needs a new 54-case matrix.

## D198 committed source release

- scripts/core/run_state.gd now contains black_crossing in the true Tier1 live deck, as card #37.
- scenes/dev/black_crossing_release_smoke.tscn and scripts/dev/black_crossing_release_smoke.gd perform the **actual 37-card pool** release audit: 37 unique cards, approved assets, original roster, 80 deterministic-seed full-pool Tier1 offers (NOT an injected two-card deck), real RunState offer/selection/Fate Spread progression and sealed XIII.
- Old D151/D152/D153, Bone Shepherd and Black Crossing smoke guards/preview labels were updated from 36 to 37. D153 remains card #36, with unchanged encounter/balance.
- No D196 VFX, battle, floor, enemy stats, or approved image resources changed for the D198 release.

## Exact next step: native release smoke

**D198 source code is live in GitHub, but native release smoke is NOT yet confirmed.**

User: run git pull, open **res://scenes/dev/black_crossing_release_smoke.tscn**, press F6. Expect **D198 / BLACK CROSSING — RELEASE PASS**, 37/45 LIVE, and evidence of ordinary full-pool Tier1 offers containing Black Crossing in 80 samples. Send PASS screenshot or error. Assistant: if it fails, fix directly in GitHub and request only a repeat F6. Do NOT claim native release PASS until reported.

Once D198 native release smoke passes: record PASS in PROJECT_STATE, ROADMAP, HANDOFF and CHANGELOG, then start concept + art-option planning for card #38. New combat cards require original enemies and mechanics (D143) and 2–3 actually rendered scene-first card art options for approval (D167/D168). No Godot/C# migration or new global architecture.

Older development evidence and design specifics: docs/D188_BLACK_CROSSING_ENCOUNTER.md, docs/DECISIONS.md, CHANGELOG.md, Git history and archive; no need to read all earlier chats.
