# D231 — Art-quality mismatch: rich original Sentinel atlas vs procedural D229

Date: 2026-10-18. **CURRENT SOURCE OF TRUTH after user's explicit question about lost fidelity.**

## User feedback that overrides the 'final-art' interpretation of D230

User said **«так стой а спрайт будет такой? Атлас же был намного красивее что произошло?»** immediately after D230 called the D229/right option "FINAL". This explicitly reveals a **mismatch in what they thought was approved**: they expected the **richly painted original generated character/atlas quality**, not that a technically accepted comparison between two simplified procedural sprites permanently replaced the art direction.

The earlier **«давай примем 2 вариант и уже закончим с этим»** is still the choice of **RIGHT / D229 relative to D228**. It is now **PROVISIONAL TECHNICAL ART ACCEPTANCE (best of two simplified candidates)**, not a clear waiver of the promised polished art quality. The assistant's broad "final visual sprite, no more art needed" claim in D230 was too strong. **Do not overwrite D230's history; this D231 user correction supersedes the interpretation.** Do not re-open an endless D226/D227/D228 incremental-procedural art comparison either.

## Verified original files and concrete technical discrepancy

Available previous-conversation image files:
- `пиксельный_атлас_скелета_стража.png` — **1254×1254 RGBA**, illustrated apparent 5×5 posed characters, highly rendered armor, deep old-blue cloak, metal highlights, detailed large lantern; **BUT IMPORTANT: character is wielding an AXE / HALBERD**, not a real pointed spear. It also has generated pose and grid irregularities and is **NOT** an engine-ready exact 576×480 6×5 animation atlas. It cannot simply be connected unchanged to the `road_sentinel` role without breaking accepted D211 long-spear identity and transparent frame requirements. This original image was NOT brought over as the canonical Road Sentinel animation sprites.
- `лунный_страж_проклятой_дороги.png` — **1672×941 RGB**, user-approved D221 visually polished spear Sentinel concept with large plated hood, **real long pointed spear** and warm lantern, correctly in Style B. Includes baked forest/UI/caption: a **visual design reference only**; not a ready transparent frame atlas.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64` — procedural hand-positioned **576×480 RGBA 6×5×96px 25-cel** art from `tools/art/author_road_sentinel_d229.py`, simpler silhouette/armor than either rich reference. It is the bit-identical source of the D230 canonical `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`. **The previous assistant repeatedly added small pixel shapes rather than producing a faithful character art adaptation.**

### Honest implementation state

- **Bit-identical D229 chosen second/right sample remains installed** in `MisdealUnitAnimationLibrary.get_frames("road_sentinel")` with correct source-left orientation, and the new D230 isolated F6 smoke exists. **This is a staging/engineering integration ONLY and must NOT be taken as final character visual approval.** Do not claim an actual native Godot battle PASS; card #38 remains **QA-only**, normal deck **37/45**, so no current playable fight uses this role.
- **Final polished Sentinel visual-art acceptance is NOW REOPENED** due user's demonstrated expectation mismatch; do not publish #38 with D229 technical art. Avoid silently restoring the beautiful but wrong-weapon generated original atlas as final.
- Approved true target continues to be the rich armored **SPEAR** Sentinel from D221, with fidelity/ambience close to the original beautiful atlas. This does not mean an AI concept magically equals 25 original game animation poses.

### Correct future path (not yet done)

1. Decide a realistic **high-quality per-frame animation art production** strategy that preserves actual D221 look, organic dark-iron/skeletal/lantern silhouette, long spear, 25 real cleanly separated movement cels and leg grounding. Potentially an art workflow with artist-authored painted sprites rather than repeating low-fidelity Pillow geometry. If the 96px format cannot retain agreed fidelity, **discuss an explicit per-role asset-size change with user** before changing global animations or game scale; don't assume resizing the 1254 sheet yields desired results.
2. Show a **single resulting playable-scale character frame next to the rich reference** before spending more cycles on 25 frames. Have user explicitly confirm visual fidelity and spear identity. No synthetic upscale/swap of an axe atlas.
3. After source art approval, create/QA 25 original alphas, replace D229 technical atlas with the accepted full-quality version while keeping a versioned rollback; check target-facing/boot contact and genuine battle frames. Only then count the art portion as complete.
4. Remaining four skeletons are likewise subject to D220 high-quality art acceptance; do not rush #38 release or weaken the previously chosen design system.

No code/asset/UnitData/real Battle was changed by this documentation correction. D230 choice remains historically recorded as selecting D229 over D228, and the current technical loader remains available. Do NOT silently represent this clarification as a user-approved final art repaint.
