# D236R — Sentinel gait repair after user rejected unnatural D236 walk

Date: 2026-10-18. **D236 native/user visual FAIL; D236R corrected SIX-frame WALK-only atlas and A/B viewer committed. Godot F6 and aesthetic acceptance of D236R PENDING.** Ordinary Act1 live **37/45**; card #38 remains QA-only.

## Later actual user verdict (2026-10-18)

After D236R side-by-side Godot QA, user replied **«пойдет»**. Update status to **USER VISUAL OK — repaired six-frame walk is sufficient to continue with SPEAR ATTACK stage D237**. This is acceptance of the gait, NOT confirmation that all 25 animation frames are finished, that the illustrated D235 visual fidelity is fully matched or that actual Battle #38 has passed. Keep earlier `native Godot F6 pending` references below as historical pre-test statements; latest user verdict supersedes their gait-acceptance status. D236 earlier gait remains rejected. No release/production role asset was changed by accepting this candidate.

## Reason for correction

After user was asked to F6 `black_lantern_sentinel_d236_walk6_pilot.tscn`, they replied **«не естествено»**. This is explicit rejection of **D236 walking motion**, regardless of previous 6-unique-cel/24-empty static technical success. Investigated `tools/art/author_road_sentinel_d236_walk6_pilot.py`:
- D236 initial legs straddled from x≈27 to x≈72 (~45px spread for an 96px character), too wide for a heavy plate guard;
- transition from frames 3→4 (index2→3) suddenly switched feet across x≈52→76 and x≈58→29, and frame index5→0 also snapped;
- hip, upper torso and lantern barely responded to changing leg poses;
- single source figure and silhouette overlays masked many lower-leg joints, so visually movement resembled foot teleport/slide rather than weight transfer.

Thus **do not mark D236 user-F6 PASS** and do not move to attack D237 while WALK remains unsatisfactory.

## D236R changes (versioned, no destructive edit of D236)

- `tools/art/author_road_sentinel_d236r_walk.py` — reproducible original authored six-phase support/swing pilot using **GitHub D234 rich illustrated upper with correctly wrist-held lantern and the real long spear**. Animated upper shifts only ±1px in x and rises 1px during push-off; both props stay in the source figure and remain attached to wrist/hand.
- A leg has **contact / weight / push-off** in frames index0–2 and a lifted rear/passing/forward swing in frames3–5; opposite B leg phases are offset by 3. Planted support sole y=91 for all six frames; reduced stride spread from ~45px to **≤23px**. Six-phase circular foot-position transitions validated (max individual x/y step ≤10px including last→first), preventing frame-edge teleports.
- Rebuilt layered knees/greaves and toe-forward boot shape. One leg behind cape, other visibly emerges below fabric. **Still an illustration cutout/hand-painted joint prototype, NOT six bespoke D235-quality full-body illustrations.** No dishonest final-art claim.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d236r_walk6_support_cycle.webp.b64`: lossless RGBA **576×480**, **six distinct WALK row index1** frames only, **24 fully transparent other cels**, clean 2px margins. Decoded WebP SHA256 **`bef95a03eb3da3996846e0826a5bf6fe53a1250b284ffa12f44d4d3fd50b73d5`**; original pixels equal round-tripped WebP.
- `docs/qa/D236R_SENTINEL_GAIT_QC.json` records per-frame contact, support foot, lift heights, torso x/y offsets, alpha bbox, 6 unique pixel signatures, no empty-support pose and max ankle deltas. Static QA is **not a substitute for visible Godot movement**.
- New `scripts/dev/black_lantern_sentinel_d236r_gait_compare.gd` + **`res://scenes/dev/black_lantern_sentinel_d236r_gait_compare.tscn`**: exact user-approved third D209 moonlit forest, LEFT **rejected D236** walk, RIGHT **new D236R**, both have **same 6-frame playback** at x3 and real x1, LEFT/RIGHT mirrors, synchronized pause and optional half-speed button. Subtle floor baselines help judge foot grounding. Source frame row/uniqueness/24-empty/borders are checked independently for each candidate.

## User review and future work

**User action:** `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d236r_gait_compare.tscn`. Compare naturalness of two walking figures especially **RIGHT x1**, first at half speed; check heels planted, lower-leg swing, torso, connected lantern, and the seam when looping frames 6→1. Report if the new gait finally looks like heavy armored stepping, or whether additional *actual individually drawn* lower body source work is needed. **Native D236R QA not run yet** (no Godot CLI). If it still appears unnatural, stop iterative coordinate-only bone/boot rigging; move to hand-authored high-quality per-pose leg/weight art instead of shipping a motion hack.

D235 1536×1024 rich illustrated 3×2 visual style is **approved** and archived; it is a **look reference**, not six clean transparent engine sprites. D234 user-approved wrist/lantern grip is preserved. **Do not switch** `MisdealUnitAnimationLibrary` (it currently uses technical D229), `BattleUnit`, `RunState.ACT1_CARD_IDS`, real #38 battle or light controller until genuine final animated art and release QA pass. D196 storm, D200 card art, D209 forest, DS2 and frozen `backups/KARAMBA73-2026-10-16` unchanged. Live **37/45**.
