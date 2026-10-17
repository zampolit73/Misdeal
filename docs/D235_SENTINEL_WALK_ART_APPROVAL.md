# D235 — Six-pose Road Sentinel WALK concept USER APPROVED

Date: 2026-10-18. **User explicitly replied «принято» to the six-pose dark-fantasy walking illustration generated immediately before this note.** The artistic direction for this **WALK** sheet is now LOCKED as the intended richer finish for Road Sentinel; not a finished Godot animation atlas or a native engine PASS.

## Precisely approved reference

The generated illustration `шесть_кадров_шагающего_скелета_воина.png` (source **1536×1024 RGBA**, SHA-256 **`9fa8e48baed60364411e13e2a58d1549e052bbdc250c26b37933d2081442b181`**) depicts **six large full-body portraits arranged 3×2 on dark brown gradients**:
- same skeletal roadside guard in layered dark corroded iron armor and torn deep-red hood/mantle;
- unmistakable **long pointed spear**, not axe or staff;
- separate warm amber lantern visibly gripped and held by the **free hand** (D234 attachment requirement);
- boots/greaves and strong silhouette; high character detail at display scale, consistent with D220 group B aesthetic and the user's original richly detailed painted-art requirement D231.

**This art is accepted for its character/pose direction.** The image depicts repeated/near-neighbor similar stride stances and does not itself establish a convincingly spaced six-pose walking cycle, foot contacts, actual animation, true transparency, cel count/timing, or battle-floor alignment. The user acceptance must **not** be interpreted as validation of a rendered x1 loop on D209 arena.

A visually close reference copy is now **in GitHub** at:
`assets/pixel/units/black_lantern_road_qa/road_sentinel_d235_approved_walk_concept_q95.webp.b64` — whole original layout preserved at **1536×1024**, WebP quality **95, lossy visual reference** (NOT pixel-identical to the original PNG), decoded asset bytes SHA-256 `fccc8642bb5d880bef39ff59dc3695a28779cd0ae35c8a1e5a7ff16639795566`. The exact original PNG SHA above records provenance, and original generated illustration remains in conversation. Stored machine-readable provenance: `docs/qa/D235_SENTINEL_WALK_CONCEPT_REF_QC.json`.

## Existing D234 and animation contract

D234 wrist-anchored free-hand lantern was accepted by the user («D234 фиксируем и идем дальше»), closing its visible grip defect **as art direction**. D233 free-floating lamp is REJECTED. Continue from this approved attachment: maintain same visible gauntlet-to-handle geometry through stride, spear thrust, impact and corpse.

The game's current 25-pose layout remains **576×480 RGBA / 6×5 / 96px per cell**: idle4+2 clear, WALK6, attack6, hit3+3 clear, death6. **The D235 poster is NOT this layout**: rendered background, non-transparent and 3×2 large illustrations, with no individual engine-aligned per-state frame pixels. Do not put it in `MisdealUnitAnimationLibrary`, or auto-resize/crop the entire composite and claim six good clean walk poses. The selected simple D229 source still resides in staging for the unreleased #38, **NOT** a rich final-approved production atlas.

## Next true production task — walk 6 source-art construction, not another look ballot

1. Use approved D235 exact character/lighting/equipment as **visual reference**. Draw/create six distinct clean RGBA full-body walking poses at the **actual native 96px budget**. Where necessary, author bones/legs/boots positions and cloak/arm/lantern layers individually, not six near-identical translations of one picture. Ensure front/rear foot separation, planted sole, passing pose, leg swing and grounded contact; avoid ankle float.
2. In all six cels, lantern remains visibly held by free gauntlet, with short handle visibly connected to wrist. Spear/hand stays consistent, movement not teleporting weapon shaft.
3. Verify no alpha clipping within 2px cell inset; exactly six different walk cells (row index1), no leaking across cells. Preserve high richness instead of drawing generic simplified skeletal geometry; native x1 on **EXACT user-approved D209 forest** is priority over x3 pretty slides.
4. Only once a real six-walk transparent pilot is built, stage isolated Godot F6 preview comparing approved D234 idle and D235 real WALK **without touching the active animation library**. Ask user motion/fidelity QA then move to attack/hit/death original art.
5. The artistically approved D235 pose poster is NOT evidence the project can now register #38 or claim final 25-frame sprite. Normal Act1 **37/45** remains, frozen `backups/KARAMБA73-2026-10-16` (actual spelling `backups/KARAMBA73-2026-10-16`) untouched.

**Latest approval priority:** D235 rich WALK visual/character reference LOCKED; D234 wrist grip LOCKED; D232 isolated illustrated base is historical reference; D230 “art final” claim superseded by D231 explicit user fidelity objection; D229 remains only technical staging. This D235 record prevents new chats from losing the beautiful approved source again.
