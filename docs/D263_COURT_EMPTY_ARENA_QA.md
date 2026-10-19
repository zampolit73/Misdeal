# D263 — Court of the Mute: character-free architectural arena QA and animation source assessment

**Date:** 2026-10-19. **GitHub main**. **Art status: NOT COMPLETE / NOT APPROVED.** The user said `«продолжай»` after D262 technical mechanics. Preserve exact D261 user-approved SECOND `448×274` court card art unchanged. Live **38/45**, #39 unreleased, frozen KARAMBA73.

## Implemented now

- New editable authoring script: `tools/art/author_court_d263_arena.py`. It draws an **original character-free** underground Gothic tribunal background with throne, weighing scales, ruined arches, red funeral banners, columns, braziers, worn stair dais and a broad contiguous tactical stone floor. D263 procedural geometry/pixel approach is a **layout/architecture candidate only**, not the same painterly quality as the selected D261 portrait. No existing combat arena bitmaps or selected card image modified, no baked actors. Raster export is **1280×720 lossless WebP**, text-packed at `assets/pixel/battle/arenas/court_of_the_mute_d263_qa.webp.b64`.
- [GitHub Actions source QC PASS](https://github.com/zampolit73/Misdeal/actions/runs/39217023278): authored bytes created in reproducible workflow `.github/workflows/d263-court-qa-arena.yml`; output SHA-256 `d1bedf7e585dd1e673b9f4a9d01f8620b750a09e44386ea46c7655f83612ca1d` (36,894 raw bytes). Source QC: `docs/qa/D263_COURT_ARENA_QC.json`.
- New standalone F6 viewer: `res://scenes/dev/court_of_the_mute_d263_empty_arena_preview.tscn` and associated `.gd`. Decodes original QA backdrop, also loads **unchanged** selected D261 card bitmap at correct 448×274, and toggles proper world-to-screen combat bounds (x110–1190 / y380–538) using **G**. Does **not** display old enemy sprites or misleading temporary Court combat. [Official Godot 4.7.2 F6 native scene import/smoke PASS](https://github.com/zampolit73/Misdeal/actions/runs/39217314242); 38/45 guard PASS. Existing unrelated `res://assets/concepts/approved_battle_direction.jpg` import error remains.
- Selected Court card resource `resources/cards/court_of_the_mute.tres` still has `target_path = ""`; no background registration in `authored_backdrop.gd` until an artistically suitable scene passes QA, and no Court sprites in `MisdealUnitAnimationLibrary`.

## Honest animation source gate

Artist exploration produced composite pixel-art character/reference montage(s), not immediately usable gameplay atlases:
- `mute_magistrate`: roughly 6×4 **24** drawn miniature poses in a montage, no 25th independent complete pose and no transparent 6×5 source grid
- `ash_scrivener`: roughly 6×5 **30** small displayed miniature illustrations, but wrong crop/material/proportions across rows, opaque background; not a vetted proper 25-frame set
- `bone_bailiff`: roughly 18–20 illustrated minis near a large portrait, but **not 25 complete small frame drawings** and some swinging polearm art crosses loose grid edges
- All three currently in composite montages with Russian UI labels and/or a battle scene; these are **NOT ready for import**, and cannot be misleadingly repacked into 25 authored poses by hashing or mirroring. These exploratory sources are conversation-generated images, not committed 25-frame atlases.

Per established AGENTS contract and prior user feedback rejecting simplified D229-style assets: each role needs independently authored *complete* 25 distinct clean-alpha poses, fixed `6×5×96px` atlas, 5 genuinely transparent spare cells, 2px margins, correct scale/facing and grounded feet, with physically connected **Magistrate bronze mantle + staff/seal**, **Scrivener iron quill + ledger**, **Bailiff shield + hooked halberd**. Use **ONE complete batch** for all three, avoid micro-approval gates. QA in one combined Godot scene at actual ×1 plus close zoom. **Do not ship generic/procedural proxy silhouettes as final art.**

## Current independent native QA is accurate but narrower

D262 real Battle mechanic CI had already passed [six configurations](https://github.com/zampolit73/Misdeal/actions/runs/39214875883) of original roles/UnitData plus the timed red seal and 54-case #38 regression. D263 *adds just an empty scene candidate and its strict Godot preview*, NOT final in-game Court integration, no full Fight→Reward→Table for #39, no complete 75-frame sprite acceptance, and NO change to shared game sprite art.

## NEXT D264

1. Deliver **all three original 25-pose transparent animation atlases as one batch**; check exactly 75 genuinely distinct poses and 15 fully-alpha-clear unused cells; inspect prop grip, feet, facing, action and death motion at ×1.
2. Refine the empty tribunal candidate to match the painterly user-approved D261 selected court environment. The current geometric QA result is deliberately **not declared acceptable final art**. No scene painted enemies.
3. Stage canonical QA art and separate environment behind a single **native F6 combined character motion/arena test** without modifying already-approved card illustration. Fix defects internally; do not ask for animation-by-animation approvals.
4. Only after art PASS, hook actual four enemy actors through normal Battle, scope existing D262 verdict controller and original scene, run solo/duo/trio × formations with balance matrix and real Battle→Reward→Table. Release #39 into **39/45 in its own commit** after all gates; stay **38/45** now.

**Source of truth:** GitHub `main`; preserve D260 #38, KARAMBA73, Fate Spread/DS2 and original selected card artwork.
