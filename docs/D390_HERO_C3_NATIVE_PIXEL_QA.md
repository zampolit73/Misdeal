# D390 — Direct-pixel C3 hero stills for native F6 art review

Date: 2026-11-04  
Status: **three independent static hero poses staged for QA, not approved production animations.**

## Why this art is different from D389

The user's actual D389 F6 screenshot showed that the large-concept-to-96px reduction remained too muted and indistinct. D390 does **not** crop, upscale, blur or recolor that concept. Three single-frame Knight / Ranger / male Mage poses were drawn **directly at 96×96** with deliberate pixel-aligned polygons, clusters, shadow and highlight strokes. This is small-scale code-assisted pixel illustration (source geometry authored directly in 96px), **not** a hand-painted 75-frame set and not a photorealistic finished sprite style. Direct pixel art prioritizes leg separation, negative space, weapon grips, class/value identity and contact at 1×.

Art contracts:
- Knight: wide weathered dark steel with burgundy cape, real two-boot separation, distinct sword and tall red shield with dull bronze rim.
- Ranger: muted olive tattered hood, brown leather, clear two-boot silhouette, long separate bow and visible string/hand.
- Male Mage: ash-purple robe with panels and visible feet, controlled beard, separate wooden staff and restrained cold-blue orb.
- No scenery, labels, podiums, or opaque rectangle in source bitmap. No anti-alias resampling; hard pixel edges.
- Source cell **96×96, actual content bounding boxes approx y=11..92**, transparent border on all edges. Strip is **288×96**.
- Artist-authored master texture: `assets/pixel/units/hero_c3_keyposes_qa/c3_native_d390_96.webp.b64` (lossless WebP encoded as version-controlled base64 text). Raw WebP SHA-256 `801c1af4d2466dcab6fe90bc48223f7d339a0955222ca67218abaf29a389f442`. Lossless, not compressed with blurry lossy interpolation.
- This is an **exploratory simplification** from C3's complex hero concept. The original C3 dark-fantasy artistic direction remains; player may reject its relatively graphic/pixel-cluster execution if too stylized.

## Actual Godot comparison

Run `res://scenes/dev/d390_hero_c3_native_preview.tscn` with F6 at 1280×720. Three current BattleUnits stand to the left of three native 96px candidates on the approved Firing Square stone floor, sharing real contact y455. Default **×1 native sampling**, optional **×1.3 only to compare physical character heights**. It uses the same proven separate QA layout as D388/389; it never mutates `scripts/battle/unit.gd`, `unit_animation_library.gd`, current combat unit textures, encounter state, DS3 interface or cards. Player's actual 1× screenshot is decisive for art approval.

Review:
- Does the Knight shield remain a real shield (not a colored polygon), sword and TWO boots remain distinct from dark floor? Does the level of painted material texture feel sufficiently aligned with current Misdeal?
- Does Ranger bow read clearly apart from arm/body and string? Can you see his hands, legs and hood? Is he not too bright/flat?
- Does Mage look like a dangerous adult male practitioner rather than a children's RPG miniature? Are robe panels and staff grip clear with blue light limited to the orb?
- Check no accidental black matte, visible feet on floor, crisp pixel edges at actual 1×; do not confuse zoomed 4× authoring proof with quality at runtime.

The test `tests/unit/test_d390_hero_c3_native_preview.gd` decodes the image; validates cell size, transparent padding, meaningful nonempty and distinct sprites, native scale and floor alignment; it does **not** prove perceptual quality or authentic motion.

## Scope / next gate

D390 creates **3 static stills**, not the 75 frame pack and not a production replacement. Existing Knight/Ranger/Mage live visuals stay unchanged. Do **not** derive 25 frames from repetitive transforms, stretched art or storyboard crops.

After F6 art direction is approved, author **25 unique original poses per hero**: idle 4, walk 6, attack 6, hit 3, death 6, in three **576×480** transparent 6×5 atlases (96×96 cells). Verify foot contacts, held weapon grip, clear silhouette at 1×, true 25 pose distinctness and Godot motion preview; stage behind a reversible opt-in route and run native GUT/CI prior to replacing production textures.

Rollback: remove only D390 asset + dedicated dev scene/script/test. D389 and earlier diagnostic references remain separate; production code remains untouched.
