# Cinematic Travel V5 — Curse Forge (approved, live)

Player requested a genuinely cinematic mini-scene with human-scale NPCs, heroes, furniture, tools and props, approving a **single pilot** before scaling. Player approved the HD forge on 2026-11-27. Only Curse Forge now uses V5 in normal F5 play; V4 stays the fallback and the live baseline in the other 23 locations.

## Native preview

Pull main and run `scenes/dev/travel_forge_v5_preview.tscn` with F6, or QA Hub → TRAVEL → Cinematic Travel V5 — Проклятая кузня (пилот).
- R/Space replay; P pause; ←/→ real applicable outcomes.
- 1/2/3 party sizes (repeated press cycles roles for 1/2); Q/E cycle all seven actual role combinations; J toggles the QA Ranger companion, M mutes local cues, H hides controls.
- 6.6 seconds, no player profile changes. All three purchases and refusal have distinct staging; invalid buyer/action pairs are intentionally excluded. Actual Curse Forge travel now uses the approved 6.6-second clock; other live Travel scenes remain four seconds.

## Authored direction

- Pulled-back shot reimagines the forge layout while preserving the original open rainy roof, furnace, anvil, storm-blue/ember contrast and half-skeletal smith. Separate plates: environment, authored smith six poses, foreground anvil extracted from the same painting, original hot sword, three actual rack props.
- Common ground plane: horizon y=280, local projection px/m = 0.55×(foot_y−280). Smith 1.82 m, Knight 1.83 m, Ranger 1.78 m, Mage 1.76 m. Smith stands on y=535 (255 px body); Knight at the exact same depth would be 257 px. The anvil surface ~y=414, base ~y=550 yields ~0.91 m high; rack floor y=463, top y=394 (~0.69 m). Shield 0.94 m, quiver 0.89 m and focus 0.34 m are projected at rack depth, not at hero screen scale. These are authored perspective anchors, not a claim of photogrammetry.
- Party enters from the right so the first smith strike is visible, stops near the chosen item, takes the front ground lane and avoids the physical anvil footprint. NPC independently raises hammer, swings, makes contact, recovers and acknowledges; synchronized local sparks/short metal cue, furnace shader, subtle rain, contact shadows. Animated approved D412 walk/idle, normalized gait, mirrored left travel, scale anchored to boots; a local copy of Ranger walk removes only neutral guide pixels under the boots. The approved combat atlas is not changed.
- Camera moves the entire scene together, with coherent overscan. In purchase, actual validated buyer stands at the selected rack mount at t=3.22, item moves behind the silhouette, then is removed from the rack. The others remain. In refusal all three props stay and the party continues. This pilot depicts the transaction by staging and occlusion; it does **not** yet have a bespoke grasp/equipment animation per hero. No new item grants, equipment changes, permanent save effects or combat logic.

## Painted smith follow-up

The player asked to restore original art quality instead of pixelating the smith. Six native-resolution source poses are now packed losslessly into 576×576 cels (1728×1152 atlas), with a 444 px standing-body reference and sole y=534. Only the smith switches to linear texture filtering. This exactly preserves the previous scene projection, logical foot anchor and timing, while retaining the source detail. Heroes, scenery, handoff, occlusion and live V4 remain as before; the older 96 px atlas is retained for rollback.

[Before/after comparison at original scene scale](smith_detail_comparison.jpg) (offline composite, not a native framebuffer). Godot 4.7.2 isolated headless: 19 contexts / 4,471 checks / zero failures ([log](godot_smith_hd.log)); checks also cover the HD cells, smith stature, foot anchor and unchanged hero filtering.

## Initial pilot technical check and visual status

Godot 4.7.2 isolated project using the **actual** pilot scripts and source assets from current main: 19 valid party/outcome contexts, 3,008 checks, zero failures. Tests include source-driven six smith poses, true party/Jack, consistent stature, contact soles, anvil avoidance, correct rack state, idle interval, pause-independent seek and a clean replay. Run in checkout:

```sh
godot --headless --path . --script res://scripts/dev/travel_forge_v5_smoke.gd
```

[Original pixel-smith baseline viewing copy (MP4)](forge_v5_offline_preview.mp4) · [Original baseline storyboard](storyboard.jpg) · [Headless log](godot_headless.log).

Native framebuffer unavailable in this environment (X11 socket unavailable). The offline preview is assembled from 160 actual Godot-sampled sprite textures, layer order, positions, camera and tint at 24 fps; local effects/audio are composed for review. It is **not** a capture of Godot's shader/framebuffer or a claim of native visual/audio approval. The player accepted the HD F6 pilot. The previous movie and storyboard remain historical baseline evidence, not captures of the integrated F5 overlay.

## Production activation

The existing SceneRouter opts in only for `curse_forge`; the committed visual action, party and Jack flag are passed without any state writes. Render the exact V5 scene in an isolated 1280×720 subviewport; reuse existing travel matte, narrative, wizard line, skip, pause and one-shot finish. SoundDirector owns the existing Ambient bus cues. If V5 cannot configure, the same overlay builds the former V4 panorama and retains its four-second clock. The separate F6 V5 preview and legacy Batch02 QA driver remain available.

Isolated Godot 4.7.2 with actual Router, Catalog, Transition, V5/V4 assets, SoundDirector and a navigation probe (renderer-dependent scene swap replaced; unrelated RunState autoload stub): 19 contexts / 229 checks / zero failures. A disposable fixture with the HD atlas removed additionally passed 2 fallback checks. [Log](godot_live_routing.log). Native integrated F5 playback and actual Table swap remain player verification.

```sh
godot --headless --path . --script res://scripts/dev/travel_forge_v5_live_smoke.gd
```
