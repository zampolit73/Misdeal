# D401 — C3 class-weapon continuity: Knight sword / Ranger bow

Date: 2026-11-06.

## Evidence and diagnosis

Player sent `00-33-27.mp4` (1920×1080 desktop, 205 video frames, 14.37s). A windowed Godot 1280×720 C3 F6 comparison cycles IDLE / WALK / ATTACK / HIT / DEATH. D399 viewport scaling is working: all 3 role pairs and AUTO are visible. **This is not recorded F5 combat.** A video frame alone cannot prove actor hit timing or smoothness.

Comparing the actual live D400 transparent atlases frame by frame confirms **two objective character-identity failures missed by the prior technical alpha and cel-count tests**:

- Knight C3 attack row 2, columns 2 and 3: previously a broad axe/halberd appears instead of the approved **sword** (shield also becomes obscured through some attack poses and still needs a later original-drawing pass). Video shows this transformation during the attack sequence.
- Ranger C3 attack row 2, column 5: bow disappears entirely during the release pose, leaving an empty weapon hand. The approved Ranger must hold his bow throughout the attack.
- Mage C3: cloth/staff and spell glow continuity remains subject to subjective motion review, but there is no comparable confirmed change needed in this limited patch.

The generated C3 storyboard with Cyrillic labels/UI was **not imported** for this fix; those designs are not valid transparent sprite atlases.

## Actual implementation

- `assets/pixel/units/hero_c3_d401/{knight,ranger,mage}.webp.b64`: independent, versioned 576×480 RGBA WebP 6×5 atlases, with 25 distinct posed cels (idle4 / walk6 / attack6 / hit3 / death6), five truly alpha-clear spare cells.
- The existing Knight C3 body, burgundy torn cape and combat pose were preserved; only the broad inappropriate axe geometry in two attack cels was removed and replaced with a **tapered steel sword and simple hilt** following the established hand direction. This is a focused 96px source-art retouch, **not 25 newly drawn poses**. Shield visibility in fast intermediate frames may still need genuine reauthoring.
- The Ranger's bow was transplanted from his **own previous C3 drawn attack cel** into the final release pose, aligned near the extended hand. Ranger clothes and body pixels are otherwise retained, with the olive cloak intact.
- Mage bytes are EXACTLY copied from D400; the Mage's violet outfit/staff and existing magic are unchanged.
- `MisdealUnitAnimationLibrary.C3_HERO_PILOT_DIR` now points to `hero_c3_d401/`; D398 and D400 atlases and v2 originals remain tracked and callable for rollback. The existing fallback on invalid C3 image stays enabled.
- `tests/unit/test_d401_c3_weapon_identity.gd`: check 3 full valid C3 atlases, source archive survival, Knight broad blade region reduction with sword still present, Ranger bow returning to specific upper-right frame region and identical Mage base64. Historical D400 connectivity test now reads D400 archived files explicitly rather than assuming it is the active directory.

No gameplay stats, weapon damage, AI, aim, VFX logic, hitbox, waves, DS3, Fate Spread XII+XIII or sound changed. This only affects art in C3 attacking animations.

## Native check after CI merge

1. Run `git -c gc.auto=0 pull --ff-only origin main`.
2. F6 `res://scenes/dev/d398_c3_hero_animation_preview.tscn`, now labelled D401; click **ATTACK** and inspect Knight two middle attack poses and Ranger final release frame, then **AUTO** to view state transitions.
3. Optionally F5 a real encounter with Knight and Ranger to assess attacks at the actual combat scale.
4. If the edited 96px sword still looks pasted rather than physically grasped, or shield disappears too abruptly, refine the **original illustrated keyposes** rather than creating arbitrary duplicate/warped frames.
5. Do not call animation production-final from Godot parser/GUT green alone. Mage motion and full F5 party battle remain open QA.

**No approval request per individual frame.** This is a direct art-error correction based on user footage, while preserving previously accepted C3 character identity.
