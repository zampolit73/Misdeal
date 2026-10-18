# D243 — Internal articulated Sentinel animation study: art FAIL

Date: 2026-10-18. After the user's recorded D242 rejection of stiff D241 animation, a new isolated 25-cel pose study was built. **It is a motion reference only, not an approved or releasable character atlas.**

## Exact deliverable and static checks

- 25 distinct separately joint-posed figures: 4 idle, 6 walk, 6 spear-thrust attack, 3 hit, 6 staged collapse/death; 5 entirely alpha-clear unused cels.
- 576×480 RGBA transparent, 6×5 of 96px, minimum two transparent border pixels, lossless WebP stored as Git-friendly text.
- Reproducible source: `tools/art/author_road_sentinel_d243.py`; asset: `assets/pixel/units/black_lantern_road_qa/road_sentinel_d243_articulated25_qa.webp.b64`; QC: `docs/qa/D243_SENTINEL_ARTICULATED_QC.json`.
- Grounded walk support/swing, anatomical elbows and knees, wrist-held amber lantern, hand-led nearly horizontal spear contact, and separate grounded kneel/fall/corpse poses (no full-picture rotation/shrinking).
- Isolated preview `res://scenes/dev/black_lantern_sentinel_d243_motion_study_preview.tscn` provides ×1/×3, both facings, 5 states, approved D209 forest. **Godot 4.7 native F6 was NOT run here.**
- Pillow local structural checks PASS; unique 25, 5 transparent, safe margins, exact WebP round-trip.

## ART GATE: FAIL (internal QA)

Inspected the actual rendered full sheet and ×2 nearest preview. Although attack direction and a multi-stage corpse are more intelligible than D241, the art remains **too geometric, clean and sparse**. It does **NOT** meet the user's approved rich original D235 Style B layered armor, illuminated worn materials, billowing ripped cloth and organic whole-body posing. This source is a motion/anatomy reference, *not 25 hand-painted production character frames*. Static hash/QC PASS cannot override artist rejection.

**Do not ask the user to F6 another inadequate candidate.** Do not change `MisdealUnitAnimationLibrary`, production Battle, live random pool or card #38 release. Next: repaint all 25 full figures richly in already accepted D235/D234 appearance, internally evaluate animation against original D153/D183 unit quality, then request **ONE** native F6 of the finished pack (D238 batch-first rule).

D239 and D241 remain user-rejected; D243 is internally rejected for final fidelity. Current pool 37/45; D200/D209, DS2, XIII and frozen KARAMBA73 unchanged.
