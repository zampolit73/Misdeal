# Misdeal — Undead Animation Pack 2: Frame Production Brief

Date: 2026-10-12
Status: **ART PRODUCTION BRIEF READY; ALL FOUR ACTUAL SPRITESHEETS PENDING; LIVE COMBAT UNCHANGED**

## Production boundary

This is an authoring specification, **not** animation artwork. The existing staging importer, validator and F6 comparison preview are ready; no approved Pack 2 candidate atlas exists in the repository. No edits to `scripts/battle/unit.gd` or `scripts/battle/unit_animation_library.gd` are authorized by this brief. Stage A impact effects remain live.

Use the existing approved static v4 tiles as **character identity references**, not as 25 transformed copies. Preserve silhouette, weapon/shield, palette and scale. Build the next real animation assets as independently drawn poses with readable footwear (or anatomically appropriate feet), consistent contact and visible attack anticipation/recovery.

## Canonical sheet contract

- One transparent RGBA sheet **576×480 px per role**, six columns and five rows, cells **96×96 px**.
- Rows in this exact order: Idle **4**, Walk **6**, Attack **6**, Hit **3**, Death **6** = **25 used cells**. Keep five unused cells transparent; no baked backdrop or UI.
- Frame origin: character centered horizontally with stable reference to the baseline in the last occupied pixels, preferably y=87–94 inside each cell. Never allow neighboring-cell bleed, clipped limbs/weapons, or detached pixels.
- Facing: preserve the game's existing sprite flip behavior. Animate one consistent orientation; no directional mixed atlas.
- Pixel grid: maintain sharp, coherent pixel clusters and readable contrast at actual combat scale. No AI blur, pseudo-pixel textures, extra limbs, duplicated poses, or weapon melting.
- At rest and through locomotion: hips, torso and feet stay coherent; attack movement must read as a deliberate action rather than full-body rubber squash. Death ends on the ground, without hovering.
- Before producing all 25 frames, produce a **four-frame key-pose strip per role** (Idle, Walk contact, Attack peak, Death final) for visual review. These strips are NOT valid import candidates or substitutes for the complete atlases.

## Role briefs and beat sheets

### `bone_thrall` — Bone Thrall

Identity: feral undead bone creature; aggressive low/forward-weighted pose, visible separate legs or distinct grounded supports, claw weapons readable.

| Row | Frame intent |
| --- | --- |
| Idle 0–3 | settle → jaw/shoulder micro-motion → weight shift → return; both feet planted |
| Walk 0–5 | left contact → passing → right contact → opposite passing → push → reset; no sliding |
| Attack 0–5 | crouched anticipation → lift claws → forward reach → dual-claw contact → retract → recover |
| Hit 0–2 | compact recoil → stagger without foot teleport → recover |
| Death 0–5 | destabilize → knees bend → fall → collapse → settle → still grounded |

### `grave_bellkeeper` — Grave Bellkeeper

Identity: bell-carrying undead support; bell must be distinct from the arm and remain attached, with visible grip and swing arc. Keep the mystical impact ripple in Stage A VFX, not baked into body frames.

| Row | Frame intent |
| --- | --- |
| Idle 0–3 | still hold → small bell sway → robe/shoulder response → settle |
| Walk 0–5 | staggered grounded steps; bell follows by slight delayed swing, never disconnects |
| Attack 0–5 | brace → draw bell back → start ring → audible/readable strike pose → decelerate → return |
| Hit 0–2 | brief torso flinch with bell inertia → correction → stable stance |
| Death 0–5 | lose grip/balance → bend → descend → bell lowers → body collapses → grounded final |

### `crypt_guard` — Crypt Guard

Identity: armored defensive undead; preserve shield/weapon separation, broad stable stance, weight and rigid armor. Do not use large body squash.

| Row | Frame intent |
| --- | --- |
| Idle 0–3 | guard stance → slight breathing → shield micro-adjust → return |
| Walk 0–5 | deliberate heel-to-toe alternating feet; shield stays anchored to arm |
| Attack 0–5 | plant rear foot → weapon wind-up → heavy strike → clear contact → pullback → guard restored |
| Hit 0–2 | shield absorbs / body recoil → shift weight → replant feet |
| Death 0–5 | shield dips → knees buckle → torso tips → armor falls → final settling → still |

### `bone_warden` — Bone Warden

Identity: large boss silhouette; maintain imposing head, oversized weapon and heavy grounded footfalls; no loss of boss scale between frames. Existing red-gold floor impact accents remain procedural Stage A VFX.

| Row | Frame intent |
| --- | --- |
| Idle 0–3 | threatening stillness → restrained chest movement → weight shift → return |
| Walk 0–5 | heavy alternating contacts with short recovery, no floating |
| Attack 0–5 | long readable anticipation → raise weapon → committed heavy downswing → contact → follow-through → recover |
| Hit 0–2 | powerful shallow recoil → brace → regain balance |
| Death 0–5 | stagger → buckle → weapon descends → massive fall → body settles → static grounded corpse |

## Delivery / review gates

1. **Visual key-pose approval:** review four key poses per role against v4 before full sheet production. The image must actually contain per-character cutouts, not a combat-scene illustration.
2. **Complete sheets:** verify 25 distinct usable poses per enemy (100 poses total). Check outlines, anatomical consistency, separately drawn weapons and foot contact on actual 96px pixel-grid.
3. **Candidate staging:** run `python scripts/dev/import_animation_pack2_candidate.py --role <role> --source <png> --output-dir assets/pixel/units/combat_units_anim_pack2_candidates` for each complete sheet. Invalid/opaque/non-distinct frames must fail QA.
4. **Godot preview:** open `res://scenes/dev/unit_animation_pack2_preview.tscn` with F6 at 1280×720. Inspect every state, transitions, frame pacing and sole alignment against static v4. Until art is staged, expected label: `ОЖИДАЕТ АРТ`.
5. **User visual approval required before activation.** Then enable one role at a time through the existing production SpriteFrames path with static v4 fallback. Run encounters and inspect facing, attack timing, death, crowd readability and floor contact.
6. **Knight is separate backlog:** keep its readable static v4 until a genuinely leg-readable reauthored Knight sheet is approved. Never solve broken geometry by merely nudging Y offsets.

## Next contributor checklist

Start with **Bone Thrall**, because the low feral silhouette best exercises feet and dual-claw readability; then Bellkeeper (prop attachment), Guard (armor weight), Warden (boss scale). This order is an asset-work recommendation, not a gameplay change. First make the four-frame Thrall proof; do not connect any placeholder art to production.
