# D239 — Road Sentinel full 25-frame illustrated-source QA package

Date: 2026-10-18. **In GitHub `main`: a complete 576×480 atlas with 25 distinct opaque roles and five fully alpha-clear cells; isolated full-state Godot preview. Not a live #38 release, not native Godot PASS, and not claimed as 25 independently repainted illustrations.** This is the first complete full-pack checkpoint after D238 batch-only workflow policy.

## Exactly committed

- `tools/art/author_road_sentinel_d239_full25.py` — reproducible Pillow builder, launched by narrowly scoped `.github/workflows/d239-sentinel-atlas.yml`; no external source-image substitution.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d239_full25_qa.webp.b64` — full 6×5×96 transparent lossless WebP, original five-state layout **idle4 / walk6 / attack6 / hit3 / death6**; five unused cels blank.
- `docs/qa/D239_SENTINEL_FULL25_QC.json` — generated per-cel pixel hashes, bounding boxes and source trace; decoded WebP SHA256 `79817fba4ee8469de6923fc9cdb30436db6852aa415533a25c93529f4fc49487`. Workflow-built: 25 unique frames, five unused alpha-clear, padded 2px safe, byte-exact RGBA after decoding.
- `res://scenes/dev/black_lantern_sentinel_d239_full25_preview.tscn` and `scripts/dev/black_lantern_sentinel_d239_full25_preview.gd` — single complete Godot F6 review on **existing user-approved D209 forest**, native ×1 and enlarged ×3, LEFT/RIGHT controls, five states including nonlooping attack/hit/death. Strict 25/5/edge/duplicate check on actual decoded artwork. Does not change runtime `MisdealUnitAnimationLibrary` or `RunState`.

## Fidelity and motion truth

The first and second animation rows preserve **exact original D234 free-hand lantern and D236R accepted gait**. Attack/hit/death use separately authored staged compositing of the same visually rich illustrated torso and real grounded legs, plus angled falling/settling body movement. They are not twenty-five separately drawn full illustrations: original upper details are reused for continuity. This is a **complete functioning source-composited QA candidate**, not a final approval of realistic spear contact or the aesthetic of falling. In particular, attack motion currently reads more as torso/weapon lunge than a fully articulated forearm-extension thrust; inspect carefully at ×1. The death sequence uses increasingly rotated original character source and may need genuine artist-redrawn bent-knee/arm poses. These remain explicit art-review risks despite 25 distinct frame hashes.

The user specifically requested **NO per-animation/pair-of-frames approval loops**. One complete D239 native review only, and implement reported fixes as a consolidated new full 25-frame revision instead of sending a 6-frame mini-review.

## User's only test

1. `git pull` after the GitHub Actions generated-asset commit.
2. Open `res://scenes/dev/black_lantern_sentinel_d239_full25_preview.tscn` and press F6.
3. In one pass, check **idle / walk / spear attack / hit / death**, both directions at ×1 first (×3 for grip, spear tip, cloak, feet), especially pose continuity and grounded corpse. Send one overall verdict or a screenshot if anything looks wrong.

**Status boundary:** GitHub Python builder and actual 25-cell WebP generation passed; Godot 4.7 native F6 is **UNVERIFIED**, artistic finished quality is **UNAPPROVED**, five-original-role fight #38 is still QA-only and 37/45 cards remain LIVE. D196 sea, D200 selected card art, D209 third forest, frozen `backups/KARAMBA73-2026-10-16`, DS2, Fate Spread boss XIII untouched.

## Next work after this checkpoint

Fix significant *full-package* F6 defects directly from GitHub, then finish other four Style-B original enemy 25-cel packs in the same batch-first manner. Once all five are visually accepted: stage 3v5, local light VFX, Battle→Reward→Table, 54-case matrix and full-pool smoke; only then release #38. New chats start with this D239 note after `AGENTS.md`, `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `HANDOFF`.
