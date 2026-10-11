# Misdeal — Unit Animation Pack 2

Status: **Stage A implemented (attack-contact VFX only), frame animation artwork not yet ready.**  
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
