# Misdeal — Unit Animation Pack 1 (2026-10-12)

Status: **Five animated roles connected in the live `BattleUnit` code on `main`; local Godot test pending.**

## Source and format

This pack comes from the five newly generated pixel-art sprite sheets:
- `пиксельный_спрайт_лист_синего_рыцаря.png` → `knight`
- `пиксельный_спрайт_лист_лесного_следопыта.png` → `ranger`
- `пиксельный_атлас_тёмного_мага.png` → `mage` (the approved **male** wizard)
- `пиксельный_спрайт_лист_скелета_воина.png` → `skeleton`
- `пиксельный_спрайт_лист_скелета_лучника.png` → `bone_archer`

Each source is a 6-column × 5-row, 229px-per-cell RGBA grid. The gameplay export is resized to **96×96** pixels per cell and stored as a transparent **576×480 WebP** atlas (Base64 text).

Runtime files:
`assets/pixel/units/combat_units_anim_v1/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`

Rows:
| Row | State | Frames | Speed | Loop |
| --- | --- | --- | --- | --- |
| 0 | `idle` | 4 | 5 fps | Yes |
| 1 | `walk` | 6 | 9 fps | Yes |
| 2 | `attack` | 6 (Mage: 5) | 16 fps (Mage: 14) | No |
| 3 | `hit` | 3 | 12 fps | No |
| 4 | `death` | 6 | 10 fps | No |

Mage's fifth raw attack cell contains a detached projectile rather than the mage. It is **skipped** in the active mage animation. Existing combat trace FX continues to visualize the spell impact. Do **not** blindly play that projectile-only cell as a character frame.

Each atlas only stores authored frames. Remaining empty grid slots are transparent. The 4-frame idle and 3-frame hit have their own explicit counts: do not use all six row columns.

## How it runs

- `scripts/battle/unit_animation_library.gd`: lazily reads the relevant `.webp.b64` file with `FileAccess`, decodes it with `Marshalls.base64_to_raw` / `Image.load_webp_from_buffer`, validates dimensions, builds and caches one `SpriteFrames` Resource per role with `AtlasTexture` tiles.
- `scripts/battle/unit.gd`: keeps the existing `Sprite2D` (`ArtSprite`) because combat attack tweens, hit tint, enemy `flip_h`, scaling, `RimSprite` and the v4 fallback all rely on it. It advances the texture by reading frames from cached `SpriteFrames`; no separate runtime `AnimatedSprite2D` is needed for the battle node.
- State selection: idle while standing/placing; walk after actual combat velocity; attack when a real attack triggers; hit on damage; death on fatal damage. One-shots take precedence over walking/idle until their short duration finishes. Sprite orientation and outline continue following the art texture.
- In the **developer gallery**, actual Godot `AnimatedSprite2D` consumes the same cached `SpriteFrames` directly, confirming that the animation resource is reusable.
- Unsupported roles (`bone_thrall`, `grave_bellkeeper`, `crypt_guard`, `bone_warden`, aliases) and invalid/missing animated atlases fall back to the existing static **v4** miniature and legacy presentation. This is intentional until Pack 2.
- Combat damage timing, cooldowns, hitboxes, AI, unit placements, attack rules, enemy facing and every `.tscn` node layout remain unchanged. The animated dead-unit fade lasts long enough for the fall frames. The existing Sprite2D squash/stretch idle is disabled **only** for these animated roles.

## Local validation gate

1. `git pull`; open `res://scenes/dev/unit_animation_pack1_preview.tscn` and press **F6**.
2. Click **IDLE / WALK / ATTACK / HIT / DEATH**. Inspect all **five** characters at 1280×720, including the male mage and skeleton facing left. Verify no transparent/empty character flash, feet anchored, weapon/robe not clipped, clear alpha edges and Cyrillic labels.
3. In normal gameplay, choose each protagonist and enter an encounter that contains `skeleton` / `bone_archer`. Check pre-fight idle, motion when moving, role-specific attack, hit and collapse.
4. Confirm HP bars/names follow the unit correctly, the outline is synchronized and enemies still face their live target.
5. Confirm unsupported enemy roles stay on v4 and run completion/results remain intact.

The connected GitHub tool can verify committed source/assets but cannot launch local Godot 4.7.x; **do not claim full runtime validation before these checks**.

## Next

Pack 2: bespoke sprites for Grave Bellkeeper, Bone Thrall, Crypt Guard and Bone Warden. After user screenshot review, improve frame alignment, attack contact timing/projectiles and individual collapse effects. Avoid paper-doll/stretch illusions that were previously rejected.
