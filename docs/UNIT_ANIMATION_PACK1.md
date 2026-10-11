# Misdeal — Unit Animation Pack 1 (2026-10-12)

Status: **Four roles actively animated in battle; Knight intentionally uses readable static v4 art until redraw. All five animation v2 atlases preserved. Local Godot check pending.**

## Source and format

This pack comes from the five newly generated pixel-art sprite sheets:
- `пиксельный_спрайт_лист_синего_рыцаря.png` → `knight`
- `пиксельный_спрайт_лист_лесного_следопыта.png` → `ranger`
- `пиксельный_атлас_тёмного_мага.png` → `mage` (the approved **male** wizard)
- `пиксельный_спрайт_лист_скелета_воина.png` → `skeleton`
- `пиксельный_спрайт_лист_скелета_лучника.png` → `bone_archer`

Each source is a 6-column × 5-row, 229px-per-cell RGBA grid. The gameplay export is resized to **96×96** pixels per cell and stored as a transparent **576×480 WebP** atlas (Base64 text).

Runtime files (current, cleaned):
`assets/pixel/units/combat_units_anim_v2/{knight,ranger,mage,skeleton,bone_archer}.webp.b64`

The original `combat_units_anim_v1` assets stay untouched in GitHub for rollback.

Rows:
| Row | State | Frames | Speed | Loop |
| --- | --- | --- | --- | --- |
| 0 | `idle` | 4 | 2.7 fps | Yes |
| 1 | `walk` | 6 | 7 fps | Yes |
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

## Grounding / start-motion repair (2026-10-12, user screenshots)

**Observed:** Knight and skeleton animations occasionally appear to have severed/hovering body fragments; some feet are buried or hovering above the stone floor. The first moments of idle/walk feel abrupt. This was traced to frame data and the old loader's movement transitions, **not** the arena art, collision/range or encounter spawns.

**Source repair:** inspected original 96px decoded atlas cells. The generated source sheets have characters crossing row boundaries: e.g. the **first four Knight walking cells contain detached legs from the previous idle row at y=0–16**. Similar small detached border components occur in several enemy rows. The v2 script strips disconnected alpha components confined to the top 18px of a frame, keeps main sprites/weapons intact, and vertically moves each cleaned frame so its final nontransparent contact pixel sits at **y=92**. This applies to idle/walk/attack/hit/death and prevents a collapsing corpse from floating when the source death frame was higher within the cell.

**Live baseline:** the floor ring/contact shadow is positioned at local y=36 in `BattleUnit._draw()`. `_art_rest_position()` calculates each animated sprite origin from the v2 y=92.5 sole and actual `base_sprite_scale.y` (including per-role visual scaling) so the visible boots meet that same ring. Static v4 art keeps its prior position. Attack tweens now return to the same grounded animated rest position instead of switching back to the old -16px constant.

**Start cadence:** idle reduced from 5 to **2.7fps**, walk from 9 to **7fps**, idle starts with a small per-unit random phase, and a **180ms walk-state hold** prevents rapid switching between idle/walk when a unit is being separated from allies or pressed against a boundary. Non-animated units, hit/attack timing, AI, action cooldowns and combat damage remain unchanged.

**Local checks after `git pull`:**
1. Test **Костяной рой** and **Засада на кладбище**, initially **before** pressing Fight: no stray legs floating above the Knight, no synchronized violent idle jumps, feet rest on shadow/ground.
2. Drag solo, duo and trio heroes: characters stay grounded after dragging, the HP label/selection target positions remain unaffected.
3. Press Fight: test units approaching each other, stopping at attack distance and moving at arena boundaries, with no idle↔walk flutter.
4. Test Knight sword attack, male Mage spell, both skeleton types' attack and death frames: corpses should collapse down *onto* the floor, not hang above it.
5. Run `scenes/dev/unit_animation_pack1_preview.tscn` (F6) for 5 states / 5 roles. Engine runtime was **not** available in this GitHub connector session; report any Godot parse/import issue for direct GitHub fixing.

**Rollback:** point `BASE_DIR` in `scripts/battle/unit_animation_library.gd` back to `combat_units_anim_v1/` if absolutely necessary, and restore original BattleUnit rest offsets. Do **not** delete the v1 archives.

## Knight leg silhouette — live static-v4 fallback (2026-10-12)

After multiple gameplay checks showed the Pack 1 Knight's boots were still obscured even when lifted by -16px, live `BattleUnit` now explicitly skips `get_frames("knight")` and loads the **existing v4 Knight tile (0,0)** through `_get_art_texture()`. This sprite has independent recognizable legs and a better shield/boot separation. Its source tile has visible boot alpha reaching approximately y=94 of a 96px cell. `ROLE_FLOOR_OFFSETS["knight"]` is reset to **-8px** for static art; the former -16px was a workaround for animated frames and is not used.

In live combat `ranger`, `mage`, `skeleton` and `bone_archer` still run the full five-state `SpriteFrames` animation set. Their Base64 WebP files and speeds are unchanged. The animated Knight v1/v2 files are **still available** and the optional F6 animation gallery **still demonstrates that archived animation**; the gallery is not a preview of current live Knight artwork. Battle Knight retains standard attack/hit idle feedback via existing Sprite2D tweens, team facing, UI, movement and combat stats.

**Local review:** `git pull` and check Bone Swarm / Grave Crossroads before the Fight button and during strikes. Confirm two separately visible Knight legs/boots, sprite-to-ring grounding and no clipping under the name label. Inspect the other four animated roles for regressions. A future Knight animation sheet requires visibly separate shins/boots, restrained shield and cloak, stable baseline in every state, and real Godot screenshot approval **before re-enabling animation**. Do not attempt to restore leg readability by only increasing vertical offsets.

