# D227 — Road Sentinel native pixel-fidelity pass (QA-only, not production)

Date: 2026-10-17. Status: **D227 original 25-frame sprite candidate, offline QA PASS, isolated native Godot F6 PENDING; STILL BELOW ACCEPTED D221 FULL-FIDELITY LOOK**. Act1 live **37/45**; card #38 not in `RunState.ACT1_CARD_IDS`.

## User direction and predecessor results

- User replied **«хорошо»** to assistant's D226 screenshot review proposing D227 source-pixel fidelity improvements. This authorizes continuing the art pass; it is NOT acceptance of D226 as finished art nor native verification of D227.
- Screenshot of D226 `black_lantern_sentinel_d226_art_preview.tscn` loaded D209 approved moonlit forest and displayed enlarged ×3 / game ×1 left-facing WALK with no red QA error. That screenshot was **partial gallery visibility only**, not complete 5 states/right-facing or Battle QA.
- **Locked art:** D211 armored spear Sentinel A silhouette, shared D220 style B, D221 original detail reference `лунный_страж_проклятой_дороги.png` (the large dark plate-armored spear guard with suspended lantern). The D221 image has baked heading/background and cannot be imported directly into animation art. No axe/halberd, no changed D209 arena.
- D225 Bearer QA direction switching user-reported OK; Bearer D224 repack softness/polishing remains distinct and independent.

## What actually changed

D227 is a **new original 96px-per-cel art export**, not a screenshot, resized D221 illustration, auto-cut generated pose sheet or fake overlay. It preserves 25 hand-configured physical body/weapon states from D226 while **repainting geometry across those poses**:

1. Asymmetric three-segment plated pauldrons, dark iron breastplate/rib strips, separate braced leather belt, reduced flat skeleton chest.
2. Three-quarter skeletal face with asymmetric eye sockets, cheekbones, jaw and individual teeth, hood opening, subdued ember eyes.
3. Frayed two-layer muted oxblood cloak: dirty borders, broken trailing hem, dark creases, no large smooth fill.
4. Angular 17px tapered spearhead plus reinforcing ferrule and short grips; attack still a 6-cel **SPEAR THRUST**, not axe slash.
5. Rebuilt short-chain antique metal lantern: trapezoid/tapered cage, side ribs, ember core and tapered base; shifted visually outside pelvis rather than resembling a bright belt buckle.
6. Leg joint-following rusty greaves and plated shoes; true two-leg walk frames, impact recoil, six steps to a grounded death; no global tween and no new gameplay statuses.
7. Reduced over-bright orange cloth accents; nearest-neighbor presentation without stretching/repacking from source illustration.

**This is modest fidelity improvement at a tight 96px render budget.** It still cannot be honestly called a complete reproduction of D221's richly hand-illustrated plates/cloak and must be judged at **×1**, then repainted further if needed. Do not declare final art based only on 25 unique hashes.

## GitHub source/assets and isolated scene

- `tools/art/author_road_sentinel_d227.py` — reproducible native 96px original art source using Pillow, self-contained, no fonts.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d227_art_candidate.webp.b64` — transparent 576×480 6×5×96px exact animation-row packing: `idle4 +2 empty`, `walk6`, `attack6`, `hit3 +3 empty`, `death6`.
- `docs/qa/D227_ROAD_SENTINEL_ART_QC.json` — **25 individually drawn/distinct RGBA tiles, 5 clear unused tiles, ZERO 2px alpha-boundary warnings**. Lossless WebP decoded bytes SHA-256 **`f1b50b919c76f5af9173ea33c77e484188077dbd72aee98110329210d84f7fbc`**. All 5 unused cells also validated after decoding exported WebP in Pillow.
- `scripts/dev/black_lantern_sentinel_d227_art_preview.gd` and `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` — isolated D209 forest gallery with 3× and 1× real-size displays, LEFT and RIGHT `flip_h` buttons, all five animations and strict in-engine 25 distinct + blank + alpha-border validator. The new art natively faces LEFT, so LEFT uses `flip_h=false` and RIGHT mirrors it.
- Conversation outputs: `D227_sentinel_animation_contact_sheet.png` and `D227_comparison_D226_D227.png` for visual per-frame review. ZIP `Misdeal_D227_Road_Sentinel_Art_QA.zip` with source + atlas + QC. GitHub includes source/atlas/report, not the standalone conversation-only contact board.

**No existing D215 or D226 artifact was overwritten.** No `BattleUnit`, `MisdealUnitAnimationLibrary`, `battle.gd`, `resources/units/*.tres`, `RunState.ACT1_CARD_IDS`, light controller, forest background or checkpoint branch changed.

## Next user F6/approval

User executes `git pull`, F6 **`res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn`**. Compare with prior D226 scene and accepted D221 illustration. At least inspect 1× walk + long-spear attack + fully grounded death, then toggle left/right in both 3× and 1×. Flag any foot sliding, lantern detachment, sudden spear jumps or insufficient visual finish. Do NOT log native Godot PASS or final character-art acceptance before an actual user result.

**Next after native D227:** if technical PASS but style still too sparse, continue original cel-level handmade fidelity improvement (no blind image-gen character swap), or discuss realistic 96px silhouette budget. Only once all five **final** original sprites are accepted, inspect 3 heroes + 5 skeletons in same real D209 battle composition, wire #38 encounter-local light, Battle→Reward→Table, 54-case matrix and full-pool release. Live 37/45 and frozen `backups/KARAMBA73-2026-10-16` remain unchanged.
