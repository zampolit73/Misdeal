# Misdeal D184 — unit atlas packaging and next GitHub handoff

## D184 — Black Crossing original sprites: art selected, local atlas QA, GitHub loader staged

Date: 2026-10-15.
User explicitly **approved the combat pair**: Ferryman visual **B (ragged cloak)** and Drowned visual **C (torn clothes)**. They subsequently explicitly approved the generated two stand-alone animation source sheets:
- `пиксельный_спрайт_лист_мрачного_перевозчика.png` (conversation file `file_00000000fa3481f5a8b818d8440c2d9e`; 1374×1145)
- `пиксельный_атлас_болотного_зомби.png` (conversation file `file_0000000041f081f5b835e5e534a0e554`; 1374×1145)
These are **approved artistic source previews**, not production atlases.

**Local repacking performed in this conversation:** isolated source cells and produced `/mnt/data/d183_drowned_ferryman_q36.webp` and `/mnt/data/d183_drowned_hand_q36.webp`, each 576×480, 6×5/96px, containing 25 nonempty/unique visibly padded frames with 5 empty cells, as independently checked after WebP decode. Corresponding local QA contact sheets `/mnt/data/d183_drowned_ferryman_qa.png` and `/mnt/data/d183_drowned_hand_qa.png`. Ferryman source art has **only five attack poses (24 original poses total)** and an oversized last horizontal pole-thrust: one additional distinct, transformed follow-through pose was constructed to meet Godot 4/6/6/3/6 contract. Some source-frame stray boundary fragments from contiguous generated artwork still need visual artist cleanup before claiming shipping-grade fidelity. No claim that all 25 Ferryman poses were independently generated; do not misrepresent as 25 user-drawn original source poses.

**Crucial upload gate:** this assistant environment's connected GitHub actions accept UTF-8 strings / base64 content, not a local `/mnt/data` file pointer, and the prepared high-quality WebP payloads have not been transferred to GitHub. DO NOT claim the rasters are committed, or ask the user to run the F6 gallery until exact runtime `.webp.b64` files are present and fetched back from GitHub. This pass commits the **strict D183 role loader and isolated gallery source** only, so the normal game remains unaffected.

Target runtime paths:
- `assets/pixel/units/deck_expansion_v1/drowned_ferryman_frames.webp.b64`
- `assets/pixel/units/deck_expansion_v1/drowned_hand_frames.webp.b64`

Loader enforces 576×480, 25 visible/padded/distinct poses and 5 empty cells, with no fallback to old undead. Native QA gallery `res://scenes/dev/black_crossing_animation_preview.tscn` must only be run **after** the atlas files are actually in `main`. Status: **candidate art approved; atlas packaging/upload and F6 native QA pending**. Live Act1 stays 36/45; no encounter, arena or waves yet. Do not change D151–D153.

