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

Seven planes: Sky, DistantBattlefield, RuinedFortifications, GothicArches, Midground/DressingStation, Road and Foreground. Speeds are 0.2 / 0.8 / 1.4 / 4 / 4 / 10 / 14 screen px/s. Connected arches and station deliberately move together, preserving stone/bed seams. Original sky apertures sit over the hidden reconstruction. Finite overscan, no wrapping or new battle activity. Existing restrained V2 fog lies behind the station; lamp modulation is about 1.5%. No new audio.

## Reactions and integration

`travel_catalog.gd::LOCATIONS` maps only `banner_seamstress` to `resources/travel/last_dressing_station.tres`. Posthouse and other card routes retain their previous resources. Existing four-second overlay, 360ms entrance, narrative reader, pause, skip, feature flag, missing-resource fallback, router/under-veil disposal and save contracts remain in charge.

- `bandages`: three ragged strips replace the intact upper banner, extra existing-source bandage rolls sit at the bench, lower offcuts move subtly, and exactly one source-cloth scrap drifts down and settles beside the road.
- `standard`: original upper banner stays intact with anchored subtle cloth motion; scissors are removed locally from the hands and placed on the bench using the original tool cutout. No new bandage rolls.
- `passed`: original scissors and seated figures remain; tiny blade, cloth and light movements suggest the repetitive work. No animated arms, face warping or moving skeleton.

This is presentation only. The existing `final_five_events.gd` continues to apply +12 HP/−0.5 damage, −6 HP/+0.75 damage, or no change once. Travel writes no gameplay fields or rewards and retains every existing narration string and event-choice painting.

## Party calibration

Unchanged D412 atlases/walk poses and existing sole measurements, contact shadows and dust. Resource-local scale1.85, origin(1015,610), spacing175 and depth step4 place the actual solo/duo/trio on the right foreground road. Scale was chosen against the seated seamstress/captain and near cot, not copied from Posthouse. A small optional `party_solo_offset` parameter replaces the previous hardcoded60px; its default remains60 for all old resources, while this scene uses−25 to keep a solo hero clear of the close wheel. No old scene's placement changes.

## Verification and limits

Native Godot4.7.2 / NVIDIA GL Compatibility / 1280×720 at1×: one full pass of each outcome; trio and solo; pause freezes the local clock; skip and natural ending work. Actual production `act_choice` button → Scene03 → Table verified, double Continue/Skip safe, +12/−0.5 applied once. Import/parsing clean. Full GUT288/288 (19 existing warnings); focused new scene3/3,60 assertions. CI selector18/18. Required PR CI must pass before merge.

The combined production-route smoke reports existing shutdown ObjectDB/RefCounted diagnostics also present in the preceding travel route fixture; no claim of global leak-free shutdown. No script/load/assertion errors in the native pass. No new QA framework or large matrix. [Five native frames](qa/dressing_station/README.md) and the same compact smoke run are included in existing RELEASE CI artifacts.

## F6

Open `scenes/dev/dressing_station_playtest.tscn`, F6. Q=bandages, W=standard, E=passed; 1=Knight,2=Ranger+Mage,3=trio; P=pause,R=replay; Space/Enter/Esc/button=skip/replay. Preview does not read/write a run. F5: finish «Знамя на бинты», continue from its normal result, review the corresponding aftermath and return to Table. Final scale, cloth and composition acceptance belongs to the user.
