# D273 — Court of the Mute #39 released into Act 1 (39/45)

**Date:** 2026-10-19. **Status: RELEASED in GitHub `main`, validated by native Godot 4.7.2 ordinary-deal route.**

The user said «все ок» after F6 testing of the newly painted D271 arena. Treat that as acceptance of **D271 battlefield plus observed genuine Battle composition**, not an unsupported claim that each of the original 75 animation frames was individually artist-reviewed. The three rich D267 character identities were previously approved; the independent D272 audit confirmed **75/75 distinct exported frames have clean alpha/gutters** (minimum 3px), including six Bailiff death poses. The 27 historical source-row/merged-pose flags remain *possible source illustration motion QA notes*, not proved output-cropping defects. No identity swaps or manufactured pose repairs were made to hide warnings.

## Actual shipped change

- `resources/cards/court_of_the_mute.tres` now has `target_path = "res://resources/encounters/court_of_the_mute.tres"`.
- `scripts/core/run_state.gd` `ACT1_CARD_IDS` now contains `court_of_the_mute`, raising **38 → 39 of 45** regular cards. The card remains Tier 1 combat. The Fate Spread still has twelve resolutions + sealed XIII and is not a 39-slot map.
- Enemy roster: one Magistrate, one Scrivener, two Bailiffs with already integrated original D267 rich sprites and D262 marked-target verdict; two original formations. Local D268 encounter balance untouched.
- Actor-free user-approved D271 painted Court scene remains primary 1280×720 image at `assets/pixel/battle/arenas/court_of_the_mute_d271_painted_qa.webp.b64` (decoded SHA256 `1eb45164d9c7418fb9c459d18c0640935452266aeecbb04d1e9d7bd527af8784`). Only lower D264 stone terrace screen x40–1268, y532–710 is walkable; no changes to party, global AI, Wagers, DS2 or original D261 second card illustration.
- D273 **real ordinary-dealt-card** observer: `res://scenes/dev/court_of_the_mute_d273_release_route_runner.tscn`. Like D260, it temporarily narrows normal Tier1 candidate set *inside headless QA only* and then calls actual `RunState.get_offer_cards()` and `choose_card()`, real Battle Fight, Continue → Reward claim → Table. It does not directly set active_card_id. Ensures 39-card pool, correct role sprites, real verdict, D271 image bytes SHA, D264 bounds and resolved Fate card.
- Existing F6 native Battle gallery and D267 previews now recognize the **released** card, and Court CI migrated from the historical unreleased QA observer to this D273 authentic deal route. Historical D268 direct-QA observer remains as an archival test and should not be used as a postrelease gate.

## Official CI verification

1. [Godot 4.7.2 D273 Court native 54-case + true ordinary-deal route PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264156351) — editor import/parse, D272 75-pose alpha audit, D271 all-three rich sprite gallery, D262 six actual Court Battle setups, D271 WebP SHA and B/L/G, **54/54 functional fights**, and **ordinary Tier1 dealt** #39 → real Battle → Reward → Table. Trace: `D273_COURT_REAL_DEAL_PASS`, `D273_COURT_RELEASE_ROUTE_PASS`.
2. [Godot 4.7.2 independently reconstructed D267 original sources PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264427458) — 3 exact D267 PNG source SHA + 3 original rich atlas SHA, all 75 unique cels, normal import and historical three-character F6, confirms **Court is released into 39/45**.
3. [Pre-release independent D272 alpha margin audit PASS](https://github.com/zampolit73/Misdeal/actions/runs/39263055006) — all three original rich roles 25 frames each, 15 transparent spare cels, **minimum 3px outer alpha gutter**, 27 original-source warning markers retained. Does **not** claim human x1 full death/weapon-grip inspection.

## Postrelease compatibility checks — also GREEN

The subsequent native CI runs were re-executed after updating historically hard-coded 38-card assertions, **without changing combat behaviors or old art**:
- [Original released #38 normal dealt Battle→Reward→Table PASS](https://github.com/zampolit73/Misdeal/actions/runs/39265487917), and [original #38 54-case BattleUnit balance diagnostics PASS](https://github.com/zampolit73/Misdeal/actions/runs/39265907347).
- [Exact D261 user-selected second Court card image SHA/native preview PASS](https://github.com/zampolit73/Misdeal/actions/runs/39265495582).
- [D262 Court verdict forced-target + six real battle setups + original #38 regression PASS](https://github.com/zampolit73/Misdeal/actions/runs/39265977185).
- [D267 full source-rich 75-frame rebuild + six Court Battle starts + original #38 regression PASS](https://github.com/zampolit73/Misdeal/actions/runs/39265987091).
- [D267 separate original three-rich F6 full source reconstruction PASS](https://github.com/zampolit73/Misdeal/actions/runs/39264427458).
- Temporary red CI runs during commits between card target-path change and finished pool-migration were superseded by these completed green re-runs; they do not reflect current `main`.

These are native automated integration checks. Artistic micro-motion concerns can still be addressed from concrete future gameplay video; do not roll the card back simply because a source flag exists.

## Next steps (D274+)

- Real player run with actual dealt #39 remains worth observing for UI, animation timing, weapons/feet and verdict telegraph. In Godot, `git pull` and F6 `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` for immediate battle; actual table should now deal #39 naturally (Tier1 randomness).
- If visible Bailiff death3–5 or Magistrate/weapon-grip issues occur, repair demonstrated art defects together, keep original source PNG and transparent frame standards. Do not ask for frame-by-frame approvals.
- Begin **next unreleased card #40** as a distinct design/art encounter with genuinely original enemies; start with 2–3 real concept image alternatives before changing a new card illustration (D168), unless user chooses a different focus. Do not create an unrelated prototype vertical-slice architecture.
- Preserve D260 #38 Black Lantern Road, D261 art, D264 user-picked floor, all D267 original identities, D271 painted arena, DS2/Fate Spread and frozen KARAMBA73.
