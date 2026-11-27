# Cinematic Travel V5 — Curse Forge pilot (QA only)

Player requested a genuinely cinematic mini-scene with human-scale NPCs, heroes, furniture, tools and props, approving a **single pilot** before scaling. No redesign is activated in F5 or other Travel scenes. V4 remains the live baseline.

## Native preview

Pull main and run `scenes/dev/travel_forge_v5_preview.tscn` with F6, or QA Hub → TRAVEL → Cinematic Travel V5 — Проклятая кузня (пилот).
- R/Space replay; P pause; ←/→ real applicable outcomes.
- 1/2/3 party sizes (repeated press cycles roles for 1/2); Q/E cycle all seven actual role combinations; J toggles the QA Ranger companion, M mutes local cues, H hides controls.
- 6.6 seconds, no player profile changes. All three purchases and refusal have distinct staging; invalid buyer/action pairs are intentionally excluded. Player's actual campaign Travel remains 4 seconds and unchanged.

## Authored direction

- Pulled-back shot reimagines the forge layout while preserving the original open rainy roof, furnace, anvil, storm-blue/ember contrast and half-skeletal smith. Separate plates: environment, authored smith six poses, foreground anvil extracted from the same painting, original hot sword, three actual rack props.
- Common ground plane: horizon y=280, local projection px/m = 0.55×(foot_y−280). Smith 1.82 m, Knight 1.83 m, Ranger 1.78 m, Mage 1.76 m. Smith stands on y=535 (255 px body); Knight at the exact same depth would be 257 px. The anvil surface ~y=414, base ~y=550 yields ~0.91 m high; rack floor y=463, top y=394 (~0.69 m). Shield 0.94 m, quiver 0.89 m and focus 0.34 m are projected at rack depth, not at hero screen scale. These are authored perspective anchors, not a claim of photogrammetry.
- Party enters from the right so the first smith strike is visible, stops near the chosen item, takes the front ground lane and avoids the physical anvil footprint. NPC independently raises hammer, swings, makes contact, recovers and acknowledges; synchronized local sparks/short metal cue, furnace shader, subtle rain, contact shadows. Animated approved D412 walk/idle, normalized gait, mirrored left travel, scale anchored to boots; a local copy of Ranger walk removes only neutral guide pixels under the boots. The approved combat atlas is not changed.
- Camera moves the entire scene together, with coherent overscan. In purchase, actual validated buyer stands at the selected rack mount at t=3.22, item moves behind the silhouette, then is removed from the rack. The others remain. In refusal all three props stay and the party continues. This pilot depicts the transaction by staging and occlusion; it does **not** yet have a bespoke grasp/equipment animation per hero. No new item grants, equipment changes, permanent save effects or combat logic.

## Technical check and visual status

Godot 4.7.2 isolated project using the **actual** pilot scripts and source assets from current main: 19 valid party/outcome contexts, 3,008 checks, zero failures. Tests include source-driven six smith poses, true party/Jack, consistent stature, contact soles, anvil avoidance, correct rack state, idle interval, pause-independent seek and a clean replay. Run in checkout:

```sh
godot --headless --path . --script res://scripts/dev/travel_forge_v5_smoke.gd
```

[Offline viewing copy (MP4)](forge_v5_offline_preview.mp4) · [Storyboard](storyboard.jpg) · [Headless log](godot_headless.log).

Native framebuffer unavailable in this environment (X11 socket unavailable). The offline preview is assembled from 160 actual Godot-sampled sprite textures, layer order, positions, camera and tint at 24 fps; local effects/audio are composed for review. It is **not** a capture of Godot's shader/framebuffer or a claim of native visual/audio approval. The final approval gate is F6 playback on the player's Godot. Do not replace the existing Travel or scale beyond this pilot until the player accepts its motion, size and visual language.
