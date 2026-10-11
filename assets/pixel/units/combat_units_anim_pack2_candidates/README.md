# Pack 2 — animation candidates only

**None of these files are wired into gameplay.** BattleUnit still renders four static v4 enemy sprites and adds only their contact VFX. This directory is intentionally empty of candidates until a real artist or approved generation supplies suitable per-frame pixel art.

Each accepted filename is `<visual_role>.webp.b64` where visual_role is one of:

- `bone_thrall`
- `grave_bellkeeper`
- `crypt_guard`
- `bone_warden`

Each file encodes a **transparent, single-role 576×480 WebP atlas** with 6 columns × 5 rows, 96×96 pixels per cell, row order `idle / walk / attack / hit / death` and active frame counts `4 / 6 / 6 / 3 / 6`. Clear unused grid cells.

**Preferred safe import:** run `python scripts/dev/import_animation_pack2_candidate.py --role bone_thrall --source <96px-grid-RGBA.png> --output-dir assets/pixel/units/combat_units_anim_pack2_candidates` (requires Pillow). The script refuses empty, opaque-background, mismatched or duplicated Walk/Attack artwork, and warns when boots drift above/below y=87..94 or weapons clip cell borders.

**Review:** open `res://scenes/dev/unit_animation_pack2_preview.tscn` with F6. It loads only candidates from this staging folder via `scripts/dev/unit_animation_candidate_validator.gd` and places each next to its existing approved v4 model. Play every state and visually approve separate boots, limbs, shield and grounded death frames before ever enabling an atlas in `unit_animation_library.gd`.

Do not place scene screenshots or pseudo-animation based on scaling a static character here.
