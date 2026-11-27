# Relic V5 wall-side staging correction (2026-11-28)

Player feedback: the debtor sat illogically in the middle of the dungeon;
the crown was oversized compared with the helmet.

- Repainted the debtor and low table together against the right wall in a
  stone alcove. The previous location is now continuous wet floor. The
  chamber, camera family, seated figure, candle and goblet remain coherent.
- Exact 1280×720 plate; table props in x1040–1180, y460–490; new 144×120
  registered hand/forearm gesture at (1040,349) with feathered local alpha
  only. Repositioned light/cloth masks, approach and waiting slots,
  continuous exit and scene-local shading. No other scenes' art changed.
- Crown width 67→43px (35.8% reduction); existing fragment/residue/tooth
  widths derive from this value. Cloth footprint radii 33×8→21×6;
  customer's waiting position +9px for the smaller pickup.
- Wizard Tithe, gameplay, committed outcome IDs, timing, audio, routing
  allowlist, card art and existing hero/Jack library unchanged.

## Evidence

Godot 4.7.2 isolated import and relic smoke PASS: 132 contexts,
26,589 checks, zero failures, including new position/size guards.
[Smoke output](alcove_smoke.log). [Offline sampled frames](alcove_samples.jpg):
debtor at 2.82s and crown at 0s. Composited from actual Godot sprite texture,
transform, pivot, modulate and z-order samples; shader output and audio are
not reproduced. Native F6 approval remains pending (10/24 live, six staged,
eight unstaged).

## Asset provenance

Pinned prior project-only debtor plate at
`a2563d269d7adbf70f25fb95f6d1474277850128`. ImageGen edit prompt:
preserve chamber, camera, light, style and human scale; move entire
debtor workstation against right side wall, build small alcove, empty
table surface for animated props, restore old floor, no party/UI.
Generated source SHA256
`07a10da1d1608c039fd8e72b8881aaf81365576d9b6a97d5dff826ffacdb44c7`
(1672×941), resized Lanczos to 1280×720 WebP quality 90.
Second ImageGen edit on the crop (1040,349,144,120), enlarged 6×:
only articulate the existing skeletal wrist and fingers towards the
table, retain hood, wall and cup. Generated source SHA256
`7834281916b7eebacd7abec537fe18b914e0a7847635ff208f8aa7d653e9cd6f`
(1374×1145); resized to 144×120, isolated the arm/hand with feathered
alpha (3.3px blur, 4px outer edge), saved WebP quality 94.
New runtime hashes, authored shader change and QA sample recorded in
THIRD_PARTY_ASSETS.json. No external new assets or dependencies. Historical
project material and tool rights remain a release gate; this is a
development origin review, not exclusive ownership or commercial clearance.
Prior revision remains in Git, with unchanged import UIDs.
