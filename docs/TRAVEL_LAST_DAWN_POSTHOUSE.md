# Cinematic Travel Scene02 — The Last Dawn Posthouse

Ready for user artistic review, not claimed finally accepted. Uses the exact user-provided `misdeal_posthouse_approved_reference.png`, preserved byte-for-byte as `assets/pixel/travel/last_dawn_posthouse/approved_reference.png`, SHA256 `e4a3f62457071e431e7d01b739925db44a3ae9c8da4a13d51928e2f790d10bf5`. The rejected generic village was not used. The postal house, envelope sign, door/window, lantern, cart, letters/bags, muddy road, houses, castle and near correct burgundy/gold emblems retain original pixels/composition.

## Selection and contract

`travel_catalog.gd::LOCATIONS` explicitly maps `unsent_letters` to `resources/travel/last_dawn_posthouse.tres`. Other existing cards/victory contexts retain the original road resource. No randomness or extra travel state. Three supplied narration texts replace only this card's three travel captions; event scene/text/effects themselves are untouched.

TravelTransitionData adds a panorama Script factory and presentation-only party/fog settings. Defaults reproduce Scene01. Scene02 implements the same build/configure/update/planes contract in `posthouse_panorama.gd`, with a small local reactions node. The existing Travel V2 scene, compact reader, four-second clock, CanvasGroup entry, SceneRouter/SceneTransition, skip/pause and under-veil disposal remain in charge. Missing artwork/manifest yields unavailable presentation and original Table routing; incomplete presentations stay transparent. No autoload, router rewrite, gameplay balance, new reward, save schema, story flag or D412 atlas changes.

## Artwork and layers

Original-pixel transparent cutouts: Castle, Village Background, Posthouse/Midground, Road and Foreground, with a retained original mountain detail. Sky and hidden terrain are reconstructed from the approved image only. Seven plane speeds in screen pixels/second:0.2/0.8/1.4/3/5.5/14/15; finite overscan, no tiling. Slightly wider framing preserves the entire close heraldic emblem. Original road geometry supplies presentation party origin805,616, spacing112,4px depth step and0.9 scale multiplier; V2 soles, support poses, shadows and restrained dust remain.

The ordinary bird is absent from the DERIVED posthouse PNG itself, not just hidden by the animated bird. A110×110 repair patch is baked only over its original source area. The original source is not edited. Two distant castle emblems were stars on magnification; tiny source-space patches replace them with the canonical ring, orthogonal cross and long pointed shaft, using the live `approved_d283/firing_square.webp` heraldry reference. Already-correct close flags are unchanged. Local cloth warp leaves poles/stone rigid; lamp intensity varies at most a few percent and passed-only shutter displacement stays subpixel. Fog stays behind the house/heroes. No new sounds or conspicuous magic FX.

Packer: `scripts/dev/pack_posthouse_assets.gd`. Rebuild from committed inputs with `godot --headless --path . --script res://scripts/dev/pack_posthouse_assets.gd`; optional first user argument accepts the full bird-removal edit to regenerate the small patch. SVG masks only copy source RGB/add alpha, with the three explicitly permitted repair rectangles. No full duplicate replacement panorama. `provenance.json` records input/output hashes, generator IDs and the live heraldry source; prompts are retained alongside it.

## One skeletal carrier

One Sprite2D bird, never two.20 genuinely authored poses in a960×768 alpha atlas,192×192 cells,5×4: perched4, anticipation1, launch5, flight10. Skull, exposed ribs and bone wing fingers remain legible; technical packing removes coloured matte spill/detached alpha islands, not procedural pose fabrication. Source atlas retained. This is a scene-only animation contract, not a combat unit/25-pose battle pack. Four distinct open-paper poses use a separate small transparent strip.

- `release`: head movement until0.65s, anticipation/takeoff0.65–1.4s, then ten-frame wing cycles at24fps along a short Bezier toward roofs/mist; perspective shrink and fade2.95–3.5s. One envelope sprite moves from the perch to its beak and remains attached. One launch counter, no game-state writes.
- `read`: bird stays perched; unfolded paper on the sill gently changes shape. No flying/extra clue grant.
- `passed`: bird stays perched; no carried envelope or opened paper. Shutter/light move subtly; no supernatural effect.

All motion derives from the V2 local clock, freezes on pause/finish, and is freed with the overlay. No per-frame texture loads, spawned birds, timers or particle nodes. Scene02 shares11 decoded textures across replays; authoring repair patches are baked inputs, not extra runtime samplers.

## Actual verification

Final full local Godot4.7.2 GUT285/285,72,176 assertions; focused travel17/17,724 assertions; CI selector18/18. Final-head RELEASE CI remains authoritative. Existing19 GUT warnings remain. Native NVIDIA GL Compatibility:43 frames covering all outcomes, solo/duo/trio, start/flight/read/passed/end/base scene, ten consecutive flight poses and pixel-identical paused frames. Twenty replay/skip/free cycles: node delta0, orphan delta0,11 cached textures, clean isolated scene exit.

Actual production Event buttons exercise release/read/passed → own location → Table, natural release and double Skip, one launch/disposal under opaque veil, unchanged gold/Defiance/facts, Save/Load directly to Table and another event selecting the old road. Original Battle→Reward→Travel→Table and save route separately re-run. The legacy production-route fixture retains baseline exit-time RefCounted diagnostics; isolated scene replay/free QA is clean. No global leak-free or full random-playthrough claim.

Native examples: [QA](qa/posthouse/README.md). Full matrix/logs are generated in required RELEASE CI and uploaded with other visual evidence. Final visual acceptance remains with the user.

## F6 and local review

`scenes/dev/posthouse_playtest.tscn`, F6.1=Knight solo,2=Ranger+Mage,3=trio; Q=release,W=read,E=passed; P=pause,R=replay; Space/Enter/Escape/button skips/replays. Pure explicit preview context, no run/save edits. Watch at1×: one bare-bone pigeon, true wing movement, envelope pickup, foot/road contact, near occlusion, absence of seams, compact narration and four-second ending. In F5 finish «Запертая почта», inspect the existing result, continue; compare all three choices, rapid Skip and direct Continue loading. Other cards must retain «Тропа вдоль мёртвых стен».
