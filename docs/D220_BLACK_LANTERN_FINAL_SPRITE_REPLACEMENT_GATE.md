# D220 — Black Lantern Road: final sprite replacement gate

Date: 2026-10-17. **User requested an explicit answer about replacing the sprites after D219 and assistant committed to replacing all five QA-looking sprites with finished original Misdeal artwork BEFORE card #38 ships.** This is a production-art commitment, not a claim that finished art or a playable #38 has been completed. Act1 LIVE **37/45**, #38 QA-only.

## Latest D219 feedback

User replied **«все ок. и у меня вопрос ты потом заменишь спрайты или нет?»** immediately after being asked to F6 the D219 `black_lantern_archer_animation_preview.tscn`. Record **user-reported positive isolated D219 animation-preview feedback**. This is not independently verified per-frame native footage, proof of all five-role full-cast QA, or acceptance of final character art. Older confirmed/pending gates: D215 Sentinel user OK; D216 Bearer F6 screenshot rendered a shield attack, not yet full five-state visual feedback; D217 Acolyte corrected SVG was user-reported PASS; D218 Guide user said «отлично» without detailed logs. Preserve distinctions.

## Non-negotiable distinction

The current assets under `assets/pixel/units/black_lantern_road_qa/` (D215/D216/D217/D218/D219) and their Godot preview scenes **are functional/procedural QA sprites**, intentionally simplified to validate state timing, anatomy, weapon identity, real-scale leg contacts and alpha safety. They are NOT final art, and must NEVER be treated as the five approved polished production characters merely because individual F6 previews launch. In particular D217 SVG is a separate art representation from local raster candidate.

The assistant explicitly promised the user:
1. **Repaint/re-author all five** skeletons as original production-quality dark-fantasy pixel art matching Misdeal's **approved visual design system** and accepted D199 character silhouettes; do not present technical 96px assets as final. Keep recognizable roles: D211 **Sentinel A spear**, Bearer wood shield + heavy lantern, Acolyte sickle/oil flask/belt lamp, 1.8× Guide triple chained lantern rig, Archer bow/quiver/amber lantern.
2. Retain useful demonstrated **animation mechanics and move intent** (25 authored cels, 5-state row packing, grounded full-body walk, genuine attack/hit/death), but **repaint actual drawings**, not merely upscale, blur, recolor, crop, smooth pseudo-frames or reuse older skeleton assets. Original atlas contract: **576×480 RGBA, 6×5×96px, state rows idle4+2clear/walk6/attack6/hit3+3clear/death6**, with 2px safe transparency and distinct physical poses.
3. Before any registration into `MisdealUnitAnimationLibrary`, show **new real-size/pixel-native character variants** together **on the exact D209 third-approved moonlit forest arena**. Obtain the user's explicit art acceptance of the chosen finished direction. Maintain D200 chosen third card art and D209 original backdrop without needless re-selection.
4. **Replace QA sprite placeholders via connected GitHub** only after user art approval and native isolated gallery validation. Integrate into the actual #38 battle as five distinct production sprites (not just five isolated previews), confirm Guide ~1.8× visual height, all fighters grounded, contrast and front/back layering, real enemy-only moving light.
5. Then run real encounter Battle→Reward→Table, tactical/party-size matrix and full-deck release smoke. Only then release #38 as **38/45**. The deterministic QA matrix D207/D208 (54/54 functional) does not count as player-facing battle art or real route QA.

No changes to gameplay, sprites, card pool, existing D196 waves/DS2/Fate Spread 12+XIII or frozen `backups/KARAMBA73-2026-10-16` are authorized by this documentation step. **Next milestone: D220 actual original art repaint/options for five-skeleton collection, NOT blind live-card enablement.**
