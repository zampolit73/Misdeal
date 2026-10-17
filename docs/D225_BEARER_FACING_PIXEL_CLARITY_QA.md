# D225 — Lantern Bearer D224: two-way sprite orientation and honest pixel-clarity QA

Date: 2026-10-17. **SOURCE STAGED IN GITHUB, NEW BUTTONS NATIVE GODOT F6 PENDING.** Live Act1 stays **37/45**, #38 QA-only; no production character, UnitData or Battle code switched.

## User evidence and intent

User attached a native Godot screenshot of `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn` with correctly loaded selected D209 forest, two views of the approved D224 Bearer: enlarged **×3** plus **×1 combat scale**, in a shield-attack animation and **no red error**. This confirms the D224 scene runs and the chosen art loads. It does **NOT** confirm the whole five-state animation QA, valid feet/attacks/death in both directions, or #38 production acceptance.

The user asked **«Анимация работает в обе стороны или только 1?»**. Investigation confirmed the D224 gallery previously displayed both views with the **same source orientation**; one image was simply scaled. The actual `scripts/battle/unit.gd::_set_facing_left` and `_update_unit_facing` have ordinary target-based `art_sprite.flip_h` (for new roles absent from old-left-authored exceptions), but the D224 gallery itself lacked a toggle. User replied **«хорошо»** agreeing to the proposed fix.

## D225 source changes (QA gallery only)

Modified ONLY `scripts/dev/black_lantern_bearer_d224_art_preview.gd`:

- Added real functional `← ВЛЕВО` and `ВПРАВО →` buttons, top left of the gallery above the enlarged preview; both button states remain synchronized.
- The **same selected 25 authored frames** are mirrored on both enlarged and native-size `AnimatedSprite2D` views through `flip_h`. Initial gallery orientation is **enemy facing LEFT toward the heroes**; click right to mirror, click left to restore. This is a flip of one atlas, **not another distinct set of frames or a gameplay movement simulation**.
- State label now includes chosen direction for each of the five animation buttons, including the longer hit/death names; wider/smaller label avoids clipping.
- Positions are aligned to integer coordinates; both sprites already had `TEXTURE_FILTER_NEAREST`, which is retained. No source art/atlas resampling was performed here.
- Updated status in the gallery: D224 native scene has been seen running, but **both-direction five-state F6 confirmation is still pending**.

## Important pixel-art clarity diagnosis

User screenshot showed somewhat **soft/overdetailed** contour at ×3. Code already uses `CanvasItem.TEXTURE_FILTER_NEAREST` and an integer ×3 display scale, so simply changing to NEAREST is not a cure. The D224 576×480 WebP QA candidate was cut and **downsized from the user-approved larger 1374×1145 source**, with source seam overlap; fine source detail is baked into 96px cells (see D224 authoring/QC docs). Mirroring cannot restore detail. **Do NOT silently run sharpening, alter pixel palette, regenerate source, or present a filtered image as the approved one.** After user F6 confirms orientation, polish source true pixel-density/individual cel separation preserving original approved style B, then re-check native motion before registering into production `MisdealUnitAnimationLibrary`.

## 2026-10-17 user-reported D225 facing preview OK

User replied **«все ок. давай дальше»** after being asked to F6 the D224 scene's left/right mirroring. Mark **D225 dual-facing preview USER-REPORTED PASS**. This does not establish all animations' final visual polish, exact real Battle enemy orientation or reward route acceptance. D226 next proceeds to separate spear Sentinel native pixel/role art QA.

## Historical user action (completed at user-report level)

1. `git pull`.
2. Godot F6 `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`.
3. Click **«← ВЛЕВО» / «ВПРАВО →»** during `walk`, `attack`, `death`, and, if practical, idle/hit. Confirm **both** enlarged and ×1 mirrored views change and equipment doesn't jump or disappear. Note flip is visual, not actor walking through world.
4. Share one screenshot/«всё ок» or specific source artifact to fix. This closes **two-way gallery** QA only; **not** full real Battle/light or polished final art.

Existing accepted D224 illustration/source preserved exactly, D209 arena untouched; D221 armored spear sentinel approval and D200 card art remain. Frozen `backups/KARAMBA73-2026-10-16` untouched.
