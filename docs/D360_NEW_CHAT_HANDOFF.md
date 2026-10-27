# D360 — «РАССТРЕЛЬНАЯ ПЛОЩАДЬ» handoff (2026-10-27)

## Approved artwork and exact identity

User chose the third D360 scene, changed it to have four undead archers firing at corpses (other fallen skeletons) across the castle square, and explicitly requested a final correction to make arrow shafts straight. The last image is **`скелетный_рыцарь_в_огненном_дворе.png`**, 1536×1024 PNG, SHA256 `b32de7df8d9f9827221301ac977f5b900365e4551ba43490849f18c29d5908fc`. Earlier D360 preliminary Figma 1–3, before the corpses/arrow corrections, are not approved final assets.

Runtime: `res://assets/pixel/card_unification_v1/run/firing_square_d360_approved_straight_arrows.webp`, center crop (0,42)-(1536,981) resized to 448×274 WebP Q86, SHA256 `2d156da95541f8c31131581bb0a986384744c5b8fb1b49482aca745bd4cb6c72`; binary Git blob `0865337d3b76e8db5e744e4b4582b083d5eeeea3`. Exactly one runtime mapping `CardUnificationV1.RUN_CARDS["firing_square"]`; existing .tres art_path remains as fallback. D315 adds SHA256 check and automatic decodable WebP, dimensions, runtime catalog image pixel equality. Total now 28 native-file WebPs plus separate D350 encoded art = **29 approved image locks**.

## Unchanged gameplay

`resources/encounters/firing_square.tres`: one `crypt_sentinel`, four `bone_archer` on `firing_square` arena, unchanged positions and rewards. The skeletal corpses in illustration are environmental narrative context, not newly spawned enemies. No DS3 changes, no changes to earlier art.

## Release and next handoff

Release branch `art/d360-firing-square-approved-straight-arrows`, based on main `d5b1b2b81001cd23c906b1742b655b604da56c73`. Run native Godot 4.7.x CI: import, GUT, D289/D315/D316, screenshot capture. **Do not report CI PASS without checking actual Actions run.** Merge PR only after success. Then user `git pull` and F6 `scenes/dev/d315_card_ds3_gallery.tscn` to inspect «РАССТРЕЛЬНАЯ ПЛОЩАДЬ». Follow up with Act 1 final visual audit and human F5 playtest of 12 resolutions + sealed XIII. The complete A1P3 playtest and standalone release matrix are still pending.
