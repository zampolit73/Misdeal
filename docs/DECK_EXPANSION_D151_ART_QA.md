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
