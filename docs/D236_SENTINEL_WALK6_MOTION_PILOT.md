# D236 — Road Sentinel: six-phase true leg-motion QA pilot (NOT final rich sprites)

Date: 2026-10-18. **Six distinct moving 96×96 walk cels STAGED; offline QC PASS; native Godot F6 and user art acceptance PENDING.** Act1 live **37/45**, card #38 QA-only.

## LATER USER RESULT: D236 gait REJECTED

2026-10-18: User replied **«не естествено»** after testing the six-WALK scene. D236 native visual gait is **FAIL**, although six distinct frames passed static alpha bounds. A/B foot switching and upper body rigidity were identified. Do not treat this experiment as approved, or continue to next attack state without correcting gait. New standalone D236R source/asset/slow-motion side-by-side F6 is in `docs/D236R_SENTINEL_GAIT_REPAIR_QA.md`. This historical D236 asset stays for comparison only.

## Background and accepted constraints

- **D235 visual:** user explicitly approved («принято») the 1536×1024 illustrated six-full-body-figure composition of richly corroded plated Sentinel with dark-red cape, long genuine pointed **SPEAR**, warm lantern explicitly held by the other hand. The D235 image is an artistic composition with a brown gradient background, not transparent 6×5 engine frames; its six poses in particular are very similar in leg stance.
- **D234 lamp grip:** user explicitly said «D234 фиксируем и идем дальше». Original four idle cells from D234 keep the free-hand gauntlet and the short connecting lantern handle; this is the valid visual base, not old D233 hovering knee lantern.
- The user's new «давай» initiates implementation of the ACTUAL walk rather than another look proposal. No live battle is requested.

## What was attempted and rejected

Directly extracting six silhouettes from approved 3×2 D235 poster via background GrabCut/automatic matting produced significant **large brown background islands, dangling cropped spear parts and inconsistent mask edges** even after manual tuning. This FAILED illustration quality and **was NOT committed as a production or walk asset**. Do not crop source panels and pretend they are clean alpha frames or a truly posed walking cycle.

## What is actually committed

Instead built a **limited articulated 6-phase locomotion pilot**, combining clean rich D234 upper-body/held lantern with six genuinely different lower-leg joint and shoe coordinates. It is not a new set of six full-body hand-painted images; some upper illustration cels repeat from D234, and the knee/shin/boots are digitally drawn in layered iron tones. Static photo-fidelity remains below the lavish D235 illustrations, particularly in the lower legs, and further native-scale art polish may be needed. Crucially, do not misrepresent this as satisfying D235 final-fidelity promise.

- `tools/art/author_road_sentinel_d236_walk6_pilot.py` — fully reproducible local Python/Pillow source (reads ONLY checked-in D234 original WebP/Base64 in repo). Creates six **genuinely distinct left/right foot placements and knee poses** with planted/swing phases on consistent ~y91 floor, original D234 intact body/connected lantern/spear, and creates the separated alpha frames.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d236_walk6_pilot.webp.b64` — **576×480 lossless WebP/Base64**, ONLY six nonempty cells in **row1 (WALK)**, other **24 cells fully transparent**; does not satisfy 25-state production library format and MUST NOT be registered in `MisdealUnitAnimationLibrary`.
- `docs/qa/D236_SENTINEL_WALK6_PILOT_QC.json` — six distinct cel SHA signatures, 24 alpha-empty unused slots (new canvas), all bboxes within 2px borders, limb/boot coordinates, frame/pixel-byte lossless output. Decoded WebP SHA256 **`c37d8155925de2e6cad90140cbe5328b91fa489b7ed4da2c301cd30b8b1ac6fb`**.
- `scripts/dev/black_lantern_sentinel_d236_walk6_pilot.gd` and **`res://scenes/dev/black_lantern_sentinel_d236_walk6_pilot.tscn`**: on EXACT accepted D209 forest, **LEFT** = D234 user-approved 4-IDLE lantern still anchored, **RIGHT** = D236 6-WALK genuine changing boot placements at native ×1 and enlarged ×3. Both direction ←/→ and pause; strict per-atlas validators check active rows, distinctness, all 24/26 unused cells, and 2px visible edge margins. Scene is QA-only; does not require full BattleUnit.
- Conversation-only preview `D236_walk6_contact_sheet.png` displays all six at x2 on dark background. The visual comparison against D235 rich full-res source should remind that this is an **engineering animation pilot**.

## Native review and next work

Godot executable is NOT available in the assistant environment; no native F6 PASS is claimed. User should `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d236_walk6_pilot.tscn`; check (1) feet clearly change phases and stay on floor, (2) neither shoe vanishes/teleports, (3) lantern remains held, (4) long spear remains correct and there are no gray/brown matting halos, (5) x1 rich style versus accepted D235 illustrative quality. A screenshot or clear user feedback determines next fidelity/rigging corrections.

If basic gait works but boots look crude, improve the illustrated lower-body rendering in each of the six true phases or change authoring method **before** accepting final walk. Don't generate six unchanged giant-image copy poses, and do not prematurely proceed to attack/death as if this particular art-quality requirement were already solved. Only after the WALK six cels are artistically and natively accepted should D237 attack6/hit3/death6 be produced, then a full 25-cel final release gate. No code/assets on active card #37 or current #38 normal pool were changed.

**Art priorities locked:** D235 rich true-spear full-character appearance, D234 wrist-held lamp and cloth, original third D209 moonlit forest, #38 five distinct undead identities, normal Act1 37/45, no touching frozen `backups/KARAMBA73-2026-10-16`.
