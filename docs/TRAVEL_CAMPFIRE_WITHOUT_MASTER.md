# Cinematic Travel Scene04 — The Campfire Without Its Master

Implemented for native artistic review; **do not merge before the user's explicit approval**. Approval applies to the supplied painting, not yet to the animated staging. Full brief retained in [requests](requests/2026-11-12-scene04-campfire.md).

## Source and visual production

Exact supplied1672×941 RGB PNG saved byte-for-byte as `assets/pixel/travel/campfire_without_master/approved_reference.png`, SHA256 `ea21184b5a2792ce5ac3d4226f95656a5b812caab6bd345d19ef6d138d94a53a`. The squire, curly hair/face, bone hand, worn oversized boots, bench, canopy, fire, gate, lighting and heraldry retain original pixels. No replacement panorama, embedded player figures, UI, active blaze or new audio.

Two small spare pairs on the shelf make the existing decisions legible. Production edits contribute only shelf pixels around source x747–1006/y447–557. These are spare stored boots, never boots on the squire. Light-pair removal restores the original empty shelf RGB; the heavy-pair state adds a small dark residual imprint. Exact patch polygons, retained source edits, input/output hashes and built-in image_gen prompts are beside the assets. The discarded generated wooden-last edit is not used. Background underpaint is technical occlusion reserve, not a replacement for the visible approved painting.

The first cutout trial exposed a wall gap beside the weapon rack and was rejected internally. Final Gate backing is the complete original image; camp/canvas/ropes/rack/gear/squire/fire and close props share its1.6px/s displacement. This keeps their physical contacts and gate silhouette exact throughout the pan. The road alone has a feathered22-source-pixel overlap and restrained3px/s drift. Sky reserve0.15px/s stays behind the intact backing. Five V2 nodes, deliberately not five independently moving architectural fragments. No separate portal holes/bar strips that can tear. Finite1344×757 overscan at(−32,−18), no tiling or white borders. Existing smoke is preserved; quiet lamp/ember brightness varies only a few percent, with tiny anchored cloth/buckle motion.

Rebuild from committed inputs:

```text
godot --headless --path . --script res://scripts/dev/pack_campfire_assets.gd
godot --headless --path . --script res://scripts/dev/pack_campfire_walk.gd
```

## Existing outcomes, no repeated effects

- `repair`: light spare pair absent; heavy spare pair remains, loose strap moves very slightly in the empty spot. Squire keeps tending the same huge worn boots. Existing narration unchanged.
- `hobnails`: heavy spare pair absent; two dark sole marks remain on the wood, with the light pair and loose gear still present. No missing feet or altered legs. Existing narration unchanged.
- `passed`: both spare pairs remain; unchanged squire silhouette and tiny buckle/light motion suggest his repetitive task. No owner appears. Existing narration unchanged.

`final_five_events.gd` remains the sole owner of −18gold/+8% speed, +8HP/−4% speed or no change. Panorama/reactions/staging have no RunState/save writes. `borrowed_boots` alone maps to the new resource; Posthouse and Dressing Station mappings/art/code remain unchanged, other supported cases retain the old road.

## Party path and view

New scene-only18-pose NE rear walk: six authored poses per Knight/Ranger/Mage in separate576×96 RGBA strips,96px cells. Redrawn for the correct direction rather than mirrored NW sprites. Costume/weapon references are the unchanged D412 polish atlases; original combat files and Scene03 rear pack are untouched. Packer checks six distinct padded poses per role and records the central-boot sole of each pose. Texture filtering stays nearest, without blur or transparent ghosts.

Uses the existing optional `stage_party` hook. Scene04-only cubic road starts at(1130,610), bends through controls(1125,555)/(1055,430) and ends inside the open gate at(1135,315). Curve2D uses2px arc-length baking; reciprocal depth preserves perspective slowdown, shrinking scale1.32/depth with an additional0.96 multiplier per farther formation rank and intervals derived from resource spacing84. Lanes follow the local normal; feet include Road displacement and dust trails opposite the local tangent. Solo uses the same road a little farther along. Measured boot soles, depth-sorted contacts and depth haze0.04–0.34 remain intact (no blur). Existing duration, title/caption UI, pause, skip, feature flag, fallback, under-veil disposal and Table router remain in control. No autoload, new travel manager or save stage.

## Verification and limits

Road-curve correction: actual native1280×720 full trio and solo preview passes; existing Scene04 GUT2/2,111 assertions. Earlier five-frame gallery below documents the initial straight-route staging, superseded by this curve.

Native Godot4.7.2/NVIDIA GL Compatibility/1280×720 at1×: three full outcome passes; trio/solo; NE direction, perspective, stable architecture, pause and skip. Actual production choice button → Scene04 → Table verified with double Continue/Skip: gold50→32 once, speed1.08 once, snapshot unchanged during travel. Five actual [Godot frames](qa/campfire/README.md) retained. Existing travel suite22/22,902 assertions; selector18/18. Full local GUT290/290,72,354 assertions (19 existing warnings). Final-head required CI is authoritative.

The combined production-route fixture retains the same exit-time ObjectDB/RefCounted diagnostics documented for earlier travel fixtures. No script, parse, load or assertion errors in the native pass; no claim of globally leak-free shutdown. No new QA framework or large scene matrix. Existing RELEASE gets only this compact smoke. Old Scene01 QA fixtures now explicitly select the default resource, since boots owns Scene04; the Posthouse fallback probe uses `false_weights`. This changes QA routing, not old scene art/behaviour.

## Local review

Open `scenes/dev/campfire_playtest.tscn`, F6. Q=repair,W=hobnails,E=passed;1=Knight,2=Ranger+Mage,3=trio;P=pause,R=replay;Space/Enter/Esc/button=skip/replay. Preview does not read/write a run. In F5 finish «Чужие сапоги», inspect the existing result then continue to its aftermath. Review the empty equipment spots, unaltered squire, rear walk/scale through the gate and continuous canopy/stone contacts. Final animation/staging approval belongs to the user.
