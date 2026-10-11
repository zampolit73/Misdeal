# Misdeal — Unit Animation Pack 2

Status: **Stage A attack-contact VFX live, Stage B candidate QA/importer + side-by-side F6 review committed; no new frame artwork activated.**  
Date: 2026-10-12

## Scope

After Unit Animation Pack 1 the user approved a readable static v4 Knight and requested the next step. Four other enemies still have only v4 sprite miniatures: `bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`.

**Do not** call their present movement `idle/walk/attack/hit/death` frame animation. We have no authored frame assets yet; simply wobbling or squashing v4 artwork would repeat the user's rejected "rubbery" look.

### Stage A — shipped visual attack cues

`scripts/battle/unit_attack_visuals.gd` provides four tiny, short-lived native `Line2D`/Tween contact accents:

| Role | Contact FX | Life |
| --- | --- | --- |
| `bone_thrall` | paired ocher/bone claw scratches | 0.17–0.21 s |
| `grave_bellkeeper` | green-gold concentric flattened bell wave | 0.27–0.36 s |
| `crypt_guard` | compact bronze crossed heavy-impact scratches | 0.19–0.23 s |
| `bone_warden` | two low red-gold ground rings and a heavy contact slash | 0.19–0.36 s |

`BattleUnit._play_attack_feedback()` calls `ATTACK_VISUALS.spawn(visual_role, get_parent(), primary_target.position)` **only at the real attack trigger**, alongside existing hit/projectile VFX. Damage is still resolved immediately by the existing `_attack_target()`; these animations are an *impact acknowledgment*, NOT a wind-up / warning or a delay to damage. The transient Line2D nodes self-delete. There is no new animation state machine or layout node.

All others roles naturally no-op in the visual helper. Character art, team flip, contact ground ring, boss baseline, HP, AI, cooldown and hitbox data are untouched.

### Local review

1. Run `git pull`; in Godot open `res://scenes/dev/unit_undead_fx_preview.tscn` and press **F6**. Use each **ПОКАЗАТЬ УДАР** button; verify a small, readable, short effect. These are the same real v4 static enemy sprites, rendered via `scenes/battle/unit.tscn`.
2. Play encounters featuring Bone Thrall, Grave Bellkeeper, Crypt Guard and Bone Warden; confirm effects appear at impact, don't flood the floor, and combat hit timing/damage remains the same.
3. Check Main → Table → Battle for no crashes, graphics leaks, opaque UI boxes, misplaced projectiles or changed Knight/Ranger/undead grounding.
4. Godot runtime was not executable in the connector environment; source-level checks cannot substitute for the local F6 smoke.

### Stage B — still to be done

Create **actual distinct 96×96 animation frames**, per role, with quality gates BEFORE switching the live unit:
- Consistent boots/feet/ground contact for every role/state frame; each cell excludes adjacent-row pieces.
- Attack silhouettes recognizable at the full 1280×720 arena view: Bellkeeper bell and staff; Thrall claws; Guard shield/weapon; Warden mass and two legs. Death must read as falling down rather than floating.
- Approved state set `idle/walk/attack/hit/death`, with a safe static v4 fallback.
- Preview/compare each sprite sheet in Godot before enabling it in normal battle.
- Do **not** fabricate these animations via blind scaling/rotating one static source, or treat a full-scene illustration as an animation atlas.
- Later, review a properly legible **animated Knight**; current live Knight should remain static v4 until those new frames are verified.

See `docs/UNIT_ANIMATION_PACK1.md` for the existing reusable `SpriteFrames` export format and grounding lessons.

## Stage B preparation — committed candidate pipeline (2026-10-12)

**Implemented in GitHub, without changing the live battlefield:**

- `scripts/dev/import_animation_pack2_candidate.py` — offline helper to convert an actual 576×480 RGBA PNG into a lossless 6×5 WebP/Base64 Godot resource. This checks 25 occupied cells per role (Idle 4, Walk 6, Attack 6, Hit 3, Death 6). It rejects wrong dimensions, non-alpha or mostly-opaque backgrounds, empty characters, cell-corner overflow and entirely identical Walk/Attack sequences. It warns about contact baseline outside y=87..94 and horizontal clipping. The helper requires Python 3 + Pillow **for asset production only**, not for running Misdeal in Godot. It was exercised locally with a known grounded pack-1 example and with an invalid opaque test sheet (rejected).
- `assets/pixel/units/combat_units_anim_pack2_candidates/README.md` — staged file convention, one character per `{role}.webp.b64`, not included in the game loader. No candidate art is committed yet.
- `scripts/dev/unit_animation_candidate_validator.gd` — pure Godot candidate reader and optional on-demand `SpriteFrames` constructor. Confirms WebP decode/grid dimensions, alpha presence through active pixels, frame variety, visible baseline and avoids enabling corrupt/empty sprites. Returns structured warnings/errors to review UI. Never called from real `BattleUnit`.
- `scripts/dev/unit_animation_pack2_preview.gd` + `scenes/dev/unit_animation_pack2_preview.tscn` — an F6 review screen showing the **existing, approved v4 static unit** alongside any staged candidate. Each of the five state buttons controls candidate animations only. If a candidate doesn't exist, it explicitly displays `ОЖИДАЕТ АРТ`, rather than using blank/duplicate art in battle.

This is a production-ready review workflow, **not a declaration that any of the four enemies already have new animated frames**. Attempts at generating art in the current environment produced battle-scene screenshots instead of valid sprite sheets; those images were excluded from the repository. A secondary image-generation account had insufficient credits. The remaining next step is genuinely authored 25-cell art per role, with distinct leg and weapon silhouettes and manual visual comparison.

**Proposed candidate flow** (asset work, not part of game installation):

```bash
python scripts/dev/import_animation_pack2_candidate.py \
  --role grave_bellkeeper \
  --source path/to/grave_bellkeeper_rgba_576x480.png \
  --output-dir assets/pixel/units/combat_units_anim_pack2_candidates
```

Once a real frame sheet is staged, open `res://scenes/dev/unit_animation_pack2_preview.tscn` with F6 and cycle through each animation; inspect image quality in Godot at full arena scale. After explicit visual approval, add the role to production `MisdealUnitAnimationLibrary` with a strict missing/invalid-sheet v4 fallback and preserve the existing combat/facing/HP logic. Do not accept the importer alone as evidence of silhouette quality: two separate boots, held shields, weapons and death-ground contact require human review.
