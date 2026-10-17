# D209 — exact user-approved Black Lantern Road forest arena: GitHub import and F6 layout QA

Date: 2026-10-17. State: **ART SOURCE COMMITTED AND SHA-VERIFIED, GODOT F6 VISUAL REVIEW PENDING.** Live Act1: **37/45**. #38 remains QA-only.

## Authoritative original and binary traceability

User selected D204 forest geography A and then explicitly chose the **THIRD rendered forest image**. Original source (conversation file): `лунная_дорога_через_туманный_лес.png` (1672×941 RGB); source SHA-256: `c7aa3d41432e890a41edfc0edcd0cad2bcd6ba93c8713c170082f0562ca4a569`.

The exact selected image was transformed ONLY by a one-pixel-scale centered 16:9 crop and Lanczos resize to **1280×720**, then exported as high-quality WebP, quality 90. No new AI background, elements, lighting or style were substituted. Export WebP SHA-256 `b82a0eb5f88113522fe31371b3cec634a059886fa001fbafb71c0794bad52307` (**170,424 bytes**). Stored in GitHub:

`res://assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64`

Base64 text uses a **single 227,232-character line**, compatible with existing `Marshalls.base64_to_raw(FileAccess.get_file_as_string(...).strip_edges())` loader. GitHub blob SHA `6fad8192e4e2a9baa308db82e0ce84beeeb167ad` was independently computed from source export text and matched the SHA fetched back from `main`. This verifies **identical committed encoded bytes**. It does **not** constitute a Godot texture decoder or visual preview PASS.

`scripts/battle/authored_backdrop.gd` now recognizes arena ID `black_lantern_road` and maps it to that new exact WebP/Base64 art. Existing arena mappings and scene rendering have not been replaced. `battle.gd` still has no #38 light controller connection; no ordinary card routing for #38, no new enemy animation activation.

## New D209 native visual-only preview

Run `res://scenes/dev/black_lantern_road_arena_visual_preview.tscn` (F6). This new scene uses the REAL production `authored_backdrop.gd` decoder to show the selected 1280×720 empty forest. It overlays:

- Three blue **silhouette clearance rectangles** for the party, and five bronze rectangles for the five original enemy roles; first enemy `extinguished_guide` has 175px high silhouette, roughly twice 76px escorts.
- Their foot contact points use the same `Battle._project_spawn_on_floor()` Y conversion plus UnitsLayer offset (20,96) and explicit foot offset (+36), preserving the default real battle bounds (screen X110..1190 / Y380..538).
- Uses the ACTUAL `BlackLanternLightController` pool coordinates, 93px radius, warnings, travelling light and timing, visual-only (controller `running` and `elapsed` set without configuring combatants). Shows warning, active, rest status and a pause control; **no gameplay buffs or actual units are run**. Press `ПОКАЗАТЬ ПОЛ` to display the combat rectangle for collision/readability QA.

QA-only proxy silhouettes are deliberately rectangular, **not** replacement art, stylized "final" characters or evidence that the new five skeletal animations exist. All combat stats and balance timings remain unchanged; the failed +22% D208 experiment was reverted to **1.16** in `cc624e3` before D209 import.

## Native F6 checklist — awaited

1. The **exact previously selected** moonlit forest scene is displayed edge-to-edge, no blank/black background or duplicate castle.
2. Three blue proxy characters occupy road on the left and five bronze skeletal proxies occupy right of road; the tall Guide is clearly ~2× others. Feet remain on grounded surface, no obstacle/foreground collision; large Guide not hidden by upper labels.
3. Two warn-then-move lanternlight circles remain legible *on top of warm highlights baked into the road*; moving circles stay underneath proxy silhouettes and do not cover UI. Warning → active → dark → repeat; pause toggles, floor debug outline toggles.
4. If leg placement/color contrast is off, adjust only this F6 staging and later approved encounter-scoped pool paths; do not force visual art or global movement changes.

The user should `git pull`, F6 **this new scene**, and send a screenshot or simple confirmation. **No native Godot test has been run by the assistant.** Do not mark the arena native PASS until user evidence is received.

## Remaining D210 gates

1. Finalize five truly original 6×5 (25 frames) animation atlases for `extinguished_guide`, `lantern_bearer`, `road_sentinel`, `oil_acolyte`, `lantern_archer`. D205 concept sheets are QC-blocked (source frame clipping; Road Sentinel axe instead of approved spear). Keep ~2× authored Guide, correct weapons/silhouette, visible feet and no source bleed.
2. Add QA-only native animated gallery and test real combat presentation; adjust scoped moving-light mechanics based on visibility/position, not blind global HP inflation.
3. Wire five original enemies, exact forest arena and encounter-only light into actual #38 Battle→Reward→Table; run further seeded fights/smokes and only after approval release #38 to **38/45**.

Preserve DS2, Fate Spread 12+XIII, all 37 previously released cards, D196 Black Crossing waves, and immutable branch `backups/KARAMBA73-2026-10-16`.
