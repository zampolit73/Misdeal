# D240 — User rejects D239: anatomical/artist mismatch, not a Godot animation bug

Date: 2026-10-18. **User-native F6 screenshot confirms D239 scene runs and visibly displays the character in `walk` at ×3 and ×1 on D209 forest. User's explicit visual verdict: «анимация страшная, ноги как будто бы от другого персонажа — посмотри анимации которые делал раньше на других юнитов». D239 full-pack ART QUALITY = FAIL, not PASS.** Do not reinterpret F6 loading as acceptance.

## Comparative inspection in actual GitHub source

Inspected the active D239 builder `tools/art/author_road_sentinel_d239_full25.py`, user screenshot, and previous **real complete** 6×5 WebP animation atlases:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`;
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`;
- `assets/pixel/units/deck_expansion_v1/drowned_ferryman_frames.webp.b64`;
- `assets/pixel/units/combat_units_anim_v2/knight.webp.b64` (reference, note earlier Knight was not universally enabled in Battle).

The accepted older sheets depict coherent **whole-body pose progression**: varied posture and center of mass, joined knees/greaves/feet and silhouette-consistent gear/cloth. Attack changes the actual action silhouette; death folds/collapses character geometry progressively. They are not one head/torso composited over flat foreign-looking line segments.

### Root cause

D236/D236R `render_leg()` and `boot()` use Pillow polygon/line art for greaves, shins and rectangular soles, **not the illustrated metal-clad legs from approved D235**. D239 then reuses those legs wholesale while compositing unaltered D234 illustrated upper at image y73/75 via `hold_upper()`. The seam cuts across lower clothing. `thrust()` shifts nearly stationary torso rather than genuinely aiming a held spear. `death()` rotates/scales a whole figure, which resembles a stiff billboard. The 25-pose SHA differences and edge padding are **technical** checks; they completely missed art cohesion, weight transfer and real motion. This is the source defect. Do NOT "fix" by Godot FPS, filtering, adding pixel noise, or reusing someone else's greaves.

### Locked correction

1. **D239 is rejected**; retain complete QA files for comparison/rollback but never register them in `MisdealUnitAnimationLibrary`, real Battle or card #38.
2. Return to the **actual full-body D235 richly illustrated six-pose source** and earlier accepted coherent character animation method; avoid procedural floating boots/isolated leg grafts. Preserve long spear, gauntlet-held lantern and heavy plate/oxblood/bone Style B. The previous D236R gait was acceptable as *movement rhythm*, but NOT D236R's placeholder boot artwork.
3. Independently construct/repaint **whole character poses** for all 25 states together and internally preview attack, ground contact, fall/corpse, left/right at x1/x3. No more repeated 4/6-frame user approvals. If source-background extraction or style consistency fails, reject internally — do not put another mismatched candidate before user.
4. QA-only `tools/art/inspect_road_sentinel_d240_d235_fullbody.py` and `.github/workflows/d240-illustrated-source-probe.yml` experiment with segmentation of the D235 original illustration solely to discover whether its illustrated legs are reusable as proper source art; **this is NOT a finished animation pack or game scene**.
5. Only present a genuinely improved complete 25-frame character with one F6. Until then preserve **37/45 live cards**, D209 exact forest, D200 card art, D196 storm, DS2 and immutable `backups/KARAMBA73-2026-10-16`.

**User feedback outranks D239's previously green SHA-count and Godot validation; no successful native art quality claim is valid for D239.**
