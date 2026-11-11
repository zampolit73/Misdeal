# Cinematic Travel Scene03 — The Last Dressing Station

Implemented for local artistic review, **not** claimed finally approved. The supplied composition is approved; the animated in-game staging still needs the user's F6 review.

## Source and production

Exact supplied 1672×941 PNG: `assets/pixel/travel/last_dressing_station/approved_reference.png`, SHA256 `3c7b2626b2028b156cc6556a8ab148721e2987763ceda451e5d38a28ca47a34d`. Original file is byte-identical. The package brief is retained in [requests](requests/2026-11-11-travel-scene03.md).

`scripts/dev/pack_dressing_station_assets.gd` deterministically copies original pixels through source-space alpha masks, cropping transparent bounds into `layers.json`. Four retained built-in image_gen edits supply plain lower cloth, cut upper banner, resting-scissors repair and a hidden occlusion underpaint. Only the specified cloth/tool masks are copied from the first three edits, never generated faces, bodies, beds or masonry. Original intact heraldry remains unchanged. Prompt descriptions, generator IDs and file SHA256s are in the adjacent `provenance.json` and `prompts.md`.

The lower embroidered cloth becomes plain offcuts in all three outcomes, so the upper hanging standard is the one canonical ceremonial banner. Other existing flags/shield heraldry belong to the ruined garrison, not a second last standard. No new military or medical symbols are added.

Repack from committed inputs:

```text
godot --headless --path . --script res://scripts/dev/pack_dressing_station_assets.gd
```

Five planes: Sky, DistantBattlefield, unified Midground/DressingStation, Road and Foreground, at0.2 /0.8 /4 /10 /14 screen px/s. The station, connected arches, linen and inner apertures are one full-height original-pixel plate per outcome. The former opening mask contained real cloth/stone pixels; moving it at sky speed tore them from the arch. It and the split fortification/arch cutouts are retained for rollback but no longer rendered separately. Both cloth/prop shader regions run on the unified texture. Finite overscan, hidden underpaint, restrained V2 fog and lamp modulation remain; no new audio, artwork, character route or outcome logic.

## Reactions and integration

`travel_catalog.gd::LOCATIONS` maps only `banner_seamstress` to `resources/travel/last_dressing_station.tres`. Posthouse and other card routes retain their previous resources. Existing four-second overlay, 360ms entrance, narrative reader, pause, skip, feature flag, missing-resource fallback, router/under-veil disposal and save contracts remain in charge.

- `bandages`: three ragged strips replace the intact upper banner, extra existing-source bandage rolls sit at the bench, lower offcuts move subtly, and exactly one source-cloth scrap drifts down and settles beside the road.
- `standard`: original upper banner stays intact with anchored subtle cloth motion; scissors are removed locally from the hands and placed on the bench using the original tool cutout. No new bandage rolls.
- `passed`: original scissors and seated figures remain; tiny blade, cloth and light movements suggest the repetitive work. No animated arms, face warping or moving skeleton.

This is presentation only. The existing `final_five_events.gd` continues to apply +12 HP/−0.5 damage, −6 HP/+0.75 damage, or no change once. Travel writes no gameplay fields or rewards and retains every existing narration string and event-choice painting.

## Party calibration

The user superseded the horizontal staging: Scene03 now uses a three-quarter REAR walk along the marked road, away from the camera/up-left. The battle D412 atlases remain byte-identical; separate six-pose96px strips for Knight/Ranger/Mage live in `rear_walk/`, with the exact generation prompt, input hashes and reproducible packer. No fake rotation/mirroring of side-view sprites.

One Scene03-only `stage_party` hook supplies the existing actors/contacts from the existing V2 local clock. Projection is `vanishing + (near - vanishing)/depth`, near(1140,486) from the resource, vanishing(850,360), depth advancing1.12 over the four-second presentation and0.32 intervals between members. Small lane offsets shrink with the same reciprocal depth. Sprite scale1.5/depth, actual rear-pose boot soles, shrinking shadows/dust and at most28% colour haze share that depth; alpha stays opaque and texture filtering stays nearest, without blur. Road-plane displacement is included in foot contacts. Nearer feet draw in front while the original foreground remains above them. Solo starts slightly farther down the same route.

The optional hook is absent from both older panoramas, whose horizontal movement and D412 frame/sole caches stay unchanged. Contact FX defaults remain scale1 and leftward dust, reproducing old scenes. No new router/manager, timing, event state, panorama plane or game effect.


## Verification and limits

Native Godot4.7.2 / NVIDIA GL Compatibility / 1280×720 at1×: one full pass of each outcome; trio and solo; pause freezes the local clock; skip and natural ending work. Actual production `act_choice` button → Scene03 → Table verified, double Continue/Skip safe, +12/−0.5 applied once. Import/parsing clean. Full GUT288/288 (19 existing warnings); focused new scene3/3,60 assertions. CI selector18/18. Required PR CI must pass before merge.

The combined production-route smoke reports existing shutdown ObjectDB/RefCounted diagnostics also present in the preceding travel route fixture; no claim of global leak-free shutdown. No script/load/assertion errors in the native pass. No new QA framework or large matrix. [Five native frames](qa/dressing_station/README.md) and the same compact smoke run are included in existing RELEASE CI artifacts.

## F6

Open `scenes/dev/dressing_station_playtest.tscn`, F6. Q=bandages, W=standard, E=passed; 1=Knight,2=Ranger+Mage,3=trio; P=pause,R=replay; Space/Enter/Esc/button=skip/replay. Preview does not read/write a run. F5: finish «Знамя на бинты», continue from its normal result, review the corresponding aftermath and return to Table. Final scale, cloth and composition acceptance belongs to the user.
