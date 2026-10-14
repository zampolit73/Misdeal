## D151 ART REPACK V2 — 2026-10-15 — clipping fixed offline; native F6 recheck pending

User noted that the original D151 art preview clipped the Priest's robe and Pallbearer's feet and showed adjacent-frame spill. Old D151 imported files were correctly rejected by the newly introduced 96px cell-edge quality gate, and card release remained blocked. The user approved continuing with replacement sprite sheets. **Fix now committed to GitHub `main`:** `assets/pixel/units/deck_expansion_v1/funeral_priest_frames.webp.b64` (`b9d1723`, SHA256 of contained WebP `02c0b86f30a1d35d7b18b9fbeb8c307d23ec488d1e1954f6b76b4f7cfd14e5f2`), `pallbearer_frames.webp.b64` (`e5c5103`, SHA256 `9b5e1f5051e13a33254a4dd941524154c6b61cf6a462df2843fc565f7f04f74d`). Their exact remote text bytes were independently refetched/compared and match the QA-generated files.

**Root cause and remedy:** the two generated 1374×1145 source actor sheets contained **five organically positioned rows, not a strict 229×229 coordinate grid**, so earlier uniform slicing cut through boots, robe and coffin. V2 reads actual transparent gaps between poses, extracts each original authored pose, scales it consistently per role, centers it with transparent padding and aligns the lower silhouette to local 96px y=90. No synthetic frames, borrowed units or repeated/duplicated poses. Both WebPs are **576×480** (6×5, 96px), 25 required active cells each (idle 4, walk 6, attack 6, hit 3, death 6). Offline redecoded lossless WebP: **50/50 active frames nonempty; 50/50 have zero alpha on the outer 3px per-cell borders; all adjacent silhouette differences nonzero** (minimum difference 3.83% Priest / 3.19% Pallbearer). The previously failing D151 strict 2px border-gate should now accept both. `funeral_procession_art_preview.gd` positioning changed from y=346 to y=354 so the new sole baseline matches the y=442 guide. Original **448×274** approved-style card art unchanged. Existing Bellkeeper, Shepherd, and all other characters untouched.

**Native QA is NOT yet complete.** Offline full-body containment is not proof the motions look fluid in the real Godot client. NEXT ACTION: user `git pull`, F6 `res://scenes/dev/funeral_procession_art_preview.tscn`, confirm the warning `АРТ НЕ ГОТОВ` is gone, both figures stand with feet/hem on the baseline, coffin and censer remain contained in IDLE/WALK/ATTACK/HIT/DEATH, and send one screenshot/verdict. If accepted, integrate already-tested `LastRiteController` into a scoped D151 actual battle, create combat smoke (solo/duo/trio, two formations, revival/interrupt), verify real victory→reward→table, only then register the new card (33→34/45). **Live 33-card pool remains unchanged** and Last Rite's earlier *isolated* Godot smoke PASS is still valid. No full production battle or visual acceptance claimed.

---

## D151 FRAME-CLIPPING BLOCKER — 2026-10-15 — GODOT SCREENSHOT + SOURCE AUDIT

User ran real `funeral_procession_art_preview.tscn`: original card looks good, but both **Funeral Priest and Pallbearer have feet/lower silhouettes cut off**, with fragments of neighbouring cells visible. User explicitly asked whether legs should be visible: **yes** for Pallbearer; Priest has a ground-touching robe, but no rectangular truncation/bleed should show. Checking `funeral_priest_frames.webp` and `pallbearer_frames.webp` decoded from the committed `576×480` atlas confirms **50/50 authored 96×96 cells contain visible alpha in the outer 2px border (>8 opaque pixels)**. First Pallbearer idle cell has 85 nontransparent pixels in last 2 rows and 95 in right border, i.e. the figure is already cropped in source. Prior frame audit only tested empty/duplicate frames and missed this. **Do not claim D151 sprite art visually passed** or enable `funeral_procession` in the main 33-card pool.

**Fixes already committed:** `scripts/dev/funeral_procession_art_preview.gd` now diagnoses per-role clipped-frame counts and shows **АРТ НЕ ГОТОВ** in F6 while retaining the source candidate for inspection. `scripts/battle/unit_animation_library.gd` has a D151-specific edge-margin validation rejecting these unfinished atlases before use, with no changes to old Bone Shepherd and other approved roles. The card image needs no change. **This is a safety gate, not a new fixed animation**: the currently committed 2 image binaries are still visually invalid and should be replaced with fully redrawn source actor poses, truly centered within 96px cells with 2+ px transparent margins all around, readable feet and grounded idle/walk, complete arms/coffin, no cross-cell bleed. Genuine 4/6/6/3/6 frames per role, avoid simple transforms or repeated poses. After creating replacement source, use exact 576×480 WebP base64 paths, run offline edge/alpha/uniqueness/baseline tests, then new Godot F6 preview and full combat QA. `Last Rite` isolated logic already PASS; no gameplay or 33-card pool change. **Do not ask user for another screenshot until source atlas artwork is actually corrected.**

---

# D151 — Funeral Procession: imported sprite atlases, awaiting in-engine art QA

Date: 2026-10-15. Repository: `zampolit73/Misdeal` main.

## What is actually in GitHub

In commit `18b8c2e54d9ed00cb43da980a7d13e3f86942e8f`, three original assets were committed **directly through GitHub's blob/tree workflow, without local installer**:

| Asset | Format | Verified local SHA256 of *WebP* bytes |
|---|---|---|
| `assets/pixel/units/deck_expansion_v1/funeral_priest_frames.webp.b64` | base64 text containing transparent 576×480 WebP, 6×5 cells of 96×96 | `6b8ca8db077827f65d461904164941b917ae917dd4099e3429a3337578bedbe4` |
| `assets/pixel/units/deck_expansion_v1/pallbearer_frames.webp.b64` | base64 text containing transparent 576×480 WebP, 6×5 cells of 96×96 | `d7987241b5723e3f46f57eda5f9d4980f342b1642a7cacc414f1d649898f9e3e` |
| `assets/pixel/card_unification_v1/run/funeral_procession.webp` | individual 448×274 standalone full-bleed painted card art | staging QA candidate, see local checksum when needed |

Both atlases were derived **from two new transparent, original, separate 1374×1145 frame source sheets**, exactly a 6×5 source grid of 229px cells. 25 authored usable cells per role (4 idle, 6 walk, 6 attack, 3 hit, 6 death), reprojected to 96px cells, encoded at WebP quality 94. The 5 unused cells (idle 4–5, hit 3–5) are left transparent. Other approved unit assets are not modified.

### Offline frame audit

Re-decoded each resulting WebP and inspected all 25 authored cells for nonempty alpha. Each passes (none under 10% occupied alpha at a moderate threshold). The minimum alpha-silhouette change across any *consecutive* pair in a named animation row is **6.6%** for Priest and **6.9%** for Pallbearer, so no consecutive frames are identical/static duplicates. Each atlas is 576×480 and has RGBA alpha. **This is not proof of flawless animation**: some generated poses extend toward or across cell edges, so possible cut-off cape/coffin pixels, moving baselines and visual discontinuity require native 1280×720 inspection.

### Godot connection

- `scripts/battle/unit_animation_library.gd` now opt-in supports `funeral_priest` and `pallbearer`, using the established WebP Base64 loader, with **strict all-25-visible check**. Unlike D147 repairs of existing legacy Shepherd frames, D151 **must never silently fill missing authored poses**; it returns null on invalid/missing atlas, without borrowing unrelated SVG art.
- `scripts/ui/card_unification_v1.gd` can return original `funeral_procession.webp` for the art preview. No card registered into runs.
- `res://scenes/dev/funeral_procession_art_preview.tscn` and `scripts/dev/funeral_procession_art_preview.gd`: standalone F6 gallery for original card + both roles, with interactive IDLE/WALK/ATTACK/HIT/DEATH animations and per-cell alpha QA.
- Isolated `res://scenes/dev/last_rite_smoke.tscn` **previously passed in the user's Godot**, verifying 1 resurrection, cancellation and rollback. That test is a separate functional check, not artwork approval.

## Production release gate / no false pass

**Not yet complete:** native in-engine F6 validation of new art, placement/groundline inspection, motion quality, user art approval, production `scripts/battle/battle.gd` controller wiring, real fight matrix, victory→reward→table flow. The new `funeral_procession` is not in `RunState.CARD_PATHS` or `ACT1_CARD_IDS`; the Act1 registered pool is **33/45**, with the 12+XIII structure unchanged. Rejected former bell-themed `mourning_bell` remains deleted.

**Next and only user action:** run `git pull`, then F6 `res://scenes/dev/funeral_procession_art_preview.tscn`; inspect frame motion with the five bottom buttons and share screenshot/verdict. If Godot errors or clips, assistant corrects directly in GitHub before activation. After acceptance, connect `LastRiteController` *only for this encounter* and create full combat smoke. Retain existing Grave Bellkeeper, Bone Shepherd and DS2 approved art unchanged.

## Pitfall

Do not mistake the previous concept sheets (with titles and frame banners) for these clean game atlases. The new 576×480 atlases are genuine frame-cell texture sheets from a later generation; frame uniqueness is measurable, but artistic review is still pending.
