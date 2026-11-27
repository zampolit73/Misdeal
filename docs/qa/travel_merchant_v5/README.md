# Cinematic Travel V5 · Merchant batch (native review candidate)

2026-11-27, baseline production commit `5ed3a4362bc18c38ec96bca9c501469a77573e44`.
F6-open `scenes/dev/travel_merchant_v5_preview.tscn`; Z/X selects location, Left/Right legal outcome, 1/2/3 size, Q/E exact composition, J toggles Jack (Ranger only), R/Space replay, P pause, H hide controls, M mute. All seven nonempty hero combinations.

| Location | Authored states | Blocking |
| --- | --- | --- |
| Candle Seller | Ivory/red/blue candle consumed according to knight/ranger/mage, leave all three intact | Merchant at left edge of right counter, party approaches from left |
| Blood Ledger | Gold, blood, erased record, closed ledger when refusing | Scribe at right edge of left desk, existing book-state painting, party moves right to left |
| Gravedigger Shop | Existing sword/arrow/stone tray patches, leave intact | Merchant at right edge of stall, actual buyer leads from right |

Four distinct painted NPC cels per location, normalized to 540 px silhouette height in a 640 px cell; lossless WebP atlas and local linear filtering. Identity drawn from existing scene art; retain D412 pixel-art heroes, real companion and common projection from Forge V5. 6.6-second local timeline, transaction at 3.22, deterministic camera, feet/shadows and distance-aware gait. Merchant stands at accessible counter edge; no walking through the counter. Distinct state transitions, not bespoke finger-grasp or fully interpolated movie footage. Review-only; no F5 route, save, combat, UI, reward or RNG changes, no edits to original art or approved forge. All other 23 campaign scenes remain V4 until acceptance.

## Prop polish 02 (after player review, 2026-11-27)

Player accepted the character/object proportions and routes, but reported remnants of the old bookkeeper's hands and inconsistent candle styling. Replaced all 17 prop state textures with new isolated painterly art in the lighting of their existing locations. No old hands, cloth patches or table fragments. Preserve the meaningful action states (ivory/red/blue candle consumed; neutral/gold/blood/erase/closed ledger; sheathed/exposed sword, quiver arrow rearrangement, rune-stone colour). Same logical canvas aspect, one common scale and bottom registration per item; dimensions 2x or 3x prior canvases. Corrected the tabletop y contacts by 9–25 px using the actual plate surfaces, without moving actors, changing stature, paths, timing, camera or world projection. Local soft contact shadows under each prop; small warm surface-light pools only beneath lit candles, extinguished for the selected candle after 3.22 s. Unchanged approved forge and all production routes.

Current evidence: Godot 4.7.2 isolated targeted smoke PASS, 66 contexts / 11,870 checks / zero failures. Added exact state-canvas, contact-pivot and consumed-candle light checks. Offline alpha/scale checks PASS for all 17 files; data diff confirms only prop anchor y changes. Inspected native-size offline composites of the actual old and new plates/props before and after selected outcomes. Headless F6 launch completed; previously documented exit ObjectDB warning persists, not a native-render or leak-free certification. Native player visual review of the three scenes is still pending.

### Prop-polish provenance
Source: ChatGPT image generation, 2026-11-27. Inputs exclusively the current project plates and previous prop files from commit `9cd15e47ae9a5a8d4d32cebcc4e9635c91591266`, in `assets/pixel/travel/cinematic_v5/merchant_batch/<id>/{plate,prop_*}.webp`. No downloaded material, fonts or dependencies.
- Candle Seller: create transparent 3x2 sheet, lit ivory/dark burgundy/smoky blue-grey medieval wax candles in matching aged blackened bronze saucers; second row corresponding extinguished wax pools; natural muted colour and chapel light, no fabric scraps or hands. Generated `exec-1b02cf6a-c389-4479-9c34-d49c1601efe7.png`, SHA-256 `0be371492e2210243ec0573db9bba8e3fabc7ee1a6e1387cede966b05b0e9975`.
- Blood Ledger: transparent 2x3 sheet, five states of same ancient leather ledger, restrained parchment, ribbon and brass dish: neutral open, gold and wax mark, blood blot, erased row/shavings, closed. Sixth cell empty. No hands, bones, clothing, old tabletop or props attached from earlier art. Generated `exec-f238c205-d3b2-4e9d-aab3-a10a43c935f9.png`, SHA-256 `9675b132c19695c33fa5db3d5ca5b8cea7dc3d597bf4327163cfd3ee72554750`.
- Gravedigger Shop: transparent 3x2 sheet of three pairs of wet aged-wood trays: sheathed/unsheathed sword, quiver/arrows rearranged, grey/violet cracked stone. Cool cemetery dusk light, no table/cloth fragments or hands. Generated `exec-69d22995-0d80-4b35-a104-bfa4a4540d97.png`, SHA-256 `fd9210def0e974c6da446cdd4f68181f039b52b0c9b3d4243fb9e722d24d201b`.

Technical preparation: split source cells, retain meaningful alpha components with soft edge padding, uniform scale across states, fixed canvas aspect and 3 px clear margins at registered base, lossless WebP. Current hashes in registry; previous cropped assets remain in prior commit. Generated/project-origin, local provenance review only; no claim of exclusive authorship/copyright or release clearance.

## Evidence (original review revision, superseded by polish 02)
- Godot 4.7.2 isolated headless smoke: `godot --headless --script res://scripts/dev/travel_merchant_v5_smoke.gd`: 66 legal contexts, 10,544 checks, 0 failures. Covers actual party/companion, selected state, stable stature and soles, route, direction, camera coverage, deterministic reset.
- Reviewed offline layout composites of actual extracted props, new NPC cels and D412 poses at stop position; NPCs moved to counter edges to avoid dwarfed appearance behind tall furniture.
- Native preview motion and aesthetic acceptance still required; no full campaign/regression or player-package clearance claimed. Headless preview launch passed (shutdown ObjectDB diagnostic, not a leak-free certification).
- If accepted, separately integrate actual committed contexts through production travel router with V4 fallback and run live route regression.

## Original art provenance (development-only, historical first revision)
All new visual files are project-origin generated or source-derived; no downloaded art, dependencies, new audio or fonts. Image generation via ChatGPT, 2026-11-27, with the project's own original art at baseline as visual references:
- `assets/pixel/travel/batch_02/candle_seller/layers/base_1280.png`
- `assets/pixel/travel/batch_02/blood_ledger/layers/base_1280.png`
- `assets/pixel/travel/pilot_01/gravedigger_shop/source/original_master.png`

Generation brief: separate wide human-scale 16:9 painterly environments, same dark fantasy lighting/identity as references; no baked characters or wares, clear foreground corridor, freestanding counter at correct scale. Separate transparent four-pose full-body original NPC sheets: faceless burgundy-robed candle merchant with bandaged hand, skull-faced burgundy-clad bookkeeper with quill, grey-bearded brown-hooded gravedigger. Distinct neutral, gesture, presentation and acknowledgment poses; maintain costume, stature, feet and detail. Generated plates resampled once to 1280x720; foreground polygons are exact crops from these plates. NPC cels segmented by source alpha, normalized with Lanczos and packed losslessly, no pixelation or generative interpolation. Runtime JSON describes original source image names, pivots, counter polygon/depth, props and blocking. 

Prop frames are technical alpha-masked cuts of the preexisting original paintings plus original outcome patches (Candle Seller knight/ranger/mage states; Blood Ledger gold/blood/erase/leave states; Gravedigger role patches with the source_rect from layer_contract.json). Preserve depicted material and specific outcome, not newly generated merchandise art. Mask edges antialiased; shared native-size canvas registers each state at its base. No third-party intake. Exact new file hashes and local origin review in `THIRD_PARTY_ASSETS.json`. Prior original-art ledger remains part of unresolved historical audit; this development review is not a verification of all historic rights, copyright eligibility, or a release clearance. Follow LICENSE_POLICY.md before publication.
