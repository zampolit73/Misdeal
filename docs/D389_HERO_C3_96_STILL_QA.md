# D389 — 96px hero miniature C3 key poses (NOT animation)

Date: 2026-11-04

## Source and status

Player chose C3 «Тёмный орден» and asked to proceed after rejecting the old low-resolution cutouts in a real F6. The latest single-trio concept was generated at 1672×941 RGB; three separate figure regions were masked against the near-black background using high-res foreground color and connectivity, without reusing the old 48px samples. Each masked figure was cropped then reduced to fit a 96×96 RGBA canvas (approximately 86px body height, feet near y92). The final 288×96 strip was encoded to WebP and stored as GitHub text: `assets/pixel/units/hero_c3_keyposes_qa/c3_keyposes_96.webp.b64`. No podiums, UI titles or card frames in the sprite strip.

**Important:** these are three still concept-derived rasterizations at 96px, **not original manually authored 96px sprite drawings** and not 25 distinct animation frames. They must pass a real 1× battle-scale art comparison before anybody considers creating the 75 frames.

## F6 preview

`res://scenes/dev/d389_hero_c3_96_preview.tscn` shows real current BattleUnit Knight/Ranger/Mage to the left of each new still, on the approved Firing Square stone floor, at shared foot-contact y455. The C3 stills start at 1.3× so physical height can be compared with the live actors, and toggle to ×1 **actual source-pixel resolution**. Nearest-neighbor filtering is used. No gameplay or UI resources changed.

Player verification after `git pull`: run F6 at 1280×720 and inspect all three roles. Do the Knight legs and sword/metal shield distinguish from the background? Is Ranger's bow an independent continuous silhouette and are both hands/boots visible? Is Mage's staff firmly gripped, mantle readable and blue accent subdued? Check no black squares around heroes and both rows remain on the same stone floor.

GUT `tests/unit/test_d389_hero_c3_96_preview.gd` asserts decode, per-cell coverage/transparent backgrounds, source dimensions, existing BattleUnit role identity and one line of actual foot contact after scale toggles. Native Godot CI must pass; it does not substitute for visual approval.

## Production follow-up

If art quality passes, create **original distinct frame art** for each hero: 4 idle, 6 walk, 6 attack, 3 hit, 6 death (25 each; 75 total), three 576×480 6×5 alpha atlases (96×96 per frame), with grounded gait, anchored props, correct animation timings and five transparent unused cells. Keep runtime unchanged until F6/native CI and user approve every role together. Never use storyboard pseudo-frames, duplicate/transformed cells or a single static pose to claim animation.
