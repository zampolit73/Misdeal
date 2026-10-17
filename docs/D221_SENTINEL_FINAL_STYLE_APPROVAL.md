# D221 — Road Sentinel: final-style illustration approved, animation repaint pending

Date: 2026-10-17. Status: **USER APPROVED THE DETAILED LOOK, NOT A FINISHED ATLAS**. Live Act1 remains **37/45**, card #38 `black_lantern_road` QA-only.

## Binding user art approval

The user first selected **five-enemy collective art direction B** from two D220 illustrative compositions. This supersedes the more ornate/busy concept A **as the visual style** for ALL five final repaints. It does NOT change the already approved exact D209 forest arena artwork.

A subsequent separate character illustration was shown titled **«D220 / Страж дороги — финальный арт pass»**, displaying:
- a large detail view (approximately ×3) of a heavily armored dark-fantasy skeletal Road Sentinel with hood/ragged mantle, layered iron pauldrons, corroded rust/bronze edges, an unmistakable **long pointed SPEAR**, and a small lantern hanging from the pole;
- a scene mockup showing the same soldier at a smaller game-like scale in the previously selected moonlit forest style, emphasizing leg visibility and restrained amber light;
- no axe/halberd, no generic old skeleton, no magical projectile or extra block mechanics.

User replied **«отлично» immediately after this illustration**, which authorizes it as a chosen **visual/character appearance direction**. Refer to in-conversation illustration `лунный_страж_проклятой_дороги.png` (2026-10-17). This image is **a flat composite with baked background and Russian headings**, NOT a transparent `SpriteFrames` atlas, NOT the D209 exact bitmap, and NOT evidence that any of 25 final painted animation cels exist.

## Locked handoff requirements

1. **Road Sentinel appearance**: maintain approved D211 armored **A silhouette** combined with approved D220 group **B art style** and the character-detail illustration accepted here. Full original new rig art has to be hand/pose repainted from design direction: 576×480 RGBA 6×5 (96px), state rows idle(4), walk(6), attack(6), hit(3), death(6), five transparent surplus cells. No simply slicing the composite, auto-cropping baked backgrounds or rescaling the existing D215 QA atlas and calling it done.
2. **Native constraints**: 2px clean edges for spear tip, lantern and cape; stable feet y≈87–94; maintain proper enemy-left facing in Godot; visible arm/torso movement in six thrust frames, meaningful walk, recoil and grounded corpse. Preserve body, pole and lantern readability at native ×1, not just the enlarged painting.
3. **D221 next visual milestone**: develop **Lantern Bearer**, the next unique skeleton, in the same coherent direction B — thick-boned rough timber/plank shield, separate heavy lantern, defensive silhouette (no spear). Produce **visual look proposal first**, ask user art approval, then genuine frame-by-frame production. Remaining order: Oil Acolyte, Extinguished Guide (1.8× visual only), Lantern Archer.
4. **Release hard gate**: original final-quality art for all five must replace D215–D219 simplified QA candidates only AFTER sprite/gallery F6 and collective native-scale art confirmation on the exact approved D209 forest. Then wire QA-only real #38 encounter/light, Battle→Reward→Table, release smoke; release #38 into 38/45 only after PASS.
5. Existing released 37-card pool, D196 surf, DS2/Fate Spread I–XII + sealed XIII, `backups/KARAMBA73-2026-10-16` frozen branch, existing mechanics/UnitData and approved card art must not be changed during aesthetic concept approval.

**Truth boundary:** D221 is acceptance of the *image direction*; no runtime sprite, final atlas, QA scene or production art bytes have been committed with this documentation.
