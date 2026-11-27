# Cinematic Travel V5 · Merchant batch (native review candidate)

2026-11-27, baseline production commit `5ed3a4362bc18c38ec96bca9c501469a77573e44`.
F6-open `scenes/dev/travel_merchant_v5_preview.tscn`; Z/X selects location, Left/Right legal outcome, 1/2/3 size, Q/E exact composition, J toggles Jack (Ranger only), R/Space replay, P pause, H hide controls, M mute. All seven nonempty hero combinations.

| Location | Authored states | Blocking |
| --- | --- | --- |
| Candle Seller | Ivory/red/blue candle consumed according to knight/ranger/mage, leave all three intact | Merchant at left edge of right counter, party approaches from left |
| Blood Ledger | Gold, blood, erased record, closed ledger when refusing | Scribe at right edge of left desk, existing book-state painting, party moves right to left |
| Gravedigger Shop | Existing sword/arrow/stone tray patches, leave intact | Merchant at right edge of stall, actual buyer leads from right |

Four distinct painted NPC cels per location, normalized to 540 px silhouette height in a 640 px cell; lossless WebP atlas and local linear filtering. Identity drawn from existing scene art; retain D412 pixel-art heroes, real companion and common projection from Forge V5. 6.6-second local timeline, transaction at 3.22, deterministic camera, feet/shadows and distance-aware gait. Merchant stands at accessible counter edge; no walking through the counter. Distinct state transitions, not bespoke finger-grasp or fully interpolated movie footage. Review-only; no F5 route, save, combat, UI, reward or RNG changes, no edits to original art or approved forge. All other 23 campaign scenes remain V4 until acceptance.

## Evidence
- Godot 4.7.2 isolated headless smoke: `godot --headless --script res://scripts/dev/travel_merchant_v5_smoke.gd`: 66 legal contexts, 10,544 checks, 0 failures. Covers actual party/companion, selected state, stable stature and soles, route, direction, camera coverage, deterministic reset.
- Reviewed offline layout composites of actual extracted props, new NPC cels and D412 poses at stop position; NPCs moved to counter edges to avoid dwarfed appearance behind tall furniture.
- Native preview motion and aesthetic acceptance still required; no full campaign/regression or player-package clearance claimed. Headless preview launch passed (shutdown ObjectDB diagnostic, not a leak-free certification).
- If accepted, separately integrate actual committed contexts through production travel router with V4 fallback and run live route regression.

## Art provenance (development-only)
All new visual files are project-origin generated or source-derived; no downloaded art, dependencies, new audio or fonts. Image generation via ChatGPT, 2026-11-27, with the project's own original art at baseline as visual references:
- `assets/pixel/travel/batch_02/candle_seller/layers/base_1280.png`
- `assets/pixel/travel/batch_02/blood_ledger/layers/base_1280.png`
- `assets/pixel/travel/pilot_01/gravedigger_shop/source/original_master.png`

Generation brief: separate wide human-scale 16:9 painterly environments, same dark fantasy lighting/identity as references; no baked characters or wares, clear foreground corridor, freestanding counter at correct scale. Separate transparent four-pose full-body original NPC sheets: faceless burgundy-robed candle merchant with bandaged hand, skull-faced burgundy-clad bookkeeper with quill, grey-bearded brown-hooded gravedigger. Distinct neutral, gesture, presentation and acknowledgment poses; maintain costume, stature, feet and detail. Generated plates resampled once to 1280x720; foreground polygons are exact crops from these plates. NPC cels segmented by source alpha, normalized with Lanczos and packed losslessly, no pixelation or generative interpolation. Runtime JSON describes original source image names, pivots, counter polygon/depth, props and blocking. 

Prop frames are technical alpha-masked cuts of the preexisting original paintings plus original outcome patches (Candle Seller knight/ranger/mage states; Blood Ledger gold/blood/erase/leave states; Gravedigger role patches with the source_rect from layer_contract.json). Preserve depicted material and specific outcome, not newly generated merchandise art. Mask edges antialiased; shared native-size canvas registers each state at its base. No third-party intake. Exact new file hashes and local origin review in `THIRD_PARTY_ASSETS.json`. Prior original-art ledger remains part of unresolved historical audit; this development review is not a verification of all historic rights, copyright eligibility, or a release clearance. Follow LICENSE_POLICY.md before publication.
