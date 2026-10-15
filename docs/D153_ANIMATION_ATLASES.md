# D153 — User-approved crimson skeletal puppet-theatre unit animations

Date: 2026-10-15  
Status: **approved redraw assets COMMITTED to main; native Godot five-state gallery user approval PENDING**.

## New deployed atlases

| Role | Active runtime path | decoded WebP bytes | SHA-256 |
| --- | --- | ---: | --- |
| Skeletal puppeteer | `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64` | 44426 | `93f8839a778709f3c144a97eb3bef51e0b16944dc796e7cf9ec690896d23b846` |
| Skeletal marionette | `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64` | 43114 | `eb51e5d13968921bfa4ee4e9adef65c9c1939fb15a91f9e10a1c88e37633c755` |

**Critical history:** The first shipped D153 mini-skeletons (3.5KB and 3.2KB WebP) were rejected by user as visually inconsistent with approved theatre card. New user-approved pixel art was generated for both roles with crimson medieval stage rags and worn brass/bone. User explicitly accepted these visuals («Подходит)»). The initial direct downscale from 1374×1145 to 576×480 was NOT valid: used frames touched borders, unused cells contained image bleed. The assistant subsequently recovered the high-resolution images, segmented the individual nonuniform generated gutters, fit poses inside true 96px cells, cleared detached residue, quantized to a 96-color pixel-art palette, and encoded **lossless WebP** with alpha.

**Technical output and QA:** Each decoded image is exactly **576×480 RGBA**; 6×5 tiles each 96×96. Populated poses per row **4 idle / 6 walk / 6 attack / 3 hit / 6 death = 25**; **all 25 distinct hash values** per role; visible alpha per active cell; >3px transparent outer border per active cell; 5 unused cells completely transparent; no reusing old enemy sprites. Rejected version rollback paths:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames_rejected_v1.webp.b64`
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames_rejected_v1.webp.b64`

This QA is **static only**, not a claim of Godot playback success, silhouette approval at 1280×720 or combat release. The generated source can contain stylized pose continuity errors despite structural tests; user F6 decides.

## User's single next test

`git pull`; F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`; examine at least one full idle/walk/attack/hit/death cycle for both: leg visibility, consistent apparent size, all 25 frames visible, puppet-like movement, source-right attack, no cropped strings, blinking or disconnected visual trash. Send screenshot/feedback.

After signoff, separate theatre combat arena and scoped real battle thread linkage are the next stage. Card remains QA-only / 35 of 45 live.
