# Cinematic Travel V2 — Parallax, Animation & Visual Polish

Extends [V1](CINEMATIC_TRAVEL_V1.md), PR #103 and the PR #104 mountain-valley correction. No new travel system, progression state, gameplay rules or saves. Final artistic approval belongs to the user after local F6 review; these are verified implementation results, not a claim of user acceptance.

## Art and depth

`source.png` remains the exact PR104 painting, SHA256 `17dfbcf2bc97045483c1ec03b92317d2feaefc43fe3f6b6ca750c75963f2f035`. Original-pixel Polygon2D UV cutouts retain the castle, visible valley, close wall/banner and road. Existing transparent foreground is unchanged. Two image_gen edits reconstruct occluded mountain terrain and isolated sky; they fill areas exposed behind moving cutouts rather than replacing the approved composition. Provenance, prompts and hashes live beside the assets. No baked text, repeated bridges, tiling, new architecture or replacement hero art.

Six independent planes, pixels/second at 1280×720: Sky0.3, Mountains1.2, Castle3, Midground7, Road24, Foreground38. Over four seconds the distant mountains move4.8px, wall28px and foreground152px. A finite centred overscan avoids wrap seams. The original valley cutout feathers into the occlusion plate; local sky-fringe keying clears the castle/wall cutout margins and existing window openings. Uniform viewport fitting adds letterboxing instead of stretching figures. Four decoded PNG textures are shared across replays; no decoding/particle allocation per frame.

## Party and atmosphere

Actual role order, solo/duo/trio, unchanged D412 frames. Travel-only6.5fps phase,120px spacing, Knight1.80× / Ranger and Mage1.72×. Central boot alpha is measured once per pose to place soles on the road; held support poses follow the road during their frame hold, advancing on the next authored pose. This is presentation retiming of existing six-pose pixel walks, not newly authored side-view animation or a promise of motion-captured gait.

One bounded immediate-mode FX node draws soft contact ellipses and four small dust motes/contact, at the feet and aligned to the stride clock. Gentle moonlit tint retains readable silhouettes. Valley fog is between distant terrain and the close wall, behind heroes. Banner distortion fades to zero before cloth boundaries/pole/masonry. No TIME uniform, random emitter allocation or new audio. Every animation, fade and FX freezes with the local clock on pause and after finish.

## Entry, narration and exit

A single CanvasGroup composites the incoming painting before its opacity fade, avoiding cutout boundary exposure from per-child alpha. The existing SceneTransition admits the overlay once any active scene swap ends; the world cross-dissolves over the completed result over360ms, with no extra black hold. Existing15 outcome texts are unchanged. Text appears520–920ms after entry. A compact centred20px serif reader on a soft lower gradient replaces the opaque black slab; all15 texts fit at most two lines. Existing UI-kit colours/button states remain; the skip action is smaller but accessible.

During the last650ms text fades out and the world dims gently. At four seconds the existing router changes to Table with its existing100/160ms veil timing. Crucially the travel layer is freed under the fully opaque veil, before Table fades in; V1 had hidden that reveal until its overlay popped away. Space/Enter/keypad Enter/Escape/button finish synchronously, without waiting for decorative fades. Missing required art/resource falls back to normal routing. Disabled flag, failed fights/XIII, save loading, rewards and completion semantics remain as in V1.

## Verification and limits

- Full local Godot4.7.2 GUT:279/279,71,900 assertions;19 existing warnings. Focused V1+V2 tests cover layers, original art hash, soles/spacing, paused clock, single finish, all15 text layouts, missing resources and cache/free behaviour.
- Native NVIDIA GL Compatibility:26 frames for solo/duo/trio at0.08/0.38/0.9/1.8/3.4/3.85/4s, paused pixels and1024×768 /1600×900 resizing. Twenty repeated open/skip/free cycles: no node/orphan growth, four cached textures, clean process exit in the isolated V2 fixture. Measured CPU update mean0.431ms / max0.772ms during concurrent local editor import; this is update cost, not an FPS or GPU benchmark.
- Real Event → Travel → Skip → Table, Battle(result) → Reward → natural Travel ending → Table, applied-save direct Table load. The battle presentation fixture injects victory through the actual result handler; it is not a combat difficulty test. Overlay disposal is asserted at veil alpha1. Existing production-route QA has baseline process-exit RefCounted diagnostics also seen in V1; isolated V2 replay/leak verification is separate and clean. No global project leak-free claim.
- Representative native frames and metrics: [QA](qa/travel_v2/README.md). Full final native matrix and route screenshots/logs are also uploaded by required RELEASE CI. No full manual random run is claimed.

## Local review

Open `scenes/dev/travel_transition_playtest.tscn`, F6. Preview loops without reading/writing a run:1=Knight,2=Ranger+Mage,3=trio,P=pause,R=replay; normal skip controls also replay immediately. Review gait at1×, soles/shadows, near/far depth, cloth, fog, subtle dust, intro/text/exit and legibility. F5: finish an Echo event then continue; win and collect both upgrade/loot before travel; skip repeatedly; load a save directly. Final art direction remains pending that review.
