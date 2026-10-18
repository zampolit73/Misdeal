# D241 — Road Sentinel: whole-body illustrated animation replacement (QA ONLY)

> **2026-10-18 D242 NATIVE MOTION ART FAIL.** User provided real Loom/video; walking is stiff, spear attack does not clearly thrust, and death folds into a flattened figure. This D241 asset is **REJECTED** and preserved only as a QA/rollback experiment. Do not ask the user to retest it. New correct work: [D242 evidence and complete redraw contract](D242_SENTINEL_NATIVE_VIDEO_ART_FAIL.md).

**Date:** 2026-10-18. **Motivation:** user saw D239 Godot F6 and explicitly rejected the art ("ноги как будто бы от другого персонажа"). The defect was real — flat procedural D236R greaves were pasted under richly illustrated armor. See [D240 comparative art rejection](D240_SENTINEL_ANIMATION_ART_REJECTION.md) for checked-in older character animation reference sheets and full technical explanation.

## Actually changed

- Pulled **all six complete illustrated character poses** (including boots/greaves, skull, cape, armor and held lantern) from the **already user-approved D235** 1536×1024 source using reproducible experimental foreground matting. Internal source probe: `tools/art/inspect_road_sentinel_d240_d235_fullbody.py`, `docs/qa/D240_D235_FULLBODY_SOURCE_PROBE.json` and `road_sentinel_d240_d235_original_legs_source_probe.webp.b64`. Source still contains some frayed/tip matte losses; full visual approval not assumed.
- Built **new entire 25-frame QA atlas** from *whole illustrated characters* rather than procedural foreign shins: `tools/art/author_road_sentinel_d241_wholebody25.py` → `assets/pixel/units/black_lantern_road_qa/road_sentinel_d241_wholebody25_qa.webp.b64` (6×5×96, idle4/walk6/attack6/hit3/death6, 5 blank).
- Used D234 original painted spear geometry to restore missing matte weapon contours, keeping its point attached to an illustrated hand pivot. Attacks stage spear angle and stance as source-composited poses. Death sequence rotates the **entire fully-armored character**, and the last corpse poses are kept horizontally visible rather than uniformly reduced to minuscule figures.
- `docs/qa/D241_SENTINEL_WHOLEBODY_QC.json` records 25 distinct cells, 5 fully transparent cells, 2px inset and lossless WebP roundtrip. Latest atlas SHA256: `47078522c29d2f5d55418800054edff21ef70541ad3fe51db0db4eb26b422be1`. Rebuilt by `.github/workflows/d241-wholebody-atlas.yml`; intermediate build errors and fixes recorded in `docs/qa/D241_BUILD_STATUS.txt`.
- `res://scenes/dev/black_lantern_sentinel_d241_wholebody25_preview.tscn` → `scripts/dev/black_lantern_sentinel_d241_wholebody25_preview.gd`: all five states, left/right, true ×1 plus ×3 on the original **D209 accepted forest**; strict loaded-WebP per-cel QA.

## IMPORTANT ART LIMITATIONS / honest status

The original D235 poster has six highly detailed leg poses but **no complete attack/hit/death illustration sheets**; D241 builds those via staged **whole-body transformations and one attached weapon rig**. This fixes the glaring mismatched flat boots, but **does not equal** 25 independently painted fully articulated bodies, nor guarantee fluid fully horizontal spear thrust, hand anatomy in every attack, natural death deformation or convincing walk rhythm at x1. Treat D241 as a **full-package art-improvement QA candidate**, not final-quality cert. The original face, colors, leg armor and boots now belong to the same illustrated source. Distinct SHA hashes are *not* artistic acceptance.

**Never** switch `scripts/battle/unit_animation_library.gd` or `RunState.ACT1_CARD_IDS` until real Godot F6 + the user's complete character-wide visual verdict. Preserve rejected D239 and source D234/D235/D236R as rollback references. No new gameplay, Deck or scene background changes. Act1 live **37/45**; #38 still QA-only; frozen **КАРАМБА73** untouched.

## One consolidated native QA request

After `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d241_wholebody25_preview.tscn`; use all five state buttons and both facings in one review. **Check whether plated boots now look physically attached at x1, whether the walk transfers mass, held lantern/long spear stay connected, and whether attack/death read as actions rather than a rotated still.** One overall verdict, not separate permissions for every 4/6 frames. If visual still fails, do not polish tiny coordinates or change Godot animation FPS: move to **truly separately illustrated full-body action and death poses** to reach the D153/D183 standard.

## After this

Only after Sentinel passes, take the remaining four skeletal #38 roles in single complete 25-cel batches. Then 3v5 combat/light visual, Battle→Reward→Table, 54-case balance, full random-card-pool smoke. Keep released 37 cards intact.
