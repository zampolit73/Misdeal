# D233 — Road Sentinel: FOUR rich-art idle cutout variants, method QA ONLY

Date: 2026-10-18. **Four actual transparent alpha frame images committed with reproducible source. NOT a finished 25-frame game animation, NOT final art approval.** Act1 still 37/45; black_lantern_road card #38 QA-only.

## User feedback and goal

After D232 showed an illustrated high-detail 96×96 one-pose Sentinel x1/x3 QA candidate, user wrote **«прододалжай»**. This authorizes continued exploratory work, **NOT a native Godot PASS or explicit final-art acceptance of D232**. The user previously objected to the loss of visual richness when D215–D229 procedural sprite revisions replaced the original illustrated look. We must not repeat that substitution.

Experiment: Can we keep D232's illustrated high-contrast iron plating/burgundy cloak/long pointed spear/amber lantern while deriving a short credible idle loop without reducing the figure to simple Python-drawn shapes? This stage only tests **lamp sway, cloak movement and warm glass flicker in 4 adjacent idle frames**, retaining the same skull/armor/weapon design and grounded feet.

## Reproducible asset method

- `tools/art/author_road_sentinel_d233_idle_proof.py` reads the tracked lossless **D232 original illustration cutout** from `assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_reference_cutout.webp.b64`. It is repository-relative, so a new chat can reproduce it without files from older conversations. Source 115×129 RGBA illustrated cutout of one authored pose.
- Separate **polygon-masked cloth tail and lantern** from that base, composite independently offset elements in 4 different idle phases, vary warm lantern glass subtly, and reinforce the pointed spear's narrow shaft beneath the source hand so the nearest-neighbor downscale will not break its outline. Every idle tile is rendered to true **96×96 RGBA**. This is a source-pose cutout motion technique, NOT 4 separately illustrated character body poses, and makes no claim to have finished walk/attack/hit/death.
- Output `assets/pixel/units/black_lantern_road_qa/road_sentinel_d233_idle4_cutout_proof.webp.b64`: lossless WebP with exact **576×480** familiar format, but ONLY row0 cols 0–3 occupied; **the remaining 26 cells are FULLY EMPTY**. It intentionally fails a strict 25-cel production loader and must not be registered in `MisdealUnitAnimationLibrary`.
- `docs/qa/D233_SENTINEL_CUTOUT_IDLE_QC.json` records 4 distinct frame SHA hashes, frame bounding boxes, no two-pixel margin warnings, 26 alpha-clear cells and `not_valid_full_animation: true`. Replaying checked-in source using the checked-in D232 source asset generated the **exact same WebP/Base64 bytes** as the staged file.
- Local preview `D233_idle4_detail_comparison.png` (four actual pixels at x3) and `Misdeal_D233_Sentinel_Idle_Animation_Proof.zip` exist as this-chat assets. The pixels are sourced from one original illustrated sprite, not generated fake animation panels.

## Isolated Godot preview and next gate

- `scripts/dev/black_lantern_sentinel_d233_idle_cutout_proof.gd` + `res://scenes/dev/black_lantern_sentinel_d233_idle_cutout_proof.tscn`: shows **STATIC D232 on LEFT, animated idle-only D233 on RIGHT**; both x3 and true x1 on exact accepted D209 moonlit forest.
- Engine QA validates 4 distinct frame hashes, 26 empty cells, alpha-safe inset and size, then loops idle at 2.8fps. Pause/resume and left/right buttons flip both sides. Intentionally **NO WALK/ATTACK/HIT/DEATH buttons** because these states do not yet exist; don't misrepresent cutout movements as fully authored combat.
- **Native Godot F6 untested until user runs scene**. If errors occur, inspect GitHub GDScript and fix it directly.
- Source and visual method have remaining possible limitations: interpolated rigid cloak/lantern movement may create visual halos/holes, source illustrated pose still not hand-cleaned at native 96px, and static body/legs are **not animation**. We must assess **actual x1 motion quality**, not count four SHA differences as artistic success.

## Do not confuse with production

D230 canonical technical D229 atlas, `BattleUnit`, `MisdealUnitAnimationLibrary`, character stats, D200 card art, D209 forest, light controller, actual #38 card enablement and shipped 37 other cards **remain unchanged**. The user's rich D221 Style-B pointed spear design and D232 art approval gate remain active. No 25-source-frame gallery available at this stage.

**Next step:** `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d233_idle_cutout_proof.tscn`. Judge if animated cloak and separate lantern remain visually natural at **x1**, not only x3. If acceptable as an idle-method test, author additional genuinely distinct bone/leg/body/weapon poses for walk and thrust as original art; if cutout jitter or detached parts are visible, reject this method and use an individual illustration/part rig authoring workflow before building the complete 25. Do not silently activate #38. KARAMBA73 fixed backup untouched.
